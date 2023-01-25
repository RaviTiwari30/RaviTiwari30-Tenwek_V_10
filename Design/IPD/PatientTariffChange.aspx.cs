using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
using System.Text;

public partial class Design_IPD_PatientTariffChange : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
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

            AllQuery AQ = new AllQuery();
            DataTable dt = AQ.GetPatientAdjustmentDetails(ViewState["TransactionID"].ToString());
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;

            if (dt != null && dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["IsBillFreezed"].ToString() == "1")
                {
                    DataTable dtAuthoritys = (DataTable)ViewState["Authority"];
                    if ((dt.Rows[0]["IsBillFreezed"].ToString() == "1") && (dtAuthoritys != null && dtAuthoritys.Rows.Count > 0))
                    {
                        string Msg = "";
                        int auth = AllLoadData_IPD.IPDBillAuthorization(Session["ID"].ToString(), Util.GetInt(Session["RoleID"].ToString()));
                        if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "0" && auth == 0)
                        {
                            Msg = "You Are Not Authorised To AMEND IPD Bills...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                        else if (dtAuthoritys.Rows[0]["BillChange"].ToString() == "1" && dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                        {
                            Msg = "Patient's Final Bill has been Closed for Further Updating...";
                            Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                        }
                    }
                    else if (dt.Rows[0]["IsBillFreezed"].ToString().Trim() == "1" && (dtAuthoritys != null && dtAuthoritys.Rows.Count == 0))
                    {
                        string Msg = "";
                        Msg = "You Are Not Authorised To AMEND This IPD Bills...";
                        Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                    }
                }

                if (dt.Rows[0]["IsBilledClosed"].ToString().Trim() == "1")
                {
                    string Msg = "";
                    Msg = "Patient's Final Bill has been Closed for Further Updating...";
                    Response.Redirect("PatientBillMsg.aspx?msg=" + Msg);
                }
            }

            All_LoadData.BindRelation(ddlHolder_Relation);
            rbtChange.Focus();
            CaseTypeBind();
            BindPanels();
            ddlBillCategory.Visible = false;
            ddlPanelCompany.Visible = false;

            DataTable dtPanel = GetPanelAndBillingCategory(ViewState["TransactionID"].ToString());

            if (dtPanel != null && dtPanel.Rows.Count > 0)
            {
                string PanelRef = dtPanel.Rows[0]["PanelID"].ToString() + "#" + dtPanel.Rows[0]["ReferenceCode"].ToString();
                ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue(PanelRef));

                txtCardNo.Text = dtPanel.Rows[0]["CardNo"].ToString();
                txtEmpID.Text = dtPanel.Rows[0]["EmployeeID"].ToString();
                txtPolicyNo.Text = dtPanel.Rows[0]["PolicyNo"].ToString();
                txtfile_no.Text = dtPanel.Rows[0]["FileNo"].ToString();
                txtCHName.Text = dtPanel.Rows[0]["CardHolderName"].ToString();
                ddlHolder_Relation.SelectedIndex = ddlHolder_Relation.Items.IndexOf(ddlHolder_Relation.Items.FindByText(dtPanel.Rows[0]["RelationWith_holder"].ToString()));


            }

            LoadStatus();
            //  hide();


        }

        lblMsg.Text = "";
    }

    private void BindPanels()
    {
        DataTable dtPanel = All_LoadData.LoadPanelIPD();
        foreach (DataRow dr in dtPanel.Rows)
        {
            ListItem li1 = new ListItem(dr[0].ToString(), dr[1].ToString() + "#" + dr[2].ToString());
            ddlPanelCompany.Items.Add(li1);
        }

        ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue("1#1"));
    }



    private void CaseTypeBind()
    {
        try
        {
            string sql = "select Name,IPDCaseTypeID from ipd_case_type_master where IsActive=1 and IPDCaseTypeID in (Select distinct BillingCategoryID from ipd_case_type_master)";
            DataTable dt = StockReports.GetDataTable(sql);
            ddlBillCategory.DataSource = dt;
            ddlBillCategory.DataTextField = "Name";
            ddlBillCategory.DataValueField = "IPDCaseTypeID";
            ddlBillCategory.DataBind();
        }

        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
    }

    protected void btnApproveRate_Click(object sender, EventArgs e)
    {
        if (ViewState["ScheduleChargeID"].ToString() == "")
        {
            lblMsg.Text = "Rate is Not Set Under this Panel & RoomType. Please Contact EDP to Set Rate";
            return;

        }
        DataTable dt = GetPanelAndBillingCategory(ViewState["TransactionID"].ToString());
        string panelId = dt.Rows[0]["PanelID"].ToString();

        if (panelId != "1" && ddlPanelCompany.SelectedItem.Text != "CASH")
        {
            //if (txtEmpID.Text.Trim() == "")
            //{
            //    lblMsg.Text = "Please Enter Staff ID";
            //    txtEmpID.Focus();
            //    return;
            //}

            if (txtPolicyNo.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter Policy No.";
                txtPolicyNo.Focus();
                return;
            }

            if (txtCardNo.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter Card No.";
                txtCardNo.Focus();
                return;
            }
            //if (txtfile_no.Text == "")
            //{
            //    lblMsg.Text = "Please Enter File No.";
            //    txtfile_no.Focus();
            //    return;
            //}
            if (txtCHName.Text == "")
            {
                lblMsg.Text = "Please Enter Card Holder Name";
                txtCHName.Focus();
                return;
            }
            if (ddlHolder_Relation.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Enter Card Holder Relation";
                ddlHolder_Relation.Focus();
                return;
            }
        }
        if (ddlPanelCompany.SelectedItem.Text != "CASH")
        {
            //if (txtEmpID.Text.Trim() == "")
            //{
            //    lblMsg.Text = "Please Enter Staff ID";
            //    txtEmpID.Focus();
            //    return;
            //}

            if (txtPolicyNo.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter Policy No.";
                txtPolicyNo.Focus();
                return;
            }

            if (txtCardNo.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter Card No.";
                txtCardNo.Focus();
                return;
            }
            //if (txtfile_no.Text == "")
            //{
            //    lblMsg.Text = "Please Enter File No.";
            //    txtfile_no.Focus();
            //    return;
            //}
            if (txtCHName.Text == "")
            {
                lblMsg.Text = "Please Enter Card Holder Name";
                txtCHName.Focus();
                return;
            }
            if (ddlHolder_Relation.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Enter Card Holder Relation";
                ddlHolder_Relation.Focus();
                return;
            }
        }
        string File = "";
        if (txtfile_no.Text != "")
        {
            File = Util.GetString(txtfile_no.Text);
        }


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string str = "Update Patient_Medical_History Set PanelID=" + ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString() + ",PolicyNo='" + txtPolicyNo.Text.Trim() + "',CardNo='" + txtCardNo.Text.Trim() + "',EmployeeID='" + txtEmpID.Text.Trim() + "',ScheduleChargeID='" + ViewState["ScheduleChargeID"].ToString() + "',LastUpdatedBy = '" + ViewState["USERID"] + "',Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "',FileNo='" + File + "',CardHolderName='" + txtCHName.Text + "',RelationWith_holder='" + ddlHolder_Relation.SelectedItem.Text + "',ParentID=" + ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString() + "  Where TransactionID='" + ViewState["TransactionID"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            str = "Update f_ledgertransaction Set PanelID=" + ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString() + ",EditUSerID = '" + ViewState["USERID"] + "',EditDateTime = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  Where TransactionID='" + ViewState["TransactionID"].ToString() + "'";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            string PatientIPDProfileID = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "Select max(pip.PatientIPDProfile_ID) from patient_ipd_profile pip where pip.TransactionID='" + ViewState["TransactionID"].ToString() + "'"));

            str = "Update Patient_IPD_Profile Set PanelID=" + ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString() + ", " +
                "IPDCaseTypeID_Bill='" + ddlBillCategory.SelectedItem.Value + "',LastUpdatedBy = '" + ViewState["USERID"] + "',Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  " +
                "Where PatientIPDProfile_ID =" + PatientIPDProfileID + "";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            //str = "Update f_ipdadjustment Set PanelID=" + ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString() + ",LastUpdatedBy = '" + ViewState["USERID"] + "',Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  Where TransactionID='" + ViewState["TransactionID"].ToString() + "'";
            //MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);


            if (chkTariff.Checked)
            {
                // str = "Select LedgerTransactionNO,ItemID,Rate,Amount,DiscountPercentage,LedgerTnxID,Surgery_ID from f_ledgertnxdetail where TransactionID='" + ViewState["TransactionID"].ToString() + "' and IsVerified=1 and ISSurgery=1";
                str = "Select LedgerTransactionNO,ItemID,sc.SubCategoryID,sc.CategoryID,Rate,Amount,DiscountPercentage,LedgerTnxID,SurgeryID,pmh.PatientTypeID from f_ledgertnxdetail ltd inner join patient_medical_history pmh on pmh.TransactionID=ltd.TransactionID inner join f_subcategorymaster sc on sc.SubCategoryID=ltd.SubCategoryID where LTD.TransactionID='" + ViewState["TransactionID"].ToString() + "' and IsVerified=1 and ISSurgery=1";

                DataSet ds = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, str);

                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    decimal TotalSurgeryAmount = Util.GetDecimal(ds.Tables[0].Compute("sum(Rate)", ""));

                    DataColumn dc = new DataColumn("Percentage", typeof(decimal));
                    dc.DefaultValue = 0;
                    ds.Tables[0].Columns.Add(dc);

                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        dr["Percentage"] = Util.GetDecimal((Util.GetDecimal(dr["Rate"]) / TotalSurgeryAmount) * 100);
                    }

                    ds.Tables[0].AcceptChanges();

                    decimal TotalRate = Util.GetDecimal(StockReports.ExecuteScalar("Select Rate from f_surgery_rate_list where Surgery_ID='" + ds.Tables[0].Rows[0]["SurgeryID"].ToString() + "' and PanelID='" + ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString() + "' and IPDCaseTypeID='" + ddlBillCategory.SelectedItem.Value + "' and ScheduleChargeID=" + ViewState["ScheduleChargeID"].ToString() + " "));

                    if (TotalRate > 0)
                    {
                        foreach (DataRow row in ds.Tables[0].Rows)
                        {
                            decimal ItemRate = (TotalRate * Util.GetDecimal(row["Percentage"]) / 100);

                            // decimal ItemDisc = (ItemRate * Util.GetDecimal(row["DiscountPercentage"]) / 100);

                            //Devendra  Panelwise Discount

                            decimal ItemDiscPercentage = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "select Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + "," + row["PatientTypeID"].ToString() + ",'" + row["ItemID"].ToString() + "','" + row["SubCategoryID"].ToString() + "','" + row["CategoryID"].ToString() + "',2)"));
                            decimal ItemDisc = (ItemRate * Util.GetDecimal(ItemDiscPercentage) / 100);
                            decimal Copay = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "select Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + "," + row["PatientTypeID"].ToString() + ",'" + row["ItemID"].ToString() + "','" + row["SubCategoryID"].ToString() + "','" + row["CategoryID"].ToString() + "',3)"));
                            int IsPayable = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "select Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + "," + row["PatientTypeID"].ToString() + ",'" + row["ItemID"].ToString() + "','" + row["SubCategoryID"].ToString() + "','" + row["CategoryID"].ToString() + "',1)"));

                            // str = " Update f_ledgertnxdetail Set Rate =" + ItemRate + ",Amount=" + (ItemRate - ItemDisc) + ",NetItemAmt=" + (ItemRate - ItemDisc) + ",LastUpdatedBy = '" + ViewState["USERID"] + "',Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  Where LedgerTnxID ='" + row["LedgerTnxID"].ToString() + "'";                         
                            str = " Update f_ledgertnxdetail Set DiscUserID='" + Session["ID"].ToString() + "',CoPayPercent=" + Copay + ",IsPayable=" + IsPayable + ",Rate =" + ItemRate + ",DiscountPercentage=" + ItemDiscPercentage + ",DiscAmt=" + ItemDisc + ",Amount=" + (ItemRate - ItemDisc) + ",NetItemAmt=" + (ItemRate - ItemDisc) + ",LastUpdatedBy = '" + ViewState["USERID"] + "',Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "'  Where LedgerTnxID ='" + row["LedgerTnxID"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

                            str = " Update f_surgery_discription sd left join f_surgery_doctor sDoc on " +
                            "sd.SurgeryTransactionID = sdoc.SurgeryTransactionID " +
                            "Set sd.Rate=" + ItemRate + ",sd.Amount=" + (ItemRate - ItemDisc) + ",sd.Discount=" + ItemDisc + ",sDoc.Discount=" + ItemDisc + ",sDoc.Amount =" + (ItemRate - ItemDisc) + " " +
                            ",sd.LastUpdatedBy = '" + ViewState["USERID"] + "',sd.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',sd.IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' " +
                             ",sDoc.LastUpdatedBy = '" + ViewState["USERID"] + "',sDoc.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',sDoc.IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "' " +
                            "where sd.LedgerTransactionNo='" + row["LedgerTransactionNo"].ToString() + "' and sd.ItemID ='" + row["ItemID"].ToString() + "'";
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                        }
                    }

                }

                str = " Update f_ledgertnxdetail ltd inner join f_subcategorymaster sc on ltd.subcategoryID = sc.SubcategoryID  " +
                    //Devendra Singh
                      " inner join patient_medical_history pmh ON pmh.TransactionID=ltd.TransactionID " +
                      " inner join f_configrelation cf on cf.CategoryID = sc.CategoryID left join f_ratelist_ipd rt on " +
                      " ltd.itemid = rt.itemid and rt.PanelID=" + ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString() + "  " +
                      " and rt.scheduleChargeID=" + ViewState["ScheduleChargeID"].ToString() + " and rt.ipdcasetypeID='" + ddlBillCategory.SelectedItem.Value + "'  and rt.IsCurrent=1 " +
                      " Set ltd.Rate=ifnull(rt.Rate,0), " +
                      " ltd.Amount=if(ltd.IsPackage=0,((ifnull(rt.Rate,0) * ltd.Quantity)-ROUND((((ifnull(rt.Rate,0) * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2))/100),2)),0), " +
                      " ltd.NetItemAmt=if(ltd.IsPackage=0,((ifnull(rt.Rate,0) * ltd.Quantity)-ROUND((((ifnull(rt.Rate,0) * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2))/100),2)),0), " +
                    //Devendra Singh
                      " ltd.CoPayPercent=Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,3),ltd.DiscountPercentage=Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2),ltd.IsPayable=Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,1),ltd.DiscAmt=round((((ifnull(rt.Rate,0) * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + ddlPanelCompany.SelectedItem.Value.Split('#')[0] + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2))/100),2),ltd.DiscUserID='" + Session["ID"].ToString() + "' " +
                      " ,ltd.ItemName = IF(IFNULL(rt.ItemCode,'')<>'',IF(IFNULL(rt.ItemDisplayName,'')='',CONCAT(ltd.ItemName,' (',rt.ItemCode,')'),CONCAT(rt.ItemDisplayName,' (',rt.ItemCode,')')),ltd.ItemName) " +
                      ",ltd.LastUpdatedBy = '" + ViewState["USERID"] + "',ltd.Updatedate = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "',ltd.IpAddress = '" + Util.GetString(All_LoadData.IpAddress()) + "',ltd.`GrossAmount`=IFNULL(rt.Rate,0) * ltd.Quantity ,ltd.`TotalDiscAmt`=ROUND((((IFNULL(rt.Rate,0) * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(43,pmh.PatientTypeID ,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2))/100),2) " +
                      "  Where ltd.TransactionID='" + ViewState["TransactionID"].ToString() + "' and ltd.IsVerified=1 and ltd.IsSurgery=0 and ltd.isPackage=0 and cf.ConfigID <>11 AND ucase(sc.DisplayName)<>'MEDICINE & CONSUMABLES' ";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);

            }

            //Devendra Singh 2018-11-12 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertIPDRevenue(ViewState["TransactionID"].ToString(), "R", Tnx));
                if (IsIntegrated == "0")
                {
                    Tnx.Rollback();
                    Tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
            }

            Tnx.Commit();
            con.Close();
            con.Dispose();

            if (chkTariff.Checked == true && rbtChange.SelectedItem.Value == "2")
                lblMsg.Text = "Billing Rates has been Changed for this Patient On Change of Billing Category";
            else if (chkTariff.Checked == true && rbtChange.SelectedItem.Value == "1")
                lblMsg.Text = "Billing Rates has been Changed for this Patient On Change of Panel";
            else
                lblMsg.Text = "Policy Details Updated";
            chkTariff.Checked = false;
            if (rbtChange.SelectedValue == "1") //Panel
            {
                lbllCurrent.Text = ddlPanelCompany.SelectedItem.Text;
            }
            else
            {
                lbllCurrent.Text = ddlBillCategory.SelectedItem.Text;
            }
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error on Updation";
        }
    }

    private void LoadDiffPanelRates(string TID, string PanelID, string IPDCaseTypeID, int ScheduleChargeID, string ActualPanelID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select Category,Round(sum(ExistingRate * Qty),2)CurrentGrossBill,Round(sum(DiscAmt),2)TotalDiscAmt, ");
        sb.Append("Round(sum(ProposedRate * Qty),2)ProposedGrossBill,");
        sb.Append("ROUND(SUM(ProposedDiscAmt),2)ProposedDiscAmt, ");
        sb.Append("Round(sum(AmtDiff),2)GrossAmtDiff from ( ");
        sb.Append("    Select (Select if(ifnull(DisplayName,'')='',Name,DisplayName) from f_subcategorymaster where  ");
        sb.Append("    SubCategoryID=ltd.subcategoryID)Category,ltd.ItemName,ltd.Rate ExistingRate,ltd.Quantity Qty, ");

        //Devendra Singh
        //  sb.Append("    (((ifnull(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100) DiscAmt,ifnull(rt.Rate,0)ProposedRate,  ");
        sb.Append("    (((ltd.Rate * ltd.Quantity)*ltd.DiscountPercentage)/100) DiscAmt,ifnull(rt.Rate,0)ProposedRate,  ");
        sb.Append(" ROUND(((IFNULL(rt.Rate,0) * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + ActualPanelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2)*0.01),2)ProposedDiscAmt, ");
        sb.Append(" ROUND(((IFNULL(rt.Rate,0) * ltd.Quantity)-(ltd.Rate*ltd.Quantity)),2) AmtDiff  ");
        //  sb.Append("    (( ifnull(rt.Rate,0) * ltd.Quantity)-(( ifnull(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100)-ltd.Amount AmtDiff  ");
        sb.Append("    from f_ledgertnxdetail ltd inner join f_subCategorymaster sc on sc.SubCategoryID = ltd.SubCategoryID ");
        sb.Append("    INNER JOIN patient_medical_history pmh ON ltd.TransactionID=pmh.TransactionID ");
        sb.Append("    inner join f_Configrelation cf on cf.CategoryID = sc.CategoryID left join f_ratelist_ipd rt on  ");
        sb.Append("    ltd.itemid = rt.itemid and rt.PanelID=" + PanelID + "  ");
        sb.Append("    and rt.ipdcasetypeID='" + IPDCaseTypeID + "' and rt.IsCurrent=1 LEFT JOIN f_rate_schedulecharges sch ON sch.panelID = rt.PanelID AND sch.IsDefault=1 ");
        sb.Append("    Where ltd.TransactionID='" + TID + "' and ltd.IsVerified=1 and ltd.IsSurgery=0 and ltd.isPackage=0 and cf.ConfigID <>11");
        sb.Append("    Union All  ");
        sb.Append("    Select  concat('Surgery Charges - ',ltd.Surgeryname)Category,  ");

        //Devendra Singh
        // sb.Append("    ltd.ItemName,ltd.Rate ExistingRate,ltd.Quantity Qty,((( ifnull(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100) DiscAmt, ifnull(rt.Rate,0)ProposedRate, ");
        sb.Append("    ltd.ItemName,ltd.Rate ExistingRate,ltd.Quantity Qty,((( ltd.Rate * ltd.Quantity)*ltd.DiscountPercentage)/100) DiscAmt, ROUND(((IFNULL(rt.Rate,0)*((ltd.Rate/lt.NetAmount)*100))/100),2)ProposedRate, ");
        sb.Append("    ROUND(((ROUND(((IFNULL(rt.Rate,0)*((ltd.Rate/lt.NetAmount)*100))/100),2) * ltd.Quantity)*Get_PanelwiseDiscount_CoPay_NonPayable(" + ActualPanelID + ",pmh.PatientTypeID,ltd.ItemID,ltd.SubCategoryID,sc.CategoryID,2)*0.01),2)ProposedDiscAmt, ");
        sb.Append("    ROUND(((ROUND(((IFNULL(rt.Rate,0)*((ltd.Rate/lt.NetAmount)*100))/100),2) * ltd.Quantity)-(ltd.Rate*ltd.Quantity)),2) AmtDiff  ");
        //   sb.Append("    (( ifnull(rt.Rate,0) * ltd.Quantity)-(( ifnull(rt.Rate,0) * ltd.Quantity)*ltd.DiscountPercentage)/100)-ltd.Amount AmtDiff  ");
        sb.Append("    from f_ledgertnxdetail ltd ");
        //Devendra Singh
        sb.Append("    INNER JOIN F_LedgerTransaction lt ON lt.LedgerTransactionNo= ltd.LedgerTransactionNo  ");
        sb.Append("    INNER JOIN f_subCategorymaster sc ON sc.SubCategoryID = ltd.SubCategoryID  ");
        sb.Append("    INNER JOIN patient_medical_history pmh ON ltd.TransactionID=pmh.TransactionID ");

        sb.Append("    left join f_surgery_rate_list rt on ltd.SurgeryID = rt.Surgery_ID and rt.PanelID=" + PanelID + "  ");
        sb.Append("    and rt.ipdcasetypeID='" + IPDCaseTypeID + "'  and rt.IsCurrent=1 LEFT JOIN f_rate_schedulecharges sch ON sch.panelID = rt.PanelID AND sch.IsDefault=1 ");
        sb.Append("    Where ltd.TransactionID='" + TID + "' and ltd.IsVerified=1 and ltd.IsSurgery=1 and ltd.isPackage=0 ");
        sb.Append(") t group by Category");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            grdPanelRate.DataSource = dt;
            grdPanelRate.DataBind();

            lblPropesedTotal.Text = "Current Gross Total : " + dt.Compute("sum(CurrentGrossBill)", "").ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;Proposed Gross Total : " + dt.Compute("sum(ProposedGrossBill)", "").ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;Total Gross AmtDiff : " + dt.Compute("sum(GrossAmtDiff)", "").ToString();
        }
    }

    private void LoadStatus()
    {
        if (rbtChange.SelectedValue == "1") //Panel
        {
            ddlBillCategory.Visible = false;
            ddlPanelCompany.Visible = true;

            DataTable dt = GetPanelAndBillingCategory(ViewState["TransactionID"].ToString());
            lblCurrentName.Text = "Current Panel :";
            lbllCurrent.Text = dt.Rows[0]["Company_Name"].ToString();
            lblName.Text = "Proposed Panel";
            ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByText(dt.Rows[0]["Company_Name"].ToString()));
            string ProposedScheduleChargeID = StockReports.GetCurrentRateScheduleID(Util.GetInt(ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString()));
            ViewState["ScheduleChargeID"] = ProposedScheduleChargeID;
            //LoadDiffPanelRates(dt.Rows[0]["TransactionID"].ToString(), ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString(), ddlBillCategory.SelectedItem.Value, Util.GetInt(ProposedScheduleChargeID), ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString());


        }
        else //CaseType
        {
            ddlBillCategory.Visible = true;
            ddlPanelCompany.Visible = false;

            DataTable dt = GetPanelAndBillingCategory(ViewState["TransactionID"].ToString());
            lblCurrentName.Text = "Current Billing Category :";
            lbllCurrent.Text = dt.Rows[0]["RoomCategory"].ToString();
            lblName.Text = "Proposed Billing Category :";
            ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(dt.Rows[0]["IPDCaseTypeID_Bill"].ToString()));
            ViewState["ScheduleChargeID"] = dt.Rows[0]["ScheduleChargeID"].ToString();
            LoadDiffPanelRates(dt.Rows[0]["TransactionID"].ToString(), ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString(), ddlBillCategory.SelectedItem.Value, Util.GetInt(dt.Rows[0]["ScheduleChargeID"].ToString()), ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString());

        }
    }

    private DataTable GetPanelAndBillingCategory(string TID)
    {
        return StockReports.GetDataTable("SELECT pip.*,pmh.PanelID,pnl.ReferenceCode,pnl.Company_Name,icm.Name RoomCategory,pmh.ScheduleChargeID," +
        "PolicyNo,CardNo,Employeeid,FileNo,pmh.CardHolderName,pmh.RelationWith_holder FROM ( " +
        "    SELECT IPDCaseTypeID,IPDCaseTypeID_Bill,TransactionID FROM patient_ipd_profile  " +
        "    WHERE TransactionID='" + TID + "' ORDER BY PatientIPDProfile_ID DESC LIMIT 1  " +
        ")pip INNER JOIN patient_medical_history pmh ON pip.TransactionID = pmh.TransactionID INNER JOIN f_panel_master pnl ON  " +
        "pmh.PanelID = pnl.PanelID inner join ipd_Case_Type_Master icm on icm.IPDCaseTypeID = pip.IPDCaseTypeID_Bill WHERE pmh.TransactionID='" + TID + "'");
    }

    protected void rbtChange_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadStatus();
        txtCardNo.Text = "";
        txtCHName.Text = "";
        txtEmpID.Text = "";
        txtfile_no.Text = "";
        txtPolicyNo.Text = "";
        ddlHolder_Relation.SelectedIndex = 0;
        chkTariff.Checked = false;
        DataTable dtPanel = GetPanelAndBillingCategory(ViewState["TransactionID"].ToString());

        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            string PanelRef = dtPanel.Rows[0]["PanelID"].ToString() + "#" + dtPanel.Rows[0]["ReferenceCode"].ToString();
            ddlPanelCompany.SelectedIndex = ddlPanelCompany.Items.IndexOf(ddlPanelCompany.Items.FindByValue(PanelRef));

            txtCardNo.Text = dtPanel.Rows[0]["CardNo"].ToString();
            txtEmpID.Text = dtPanel.Rows[0]["EmployeeID"].ToString();
            txtPolicyNo.Text = dtPanel.Rows[0]["PolicyNo"].ToString();
            txtfile_no.Text = dtPanel.Rows[0]["FileNo"].ToString();
            txtCHName.Text = dtPanel.Rows[0]["CardHolderName"].ToString();
            ddlHolder_Relation.SelectedIndex = ddlHolder_Relation.Items.IndexOf(ddlHolder_Relation.Items.FindByText(dtPanel.Rows[0]["RelationWith_holder"].ToString()));


        }
    }
    protected void ddlBillCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ProposedScheduleChargeID = StockReports.GetPatientCurrentRateScheduleID_IPD(ViewState["TransactionID"].ToString());
        //LoadDiffPanelRates(ViewState["TransactionID"].ToString(), ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString(), ddlBillCategory.SelectedItem.Value, Util.GetInt(ProposedScheduleChargeID), ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString());
        ViewState["ScheduleChargeID"] = ProposedScheduleChargeID;
    }
    protected void ddlPanelCompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ProposedScheduleChargeID = StockReports.GetCurrentRateScheduleID(Util.GetInt(ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString()));
        ViewState["ScheduleChargeID"] = ProposedScheduleChargeID;
        //LoadDiffPanelRates(ViewState["TransactionID"].ToString(), ddlPanelCompany.SelectedItem.Value.Split('#')[1].ToString(), ddlBillCategory.SelectedItem.Value, Util.GetInt(ProposedScheduleChargeID), ddlPanelCompany.SelectedItem.Value.Split('#')[0].ToString());
        //if (ddlPanelCompany.SelectedItem.Text.ToUpper() != "CASH")
        //{
        //    txtCardNo.Enabled = true;
        //    txtCHName.Enabled = true;
        //    txtEmpID.Enabled = true;
        //    txtfile_no.Enabled = true;
        //    txtPolicyNo.Enabled = true;
        //    ddlHolder_Relation.Enabled = true;
        //}
        //else
        //{
        //    txtCardNo.Enabled = false;
        //    txtCHName.Enabled = false;
        //    txtEmpID.Enabled = false;
        //    txtfile_no.Enabled = false;
        //    txtPolicyNo.Enabled = false;
        //    ddlHolder_Relation.Enabled = false;
        //}
    }
    private void hide()
    {
        DataTable dtPanel = GetPanelAndBillingCategory(ViewState["TransactionID"].ToString());
        if (dtPanel.Rows[0]["Company_Name"].ToString().ToUpper() == "CASH")
        {
            txtCardNo.Enabled = false;
            txtCHName.Enabled = false;
            txtEmpID.Enabled = false;
            txtfile_no.Enabled = false;
            txtPolicyNo.Enabled = false;
            ddlHolder_Relation.Enabled = false;

        }
        else
        {
            txtCardNo.Enabled = true;
            txtCHName.Enabled = true;
            txtEmpID.Enabled = true;
            txtfile_no.Enabled = true;
            txtPolicyNo.Enabled = true;
            ddlHolder_Relation.Enabled = true;
        }
    }
}
