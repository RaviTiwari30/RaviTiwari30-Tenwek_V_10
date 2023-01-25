using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_Store_InternalStockTransferPatient : System.Web.UI.Page
{
    public void searchindentnew(string status)
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (  ");
            sb.Append("   SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'  ");
            sb.Append("   WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ");
            sb.Append("   FROM ( ");
            sb.Append("  SELECT id.indentno,id.IndentType,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,(SELECT ledgername FROM f_ledgermaster WHERE LedgerNumber = id.Deptfrom)DeptFrom ,id.Status,REPLACE(id.TransactionID,'ISHHI','')IPDNo,id.TransactionID,pm.PatientID,pm.PName,id.DoctorID,IFNULL(id.IPDCaseType_ID,'')IPDCaseType_ID,IFNULL(id.Room_ID,'')Room_ID, ");
            sb.Append("  (SELECT NAME FROM employee_master WHERE employee_id=id.userid)UserName,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty ");
            sb.Append("  FROM f_indent_detail_patient id  INNER JOIN patient_master pm ON id.PatientID = pm.PatientID  ");
            sb.Append("     where Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' and id.storeid='STO00001' and id.deptto = '" + ViewState["DeptLedgerNo"].ToString() + "'  ");

            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append("   and indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "' ");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                sb.Append("  and deptfrom='" + ddlDepartment.SelectedItem.Value + "'");
            }
            if (txtTransactionID.Text.Trim() != "")
            {
                sb.Append("  and TransactionID = 'ISHHI" + txtTransactionID.Text.ToString().Trim() + "'");
            }

            sb.Append(" GROUP BY IndentNo )t  )t1 where t1.StatusNew in (" + status + ") order by dtentry");
            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                grdIndentSearch.DataSource = dtIndentDetails;
                grdIndentSearch.DataBind();
                pnlSearch.Visible = true;
                pnlSave.Visible = false;
            }
            else
            {
                grdIndentSearch.DataSource = null;
                grdIndentSearch.DataBind();
                pnlSave.Visible = false;
                pnlSearch.Visible = false;
                return;
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error..";
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }

    }

    protected void BindIndentDetails(string Dept, string IndentNo, string TransactionID, string Status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select t1.*,CONCAT(ictm.Name,' ',rm.Bed_No,' ',rm.Floor)RoomName FROM ( SELECT CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',pm.Gender)Age,pm.PatientID PatientID, ");
        sb.Append(" replace(pmh.TransactionID,'ISHHI','')TransactionID,replace(pmh.TransactionID,'ISHHI','')EmergencyNo,'' LedgerTransactionNo,pmh.PanelID,pmh.Patient_Type PatientType,pmh.DoctorID, ");
        sb.Append(" (select name from  doctor_master where DoctorID=pmh.DoctorID)DocTorName,(select company_name from f_panel_master where PanelID=pmh.PanelID)PanelName,ich.Status,pip.Room_ID ");
        sb.Append(" FROM patient_master pm INNER JOIN patient_medical_history pmh ON pmh.PatientID=pm.PatientID  ");
        sb.Append(" inner join patient_ipd_profile pip on pip.TransactionID=pmh.TransactionID inner join ipd_case_history ich on ich.TransactionID=pip.TransactionID ");
        sb.Append(" WHERE pmh.TransactionID='" + TransactionID + "'  )t1 ");
        sb.Append(" inner join room_master rm on t1.room_id=rm.Room_Id inner join ipd_case_type_master ictm on rm.IPDCaseTypeID=ictm.IPDCaseType_ID ");

        DataTable dtPatientDetails = StockReports.GetDataTable(sb.ToString());
        lblPatientTypeID.Text = "IPD No.";
        


        if (dtPatientDetails.Rows.Count == 0)
        {
            sb = new StringBuilder(" SELECT ");
            sb.Append(" CONCAT(pm.Title,' ',pm.PName) PName, ");
            sb.Append(" CONCAT(pm.Age,'/',pm.Gender) Age, ");
            sb.Append("  pm.PatientID , ");
            sb.Append("  pmh.TransactionID, ");
            sb.Append("  pmh.PanelID, ");
            sb.Append("  pm.PatientType, ");
            sb.Append("  CONCAT(dm.Title,' ',dm.Name) DocTorName, ");
            sb.Append("  dm.DoctorID, ");
            sb.Append("  p.Company_Name  PanelName, ");
            sb.Append("  'IN' `Status`, ");
            sb.Append("  '' Room_ID, ");
            sb.Append("  '' RoomName ,");
            sb.Append("  emr.EmergencyNo, ");
            sb.Append("  emr.LedgerTransactionNo ");
           
            sb.Append("  FROM  emergency_patient_details   emr ");
            sb.Append("  INNER JOIN patient_master pm ON pm.PatientID=emr.PatientId ");
            sb.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransactionID=emr.TransactionId   ");
            sb.Append("  INNER JOIN  f_panel_master p ON p.PanelID=pmh.PanelID ");
            sb.Append("  LEFT JOIN doctor_master dm ON dm.DoctorID=pmh.DoctorID ");
            sb.Append("  WHERE emr.IsReleased=0 AND emr.TransactionId='" + TransactionID + "' ");

            dtPatientDetails = StockReports.GetDataTable(sb.ToString());

            lblPatientTypeID.Text = "Emergency No.";
        }



        if (dtPatientDetails != null && dtPatientDetails.Rows.Count > 0)
        {
            lblAge.Text = dtPatientDetails.Rows[0]["Age"].ToString();
            lblPatientName.Text = dtPatientDetails.Rows[0]["PName"].ToString();
            lblRegistrationNo.Text = dtPatientDetails.Rows[0]["PatientID"].ToString();
            lblRegistrationNo.Attributes["PanelID"] = dtPatientDetails.Rows[0]["PanelID"].ToString();
            lbllblTransactionIDDisplay.Text = dtPatientDetails.Rows[0]["EmergencyNo"].ToString();
            lblLedgerTransactionNo.Text = dtPatientDetails.Rows[0]["LedgerTransactionNo"].ToString();
            lblTransactionID.Text = dtPatientDetails.Rows[0]["TransactionID"].ToString();//.Replace("ISHHI", "");
            lblDocName.Text = dtPatientDetails.Rows[0]["DocTorName"].ToString();
            lblPanelName.Text = dtPatientDetails.Rows[0]["PanelName"].ToString();
            lblRoomName.Text = dtPatientDetails.Rows[0]["RoomName"].ToString();
            lblPanelId.Text = dtPatientDetails.Rows[0]["PanelID"].ToString();
            ViewState["TID"] = dtPatientDetails.Rows[0]["TransactionID"].ToString();
            ViewState["PID"] = dtPatientDetails.Rows[0]["PatientID"].ToString();
            lblPatientStatus.Text = dtPatientDetails.Rows[0]["Status"].ToString();
            lblPatientType.Text = dtPatientDetails.Rows[0]["PatientType"].ToString();
            lblDoctorID.Text = dtPatientDetails.Rows[0]["DoctorID"].ToString();
        }
        else
        {
            lblMsg.Text = "Data Not Found. Please Check May be Patient is Discharged ";
            pnlSave.Visible = false;
            return;
        }
        string strnew = "select ind.*,im.Type_ID,im.SubCategoryID,im.ServiceItemID,im.ToBeBilled from f_indent_detail_patient ind inner join f_itemmaster im on ind.itemid=im.itemid where (ind.ReceiveQty+ind.RejectQty)<ind.ReqQty and ind.indentno = '" + IndentNo + "'";
        DataTable dtIndentDetails = StockReports.GetDataTable(strnew);

        if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
        {
            lblMsg.Text = "";
            DataColumn dc = new DataColumn("AvailQty");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            dc = new DataColumn("IssuePossible");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            dc = new DataColumn("PendingQty");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            dc = new DataColumn("DeptAvailQty");
            dc.DefaultValue = "0";
            dtIndentDetails.Columns.Add(dc);

            for (int m = 0; m < dtIndentDetails.Rows.Count; m++)
            {
                //string strStock = "select DISTINCT sum(InitialCount-ReleasedCount-PendingQty)AvailQty,deptledgerNo from f_stock  where itemID='" + dtIndentDetails.Rows[m]["itemID"] + "' and (InitialCount-ReleasedCount-PendingQty)>0 and deptledgerNo in ('" + ViewState["DeptLedgerNo"].ToString() + "','" + dtIndentDetails.Rows[m]["DeptFrom"].ToString() + "') and IsPost=1  and MedExpiryDate>CURDATE() group by  itemID,deptledgerno";
                string strStock = "select DISTINCT sum(InitialCount-ReleasedCount-PendingQty)AvailQty,deptledgerNo from f_stock  where itemID='" + dtIndentDetails.Rows[m]["itemID"] + "' and (InitialCount-ReleasedCount-PendingQty)>0 and deptledgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and IsPost=1  and MedExpiryDate>CURDATE() group by  itemID,deptledgerno";

                DataTable dtStock = StockReports.GetDataTable(strStock);

                if (dtStock != null && dtStock.Rows.Count > 0)
                {
                    foreach (DataRow row in dtStock.Rows)
                    {
                        if (row["deptledgerNo"].ToString() == ViewState["DeptLedgerNo"].ToString())
                            dtIndentDetails.Rows[m]["AvailQty"] = row["AvailQty"].ToString();

                        if (row["deptledgerNo"].ToString() == dtIndentDetails.Rows[m]["DeptFrom"].ToString())
                            dtIndentDetails.Rows[m]["DeptAvailQty"] = row["AvailQty"].ToString();
                    }
                }

                float resQty = Util.GetFloat(dtIndentDetails.Rows[m]["ReqQty"]) - Util.GetFloat(dtIndentDetails.Rows[m]["ReceiveQty"]) - Util.GetFloat(dtIndentDetails.Rows[m]["RejectQty"]);
                if (resQty < Util.GetFloat(dtIndentDetails.Rows[m]["AvailQty"]))
                {
                    dtIndentDetails.Rows[m]["IssuePossible"] = resQty;
                }
                else
                {
                    dtIndentDetails.Rows[m]["IssuePossible"] = Util.GetFloat(dtIndentDetails.Rows[m]["AvailQty"]);
                }

                dtIndentDetails.Rows[m]["PendingQty"] = Util.GetFloat(dtIndentDetails.Rows[m]["ReqQty"]) - (Util.GetFloat(dtIndentDetails.Rows[m]["ReceiveQty"]) + Util.GetFloat(dtIndentDetails.Rows[m]["RejectQty"]));
            }
            dtIndentDetails.AcceptChanges();
            ViewState["StockTransfer"] = dtIndentDetails;
            grdIndentDetails.DataSource = dtIndentDetails;
            grdIndentDetails.DataBind();
            pnlSave.Visible = true;
            if (lblPatientStatus.Text == "OUT")
            {
                foreach (RepeaterItem ri in grdIndentDetails.Items)
                {
                    ((ImageButton)ri.FindControl("imgMore")).Visible = false;
                }
            }
        }
        else
        {
            grdIndentDetails.DataSource = null;
            grdIndentDetails.DataBind();
            pnlSave.Visible = false;
            return;
        }
    }

    protected void btnA_Click(object sender, EventArgs e)
    {
        searchindentnew("'PARTIAL'");
        // Partial
    }

    protected void btnNA_Click(object sender, EventArgs e)
    {
        searchindentnew("'REJECT'");
        // Reject
    }

    protected void btnRN_Click(object sender, EventArgs e)
    {
        searchindentnew("'CLOSE'");
        // Close
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        bool isSelect = false;
        foreach (RepeaterItem lt in grdIndentDetails.Items)
        {
            // GridView grdIt = (GridView)lt.FindControl("grdItem");
            Repeater grdItem = (Repeater)lt.FindControl("grdItem");
            Repeater grdItemGenric = (Repeater)lt.FindControl("grdItemGenric");
            Label LbItemId = (Label)lt.FindControl("lblItemID");
            Label RequestQty = (Label)lt.FindControl("lblRequestedQty");
            Label LAvailQty = (Label)lt.FindControl("lblAvailQty");
            CheckBox chkSelect = (CheckBox)lt.FindControl("chkSelect");
            if (chkSelect.Checked)
            {
                isSelect = true;
                decimal newIssueQty = 0;

                if (grdItem.Items.Count > 0)
                {
                    foreach (RepeaterItem grItem in grdItem.Items)
                    {
                        GridView grdItemNew = (GridView)grItem.FindControl("grdItemNew");
                        if (grdItemNew != null)
                        {
                            if (grdItemNew.Rows.Count > 0)
                            {
                                foreach (GridViewRow grItemNew in grdItemNew.Rows)
                                {
                                    if (Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) > 0)
                                    {
                                        newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                    }
                                }
                            }
                        }
                        if (Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text) > 0)
                        {
                            newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                        }
                    }
                }
                else if (grdItemGenric.Items.Count > 0)
                {
                    foreach (RepeaterItem grItemGenric in grdItemGenric.Items)
                    {
                        GridView grdItemNewgenric = (GridView)grItemGenric.FindControl("grdItemNewgenric");
                        if (grdItemNewgenric != null)
                        {
                            if (grdItemNewgenric.Rows.Count > 0)
                            {
                                foreach (GridViewRow grItemNewgenric in grdItemNewgenric.Rows)
                                {
                                    if (Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) > 0)
                                    {
                                        newIssueQty = newIssueQty + Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                    }
                                }
                            }
                        }
                    }
                }

                decimal totalRequest = Util.GetDecimal(((Label)lt.FindControl("lblRequestedQty")).Text);
                decimal oldIssueQty = Util.GetDecimal(((Label)lt.FindControl("lblIssuedQty")).Text);
                decimal oldReject = Util.GetDecimal(((Label)lt.FindControl("lblRejectedQty")).Text);
                decimal txtReject = Util.GetDecimal(((TextBox)lt.FindControl("txtReject")).Text);
                if (txtReject != 0)
                {
                    string Reason = Util.GetString(((TextBox)lt.FindControl("txtReason")).Text);

                    if (Reason == "")
                    {
                        lblMsg.Text = "Enter Rejected Reason";
                        return;
                    }
                }
                decimal pendingQty = Util.GetDecimal(((Label)lt.FindControl("lblPendingQty")).Text);
                if (totalRequest < oldIssueQty + oldReject + txtReject + newIssueQty)
                {
                    if (newIssueQty == 0 && txtReject > 0)
                    {
                        lblMsg.Text = "Reject Qty. is greater than requested Qty.";
                    }
                    else
                    {
                        lblMsg.Text = "Issue Qty. is greater than requested Qty.";
                    } return;
                }
                else
                    ((TextBox)lt.FindControl("txtIssueingQty")).Text = Util.GetString(newIssueQty);
                if (newIssueQty == 0 && txtReject == 0)
                {
                    lblMsg.Text = "Please Enter Issue Or Reject Qty.";
                    return;
                }
            }
        }

        if (!isSelect)
        {
            lblMsg.Text = "No Item is Selected";
            return;
        }
        else
            SaveIndentData();
    }

    protected void btnSearchIndent_Click1(object sender, EventArgs e)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT *,IF(StatusNew='OPEN' OR StatusNew='PARTIAL','true','false')VIEW FROM (  ");
            sb.Append("  SELECT t.*,(CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN  t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE'  ");
            sb.Append("  WHEN   t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL'  END)StatusNew  ");
            sb.Append("  FROM ( ");
            sb.Append("  SELECT id.indentno,id.IndentType,DATE_FORMAT(id.dtentry,'%d-%b-%y')dtEntry,(SELECT ledgername FROM f_ledgermaster WHERE LedgerNumber = id.Deptfrom)DeptFrom ,id.Status,replace(id.TransactionID,'ISHHI','')IPDNo,id.TransactionID, pm.PatientID,pm.PName,id.DoctorID,IFNULL(id.IPDCaseType_ID,'')IPDCaseType_ID,IFNULL(id.Room_ID,'')Room_ID, ");
            sb.Append("  (SELECT NAME FROM employee_master WHERE employee_id=id.userid)UserName,SUM(ReqQty)ReqQty,SUM(ReceiveQty)ReceiveQty,SUM(RejectQty)RejectQty ");
            sb.Append("  FROM f_indent_detail_patient id INNER JOIN patient_master pm ON id.PatientID = pm.PatientID  ");
            sb.Append("   where id.storeid='STO00001' and id.deptto = '" + ViewState["DeptLedgerNo"].ToString() + "'  ");

            if (txtIndentNoToSearch.Text.ToString().Trim() != string.Empty)
            {
                sb.Append("   and indentno = '" + txtIndentNoToSearch.Text.ToString().Trim() + "' ");
            }
            if (ddlDepartment.SelectedIndex > 0)
            {
                sb.Append("  and deptfrom='" + ddlDepartment.SelectedItem.Value + "'");
            }
            if (txtTransactionID.Text.Trim() != "")
            {
                sb.Append("  and id.TransactionID = 'ISHHI" + txtTransactionID.Text.ToString().Trim() + "'");
            }
            if (txtIndentNoToSearch.Text.ToString().Trim() == string.Empty && txtTransactionID.Text.Trim() == "")
                sb.Append(" and Date(id.dtEntry) >= '" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' and Date(id.dtEntry) <='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' ");
            if (txtMrNo.Text.Trim() != "")
                sb.Append(" AND id.PatientID='" + txtMrNo.Text.Trim() + "' ");
            if (txtPName.Text.Trim() != "")
                sb.Append(" AND pm.pName like '%" + txtPName.Text.Trim() + "%' ");
            sb.Append("  GROUP BY IndentNo        )t  )t1  where t1.StatusNew in ('OPEN','PARTIAL','CLOSE','REJECT') ");
            DataTable dtIndentDetails = StockReports.GetDataTable(sb.ToString());
            if (dtIndentDetails != null && dtIndentDetails.Rows.Count > 0)
            {
                grdIndentSearch.DataSource = dtIndentDetails;
                grdIndentSearch.DataBind();
                ViewState["IndentDetail"] = dtIndentDetails;
                pnlSearch.Visible = true;
                pnlSave.Visible = false;
                lblMsg.Text = "";
            }
            else
            {
                grdIndentSearch.DataSource = null;
                grdIndentSearch.DataBind();
                ViewState["IndentDetail"] = null;
                pnlSearch.Visible = false;
                pnlSave.Visible = false;
                lblMsg.Text = "No Record Found";
                return;
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Error..";
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
    }

    protected void btnSN_Click(object sender, EventArgs e)
    {
        searchindentnew("'OPEN'");
        //Open
    }

    protected void grdIndentDetails_ItemCommand(object source, RepeaterCommandEventArgs e)
    {


        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        Repeater rptitems = (Repeater)e.Item.FindControl("grdItem");
        Repeater rptitemsgenric = (Repeater)e.Item.FindControl("grdItemGenric");
        if (opType == "SHOW")
        {
            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";

            DataTable dt = getStockItem(Util.GetString(e.CommandArgument));
            if (dt.Rows.Count > 0)
            {
                rptitems.DataSource = dt;
                rptitems.DataBind();
                rptitems.Visible = true;
                rptitemsgenric.DataSource = null;
                rptitemsgenric.DataBind();
                rptitemsgenric.Visible = false;
                decimal PendingQty = Util.GetDecimal(((Label)e.Item.FindControl("lblPendingQty")).Text);


                if (PendingQty > 0)
                {
                    foreach (RepeaterItem grItem in rptitems.Items)
                    {
                        decimal availQty1 = Util.GetDecimal(((Label)grItem.FindControl("lblAvailQty1")).Text);
                        if (PendingQty > 0)
                        {
                            if (PendingQty > Util.GetDecimal(((Label)grItem.FindControl("lblAvailQty1")).Text))
                            {

                                ((TextBox)grItem.FindControl("txtIssueQty1")).Text = Util.GetDecimal(((Label)grItem.FindControl("lblAvailQty1")).Text).ToString();
                                PendingQty = PendingQty - Util.GetDecimal(((Label)grItem.FindControl("lblAvailQty1")).Text);
                            }
                            else
                            {

                                ((TextBox)grItem.FindControl("txtIssueQty1")).Text = Util.GetDecimal(PendingQty).ToString();
                                PendingQty = PendingQty - Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                            }
                        }
                    }
                }

                ((CheckBox)e.Item.FindControl("chkSelect")).Checked = true;
            }
            else
            {
                DataRow dr = dt.NewRow();
                dr["ItemID"] = Util.GetString(e.CommandArgument);
                dt.Rows.Add(dr);
                dt.AcceptChanges();

                rptitemsgenric.DataSource = dt;
                rptitemsgenric.DataBind();
                rptitemsgenric.Visible = true;
                rptitems.DataSource = null;
                rptitems.DataBind();
                rptitems.Visible = false;
                ((CheckBox)e.Item.FindControl("chkSelect")).Checked = true;
            }
        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "SHOW";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus_in.gif";
            rptitemsgenric.DataSource = null;
            rptitemsgenric.DataBind();
            rptitemsgenric.Visible = false;
            rptitems.DataSource = null;
            rptitems.DataBind();
            rptitems.Visible = false;
            ((CheckBox)e.Item.FindControl("chkSelect")).Checked = false;
        }

        ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + ((ImageButton)e.CommandSource).ClientID + "';", true);
    }

    protected void grdIndentdtl_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string Itemname = ((Label)e.Row.FindControl("lblname")).Text;
            string ItemQty = ((Label)e.Row.FindControl("lblReqqty")).Text;
            string ItemUnittype = ((Label)e.Row.FindControl("lblUnittype")).Text;
            string Indentno = ((Label)e.Row.FindControl("lblIndentno")).Text;

            if (e.Row.RowIndex >= 1)
            {
                string Previousname = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblname")).Text;
                string PreviousQty = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblReqqty")).Text;
                string PreviousUnittype = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblUnittype")).Text;
                string PreviousIndentno = ((Label)grdIndentdtl.Rows[e.Row.RowIndex - 1].FindControl("lblIndentno")).Text;

                if (Itemname == Previousname && ItemQty == PreviousQty && ItemUnittype == PreviousUnittype && Indentno == PreviousIndentno)
                {
                    ((Label)e.Row.FindControl("lblItemname")).Text = "";
                    ((Label)e.Row.FindControl("lblitemIndentNo")).Text = "";
                    ((Label)e.Row.FindControl("lblItemUnitType")).Text = "";
                    ((Label)e.Row.FindControl("lblItemQty")).Text = "";
                }
            }
        }
    }

    protected void grdItem_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        GridView grdItemNew = (GridView)e.Item.FindControl("grdItemNew");

        if (opType == "SHOW")
        {
            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";

            DataTable dt = getStockItemgenric(Util.GetString(e.CommandArgument));
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    grdItemNew.DataSource = dt;
                    grdItemNew.DataBind();
                    grdItemNew.Visible = true;
                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
                }
                else
                {
                    grdItemNew.DataSource = null;
                    grdItemNew.DataBind();
                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
                }
            }
            else
            {
                grdItemNew.DataSource = null;
                grdItemNew.DataBind();
                ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
            }
        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "SHOW";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus_in.gif";
            grdItemNew.DataSource = null;
            grdItemNew.DataBind();
            grdItemNew.Visible = false;
        }
    }

    protected void grdItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.AntiqueWhite;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew1")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.LightYellow;
            }
        }
    }

    protected void grdItemGenric_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
        GridView grdItemNewgenric = (GridView)e.Item.FindControl("grdItemNewgenric");

        if (opType == "SHOW")
        {
            ((ImageButton)e.CommandSource).AlternateText = "Hide";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";

            DataTable dt = getStockItemgenric(Util.GetString(e.CommandArgument));

            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    grdItemNewgenric.DataSource = dt;
                    grdItemNewgenric.DataBind();
                    grdItemNewgenric.Visible = true;

                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
                }
                else
                {
                    grdItemNewgenric.DataSource = null;
                    grdItemNewgenric.DataBind();
                    ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;
                }
            }
            else
            {
                grdItemNewgenric.DataSource = null;
                grdItemNewgenric.DataBind();
                ((CheckBox)e.Item.NamingContainer.Parent.FindControl("chkSelect")).Checked = true;

            }
        }
        else
        {
            ((ImageButton)e.CommandSource).AlternateText = "SHOW";
            ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus_in.gif";
            grdItemNewgenric.DataSource = null;
            grdItemNewgenric.DataBind();
            grdItemNewgenric.Visible = false;
        }
    }

    protected void gvGRN_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "AView")
        {
            //string stttt = Util.GetString(e.CommandArgument).Split('#')[1];
            ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByText(Util.GetString(e.CommandArgument).Split('#')[1]));
            txtIndentNo.Text = Util.GetString(e.CommandArgument).Split('#')[0];
            ViewState["Indent_Dpt"] = Util.GetString(e.CommandArgument).Split('#')[0] + "#" + Util.GetString(e.CommandArgument).Split('#')[1];
            BindIndentDetails(Util.GetString(e.CommandArgument).Split('#')[1], Util.GetString(e.CommandArgument).Split('#')[0], Util.GetString(e.CommandArgument).Split('#')[2], Util.GetString(e.CommandArgument).Split('#')[5].ToString());

            ddlDepartment.SelectedIndex = ddlDepartment.Items.IndexOf(ddlDepartment.Items.FindByText(Util.GetString(e.CommandArgument).Split('#')[1]));
            lblDepartment.Text = Util.GetString(e.CommandArgument).Split('#')[3].ToString();
            lblUserName.Text = Util.GetString(e.CommandArgument).Split('#')[4].ToString();

            lblIPDCaseType_ID.Text = Util.GetString(e.CommandArgument).Split('#')[6].ToString();
            lblRoom_ID.Text = Util.GetString(e.CommandArgument).Split('#')[7].ToString();
        }
        if (e.CommandName == "AViewDetail")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string status = Util.GetString(e.CommandArgument).Split('#')[1];

            StringBuilder sb1 = new StringBuilder();

            sb1.Append("SELECT sd.SoldUnits, id.IndentNo,id.ItemName,id.UnitType,id.ReceiveQty,id.ReqQty,id.RejectQty,id.TransactionID,om.Dose,om.Timing,om.Duration,");
            sb1.Append("  pm.PName,pm.PatientID,id.STATUS, DATE_FORMAT(sd.Date,'%d-%b-%y')    DATE,lm.ledgername     AS DeptFrom FROM f_indent_detail_patient id");
            sb1.Append("   INNER JOIN patient_master pm");
            sb1.Append("  ON pm.PatientID = id.PatientID INNER JOIN f_ledgermaster lm ON lm.LedgerNumber = id.Deptfrom");
            sb1.Append("  left join orderset_medication om on om.IndentNo=id.IndentNo AND om.MedicineID=id.ItemId");
            sb1.Append("  LEFT OUTER JOIN f_salesdetails sd ON sd.IndentNo=id.IndentNo AND sd.ItemID=id.ItemId AND sd.TrasactionTypeID='3'");
            sb1.Append("  WHERE id.IndentNo = '" + IndentNo + "' group by id.ItemID");

            DataTable dtnew = StockReports.GetDataTable(sb1.ToString());
            if (dtnew.Rows.Count > 0)
            {
                grdIndentdtl.DataSource = dtnew;
                grdIndentdtl.DataBind();
                mpe2.Show();
            }
            else
            {
                grdIndentdtl.DataSource = null;
                grdIndentdtl.DataBind();
                lblMsg.Text = "No Record Found";
            }
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + ((ImageButton)e.CommandSource).ClientID + "';", true);
    }

    protected void gvGRN_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatusNew")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.Green;
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            DateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            DateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            BindDepartment();
            pnlSave.Visible = false;
            pnlSearch.Visible = false;
        }

        DateFrom.Attributes.Add("readOnly", "true");
        DateTo.Attributes.Add("readOnly", "true");
    }

    private void BindDepartment()
    {
        string str = "select LedgerNumber,LedgerName from  f_ledgermaster where GroupID='DPT' order by LedgerName ";
        DataTable dt = StockReports.GetDataTable(str);

        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "LedgerName";
            ddlDepartment.DataValueField = "LedgerNumber";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("StockID");
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ServiceItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("BatchNumber");
        dt.Columns.Add("SubCategory");
        dt.Columns.Add("UnitType");
        dt.Columns.Add("DeptFrom");
        dt.Columns.Add("DeptTo");
        dt.Columns.Add("AvailQty", typeof(float));
        dt.Columns.Add("MRP", typeof(float));
        dt.Columns.Add("UnitPrice", typeof(float));
        dt.Columns.Add("Qty", typeof(float));
        dt.Columns.Add("IssueQty", typeof(float));
        dt.Columns.Add("Amount", typeof(float));
        dt.Columns.Add("id", typeof(int));
        dt.Columns.Add("IndentNo");
        dt.Columns.Add("ReqQty", typeof(float));
        dt.Columns.Add("ReceiveQty", typeof(float));
        dt.Columns.Add("RejectQty", typeof(float));

        return dt;
    }

    private DataTable getStockItem(string ItemId)
    {
        return StockReports.GetDataTable("select StockID,ItemID,ItemName,SaleTaxPer,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,(InitialCount-ReleasedCount)AvailQty,SubCategoryID,UnitType,IsExpirable FROM f_stock where ItemID='" + ItemId + "' and (InitialCount-ReleasedCount)>0 and Ispost=1 and DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and MedExpiryDate>curdate() order by stockid ");
    }

    private DataTable getStockItemgenric(string ItemId)
    {
        string Itemids = "";
        DataTable dtsalts1;

        dtsalts1 = StockReports.GetDataTable("SELECT saltid,Quantity FROM f_item_salt WHERE itemid='" + ItemId + "' ");
        dtsalts1.TableName = "firsttable";
        DataTable dtitemSalts = new DataTable();
        DataTable dtsalts2 = new DataTable();
        if (dtsalts1.Rows.Count > 0)
        {
            foreach (DataRow dr in dtsalts1.Rows)
            {
                dtitemSalts = StockReports.GetDataTable("SELECT distinct Itemid FROM f_item_salt WHERE saltid='" + dr["saltid"].ToString() + "' and itemid <>  '" + ItemId + "' ");
                break;
            }
        }
        if (dtitemSalts.Rows.Count > 0)
        {
            foreach (DataRow dr in dtitemSalts.Rows)
            {
                dtsalts2 = StockReports.GetDataTable("SELECT saltid,Quantity FROM f_item_salt WHERE itemid='" + dr["Itemid"].ToString() + "' ");
                if (dtsalts2.Rows.Count > 0)
                {
                    dtsalts2.TableName = "secondtable";
                    DataTable dt;
                    dt = getDifferentRecords(dtsalts1, dtsalts2);
                    if (dt.Rows.Count == 0)
                    {
                        if (Itemids == "")
                        {
                            Itemids = "'" + dr["itemid"] + "'";
                        }
                        else
                        {
                            Itemids = Itemids + "," + "'" + dr["itemid"] + "'";
                        }
                    }
                }
            }
        }

        if (Itemids != "")
        {
            return StockReports.GetDataTable("select st.StockID,st.ItemID,st.ItemName,st.SaleTaxPer,st.BatchNumber,st.UnitPrice,st.MRP,date_format(st.MedExpiryDate,'%d-%b-%y')MedExpiryDate,(st.InitialCount-st.ReleasedCount)AvailQty,st.SubCategoryID,st.UnitType,im.Type_ID,im.SubCategoryID,im.ServiceItemID,im.ToBeBilled,st.IsExpirable from f_stock st inner join f_itemmaster im on st.itemid=im.itemid where st.ItemID in (" + Itemids + ") and (st.InitialCount-st.ReleasedCount)>0 and st.Ispost=1 and st.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' and st.MedExpiryDate>curdate() order by st.stockid ");
        }
        else
            return null;
    }

    private void SaveIndentData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = (DataTable)ViewState["StockTransfer"];
            string BillNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select get_billno_store('" + ViewState["DeptLedgerNo"].ToString() + "','" + Session["CentreID"].ToString() + "')").ToString();
            if (BillNo == "")
            {
                lblMsg.Text = "Please Generate Store Issue Bill No.";
                return;
            }
            if (dt.Columns.Contains("BillNo") == false) dt.Columns.Add("BillNo");


            string IndentNo = "";
            string str_StockId = "";
            string LedTxnID = "";
            string Type_Id = "";
            string Itemid = "";
            int SalesNo = 0;
            int IssueQuantitycount = 0;
            //GST Changes
            decimal igstTaxPercent = 0, cgstTaxPercent = 0, sgstTaxPercent = 0;
            decimal igstTaxAmt = 0, cgstTaxAmt = 0, sgstTaxAmt = 0;


            //FOR EMERGENCY BILLING
            LedTxnID= Util.GetString(lblLedgerTransactionNo.Text);


            foreach (RepeaterItem ri in grdIndentDetails.Items)
            {
                if (((CheckBox)ri.FindControl("chkSelect")).Checked)
                {
                    string GenricItemid = ((Label)ri.FindControl("lblItemID")).Text.ToString();
                    Repeater grdItem = (Repeater)ri.FindControl("grdItem");
                    Repeater grdItemGenric = (Repeater)ri.FindControl("grdItemGenric");

                    float ReqQty = 0f, ReceivedQty = 0f, RejectedQty = 0f, DeptAvailQty = 0f, AvailQty = 0f, PendingQty = 0f, Reject = 0f;

                    IndentNo = Util.GetString(((Label)ri.FindControl("lblIndentNo")).Text.Trim());
                    Type_Id = Util.GetString(((Label)ri.FindControl("lblType_ID")).Text);
                    Itemid = Util.GetString(((Label)ri.FindControl("lblItemID")).Text);

                    ReqQty = Util.GetFloat(((Label)ri.FindControl("lblRequestedQty")).Text);
                    ReceivedQty = Util.GetFloat(((Label)ri.FindControl("lblIssuedQty")).Text);
                    RejectedQty = Util.GetFloat(((Label)ri.FindControl("lblRejectedQty")).Text);
                    DeptAvailQty = Util.GetFloat(((Label)ri.FindControl("lblDeptAvailQty")).Text);
                    AvailQty = Util.GetFloat(((Label)ri.FindControl("lblAvailQty")).Text);
                    PendingQty = Util.GetFloat(((Label)ri.FindControl("lblPendingQty")).Text);
                    Reject = Util.GetFloat(((TextBox)ri.FindControl("txtReject")).Text);

                    SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select Get_SalesNo('3','" + AllGlobalFunction.MedicalStoreID + "','" + Session["CentreID"].ToString() + "') "));
                    if (SalesNo == 0)
                    {
                        lblMsg.Text = "Please Generate Store Sales No.";
                        return;
                    }
                    string str = "select LedgerNumber from f_ledgermaster where LedgerUserID='" + lblRegistrationNo.Text.ToString() + "' and GroupID='PTNT' ";
                    string LedgerNumber = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, str));
                    ViewState.Add("LedgerNumber", LedgerNumber);

                    DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(lblTransactionID.Text.ToString(), con);  //Niraj ISHHI Remove
                    if (grdItem.Items.Count > 0)
                    {
                        foreach (RepeaterItem grItem in grdItem.Items)
                        {
                            GridView grdItemNew = (GridView)grItem.FindControl("grdItemNew");
                            if (grdItemNew != null)
                            {
                                if (grdItemNew.Rows.Count > 0)
                                {
                                    foreach (GridViewRow grItemNew in grdItemNew.Rows)
                                    {
                                        Type_Id = Util.GetString(((Label)grItemNew.FindControl("lblType_IDnew")).Text);
                                        Itemid = Util.GetString(((Label)grItemNew.FindControl("lblItemIDnew")).Text);
                                        if (Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) > 0)
                                        {
                                            if (LedTxnID == "")
                                            {
                                                //Insert into f_LedgerTransaction Single row effect
                                                Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                                                objLedTran.LedgerNoCr = LedgerNumber;
                                                objLedTran.LedgerNoDr = "STO00001";
                                                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                //objLedTran.GrossAmount = Util.GetFloat(dtItem.Compute("sum(Amount)", ""));
                                                //objLedTran.NetAmount = Util.GetFloat(dtItem.Compute("sum(Amount)", ""));
                                                objLedTran.TransactionID = lblTransactionID.Text.ToString().Trim(); //Niraj ISHHI Remove
                                                objLedTran.TypeOfTnx = "Sales";
                                                objLedTran.PanelID = Util.GetInt(lblPanelId.Text.ToString());
                                                objLedTran.PatientID = lblRegistrationNo.Text.ToString();
                                                objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                                                objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                                                // objLedTran.IndentNo = IndentNo;
                                                objLedTran.TransactionType_ID = 3;
                                                objLedTran.BillNo = BillNo;
                                                objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                objLedTran.PatientType = lblPatientType.Text.Trim();
                                                objLedTran.IpAddress = All_LoadData.IpAddress();
                                                objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                                objLedTran.UserID = ViewState["ID"].ToString();
                                                LedTxnID = objLedTran.Insert();

                                                if (LedTxnID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                            }


                                            //---------------- Insert into Ledger Trans Details Table Multiple Row Effect-----------

                                            str_StockId = ((Label)grItemNew.FindControl("lblStockIDnew")).Text;

                                            // Modify on 29-06-2017 - For GST
                                            // string stt = "select StockID,ItemID,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                                            string stt = "select StockID,ItemID,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";

                                            DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                            if (dtResult != null && dtResult.Rows.Count > 0)
                                            {
                                                int i = 0;
                                                string sql = "select if(InitialCount < (ReleasedCount+" + ((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //******************************************************** Ankush 03-07-2013***************************************************

                                                string sqlind = "SELECT   ReqQty-(ReceiveQty+RejectQty) FROM f_indent_detail_patient WHERE indentno='" + IndentNo + "' AND itemid= '" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "' ";
                                                int RemQty = Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind));
                                                int AvlQty = RemQty - Util.GetInt(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                if (AvlQty < 0)
                                                {
                                                    DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                                                    foreach (DataRow dr in DtIndent.Rows)
                                                    {
                                                        if (Util.GetString(dr["Itemid"]) == Util.GetString(dtResult.Rows[i]["ItemID"]))
                                                            dr["PendingQty"] = RemQty;
                                                    }
                                                    DtIndent.AcceptChanges();
                                                    grdIndentDetails.DataSource = DtIndent;
                                                    grdIndentDetails.DataBind();
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //*********************************************************************************************************************

                                                StringBuilder sb = new StringBuilder();
                                                sb.Append("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,TransactionID,IndentType,GenricType,OLDItemID,CentreID,Hospital_Id,PatientID)  ");
                                                sb.Append("values('" + IndentNo + "','" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "','" + Util.GetString(dtResult.Rows[i]["ItemName"]) + "'," + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "," + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + "");
                                                sb.Append(",'" + Util.GetString(dtResult.Rows[i]["UnitType"]) + "','" + ddlDepartment.SelectedValue + "','" + ViewState["DeptLedgerNo"].ToString() + "','STO00001','genric Item issue','" + ViewState["ID"].ToString() + "','" + lblTransactionID.Text.ToString() + "','Normal','GENRIC','" + GenricItemid + "','" + Session["CentreID"].ToString() + "','" + Session["HOSPID"].ToString() + "','" + lblRegistrationNo.Text.ToString() + "') ");

                                                string strIndent = "update f_indent_detail_patient set RejectQty = RejectQty + " + Util.GetFloat(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text) + ",RejectBy='" + ViewState["ID"].ToString() + "',RejectReason='Genric Item Issued' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptfrom='" + ddlDepartment.SelectedItem.Value + "'";

                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent);
                                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(Tranx);
                                                objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                                                objLTDetail.LedgerTransactionNo = LedTxnID;
                                                objLTDetail.ItemID = Itemid;
                                                objLTDetail.SubCategoryID = Util.GetString(((Label)grItemNew.FindControl("lblSubCategorynew")).Text);
                                                objLTDetail.TransactionID =  lblTransactionID.Text.ToString();
                                                objLTDetail.Rate = Util.GetDecimal(((Label)grItemNew.FindControl("lblMRPnew")).Text);
                                                objLTDetail.Quantity = Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                objLTDetail.StockID = ((Label)grItemNew.FindControl("lblStockIDnew")).Text;
                                                objLTDetail.Type_ID = Type_Id;
                                                objLTDetail.ServiceItemID = ((Label)grItemNew.FindControl("lblServiceItemIdnew")).Text;
                                                objLTDetail.ToBeBilled = Util.GetInt(((Label)grItemNew.FindControl("lblToBeBillednew")).Text);
                                                if (Util.GetBoolean(StockReports.ToBeBilled(objLTDetail.ItemID)))
                                                    objLTDetail.IsVerified = 1;
                                                else
                                                    objLTDetail.IsVerified = 3;
                                                objLTDetail.ItemName = Util.GetString(((Label)grItemNew.FindControl("lblItemNamenew")).Text);
                                                objLTDetail.UserID = ViewState["ID"].ToString();
                                                objLTDetail.EntryDate = DateTime.Now;
                                                objLTDetail.SubCategoryID = Util.GetString(((Label)grItemNew.FindControl("lblSubCategorynew")).Text);
                                                //	objLTDetail.Amount = Util.GetDecimal(((Label)grItemNew.FindControl("lblMRPnew")).Text) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(objLTDetail.SubCategoryID), con));
                                                objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, Util.GetInt(lblPanelId.Text.ToString()));
                                                objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                                                objLTDetail.IpAddress = All_LoadData.IpAddress();
                                                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                                                objLTDetail.Type = "I";
                                                objLTDetail.medExpiryDate = Util.GetDateTime(dtResult.Rows[0]["MedExpiryDate"].ToString());
                                                objLTDetail.BatchNumber = dtResult.Rows[0]["BatchNumber"].ToString();
                                                objLTDetail.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();

                                                objLTDetail.unitPrice = Util.GetDecimal(dtResult.Rows[0]["UnitPrice"]);
                                                objLTDetail.MACAddress = All_LoadData.macAddress();
                                                objLTDetail.StoreLedgerNo = "STO00001";
                                                objLTDetail.IsExpirable = Util.GetInt(dtResult.Rows[0]["IsExpirable"]);
                                                objLTDetail.TransactionType_ID = 3;
                                                objLTDetail.DoctorID = lblDoctorID.Text.Trim();
                                                //	objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                objLTDetail.IPDCaseType_ID = lblIPDCaseType_ID.Text.Trim();
                                                objLTDetail.Room_ID = lblRoom_ID.Text;
                                                objLTDetail.VerifiedDate = DateTime.Now;
                                                objLTDetail.VarifiedUserID = ViewState["ID"].ToString();
                                                if (dtPkg != null && dtPkg.Rows.Count > 0)
                                                {
                                                    int iCtr = 0;
                                                    foreach (DataRow drPkg in dtPkg.Rows)
                                                    {
                                                        if (iCtr == 0)
                                                        {
                                                            DataTable dtPkgDetl = new DataTable();


                                                            dtPkgDetl = StockReports.ShouldSendToIPDPackage( lblTransactionID.Text.ToString(), drPkg["PackageID"].ToString(), Itemid, Util.GetDecimal(Util.GetDecimal(((Label)grItemNew.FindControl("lblMRPnew")).Text) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text)), Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text), con);

                                                            if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                                            {
                                                                if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                                                {
                                                                    objLTDetail.Amount = 0;
                                                                    objLTDetail.IsPackage = 1;
                                                                    objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                                                    objLTDetail.NetItemAmt = 0;

                                                                    iCtr = 1;
                                                                }
                                                                else
                                                                {
                                                                    objLTDetail.Amount = (Util.GetDecimal(((Label)grItemNew.FindControl("lblMRPnew")).Text) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text)) - objLTDetail.DiscAmt;
                                                                    objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                                    iCtr = 1;
                                                                }
                                                            }
                                                            else
                                                            {
                                                                objLTDetail.Amount = (Util.GetDecimal(((Label)grItemNew.FindControl("lblMRPnew")).Text) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text)) - objLTDetail.DiscAmt;
                                                                objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                                iCtr = 1;
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    objLTDetail.Amount = (Util.GetDecimal(((Label)grItemNew.FindControl("lblMRPnew")).Text) * Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text)) - objLTDetail.DiscAmt;
                                                    objLTDetail.NetItemAmt = objLTDetail.Amount;

                                                }
                                                objLTDetail.PurTaxPer = Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"]);
                                                if (Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"]) > 0)
                                                    objLTDetail.PurTaxAmt = Util.GetDecimal(Util.GetDecimal(objLTDetail.Amount) * Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"])) / 100;
                                                else
                                                    objLTDetail.PurTaxAmt = 0;
                                                // Add new on 29-06-2017 - For GST
                                                igstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["IGSTPercent"]);
                                                cgstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["CGSTPercent"]);
                                                sgstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["SGSTPercent"]);

                                                decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstTaxPercent + cgstTaxPercent + sgstTaxPercent);

                                                igstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * igstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                cgstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * cgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                sgstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * sgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);

                                                objLTDetail.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                                objLTDetail.IGSTPercent = igstTaxPercent;
                                                objLTDetail.CGSTPercent = cgstTaxPercent;
                                                objLTDetail.SGSTPercent = sgstTaxPercent;
                                                objLTDetail.IGSTAmt = igstTaxAmt;
                                                objLTDetail.CGSTAmt = cgstTaxAmt;
                                                objLTDetail.SGSTAmt = sgstTaxAmt;
                                                if (chkDischargeMedicine.Checked)
                                                {
                                                    objLTDetail.IsDischargeMedicine = 1;
                                                }
                                                else
                                                {
                                                    objLTDetail.IsDischargeMedicine = 0;
                                                }
                                                objLTDetail.typeOfTnx = "Sales";
                                                int ID = objLTDetail.Insert();

                                                Sales_Details ObjSales = new Sales_Details(Tranx);
                                                ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                ObjSales.LedgerNumber = LedgerNumber;
                                                ObjSales.DepartmentID = "STO00001";
                                                ObjSales.ItemID = Itemid;
                                                ObjSales.StockID = Util.GetString(((Label)grItemNew.FindControl("lblStockIDnew")).Text);
                                                ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text);
                                                ObjSales.PerUnitBuyPrice = Util.GetDecimal(((Label)grItemNew.FindControl("lblUnitPricenew")).Text);
                                                ObjSales.PerUnitSellingPrice = Util.GetDecimal(((Label)grItemNew.FindControl("lblMRPnew")).Text);
                                                ObjSales.Date = DateTime.Now;
                                                ObjSales.Time = DateTime.Now;
                                                ObjSales.IsReturn = 0;
                                                ObjSales.LedgerTransactionNo = LedTxnID;
                                                ObjSales.TrasactionTypeID = 3;
                                                ObjSales.IsService = "NO";
                                                ObjSales.IndentNo = IndentNo;
                                                ObjSales.SalesNo = SalesNo;
                                                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                ObjSales.UserID = ViewState["ID"].ToString();
                                                ObjSales.PatientID = lblRegistrationNo.Text.ToString();
                                                ObjSales.Type_ID = Type_Id;
                                                ObjSales.ServiceItemID = ((Label)grItemNew.FindControl("lblServiceItemIdnew")).Text;
                                                ObjSales.ToBeBilled = Util.GetInt(((Label)grItemNew.FindControl("lblToBeBillednew")).Text);
                                                ObjSales.BillNoforGP = BillNo;
                                                ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                                ObjSales.IpAddress = All_LoadData.IpAddress();
                                                ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[0]["MedExpiryDate"].ToString());
                                                ObjSales.LedgerTnxNo = ID;

                                                ObjSales.BillNo = BillNo;
                                                ObjSales.TaxAmt = objLTDetail.PurTaxAmt;
                                                ObjSales.TaxPercent = objLTDetail.PurTaxPer;
                                                ObjSales.BatchNo = dtResult.Rows[0]["BatchNumber"].ToString();

                                                // Add new on 29-06-2017 - For GST
                                                ObjSales.IGSTPercent = igstTaxPercent;
                                                ObjSales.CGSTPercent = cgstTaxPercent;
                                                ObjSales.SGSTPercent = sgstTaxPercent;
                                                ObjSales.IGSTAmt = igstTaxAmt;
                                                ObjSales.CGSTAmt = cgstTaxAmt;
                                                ObjSales.SGSTAmt = sgstTaxAmt;
                                                ObjSales.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                                ObjSales.GSTType = Util.GetString(dtResult.Rows[0]["GSTType"]);
                                                //

                                                string SalesID = ObjSales.Insert();
                                                if (SalesID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //----Check Release Count in Stock Table---------------------
                                                str = "select if(InitialCount < (ReleasedCount+" + ((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text + "),0,1)CHK from f_stock where stockID='" + ((Label)grItemNew.FindControl("lblStockIDnew")).Text + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    lblMsg.Text = "Stock already issued please reopen the page";
                                                    return;
                                                }

                                                string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + ((TextBox)grItemNew.FindControl("txtIssueQtynew")).Text + " where StockID = '" + ((Label)grItemNew.FindControl("lblStockIDnew")).Text + "'";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);





                                                if (Resources.Resource.AllowFiananceIntegration == "1")
                                                {
                                                    string IsIntegrated = Util.GetString(EbizFrame.InsertEmergencyTransaction(Util.GetInt(LedTxnID), "", "R","", Tranx));
                                                    if (IsIntegrated == "0")
                                                    {
                                                        Tranx.Rollback();
                                                        lblMsg.Text = "Error In Finance Integration Details";
                                                    }
                                                }


                                            }
                                        }
                                    }
                                }
                            }

                            if (Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text) > 0)
                            {
                                IssueQuantitycount += 1;
                                Type_Id = Util.GetString(((Label)ri.FindControl("lblType_ID")).Text);
                                Itemid = Util.GetString(((Label)ri.FindControl("lblItemID")).Text);
                                if (LedTxnID == "")
                                {
                                    //Insert into f_LedgerTransaction Single row effect
                                    Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                                    objLedTran.LedgerNoCr = LedgerNumber;
                                    objLedTran.LedgerNoDr = "STO00001";
                                    objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    //objLedTran.GrossAmount = Util.GetFloat(dtItem.Compute("sum(Amount)", ""));
                                    //objLedTran.NetAmount = Util.GetFloat(dtItem.Compute("sum(Amount)", ""));
                                    objLedTran.TransactionID =  lblTransactionID.Text.ToString();
                                    objLedTran.TypeOfTnx = "Sales";
                                    objLedTran.PanelID = Util.GetInt(lblPanelId.Text.ToString());
                                    objLedTran.PatientID = "" + lblRegistrationNo.Text.ToString();
                                    objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                                    objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                                    // objLedTran.IndentNo = IndentNo;
                                    objLedTran.TransactionType_ID = 3;
                                    objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                    objLedTran.BillNo = BillNo;
                                    objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                    objLedTran.PatientType = lblPatientType.Text.Trim();
                                    objLedTran.IpAddress = All_LoadData.IpAddress();
                                    objLedTran.UserID = ViewState["ID"].ToString();
                                    LedTxnID = objLedTran.Insert();

                                    if (LedTxnID == string.Empty)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }
                                }

                                // BillNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select get_billno_store()").ToString();

                                //---------------- Insert into Ledger Trans Details Table Multiple Row Effect-----------

                                str_StockId = ((Label)grItem.FindControl("lblStockID")).Text;

                                // Modify on 29-06-2017 - For GST
                                // string stt = "select StockID,ItemID,Rate,DiscPer,DiscAmt,PurTaxPer,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,IsExpirable FROM f_stock  WHERE DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                                string stt = "select StockID,ItemID,Rate,DiscPer,DiscAmt,PurTaxPer,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,IsExpirable,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType FROM f_stock  WHERE DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";

                                DataTable dtResult = MySqlHelper.ExecuteDataset(con, CommandType.Text, stt).Tables[0];
                                if (dtResult != null && dtResult.Rows.Count > 0)
                                {
                                    string sql = "select if(InitialCount < (ReleasedCount+" + ((TextBox)grItem.FindControl("txtIssueQty1")).Text + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                    {
                                        Tranx.Rollback();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }

                                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(Tranx);
                                    objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                                    objLTDetail.LedgerTransactionNo = LedTxnID;
                                    objLTDetail.ItemID = Itemid;
                                    objLTDetail.SubCategoryID = Util.GetString(((Label)grItem.FindControl("lblSubCategory")).Text);
                                    objLTDetail.TransactionID =  lblTransactionID.Text.ToString();
                                    objLTDetail.Rate = Util.GetDecimal(((Label)grItem.FindControl("lblMRP1")).Text);
                                    objLTDetail.Quantity = Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    objLTDetail.StockID = ((Label)grItem.FindControl("lblStockID")).Text;
                                    //	objLTDetail.Amount = Util.GetDecimal(((Label)grItem.FindControl("lblMRP1")).Text) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    objLTDetail.Type_ID = Type_Id;
                                    objLTDetail.ServiceItemID = ((Label)ri.FindControl("lblServiceItemId")).Text;
                                    objLTDetail.ToBeBilled = Util.GetInt(((Label)ri.FindControl("lblToBeBilled")).Text);
                                    objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, Util.GetInt(lblPanelId.Text.ToString()));

                                    if (Util.GetBoolean(StockReports.ToBeBilled(objLTDetail.ItemID)))
                                        objLTDetail.IsVerified = 1;
                                    else
                                        objLTDetail.IsVerified = 3;

                                    objLTDetail.ItemName = Util.GetString(((Label)ri.FindControl("lblItemName")).Text);
                                    objLTDetail.UserID = ViewState["ID"].ToString();
                                    objLTDetail.EntryDate = DateTime.Now;
                                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                                    objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(objLTDetail.SubCategoryID), con));

                                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                                    objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                                    objLTDetail.Type = "I";
                                    objLTDetail.medExpiryDate = Util.GetDateTime(dtResult.Rows[0]["MedExpiryDate"].ToString());
                                    objLTDetail.BatchNumber = dtResult.Rows[0]["BatchNumber"].ToString();
                                    objLTDetail.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                    objLTDetail.PurTaxPer = Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"]);
                                    // -----------Package Entry----------
                                    if (dtPkg != null && dtPkg.Rows.Count > 0)
                                    {
                                        int iCtr = 0;
                                        foreach (DataRow drPkg in dtPkg.Rows)
                                        {
                                            if (iCtr == 0)
                                            {
                                                DataTable dtPkgDetl = new DataTable();

                                                dtPkgDetl = StockReports.ShouldSendToIPDPackage( lblTransactionID.Text.ToString(), drPkg["PackageID"].ToString(), Itemid, Util.GetDecimal(Util.GetDecimal(((Label)grItem.FindControl("lblMRP1")).Text) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text)), Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text), con);

                                                if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                                {
                                                    if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                                    {
                                                        objLTDetail.Amount = 0;
                                                        objLTDetail.IsPackage = 1;
                                                        objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                                        objLTDetail.NetItemAmt = 0;

                                                        iCtr = 1;
                                                    }
                                                    else
                                                    {
                                                        objLTDetail.Amount = (Util.GetDecimal(((Label)grItem.FindControl("lblMRP1")).Text) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text)) - objLTDetail.DiscAmt;
                                                        objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                        iCtr = 1;
                                                    }
                                                }
                                                else
                                                {
                                                    objLTDetail.Amount = (Util.GetDecimal(((Label)grItem.FindControl("lblMRP1")).Text) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text)) - objLTDetail.DiscAmt;
                                                    objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                    iCtr = 1;
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        objLTDetail.Amount = (Util.GetDecimal(((Label)grItem.FindControl("lblMRP1")).Text) * Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text)) - objLTDetail.DiscAmt;
                                        objLTDetail.NetItemAmt = objLTDetail.Amount;

                                    }
                                    if (Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"]) > 0)
                                        objLTDetail.PurTaxAmt = Util.GetDecimal(Util.GetDecimal(objLTDetail.Amount) * Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"])) / 100;
                                    else
                                        objLTDetail.PurTaxAmt = 0;
                                    objLTDetail.unitPrice = Util.GetDecimal(dtResult.Rows[0]["UnitPrice"]);
                                    objLTDetail.MACAddress = All_LoadData.macAddress();
                                    objLTDetail.StoreLedgerNo = "STO00001";
                                    objLTDetail.IsExpirable = Util.GetInt(dtResult.Rows[0]["IsExpirable"]);
                                    objLTDetail.TransactionType_ID = 3;
                                    objLTDetail.DoctorID = lblDoctorID.Text.Trim();
                                    //objLTDetail.NetItemAmt = objLTDetail.Amount;
                                    objLTDetail.IPDCaseType_ID = lblIPDCaseType_ID.Text.Trim();
                                    objLTDetail.Room_ID = lblRoom_ID.Text;
                                    objLTDetail.VerifiedDate = DateTime.Now;
                                    objLTDetail.VarifiedUserID = ViewState["ID"].ToString();
                                    // Add new on 29-06-2017 - For GST
                                    igstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["IGSTPercent"]);
                                    cgstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["CGSTPercent"]);
                                    sgstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["SGSTPercent"]);

                                    decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstTaxPercent + cgstTaxPercent + sgstTaxPercent);

                                    igstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * igstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
                                    cgstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * cgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
                                    sgstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * sgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);

                                    objLTDetail.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                    objLTDetail.IGSTPercent = igstTaxPercent;
                                    objLTDetail.CGSTPercent = cgstTaxPercent;
                                    objLTDetail.SGSTPercent = sgstTaxPercent;
                                    objLTDetail.IGSTAmt = igstTaxAmt;
                                    objLTDetail.CGSTAmt = cgstTaxAmt;
                                    objLTDetail.SGSTAmt = sgstTaxAmt;
                                    if (chkDischargeMedicine.Checked)
                                    {
                                        objLTDetail.IsDischargeMedicine = 1;
                                    }
                                    else
                                    {
                                        objLTDetail.IsDischargeMedicine = 0;
                                    }
                                    objLTDetail.typeOfTnx = "Sales";
                                    int ID = objLTDetail.Insert();

                                    if (ID == 0)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }

                                    Sales_Details ObjSales = new Sales_Details(Tranx);
                                    ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                    ObjSales.LedgerNumber = LedgerNumber;
                                    ObjSales.DepartmentID = "STO00001";
                                    ObjSales.ItemID = Itemid;
                                    ObjSales.StockID = Util.GetString(((Label)grItem.FindControl("lblStockID")).Text);
                                    ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                    ObjSales.PerUnitBuyPrice = Util.GetDecimal(((Label)grItem.FindControl("lblUnitPrice1")).Text);
                                    ObjSales.PerUnitSellingPrice = Util.GetDecimal(((Label)grItem.FindControl("lblMRP1")).Text);
                                    ObjSales.Date = DateTime.Now;
                                    ObjSales.Time = DateTime.Now;
                                    ObjSales.IsReturn = 0;
                                    ObjSales.LedgerTransactionNo = LedTxnID;
                                    ObjSales.TrasactionTypeID = 3;
                                    ObjSales.IsService = "NO";
                                    ObjSales.IndentNo = IndentNo;
                                    ObjSales.SalesNo = SalesNo;
                                    ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                    ObjSales.UserID = ViewState["ID"].ToString();
                                    ObjSales.PatientID = lblRegistrationNo.Text.ToString();
                                    ObjSales.Type_ID = Type_Id;
                                    ObjSales.ServiceItemID = ((Label)ri.FindControl("lblServiceItemID")).Text;
                                    ObjSales.ToBeBilled = Util.GetInt(((Label)ri.FindControl("lblToBeBilled")).Text);
                                    ObjSales.BillNoforGP = BillNo;
                                    ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                    ObjSales.IpAddress = All_LoadData.IpAddress();
                                    ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[0]["MedExpiryDate"].ToString());
                                    ObjSales.LedgerTnxNo = ID;
                                    ObjSales.BillNo = BillNo;
                                    ObjSales.TaxAmt = objLTDetail.PurTaxAmt;
                                    ObjSales.TaxPercent = objLTDetail.PurTaxPer;
                                    ObjSales.BatchNo = dtResult.Rows[0]["BatchNumber"].ToString();
                                    // Add new on 29-06-2017 - For GST
                                    ObjSales.IGSTPercent = igstTaxPercent;
                                    ObjSales.CGSTPercent = cgstTaxPercent;
                                    ObjSales.SGSTPercent = sgstTaxPercent;
                                    ObjSales.IGSTAmt = igstTaxAmt;
                                    ObjSales.CGSTAmt = cgstTaxAmt;
                                    ObjSales.SGSTAmt = sgstTaxAmt;
                                    ObjSales.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                    ObjSales.GSTType = Util.GetString(dtResult.Rows[0]["GSTType"]);
                                    //
                                    string SalesID = ObjSales.Insert();
                                    if (SalesID == string.Empty)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }

                                    //----Check Release Count in Stock Table---------------------
                                    str = "select if(InitialCount < (ReleasedCount+" + ((TextBox)grItem.FindControl("txtIssueQty1")).Text + "),0,1)CHK from f_stock where stockID='" + ((Label)grItem.FindControl("lblStockID")).Text + "'";
                                    if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                                    {
                                        Tranx.Rollback();
                                        Tranx.Dispose();
                                        con.Close();
                                        con.Dispose();
                                        lblMsg.Text = "Stock already issued please reopen the page";
                                        return;
                                    }

                                    string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + ((TextBox)grItem.FindControl("txtIssueQty1")).Text + " where StockID = '" + ((Label)grItem.FindControl("lblStockID")).Text + "'";
                                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);
                                }

                                //********************************************************03-07-2013***************************************************

                                string sqlind = "SELECT   (ReqQty-(ReceiveQty+RejectQty))Qty FROM f_indent_detail_patient WHERE indentno='" + IndentNo + "' AND itemid= '" + Itemid + "' ";
                                float RemQty = Util.GetFloat(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind));
                                float AvlQty = RemQty - Util.GetFloat(((TextBox)grItem.FindControl("txtIssueQty1")).Text);
                                if (AvlQty < 0)
                                {
                                    DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                                    foreach (DataRow dr in DtIndent.Rows)
                                    {
                                        if (Util.GetString(dr["Itemid"]) == Util.GetString(Itemid))
                                            dr["PendingQty"] = RemQty;
                                    }
                                    DtIndent.AcceptChanges();
                                    grdIndentDetails.DataSource = DtIndent;
                                    grdIndentDetails.DataBind();
                                    Tranx.Rollback();
                                    Tranx.Dispose();
                                    con.Close();
                                    con.Dispose();
                                    return;
                                }


                                string strIndentUpdate = "update f_indent_detail_patient set ReceiveQty=ReceiveQty+" + ((TextBox)grItem.FindControl("txtIssueQty1")).Text + "  where itemid='" + Itemid + "' and indentno='" + IndentNo + "' and IFNULL(genrictype,'')<>'GENRIC'  ";
                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndentUpdate);
                            }
                        }
                    }

                    if (grdItemGenric.Items.Count > 0)
                    {
                        foreach (RepeaterItem grItemGenric in grdItemGenric.Items)
                        {
                            GridView grdItemNewgenric = (GridView)grItemGenric.FindControl("grdItemNewgenric");
                            if (grdItemNewgenric != null)
                            {
                                if (grdItemNewgenric.Rows.Count > 0)
                                {
                                    foreach (GridViewRow grItemNewgenric in grdItemNewgenric.Rows)
                                    {
                                        Type_Id = Util.GetString(((Label)grItemNewgenric.FindControl("lblType_IDnewgenric")).Text);
                                        Itemid = Util.GetString(((Label)grItemNewgenric.FindControl("lblItemIDnewgenric")).Text);

                                        if (Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) > 0)
                                        {
                                            if (LedTxnID == "")
                                            {
                                                //Insert into f_LedgerTransaction Single row effect
                                                Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                                                objLedTran.LedgerNoCr = LedgerNumber;
                                                objLedTran.LedgerNoDr = "STO00001";
                                                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                //objLedTran.GrossAmount = Util.GetFloat(dtItem.Compute("sum(Amount)", ""));
                                                //objLedTran.NetAmount = Util.GetFloat(dtItem.Compute("sum(Amount)", ""));
                                                objLedTran.TransactionID =  lblTransactionID.Text.ToString();
                                                objLedTran.TypeOfTnx = "Sales";
                                                objLedTran.PanelID = Util.GetInt(lblPanelId.Text.ToString());
                                                objLedTran.PatientID = "" + lblRegistrationNo.Text.ToString();
                                                objLedTran.Date = Util.GetDateTime(DateTime.Now.ToShortDateString());
                                                objLedTran.Time = Util.GetDateTime(DateTime.Now.ToShortTimeString());
                                                // objLedTran.IndentNo = IndentNo;
                                                objLedTran.TransactionType_ID = 3;
                                                objLedTran.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                objLedTran.BillNo = BillNo;
                                                objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                                objLedTran.PatientType = lblPatientType.Text.Trim();
                                                objLedTran.IpAddress = All_LoadData.IpAddress();
                                                objLedTran.UserID = ViewState["ID"].ToString();
                                                LedTxnID = objLedTran.Insert();

                                                if (LedTxnID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }
                                            }

                                            // BillNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select get_billno_store()").ToString();

                                            //---------------- Insert into Ledger Trans Details Table Multiple Row Effect-----------

                                            str_StockId = ((Label)grItemNewgenric.FindControl("lblStockIDnewgenric")).Text;

                                            // Modify on 29-06-2017 - For GST
                                            // string stt = "select StockID,ItemID,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";
                                            string stt = "select StockID,ItemID,Rate,DiscPer,DiscAmt,PurTaxPer ,PurTaxAmt ,SaleTaxPer,SaleTaxAmt,TYPE ,Reusable ,IsBilled,itemname,BatchNumber,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%Y')MedExpiryDate,(InitialCount-ReleasedCount-PendingQty)AvailQty,SubCategoryID,UnitType,HSNCode,IGSTPercent,CGSTPercent,SGSTPercent,GSTType from f_stock  where DeptLedgerNo = '" + ViewState["DeptLedgerNo"].ToString() + "' and (InitialCount-ReleasedCount-PendingQty)>0 and Ispost=1 and Stockid='" + str_StockId + "'";

                                            DataTable dtResult = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, stt).Tables[0];
                                            if (dtResult != null && dtResult.Rows.Count > 0)
                                            {
                                                int i = 0;
                                                string sql = "select if(InitialCount < (ReleasedCount+" + ((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text + "),0,1)CHK from f_stock where stockID='" + str_StockId + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sql)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //********************************************************03-07-2013***************************************************

                                                string sqlind = "SELECT   ReqQty-(ReceiveQty+RejectQty) FROM f_indent_detail_patient WHERE indentno='" + IndentNo + "' AND itemid= '" + Itemid + "' ";
                                                int RemQty = Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, sqlind));
                                                int AvlQty = RemQty - Util.GetInt(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                if (AvlQty < 0)
                                                {
                                                    DataTable DtIndent = (DataTable)ViewState["StockTransfer"];
                                                    foreach (DataRow dr in DtIndent.Rows)
                                                    {
                                                        if (Util.GetString(dr["Itemid"]) == Util.GetString(Itemid))
                                                            dr["PendingQty"] = RemQty;
                                                    }
                                                    DtIndent.AcceptChanges();
                                                    grdIndentDetails.DataSource = DtIndent;
                                                    grdIndentDetails.DataBind();
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //*********************************************************************************************************************

                                                StringBuilder sb = new StringBuilder();
                                                sb.Append("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,ReceiveQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,TransactionID,IndentType,GenricType,OLDItemID,CentreID,Hospital_Id,PatientID)  ");
                                                sb.Append("values('" + IndentNo + "','" + Util.GetString(dtResult.Rows[i]["ItemID"]) + "','" + Util.GetString(dtResult.Rows[i]["ItemName"]) + "'," + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "," + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + "");
                                                sb.Append(",'" + Util.GetString(dtResult.Rows[i]["UnitType"]) + "','" + ddlDepartment.SelectedValue + "','" + ViewState["DeptLedgerNo"].ToString() + "','STO00001','genric Item issue','" + ViewState["ID"].ToString() + "','" + lblTransactionID.Text.ToString() + "','Normal','GENRIC','" + GenricItemid + "','" + Session["CentreID"].ToString() + "','" + Session["HOSPID"].ToString() + "','" + lblRegistrationNo.Text.ToString() + "') ");

                                                string strIndent = "update f_indent_detail_patient set RejectQty = RejectQty + " + Util.GetFloat(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text) + ",RejectBy='" + ViewState["ID"].ToString() + "',RejectReason='Genric Item Issued' where IndentNo = '" + ((Label)ri.FindControl("lblIndentNo")).Text + "' and itemid= '" + ((Label)ri.FindControl("lblItemID")).Text + "' and deptfrom='" + ddlDepartment.SelectedItem.Value + "'";

                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndent);
                                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                LedgerTnxDetail objLTDetail = new LedgerTnxDetail(Tranx);
                                                objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                                                objLTDetail.LedgerTransactionNo = LedTxnID;
                                                objLTDetail.ItemID = Itemid;
                                                objLTDetail.SubCategoryID = Util.GetString(((Label)grItemNewgenric.FindControl("lblSubCategorynewgenric")).Text);
                                                objLTDetail.TransactionID =  lblTransactionID.Text.ToString();
                                                objLTDetail.Rate = Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblMRPnewgenric")).Text);
                                                objLTDetail.Quantity = Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                objLTDetail.StockID = ((Label)grItemNewgenric.FindControl("lblStockIDnewgenric")).Text;
                                                //objLTDetail.Amount = Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblMRPnewgenric")).Text) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                objLTDetail.Type_ID = Type_Id;
                                                objLTDetail.ServiceItemID = ((Label)grItemNewgenric.FindControl("lblServiceItemIdnewgenric")).Text;
                                                objLTDetail.ToBeBilled = Util.GetInt(((Label)grItemNewgenric.FindControl("lblToBeBillednewgenric")).Text);
                                                objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(objLTDetail.SubCategoryID), con));
                                                objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, Util.GetInt(lblPanelId.Text.ToString()));

                                                if (Util.GetBoolean(StockReports.ToBeBilled(objLTDetail.ItemID)))
                                                    objLTDetail.IsVerified = 1;
                                                else
                                                    objLTDetail.IsVerified = 3;

                                                objLTDetail.ItemName = Util.GetString(((Label)grItemNewgenric.FindControl("lblItemNamenewgenric")).Text);
                                                objLTDetail.UserID = ViewState["ID"].ToString();
                                                objLTDetail.EntryDate = DateTime.Now;
                                                objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                                                objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());

                                                objLTDetail.IpAddress = All_LoadData.IpAddress();
                                                objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                                                objLTDetail.Type = "I";
                                                objLTDetail.medExpiryDate = Util.GetDateTime(dtResult.Rows[0]["MedExpiryDate"].ToString());
                                                objLTDetail.BatchNumber = dtResult.Rows[0]["BatchNumber"].ToString();
                                                objLTDetail.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                objLTDetail.PurTaxPer = Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"]);
                                                if (dtPkg != null && dtPkg.Rows.Count > 0)
                                                {
                                                    int iCtr = 0;
                                                    foreach (DataRow drPkg in dtPkg.Rows)
                                                    {
                                                        if (iCtr == 0)
                                                        {
                                                            DataTable dtPkgDetl = new DataTable();

                                                            dtPkgDetl = StockReports.ShouldSendToIPDPackage( lblTransactionID.Text.ToString(), drPkg["PackageID"].ToString(), Itemid, Util.GetDecimal(Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblMRPnewgenric")).Text) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text)), Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text), con);


                                                            if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                                            {
                                                                if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                                                {
                                                                    objLTDetail.Amount = 0;
                                                                    objLTDetail.IsPackage = 1;
                                                                    objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                                                    objLTDetail.NetItemAmt = 0;

                                                                    iCtr = 1;
                                                                }
                                                                else
                                                                {
                                                                    objLTDetail.Amount = (Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblMRPnewgenric")).Text) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text)) - objLTDetail.DiscAmt;
                                                                    objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                                    iCtr = 1;
                                                                }
                                                            }
                                                            else
                                                            {
                                                                objLTDetail.Amount = (Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblMRPnewgenric")).Text) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text)) - objLTDetail.DiscAmt;
                                                                objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                                iCtr = 1;
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    objLTDetail.Amount = (Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblMRPnewgenric")).Text) * Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text)) - objLTDetail.DiscAmt;
                                                    objLTDetail.NetItemAmt = objLTDetail.Amount;

                                                }
                                                if (Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"]) > 0)
                                                    objLTDetail.PurTaxAmt = Util.GetDecimal(Util.GetDecimal(objLTDetail.Amount) * Util.GetDecimal(dtResult.Rows[0]["PurTaxPer"])) / 100;
                                                else
                                                    objLTDetail.PurTaxAmt = 0;

                                                objLTDetail.unitPrice = Util.GetDecimal(dtResult.Rows[0]["UnitPrice"]);
                                                // objLTDetail.MACAddress = All_LoadData.macAddress();
                                                objLTDetail.StoreLedgerNo = "STO00001";
                                                objLTDetail.IsExpirable = Util.GetInt(dtResult.Rows[0]["IsExpirable"]);
                                                objLTDetail.TransactionType_ID = 3;
                                                objLTDetail.DoctorID = lblDoctorID.Text.Trim();
                                                //	objLTDetail.NetItemAmt = objLTDetail.Amount;
                                                objLTDetail.IPDCaseType_ID = lblIPDCaseType_ID.Text.Trim();
                                                objLTDetail.Room_ID = lblRoom_ID.Text;
                                                objLTDetail.VerifiedDate = DateTime.Now;
                                                objLTDetail.VarifiedUserID = ViewState["ID"].ToString();

                                                // Add new on 29-06-2017 - For GST
                                                igstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["IGSTPercent"]);
                                                cgstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["CGSTPercent"]);
                                                sgstTaxPercent = Util.GetDecimal(dtResult.Rows[0]["SGSTPercent"]);

                                                decimal nonTaxableRate = (objLTDetail.Rate * 100) / (100 + igstTaxPercent + cgstTaxPercent + sgstTaxPercent);

                                                igstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * igstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                cgstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * cgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);
                                                sgstTaxAmt = Math.Round(nonTaxableRate * objLTDetail.Quantity * sgstTaxPercent / 100, 4, MidpointRounding.AwayFromZero);

                                                objLTDetail.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                                objLTDetail.IGSTPercent = igstTaxPercent;
                                                objLTDetail.CGSTPercent = cgstTaxPercent;
                                                objLTDetail.SGSTPercent = sgstTaxPercent;
                                                objLTDetail.IGSTAmt = igstTaxAmt;
                                                objLTDetail.CGSTAmt = cgstTaxAmt;
                                                objLTDetail.SGSTAmt = sgstTaxAmt;
                                                if (chkDischargeMedicine.Checked)
                                                {
                                                    objLTDetail.IsDischargeMedicine = 1;
                                                }
                                                else
                                                {
                                                    objLTDetail.IsDischargeMedicine = 0;
                                                }
                                                objLTDetail.typeOfTnx = "Sales";
                                                int ID = objLTDetail.Insert();

                                                if (ID == 0)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                Sales_Details ObjSales = new Sales_Details(Tranx);
                                                ObjSales.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                                                ObjSales.LedgerNumber = LedgerNumber;
                                                ObjSales.DepartmentID = "STO00001";
                                                ObjSales.ItemID = Itemid;
                                                ObjSales.StockID = Util.GetString(((Label)grItemNewgenric.FindControl("lblStockIDnewgenric")).Text);
                                                ObjSales.SoldUnits = Util.GetDecimal(((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text);
                                                ObjSales.PerUnitBuyPrice = Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblUnitPricenewgenric")).Text);
                                                ObjSales.PerUnitSellingPrice = Util.GetDecimal(((Label)grItemNewgenric.FindControl("lblMRPnewgenric")).Text);
                                                ObjSales.Date = DateTime.Now;
                                                ObjSales.Time = DateTime.Now;
                                                ObjSales.IsReturn = 0;
                                                ObjSales.LedgerTransactionNo = LedTxnID;
                                                ObjSales.TrasactionTypeID = 3;
                                                ObjSales.IsService = "NO";
                                                ObjSales.IndentNo = IndentNo;
                                                ObjSales.SalesNo = SalesNo;
                                                ObjSales.DeptLedgerNo = ViewState["DeptLedgerNo"].ToString();
                                                ObjSales.UserID = ViewState["ID"].ToString();
                                                ObjSales.PatientID = lblRegistrationNo.Text.ToString();
                                                ObjSales.Type_ID = Type_Id;
                                                ObjSales.ServiceItemID = ((Label)grItemNewgenric.FindControl("lblServiceItemIdnewgenric")).Text;
                                                ObjSales.ToBeBilled = Util.GetInt(((Label)grItemNewgenric.FindControl("lblToBeBillednewgenric")).Text);
                                                ObjSales.BillNoforGP = BillNo;
                                                ObjSales.CentreID = Util.GetInt(Session["CentreID"].ToString());
                                                ObjSales.medExpiryDate = Util.GetDateTime(dtResult.Rows[0]["MedExpiryDate"].ToString());
                                                ObjSales.IpAddress = All_LoadData.IpAddress();
                                                ObjSales.BillNo = BillNo;
                                                ObjSales.LedgerTnxNo = ID;
                                                ObjSales.TaxPercent = Util.GetDecimal(objLTDetail.PurTaxPer);
                                                ObjSales.TaxAmt = Util.GetDecimal(objLTDetail.PurTaxAmt);
                                                ObjSales.BatchNo = dtResult.Rows[0]["BatchNumber"].ToString();
                                                // Add new on 29-06-2017 - For GST
                                                ObjSales.IGSTPercent = igstTaxPercent;
                                                ObjSales.CGSTPercent = cgstTaxPercent;
                                                ObjSales.SGSTPercent = sgstTaxPercent;
                                                ObjSales.IGSTAmt = igstTaxAmt;
                                                ObjSales.CGSTAmt = cgstTaxAmt;
                                                ObjSales.SGSTAmt = sgstTaxAmt;
                                                ObjSales.HSNCode = Util.GetString(dtResult.Rows[0]["HSNCode"]);
                                                ObjSales.GSTType = Util.GetString(dtResult.Rows[0]["GSTType"]);
                                                //
                                                string SalesID = ObjSales.Insert();
                                                if (SalesID == string.Empty)
                                                {
                                                    Tranx.Rollback();
                                                    Tranx.Dispose();
                                                    con.Close();
                                                    con.Dispose();
                                                    return;
                                                }

                                                //----Check Release Count in Stock Table---------------------
                                                str = "select if(InitialCount < (ReleasedCount+" + ((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text + "),0,1)CHK from f_stock where stockID='" + ((Label)grItemNewgenric.FindControl("lblStockIDnewgenric")).Text + "'";
                                                if (Util.GetInt(MySqlHelperNEw.ExecuteScalar(Tranx, CommandType.Text, str)) <= 0)
                                                {
                                                    Tranx.Rollback();
                                                    con.Close();
                                                    con.Dispose();
                                                    lblMsg.Text = "Stock already issued please reopen the page";
                                                    return;
                                                }

                                                string strStock = "update f_stock set ReleasedCount = ReleasedCount + " + ((TextBox)grItemNewgenric.FindControl("txtIssueQtynewgenric")).Text + " where StockID = '" + ((Label)grItemNewgenric.FindControl("lblStockIDnewgenric")).Text + "'";
                                                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strStock);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if (Util.GetFloat(((TextBox)ri.FindControl("txtReject")).Text) > 0)
                    {
                        string strIndentUpdatereject = "update f_indent_detail_patient set RejectQty = RejectQty + " + ((TextBox)ri.FindControl("txtReject")).Text + " ,RejectReason= '" + ((TextBox)ri.FindControl("txtReason")).Text + "',RejectBy='" + Session["ID"].ToString() + "' where itemid='" + Util.GetString(((Label)ri.FindControl("lblItemID")).Text) + "' and indentno='" + IndentNo + "' ";
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, strIndentUpdatereject);
                    }

                    string updateIndentStatus = "";
                    updateIndentStatus = " update f_indent_detail_patient a " +
                                      " inner join " +
                                      " ( select count(*) cnt from f_indent_detail_patient where  " +
                                      " ReqQty-ReceiveQty-RejectQty >0 and IndentNo='" + IndentNo + "' ) b " +
                                      " set STATUS = if( b.cnt >0,STATUS,'2' ) where a.IndentNo='" + IndentNo + "' ";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, updateIndentStatus);

                    str = "UPDATE f_ledgertransaction  lt INNER JOIN (SELECT SUM(Amount)Amount,LedgerTransactionNo FROM f_ledgertnxdetail WHERE LedgerTransactionNo = '" + LedTxnID + "' GROUP BY LedgerTransactionNo )ltd " +
                                       " SET lt.NetAmount = ltd.Amount, lt.GrossAmount = ltd.Amount,lt.IndentNo='" + IndentNo + "' WHERE lt.LedgerTransactionNo = '" + LedTxnID + "'";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);
                }
            }

            int notification = All_LoadData.updateNotification(IndentNo, "", Util.GetString(Session["RoleID"].ToString()), 28, Tranx);
            Tranx.Commit();
            lblMsg.Text = "Indent Issued Successfully";
            btnSearchIndent_Click1(btnSearchIndent, null);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location='" + Request.RawUrl + "';", true);
            
            string a = SalesNo.ToString() + "#" + BillNo.ToString();

            if (a != string.Empty)
            {
                string Sale = a.Split('#')[0];
                if (chkPrint.Checked)
                {
                    string BillNo1 = a.Split('#')[1];
                    if (IssueQuantitycount > 0)
                    {
                        if (BillNo1 != "")
                        {
                            string argmnt = "Sales";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('InternalStockTransferPatientRecipt.aspx?billno=" + BillNo1 + "&typeOftnx=" + argmnt + "&TID='" + "" + lblTransactionID.Text.ToString() + "');", true);
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "alert('Entry No. :'+'" + Sale + "');", true);
                    }
                    chkPrint.Checked = false;
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "alert('Entry No. :'+'" + Sale + "');", true);
                }
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            lblMsg.Text = "Error..";
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    #region Compare two DataTables and return a DataTable with DifferentRecords

    public DataTable getDifferentRecords(DataTable FirstDataTable, DataTable SecondDataTable)
    {
        //Create Empty Table
        DataTable ResultDataTable = new DataTable("ResultDataTable");

        //use a Dataset to make use of a DataRelation object
        using (DataSet ds = new DataSet())
        {
            //Add tables
            ds.Tables.AddRange(new DataTable[] { FirstDataTable.Copy(), SecondDataTable.Copy() });

            //Get Columns for DataRelation
            DataColumn[] firstColumns = new DataColumn[ds.Tables[0].Columns.Count];
            for (int i = 0; i < firstColumns.Length; i++)
            {
                firstColumns[i] = ds.Tables[0].Columns[i];
            }

            DataColumn[] secondColumns = new DataColumn[ds.Tables[1].Columns.Count];
            for (int i = 0; i < secondColumns.Length; i++)
            {
                secondColumns[i] = ds.Tables[1].Columns[i];
            }

            //Create DataRelation
            DataRelation r1 = new DataRelation(string.Empty, firstColumns, secondColumns, false);
            ds.Relations.Add(r1);

            DataRelation r2 = new DataRelation(string.Empty, secondColumns, firstColumns, false);
            ds.Relations.Add(r2);

            //Create columns for return table
            for (int i = 0; i < FirstDataTable.Columns.Count; i++)
            {
                ResultDataTable.Columns.Add(FirstDataTable.Columns[i].ColumnName, FirstDataTable.Columns[i].DataType);
            }

            //If FirstDataTable Row not in SecondDataTable, Add to ResultDataTable.
            ResultDataTable.BeginLoadData();
            foreach (DataRow parentrow in ds.Tables[0].Rows)
            {
                DataRow[] childrows = parentrow.GetChildRows(r1);
                if (childrows == null || childrows.Length == 0)
                    ResultDataTable.LoadDataRow(parentrow.ItemArray, true);
            }

            //If SecondDataTable Row not in FirstDataTable, Add to ResultDataTable.
            foreach (DataRow parentrow in ds.Tables[1].Rows)
            {
                DataRow[] childrows = parentrow.GetChildRows(r2);
                if (childrows == null || childrows.Length == 0)
                    ResultDataTable.LoadDataRow(parentrow.ItemArray, true);
            }
            ResultDataTable.EndLoadData();
        }

        return ResultDataTable;
    }

    #endregion Compare two DataTables and return a DataTable with DifferentRecords
}