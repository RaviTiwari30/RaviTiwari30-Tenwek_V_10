using AjaxControlToolkit;
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

public partial class Design_IPD_AttenderRoom : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
            All_LoadData.BindRelation(ddlRelationship);
            ViewState["ID"] = Session["ID"].ToString();
            bindPatientDetails(TID);
            bindRoomCategory();
            bindAvailableRooms(ddlRoomType.SelectedValue.ToString());
            bindRoomDetails(TID);
        }
        ((TextBox)txtDate.FindControl("txtStartDate")).Attributes.Add("readOnly", "readOnly");
    }

    public void bindRoomDetails(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pip.ID attendentID,REPLACE(pip.TransactionID,'ISHHI','')IPDNo,pmh.PatientID MRNo,pip.Name,(ictm.Name)RoomType,pip.RoomID,pip.attenderType, ");
        sb.Append(" CONCAT(rm.Name,'/',rm.Bed_No)Room,pip.BillingCategory, ");
        sb.Append(" CONCAT(DATE_FORMAT(pip.StartDate,'%d-%b-%Y'),' ',TIME_FORMAT(pip.StartTime,'%h:%i %p'))EntryDate, ");
        sb.Append(" IF(pip.Status='IN','',CONCAT(DATE_FORMAT(pip.EndDate,'%d-%b-%Y'),' ',TIME_FORMAT(pip.EndTime,'%h:%i %p')))LeaveDate, ");
        sb.Append(" (SELECT Name FROM employee_master WHERE employeeid=pip.EntryBy)EntryBy,pip.Status,(SELECT Name FROM employee_master WHERE employeeid=pip.OutBy)OutBy,pip.Relationship FROM patient_attender_profile pip ");
        sb.Append(" INNER JOIN patient_medical_history pmh ON pip.TransactionID=pmh.TransactionID ");
        sb.Append(" LEFT JOIN room_master rm ON rm.roomID=pip.roomID ");
        sb.Append(" LEFT JOIN ipd_case_type_master ictm ON pip.IPDCaseTypeID=ictm.IPDCaseTypeID ");
        sb.Append(" WHERE pip.TransactionID='" + TransactionID + "' ");
        sb.Append(" ORDER BY pip.ID DESC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdRoomDetail.DataSource = dt;
            grdRoomDetail.DataBind();
            pnlAttender.Visible = true;
        }
        else
        {
            grdRoomDetail.DataSource = null;
            grdRoomDetail.DataBind();
            pnlAttender.Visible = false;
        }
    }

    private void bindAvailableRooms(string IPDCaseTypeID)
    {
        DataTable dtAvailRooms = new DataTable();
        if (rblRoomCategory.SelectedValue == "1")
            dtAvailRooms = AllLoadData_IPD.getAttendendAvailRoom(IPDCaseTypeID);
        else
            dtAvailRooms = RoomBilling.GetAvailRooms(IPDCaseTypeID);
        if (dtAvailRooms != null && dtAvailRooms.Rows.Count > 0)
        {
            ddlAvailRooms.Items.Clear();
            ddlAvailRooms.DataSource = dtAvailRooms;
            ddlAvailRooms.DataTextField = "Name";
            ddlAvailRooms.DataValueField = "roomID";
            ddlAvailRooms.DataBind();
            ddlAvailRooms.Items.Insert(0, new ListItem("Select", "0"));
            lblMsg.Text = "";
            btnSave.Enabled = true;
        }
        else
        {
            lblMsg.Text = "No Room Available under Current Selected RoomType";
            ddlAvailRooms.Items.Clear();
            btnSave.Enabled = false;
        }
    }

    private void bindPatientDetails(string TransactionID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pmh.PatientID,pmh.TransactionID,pmh.patient_type,pmh.PanelID,pmh.ScheduleChargeID,CONCAT(Date_Format(pmh.DateOfVisit,'%d-%b-%Y'),' ',Time_format(pmh.Time,'%h:%i %p'))DateOfAdmit ");
        sb.Append(" FROM patient_medical_history pmh ");
        sb.Append(" WHERE pmh.TransactionID='" + TransactionID + "' AND pmh.Status='IN' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            lblPatientID.Text = dt.Rows[0]["PatientID"].ToString();
            lblTransactionNo.Text = dt.Rows[0]["TransactionID"].ToString();
            lblPanelID.Text = dt.Rows[0]["PanelID"].ToString();
            ViewState["ScheduleChargeID"] = dt.Rows[0]["ScheduleChargeID"].ToString();
            ((CalendarExtender)txtDate.FindControl("calStartDate")).StartDate = Util.GetDateTime(dt.Rows[0]["DateOfAdmit"].ToString());
        }
    }

    protected void ddlRoomType_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindAvailableRooms(ddlRoomType.SelectedValue.ToString());
        string BillingCategoryID = StockReports.ExecuteScalar("SElect BillingCategoryID from Ipd_Case_Type_master where IPDCaseTypeID='" + ddlRoomType.SelectedValue.ToString() + "'");
        ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(BillingCategoryID));
    }

    public string GetRoomItemDetails(string PanelID, string IPDCaseTypeID, int ScheduleChargeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("      SELECT CONCAT(t1.ItemID,'#',IF(t1.Rate IS NULL,0,t1.Rate),'#',t1.SubCategoryID,'#',t1.BufferTime,'#',IFNULL(t1.ID,0))DATA ");
        sb.Append(" FROM ( ");
        sb.Append("        SELECT CONCAT(im.ItemID,'#',im.TypeName)ItemID,rt.Rate,im.SubCategoryID,im.BufferTime,rt.ID ");
        sb.Append("        FROM f_itemmaster im LEFT JOIN ( ");
        sb.Append("           SELECT ID,Rate,ItemID FROM f_ratelist_ipd WHERE PanelID=" + PanelID + " AND IPDCaseTypeID = '" + IPDCaseTypeID + "' AND ScheduleChargeID='" + ScheduleChargeID + "' ");
        sb.Append("          )  rt ON rt.ItemID = im.ItemID INNER JOIN f_subcategorymaster sc ON  sc.SubCategoryID = im.SubCategoryID INNER JOIN f_configrelation cf ");
        sb.Append("        ON cf.CategoryID = sc.CategoryID WHERE im.Type_ID = '" + IPDCaseTypeID + "' AND cf.ConfigID=2");
        sb.Append("     )t1 ");

        return StockReports.ExecuteScalar(sb.ToString());
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (btnSave.Text.ToUpper() == "OUT")
        {
            string SiftDateTime = Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(((TextBox)txtDate.FindControl("txtTime")).Text).ToString("HH:mm:ss");
            string entryDate = lblEnterydate.Text;
            TimeSpan difference = Util.GetDateTime(SiftDateTime) - Util.GetDateTime(entryDate);
            if (difference.TotalMinutes < 0)
            {
                lblMsg.Text = "Please Select Valid Out Date Time";
                return;
            }
        }

        MySqlConnection conn = Util.GetMySqlCon();
        conn.Open();
        MySqlTransaction Tnx = conn.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string SiftDate = Util.GetDateTime(((TextBox)txtDate.FindControl("txtStartDate")).Text).ToString("yyyy-MM-dd");
            string SiftTime = Util.GetDateTime(((TextBox)txtDate.FindControl("txtTime")).Text).ToString("HH:mm:ss");

            if (btnSave.Text.ToUpper() == "SAVE")
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO patient_attender_profile(Name,RelationShip,TransactionID,PatientID,IPDCaseTypeID,BillingCategory,roomID,StartDate,StartTime,Status,IPAddress,Hospital_ID,CentreID,EntryBy,attenderType)VALUES( " +
                " '" + txtName.Text.Trim() + "','" + ddlRelationship.SelectedItem.Text + "','" + lblTransactionNo.Text + "','" + lblPatientID.Text + "','" + ddlRoomType.SelectedValue + "','" + ddlBillCategory.SelectedValue + "','" + ddlAvailRooms.SelectedItem.Value + "' , " +
                " '" + Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(SiftTime).ToString("HH:mm:ss") + "','IN','" + HttpContext.Current.Request.UserHostAddress + "','" + Session["HOSPID"].ToString() + "', " +
                " '" + Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()) + "','" + ViewState["ID"].ToString() + "','" + rblRoomCategory.SelectedValue + "')");

                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE room_master SET isAttendent=1 WHERE roomID='" + ddlAvailRooms.SelectedValue + "'");

                string RoomDetail = GetRoomItemDetails(lblPanelID.Text.Trim(), ddlBillCategory.SelectedItem.Value, Util.GetInt(ViewState["ScheduleChargeID"]));

                Ledger_Transaction ObjLdgTnx = new Ledger_Transaction(Tnx);

                ObjLdgTnx.Hospital_ID = Session["HOSPID"].ToString();
                ObjLdgTnx.LedgerNoCr = AllQuery.GetLedgerNoByLedgerUserID(lblPatientID.Text, "PTNT", conn);
                ObjLdgTnx.LedgerNoDr = AllQuery.GetLedgerNoByLedgerUserID(Session["HOSPID"].ToString(), "HOSP", conn);
                ObjLdgTnx.TypeOfTnx = "IPD-Room-Shift";
                ObjLdgTnx.Date = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd"));
                ObjLdgTnx.Time = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("HH:mm:ss"));
                ObjLdgTnx.BillNo = "";
                ObjLdgTnx.NetAmount = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
                ObjLdgTnx.GrossAmount = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());

                if (lblPatientID.Text == "")
                    lblPatientID.Text = StockReports.ExecuteScalar("SELECT PatientID from patient_medical_history WHERE TransactionID='" + lblTransactionNo.Text + "'");

                ObjLdgTnx.PatientID = lblPatientID.Text;
                ObjLdgTnx.PanelID = Util.GetInt(lblPanelID.Text);
                ObjLdgTnx.TransactionID = lblTransactionNo.Text;
                ObjLdgTnx.UserID = ViewState["ID"].ToString();
                ObjLdgTnx.IpAddress = All_LoadData.IpAddress();
                ObjLdgTnx.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                string LedgerTransactionNo = ObjLdgTnx.Insert();

                if (LedgerTransactionNo != "")
                {
                    DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(lblTransactionNo.Text, conn);

                    LedgerTnxDetail ObjLdgTnxDtl = new LedgerTnxDetail(Tnx);
                    ObjLdgTnxDtl.Hospital_Id = Session["HOSPID"].ToString();
                    ObjLdgTnxDtl.LedgerTransactionNo = LedgerTransactionNo;
                    ObjLdgTnxDtl.ItemID = Util.GetString(RoomDetail.Split('#')[0].ToString());
                    ObjLdgTnxDtl.Rate = Util.GetDecimal(RoomDetail.Split('#')[2].ToString());
                    ObjLdgTnxDtl.Quantity = 1;
                    ObjLdgTnxDtl.StockID = "";
                    ObjLdgTnxDtl.IsTaxable = "NO";
                    ObjLdgTnxDtl.IsVerified = 1;
                    ObjLdgTnxDtl.TransactionID = lblTransactionNo.Text;
                    ObjLdgTnxDtl.SubCategoryID = Util.GetString(RoomDetail.Split('#')[3]);
                    ObjLdgTnxDtl.ItemName = Util.GetString(RoomDetail.Split('#')[1].ToString()) + " (Attendent Room)";
                    ObjLdgTnxDtl.UserID = ViewState["ID"].ToString();
                    ObjLdgTnxDtl.EntryDate = Util.GetDateTime(Util.GetDateTime(SiftDate).ToString("yyyy-MM-dd HH:mm:ss"));
                    ObjLdgTnxDtl.IsPayable = StockReports.GetIsPayableItems(ObjLdgTnxDtl.ItemID, ObjLdgTnx.PanelID);
                    ObjLdgTnxDtl.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                    ObjLdgTnxDtl.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(Util.GetString(RoomDetail.Split('#')[3])), conn));
                    ObjLdgTnxDtl.pageURL = All_LoadData.getCurrentPageName();
                    ObjLdgTnxDtl.RateListID = Util.GetInt(RoomDetail.Split('#')[5].ToString());
                    ObjLdgTnxDtl.IPDCaseTypeID = ddlBillCategory.SelectedItem.Value;
                    ObjLdgTnxDtl.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                    ObjLdgTnxDtl.IpAddress = All_LoadData.IpAddress();
                    ObjLdgTnxDtl.Type = "I";
                    ObjLdgTnxDtl.VarifiedUserID = ViewState["ID"].ToString();
                    if (dtPkg != null && dtPkg.Rows.Count > 0)
                    {
                        int iCtr = 0;
                        foreach (DataRow drPkg in dtPkg.Rows)
                        {
                            if (iCtr == 0)
                            {
                                DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(lblTransactionNo.Text, drPkg["PackageID"].ToString(), Util.GetString(RoomDetail.Split('#')[0].ToString()), Util.GetDecimal(RoomDetail.Split('#')[2].ToString()), 1,Util.GetInt(ObjLdgTnxDtl.IPDCaseTypeID), conn);

                                if (dtPkgDetl != null && Util.GetString(dtPkgDetl.Rows[0]["iStatus"]) != "")
                                {
                                    if (Util.GetBoolean(dtPkgDetl.Rows[0]["iStatus"]))
                                    {
                                        ObjLdgTnxDtl.Amount = 0;
                                        ObjLdgTnxDtl.DiscountPercentage = 0;
                                        ObjLdgTnxDtl.DiscAmt = 0;
                                        ObjLdgTnxDtl.IsPackage = 1;
                                        ObjLdgTnxDtl.PackageID = Util.GetString(dtPkgDetl.Rows[0]["PackageID"]);
                                        ObjLdgTnxDtl.NetItemAmt = 0;
                                        ObjLdgTnxDtl.TotalDiscAmt = 0;
                                        iCtr = 1;
                                    }
                                    else
                                    {
                                        GetDiscount ds = new GetDiscount();
                                        decimal DiscPerc = ds.GetDefaultDiscount(Util.GetString(RoomDetail.Split('#')[3]), Util.GetInt(lblPanelID.Text), Util.GetDateTime(DateTime.Now.ToString()), "", "IPD");

                                        if (DiscPerc > 0)
                                        {
                                            decimal GrossAmt = Util.GetDecimal(Util.GetDecimal(RoomDetail.Split('#')[2].ToString()));
                                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                                            ObjLdgTnxDtl.Amount = NetAmount;
                                            ObjLdgTnxDtl.DiscountPercentage = DiscPerc;
                                            ObjLdgTnxDtl.DiscAmt = GrossAmt - NetAmount;
                                            ObjLdgTnxDtl.TotalDiscAmt = (GrossAmt * DiscPerc) / 100;
                                            ObjLdgTnxDtl.NetItemAmt = NetAmount;
                                            iCtr = 1;
                                        }
                                        else
                                        {
                                            ObjLdgTnxDtl.DiscountPercentage = DiscPerc;
                                            ObjLdgTnxDtl.DiscAmt = (Util.GetDecimal(RoomDetail.Split('#')[2].ToString()) * DiscPerc) / 100;
                                            ObjLdgTnxDtl.Amount = Util.GetDecimal(Util.GetDecimal(RoomDetail.Split('#')[2].ToString()));
                                            ObjLdgTnxDtl.TotalDiscAmt = (Util.GetDecimal(RoomDetail.Split('#')[2].ToString()) * DiscPerc) / 100;
                                            ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(Util.GetDecimal(RoomDetail.Split('#')[2].ToString()));
                                            iCtr = 1;
                                        }
                                    }
                                }
                                else
                                {
                                    ObjLdgTnxDtl.Amount = 0;
                                    ObjLdgTnxDtl.DiscountPercentage = 0;
                                    ObjLdgTnxDtl.DiscAmt = 0;
                                    ObjLdgTnxDtl.IsPackage = 1;
                                    ObjLdgTnxDtl.PackageID = Util.GetString(dtPkg.Rows[0]["PackageID"]);
                                    ObjLdgTnxDtl.TotalDiscAmt = 0;
                                    ObjLdgTnxDtl.NetItemAmt = 0;
                                    iCtr = 1;
                                }
                            }
                        }
                    }
                    else
                    {
                        GetDiscount ds = new GetDiscount();
                        decimal DiscPerc = ds.GetDefaultDiscount(Util.GetString(RoomDetail.Split('#')[3]), Util.GetInt(lblPanelID.Text), Util.GetDateTime(DateTime.Now.ToString()), "", "IPD");

                        if (DiscPerc > 0)
                        {
                            decimal GrossAmt = Util.GetDecimal(Util.GetDecimal(RoomDetail.Split('#')[2].ToString()));
                            decimal NetAmount = GrossAmt - ((GrossAmt * DiscPerc) / 100);

                            ObjLdgTnxDtl.Amount = NetAmount;
                            ObjLdgTnxDtl.DiscountPercentage = DiscPerc;
                            ObjLdgTnxDtl.DiscAmt = GrossAmt - NetAmount;
                            ObjLdgTnxDtl.TotalDiscAmt = GrossAmt - NetAmount;
                            ObjLdgTnxDtl.NetItemAmt = NetAmount;
                        }
                        else
                        {
                            ObjLdgTnxDtl.DiscountPercentage = DiscPerc;
                            ObjLdgTnxDtl.DiscAmt = (Util.GetDecimal(RoomDetail.Split('#')[2].ToString()) * DiscPerc) / 100;
                            ObjLdgTnxDtl.Amount = Util.GetDecimal(Util.GetDecimal(RoomDetail.Split('#')[2].ToString()));
                            ObjLdgTnxDtl.TotalDiscAmt = (Util.GetDecimal(RoomDetail.Split('#')[2].ToString()) * DiscPerc) / 100;
                            ObjLdgTnxDtl.NetItemAmt = Util.GetDecimal(Util.GetDecimal(RoomDetail.Split('#')[2].ToString()));
                        }
                    }

                    string LdgTnxDtlID = ObjLdgTnxDtl.Insert().ToString();

                    if (LdgTnxDtlID == "")
                    {
                        return;
                    }
                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_ledgertnxdetail SET isAttendentRoom=1 Where ID='" + LdgTnxDtlID + "'");
                }
            }
            else
            {
                string str = "Update patient_attender_profile Set ";
                str += "EndDate='" + SiftDate + "',";
                str += "EndTime='" + SiftTime + "',";
                str += "Status='OUT',OutBy='" + ViewState["ID"] + "' ";
                str += "Where ID='" + lblAttendedID.Text.Split('#')[0] + "' AND Status='IN'";
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str);
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE room_master SET isAttendent=0 WHERE roomID='" + lblAttendedID.Text.Split('#')[1] + "'");
            }


            //Devendra Singh 2018-11-12 Insert Finance Integarion 
            if (Resources.Resource.AllowFiananceIntegration == "1")
            {
                string IsIntegrated = Util.GetString(EbizFrame.InsertIPDRevenue(lblTransactionNo.Text, "R", Tnx));
                if (IsIntegrated == "0")
                {
                    Tnx.Rollback();
                    Tnx.Dispose();
                }
            }

            Tnx.Commit();
            clearData();

            lblMsg.Text = "Record Saved Successfully";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();

            lblMsg.Text = "Room Is Not Shifted";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            Tnx.Dispose();
            conn.Close();
            conn.Dispose();
        }
    }

    protected void grdRoomDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblStatus")).Text.ToString().Trim() == "OUT")
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF99CC");
                ((Button)e.Row.FindControl("btnOut")).Visible = false;
            }
            else
            {
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml("#99FFCC");
                ((Button)e.Row.FindControl("btnOut")).Visible = true;
            }
        }
    }

    private void clearData()
    {
        lblDateTime.Text = "Entry ";
        btnSave.Text = "Save";
        btnCancel.Visible = false;
        lblMsg.Text = "";
        txtName.Text = "";
        txtName.Enabled = true;
        ddlRelationship.SelectedIndex = 0;
        ddlRelationship.Enabled = true;
        ddlRoomType.Enabled = true;
        ddlAvailRooms.Enabled = true;
        rblRoomCategory.SelectedIndex = 0;
        bindRoomDetails(lblTransactionNo.Text);
        bindRoomCategory();
        bindAvailableRooms(ddlRoomType.SelectedValue.ToString());

        rblRoomCategory.Enabled = true;
        ((CalendarExtender)txtDate.FindControl("calStartDate")).StartDate = DateTime.Now;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        clearData();
    }

    protected void grdRoomDetail_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Out")
        {
            btnSave.Text = "OUT";
            btnCancel.Visible = true;
            lblAttendedID.Text = e.CommandArgument.ToString();
            txtName.Text = ((Label)grdRoomDetail.Rows[0].FindControl("lblAttendedName")).Text;
            ddlRelationship.SelectedIndex = ddlRelationship.Items.IndexOf(ddlRelationship.Items.FindByValue(((Label)grdRoomDetail.Rows[0].FindControl("lblRelationship")).Text));
            rblRoomCategory.SelectedIndex = rblRoomCategory.Items.IndexOf(rblRoomCategory.Items.FindByValue(((Label)grdRoomDetail.Rows[0].FindControl("lblAttenderType")).Text));

            rblRoomCategory.Enabled = false;
            lblMsg.Text = "";
            txtName.Enabled = false;
            ddlRelationship.Enabled = false;
            ddlRoomType.Enabled = false;
            ddlAvailRooms.Enabled = false;
            ((CalendarExtender)txtDate.FindControl("calStartDate")).StartDate = Util.GetDateTime(((Label)grdRoomDetail.Rows[0].FindControl("lblEntryDate")).Text);
            lblEnterydate.Text = Util.GetDateTime(((Label)grdRoomDetail.Rows[0].FindControl("lblEntryDate")).Text).ToString("yyyy-MM-dd HH:mm:ss");
            lblDateTime.Text = "Out ";
            btnSave.Enabled = true;
        }
    }

    private void bindRoomCategory()
    {
        AllLoadData_IPD.bindCaseType(ddlRoomType, "", Util.GetInt(rblRoomCategory.SelectedValue));
        AllLoadData_IPD.bindBillingCategory(ddlBillCategory, "Select", Util.GetInt(rblRoomCategory.SelectedValue));
        ddlBillCategory.SelectedIndex = ddlBillCategory.Items.IndexOf(ddlBillCategory.Items.FindByValue(ddlRoomType.SelectedValue));
        ddlBillCategory.Enabled = false;
    }

    protected void rblRoomCategory_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindRoomCategory();
        bindAvailableRooms(ddlRoomType.SelectedValue.ToString());
    }
}