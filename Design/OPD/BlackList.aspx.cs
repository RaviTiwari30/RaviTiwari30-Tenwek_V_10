using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_BlackList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            dgGrid.Visible = false;
        }
        ucFromDate.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        string PID = txtUHID.Text.Trim();
        string contact = txtContactNumber.Text.Trim();
        string IPD = txtIPDNumber.Text.Trim();
        string receipt = txtReceiptNum.Text.Trim();
        string bill = txtBillNumber.Text.Trim();
        string pname = txtPName.Text.Trim();

        DataTable dtt = new DataTable();

        if (IPD != "")
        {
            dtt = StockReports.GetDataTable("SELECT PatientID FROM patient_medical_history  WHERE TYPE='IPD' AND TransactionID='" + IPD + "'");
            PID = dtt.Rows[0]["PatientID"].ToString();
        }
        else if (rblCon.SelectedValue == "1")//bill
        {
            if (PID == "" && pname == "" && bill != "")
            {
                dtt = StockReports.GetDataTable("SELECT PatientID FROM f_ledgertransaction WHERE BillNo='" + bill + "'");
                PID = dtt.Rows[0]["PatientID"].ToString();
            }
        }
        else if (rblCon.SelectedValue == "2")//Receipt
        {
            if (PID == "" && pname == "" && receipt != "")
            {
                dtt = StockReports.GetDataTable("SELECT Depositor FROM f_reciept WHERE ReceiptNo='" + receipt + "'");
                PID = dtt.Rows[0]["Depositor"].ToString();
            }
        }

        // sb.Append("SELECT 'false' Save, PatientID,CONCAT(Title,' ',PName)AS Pname,Gender,Age,Mobile,House_No FROM patient_master WHERE Location='L'  ");

        sb.Append(" SELECT IFNULL(B.`Id`,0) AS ID, IF(b.id IS NULL,'true', 'false') Save,IFNULL(DATE_FORMAT(IFNULL(b.`ActualStartDate`,b.StartDate),'%d-%b-%Y'),'')  AS ActualStartDate,IFNULL(DATE_FORMAT(b.`StartDate`,'%d-%b-%Y'),'')  AS StartDate,IFNULL(b.`Reason`,'') AS Reason, pm.PatientID,CONCAT(pm.Title,' ',pm.PName)AS Pname,pm.Gender,pm.Age,pm.Mobile,pm.House_No FROM patient_master pm LEFT JOIN blacklist b ON b.`PatientID`=pm.`PatientID` AND b.`IsBlackList`=1 AND b.`CentreID`=" + Session["CentreID"].ToString() + " WHERE pm.`Active`=1 AND pm.`PatientID`<>'CASH002' ");


        if (contact != "")
        {
            sb.Append(" AND pm.Mobile='" + contact + "' ");
        }
        if (PID != "")
        {
            sb.Append(" AND pm.PatientID='" + PID + "' ");
        }
        if (pname != "")
        {
            sb.Append(" AND pm.PFirstName LIKE '%" + pname + "%' ");
        }

        sb.Append("  GROUP BY pm.`PatientID` order by pm.PName ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            dgGrid.DataSource = dt;
            dgGrid.DataBind();
            dgGrid.Visible = true;
            //  lblMsg.Visible = false;
            btnSave.Visible = true;
            btnUpdate.Visible = false;
        }
        else
        {
            dgGrid.DataSource = null;
            dgGrid.Visible = false;
            // lblMsg.Visible = true;
            lblMsg.Text = "Record not found";
            btnSave.Visible = false;
            btnUpdate.Visible = false;
        }
    }
    protected void dgGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction objTran = con.BeginTransaction(IsolationLevel.ReadCommitted);

        if (e.CommandName == "Remove")
        {
            string ID = Util.GetString(e.CommandArgument);
            string str = "UPDATE BlackList SET IsBlackList=0,UpdatedBy='" + Util.GetString(Session["ID"].ToString()) + "',UpdatedDateTime=NOW() WHERE ID='" + ID + "' ";
            // MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);
            StockReports.ExecuteDML(str);
            btnSearch_Click(this, new EventArgs());
        }
        else if (e.CommandName == "Edit")
        {
            lblMsg.Text = "";
            string ID = Util.GetString(e.CommandArgument);

            btnUpdate.Visible = false;
            DataTable dtData = StockReports.GetDataTable(" SELECT b.`Id`, b.`Reason`,b.`StartDate` FROM BlackList b WHERE b.`ID`='" + ID + "' ");
            if (dtData != null && dtData.Rows.Count > 0)
            {
                ucFromDate.Text = Util.GetDateTime(dtData.Rows[0]["StartDate"].ToString()).ToString("dd-MMM-yyyy");
                txtReason.Text = dtData.Rows[0]["Reason"].ToString();
                btnUpdate.Visible = true;
                btnSave.Visible = false;
                ViewState["ID"] = dtData.Rows[0]["Id"].ToString();
            }
            else
            {
                // lblMsg.Visible = true;
                lblMsg.Text = "Patient is not Blacklisted..";
            }
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        //foreach (GridViewRow gr in dgGrid.Rows)
        //{
        //    if (((CheckBox)gr.FindControl("chkSelect")).Checked)
        //    { 

        //    }
        //}

        lblMsg.Text = "";
        DataTable dtItem = getItemDT();

        int count = 0;
        for (int i = 0; i < dgGrid.Rows.Count; i++)
        {
            if (((CheckBox)dgGrid.Rows[i].FindControl("chkSelect")).Checked)
            {

                DataRow dr = dtItem.NewRow();
                string uhid = ((Label)dgGrid.Rows[i].FindControl("lblUHID")).Text.Trim();
                dr["PatientID"] = uhid;
                dr["Reason"] = Util.GetString(txtReason.Text.Trim());
                dr["StartDate"] = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
                dr["IsBlackList"] = 1;
                dr["CentreID"] = Session["CentreID"].ToString();
                dr["EntryBy"] = Util.GetString(Session["ID"].ToString());
                count++;

                dtItem.Rows.Add(dr);
            }
        }
        dtItem.AcceptChanges();

        if (count == 0)
        {
            // lblMsg.Visible = true;
            lblMsg.Text = "Please select patient";
        }
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            foreach (DataRow drr in dtItem.Rows)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO BlackList(PatientID,Reason,StartDate,ActualStartDate,IsBlackList,CentreID,EntryBy,EntryDateTime)  ");
                sb.Append(" VALUES('" + Util.GetString(drr["PatientID"]) + "','" + Util.GetString(drr["Reason"]) + "','" + Util.GetString(drr["StartDate"]) + "','" + Util.GetString(drr["StartDate"]) + "','" + Util.GetInt(drr["IsBlackList"]) + "','" + Util.GetString(drr["CentreID"]) + "','" + Util.GetString(drr["EntryBy"]) + "',NOW())");

                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                {
                    Tranx.Rollback();
                    con.Close();
                    con.Dispose();
                    lblMsg.Visible = true;
                    lblMsg.Text = "Error";
                    return;
                }
            }

            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Visible = true;
            lblMsg.Text = "Record Saved";

            btnSearch_Click(this, new EventArgs());
        }
    }

    public DataTable getItemDT()
    {
        DataTable dtItem = new DataTable();
        dtItem.Columns.Add("PatientID");
        dtItem.Columns.Add("Reason");
        dtItem.Columns.Add("StartDate");
        dtItem.Columns.Add("IsBlackList");
        dtItem.Columns.Add("CentreID");
        dtItem.Columns.Add("EntryBy");
        dtItem.Columns.Add("EntryDateTime");
        dtItem.Columns.Add("UpdatedBy");
        dtItem.Columns.Add("UpdatedDateTime");

        return dtItem;
    }
    protected void dgGrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        DataTable dt = new DataTable();
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            int BlackListID = Util.GetInt(((Label)e.Row.FindControl("lblBlackListID")).Text);
            if (BlackListID > 0)
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
        }
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        dgGrid.DataSource = null;
        dgGrid.DataBind();
    }
    protected void dgGrid_RowEditing(object sender, GridViewEditEventArgs e)
    {

    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (txtReason.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Enter Reason";
            return;
        }

        string str = "UPDATE BlackList SET StartDate='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "',UpdatedBy='" + Util.GetString(Session["ID"].ToString()) + "',UpdatedDateTime=NOW(),Reason='" + txtReason.Text.Trim() + "' WHERE ID='" + ViewState["ID"].ToString() + "' ";
        // MySqlHelper.ExecuteNonQuery(objTran, CommandType.Text, str);
        StockReports.ExecuteDML(str);
        ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        txtReason.Text = "";
        btnSearch_Click(this, new EventArgs());
    }
}