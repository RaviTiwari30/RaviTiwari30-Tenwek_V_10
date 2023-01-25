using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_IPD_OrderSet_Nursing_OrderSet_SurgeryProcedure : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["ID"] != null)
            {
                string OrderSetID = Request.QueryString["ID"].ToString();
                ViewState["ID"] = OrderSetID;
                string TID = Request.QueryString["TID"].ToString();
                ViewState["TransID"] = TID;
                string Groupid = Request.QueryString["GroupID"].ToString();
                ViewState["GroupID"] = Groupid;
                ViewState["Relational_ID"] = Request.QueryString["RelationalID"].ToString();
                BindSurgery();
                Bindpatientsurgery();

            }
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        //if (grdItemDetails.Rows.Count == 0)
        //{
        //    lblMsg.Text = "Please Select Surgery Detail";


        //}
        if (SaveData() !=string.Empty)
        {

            grdItemDetails.DataSource = null;
            grdItemDetails.DataBind();
            ViewState.Remove("dtSurgeryDetail");
            Bindpatientsurgery();
            //lblMsg.Text = "Record Saved Successfully";
        }
        
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

        }
    }
    private string SaveData()
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        if (ViewState["dtSurgeryDetail"] != null)
        {
            try
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM nursing_ordersetsurgery WHERE TransactionID ='" + ViewState["TransID"].ToString() + "'and GroupID='" + ViewState["GroupID"].ToString() + "' and RelationalID=" + ViewState["Relational_ID"].ToString() + "");
                DataTable dt1 = ViewState["dtSurgeryDetail"] as DataTable;



                for (int i = 0; i < dt1.Rows.Count; i++)
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO nursing_ordersetsurgery (TransactionID,GroupID,surgeryid,surgeryname,qty,OrderSetID,RelationalID) VALUES('" + ViewState["TransID"].ToString() + "','" + ViewState["GroupID"].ToString() + "','" + dt1.Rows[i]["surgeryid"] + "','" + dt1.Rows[i]["SurgeryName"] + "','" + dt1.Rows[i]["Qty"] + "','" + ViewState["ID"].ToString() + "'," + ViewState["Relational_ID"].ToString() + ")");

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

        else
        {
            try
            {

                int numberOfRecords = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM nursing_ordersetsurgery WHERE TransactionID ='" + ViewState["TransID"].ToString() + "'and GroupID='" + ViewState["GroupID"].ToString() + "' and RelationalID=" + ViewState["Relational_ID"].ToString() + "");

                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                if (numberOfRecords > 1)
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
                else
                    lblMsg.Text = "Please Select Surgery Detail";
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
    protected void BindSurgery()
    {
        try
        {
            DataTable dtSurgery = AllLoadData_OPD.GetSurgery(txtSurgeryCode.Text, txtWord.Text);
            lstSurgery.DataSource = dtSurgery;
            lstSurgery.DataTextField = "NAME";
            lstSurgery.DataValueField = "Surgery_ID";
            lstSurgery.DataBind();
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    private void Bindpatientsurgery()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("select surgeryid,surgeryname,qty from nursing_ordersetsurgery where TransactionID='" + ViewState["TransID"].ToString() + "' and GroupID=" + ViewState["GroupID"].ToString() + " and RelationalID=" + ViewState["Relational_ID"] + "");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdItemDetails.DataSource = dt;
            grdItemDetails.DataBind();
            ViewState.Add("dtSurgeryDetail", dt);
        }
    }
    //protected void btnWord_Click(object sender, EventArgs e)
    //{
    //    BindSurgery();
    //}
    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        if (lstSurgery.SelectedIndex >= 0)
        {
            bool isTrue = false;
            isTrue = validation();
            if (isTrue)
            {
                lblMsg.Text = "";
                DataTable dtSurgeryDetail = ViewState["dtSurgeryDetail"] as DataTable;
                if (dtSurgeryDetail == null)
                {
                    GetD();
                    dtSurgeryDetail = ViewState["dtSurgeryDetail"] as DataTable;
                }

                DataRow row = dtSurgeryDetail.NewRow();
                row["SurgeryID"] = lstSurgery.SelectedItem.Value;
                row["SurgeryName"] = lstSurgery.SelectedItem.Text.Split('#')[1].Trim();
                row["Qty"] = "1";
                dtSurgeryDetail.Rows.Add(row);
                grdItemDetails.DataSource = dtSurgeryDetail;
                grdItemDetails.DataBind();

                //lblMsg.Text = "Surgery Added Successfully";

            }
        }
        else
        {
            lblMsg.Text = "Select Item";
        }
    }
    private bool validation()
    {
        DataTable dtItem = new DataTable();
        // Bindpatientsurgery();
        if (ViewState["dtSurgeryDetail"] != null)
        {

            dtItem = (DataTable)ViewState["dtSurgeryDetail"];

            if (dtItem != null && dtItem.Rows.Count > 0)
            {

                string SurgeryID = lstSurgery.SelectedValue.Split('#')[0].ToString();

                foreach (DataRow drItem in dtItem.Rows)
                {
                    if (SurgeryID == drItem["SurgeryID"].ToString())
                    {
                        lblMsg.Text = "Surgery Already Added";

                        return false;
                    }
                }
            }
            dtItem = GetD();
            ViewState.Add("dtSurgeryDetail", dtItem);
            grdItemDetails.DataSource = dtItem;
            grdItemDetails.DataBind();

        }


        return true;

    }
    private DataTable GetD()
    {
        if (ViewState["dtSurgeryDetail"] != null)
        {
            return (DataTable)ViewState["dtSurgeryDetail"];
        }
        else
        {
            DataTable dt = new DataTable();
            dt.Columns.Add(new DataColumn("SurgeryID"));
            dt.Columns.Add(new DataColumn("SurgeryName"));
            dt.Columns.Add(new DataColumn("Qty"));
            ViewState["dtSurgeryDetail"] = dt;
            return dt;
        }

    }
    protected void grdItemDetails_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);
            DataTable dtItem = (DataTable)ViewState["dtSurgeryDetail"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            grdItemDetails.DataSource = dtItem;
            grdItemDetails.DataBind();
            ViewState["dtSurgeryDetail"] = dtItem;
           // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM03','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void btnWord_Click1(object sender, EventArgs e)
    {
        BindSurgery();
    }
}