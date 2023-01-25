using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web;
using System.Web.Script.Services;
using System.Collections.Generic;

public partial class Design_Store_Indent : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null)
            {
                string lblTransactionNo = Request.QueryString["TransactionID"].ToString();
                ViewState["ID"] = Session["ID"].ToString();
                ViewState["HOSPID"] = Session["HOSPID"].ToString();
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                ViewState["LoginType"] = Session["LoginType"].ToString();
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["PID"] = Request.QueryString["Patientid"].ToString();
                string TID = Request.QueryString["TransactionID"].ToString();
                //All_LoadData.bindDoctor(ddlDoctor);
                AllLoadData_IPD.BindDoctorIPD(ddlDoctor);
                //Checking if patient's bill No is generated or not
                // if generated then nothing to him can be prescribed
                AllQuery AQ = new AllQuery();
              
                DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);
                if (dtDischarge != null && dtDischarge.Rows.Count > 0)
                {
                    if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                    {
                        string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Patient Requisition can be possible...";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
                BindPatientDetails(TID);
                BindSubCategory();
                HIIDEN.Visible = false;
                AllLoadData_Store.bindStoreIndentDepartments(ddlDept,Util.GetInt( Session["RoleID"].ToString()), "Select");
                BindItem();
                AllLoadData_Store.bindTypeMaster(ddlRequestType);
                All_LoadData.bindMedicineQuan(ddlTime, "Time");
                All_LoadData.bindMedicineQuan(ddlDuration, "Duration");
                ddlRoute.DataSource = AllGlobalFunction.Route;
                ddlRoute.DataBind();
                ddlRoute1.DataSource = AllGlobalFunction.Route;
                ddlRoute1.DataBind();
                txtWord.Attributes.Add("onKeyPress", "doClick('" + btnWord.ClientID + "',event)");
                txtOtherMedicine.Enabled = false;
                }
         //   txtDuration.Attributes.Add("readOnly", "readOnly");
            }
        }


    private void BindItem()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT IM.Typename ItemName,CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,''),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route)ItemID");
        sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
        sb.Append(" inner join f_configrelation CR on SM.CategoryID = CR.CategoryID ");
        sb.Append(" LEFT JOIN (SELECT IF((InitialCount-ReleasedCount)>0,(InitialCount-ReleasedCount),0) ");
        sb.Append(" Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 AND DeptLedgerNo='" + ddlDept.SelectedValue + "' GROUP BY ITemID)st ON st.itemID = im.ItemID ");
        sb.Append(" LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID=" + lblPanelID.Text + " AND  pay.IsActive=1 WHERE CR.ConfigID = 11 AND im.IsActive=1 ");
        if (txtWord.Text.Trim() != string.Empty)
        {
            sb.Append(" AND im.TypeName like '%" + txtWord.Text.Trim().Replace("'", "''") + "%' ");
        }
        if (ddlSubcategory.SelectedValue != "ALL")
            sb.Append(" AND SM.SubCategoryID='" + ddlSubcategory.SelectedValue + "'");
        sb.Append(" order by IM.Typename ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "ItemName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
            ListBox1.SelectedIndex = 0;
        }
        else
            {
            ListBox1.Items.Clear();

            }
        }

    protected void btnAddItem_Click(object sender, EventArgs e)
    {
        try
        {
            if (chkOtherItems.Checked == true)
            {
                if (txtOtherMedicine.Text.Trim() == string.Empty)
                {
                    txtOtherMedicine.Focus();
                    lblMsg.Text = "Enter Other Medicine Name";
                    return;
                }
            }
            if (ddlDept.SelectedItem.Text == "Select")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
                ddlDept.Focus();
                return;
            }
            //if (txtDose.Text.Trim() == "")
            //{
            //    txtDose.Focus();
            //    lblMsg.Text = "Enter Medicine Dose";
            //    return;
            //}
            //if (ddlTime.SelectedItem.Text == "")
            //{
            //    ddlTime.Focus();
            //    lblMsg.Text = "Select Medicine Times";
            //    return;
            //}
            if (ListBox1.SelectedIndex >= 0)
            {
                if (txtTransferQty.Text.Trim() == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
                    return;
                }
                DataTable dt = null;
                if (ViewState["ItemList"] != null)
                {
                    dt = (DataTable)ViewState["ItemList"];
                }
                else
                {
                    dt = GetItemDataTable();
                }
                if (dt.Select("ItemID='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "'", "").Length == 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("  SELECT st.DeptQty,ind.IndentNo,DATE_FORMAT(ind.dtEntry,'%d-%b-%y')RaisedDate,ind.ReqQty,(ind.ReqQty-ind.ReceiveQty-ind.RejectQty)PendingQty, ");
                    sb.Append("  (SELECT NAME FROM employee_master WHERE employee_id=ind.UserId)Raisedby FROM ");
                    sb.Append("  f_indent_detail_patient ind LEFT JOIN (    ");
                    sb.Append("  SELECT SUM(st.InitialCount-st.ReleasedCount)DeptQty,st.ItemID FROM f_stock st WHERE st.ispost=1 AND (st.InitialCount-st.ReleasedCount)>0    ");
                    sb.Append("   AND st.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' AND   st.itemid='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' GROUP BY st.ITemID)st  ");
                    sb.Append("   ON st.itemid=ind.ItemId WHERE ind.itemid='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' AND  ind.DeptFrom='" + ViewState["DeptLedgerNo"].ToString() + "' AND ind.DeptTo='" + ddlDept.SelectedValue + "'  and  ind.TransactionID='" + ViewState["TID"].ToString() + "' ORDER BY ind.id DESC LIMIT 1   ");


                    DataTable dtnew = StockReports.GetDataTable(sb.ToString());

                    DataTable dtDeptQty = StockReports.GetDataTable("SELECT SUM(st.InitialCount-st.ReleasedCount)DeptQty,st.ItemID FROM f_stock st WHERE st.ispost=1 AND (st.InitialCount-st.ReleasedCount)>0  AND st.DeptLedgerNo='" + ViewState["DeptLedgerNo"].ToString() + "' AND  st.itemid='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' and st.MedExpiryDate>CURDATE() GROUP BY st.ITemID");

                    DataTable dtReqDeptQty = StockReports.GetDataTable("SELECT SUM(st.InitialCount-st.ReleasedCount)ReqDeptQty,st.ItemID FROM f_stock st WHERE st.ispost=1 AND (st.InitialCount-st.ReleasedCount)>0  AND st.DeptLedgerNo='" + ddlDept.SelectedItem.Value + "' AND st.itemid='" + ListBox1.SelectedValue.Split('#').GetValue(0) + "' and st.MedExpiryDate>CURDATE() GROUP BY st.ITemID");

                    DataRow dr = dt.NewRow();
                    if (rdoType.SelectedValue == "0")
                    {
                        dr["ItemID"] = ListBox1.SelectedValue.Split('#').GetValue(0);
                        dr["ItemName"] = ListBox1.SelectedItem.Text.Split('#').GetValue(0);
                    }
                    else if (rdoType.SelectedValue == "1")
                    {
                        dr["ItemID"] = ListBox1.SelectedValue.Split('#').GetValue(1);
                        dr["ItemName"] = ListBox1.SelectedItem.Text.Split('#').GetValue(1);
                    }
                    dr["Qty"] = txtTransferQty.Text;
                    dr["UnitType"] = ListBox1.SelectedItem.Value.Split('#').GetValue(3);
                   
                    dr["Dose"] = txtDose.Text.Trim();
                    dr["Times"] = ddlTime.SelectedItem.Text;
                    dr["Duration"] = System.DateTime.Now.AddDays(Util.GetDouble(ddlDuration.SelectedItem.Value)).ToString("yyyy-MM-dd");
                   // dr["Duration"] = ddlDuration.SelectedItem.Value;
                    dr["Narration"] = txtRemarks.Text.Trim();
                    if (ddlRoute.SelectedItem.Text != " ")
                        dr["Route"] = ddlRoute.SelectedItem.Text;
                    else
                        dr["Route"] = "";
                    dr["DurationDays"] = ddlDuration.SelectedItem.Text;
                    dr["DoctorID"] = ddlDoctor.SelectedItem.Value;
                    dr["DoctorName"] = ddlDoctor.SelectedItem.Text;
                    dr["MedStoreQty"] = Util.GetFloat(ListBox1.SelectedValue.Split('#').GetValue(2));

                    if (dtnew.Rows.Count > 0)
                    {
                        dr["ReqQty"] = Util.GetFloat(dtnew.Rows[0]["ReqQty"].ToString());
                        dr["PendingQty"] = Util.GetFloat(dtnew.Rows[0]["PendingQty"].ToString());
                        if (Util.GetFloat(dtnew.Rows[0]["PendingQty"].ToString()) > 0)
                        {
                            dr["Status"] = "true";
                        }
                        else
                        {
                            dr["Status"] = "false";
                        }
                        dr["Raisedby"] = Util.GetString(dtnew.Rows[0]["Raisedby"].ToString());
                        dr["RaisedDate"] = Util.GetString(dtnew.Rows[0]["RaisedDate"].ToString());
                        dr["IndentNo"] = Util.GetString(dtnew.Rows[0]["IndentNo"].ToString());
                    }
                    else
                    {
                        dr["ReqQty"] = 0;
                        dr["PendingQty"] = 0;
                        dr["Status"] = "false";
                        dr["Raisedby"] = "";
                        dr["RaisedDate"] = "";
                        dr["IndentNo"] = "";
                    }
                    if (dtDeptQty.Rows.Count > 0)
                    {
                        dr["DeptQty"] = Util.GetFloat(dtDeptQty.Rows[0]["DeptQty"].ToString());
                    }
                    else
                    {
                        dr["DeptQty"] = 0;
                    }
                    if (dtReqDeptQty.Rows.Count > 0)
                    {
                        dr["MedStoreQty"] = Util.GetFloat(dtReqDeptQty.Rows[0]["ReqDeptQty"].ToString());
                    }
                    else
                    {
                        dr["MedStoreQty"] = 0;
                    }
                    dt.Rows.Add(dr);
                    dt.AcceptChanges();
                    lblMsg.Text = "";
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM240','" + lblMsg.ClientID + "');", true);
                }
                ViewState["ItemList"] = dt;
                gvIssueItem.DataSource = dt;
                gvIssueItem.DataBind();
                txtInBetweenSearch.Text = "";
                txtInBetweenSearch.Focus();
                if (dt.Rows.Count > 0)
                {
                    txtTransferQty.Text = "";
                    txtDose.Text = "";
                    ddlTime.SelectedIndex = -1;
                    ddlRoute.SelectedIndex = -1;
                  // txtDuration.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    ddlDuration.SelectedIndex = -1;
                    txtRemarks.Text = "";
                    pnlHide.Visible = true;
                    pnlHide1.Visible = true;
                    ddlDept.Enabled = false;
                    }
                else
                {
                    pnlHide.Visible = false;
                    pnlHide1.Visible = false;
                    ddlDept.Enabled = true;
                    }

                txtWord.Text = "";
                txtWord.Focus();
            }
            else if (chkOtherItems.Checked == true)
            {
                if (txtTransferQty.Text.Trim() == "")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
                    return;
                }
                DataTable dt = null;
                if (ViewState["ItemList"] != null)
                {
                    dt = (DataTable)ViewState["ItemList"];
                }
                else
                {
                    dt = GetItemDataTable();
                }

                DataRow dr = dt.NewRow();
                dr["ItemID"] = "OTH001";
                dr["ItemName"] = txtOtherMedicine.Text.Trim();
                dr["Qty"] = txtTransferQty.Text;
                dr["UnitType"] = "Single";

                dr["Dose"] = txtDose.Text.Trim();
                dr["Times"] = ddlTime.SelectedItem.Text;
              //  dr["Duration"] = Util.GetDateTime(txtDuration.Text).ToString("yyyy-MM-dd");
                dr["Duration"] = System.DateTime.Now.AddDays(Util.GetDouble(ddlDuration.SelectedItem.Value)).ToString("yyyy-MM-dd");
                dr["Narration"] = txtRemarks.Text.Trim();
                if (ddlRoute.SelectedItem.Text != "Select")
                    dr["Route"] = ddlRoute.SelectedItem.Text;
                else
                    dr["Route"] = "";
                dr["DurationDays"] = ddlDuration.SelectedItem.Text;
                dr["DoctorID"] = ddlDoctor.SelectedItem.Value;
                dr["DoctorName"] = ddlDoctor.SelectedItem.Text;
                dr["MedStoreQty"] = 0;

                dr["ReqQty"] = 0;
                dr["PendingQty"] = 0;
                dr["Status"] = "false";
                dr["Raisedby"] = "";
                dr["RaisedDate"] = "";
                dr["IndentNo"] = "";
                dr["DeptQty"] = 0;

                dr["MedStoreQty"] = 0;
                dt.Rows.Add(dr);
                dt.AcceptChanges();
                lblMsg.Text = "";


                ViewState["ItemList"] = dt;
                gvIssueItem.DataSource = dt;
                gvIssueItem.DataBind();
                txtInBetweenSearch.Text = "";
                txtInBetweenSearch.Focus();
                if (dt.Rows.Count > 0)
                {
                    txtTransferQty.Text = "";
                    txtDose.Text = "";
                    ddlTime.SelectedIndex = -1;
                    ddlRoute.SelectedIndex = -1;
                   // txtDuration.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                    dr["Duration"] = ddlDuration.SelectedItem.Value;
                    txtRemarks.Text = "";
                    pnlHide.Visible = true;
                    pnlHide1.Visible = true;
                    txtOtherMedicine.Text = "";
                }
                else
                {
                    pnlHide.Visible = false;
                    pnlHide1.Visible = false;
                }

                txtWord.Text = "";
                txtWord.Focus();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM018','" + lblMsg.ClientID + "');", true);
                return;
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Quantity is too Large";
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return;
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (ViewState["ItemList"] != null)
            {
            if (ddlDept.SelectedItem.Text == "Select")
                {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM014','" + lblMsg.ClientID + "');", true);
                ddlDept.Focus();
                return;
            }
            if (lblTransactionNo.ToString() != "")
            {
                string IndentNo = "";
                DataTable dt = null;
                if (ViewState["ItemList"] != null)
                {
                    dt = (DataTable)ViewState["ItemList"];
                    MySqlConnection con = Util.GetMySqlCon();
                    con.Open();
                    MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
                    try
                    {
                        string EntryID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select ifnull(Max(EntryID),0)+1 ID from orderset_medication"));
                        IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_indent_no_patient('" + ddlDept.SelectedValue + "','" + Session["CentreID"].ToString() + "')").ToString();
                        if (IndentNo != "")
                        {
                            string ItemID = "";
                            string OtherIndentNo = "";
                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                StringBuilder sb = new StringBuilder();
                                if (dt.Rows[i]["ItemId"].ToString() != "OTH001")
                                {
                                    sb.Append("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,Narration,UserId,TransactionID,IndentType,CentreID,Hospital_Id,DoctorID,PatientID,IPDCaseType_ID,Room_ID)  ");
                                    sb.Append("values('" + IndentNo + "','" + dt.Rows[i]["ItemId"].ToString() + "','" + dt.Rows[i]["ItemName"].ToString() + "'," + Util.GetFloat(dt.Rows[i]["Qty"].ToString()) + "");
                                    sb.Append(",'" + dt.Rows[i]["UnitType"].ToString() + "','" + ViewState["DeptLedgerNo"].ToString() + "','" + ddlDept.SelectedValue + "','STO00001', ");
                                    sb.Append(" '" + ((Label)gvIssueItem.Rows[i].FindControl("lblNarration")).Text + "','" + ViewState["ID"].ToString() + "', ");
                                    sb.Append(" '" + Request.QueryString["TransactionID"].ToString() + "','" + ddlRequestType.SelectedItem.Text + "','" + Session["CentreID"].ToString() + "','" + Session["HOSPID"].ToString() + "','" + dt.Rows[i]["DoctorID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + lblIPDCaseType_ID.Text.Trim() + "','" + lblRoomID.Text.Trim() + "') ");

                                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                    {
                                        Tranx.Rollback();
                                        con.Close();
                                        con.Dispose();
                                        return;
                                    }

                                }

                                if (dt.Rows[i]["ItemId"].ToString() == "OTH001")
                                {
                                    OtherIndentNo = "OTH" + EntryID;
                                    ItemID = "OTH" + EntryID + i;
                                }
                                else
                                {
                                    ItemID = dt.Rows[i]["ItemId"].ToString();
                                    OtherIndentNo = IndentNo;
                                }

                                sb.Clear();
                                sb.Append(" Insert into orderset_medication(EntryID,TransactionID,PatientID,MedicineID,MedicineName,ReqQty,Dose,Timing,Duration,Remark,EntryBy,IndentNo,Route,DoctorID)values(");
                                sb.Append(" " + Util.GetInt(EntryID) + ",'" + Request.QueryString["TransactionID"].ToString() + "','" + ViewState["PID"].ToString() + "','" + ItemID + "','" + dt.Rows[i]["ItemName"].ToString() + "','" + Util.GetFloat(dt.Rows[i]["Qty"].ToString()) + "', ");
                                sb.Append(" '" + dt.Rows[i]["Dose"].ToString() + "','" + dt.Rows[i]["Times"].ToString() + "','" + dt.Rows[i]["Duration"].ToString() + "','" + dt.Rows[i]["Narration"].ToString() + "','" + ViewState["ID"].ToString() + "','" + OtherIndentNo + "','" + dt.Rows[i]["Route"].ToString() + "','" + dt.Rows[i]["DoctorID"].ToString() + "')");
                                if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                                {
                                    Tranx.Rollback();
                                    Tranx.Dispose();
                                    con.Close();
                                    con.Dispose();
                                    return;
                                }
                            }
                            int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + ddlDept.SelectedValue + "'"));
                            string notification = Notification_Insert.notificationInsert(28, IndentNo, Tranx, "", "", roleID);
                            if (notification == "")
                            {
                                Tranx.Rollback();
                                return;
                            }
                            Tranx.Commit();
                        }
                        else
                        {
                            lblMsg.Text = "Please Create Patient Indent No.";
                            return;
                        }
                    }

                    catch (Exception ex)
                    {
                        Tranx.Rollback();
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);

                    }
                    finally
                    {
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                    }

                    if (chkprint.Checked == true)
                    {
                        StringBuilder sb1 = new StringBuilder();
                        sb1.Append("select id.IndentNo,(rd.DeptName)DeptFrom,(rd1.DeptName)DeptTo,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,id.UnitType,id.Narration,id.isApproved, ");
                        sb1.Append("id.ApprovedBy,id.ApprovedReason,id.dtEntry,id.UserId,ConCat(em.Title,' ',em.Name)EmpName,CONCAT(pm.Title,' ',pm.PName)PatientName,Replace(pmh.TransactionID,'ISHHI','')TransactionID,id.IndentType from f_indent_detail_patient id inner  ");
                        sb1.Append("join f_rolemaster rd on id.DeptFrom=rd.DeptLedgerNo inner join f_rolemaster rd1  ");
                        sb1.Append("on id.DeptTo=rd1.DeptLedgerNo inner join employee_master em on id.UserId=em.Employee_ID INNER JOIN patient_medical_history pmh ON pmh.TransactionID=id.TransactionID INNER JOIN patient_master pm ON pmh.PatientID=pm.PatientID ");
                        sb1.Append("where indentNo='" + IndentNo + "' ");
                        DataSet ds = new DataSet();
                        ds.Tables.Add(StockReports.GetDataTable(sb1.ToString()).Copy());
                        //ds.WriteXmlSchema(@"c:/PatientNewIndent.xml");
                        Session["ds"] = ds;
                        Session["ReportName"] = "PatientNewIndent";
                        lblMsg.Text = "";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/Commonreport.aspx');", true);
                    }
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');", true);
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "location.href='../Store/Indent.aspx?TransactionID=" + Request.QueryString["TransactionID"].ToString() + "&Patientid=" + ViewState["PID"].ToString() + "';", true);
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM034','" + lblMsg.ClientID + "');", true);
                return;
            }
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM253','" + lblMsg.ClientID + "');", true);
            return;
        }
    }
    private DataTable GetItemDataTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("ItemID");
        dt.Columns.Add("ItemName");
        dt.Columns.Add("Qty", typeof(float));
        dt.Columns.Add("UnitType");
        dt.Columns.Add("MedStoreQty", typeof(float));
        dt.Columns.Add("DeptQty", typeof(float));
        dt.Columns.Add("ReqQty", typeof(float));
        dt.Columns.Add("PendingQty", typeof(float));
        dt.Columns.Add("Raisedby");
        dt.Columns.Add("RaisedDate");
        dt.Columns.Add("Status");
        dt.Columns.Add("IndentNo");
        dt.Columns.Add("AvgCon");
        dt.Columns.Add("Dose");
        dt.Columns.Add("Times");
        dt.Columns.Add("Duration");
        dt.Columns.Add("Narration");
        dt.Columns.Add("Route");
        dt.Columns.Add("DurationDays");
        dt.Columns.Add("DoctorID");
        dt.Columns.Add("DoctorName");
        return dt;
    }

    protected void gvIssueItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            int args = Util.GetInt(e.CommandArgument);

            DataTable dtItem = (DataTable)ViewState["ItemList"];
            dtItem.Rows[args].Delete();
            dtItem.AcceptChanges();
            gvIssueItem.DataSource = dtItem;
            gvIssueItem.DataBind();
            ViewState["ItemList"] = dtItem;
            if (dtItem.Rows.Count == 0)
            {
                pnlHide.Visible = false;
                pnlHide1.Visible = false;
                ddlDept.Enabled = true;
            }
            else
            {
                pnlHide.Visible = true;
                pnlHide1.Visible = true;
            }
        }
    }
    protected void grdPatient_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ASelect")
        {
            string TID = Util.GetString(e.CommandArgument);
            BindPatientDetails(TID);
        }
    }
    private void BindPatientDetails(string TransactionID)
    {
        try
        {
            AllQuery AQ = new AllQuery();

            DataTable dt = AQ.GetPatientIPDInformation("", TransactionID);
            ViewState["PatientDetail"] = dt as DataTable;
            if (dt != null && dt.Rows.Count > 0)
            {
                lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
                lblIPDCaseType_ID.Text = dt.Rows[0]["IPDCaseType_ID"].ToString();
                lblRoomID.Text = dt.Rows[0]["Room_ID"].ToString();
                lblDoctorID.Text = dt.Rows[0]["DoctorID"].ToString();
                ddlDoctor.SelectedIndex = ddlDoctor.Items.IndexOf(ddlDoctor.Items.FindByValue(dt.Rows[0]["DoctorID"].ToString()));
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }
    protected void btnWord_Click(object sender, EventArgs e)
    {
        if (txtWord.Text.Trim() != string.Empty)
        {
            BindItem();
            txtWord.Focus();
        }
    }
    private void BindSubCategory()
    {
        string strQuery = "";
        strQuery = " SELECT sc.Name GroupHead,sc.SubCategoryID FROM f_subcategorymaster sc ";
        strQuery += " INNER JOIN f_configrelation cf ON cf.CategoryID = sc.CategoryID ";
        strQuery += " WHERE sc.Active=1 AND cf.ConfigID IN ('11') ";
        strQuery += " ORDER BY sc.Name";
        ddlSubcategory.DataSource = StockReports.GetDataTable(strQuery);
        ddlSubcategory.DataTextField = "GroupHead";
        ddlSubcategory.DataValueField = "SubCategoryID";
        ddlSubcategory.DataBind();
        ddlSubcategory.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlSubcategory.SelectedIndex = 0;
    }
    protected void ddlSubcategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindItem();
    }
    [WebMethod]
    public static string LoadIndentMedicine(string TnxID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,IndentNo,DATE_FORMAT(dtEntry,'%d-%b-%y %h:%i %p')dtEntry FROM f_indent_detail_patient WHERE TransactionID='" + TnxID + "' GROUP BY dtentry ORDER BY dtentry ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod(EnableSession = true, Description = "Load Indent")]
    public static string LoadIndentItems(string IndentNo)
    {
        DataTable dt = StockReports.GetDataTable("SELECT osm.entryid ID,osm.reqqty quantity,im.typename NAME,im.ItemID,osm.indentno,osm.dose,osm.timing Times,DATE_FORMAT(osm.duration,'%d-%b-%y')duration,osm.Route,im.unittype,im.MedicineType FROM orderset_medication  osm INNER JOIN f_itemmaster im ON im.ItemID=osm.medicineid INNER JOIN f_indent_detail_patient idp ON idp.`IndentNo`=osm.`IndentNo`WHERE idp.`id`='" + IndentNo + "' ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true, Description = "Save Indent")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string InsertIndent(List<insert> Data)
    {
        string IndentNo = "";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string EntryID = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "Select ifnull(Max(EntryID),0)+1 ID from orderset_medication"));
            IndentNo = MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "select get_indent_no_patient('" + Data[0].Dept + "','" + HttpContext.Current.Session["CentreID"].ToString() + "')").ToString();
            if (IndentNo != "")
            {
                int count = Util.GetInt(0);
                string ItemID = "";
                string OtherIndentNo = "";
                string DurationDate = "";
                for (int i = 0; i < Data.Count; i++)
                {

                    StringBuilder sb = new StringBuilder();
                    DurationDate = Data[i].Duration;

                    sb.Append("insert into f_indent_detail_patient(IndentNo,ItemId,ItemName,ReqQty,UnitType,DeptFrom,DeptTo,StoreId,UserId,TransactionID,IndentType,CentreID,Hospital_Id,PatientID,DoctorID,IPDCaseType_ID,Room_ID)  ");
                    sb.Append("values('" + IndentNo + "','" + Data[i].ItemID + "','" + Data[i].MedicineName + "'," + Util.GetFloat(Data[i].Quantity) + "");
                    sb.Append(",'" + Data[i].UnitType + "','" + HttpContext.Current.Session["DeptLedgerNo"].ToString() + "','" + Data[i].Dept + "','STO00001', ");
                    sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "','" + Data[i].TID + "','" + Data[i].IndentType + "','" + HttpContext.Current.Session["CentreID"].ToString() + "', ");
                    sb.Append("'" + HttpContext.Current.Session["HOSPID"].ToString() + "','" + Data[i].PID + "','" + Data[i].DoctorID + "','" + Data[i].IPDCaseType_ID + "','" + Data[i].Room_ID + "') ");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                    count = 1;
                    ItemID = Data[i].ItemID;
                    OtherIndentNo = IndentNo;
                    sb.Clear();
                    DateTime DateDuration = Util.GetDateTime(System.DateTime.Now.AddDays(Util.GetDouble(Data[i].Duration.Split('#')[0])).ToString("yyyy-MM-dd"));
                    sb.Append(" Insert into orderset_medication(EntryID,TransactionID,PatientID,MedicineID,MedicineName,ReqQty,Dose,Timing,Duration,EntryBy,IndentNo,Route)values(");
                    sb.Append(" " + Util.GetInt(EntryID) + ",'" + Data[i].TID + "','" + Data[i].PID + "','" + ItemID + "','" + Data[i].MedicineName + "','" + Util.GetFloat(Data[i].Quantity) + "', ");
                    sb.Append(" '" + Data[i].Dose + "','" + Data[i].Time + "','" + DateDuration.ToString("yyyy-MM-dd") + "','" + HttpContext.Current.Session["ID"].ToString() + "','" + OtherIndentNo + "','" + Data[i].Route + "')");
                    if (MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString()) == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return "0";
                    }
                }
                int roleID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ID FROM f_rolemaster WHERE DeptLedgerNo='" + Data[0].Dept + "'"));
                string notification = Notification_Insert.notificationInsert(28, IndentNo, Tranx, "", "", roleID);
                if (notification == "")
                {
                    Tranx.Rollback();
                    return "";
                }
                Tranx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

        return "0";
    }
    public class insert
    {
        public string ItemID { get; set; }
        public string Dose { get; set; }
        public string Time { get; set; }
        public string Duration { get; set; }
        public string Route { get; set; }
        public string TID { get; set; }
        public string PID { get; set; }
        public string Doc { get; set; }
        public string LnxNo { get; set; }
        public string MedicineName { get; set; }
        public string Dept { get; set; }
        public string Quantity { get; set; }
        public string UnitType { get; set; }
       
        public string IndentType { get; set; }
        public string DoctorID { get; set; }
        public string IPDCaseType_ID { get; set; }
        public string Room_ID { get; set; }

    }
    protected void rdoType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoType.SelectedValue == "0")
        {
            BindItem();
        }
        else
        {
            BindGeneric();
        }

    }
    private void BindGeneric()
    {
        string str = " select CONCAT(IM.ItemID,'#',IM.SubCategoryID,'#',IFNULL(st.Qty,'0'),'#',IFNULL(IM.UnitType,''),'#',IF(pay.ItemID IS NULL,'0','1'),'#',im.Dose,'#',im.MedicineType,'#',im.Route)ItemID, CONCAT(fsm.Name,' # ',im.typename,' # (',sm.name,')')ItemName from f_itemmaster im "
                     + "inner join f_subcategorymaster sm on sm.SubCategoryID = im.SubCategoryID "
                     + "LEFT JOIN (SELECT IF((InitialCount-ReleasedCount)>0,(InitialCount-ReleasedCount),0) "
                     + "Qty,ItemID FROM f_stock WHERE isPost=1 AND (InitialCount-ReleasedCount)>0 AND DeptLedgerNo='" + ddlDept.SelectedValue + "' GROUP BY ITemID)st ON st.itemID = im.ItemID "
                     + "INNER JOIN f_item_salt fis ON fis.ItemID=im.ItemID LEFT JOIN f_salt_master fsm ON fis.saltID = fsm.SaltID "
                     + "LEFT JOIN f_panel_item_payable pay ON Pay.ItemID=im.ItemID AND Pay.PanelID=" + lblPanelID.Text + " AND  pay.IsActive=1 WHERE fsm.IsActive=1 ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ListBox1.DataSource = dt;
            ListBox1.DataTextField = "ItemName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
        }
        else
        {
            ListBox1.Items.Clear();
        }
    }
    [WebMethod]
    public static string GetMedicineStock(string MedicineID, string DeptLedgerNo)
    {
        DataTable dt = StockReports.GetDataTable(" SELECT rm.RoleName DeptName,SUM(st.InitialCount-st.ReleasedCount)Quantity FROM f_stock st INNER JOIN f_rolemaster rm ON rm.DeptLedgerNo=st.DeptLedgerNo inner Join f_itemmaster im on im.itemID=st.itemID WHERE st.ItemID='" + MedicineID + "'  AND st.DeptLedgerNo='"+DeptLedgerNo+"' AND st.IsPost=1 GROUP BY rm.DeptLedgerNo ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }
    [WebMethod]
    public static string GetPatientAllery(string TID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT IFNULL(Allergies,'')Allergies,IFNULL(Medications,'')Medications FROM  cpoe_hpexam WHERE TransactionID='" + TID + "'");
        if (dt.Rows.Count > 0)
          return  Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
        return "";
    } 
}
