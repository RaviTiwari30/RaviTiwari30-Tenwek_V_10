﻿using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_IPD_PatientRequisitionSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["LoginType"] = Session["LoginType"].ToString().ToUpper();
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TID"] = TID;
            AllQuery AQ = new AllQuery();

            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;

          //  DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);

           // if (dtDischarge != null && dtDischarge.Rows.Count > 0)
          //  {
            //    if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
              //  {
               //     string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Services can be possible...";
               //     Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
              //  }
           // }
            BindDetails();
        }
    }
    private void BindDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM (SELECT t.*,");
        sb.Append("    (CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE' WHEN t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL' END)    StatusNew");
        sb.Append("     FROM(SELECT CONCAT(em.Title,' ',em.Name)    EmpName,rd.DeptName AS Deptfrom,id.IndentNo,DATE_FORMAT(id.dtEntry,'%d-%b-%Y %h:%i %p')dtentry,id.ItemName,sum(id.ReqQty) ReqQty,sum(id.ReceiveQty)ReceiveQty,sum(id.RejectQty)RejectQty,id.UnitType,id.Narration,id.isApproved,");
        sb.Append("  id.ApprovedBy,id.ApprovedReason,id.UserId,CONCAT(pm.Title,' ',pm.PName)    PatientName,REPLACE(pmh.TransactionID,'ISHHI','')    TransactionID,");
        sb.Append("   id.IndentType,CONCAT(SUM(isacknowledge),'/',COUNT(*))AckStatus FROM f_indent_detail_patient id INNER JOIN patient_medical_history pmh ON pmh.TransactionID = id.TransactionID");
        sb.Append("    INNER JOIN employee_master em ON id.UserId = em.EmployeeID  INNER JOIN f_rolemaster rd    ON id.DeptFrom = rd.DeptLedgerNo  INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID WHERE pmh.TransactionID = '" + ViewState["TID"] + "'  GROUP BY id.IndentNo");
        sb.Append("   )t)t2");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdRequsition.DataSource = dt;
            grdRequsition.DataBind();
        }
    }
    private void BindDetails(string status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM (SELECT t.*,");
        sb.Append("    (CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE' WHEN t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL' END)    StatusNew");
        sb.Append("     FROM(SELECT CONCAT(em.Title,' ',em.Name)    EmpName,rd.DeptName AS Deptfrom,id.IndentNo,DATE_FORMAT(id.dtEntry,'%d-%b-%Y %h:%i %p')dtentry,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,id.Narration,id.isApproved,");
        sb.Append("  id.ApprovedBy,id.ApprovedReason,id.UserId,CONCAT(pm.Title,' ',pm.PName)    PatientName,REPLACE(pmh.TransactionID,'ISHHI','')    TransactionID,");
        sb.Append("   id.IndentType FROM f_indent_detail_patient id INNER JOIN patient_medical_history pmh ON pmh.TransactionID = id.TransactionID");
        sb.Append("    INNER JOIN employee_master em ON id.UserId = em.EmployeeID  INNER JOIN f_rolemaster rd    ON id.DeptFrom = rd.DeptLedgerNo  INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID WHERE pmh.TransactionID = '" + ViewState["TID"] + "'  GROUP BY id.IndentNo");
        sb.Append("   )t)t2");

        if (status != "")
        {
            sb.Append("  WHERE t2.StatusNew = '"+status+"'");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdRequsition.DataSource = dt;
            grdRequsition.DataBind();
        }
        else
        {
            grdRequsition.DataSource = null;
            grdRequsition.DataBind();
            lblMsg.Text = "";
            
        }
    }
    protected void btnSN_Click(object sender, EventArgs e)
    {
        BindDetails("OPEN");
        //Open
    }
    protected void btnRN_Click(object sender, EventArgs e)
    {
        BindDetails("CLOSE");
        // Close
    }
    protected void btnNA_Click(object sender, EventArgs e)
    {

        BindDetails("REJECT");
        // Reject
    }
    protected void btnA_Click(object sender, EventArgs e)
    {
        BindDetails("PARTIAL");
        // Partial
    }
    protected void grdRequsition_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            //string stttt = Util.GetString(e.CommandArgument).Split('#')[1];

            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string status = Util.GetString(e.CommandArgument).Split('#')[1];
      
            DataTable dt = viewIndentDetail(IndentNo);
            if (dt.Rows.Count > 0)
            {
                grdindent.DataSource = dt;
                grdindent.DataBind();
                mpe2.Show();
            }
        }
        if (e.CommandName == "APrint")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string status = Util.GetString(e.CommandArgument).Split('#')[1];
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("select cm.CentreName,id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,id.Narration,id.isApproved, ");
            sb1.Append("id.ApprovedBy,id.ApprovedReason,id.dtEntry,id.UserId,Concat(em.Title,' ',em.Name)EmpName,CONCAT(pm.Title,' ',pm.PName)PatientName,Replace(pmh.TransactionID,'ISHHI','')TransactionID,id.IndentType,pmh.`TransNo` as Transaction_ID from f_indent_detail_patient id inner  ");
            sb1.Append("join f_rolemaster rd on id.DeptFrom=rd.DeptLedgerNo inner join f_rolemaster rd1  ");
            sb1.Append("on id.DeptTo=rd1.DeptLedgerNo inner join employee_master em on id.UserId=em.EmployeeID INNER JOIN patient_medical_history pmh ON pmh.TransactionID=id.TransactionID INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID INNER JOIN center_master cm ON cm.CentreID=id.CentreID ");
            sb1.Append("  WHERE pmh.TransactionID = '" + ViewState["TID"] + "'  and id.indentno='" + IndentNo + "'");
            DataSet ds = new DataSet();
            ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
            ds.Tables[0].TableName = "Table";
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[1].TableName = "ClientImage";
          //  ds.WriteXmlSchema(@"F:/PatientNewIndent.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PatientNewIndent";
            lblMsg.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
    }

    protected void grdRequsition_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (((Label)e.Row.FindControl("lblStatusNew")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }

        }
    }
    protected void grdindent_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.YellowGreen;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }
           
            if (((Label)e.Row.FindControl("lblisAcknowledge")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
                ((CheckBox)e.Row.FindControl("chkSelect")).Enabled = false;
            }
        }
    }

    protected void btnAcknowledge_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        try
        {
            bool flag = false;
            string indentNo = "";
            foreach (GridViewRow row in grdindent.Rows)
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked)
                {
                    indentNo = ((Label)row.FindControl("lblIndentNo")).Text;
                    string itemID = ((Label)row.FindControl("lblItemID")).Text;
                    string indentID = ((Label)row.FindControl("lblIndentID")).Text;
                    string str = @"UPDATE  
                                     f_indent_detail_patient idp 
                                    SET idp.`isAcknowledge`=1,idp.isacknowledgeBy='" + Session["ID"].ToString() + "' WHERE idp.ID=@id";//lt.indentno=@indentNo AND ltd.`ItemID`=@itemID
                    excuteCMD.DML(Tranx, str, CommandType.Text, new
                    {
                       // itemID = itemID,
                        //indentNo = indentNo,
                        id = indentID,
                    });
                    flag = true;
                }
            }
            Tranx.Commit();
            if (flag)
            {
                lblMsgNew.Text = "Medicine Acknowledged Successfully";
                DataTable dt = viewIndentDetail(indentNo);
                if (dt.Rows.Count > 0)
                {
                    grdindent.DataSource = dt;
                    grdindent.DataBind();
                    mpe2.Show();
                }

            }
            else
            {
                lblMsgNew.Text = "No Medicine Selected to Acknowledged";
                mpe2.Show();
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsgNew.Text = ex.Message;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public DataTable viewIndentDetail(string indentNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT id.`id`as IndentID,(CASE WHEN id.reqQty=id.RejectQty THEN 'REJECT' WHEN id.reqQty-id.ReceiveQty-id.RejectQty=0 THEN 'CLOSE' WHEN id.reqQty+id.ReceiveQty+id.RejectQty=id.reqQty THEN 'OPEN' ELSE 'PARTIAL' END)    StatusNew,(IFNULL(id.ReqQty,0)-IFNULL(id.ReceiveQty,0)-IFNULL(id.RejectQty,0))PendingQty, id.IndentNo,(rd.DeptName)        DeptFrom,(rd1.DeptName)       DeptTo,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,");
        sb.Append("   id.Narration,id.isApproved,id.ApprovedBy,id.ApprovedReason,DATE_FORMAT(id.dtEntry,'%d-%b-%Y')DATE,id.UserId,CONCAT(em.Title,' ',em.Name)    EmpName,CONCAT(pm.Title,' ',pm.PName)    PatientName,");
        sb.Append("     REPLACE(pmh.TransactionID,'ISHHI','')    Transaction_ID,id.IndentType,id.ItemID,id.isAcknowledge FROM f_indent_detail_patient id ");
        sb.Append("   INNER JOIN f_rolemaster rd ON id.DeptFrom = rd.DeptLedgerNo");
        sb.Append("   INNER JOIN f_rolemaster rd1 ON id.DeptTo = rd1.DeptLedgerNo");
        sb.Append("    INNER JOIN employee_master em ON id.UserId = em.EmployeeID");
        sb.Append("    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = id.TransactionID");
        sb.Append("    INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID");
        sb.Append("  WHERE pmh.transactionid = '" + ViewState["TID"] + "'  and id.indentno='" + indentNo + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}