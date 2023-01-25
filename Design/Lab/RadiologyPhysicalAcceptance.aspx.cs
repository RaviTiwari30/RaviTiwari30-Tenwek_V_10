using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Lab_RadiologyPhysicalAcceptance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            ViewState["EmpName"] = Session["LoginName"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");



        }
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");
    }

   

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
      
    }
    private void Search()
    {
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        string RoleDept = ViewState["RoleDept"].ToString();

        if (rdbLabType.SelectedValue == "OPD")
        {
            sb.Append("SELECT otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,PM.pname,pm.age,pm.gender,pli.physical_acceptance,pli.IsOutSource,pli.Remarks,pli.IsUrgent,");
            sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.TransactionID, ");
            sb.Append("pli.Test_ID,pli.LedgerTransactionNo,im.Name , ");
            sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,DATE_FORMAT(pli.date,'%d-%b-%y')InDate,pli.Time, ");
            sb.Append("PLI.ID,pli.SampleReceiveDate,'OPD' AS EntryType,ifnull(pli.LedgerTnxID,'')LedgerTnxID, IFNULL(( ");
            sb.Append("       SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
            sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
            sb.Append("       ) LIMIT 1 ");
            sb.Append("),0) IsRefund ");
            sb.Append("FROM patient_labinvestigation_opd pli ");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON pli.LedgerTransactionNo=lt.LedgerTransactionNo ");
            //sb.Append("INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID and pli.Result_Flag=0 INNER JOIN investigation_master im ");
            sb.Append("INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID INNER JOIN investigation_master im ");
            sb.Append("ON pli.Investigation_ID = im.Investigation_Id ");
            sb.Append("INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
            sb.Append("INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
            sb.Append(" where im.Type='N' and  im.ReportType='5'  AND lt.IsCancel=0");
            

           
        }
        else
        {
            sb.Append(" Select otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,PM.pname,pm.age,pm.gender,pli.physical_acceptance,pli.IsOutSource,pli.Remarks,pli.IsUrgent,  ");
            sb.Append(" concat(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,pli.Test_ID,pli.TransactionID, pli.LedgerTransactionNo,  ");
            sb.Append(" if(PLI.Result_Flag=0,'false','true')IsResult,IM.Name,date_format(pli.date,'%d-%b-%y')InDate,pli.Time,PLI.ID,PLI.SampleReceiveDate,'IPD' as EntryType,ifnull(pli.LedgerTnxID,'')LedgerTnxID   ");
            sb.Append(" from patient_labinvestigation_ipd PLI inner join investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id  ");
            sb.Append(" inner join patient_medical_history pmh  on PLI.TransactionID =pmh.TransactionID inner join  patient_master PM on pmh.PatientID=PM.PatientID  ");
            sb.Append(" inner join investigation_observationtype iom on iom.Investigation_ID = im.Investigation_ID  ");
            sb.Append(" inner join observationtype_master otm on otm.ObservationType_Id = iom.ObservationType_Id  ");
            sb.Append(" INNER JOIN f_itemmaster fim ON fim.Type_ID=pli.Investigation_ID  ");
            sb.Append(" inner join f_ledgertnxdetail ltd on pli.LedgerTransactionNo=ltd.LedgerTransactionNo and ltd.ItemID=fim.ItemID  ");
            sb.Append(" where im.Type='N' and ltd.IsVerified=1 and  im.ReportType='5' ");
        }

        if (txtMRNo.Text != string.Empty)
        {
            if (rdbLabType.SelectedValue == "OPD")
                sb.Append(" and pm.PatientID='" + txtMRNo.Text.Trim() + "'");
            else
                sb.Append(" and pmh.PatientID='" + txtMRNo.Text.Trim() + "'");
        }
        else if (txtCRNo.Text != string.Empty)
        {
            if (rdbLabType.SelectedValue == "IPD")
            {
                sb.Append(" and pmh.TransactionID='ISHHI" + txtCRNo.Text.Trim() + "'");
            }
            else
            {
                //lblMsg.Text = "Plz Select Correct LAB Type";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM047','" + lblMsg.ClientID + "');", true);
                return;
            }
        }

        if (txtPName.Text != string.Empty)
            sb.Append(" and PM.PName like '" + txtPName.Text.Trim() + "%'");

        if (FrmDate.Text != string.Empty)
            sb.Append(" and PLI.Date >='" + Util.GetDateTime(FrmDate.Text).ToString("yyyy-MM-dd") + "'");

        if (ToDate.Text != string.Empty)
            sb.Append(" and PLI.Date <='" + Util.GetDateTime(ToDate.Text).ToString("yyyy-MM-dd") + "'");

        if (txtLabNo.Text != string.Empty)
            if (rdbLabType.SelectedValue == "OPD")
                sb.Append(" and (PLI.LedgerTransactionNo='LOSHHI" + txtLabNo.Text.Trim().Substring(1) + "' OR PLI.LedgerTransactionNo='LSHHI" + txtLabNo.Text.Trim().Substring(1) + "')");
            else
                sb.Append(" and PLI.LedgerTransactionNo='LISHHI" + txtLabNo.Text.Trim().Substring(1) + "'");

        sb.Append(" order by PLI.ID ");

        DataTable dtInvest = StockReports.GetDataTable(sb.ToString());
        if (dtInvest != null && dtInvest.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "LabType";
            dc.DefaultValue = rdbLabType.SelectedValue;
            dtInvest.Columns.Add(dc);
            ViewState["dtInvest"] = dtInvest;

            grdLabSearch2.DataSource = dtInvest;
            grdLabSearch2.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            grdLabSearch2.DataSource = null;
            grdLabSearch2.DataBind();
            pnlHide.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }

    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            
            if (((Label)e.Row.FindControl("lblIs_Urgent")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.Pink;
            }
            if (((Label)e.Row.FindControl("lblIs_Outsource")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.Teal;
            }
            if (((Label)e.Row.FindControl("lblphysical")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.Tan;
                ((CheckBox)e.Row.FindControl("chkPhysicalAcceptance")).Visible = false;
            }
            string LedgerTransactionNO = ((Label)e.Row.FindControl("lblLedTnx")).Text;
            if (e.Row.RowIndex >= 1)
            {
                string PreviousLedgerTransactionNO = ((Label)grdLabSearch2.Rows[e.Row.RowIndex - 1].FindControl("lblLedTnx")).Text;
                if (LedgerTransactionNO == PreviousLedgerTransactionNO)
                {
                    ((Label)e.Row.FindControl("lblPatientID")).Text = "";
                    ((Label)e.Row.FindControl("lbl_pname")).Text = "";
                    ((Label)e.Row.FindControl("lbl_age")).Text = "";
                }
            }
        }
        else
        {
            e.Row.BackColor = System.Drawing.Color.White;
        }
        

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        int IsSelected = 0;
        for (int i = 0; i < grdLabSearch2.Rows.Count; i++)
        {
            if (((CheckBox)grdLabSearch2.Rows[i].FindControl("chkPhysicalAcceptance")).Checked)
                IsSelected = 1;
        }

        if (IsSelected == 0)
        {
            //lblMsg.Text = "Kindly Select Test to Accept & Forward..";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM048','" + lblMsg.ClientID + "');", true);
            return;
        }


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {
            string sql ;

            bool flag = false;
            foreach (GridViewRow gr in grdLabSearch2.Rows)
            {
                if (((CheckBox)gr.FindControl("chkPhysicalAcceptance")).Checked)
                {
                    flag = true;

                    string EntryType = ((Label)gr.FindControl("lblEntryType")).Text;
                    string ID = ((Label)gr.FindControl("lblID")).Text;

                    if (EntryType == "OPD")
                    {
                        sql = "Update patient_labinvestigation_opd Set physical_acceptance = 1 Where ID = " + ID;
                    }
                    else
                    {
                        sql = "Update patient_labinvestigation_ipd Set physical_acceptance = 1 Where ID = " + ID;
                    }

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                }
            }

            if (!flag)
            {
                tnx.Rollback();
                con.Close();
                con.Dispose();
                return;
            }

            tnx.Commit();
            con.Close();
            con.Dispose();
            // lblMsg.Text = "Record Saved Successfully ..";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

            Search();
            return;

        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
            con.Close();
            con.Dispose();
            return;
        }


    }

  
}
