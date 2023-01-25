using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;

public partial class Design_IPD_ApprovedInvestigationIndent : System.Web.UI.Page
{
  public int CanApproveInvestigationRequest = 0, CanRejectInvestigationRequest = 0;
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
            if (dtAuthority.Rows.Count > 0 && dtAuthority !=null)
            {
                if (dtAuthority.Rows[0]["CanApproveInvestigationRequest"].ToString() == "1")
                    CanApproveInvestigationRequest = 1;
                if (dtAuthority.Rows[0]["CanRejectInvestigationRequest"].ToString() == "1")
                    CanRejectInvestigationRequest = 1;
            }
            DataTable dtDischarge = AQ.GetPatientDischargeStatus(TID);

            if (dtDischarge != null && dtDischarge.Rows.Count > 0)
            {
                if (dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper() == "OUT")
                {
                    string Msg = "Patient is Already Discharged on " + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("dd-MMM-yyyy") + " . No Services can be possible...";
                    Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                }
            }
            BindDetails();
            BindPatientDetails();
        }
    }
    private void BindDetails()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT * FROM ( ");
        sb.Append("     SELECT t.*, ");
        sb.Append("     (CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE' ");
        sb.Append("     WHEN t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL' END)    StatusNew ");
        sb.Append("     FROM( ");
        sb.Append("         SELECT CONCAT(em.Title,' ',em.Name)    EmpName,rd.DeptName AS Deptfrom,id.IndentNo, ");
        sb.Append("         DATE_FORMAT(id.dtEntry,'%d-%b-%Y %h:%i %p')dtentry,id.ItemName,SUM(id.ReqQty) ReqQty,SUM(id.ReceiveQty)ReceiveQty,SUM(id.RejectQty)RejectQty,id.Narration, ");
        sb.Append("         id.ApprovedBy,id.UserId,CONCAT(pm.Title,' ',pm.PName)    PatientName,REPLACE(pmh.TransactionID,'ISHHI','')    TransactionID,id.IndentType  ");
        sb.Append("         FROM f_indent_detail_investigation id  ");
        sb.Append("         INNER JOIN patient_medical_history pmh ON pmh.TransactionID = id.TransactionID ");
        sb.Append("         INNER JOIN employee_master em ON id.UserId = em.EmployeeID   ");
        sb.Append("         INNER JOIN f_rolemaster rd    ON id.DeptFrom = rd.DeptLedgerNo   ");
        sb.Append("         INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID  ");
        sb.Append("         WHERE pmh.TransactionID = '" + ViewState["TID"] + "' AND ID.`CentreID`='" + Session["CentreID"].ToString() + "' ");
        sb.Append("         GROUP BY id.IndentNo ");
        sb.Append("         )t )t2 ");

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
        sb.Append("SELECT * FROM ( ");
        sb.Append("     SELECT t.*, ");
        sb.Append("     (CASE WHEN t.reqQty=t.RejectQty THEN 'REJECT' WHEN t.reqQty-t.ReceiveQty-t.RejectQty=0 THEN 'CLOSE' ");
        sb.Append("     WHEN t.reqQty+t.ReceiveQty+t.RejectQty=t.reqQty THEN 'OPEN' ELSE 'PARTIAL' END)    StatusNew ");
        sb.Append("     FROM( ");
        sb.Append("         SELECT CONCAT(em.Title,' ',em.Name)    EmpName,rd.DeptName AS Deptfrom,id.IndentNo, ");
        sb.Append("         DATE_FORMAT(id.dtEntry,'%d-%b-%Y %h:%i %p')dtentry,id.ItemName,SUM(id.ReqQty) ReqQty,SUM(id.ReceiveQty)ReceiveQty,SUM(id.RejectQty)RejectQty,id.Narration, ");
        sb.Append("         id.ApprovedBy,id.UserId,CONCAT(pm.Title,' ',pm.PName)    PatientName,REPLACE(pmh.TransactionID,'ISHHI','')    TransactionID,id.IndentType  ");
        sb.Append("         FROM f_indent_detail_investigation id  ");
        sb.Append("         INNER JOIN patient_medical_history pmh ON pmh.TransactionID = id.TransactionID ");
        sb.Append("         INNER JOIN employee_master em ON id.UserId = em.EmployeeID   ");
        sb.Append("         INNER JOIN f_rolemaster rd    ON id.DeptFrom = rd.DeptLedgerNo   ");
        sb.Append("         INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID  ");
        sb.Append("         WHERE pmh.TransactionID = '" + ViewState["TID"] + "' AND ID.`CentreID`='" + Session["CentreID"].ToString() + "' ");
        sb.Append("         GROUP BY id.IndentNo ");
        sb.Append("         )t )t2 ");

        if (status != "")
        {
            sb.Append("  WHERE t2.StatusNew = '" + status + "'");
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
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT (CASE WHEN id.reqQty=id.RejectQty THEN 'REJECT' WHEN id.reqQty-id.ReceiveQty-id.RejectQty=0 THEN 'CLOSE' WHEN id.reqQty+id.ReceiveQty+id.RejectQty=id.reqQty THEN 'OPEN' ELSE 'PARTIAL' END)    StatusNew,(IFNULL(id.ReqQty,0)-IFNULL(id.ReceiveQty,0)-IFNULL(id.RejectQty,0))PendingQty, id.IndentNo,(rd.DeptName)DeptFrom,id.ItemName,id.ReqQty,id.ReceiveQty,id.RejectQty,");
            sb.Append("   id.Narration,id.ApprovedBy,DATE_FORMAT(id.dtEntry,'%d-%b-%Y')DATE,id.UserId,CONCAT(em.Title,' ',em.Name)    EmpName,CONCAT(pm.Title,' ',pm.PName)    PatientName,");
            sb.Append("     REPLACE(pmh.TransactionID,'ISHHI','')    TransactionID,id.IndentType FROM f_indent_detail_investigation id ");
            sb.Append("   INNER JOIN f_rolemaster rd ON id.DeptFrom = rd.DeptLedgerNo");
            sb.Append("    INNER JOIN employee_master em ON id.UserId = em.EmployeeID");
            sb.Append("    INNER JOIN patient_medical_history pmh ON pmh.TransactionID = id.TransactionID");
            sb.Append("    INNER JOIN patient_master pm ON pmh.PatientID = pm.PatientID");
            sb.Append("  WHERE pmh.TransactionID = '" + ViewState["TID"] + "'  and id.indentno='" + IndentNo + "'");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                grdindent.DataSource = dt;
                grdindent.DataBind();
                mpe2.Show();
            }
        }
        if (e.CommandName == "Approved")
        {
            txtHash.Text = Util.getHash();
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            string LedTnxId = SaveIenvestigation(IndentNo);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Lab No.: '+'" + LedTnxId + "');", true);
           
            lblMsg.Text = "Pending Indent Investigations have approved successfully";
            BindDetails();
        }
        if (e.CommandName == "Reject")
        {
            string IndentNo = Util.GetString(e.CommandArgument).Split('#')[0];
            StringBuilder sb1 = new StringBuilder();
            sb1.Append("UPDATE f_indent_detail_investigation set RejectQty =(ReqQty-ReceiveQty),RejectedDateTime=NOW(),RejectBy='" + Session["ID"].ToString() + "'   ");
            sb1.Append("  WHERE TransactionID = '" + ViewState["TID"] + "'  and indentno='" + IndentNo + "' and ReqQty>(ReceiveQty+RejectQty)  AND isCancel=0  ");
            StockReports.ExecuteDML(sb1.ToString());
            lblMsg.Text = "Pending Indent Investigations have rejected successfully";
            BindDetails();
        }

    }

    protected void grdRequsition_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            if (((Label)e.Row.FindControl("lblStatusNew")).Text == "REJECT")
            {
                e.Row.BackColor = System.Drawing.Color.LightPink;
                ((ImageButton)e.Row.FindControl("imbApproved")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbReject")).Visible = false;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "CLOSE")
            {
                e.Row.BackColor = System.Drawing.Color.BurlyWood;
                ((ImageButton)e.Row.FindControl("imbApproved")).Visible = false;
                ((ImageButton)e.Row.FindControl("imbReject")).Visible = false;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "OPEN")
            {
                e.Row.BackColor = System.Drawing.Color.LightBlue;
            }
            else if (((Label)e.Row.FindControl("lblStatusNew")).Text == "PARTIAL")
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }

            if(CanApproveInvestigationRequest ==0)
                grdRequsition.Columns[7].Visible = false;
            if(CanRejectInvestigationRequest ==0)
                grdRequsition.Columns[8].Visible = false;
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
                e.Row.BackColor = System.Drawing.Color.BurlyWood;
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
    private void BindPatientDetails()
    {
        lblTransactionNo.Text = Convert.ToString(ViewState["TID"]);

        AllQuery AQ = new AllQuery();
        DataTable ds = AQ.GetPatientIPDInformation("", lblTransactionNo.Text.Trim());

        if (ds != null && ds.Rows.Count > 0)
        {
            if (Resources.Resource.IsmembershipInIPD == "1")
            {
                lblMsg.Text = ds.Rows[0]["IsMemberShipExpire"].ToString();
                lblMembership.Text = ds.Rows[0]["MemberShipCardNo"].ToString();
            }
            else
            {
                lblMsg.Text = "";
                lblMembership.Text = "";
            }
            lblPatientID.Text = ds.Rows[0]["PatientID"].ToString();
            lblTransactionNo.Text = ds.Rows[0]["TransactionID"].ToString();
            lblReferenceCode.Text = ds.Rows[0]["ReferenceCode"].ToString();
            lblCaseTypeID.Text = ds.Rows[0]["IPDCaseTypeID"].ToString();
            lblPanelID.Text = ds.Rows[0]["PanelID"].ToString();
            lblDoctorID.Text = ds.Rows[0]["DoctorID"].ToString();
            ViewState["ScheduleChargeID"] = ds.Rows[0]["ScheduleChargeID"].ToString();
            lblPatientType.Text = ds.Rows[0]["PatientType"].ToString();
            lblRoomID.Text = ds.Rows[0]["RoomID"].ToString();
            lblPatientTypeID.Text = ds.Rows[0]["PatientTypeID"].ToString();
        }
    }

    private void GetItemRate(string IndentNo)
    {
        DataTable dtItem = new DataTable();
        dtItem.Columns.Add("Rate", typeof(float));
        dtItem.Columns.Add("ItemID");
        dtItem.Columns.Add("Item");
        dtItem.Columns.Add("PanelID");
        dtItem.Columns.Add("Type_ID");
        dtItem.Columns.Add("Quantity", typeof(float));
        dtItem.Columns.Add("SubCategoryID");
        dtItem.Columns.Add("Date");
        dtItem.Columns.Add("Amount", typeof(float));
        dtItem.Columns.Add("ItemDiscPer", typeof(float));
        dtItem.Columns.Add("ItemDiscAmount", typeof(float));
        dtItem.Columns.Add("TnxTypeID");
        dtItem.Columns.Add("OldRate");
        dtItem.Columns.Add("ItemDisplayName");
        dtItem.Columns.Add("ItemCode");
        dtItem.Columns.Add("Remarks");
        dtItem.Columns.Add("NonPayable", typeof(int));
        dtItem.Columns.Add("PatientTest_ID", typeof(int));
        dtItem.Columns.Add("RateListID");
        dtItem.Columns.Add("IsUrgent", typeof(int));
        dtItem.Columns.Add("IsOutSource", typeof(int));
        dtItem.Columns.Add("isPayable");
        dtItem.Columns.Add("RateEditable");
        dtItem.Columns.Add("isRateZero");
        dtItem.Columns.Add("RateItemCode");
        dtItem.Columns.Add("DoctorID");
        dtItem.Columns.Add("CoPayment");
        string ScheduleChargeID = StockReports.GetPatientCurrentRateScheduleID_IPD(ViewState["TID"].ToString());
        DataTable dtIndentdetail = StockReports.GetDataTable(" SELECT ID.`DoctorID`,id.`ItemId`,(ReqQty-ReceiveQty+RejectQty)PendingTest FROM f_indent_detail_investigation id WHERE TransactionID = '" + ViewState["TID"].ToString() + "'  AND id.`IndentNo`='" + IndentNo + "' AND id.`isCancel`=0 AND ReqQty>(ReceiveQty+RejectQty) ");
        if (dtIndentdetail.Rows.Count > 0)
        {
            DataTable dtMappedItem = new DataTable();
            foreach (DataRow drInd in dtIndentdetail.Rows)
            {
                if (Util.GetInt(drInd["PendingTest"].ToString()) > 0)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("SELECT TypeName,CONCAT(ItemId,'#',IF(Rate IS NULL,0,Rate),'#',IF(ItemDisplayName IS NULL,'',ItemDisplayName),'#',IF(ItemCode IS NULL,'',ItemCode),'#',rateEditable)ItemId FROM ( ");
                    sb.Append("    SELECT IM.TypeName,CONCAT(IM.ItemID,'#',IM.Type_ID,'#',IM.SubCategoryID)ItemId,RL.Rate,RL.ItemDisplayName,RL.ItemCode,IM.rateEditable ");
                    sb.Append("    FROM f_itemmaster IM INNER JOIN f_subcategorymaster sub ON  IM.SubCategoryID=sub.SubCategoryID ");
                    sb.Append("    INNER JOIN f_configrelation cf ON cf.CategoryID = sub.CategoryID ");
                    sb.Append("    LEFT JOIN ( ");
                    sb.Append("        SELECT ItemID,Rate,ItemDisplayName,ItemCode FROM f_ratelist_ipd WHERE  IPDCaseTypeID='" + lblCaseTypeID.Text.Trim() + "' ");
                    sb.Append("        AND ScheduleChargeID=" + ScheduleChargeID + " AND PanelID=" + lblReferenceCode.Text.Trim() + "  and IsCurrent=1 ");
                    sb.Append("    ) RL ON RL.ItemID=IM.ItemID WHERE cf.ConfigID=3 AND im.Isactive=1  ");
                    sb.Append("    and im.ItemID ='" + drInd["ItemId"].ToString() + "' ");
                    sb.Append("    ORDER BY TypeName ");
                    sb.Append(")t1 ");

                    dtMappedItem = StockReports.GetDataTable(sb.ToString());

                    if (dtMappedItem == null || dtMappedItem.Rows.Count == 0)
                    {
                        lblMsg.Text = "Rate is Not Set for this Item. Please Contact EDP";
                        return;
                    }


                    DataRow dr = dtItem.NewRow();
                    dr["DoctorID"] = drInd["DoctorID"].ToString();
                    dr["Item"] = dtMappedItem.Rows[0]["TypeName"].ToString();
                    dr["Rate"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[3]);
                    dr["OldRate"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[3]);
                    dr["ItemDisplayName"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[4]);
                    dr["ItemCode"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[5]);
                    dr["ItemID"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[0]);
                    dr["PanelID"] = lblPanelID.Text.Trim();
                    dr["Type_ID"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[1]);
                    dr["Quantity"] = "1";
                    dr["SubCategoryID"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[2]);
                    dr["Date"] = Util.GetDateTime(System.DateTime.Now);
                    dr["TnxTypeID"] = "15";

                    string SubCategoryID = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[2]);
                    string PanelID = lblPanelID.Text.Trim();
                    DateTime date = Util.GetDateTime(DateTime.Now.ToString());
                    string PatientType = StockReports.GetPatient_Type_IPD(ViewState["TID"].ToString());


                    int patientTypeID = Util.GetInt(lblPatientTypeID.Text);
                    var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(PanelID), Util.GetString(dr["ItemID"]), patientTypeID);
                    decimal DiscPerc = 0;
                    if (Resources.Resource.IsmembershipInIPD == "1")
                    {
                        if (Util.GetInt(PanelID) == 1)
                        {
                            if (lblMembership.Text != "")
                            {
                                GetDiscount ds = new GetDiscount();
                                DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(dr["ItemID"]), lblMembership.Text, "IPD").Split('#')[0].ToString());
                            }
                            else
                            {
                                DiscPerc = 0;
                            }
                        }
                        else
                        {
                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                        }
                    }
                    else
                    {
                        DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                    }
                    if (DiscPerc > 0)
                    {
                        decimal GrossAmt = Util.GetDecimal(dr["Rate"]) * Util.GetDecimal(dr["Quantity"]);
                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                        dr["Amount"] = NetAmount;
                        dr["ItemDiscPer"] = DiscPerc;
                        dr["ItemDiscAmount"] = GrossAmt - NetAmount;
                    }
                    else
                    {
                        dr["Amount"] = Util.GetDecimal(dr["Rate"]) * Util.GetDecimal(dr["Quantity"]);
                        dr["ItemDiscPer"] = DiscPerc;
                        dr["ItemDiscAmount"] = Util.GetDecimal(dr["Rate"]) * Util.GetDecimal(dr["Quantity"]);
                    }

                    if (lblPanelID.Text == "1")
                        dr["isPayable"] = "false";
                    else
                        dr["isPayable"] = "true";
                    dr["RateEditable"] = Util.GetInt(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[6]);
                    if (dr["Rate"] == "0")
                        dr["isRateZero"] = 0;
                    else
                        dr["isRateZero"] = 1;
                    dr["RateItemCode"] = Util.GetString(dtMappedItem.Rows[0]["ItemID"].ToString().Split('#')[5]);


                    dr["isPayable"] = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
                    dr["CoPayment"] = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);

                    dtItem.Rows.Add(dr);
                }
            }
            ViewState.Add("dtItems", dtItem);
        }
        else
        {
            lblMsg.Text = "No Pending Investigations are found under the Indent No. :" + IndentNo;
            return;
        }
    }
    private string SaveIenvestigation(string IndentNo)
    {
        GetItemRate(IndentNo);
        if (ViewState["dtItems"] != null)
        {
            DataTable dtItem = (DataTable)ViewState["dtItems"];
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string str = "Select LedgerNumber  from f_ledgermaster Where  GroupId='PTNT' and LedgerUserID='" + lblPatientID.Text.Trim() + "'";
                string PatientLedgerNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, str));
                string LedTxnID = string.Empty, SalesId = string.Empty;

                Ledger_Transaction objLedTran = new Ledger_Transaction(Tranx);
                objLedTran.LedgerNoCr = PatientLedgerNo;
                objLedTran.LedgerNoDr = "HOSP0001";
                objLedTran.Hospital_ID = Session["HOSPID"].ToString();
                objLedTran.TypeOfTnx = "IPD-LAB";
                objLedTran.Date = Util.GetDateTime(dtItem.Rows[0]["Date"]);
                objLedTran.Time = DateTime.Now;
                objLedTran.GrossAmount = Util.GetDecimal(dtItem.Compute("sum(amount)", ""));
                objLedTran.NetAmount = Util.GetDecimal(dtItem.Compute("sum(amount)", ""));
                objLedTran.UserID = ViewState["ID"].ToString();
                objLedTran.PatientID = lblPatientID.Text.Trim();
                objLedTran.TransactionID = lblTransactionNo.Text.Trim();
                objLedTran.PanelID = Util.GetInt(lblPanelID.Text.Trim());
                objLedTran.UniqueHash = txtHash.Text;
                objLedTran.IpAddress = All_LoadData.IpAddress();
                objLedTran.CentreID = Util.GetInt(Session["CentreID"].ToString());
                objLedTran.PatientType = lblPatientType.Text;
                objLedTran.IpAddress = All_LoadData.IpAddress();
                objLedTran.IndentNo = IndentNo;
                LedTxnID = objLedTran.Insert().ToString();
                if (LedTxnID == string.Empty)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }

                //***************** insert into Ledger transaction details and Sales Details *************            


                Patient_Lab_InvestigationIPD objPLI = new Patient_Lab_InvestigationIPD(Tranx);

                string PatientType = StockReports.GetPatient_Type_IPD(lblTransactionNo.Text.Trim());

                //Checking if Patient is prescribed any IPD Packages
                DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(lblTransactionNo.Text.Trim(), con);
                int sampleCollectCount = 0;
                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    LedgerTnxDetail objLTDetail = new LedgerTnxDetail(Tranx);
                    objLTDetail.Hospital_Id = Session["HOSPID"].ToString();
                    objLTDetail.LedgerTransactionNo = LedTxnID;
                    objLTDetail.ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);
                    objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtItem.Rows[i]["SubCategoryID"]), con));
                    objLTDetail.Rate = Util.GetDecimal(dtItem.Rows[i]["Rate"]);
                    objLTDetail.Quantity = Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                    if (dtItem.Columns.Contains("NonPayable"))
                        objLTDetail.IsPayable = Util.GetInt(dtItem.Rows[i]["NonPayable"]);
                    else
                        objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, objLedTran.PanelID);



                    int patientTypeID = Util.GetInt(lblPatientTypeID.Text);
                    var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(objLedTran.PanelID), Util.GetString(objLTDetail.ItemID), patientTypeID);
                    if (dtPkg != null && dtPkg.Rows.Count > 0)
                    {
                        int iCtr = 0;
                        foreach (DataRow drPkg in dtPkg.Rows)
                        {
                            if (iCtr == 0)
                            {
                                DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(lblTransactionNo.Text.Trim(), drPkg["PackageID"].ToString(), dtItem.Rows[i]["ItemID"].ToString(), (Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"])), Util.GetInt(dtItem.Rows[i]["Quantity"]), Util.GetInt(lblCaseTypeID.Text), con);

                                if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                {
                                    if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                    {
                                        objLTDetail.Amount = 0;
                                        objLTDetail.DiscountPercentage = 0;
                                        objLTDetail.DiscAmt = 0;
                                        objLTDetail.IsPackage = 1;
                                        objLTDetail.PackageID = Util.GetString(drPkg["PackageID"]);
                                        objLTDetail.NetItemAmt = 0;
                                        objLTDetail.TotalDiscAmt = 0;
                                        iCtr = 1;
                                    }
                                    else
                                    {
                                        //  decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(lblPanelID.Text.Trim()), Util.GetString(dtItem.Rows[i]["ItemID"]),"I",con));

                                        decimal DiscPerc = 0;
                                        if (Resources.Resource.IsmembershipInIPD == "1")
                                        {
                                            if (Util.GetInt(lblPanelID.Text.Trim()) == 1)
                                            {
                                                if (lblMembership.Text != "")
                                                {
                                                    GetDiscount ds = new GetDiscount();
                                                    DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(dtItem.Rows[i]["ItemID"]), lblMembership.Text, "IPD").Split('#')[0].ToString());
                                                }
                                                else
                                                {
                                                    DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                                }
                                            }
                                            else
                                            {
                                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                            }
                                        }
                                        else
                                        {
                                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                        }
                                        if (DiscPerc > 0)
                                        {
                                            decimal GrossAmt = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                            objLTDetail.Amount = NetAmount;
                                            objLTDetail.DiscountPercentage = DiscPerc;
                                            objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                            objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                            objLTDetail.NetItemAmt = NetAmount;
                                            objLTDetail.DiscountReason = "Panel Wise Discount";
                                            objLTDetail.DiscUserID = ViewState["ID"].ToString();
                                            if (Util.GetInt(lblPanelID.Text.Trim()) != 1)
                                                objLTDetail.isPanelWiseDisc = 1;
                                        }
                                        else
                                        {
                                            objLTDetail.DiscountPercentage = DiscPerc;
                                            objLTDetail.DiscAmt = 0;
                                            objLTDetail.Amount = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                                            objLTDetail.TotalDiscAmt = 0;
                                            objLTDetail.NetItemAmt = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                                        }
                                    }
                                }
                                else
                                {

                                    // decimal DiscPerc = Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(lblPanelID.Text.Trim()), Util.GetString(dtItem.Rows[i]["ItemID"]),"I", con));
                                    decimal DiscPerc = 0;
                                    if (Resources.Resource.IsmembershipInIPD == "1")
                                    {
                                        if (Util.GetInt(lblPanelID.Text.Trim()) == 1)
                                        {
                                            if (lblMembership.Text != "")
                                            {
                                                GetDiscount ds = new GetDiscount();
                                                DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(dtItem.Rows[i]["ItemID"]), lblMembership.Text, "IPD").Split('#')[0].ToString());
                                            }
                                            else
                                            {
                                                DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                            }
                                        }
                                        else
                                        {
                                            DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                        }
                                    }
                                    else
                                    {
                                        DiscPerc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                    }
                                    if (DiscPerc > 0)
                                    {
                                        decimal GrossAmt = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                                        decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                        objLTDetail.Amount = NetAmount;
                                        objLTDetail.DiscountPercentage = DiscPerc;
                                        objLTDetail.DiscAmt = GrossAmt - NetAmount;
                                        objLTDetail.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                        objLTDetail.NetItemAmt = NetAmount;
                                        objLTDetail.DiscountReason = "Panel Wise Discount";
                                        objLTDetail.DiscUserID = ViewState["ID"].ToString();
                                        if (Util.GetInt(lblPanelID.Text.Trim()) != 1)
                                            objLTDetail.isPanelWiseDisc = 1;

                                    }
                                    else
                                    {
                                        objLTDetail.DiscountPercentage = DiscPerc;
                                        objLTDetail.DiscAmt = 0;
                                        objLTDetail.Amount = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                                        objLTDetail.TotalDiscAmt = 0;
                                        objLTDetail.NetItemAmt = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);

                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        // decimal ipdPanelDisc=Util.GetDecimal(AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(lblPanelID.Text.Trim()), Util.GetString(dtItem.Rows[i]["ItemID"]),"I",con));
                        decimal ipdPanelDisc = 0;
                        if (Resources.Resource.IsmembershipInIPD == "1")
                        {
                            if (Util.GetInt(lblPanelID.Text.Trim()) == 1)
                            {
                                if (lblMembership.Text != "")
                                {
                                    GetDiscount ds = new GetDiscount();
                                    ipdPanelDisc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(dtItem.Rows[i]["ItemID"]), lblMembership.Text, "IPD").Split('#')[0].ToString());
                                }
                                else
                                {
                                    ipdPanelDisc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                                }
                            }
                            else
                            {
                                ipdPanelDisc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                            }
                        }
                        else
                        {
                            ipdPanelDisc = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                        }

                        if (ipdPanelDisc > 0)
                        {
                            decimal GrossAmt = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                            decimal NetAmount = GrossAmt - ((GrossAmt * ipdPanelDisc) / 100);

                            objLTDetail.Amount = NetAmount;
                            objLTDetail.DiscountPercentage = ipdPanelDisc;
                            objLTDetail.DiscAmt = GrossAmt - NetAmount;
                            objLTDetail.TotalDiscAmt = (GrossAmt * ipdPanelDisc) / 100;
                            objLTDetail.NetItemAmt = NetAmount;
                            objLTDetail.DiscountReason = "Panel Wise Discount";
                            objLTDetail.DiscUserID = ViewState["ID"].ToString();
                            if (Util.GetInt(lblPanelID.Text.Trim()) != 1)
                                objLTDetail.isPanelWiseDisc = 1;
                        }
                        else
                        {
                            objLTDetail.DiscountPercentage = 0;
                            objLTDetail.DiscAmt = 0;
                            objLTDetail.Amount = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                            objLTDetail.TotalDiscAmt = 0;
                            objLTDetail.NetItemAmt = Util.GetDecimal(dtItem.Rows[i]["Rate"]) * Util.GetDecimal(dtItem.Rows[i]["Quantity"]);
                        }
                    }


                    objLTDetail.IsPayable = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
                    objLTDetail.CoPayPercent = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);
                    objLTDetail.EntryDate = Util.GetDateTime(dtItem.Rows[i]["Date"]);
                    objLTDetail.TransactionID = lblTransactionNo.Text.Trim();
                    objLTDetail.UserID = ViewState["ID"].ToString();
                    objLTDetail.IsVerified = 1;

                    if (Util.GetString(dtItem.Rows[i]["ItemCode"]) != "")
                        objLTDetail.ItemName = Util.GetString(dtItem.Rows[i]["ItemDisplayName"]) + " (" + Util.GetString(dtItem.Rows[i]["ItemCode"]) + ")";
                    else
                        objLTDetail.ItemName = Util.GetString(dtItem.Rows[i]["Item"]);

                    objLTDetail.SubCategoryID = Util.GetString(dtItem.Rows[i]["SubCategoryID"]);
                    objLTDetail.DoctorID = Util.GetString(dtItem.Rows[i]["DoctorID"]);
                    objLTDetail.IPDCaseTypeID = lblCaseTypeID.Text;
                    objLTDetail.RateListID = Util.GetInt(dtItem.Rows[i]["RateListID"]);
                    objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                    objLTDetail.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objLTDetail.Type = "I";
                    objLTDetail.RoleID = Util.GetInt(Session["RoleID"].ToString());
                    objLTDetail.IpAddress = All_LoadData.IpAddress();
                    objLTDetail.MACAddress = All_LoadData.macAddress();
                    objLTDetail.rateItemCode = Util.GetString(dtItem.Rows[i]["RateItemCode"]);
                    objLTDetail.VarifiedUserID = ViewState["ID"].ToString();
                    objLTDetail.VerifiedDate = Util.GetDateTime(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    objLTDetail.RoomID = lblRoomID.Text.Trim();
                    objLTDetail.typeOfTnx = "IPD-LAB";
                    int ID = objLTDetail.Insert();


                    if (ID == 0)
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }

                    objPLI.Investigation_ID = Util.GetString(dtItem.Rows[i]["Type_ID"]);
                    objPLI.Date = Util.GetDateTime(dtItem.Rows[i]["Date"]);
                    objPLI.Time = Util.GetDateTime(DateTime.Now.ToString("HH:mm:ss"));
                    objPLI.TransactionID = lblTransactionNo.Text.Trim();

                    string Type = StockReports.ExecuteScalar("Select Type from Investigation_master where Investigation_ID='" + objPLI.Investigation_ID + "'");

                    if (Type.ToUpper() == "N")
                        objPLI.IsSampleCollected = "Y";
                    else if (Type.ToUpper() == "R")
                    {
                        sampleCollectCount += 1;
                        objPLI.IsSampleCollected = "N";

                    }
                    else
                        objPLI.IsSampleCollected = Type.ToUpper();

                    objPLI.SampleDate = Util.GetDateTime(dtItem.Rows[i]["Date"]);
                    objPLI.Special_Flag = 0;
                    objPLI.Round_No = 0;
                    objPLI.Result_Flag = 0;
                    objPLI.LedgerTransactionNo = LedTxnID;
                    objPLI.LedgerTnxID = ID.ToString();
                    objPLI.PatientID = lblPatientID.Text.Trim();
                    objPLI.Remarks = dtItem.Rows[i]["Remarks"].ToString();
                    objPLI.DoctorID = Util.GetString(dtItem.Rows[i]["DoctorID"]);
                    objPLI.IsUrgent = Util.GetInt(dtItem.Rows[i]["IsUrgent"]);
                    objPLI.IsOutSource = Util.GetInt(dtItem.Rows[i]["IsOutSource"]);
                    objPLI.OutSourceLabID = 0;
                    if (Util.GetInt(dtItem.Rows[i]["IsOutSource"]) == 1)
                    {
                        objPLI.OutSourceBy = ViewState["ID"].ToString();
                        objPLI.OutsourceDate = DateTime.Now;
                        int OutSourceLabID = Util.GetInt(StockReports.ExecuteScalar("select IFNULL(OutSourceLabID,'0')OutSourceLabID from investigation_master where Investigation_ID='" + Util.GetString(dtItem.Rows[i]["Type_ID"]) + "'"));
                        objPLI.OutSourceLabID = OutSourceLabID;
                    }
                    objPLI.Hospital_Id = Session["HOSPID"].ToString();
                    objPLI.CentreID = Util.GetInt(Session["CentreID"].ToString());
                    objPLI.IPDCaseType_ID = lblCaseTypeID.Text;
                    objPLI.Room_ID = lblRoomID.Text;
                    objPLI.Insert();
                    string UpdatePatientTest = "Update patient_test set isIssue='1',IssueBy='" + Session["ID"].ToString() + "',IssueDate=Now() where PatientTest_ID='" + dtItem.Rows[i]["PatientTest_ID"].ToString() + "'";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, UpdatePatientTest);
                }
                if (sampleCollectCount > 0)
                {
                    string notification = Notification_Insert.notificationInsert(15, LedTxnID, Tranx, "", lblCaseTypeID.Text, 0, "");
                    if (notification == "")
                    {
                        Tranx.Rollback();
                        Tranx.Dispose();
                        con.Close();
                        con.Dispose();
                        return string.Empty;
                    }
                }
                StringBuilder sb1 = new StringBuilder();
                sb1.Append("UPDATE f_indent_detail_investigation set ReceiveQty =(ReqQty-RejectQty),ApprovedDateTime=NOW(),ApprovedBy='" + Session["ID"].ToString() + "'  ");
                sb1.Append("  WHERE TransactionID = '" + ViewState["TID"] + "'  and indentno='" + IndentNo + "' and ReqQty>(ReceiveQty+RejectQty)  AND isCancel=0  ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb1.ToString());
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();

                return LedTxnID;
            }
            catch (Exception ex)
            {
                ClassLog c1 = new ClassLog();
                c1.errLog(ex);
                Tranx.Rollback();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
        }
        else
            return string.Empty;
    }
}