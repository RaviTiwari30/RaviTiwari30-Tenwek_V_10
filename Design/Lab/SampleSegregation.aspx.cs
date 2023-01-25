using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_SampleCollection_SampleSegregation : System.Web.UI.Page
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
            txtMRNo.Focus();
            All_LoadData.bindDocTypeList(ddldepartment, 5, "Select");
            All_LoadData.bindDoctor(ddlDoctor, "All");
            BindSegregationDept();
            calEntryDate1.EndDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now;
        }
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");
    }
    private void BindSegregationDept()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name as DeptName,ot.ObservationType_ID as DeptLedgerNo FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id ");
        sb.Append(" INNER JOIN f_categoryrole cr ON cr.ObservationType_ID = ot.ObservationType_ID and cr.RoleID='11' ");
        sb.Append(" order by ot.Name");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ViewState["SegregationDept"] = dt;
        }
       }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (rbtSegregate.SelectedItem.Value == "1")
            btnSave.Visible = false;
        else
            btnSave.Visible = true;

        Search();
    }
    private void Search()
    {
        StringBuilder sb = new StringBuilder();
        string TypeofTnx = string.Empty;
        string RoleDept = ViewState["RoleDept"].ToString();
        if (rdbLabType.SelectedValue == "OPD")
        {
            sb.Append("SELECT pli.isSegregate,ifnull(pli.SegregateDeptLedgerNo,'LSHHI952')SegregateDeptLedgerNo,otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id, PM.PatientID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender, ");
            sb.Append("CONCAT(pm.House_No,pm.Street_Name,pm.City)Address,pli.TransactionID,PLI.LedgerTransactionNo LedgerTransactionNo1, ");
            sb.Append("pli.Test_ID,IF(lom.Suffix<>'',CONCAT(REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2),'-',lom.Suffix), ");
            sb.Append(" REPLACE(REPLACE(pli.LedgerTransactionNo,'LOSHHI','1'),'LSHHI',2))LedgerTransactionNo, ");
            sb.Append(" im.Name ,im.sampletypename AS SampleType,im.IsOutSource AS IsOutSource,pli.OutSourceID,pli.IsOutSource OutSourceDone, ");
            sb.Append("IF(PLI.Result_Flag = 0,'false','true')IsResult,DATE_FORMAT(pli.date,'%d-%b-%Y')InDate,TIME_FORMAT(pli.Time,'%l:%i %p')TIME, ");
            sb.Append("PLI.ID,pli.SampleReceiveDate,'OPD' AS EntryType,IFNULL(pli.LedgerTnxID,'')LedgerTnxID,pli.isTransferReceive,IFNULL(sampleTransferCentreID,0)sampleTransferCentreID, IFNULL(( ");
            sb.Append("       SELECT IsRefund FROM f_ledgertnxdetail WHERE LedgerTransactionNo = pli.LedgerTransactionNo AND IsRefund=0 AND ItemID IN ( ");
            sb.Append("           SELECT ItemID FROM f_itemmaster WHERE Type_ID=pli.Investigation_ID AND Isactive=1 ");
            sb.Append("       ) LIMIT 1 ");
            sb.Append("),0) IsRefund,pli.IsUrgent,'' TransactionID,''room ");
            // sb.Append(" , (SELECT IF((NetAmount=Adjustment),TRUE,FALSE) FROM f_ledgertransaction ltp WHERE PaymentmodeID<>4 AND ltp.TransactionID=lt.TransactionID limit 1)PendingAmount  ");
            sb.Append("FROM patient_labinvestigation_opd pli INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo ");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pli.`TransactionID`=pmh.`TransactionID` INNER JOIN patient_master PM ON pli.PatientID = PM.PatientID and pli.Result_Flag=0 INNER JOIN investigation_master im ");
            sb.Append("ON pli.Investigation_ID = im.Investigation_Id ");
            sb.Append(" INNER JOIN doctor_master dm  ON dm.DoctorID = PLI.DoctorID");
            sb.Append(" INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ");
            sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id ");
            sb.Append(" LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=pli.Investigation_ID ");
            sb.Append(" LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
            sb.Append(" where im.Type='R' ");
            if (rbtSample.SelectedValue == "T")
                sb.Append(" AND IsSampleCollected='Y' and isTransfer=0 ");
            else if (rbtSample.SelectedValue == "O")
                sb.Append(" AND IsSampleCollected='Y' ");
            else
                sb.Append(" AND IsSampleCollected='" + rbtSample.SelectedValue + "' ");
            sb.Append(" AND pli.CentreID='" + Session["CentreID"].ToString() + "' ");

            sb.Append("  ");
        }
        else
        {
            sb.Append(" Select pli.isSegregate,ifnull(pli.SegregateDeptLedgerNo,'LSHHI952')SegregateDeptLedgerNo,otm.Name ObservationName,otm.ObservationType_Id, im.Investigation_Id,PLI.LedgerTransactionNo LedgerTransactionNo1, PM.PatientID,CONCAT(PM.Title,' ',Pm.PName)pname,pm.age,pm.gender,  ");
            sb.Append(" CONCAT(pm.House_No,pm.Street_Name,pm.City)Address,pli.Test_ID,pli.TransactionID,  ");
            //  sb.Append(" '1'PendingAmount ,");
            sb.Append(" IF(lom.Suffix<>'',CONCAT(REPLACE(REPLACE(pli.LedgerTransactionNo,'LISHHI','3'),'LSHHI',2),'-',lom.Suffix), ");
            sb.Append(" REPLACE(REPLACE(pli.LedgerTransactionNo,'LISHHI','3'),'LSHHI',2))LedgerTransactionNo, ");
            sb.Append(" if(PLI.Result_Flag=0,'false','true')IsResult,IM.Name,im.sampletypename AS SampleType,date_format(pli.date,'%d-%b-%Y')InDate,TIME_FORMAT(pli.Time,'%l:%i %p')TIME,PLI.ID,PLI.SampleReceiveDate,'IPD' as EntryType, ");
            sb.Append(" IFNULL(pli.LedgerTnxID,'')LedgerTnxID,pli.IsUrgent,im.IsOutSource AS IsOutSource,pli.OutSourceID,pli.IsOutSource OutSourceDone,pli.isTransferReceive,IFNULL(sampleTransferCentreID,0)sampleTransferCentreID,  ");
            sb.Append(" ( SELECT CONCAT(NAME,'/',bed_no)room FROM patient_ipd_profile pif INNER JOIN room_master rm ON pif.Room_ID=rm.Room_Id WHERE patientid=pm.`PatientID` AND STATUS ='IN')room,pli.TransactionID as TransactionID ");

            sb.Append(" FROM patient_labinvestigation_ipd PLI INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo  INNER JOIN investigation_master IM on PLI.Investigation_ID=IM.Investigation_Id  ");
            sb.Append(" INNER JOIN doctor_master dm  ON dm.DoctorID = PLI.DoctorID");
            sb.Append(" INNER JOIN patient_medical_history pmh ON pli.`TransactionID`=pmh.`TransactionID` INNER JOIN patient_master PM on lt.PatientID=PM.PatientID  ");
            sb.Append(" INNER JOIN investigation_observationtype iom on iom.Investigation_ID = im.Investigation_ID  ");
            sb.Append(" INNER JOIN observationtype_master otm on otm.ObservationType_Id = iom.ObservationType_Id  ");
            sb.Append(" INNER JOIN f_itemmaster fim ON fim.Type_ID=pli.Investigation_ID  ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd on IF(pli.IsSampleCollected='R',pli.LedgerTransactionNo, pli.LedgerTransactionNo)=ltd.LedgerTransactionNo and ltd.ItemID=fim.ItemID  ");
            sb.Append(" LEFT JOIN labobservation_investigation loi ON loi.Investigation_Id=pli.Investigation_ID ");
            sb.Append(" LEFT JOIN labobservation_master lom ON lom.LabObservation_ID=loi.labObservation_ID ");
            sb.Append(" where  im.Type='R' ");
            if (rbtSample.SelectedValue == "T")
                sb.Append(" AND IsSampleCollected='Y' and isTransfer=0 ");
            else if (rbtSample.SelectedValue == "O")
                sb.Append(" AND IsSampleCollected='Y' ");
            else
                sb.Append(" AND IsSampleCollected='" + rbtSample.SelectedValue + "' ");
            sb.Append(" AND pli.CentreID='" + Session["CentreID"].ToString() + "'  ");

            sb.Append(" and ltd.IsVerified=1  ");
        }

        if (txtMRNo.Text != string.Empty)
            if (rdbLabType.SelectedValue == "OPD")
                sb.Append(" and pm.PatientID='" + txtMRNo.Text.Trim() + "'");
            else
                sb.Append(" and pmh.PatientID='" + txtMRNo.Text.Trim() + "'");
        else if (txtCRNo.Text != string.Empty)
        {
            if (rdbLabType.SelectedValue == "IPD")
            {
                sb.Append(" and pmh.TransactionID='ISHHI" + txtCRNo.Text.Trim() + "'");
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
            if (rdbLabType.SelectedValue == "OPD")
            {
                sb.Append("   and   PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'1','LOSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )  OR");
                sb.Append("      PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'2','LSHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )  ");
                // sb.Append(" and (PLI.LedgerTransactionNo='" + txtLabNo.Text.Trim() + "' OR PLI.LedgerTransactionNo='" + txtLabNo.Text.Trim() + "')");
            }
            else
                sb.Append(" and PLI.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'3','LISHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )");
        if (ddlUrgent.SelectedValue != "2")
        {
            sb.Append(" and pli.IsUrgent='" + ddlUrgent.SelectedValue + "'");
        }
        if (ddldepartment.SelectedValue != "0")
            sb.Append(" AND dm.DocDepartmentID = '" + ddldepartment.SelectedValue + "'");
        if (ddlDoctor.SelectedValue != "0")
            sb.Append(" AND dm.DoctorID = '" + ddldepartment.SelectedValue + "'");

        sb.Append(" and pli.isSegregate='" + rbtSegregate.SelectedItem.Value + "'");
        sb.Append(" GROUP BY PLI.ID,IFNULL(lom.Suffix,'')  order by PLI.ID ");

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
        }
        else
        {
            grdLabSearch.DataSource = null;
            grdLabSearch.DataBind();
            pnlHide.Visible = false;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
    protected void grdLabSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (((Label)e.Row.FindControl("lblResult")).Text == "true")
            {
                e.Row.CssClass = "GridViewResultItemStyle";
            }
            if (((Label)e.Row.FindControl("lblIs_Urgent")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.Pink;
            }
            if (((Label)e.Row.FindControl("lblIs_Urgent")).Text == "0")
            {
                e.Row.BackColor = System.Drawing.Color.White;
            }
            if (((Label)e.Row.FindControl("lblIs_Outsource")).Text == "1" || ((Label)e.Row.FindControl("lblOutSourceDone")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.Cyan;
            }
            if (((Label)e.Row.FindControl("lblisSegregate")).Text == "1")
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }

            DropDownList ddlDepartment = (e.Row.FindControl("ddlDepartment") as DropDownList);
            ddlDepartment.DataTextField = "DeptName";
            ddlDepartment.DataValueField = "DeptLedgerNo";
            ddlDepartment.DataSource = (DataTable)ViewState["SegregationDept"];
            ddlDepartment.DataBind();
            string Department = ((Label)e.Row.FindControl("lblObservationType_Id")).Text;
            if (Department != "")
                ddlDepartment.Items.FindByValue(Department).Selected = true;


        }

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        int IsSelect = 0;
        StringBuilder applet = new StringBuilder();
        if (rbtSample.SelectedIndex == 1)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction();

            try
            {
                for (int i = 0; i < grdLabSearch.Rows.Count; i++)
                {
                    string sql = "";
                    if (((CheckBox)grdLabSearch.Rows[i].FindControl("chkSampleSegregate")).Checked)
                    {
                        IsSelect = 1;
                        string EntryType = ((Label)grdLabSearch.Rows[i].FindControl("lblEntryType")).Text;
                        string ID = ((Label)grdLabSearch.Rows[i].FindControl("lblID")).Text;
                        string Department = ((DropDownList)grdLabSearch.Rows[i].FindControl("ddlDepartment")).SelectedValue;
                        if (EntryType == "OPD")
                        {
                            sql = "Update patient_labinvestigation_opd Set isSegregate=1,SegregateDate=NOW(),SegregateBy='" + Session["ID"].ToString() + "',SegregateDeptLedgerNo='" + Department + "' Where ID = " + ID;
                        }
                        else
                        {
                            sql = "Update patient_labinvestigation_ipd Set isSegregate=1,SegregateDate=NOW(),SegregateBy='" + Session["ID"].ToString() + "',SegregateDeptLedgerNo='" + Department + "' Where ID = " + ID;
                        }

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
                    }

                }
                tnx.Commit();

            }

            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);

            }

            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

            if (IsSelect == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Select Atleast one record');", true);
                return;
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                Search();
            }
        }
    }

}
