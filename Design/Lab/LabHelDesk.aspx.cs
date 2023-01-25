using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;

public partial class Design_Lab_LabHelDesk : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            ViewState["EmpName"] = Session["LoginName"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtMRNo.Focus();
            All_LoadData.bindDoctor(ddlDoctor,"Select");
            GetDoctor();
        }
        
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");

    }
    private void search()
    {
        lblMsg.Text = "";
        btnSearch.Text = "Searching...";
        btnSearch.Enabled = false;
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        string RoleDept = ViewState["RoleDept"].ToString();

        sb.Append("SELECT pmh.Type Type,pmh.TransNo,otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender, ");
            sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.City)Address,pli.TransactionID,PLI.LedgerTransactionNo LedgerTransactionNo1, ");
            sb.Append("pli.Test_ID,REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2)LedgerTransactionNo,im.Name ,im.sampletypename AS SampleType,pli.IsOutSource, ");
            sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,DATE_FORMAT(pli.date,'%d-%b-%Y')InDate,TIME_FORMAT(pli.Time,'%l:%i %p')TIME, ");
            sb.Append("if(lt.paymentmodeID<>4, if(lt.NetAmount=lt.Adjustment,'true','false'),'true')AmountStatus,if(Approved=1,'true','false')isApproved, ");
            sb.Append(" IF(im.Type='R',IF(IsSampleCollected = 'N','false','true'),'R')IsSampleCollected, ");
            sb.Append("PLI.ID,pli.SampleReceiveDate,'OPD' AS EntryType,IFNULL(pli.LedgerTnxID,'')LedgerTnxID, IFNULL(( ");
            sb.Append("       SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
            sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
            sb.Append("       ) LIMIT 1 ");
            sb.Append("),0) IsRefund,pli.IsUrgent, ");
            sb.Append(" IFNULL(prp.PrintedbyName,'') PrintedbyName ");            
            sb.Append("FROM patient_labinvestigation_opd pli INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            sb.Append("INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID  INNER JOIN investigation_master im ");
            sb.Append("ON pli.Investigation_ID = im.Investigation_Id ");
            sb.Append("INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.TransactionID=lt.TransactionID ");
            sb.Append("INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
            sb.Append(" LEFT JOIN patientreport_printout prp ON prp.LedgerTransactionNo=pli.LedgerTransactionNo AND prp.InvestigationID=pli.Investigation_ID AND prp.IsActive=1");
            sb.Append(" where  im.type in ('R','N')   ");
            if (rdbLabType.SelectedValue == "OPD")
                sb.Append(" AND pli.Type=1 ");
            else if (rdbLabType.SelectedValue == "OPD")
                sb.Append(" AND pli.Type=2 ");
        if (txtMRNo.Text != string.Empty)
            if (rdbLabType.SelectedValue == "OPD")
                sb.Append(" and pm.PatientID='" + txtMRNo.Text.Trim() + "'");
            else
                sb.Append(" and pmh.PatientID='" + txtMRNo.Text.Trim() + "'");
        else if (txtCRNo.Text != string.Empty)
        {
            if (rdbLabType.SelectedValue == "IPD")
            {
                sb.Append(" and pmh.TransNo='" + txtCRNo.Text.Trim() + "'");
            }
            else
            {
                lblMsg.Text = "Please Select Correct LAB Type";
                return;
            }
        }

        if (txtPName.Text != string.Empty)
            sb.Append(" and PM.PName like '" + txtPName.Text.Trim() + "%'");

        if (FrmDate.Text != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

        if (ToDate.Text != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "' AND lt.IsCancel=0");

        if (txtLabNo.Text != string.Empty)
            sb.Append(" AND pli.BarcodeNo='"+ txtLabNo.Text.Trim() +"' ");
        if (ddlUrgent.SelectedValue != "2")
        {
            sb.Append(" and pli.IsUrgent='" + ddlUrgent.SelectedValue + "'");
        }
        if (ddlDoctor.SelectedIndex > 0)
            sb.Append(" AND pli.DoctorID= '" + ddlDoctor.SelectedValue + "'  ");
        if (lblDoctor.Text != "")
            sb.Append(" and pli.Approved=1 ");
        sb.Append(" AND pli.CentreID='" + Session["CentreID"].ToString() + "' ");
        sb.Append(" order by PLI.ID DESC ");

        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "LabType";
            dc.DefaultValue = rdbLabType.SelectedValue;
            dtInvest.Columns.Add(dc);
            ViewState["dtInvest"] = dtInvest;

            grdLabSearch.DataSource = dtInvest;
            grdLabSearch.DataBind();
            pnlHide.Visible = true;
            btnPrint.Visible = true;
            btnSearch.Text = "Search";
            btnSearch.Enabled = true;
        }
        else
        {
            grdLabSearch.DataSource = null;
            grdLabSearch.DataBind();
            pnlHide.Visible = false;
            btnSearch.Text = "Search";
            btnSearch.Enabled = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    private void GetDoctor()
    {
            lblDoctor.Text = StockReports.ExecuteScalar("select DoctorID from doctor_employee where Employeeid='" + Convert.ToString(Session["ID"]) + "'");
            ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(lblDoctor.Text));
            search();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        search();
    }
    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            
            if (((Label)e.Row.FindControl("lblIs_Urgent")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.Pink;
            }
            if (((Label)e.Row.FindControl("lbl_samplecollect")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lbl_samplecollect")).Text == "false")
            {
                e.Row.BackColor = System.Drawing.Color.White;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "true" || ((Label)e.Row.FindControl("lbl_samplecollect")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.Coral;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblisApproved")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblisApproved")).Text == "false" && ((Label)e.Row.FindControl("lblResult")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.Coral;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "false" && ((Label)e.Row.FindControl("lbl_samplecollect")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "true" && ((Label)e.Row.FindControl("lbl_samplecollect")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.Coral;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "true" && ((Label)e.Row.FindControl("lbl_samplecollect")).Text == "true" && ((Label)e.Row.FindControl("lblisApproved")).Text == "false")
            {
                e.Row.BackColor = System.Drawing.Color.Coral;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lblResult")).Text == "true" && ((Label)e.Row.FindControl("lbl_samplecollect")).Text == "true" && ((Label)e.Row.FindControl("lblisApproved")).Text == "true")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
                ((ImageButton)e.Row.FindControl("imbView")).Visible = true;
            }
            if (((Label)e.Row.FindControl("lbl_AmountStatus")).Text == "false")
            {
                if (lblDoctor.Text == "")
                    ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if (((Label)e.Row.FindControl("lbl_AmountStatus")).Text == "true" && ((Label)e.Row.FindControl("lblResult")).Text == "true" && ((Label)e.Row.FindControl("lblisApproved")).Text == "true")
            {
                ((ImageButton)e.Row.FindControl("imbView")).Visible = true;
            }
            else
            {
                if (rdbLabType.SelectedValue == "OPD")
                    ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
                else
                    ((ImageButton)e.Row.FindControl("imbView")).Visible = false;
            }
            if ((((Label)e.Row.FindControl("lblPrintedBy")).Text != "") || (((Label)e.Row.FindControl("lblisApproved")).Text =="true" ))
            {
                ((Label)e.Row.FindControl("lblPrintShow")).Attributes.Add("style", "display:block");
            }
            else
            {
                ((Label)e.Row.FindControl("lblPrintShow")).Attributes.Add("style", "display:none");
            }
            if (((Label)e.Row.FindControl("lblIs_Outsource")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.Aqua;
            }
        }
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string TestID = "";
        string Labtype = lbllabType.Text.Trim();
        int LabreportType = 11;
        btnPrint.Text = "Printing...";
        btnPrint.Enabled = false;
        foreach (GridViewRow gr in grdResult.Rows)
        {
            if (((CheckBox)gr.FindControl("chkSelect")).Checked)
            {
                if (TestID == "")
                    TestID = ((TextBox)gr.FindControl("txtTest_ID")).Text;
                else
                    TestID = TestID + "," + ((TextBox)gr.FindControl("txtTest_ID")).Text;
            }
        }
        if (TestID != "")
        {
            if(Labtype =="OPD")
            All_LoadData.updateNotification(Convert.ToString(lblUpdateLedgertransactionNo.Text.Trim()), Util.GetString(Session["ID"].ToString()), "", 4);
            else
                All_LoadData.updateNotification(Convert.ToString(lblUpdateLedgertransactionNo.Text.Trim()), Util.GetString(Session["ID"].ToString()), "", 16);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", " window.open('../../Design/Lab/printLabReport_pdf.aspx?TestID=" + TestID + "&LabType=" + Labtype + "&LabreportType=" + LabreportType + "');", true);
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM046','" + lblMsg.ClientID + "');", true);
        btnPrint.Text = "Print";
        btnPrint.Enabled = true;
        lblUpdateLedgertransactionNo.Text = "";
        lbllabType.Text = "";
        mpePatientResult.Hide();
        
    }
    protected void grdLabSearch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "viewResult")
        {
            string LedgertransactionNo = e.CommandArgument.ToString().Split('#')[0];
            string TID = e.CommandArgument.ToString().Split('#')[1];
            string LabType = e.CommandArgument.ToString().Split('#')[2];
            DataTable dtSearch = LabOPD.getLabToPrint(LedgertransactionNo);
            
           if (dtSearch.Rows.Count > 0)
            {
                dtSearch.Columns.Add("PendingAmount", typeof(System.Int32));
                foreach (DataRow dr in dtSearch.Rows)
                {
                    dr["PendingAmount"] = 0;
                }
                grdResult.DataSource = dtSearch;
                grdResult.DataBind();
                mpePatientResult.Show();
                lblUpdateLedgertransactionNo.Text = LedgertransactionNo;
                lbllabType.Text = LabType;
            }
        }
    }
    protected void grdResult_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (((Label)e.Row.FindControl("lbldhk")).Text == "1" && ((Label)e.Row.FindControl("AmountStatus")).Text == "false")
            {
                if (lblDoctor.Text == "")
                    ((CheckBox)e.Row.FindControl("chkSelect")).Enabled = false;
                ((CheckBox)e.Row.FindControl("chkSelect")).Checked = false;
            }
        }
    }
}
