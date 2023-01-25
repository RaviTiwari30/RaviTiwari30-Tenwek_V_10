using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Finance_UpdatePanelApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["fileUpload1"] = null;

            if (Session["ID"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                ViewState.Add("USERID", Session["ID"].ToString());
            }

            if (Request.QueryString["TransactionID"] != null)
            {
                ViewState["TransactionID"] = Request.QueryString["TransactionID"].ToString();
            }
            else if (Request.QueryString["TID"] != null)
            {
                ViewState["TransactionID"] = Request.QueryString["TID"].ToString();
            }
            string panelID = AllLoadData_IPD.getPatientPanelID(ViewState["TransactionID"].ToString(), null);
            if (panelID == "1")
            {
                string Msg = "This Form Is Not For CASH Patient...";
                Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
            }
            txtPanelBillAmt.Attributes.Add("onKeyUp", "CalculateDiff(" + lblBillAmount.ClientID + "," + lblCashBillAmt.ClientID + " ," + txtPanelBillAmt.ClientID + "  );");
            txtPanelBillAmt.Attributes.Add("onchange", "CalculateDiff(" + lblBillAmount.ClientID + "," + lblCashBillAmt.ClientID + " ," + txtPanelBillAmt.ClientID + "  );");


            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientAdjustmentDetails(ViewState["TransactionID"].ToString());
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;

            if (dt != null && dt.Rows.Count > 0)
            {
                DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                if (dt.Rows[0]["BillNo"].ToString().Trim() != "")
                {
                    if (dtAuthoritys.Rows.Count > 0)
                    {
                        if (dtAuthoritys.Rows[0]["AppAmtAfterBill"].ToString() == "0")
                        {
                            string Msg = "You are Not Authorised to Put Approval Amt after Bill Generation";
                            Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                        }
                    }
                    else
                    {
                        string Msg = "You are Not Authorised to Put Approval Amt after Bill Generation";
                        Response.Redirect("../IPD/PatientBillMsg.aspx?msg=" + Msg);
                    }
                }
            }
            BindPanels();
            decimal AmountBilled = Util.GetDecimal(AQ.GetBillAmount(ViewState["TransactionID"].ToString(), null));
            decimal TotalDisc = Util.GetDecimal(StockReports.ExecuteScalar("Select (IFNULL(sum((Rate*Quantity)-Amount),0) + (Select IFNULL(DiscountOnBill,0) from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "')) TotalDisc from f_ledgertnxdetail where TransactionID='" + ViewState["TransactionID"].ToString() + "' and DiscountPercentage > 0  and isverified=1 and ispackage=0"));//f_ipdadjustment
            AmountBilled = AmountBilled - TotalDisc;
            lblBillAmount.Text = Math.Round(Util.GetDecimal(AmountBilled), 2).ToString();
            lblApprovalAmt.Text = Util.GetDecimal((dt.Rows[0]["PanelApprovedAmt"])).ToString();
            // if (dt != null && dt.Rows.Count > 0 && Util.GetDecimal(dt.Rows[0]["PanelApprovedAmt"]) > 0)
            //  rdoAppType.Visible = true;
            //  else
            //   rdoAppType.Visible = false;
            //  txtPanelBillAmt.Text = "0";

            if (dt != null && dt.Rows.Count > 0 && Util.GetDecimal(dt.Rows[0]["PatientCashAmt"]) > 0)
                lblCashBillAmt.Text = Util.GetString(dt.Rows[0]["PatientCashAmt"]);
            else
                lblCashBillAmt.Text = "0.00";
           // lblPanelNAme.Text = Util.GetString(StockReports.ExecuteScalar("SELECT Company_Name FROM f_panel_master WHERE PanelID=" + dt.Rows[0]["PanelId"].ToString() + " "));
          //  if (lblPanelNAme.Text.ToUpper() == "CASH")
          //      btnUpdateBilling.Enabled = true;
          //  else
          //      btnUpdateBilling.Enabled = true;

            DataTable dtAdj = StockReports.GetDataTable("Select PanelAppRemarks,ClaimNo from patient_medical_history where TransactionID='" + ViewState["TransactionID"].ToString() + "'");//f_ipdadjustment
            // txtRemarks.Text = dtAdj.Rows[0]["PanelAppRemarks"].ToString();
            txtClaimNo.Text = dtAdj.Rows[0]["ClaimNo"].ToString();

            if (txtClaimNo.Text.Trim() != string.Empty)
                txtClaimNo.Attributes.Add("readOnly", "readOnly");

            BindPanelDetail();

            string ToAlert = StockReports.GetExpireApprovalAmountAlert(ViewState["TransactionID"].ToString());
            if (ToAlert != "" && Util.GetInt(ToAlert) >= 0)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ak1", "alert('Maximum Allowed Panel Approval Amount Date Is Expiring In " + ToAlert + " Days Please Renew');", true);
            else if (ToAlert != "" && Util.GetInt(ToAlert) < 0)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "ak2", "alert('Maximum Allowed Panel Approval Amount Date Is Already Expired " + Util.GetInt(ToAlert) * -1 + " Days Ago Please Renew');", true);

            txtAppDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calucDate.EndDate = DateTime.Now;
        }
    }
    private void BindPanels()
    {
        DataTable dtPanel = StockReports.GetDataTable("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,applyCreditLimit,CreditLimitType,pae.ApprovalAmount ,pae.IsThroughsmartCard " +
                          "FROM f_panel_master pm INNER JOIN f_rate_schedulecharges sc ON pm.ReferenceCode=sc.PanelID INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID INNER JOIN panelapproval_emaildetails pae ON pm.PanelID=pae.panelID where sc.IsDefault=1 and pm.Isactive=1  AND pm.DateTo>NOW() AND  fcp.CentreID='" + Session["CentreID"].ToString() + "' AND fcp.isActive=1 AND pae.TransactionID='" + ViewState["TransactionID"].ToString() + "' Group By PanelID  ORDER BY Company_Name ");
        foreach (DataRow dr in dtPanel.Rows)
        {
            ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString());
            ddlPanelCompany.Items.Add(li1);
        }
        if (dtPanel.Rows.Count > 0 && dtPanel!=null)
        {
            txtPanelBillAmt.Text = dtPanel.Rows[0]["ApprovalAmount"].ToString();

            if (Util.GetInt(dtPanel.Rows[0]["IsThroughsmartCard"].ToString()) == 1)
            {
                //txtPanelBillAmt.Attributes.Add("readOnly", "readOnly");
                txtPanelBillAmt.Attributes.Remove("readOnly");

            }
            else
            {
                txtPanelBillAmt.Attributes.Remove("readOnly");
            }

            ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue(dtPanel.Rows[0]["PanelId"].ToString()));
        }
    }



    protected void btnUpdateBilling_Click(object sender, EventArgs e)
    {
        GetEncounterNo Encounters = new GetEncounterNo();


        if (Encounters.IsMergerOrAllocated(ddlPanelCompany.SelectedValue, ViewState["TransactionID"].ToString()) == 1)
        {
            lblMsg.Text = "Amount Is already Allocated For selected Panel";
            txtAppDate.Focus();
            return;
        }

        if (Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") == string.Empty)
        {
            lblMsg.Text = "Please Enter Date of Approval";
            txtAppDate.Focus();
            return;
        }
        if (Util.GetDecimal(txtPanelBillAmt.Text) == 0 || txtPanelBillAmt.Text == "")
        {
            lblMsg.Text = "Please Enter Panel Approved Amount";
            txtPanelBillAmt.Focus();
            return;
        }
        string upld = "";
        //if (fileUpload1.PostedFile.ContentLength == 0)
        //{
        //    lblMsg.Visible = true;
        //    lblMsg.Text = "Please Browse File";
        //    return;
        //}
        if ((bool)rdoAppType.Visible && rdoAppType.SelectedIndex == -1)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Please Select Panel Approval Type ";
            return;
        }
        if (txtRemarks.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Remarks for Approval";
            return;
        }

        if (rdoAppWay.SelectedIndex == -1)
        {
            lblMsg.Visible = true;
            lblMsg.Text = "Please Select Amount Approval Type ";
            return;
        }

        if (rdoAppWay.SelectedValue.ToUpper() != "OPEN")
        {
            string ExpiryAppDate = StockReports.ExecuteScalar("SELECT DATE_FORMAT(ApprovalExpiryDate,'%d-%b-%Y')ApprovalExpiryDate FROM f_ipdpanelapproval WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' AND AmountApprovalType='Fix' ORDER BY ApprovalExpiryDate DESC LIMIT 1");

            if (ExpiryAppDate == "")
            {
                DateTime s = Util.GetDateTime(Util.GetDateTime(((TextBox)txtType.FindControl("txtStartDate")).Text).ToString("dd-MMM-yyyy"));
                if (Util.GetDateTime(Util.GetDateTime(((TextBox)txtType.FindControl("txtStartDate")).Text).ToString("dd-MMM-yyyy")).Date < Util.GetDateTime(ViewState["StartDate"]).Date)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Maximum Allowed Panel Approval Amount Date Can Not Be Back Date";
                    return;
                }
            }
            else

                if (Util.GetDateTime(Util.GetDateTime(((TextBox)txtType.FindControl("txtStartDate")).Text).ToString("dd-MMM-yyyy")).Date <= Util.GetDateTime(ExpiryAppDate))
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Maximum Allowed Panel Approval Amount Date Can Not Be Back Date";
                    return;
                }
        }

        try
        {
        //    string Ext = System.IO.Path.GetExtension(fileUpload1.PostedFile.FileName.ToString());
        //    if ((Ext != ".pdf") || (Ext != ".PDF") || (Ext != ".doc") || (Ext != ".DOC") || (Ext != ".docx") || (Ext != ".gif") || (Ext != ".jpg") || (Ext != ".xls") || (Ext != ".xlsx") || (Ext != ".txt"))
        //    {

        //        if (All_LoadData.chkDocumentDrive() == 0)
        //        {
        //            lblMsg.Text = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
        //            return;
        //        }
        //        var folder = All_LoadData.createDocumentFolder("FileApprovalUpload", ViewState["TransactionID"].ToString());
        //        if (folder == null)
        //        {
        //            lblMsg.Text = "Error occurred, Please contact administrator ";
        //            return;
        //        }
        //        //   DirectoryInfo folder = new DirectoryInfo(@"C:\FileApprovalUpload");

        //        if (folder.Exists)
        //        {
        //            DirectoryInfo[] SubFolder = folder.GetDirectories(ViewState["TransactionID"].ToString());

        //            if (SubFolder.Length > 0)
        //            {
        //                foreach (DirectoryInfo Sub in SubFolder)
        //                {
        //                    if (Sub.Name == ViewState["TransactionID"].ToString())
        //                    {
        //                        FileInfo[] files = Sub.GetFiles();
        //                        foreach (FileInfo fl in files)
        //                        {
        //                            string fil = fl.Name;
        //                            if (fil == fileUpload1.PostedFile.FileName.ToString())
        //                            {
        //                                lblMsg.Visible = true;
        //                                lblMsg.Text = "File Already Exist";
        //                                return;
        //                            }
        //                        }
        //                        string doc = fileUpload1.FileName;
        //                        string IpFolder = Sub.Name;
        //                      //  string Ip = Path.Combine(folder.ToString(), IpFolder);
        //                        upld = Path.Combine(folder.ToString(), doc);
        //                        fileUpload1.PostedFile.SaveAs(upld);
        //                        lblMsg.Visible = true;
        //                        lblMsg.Text = "File Uploaded Successfully";

        //                        break;
        //                    }
        //                }
        //            }
        //            else
        //            {
        //               // DirectoryInfo subFold = folder.CreateSubdirectory(ViewState["TransactionID"].ToString());
        //               // string IpFolder = folder.Name;
        //                string doc = fileUpload1.FileName;
        //              //  string Ip = Path.Combine(folder.ToString(), doc);
        //                upld = Path.Combine(folder.ToString(), doc);
        //                fileUpload1.PostedFile.SaveAs(upld);
        //                lblMsg.Visible = true;
        //                lblMsg.Text = "File Uploaded Successfully";
        //            }
        //        }
        //        else
        //        {
        //           // DirectoryInfo subfolder = folder.CreateSubdirectory(ViewState["TransactionID"].ToString());
        //            DirectoryInfo[] sub = folder.GetDirectories();


        //          //  string IpFolder = folder.Name;
        //            string doc = fileUpload1.FileName;
        //          //  string Ip = Path.Combine(folder.ToString(), doc);
        //            upld = Path.Combine(folder.ToString(), doc);
        //            fileUpload1.PostedFile.SaveAs(upld);
        //            lblMsg.Visible = true;
        //            lblMsg.Text = "File Uploaded Successfully";
        //        }
        //    }
        //    else
        //    {
        //        lblMsg.Text = "Only Upload ms-Word,ms-Excel,PDF,JPG,Text and PNG File";
        //        return;
        //    }
        }
        catch (Exception ex)
        {
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
        if (btnUpdateBilling.Text == "Update Billing")
        {

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

            try
            {
                string TotalRemarks = " Date : " + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "  User : " + Session["LoginName"].ToString() + "  UserID : " + Session["ID"].ToString() + ",  Remarks : " + txtRemarks.Text.Trim() + "";
                StringBuilder sqlCMD = new StringBuilder();
                AllQuery AQ = new AllQuery();
                DataTable dtPanelApp_Detail = AQ.PanelApp_Detail(ViewState["TransactionID"].ToString());
                DataView PanelApp = dtPanelApp_Detail.DefaultView;
                PanelApp.RowFilter = "IsActive='1'";
                dtPanelApp_Detail = PanelApp.ToTable();
                if (dtPanelApp_Detail != null && dtPanelApp_Detail.Rows.Count == 0)
                {
                    string str = "Update patient_medical_history Set PatientCashAmt=" + (Util.GetDecimal(lblBillAmount.Text.Trim()) - Util.GetDecimal(txtPanelBillAmt.Text.Trim())) + ",PanelApprovedAmt=" + txtPanelBillAmt.Text.Trim() + ",PanelApprovalDate='" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "',PanelAppRemarksHistory=concat_ws('" + TotalRemarks + "','  ',PanelAppRemarksHistory),PanelAppRemarks='" + txtRemarks.Text.Trim() + "',ClaimNo='" + txtClaimNo.Text.Trim() + "' where TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdadjustment
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                    upld = upld.Replace("\\", "''");
                    upld = upld.Replace("'", "\\");

                    string App_Table = "";
                    if (rdoAppWay.SelectedValue.ToUpper() == "FIX")
                    {
                        App_Table = " Insert Into f_IpdPanelApproval (TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ApprovalExpiryDate,ClaimNo,PanelID)values('" + ViewState["TransactionID"].ToString() + "','" + ViewState["USERID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "','" + txtRemarks.Text.Trim() + "','" + TotalRemarks + "','" + fileUpload1.FileName + "','" + upld + "','F','" + rdoAppWay.SelectedValue + "','" + Util.GetDateTime(((TextBox)txtType.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + "','" + txtClaimNo.Text.Trim() + "'," + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ")";
                    }
                    else
                    {
                        App_Table = " Insert Into f_IpdPanelApproval (TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ClaimNo,PanelID)values('" + ViewState["TransactionID"].ToString() + "','" + ViewState["USERID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "','" + txtRemarks.Text.Trim() + "','" + TotalRemarks + "','" + fileUpload1.FileName + "','" + upld + "','F','" + rdoAppWay.SelectedValue + "','" + txtClaimNo.Text.Trim() + "'," + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ")";
                    }

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, App_Table);

                    if (Resources.Resource.skipPanelAllocation == "1")
                    {

                        if (Encounters.IsUsingSmartCardIpd(ddlPanelCompany.SelectedValue, ViewState["TransactionID"].ToString()) == 1)
                        {

                            int a = Encounters.PanelAmountAllocationAndMergeSessionId(ddlPanelCompany.SelectedValue, ViewState["TransactionID"].ToString(), Encounters.GetPatientIdByTransactionId(ViewState["TransactionID"].ToString()), Util.GetDouble(txtPanelBillAmt.Text.Trim()), ViewState["USERID"].ToString(), "CR", tnx);

                            if (a == 0)
                            {
                                tnx.Rollback();
                                lblMsg.Visible = true;
                                lblMsg.Text = "Already Merge Session Id with Visit Number ";
                                return;
                            }
                        }
                        else
                        {

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (" + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ",'" + ViewState["TransactionID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + ViewState["USERID"].ToString() + "','CR') ");

                        }


                    }
                }
                else
                {
                    if (rdoAppType.SelectedItem.Value == "A")
                    {
                        string PanelAlreadyAppAmt = StockReports.ExecuteScalar("SELECT PanelApprovedAmt FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'");//f_ipdadjustment
                        string str = "Update patient_medical_history Set PatientCashAmt=" + (Util.GetDecimal(lblCashBillAmt.Text.Trim()) - Util.GetDecimal(txtPanelBillAmt.Text.Trim())) + ",PanelApprovedAmt=" + (Util.GetDecimal(txtPanelBillAmt.Text.Trim()) + Util.GetDecimal(PanelAlreadyAppAmt)) + ",PanelApprovalDate='" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "',PanelAppRemarksHistory=concat_ws('" + TotalRemarks + "','  ',PanelAppRemarksHistory),PanelAppRemarks='" + txtRemarks.Text.Trim() + "',ClaimNo='" + txtClaimNo.Text.Trim() + "' where TransactionID='" + ViewState["TransactionID"].ToString() + "' "; //f_ipdadjustment
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                        upld = upld.Replace("\\", "''");
                        upld = upld.Replace("'", "\\");

                        string App_Table = "";
                        if (rdoAppWay.SelectedValue.ToUpper() == "FIX")
                        {
                            App_Table = " Insert Into f_IpdPanelApproval (TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ApprovalExpiryDate,ClaimNo,PanelID)values('" + ViewState["TransactionID"].ToString() + "','" + ViewState["USERID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "','" + txtRemarks.Text.Trim() + "','" + TotalRemarks + "','" + fileUpload1.FileName + "','" + upld + "','" + rdoAppType.SelectedValue + "','" + rdoAppWay.SelectedValue + "','" + Util.GetDateTime(((TextBox)txtType.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + "','" + txtClaimNo.Text.Trim() + "'," + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ")";

                        }
                        else
                        {
                            App_Table = " Insert Into f_IpdPanelApproval (TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ClaimNo,PanelID)values('" + ViewState["TransactionID"].ToString() + "','" + ViewState["USERID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "','" + txtRemarks.Text.Trim() + "','" + TotalRemarks + "','" + fileUpload1.FileName + "','" + upld + "','" + rdoAppType.SelectedValue + "','" + rdoAppWay.SelectedValue + "','" + txtClaimNo.Text.Trim() + "'," + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ")";
                        }

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, App_Table);

                        if (Resources.Resource.skipPanelAllocation == "1")
                        {

                            if (Encounters.IsUsingSmartCardIpd(ddlPanelCompany.SelectedValue, ViewState["TransactionID"].ToString()) == 1)
                            {

                                int a = Encounters.PanelAmountAllocationAndMergeSessionId(ddlPanelCompany.SelectedValue, ViewState["TransactionID"].ToString(), Encounters.GetPatientIdByTransactionId(ViewState["TransactionID"].ToString()), Util.GetDouble(txtPanelBillAmt.Text.Trim()), ViewState["USERID"].ToString(), "CR", tnx);

                                if (a == 0)
                                {
                                    tnx.Rollback();
                                    lblMsg.Visible = true;
                                    lblMsg.Text = "Already Merge Session Id with Visit Number ";
                                    return;
                                }
                            }
                            else
                            {

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (" + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ",'" + ViewState["TransactionID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + ViewState["USERID"].ToString() + "','CR') ");

                            }



                        }
                    }
                    else if (rdoAppType.SelectedItem.Value == "C")
                    {
                        string str = "Update patient_medical_history Set PatientCashAmt=" + (Util.GetDecimal(lblBillAmount.Text.Trim()) - Util.GetDecimal(txtPanelBillAmt.Text.Trim())) + ",PanelApprovedAmt=" + txtPanelBillAmt.Text.Trim() + ",PanelApprovalDate='" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "',PanelAppRemarksHistory=concat_ws('" + TotalRemarks + "','  ',PanelAppRemarksHistory),PanelAppRemarks='" + txtRemarks.Text.Trim() + "',ClaimNo='" + txtClaimNo.Text.Trim() + "' where TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdadjustment
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                        upld = upld.Replace("\\", "''");
                        upld = upld.Replace("'", "\\");

                        string App_Table = "";
                        if (rdoAppWay.SelectedValue.ToUpper() == "FIX")
                        {
                            App_Table = " Insert Into f_IpdPanelApproval (TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ApprovalExpiryDate,ClaimNo,PanelID)values('" + ViewState["TransactionID"].ToString() + "','" + ViewState["USERID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "','" + txtRemarks.Text.Trim() + "','" + TotalRemarks + "','" + fileUpload1.FileName + "','" + upld + "','" + rdoAppType.SelectedValue + "','" + rdoAppWay.SelectedValue + "','" + Util.GetDateTime(((TextBox)txtType.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + "','" + txtClaimNo.Text.Trim() + "'," + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ")";
                        }
                        else
                        {
                            App_Table = " Insert Into f_IpdPanelApproval (TransactionID,UserID,PanelApprovedAmt,PanelApprovalDate,PanelAppRemarks,PanelAppRemarksHistory,ApprovalFileName,ApprovalURL,PanelApprovalType,AmountApprovalType,ClaimNo,PanelID)values('" + ViewState["TransactionID"].ToString() + "','" + ViewState["USERID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "','" + txtRemarks.Text.Trim() + "','" + TotalRemarks + "','" + fileUpload1.FileName + "','" + upld + "','" + rdoAppType.SelectedValue + "','" + rdoAppWay.SelectedValue + "','" + txtClaimNo.Text.Trim() + "'," + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ")";
                        }
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, App_Table);

                        if (Resources.Resource.skipPanelAllocation == "1")
                        {
                            if (Encounters.IsUsingSmartCardIpd(ddlPanelCompany.SelectedValue, ViewState["TransactionID"].ToString()) == 1)
                            {

                                int a = Encounters.PanelAmountAllocationAndMergeSessionId(ddlPanelCompany.SelectedValue, ViewState["TransactionID"].ToString(), Encounters.GetPatientIdByTransactionId(ViewState["TransactionID"].ToString()), Util.GetDouble(txtPanelBillAmt.Text.Trim()), ViewState["USERID"].ToString(), "CR", tnx);
                                if (a == 0)
                                {
                                    tnx.Rollback();
                                    lblMsg.Visible = true;
                                    lblMsg.Text = "Already Merge Session Id with Visit Number ";
                                    return;
                                }

                            }
                            else
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (" + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ",'" + ViewState["TransactionID"].ToString() + "'," + txtPanelBillAmt.Text.Trim() + ",'" + ViewState["USERID"].ToString() + "','CR') ");

                            }

                        }
                    }
                }

                tnx.Commit();
                lblMsg.Text = "Record Updated Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='UpdatePanelApproval.aspx?TransactionID=" + ViewState["TransactionID"].ToString() + "';", true);
            }
            catch (Exception ex)
            {
                ClassLog objErr = new ClassLog();
                objErr.errLog(ex);
                tnx.Rollback();
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
        else
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string TotalRemarks = " Date : " + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "  User : " + Session["LoginName"].ToString() + "  UserID : " + Session["ID"].ToString() + ",  Remarks : " + txtRemarks.Text.Trim() + "";

                string approval = " Update f_IpdPanelApproval set PanelApprovedAmt = " + txtPanelBillAmt.Text.Trim() + ",PanelAppRemarks = '" + txtRemarks.Text.Trim() + "',ClaimNo='" + txtClaimNo.Text.Trim() + "' where TransactionID = '" + ViewState["TransactionID"] + "' and ID='" + ViewState["ApprovalID"] + "' ";

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, approval.ToString());


                decimal diffAmount = Util.GetDecimal(txtPanelBillAmt.Text.Trim()) - Util.GetDecimal(ViewState["PrePanelApprovedAmt"].ToString());
                string EntryType = string.Empty;
                if (diffAmount < 0)
                    EntryType = "DR";
                else
                    EntryType = "CR";

                if (Resources.Resource.skipPanelAllocation == "1" && Math.Abs(diffAmount)>0)
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (" + Util.GetInt(ddlPanelCompany.SelectedItem.Value) + ",'" + ViewState["TransactionID"].ToString() + "'," + diffAmount + ",'" + ViewState["USERID"].ToString() + "','" + EntryType + "') ");



                decimal PanelApprovedAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Sum(PanelApprovedAmt) FROM f_IpdPanelApproval WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "'"));

                string str = "Update patient_medical_history Set PatientCashAmt=" + (Util.GetDecimal(lblCashBillAmt.Text.Trim()) - Util.GetDecimal(txtPanelBillAmt.Text.Trim())) + ",PanelApprovedAmt='" + Util.GetDecimal(PanelApprovedAmt) + "',PanelApprovalDate='" + Util.GetDateTime(txtAppDate.Text).ToString("yyyy-MM-dd") + "',PanelAppRemarksHistory=concat_ws('" + TotalRemarks + "','  ',PanelAppRemarksHistory),PanelAppRemarks='" + txtRemarks.Text.Trim() + "',ClaimNo='" + txtClaimNo.Text.Trim() + "' where TransactionID='" + ViewState["TransactionID"].ToString() + "' ";//f_ipdadjustment

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                tnx.Commit();
                ClearData();

                lblMsg.Text = "Record Save Successfully";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='UpdatePanelApproval.aspx?TransactionID=" + ViewState["TransactionID"].ToString() + "';", true);
            }
            catch (Exception ex)
            {
                ClassLog objErr = new ClassLog();
                objErr.errLog(ex);
                tnx.Rollback();
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    private void ClearData()
    {
        txtClaimNo.Text = "";
        txtPanelBillAmt.Text = "";
        txtAppDate.Text = "";
        txtRemarks.Text = "";
    }

    private void BindPanelDetail()
    {
        grdPanel_App.DataSource = null;
        grdPanel_App.DataBind();

        AllQuery AQ = new AllQuery();
        DataTable dtPanelApp_Detail = AQ.PanelApp_Detail(ViewState["TransactionID"].ToString());
        if (dtPanelApp_Detail != null && dtPanelApp_Detail.Rows.Count > 0)
        {
            grdPanel_App.DataSource = dtPanelApp_Detail;
            grdPanel_App.DataBind();
        }
    }

    protected void grdPanel_App_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            int index = Util.GetInt(e.CommandArgument.ToString().Split('$')[2]);
            ViewState["PanelApprovedAmt"] = ((Label)grdPanel_App.Rows[index].FindControl("lblPanelApprovedAmt")).Text;
            ViewState["lblID"] = ((Label)grdPanel_App.Rows[index].FindControl("lblID")).Text;
            mpeRejection.Show();
        }
        else if (e.CommandName == "AView")
        {
            foreach (GridViewRow gv in grdPanel_App.Rows)
            {
                string TId = e.CommandArgument.ToString().Split('$')[0];
                string FileAppName = e.CommandArgument.ToString().Split('$')[1];
                string lblFName = ((Label)gv.FindControl("lblFileName")).Text;

                if (FileAppName == lblFName)
                {
                    string URL = StockReports.ExecuteScalar("SELECT ApprovalURL FROM f_ipdpanelapproval WHERE TransactionID='" + TId + "' AND ApprovalFileName='" + lblFName + "'");

                    try
                    {
                        DirectoryInfo MyDir = new DirectoryInfo(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\FileApprovalUpload");
                        DirectoryInfo[] f1 = MyDir.GetDirectories(ViewState["TransactionID"].ToString());
                        if (f1.Length > 0)
                        {
                            foreach (DirectoryInfo di in f1)
                            {
                                FileInfo[] files = di.GetFiles();
                                if (files.Length > 0)
                                {
                                    foreach (FileInfo fi in files)
                                    {
                                        string FileName = fi.Name;
                                        string path1 = Path.Combine(Resources.Resource.DocumentDriveIPAddress + Resources.Resource.DocumentDriveName + "\\" + Resources.Resource.DocumentFolderName + "\\FileApprovalUpload", di.Name);
                                        string path2 = Path.Combine(path1, FileName);

                                        if (URL == path2)
                                        {
                                            if (fi.Extension == ".pdf" || fi.Extension == ".PDF")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "application/pdf";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }

                                            if (fi.Extension == ".xls")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "application/vnd.ms-excel";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }

                                            if (fi.Extension == ".xlsx")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "application/vnd.ms-excel";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }

                                            if (fi.Extension == ".jpg")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "image / jpeg";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }
                                            if (fi.Extension == ".txt")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "text/plain";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }
                                            if (fi.Extension == ".doc")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "application/ms-word";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }
                                            if (fi.Extension == ".docx")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "application/ms-word";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }
                                            if (fi.Extension == ".csv")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "application/vnd.ms-excel";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }
                                            if (fi.Extension == ".gif")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "image/gif";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }

                                            if (fi.Extension == ".html")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "text/HTML";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }

                                            if (fi.Extension == ".htm")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "text/HTML";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }

                                            if (fi.Extension.ToUpper() == ".TIF")
                                            {
                                                Response.AddHeader("Content-Disposition", "attachment; filename=" + FileName);

                                                // Add the file size into the response header
                                                Response.AddHeader("Content-Length", fi.Length.ToString());

                                                // Set the ContentType
                                                Response.ContentType = "image/tiff";

                                                // Write the file into the response (TransmitFile is for ASP.NET 2.0. In ASP.NET 1.1 you have to use WriteFile instead)
                                                Response.TransmitFile(fi.FullName);

                                                // End the response
                                                Response.Flush();
                                            }
                                        }
                                    }
                                    lblMsg.Text = "File Not Found..";
                                    lblMsg.Visible = true;
                                    return;
                                }
                            }
                        }
                        else
                        {
                            lblMsg.Text = "File Not Found..";
                            lblMsg.Visible = true;
                            return;
                        }
                    }
                    catch (Exception ex)
                    {
                        ClassLog objErr = new ClassLog();
                        objErr.errLog(ex);
                    }
                }
            }
        }
        else if (e.CommandName == "AEdit")
        {
            string TId =  e.CommandArgument.ToString().Split('$')[0];
            string ID = e.CommandArgument.ToString().Split('$')[1];
            string str = " SELECT ipa.ID,ia.TransactionID,ipa.PanelApprovedAmt,ia.TotalBilledAmt,ia.PanelApprovalDate,ia.PanelAppRemarks,ia.ClaimNo,ipa.AmountApprovalType, " +
                         " ipa.PanelApprovalType,ipa.PanelID FROM f_IpdPanelApproval ipa INNER JOIN patient_medical_history ia ON ia.TransactionID = ipa.TransactionID where ia.TransactionID = '" + TId + "' and ipa.ID = '" + ID + "'";//f_ipdadjustment
            DataTable dt = StockReports.GetDataTable(str);
            txtPanelBillAmt.Text = dt.Rows[0]["PanelApprovedAmt"].ToString();
            ViewState["PrePanelApprovedAmt"] = dt.Rows[0]["PanelApprovedAmt"].ToString();

            txtClaimNo.Text = dt.Rows[0]["ClaimNo"].ToString();
            txtRemarks.Text = dt.Rows[0]["PanelAppRemarks"].ToString();
            ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue(dt.Rows[0]["PanelID"].ToString()));
            rdoAppType.Visible = false;
            ViewState["ApprovalID"] = ID.ToString();
            btnUpdateBilling.Text = "Edit";
        }
    }
    protected void rdoAppWay_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoAppWay.SelectedItem.Value == "Fix")
        {
            pnlVisible.Visible = true;
        }
        else
        {
            pnlVisible.Visible = false;
        }
    }
    protected void grdPanel_App_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            int active = Util.GetInt(((Label)e.Row.FindControl("lblIsActive")).Text);
            if (active == 0)
                e.Row.Attributes.Add("style", "background-color:#90EE90");
            DateTime panelAppDate = Util.GetDateTime(((Label)e.Row.FindControl("lblPanelApprovalDate")).Text);
            DateTime currentDate = Util.GetDateTime(DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss"));
            var diff = currentDate.Subtract(panelAppDate).TotalHours;
            //if (diff > 72 || active == 0)
            //{
            //    ((ImageButton)e.Row.FindControl("imgEdit")).Visible = false;
            //    ((ImageButton)e.Row.FindControl("imgReject")).Visible = false;
            //}
        }
    }

    protected void btnOKRejection_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string PanelAlreadyApp = StockReports.ExecuteScalar("SELECT PanelApprovedAmt FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ");//f_ipdadjustment
            string AlreadyPatientcashAmt = StockReports.ExecuteScalar("SELECT PatientcashAmt FROM patient_medical_history WHERE TransactionID='" + ViewState["TransactionID"].ToString() + "' ");//f_ipdadjustment
            int PanelID = Util.GetInt(StockReports.ExecuteScalar(" SELECT PanelID from f_IpdPanelApproval where TransactionID='" + ViewState["TransactionID"].ToString() + "' and ID='" + ViewState["lblID"] + "' "));
            
            
            string str = "UPDATE patient_medical_history SET PatientcashAmt=" + (Util.GetDecimal(AlreadyPatientcashAmt) + Util.GetDecimal(ViewState["PanelApprovedAmt"])) + ", PanelApprovedAmt=" + (Util.GetDecimal(PanelAlreadyApp) - Util.GetDecimal(ViewState["PanelApprovedAmt"])) + " where TransactionID='" + ViewState["TransactionID"].ToString() + "'";//f_ipdadjustment

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str);

            string str1 = "UPDATE f_IpdPanelApproval SET RejectedBy='" + Session["ID"].ToString() + "',LastUpdatedBy = '" + Session["UserName"].ToString() + "',UpdatedDate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "',Reason='" + txtCancelReason.Text + "', isActive=0 where TransactionID='" + ViewState["TransactionID"].ToString() + "' and ID='" + ViewState["lblID"] + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str1);

            if (Resources.Resource.skipPanelAllocation == "1")
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO panel_amountallocation (PanelID, TransactionID, Amount, EntryBy, EntryType ) VALUES (" + PanelID + ",'" + ViewState["TransactionID"].ToString() + "'," + -1*Util.GetDecimal(ViewState["PanelApprovedAmt"].ToString()) + ",'" + Session["ID"].ToString() + "','DR') ");


            


            Tranx.Commit();
            txtCancelReason.Text = " ";
            lblMsg.Text = "Record Updated successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "location.href='UpdatePanelApproval.aspx?TransactionID=" + ViewState["TransactionID"] + "';", true);
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog objErr = new ClassLog();
            objErr.errLog(ex);
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void ddlPanelCompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dtPanel = StockReports.GetDataTable("SELECT TRIM(Company_Name) AS Company_Name,pm.PanelID,ReferenceCode,ReferenceCodeOPD,IsCash,applyCreditLimit,CreditLimitType,pae.ApprovalAmount ,pae.IsThroughsmartCard " +
                         "FROM f_panel_master pm INNER JOIN f_rate_schedulecharges sc ON pm.ReferenceCode=sc.PanelID INNER JOIN f_center_panel fcp ON pm.PanelID=fcp.panelID INNER JOIN panelapproval_emaildetails pae ON pm.PanelID=pae.panelID and pae.panelID='" + ddlPanelCompany.SelectedValue + "' where sc.IsDefault=1 and pm.Isactive=1  AND pm.DateTo>NOW() AND  fcp.CentreID='" + Session["CentreID"].ToString() + "' AND fcp.isActive=1 AND pae.TransactionID='" + ViewState["TransactionID"].ToString() + "' Group By PanelID  ORDER BY Company_Name ");

        txtPanelBillAmt.Text = dtPanel.Rows[0]["ApprovalAmount"].ToString();
        if (Util.GetInt(dtPanel.Rows[0]["IsThroughsmartCard"].ToString()) == 1)
        {
           // txtPanelBillAmt.Attributes.Add("readOnly", "readOnly");
            txtPanelBillAmt.Attributes.Remove("readOnly");

        }
        else
        {
            txtPanelBillAmt.Attributes.Remove("readOnly");

        }

    }
}
