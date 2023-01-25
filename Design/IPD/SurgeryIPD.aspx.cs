using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Linq;
public partial class Design_IPD_SurgeryIPD : Page
{
    public int Flag = 0;
    decimal Total = 0;

    #region Event Handling

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TransID = string.Empty;
            if (Session["ID"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            else
            {
                ViewState.Add("USERID", Session["ID"].ToString());
            }

            if (Request.QueryString["TransactionID"] != null)
                TransID = Request.QueryString["TransactionID"].ToString();
            else if (Request.QueryString["TID"] != null)
                TransID = Request.QueryString["TID"].ToString();

            var AQ = new AllQuery();

            DataTable dt = AQ.GetPatientAdjustmentDetails(TransID);

            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]),
                Util.GetString(Session["ID"]));
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
            bindPatientInfo(TransID);

            ViewState["TID"] = TransID;
            BindDoctor();
            BindDocType();

            spnTransactionID.InnerText = ViewState["TID"].ToString();
            spnPatientID.InnerText = ViewState["PatientID"].ToString();
            spnIPD_CaseTypeID.InnerText = ViewState["IPDCaseTypeID"].ToString();
            spnRoom_ID.InnerText = ViewState["RoomID"].ToString();
            spnPatientType.InnerText = ViewState["PatientType"].ToString();
            spnScheduleChargeID.InnerText = ViewState["ScheduleChargeID"].ToString();
            spnPatientTypeID.InnerText = ViewState["PatientTypeID"].ToString();
            spnReferenceCodeIPD.InnerText = ViewState["ReferenceCode"].ToString();

            All_LoadData.bindApprovalType(ddlApproveBy);
            AllLoadData_IPD.fromDatetoDate(ViewState["TID"].ToString(), ucSurDate, ucSurDate, calucDate, calucDate);

            for (int i = 0; i < gvItem.Rows.Count; i++)
            {
                ((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked = false;
            }
            if (Request.QueryString["LedgerTransactionNo"] != null)
            {
                ViewState["IsEdit"] = "True";
                string LedgerTransID = Request.QueryString["LedgerTransactionNo"].ToString();
                ViewState["strLedgerTnxNo"] = LedgerTransID;
                LoadSurgery(LedgerTransID);
                LoadSurgeryDetail(LedgerTransID);
            }
        }


        ViewState["Selected"] = 0;
        ucSurDate.Attributes.Add("readOnly", "true");
    }

    private void bindPatientInfo(string TransID)
    {
        DataTable dt = AllLoadData_IPD.getPatientIPDInformation(TransID);
        ViewState["PatientID"] = dt.Rows[0]["PatientID"].ToString();
        ViewState["PatientType"] = dt.Rows[0]["PatientType"].ToString();
        ViewState["ScheduleChargeID"] = dt.Rows[0]["ScheduleChargeID"].ToString();
        ViewState["PanelID"] = dt.Rows[0]["panelID"].ToString();
        ViewState["IPDCaseTypeID"] = dt.Rows[0]["IPDCaseTypeID"].ToString();
        ViewState["RoomID"] = dt.Rows[0]["RoomID"].ToString();
        ViewState["PatientTypeID"] = dt.Rows[0]["PatientTypeID"].ToString();
    }

    protected void ddlDocType_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ItemType = string.Empty;
        ItemType = ddlDocType.SelectedItem.Text.ToUpper();
        if ((ItemType == "PULSE OXEMETER") || (ItemType == "CARDIAC MONITOR") || (ItemType == "ASCAN BIOMETRY"))
        {
            txtChargeAmt.Text = ddlDocType.SelectedValue.Split('#')[1].ToString();
            txtChargesPer.Text = string.Empty;
        }
        else
        {
            txtChargeAmt.Text = string.Empty;
            txtChargesPer.Text = ddlDocType.SelectedValue.Split('#')[1].ToString();
        }
        if (ddlDocType.SelectedIndex > 7)
            chkDoctor.Visible = false;
        else
            chkDoctor.Visible = true;
    }

    protected void btnAdd_Click(object sender, EventArgs e)
    {
        var dtItem = new DataTable();
        if (ViewState["SurgeryItem"] != null)
            dtItem = (DataTable)ViewState["SurgeryItem"];
        else
            dtItem = SurgeryItem();


        if (ddlDocType.SelectedIndex < 8)
        {
            string str = StockReports.GetListSelection(chkDoctor);

            if (str != string.Empty)
            {
                DataRow[] dr = dtItem.Select("DoctorID in (" + str + ")");

                if (dr.Length > 0)
                {
                    lblMsg.Text = "Doctor already";
                    return;
                }
                DataRow[] drItem = dtItem.Select("ItemID ='" + ddlDocType.SelectedValue.Split('#')[0].ToString() + "'");

                int count = str.Split(',').Length + drItem.Length;

                foreach (ListItem li in chkDoctor.Items)
                {
                    if (li.Selected)
                    {
                        DataRow row = dtItem.NewRow();

                        row["ItemID"] = ddlDocType.SelectedValue.Split('#')[0].ToString();
                        row["Type"] = ddlDocType.SelectedItem.Text;
                        row["DoctorName"] = li.Text;
                        row["DoctorID"] = li.Value;
                        row["DiscountPer"] = Util.GetDecimal(txtDiscPer.Text.Trim());
                        row["DiscountAmt"] = Util.GetDecimal(txtDiscAmt.Text.Trim());
                        row["NetAmt"] = 0;
                        row["SubCategoryID"] = ddlDocType.SelectedValue.Split('#')[2].ToString();
                        dtItem.Rows.Add(row);
                    }
                }
                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    if (Util.GetString(dtItem.Rows[i]["ItemID"]) == ddlDocType.SelectedValue.Split('#')[0].ToString())
                    {
                        if (txtChargesPer.Text.Trim() != string.Empty)
                        {
                            dtItem.Rows[i]["DoctorChargePer"] = Util.GetDecimal(txtChargesPer.Text) / count;
                            dtItem.Rows[i]["IsPer"] = true;
                            dtItem.Rows[i]["DoctorCharge"] = DBNull.Value;
                        }
                        else
                        {
                            dtItem.Rows[i]["DoctorCharge"] = Util.GetDecimal(txtChargeAmt.Text) / count;
                            dtItem.Rows[i]["DoctorChargePer"] = DBNull.Value;
                            dtItem.Rows[i]["IsPer"] = false;
                        }
                        if (txtDiscAmt.Text.Trim() != string.Empty)
                            dtItem.Rows[i]["DiscountAmt"] = Util.GetDecimal(txtDiscAmt.Text) / count;
                    }
                }
            }
            else
                lblMsg.Text = "Select Doctor";
        }
        else
        {
            DataRow[] dr1 = dtItem.Select("ItemID='" + ddlDocType.SelectedValue.Split('#')[0].ToString() + "'");

            if (dr1.Length > 0)
            {
                lblMsg.Text = "Item Already";
                return;
            }
            else
            {
                DataRow row1 = dtItem.NewRow();
                row1["ItemID"] = ddlDocType.SelectedValue.Split('#')[0].ToString();
                row1["Type"] = ddlDocType.SelectedItem.Text;
                row1["DoctorName"] = "-----";
                row1["DoctorID"] = "0";
                if (txtChargesPer.Text.Trim() != string.Empty && txtChargesPer.Text.Trim() != "0")
                {
                    row1["DoctorChargePer"] = Util.GetDecimal(txtChargesPer.Text);
                    row1["DoctorCharge"] = DBNull.Value;
                }
                else
                {
                    row1["DoctorCharge"] = Util.GetDecimal(txtChargeAmt.Text);
                    row1["DoctorChargePer"] = DBNull.Value;
                }
                if (Util.GetDecimal(txtDiscPer.Text.Trim()) > 0)
                    row1["DiscountPer"] = Util.GetDecimal(txtDiscPer.Text.Trim());
                else
                    row1["DiscountAmt"] = Util.GetDecimal(txtDiscAmt.Text.Trim());

                row1["NetAmt"] = 0;
                row1["SubCategoryID"] = ddlDocType.SelectedValue.Split('#')[2].ToString();
                dtItem.Rows.Add(row1);
            }
        }
        Clear();

        gvItem.DataSource = dtItem;
        gvItem.DataBind();
        ViewState["SurgeryItem"] = dtItem;
        sm1.SetFocus(btnAddItem);
    }

    protected void gvItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "imbRemove")
        {
            var dtItem = (DataTable)ViewState["SurgeryItem"];
            int Index = Util.GetInt(e.CommandArgument);
            string ItemID = Util.GetString(dtItem.Rows[Index]["ItemID"]);
            decimal amt = 0;
            bool IsPer = Util.GetBoolean(dtItem.Rows[Index]["IsPer"]);
            if (IsPer)
                amt = Util.GetDecimal(dtItem.Compute("sum(DoctorChargePer)", "ItemID='" + ItemID + "'"));
            else
                amt = Util.GetDecimal(dtItem.Compute("sum(DoctorCharge)", "ItemID='" + ItemID + "'"));

            dtItem.Rows[Index].Delete();
            dtItem.AcceptChanges();
            int Count = Util.GetInt(dtItem.Compute("count(ItemID)", "ItemID='" + ItemID + "'"));

            if (Count > 0)
            {
                decimal NewDocCharges = amt / Count;
                for (int i = 0; i < dtItem.Rows.Count; i++)
                {
                    if (Util.GetString(dtItem.Rows[i]["ItemID"]) == ItemID)
                    {
                        if (IsPer)
                            dtItem.Rows[i]["DoctorChargePer"] = NewDocCharges;
                        else
                            dtItem.Rows[i]["DoctorCharge"] = NewDocCharges;
                    }
                }
            }

            dtItem.AcceptChanges();
            ViewState["SurgeryItem"] = dtItem;
            gvItem.DataSource = dtItem;
            gvItem.DataBind();
            Calculator();
        }
    }

    protected void btnCalculator_Click(object sender, EventArgs e)
    {
        string a = "";
        string b = "";
        foreach (GridViewRow row in gvItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked == true &&
                ((Label)row.FindControl("lblType_ID")).Text == "2" ||
                ((Label)row.FindControl("lblType_ID")).Text == "1")
            {
                if (((DropDownList)row.FindControl("ddlDoctor")).SelectedIndex == 0)
                {
                    lblMsg.Text = "Please Select Doctor";
                    ((DropDownList)row.FindControl("ddlDoctor")).Focus();
                    return;
                }
            }
        }

        foreach (GridViewRow row in gvItem.Rows)
        {
            if (a == "")
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked == true &&
                    ((Label)row.FindControl("lblType_ID")).Text == "2" ||
                    ((Label)row.FindControl("lblType_ID")).Text == "1")
                {
                    a = ((DropDownList)row.FindControl("ddlDoctor")).SelectedValue;
                }
            }
            else
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked == true &&
                    ((Label)row.FindControl("lblType_ID")).Text == "2" ||
                    ((Label)row.FindControl("lblType_ID")).Text == "1")
                {
                    b = ((DropDownList)row.FindControl("ddlDoctor")).SelectedValue;
                }
            }
            if (a == b)
            {
                lblMsg.Text = "Surgeon Name Cannot Be Same as Second Surgeon Name";
                return;
            }
        }
        int surgeryCalculation = Util.GetInt(rdoSurgeryCalculate.SelectedValue);

        if (surgeryCalculation == 2)
        {
            if (txtDocCharges.Text == "" && txtSurgeryAmt.Text == "")
            {
                lblMsg.Text = "Please Enter either Total Surgery Amt. or Total Surgeon Charges";
                return;
            }
        }

        if ((Util.GetDecimal(txtDocShared.Text) > 0 && Util.GetDecimal(txtDocCharges.Text) > 0) ||
            (Util.GetDecimal(txtDocShared.Text) > 0 && Util.GetDecimal(txtSurgeryAmt.Text) > 0) ||
            (Util.GetDecimal(txtSurgeryAmt.Text) > 0 && Util.GetDecimal(txtDocCharges.Text) > 0))
        {
            lblMsg.Text = "Please Enter any one, either Total Surgery Amt. or Total Surgeon Charges";
            return;
        }

        Calculator();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        bool isValid = false;

        isValid = CheckValidation();

        if (isValid == false)
            return;

        string ledTnxID = SaveData();
        if (ledTnxID != string.Empty)
        {
            //ScriptManager.RegisterStartupScript(this, GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);

            //ScriptManager.RegisterStartupScript(this, GetType(), "key", "DisplayMsg('MM01','" + lblMsg.ClientID + "');", true);
            txtDocCharges.Text = string.Empty;
            lblTotalAmt.Text = string.Empty;
            for (int i = 0; i < gvItem.Rows.Count; i++)
            {
                ((Label)gvItem.Rows[i].FindControl("lblNetAmt")).Text = "";
            }
            txtSurgeryAmt.Text = "";
            txtDocCharges.Text = "";

            txtNarration.Text = "";
            lblTotalAmt.Text = "";
            lblDept.Text = "";
            lblCode.Text = "";
            ViewState["SurgeryDetail"] = null;
            gvSurgeryDetail.DataSource = null;
            gvSurgeryDetail.DataBind();
            txttotal.Text = "0.00";
            //Response.Redirect(Request.RawUrl);
         //   ScriptManager.RegisterStartupScript(this, GetType(), "key505", "saveMessage();", true);
           if (Request.QueryString["LedgerTransactionNo"] != null)
           {
               Page.ClientScript.RegisterStartupScript(this.GetType(), "keyDev", "$(function () { modelAlert('Record Update Successfully',function(){ })  });", true);
           }
           else
           {
               Page.ClientScript.RegisterStartupScript(this.GetType(), "DeyDev1", "$(function () { modelAlert('Record Save Successfully',function(){ window.location=window.location.href;  })  });", true);
           }

        }
        else
            ScriptManager.RegisterStartupScript(this, GetType(), "key", "DisplayMsg('MM05','" + lblMsg.ClientID + "');", true);

    }

    #endregion

    #region Data Binding

    //Load old Already Given Surgery 
    private void LoadSurgery(string LedTnxID)
    {
        var sb = new StringBuilder();

        sb.Append("Select t1.LedgerTransactionNo,t1.DoctorName,IFNULL(t1.DoctorChargePer,im.minlimit)DoctorChargePer,t1.DoctorCharge, ");
        sb.Append("t1.DiscountPer,t1.IsPayable,t1.CoPayment,t1.IsPanelWiseDiscount,t1.DiscountAmt,t1.NetAmt,t1.DoctorID,t1.IsPer,t1.SurgeryID,IFNULL(t1.IsSelected,'false')IsSelected  ");
        sb.Append(",im.*,(Select Date from f_ledgertransaction where LedgerTransactionNo=t1.LedgerTransactionNo)Date  ");
        sb.Append("from (Select TypeName as Type,ItemID,SubCategoryID,Type_ID,minlimit from f_itemmaster where ISSurgery=1   ");
        sb.Append("AND IsActive=1 order by description) im  ");
        sb.Append("left join (  ");
        sb.Append("     select SDS.LedgerTransactionNo,SDS.ItemID,DM.Name as DoctorName,SD.Percentage as DoctorChargePer, ");
        sb.Append("     ((100*sd.Amount)/(100-sd.Discount)) AS DoctorCharge ,SD.Discount as DiscountPer, ");
        sb.Append("     ((((100*sd.Amount)/(100-sd.Discount))*Sd.Discount)/100)DiscountAmt ,SD.Amount as NetAmt,Sd.DoctorID, ");
        sb.Append("     'true' as IsPer,SDS.SurgeryID,'true' as IsSelected, ");
        sb.Append("     IFNULL((select IsPayable From f_ledgertnxdetail where LedgerTransactionNO=sds.`LedgerTransactionNo` and ");
        sb.Append("     ItemID=sds.ItemID and isverified=1),0)IsPayable,	 ");
        sb.Append(" IFNULL((select CoPayPercent From f_ledgertnxdetail where LedgerTransactionNO=sds.`LedgerTransactionNo` and  ");
        sb.Append("  ItemID=sds.ItemID and isverified=1) ,0)CoPayment,	 ");

        sb.Append(" IFNULL((select isPanelWiseDisc From f_ledgertnxdetail where LedgerTransactionNO=sds.`LedgerTransactionNo` and  ");
        sb.Append("  ItemID=sds.ItemID and isverified=1),0)IsPanelWiseDiscount	 ");

        sb.Append("from f_surgery_doctor SD  ");
        sb.Append("inner join f_surgery_discription SDS on SD.SurgeryTransactionID=SDS.SurgeryTransactionID ");
        sb.Append("inner join doctor_master DM on Sd.DoctorID=DM.DoctorID  where SDS.LedgerTransactionNo='" + LedTnxID + "' ");
        sb.Append("union all  ");
        sb.Append("select SDS.LedgerTransactionNo,SDS.ItemID,'---' as DoctorName,null as DoctorChargePer ,  ");
        sb.Append("SDS.Rate as DoctorCharge ,SDS.Discount as DiscountPer,((SDS.Rate*SDS.Discount)/100)as DiscountAmt, ");
        sb.Append("SDS.Amount as NetAmt,'0' as DoctorID, 'false' as IsPer,SDS.SurgeryID,'true' as IsSelected, ");
        sb.Append("IFNULL((select IsPayable From f_ledgertnxdetail where LedgerTransactionNO=sds.`LedgerTransactionNo` and ");
        sb.Append(" ItemID=sds.ItemID and isverified=1),0)IsPayable,");
        sb.Append(" IFNULL((select CoPayPercent From f_ledgertnxdetail where LedgerTransactionNO=sds.`LedgerTransactionNo` and  ");
        sb.Append("  ItemID=sds.ItemID and isverified=1),0)CoPayment,	 ");
        sb.Append(" IFNULL((select isPanelWiseDisc From f_ledgertnxdetail where LedgerTransactionNO=sds.`LedgerTransactionNo` and  ");
        sb.Append("  ItemID=sds.ItemID and isverified=1),0)IsPanelWiseDiscount	 ");


        sb.Append("from f_surgery_discription SDS  ");
        sb.Append("left join f_surgery_doctor SD on SDS.SurgeryTransactionID=SD.SurgeryTransactionID   ");
        sb.Append("where SDS.LedgerTransactionNo='" + LedTnxID + "' and Sd.ItemID is null  ");
        sb.Append(")t1 on IM.ItemID= t1.itemID  ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            // Putting Percentage of DoctorChargePer if that is null
            DataRow[] drSurgeon = dt.Select("Type_ID='1'");

            if (drSurgeon != null && drSurgeon.Length > 0)
            {
                foreach (DataRow row in dt.Rows)
                {
                    if (Util.GetString(row["DoctorChargePer"]).Trim() == "")
                    {
                        row["DoctorChargePer"] = (Util.GetDecimal(row["DoctorCharge"]) * 100) /
                                                 Util.GetDecimal(drSurgeon[0]["DoctorCharge"]);
                    }
                }
                dt.AcceptChanges();
            }

            ViewState["SurgeryItem"] = dt;
            gvItem.DataSource = dt;
            gvItem.DataBind();
            txtSurgeryAmt.Text = Util.GetString(Util.round(Util.GetDecimal(dt.Compute("sum(DoctorCharge)", ""))));
            lblTotalAmt.Text = Util.GetString(Util.round(Util.GetDecimal(dt.Compute("sum(NetAmt)", ""))));
            DataTable dtSurgery = StockReports.GetDataTable("SELECT Surgery_ID SurgeryID, Department,SurgeryCode,NAME FROM f_surgery_master sm  WHERE Surgery_ID='" + dt.Rows[0]["SurgeryID"].ToString() + "'");
            if (dtSurgery.Rows.Count > 0)
            {
                lblDept.Text = dtSurgery.Rows[0]["Department"].ToString();
                lblCode.Text = dtSurgery.Rows[0]["SurgeryCode"].ToString();

                lblSurgeryName.Text = dtSurgery.Rows[0]["NAME"].ToString();
                txtSurgeryName.Text = dtSurgery.Rows[0]["NAME"].ToString();
                txtSurgeryID.Text = dtSurgery.Rows[0]["SurgeryID"].ToString();
            }
        }
    }

    private void BindDoctor()
    {
        DataTable dtDoctor = AllLoadData_IPD.dtbindDoctor();
        ViewState["dtDoctor"] = dtDoctor;
    }
    private void BindDocType()
    {
        try
        {
            string ReferenceCode = StockReports.ExecuteScalar("Select ReferenceCode from f_panel_master where PanelID='" + ViewState["PanelID"].ToString() + "'");
            ViewState["ReferenceCode"] = ReferenceCode;

            StringBuilder sb = new StringBuilder();

            sb.Append(" select IM.ItemID,   ");
            if (rdoRateType.SelectedValue == "1")   // Rate On Surgery
                sb.Append(" IFNULL(SC.Percentage,0) DoctorChargePer, ");
            else if (rdoRateType.SelectedValue == "2")  // Rate On Surgeon
                sb.Append(" IFNULL(IF(im.TypeName='Surgeon Charges',100,SC.Percentage),0) DoctorChargePer, ");

            sb.Append(" IM.SubCategoryID,IM.TypeName Type, ");
            sb.Append(" IM.Type_ID,0 DoctorCharge,0 DiscountPer,0 DiscountAmt,0 NetAmt,'true' IsSelected,0 isPayable,0 CoPayment,0 IsPanelWiseDiscount   from f_itemmaster IM  ");
            sb.Append(" INNER join f_surgery_calculator SC on IM.ItemID=SC.ItemID  ");
            sb.Append(" and SC.SurgeryID='" + txtSurgeryID.Text + "' AND im.IsActive=1 ");
            sb.Append(" order by im.Description+0 ");
            DataTable dtDoctorType = StockReports.GetDataTable(sb.ToString());
            if (dtDoctorType != null && dtDoctorType.Rows.Count > 0)
            {
                gvItem.DataSource = dtDoctorType;
                gvItem.DataBind();

                var dtItem = new DataTable();
                if (ViewState["SurgeryItem"] != null)
                    dtItem = (DataTable)ViewState["SurgeryItem"];
                else
                {
                    dtItem = SurgeryItem();
                    ViewState["SurgeryItem"] = dtItem;
                }
            }
        }
        catch (Exception ex)
        {
            var c1 = new ClassLog();
            c1.errLog(ex);
        }
    }
    #endregion

    #region Data Definition

    private DataTable SurgeryItem()
    {
        var dtSurgery = new DataTable();
        dtSurgery.Columns.Add("ItemID");
        dtSurgery.Columns.Add("Type");
        dtSurgery.Columns.Add("DoctorName");
        dtSurgery.Columns.Add("DoctorID");
        dtSurgery.Columns.Add("DoctorCharge", typeof(decimal));
        dtSurgery.Columns.Add("DoctorChargePer", typeof(decimal));
        dtSurgery.Columns.Add("DiscountPer", typeof(decimal));
        dtSurgery.Columns.Add("DiscountAmt", typeof(decimal));
        dtSurgery.Columns.Add("NetAmt", typeof(decimal));
        dtSurgery.Columns.Add("Type_ID");
        dtSurgery.Columns.Add("SubCategoryID");
        dtSurgery.Columns.Add("IsPer", typeof(bool));
        dtSurgery.Columns.Add("DoctorIDIndex", typeof(int));
        dtSurgery.Columns.Add("IsSelected", typeof(bool));
        dtSurgery.Columns.Add("rateListID");
        dtSurgery.Columns.Add("isPayable");
        dtSurgery.Columns.Add("CoPayment");
        dtSurgery.Columns.Add("IsPanelWiseDiscount");
        return dtSurgery;
    }

    private DataTable GetDescTable()
    {
        var dtSurItem = (DataTable)ViewState["SurgeryItem"];

        DataTable dtItem = dtSurItem.DefaultView.ToTable(true,
            new string[] { "ItemID", "Type", "SubCategoryID", "IsSelected", "DoctorID" });

        if (dtItem != null && dtItem.Rows.Count > 0)
        {
            dtItem.Columns.Add("SurgeryID");
            dtItem.Columns.Add("SurgeryName");
            dtItem.Columns.Add("Percentage", typeof(decimal));
            dtItem.Columns.Add("ItemCharge", typeof(decimal));
            dtItem.Columns.Add("Discount", typeof(decimal));
            dtItem.Columns.Add("DiscountAmt", typeof(decimal));
            dtItem.Columns.Add("NetCharge", typeof(decimal));
            dtItem.Columns.Add("isPayable", typeof(int));
            dtItem.Columns.Add("CoPayment", typeof(decimal));
            dtItem.Columns.Add("IsPanelWiseDiscount", typeof(decimal));
        }

        for (int i = 0; i < dtItem.Rows.Count; i++)
        {
            string ItemID = Util.GetString(dtItem.Rows[i]["ItemID"]);

            int patientTypeID = Util.GetInt(ViewState["PatientTypeID"]);
            var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(ViewState["PanelID"]), Util.GetString(ItemID), patientTypeID);

            dtItem.Rows[i]["SurgeryID"] = txtSurgeryID.Text;
            dtItem.Rows[i]["SurgeryName"] = lblCode.Text + "#" + txtSurgeryName.Text;//lstSurgery.SelectedItem.Text;
            dtItem.Rows[i]["Percentage"] = dtSurItem.Compute("Sum(DoctorChargePer)", "ItemID='" + ItemID + "'");
            decimal ItemCharge = Util.GetDecimal(dtSurItem.Compute("count(ItemID)", "ItemID='" + ItemID + "'"));
            dtItem.Rows[i]["ItemCharge"] = dtSurItem.Compute("Sum(DoctorCharge)", "ItemID='" + ItemID + "'");
            decimal Discount = Util.GetDecimal(dtSurItem.Compute("Sum(DiscountPer)", "ItemID='" + ItemID + "'"));
            if (Discount < 1)
                Discount = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);


            dtItem.Rows[i]["Discount"] = Discount / ItemCharge;
            dtItem.Rows[i]["DiscountAmt"] = dtSurItem.Compute("Sum(DiscountAmt)", "ItemID='" + ItemID + "'");
            dtItem.Rows[i]["NetCharge"] = dtSurItem.Compute("Sum(NetAmt)", "ItemID='" + ItemID + "'");
            dtItem.Rows[i]["isPayable"] = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
            dtItem.Rows[i]["CoPayment"] = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);
            dtItem.Rows[i]["IsPanelWiseDiscount"] = Util.GetInt(dtItem.Rows[0]["IsPanelWiseDiscount"]);
        }
        return dtItem;
    }

    #endregion

    #region Helper Function

    private void Clear()
    {
        if (ddlDocType.SelectedIndex < 8)
            foreach (ListItem li in chkDoctor.Items)
                if (li.Selected)
                    li.Selected = false;

        txtChargesPer.Text = string.Empty;
        txtChargeAmt.Text = string.Empty;
        txtDiscAmt.Text = string.Empty;
        txtDiscPer.Text = string.Empty;
    }

    private void Calculator()
    {
        try
        {
            decimal SurDocTotal = 0, SurDocNetTotal = 0, TotalSurgeryAmt = 0, TotalPercentage = 0;

            int surgeryCalculation = Util.GetInt(rdoSurgeryCalculate.SelectedValue);

            SurDocTotal = Util.GetDecimal(txtDocCharges.Text);
            SurDocNetTotal = Util.GetDecimal(txtDocShared.Text);
            TotalSurgeryAmt = Util.GetDecimal(txtSurgeryAmt.Text);

            if (surgeryCalculation == 1) // Amount
            {
                TotalSurgeryAmt = 0;
                for (int i = 0; i < gvItem.Rows.Count; i++)
                {
                    if (((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked)
                    {
                        TotalSurgeryAmt += Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtchargesAmt")).Text);
                    }
                }
                txtSurgeryAmt.Text = Util.GetString(Util.round(TotalSurgeryAmt));
            }
            if (surgeryCalculation == 1 && TotalSurgeryAmt == 0)
            {

                lblMsg.Text = "Please Enter Surgery Amount";
                return;
            }
            if (ValidateCharges())
            {
                var dtItem = (DataTable)ViewState["SurgeryItem"];

                for (int i = 0; i < gvItem.Rows.Count; i++)
                {
                    if (((Label)gvItem.Rows[i].FindControl("lblType_ID")).Text == "1")
                    {
                        if (((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked == false)
                        {
                            lblMsg.Text = "Please Select Surgeon Charges Since it's the base of Surgery Calculation..";
                            return;
                        }

                        decimal DocShare =
                            Util.GetDecimal(
                                ((TextBox)gvItem.Rows[i].FindControl("txtCharges")).Text.ToString());

                        if (DocShare == 0 && SurDocNetTotal > 0)
                        {
                            lblMsg.Text = "Surgeon Share is not set in masters. Please give Total Surgeon fees..";
                            return;
                        }

                        if (SurDocTotal == 0 && SurDocNetTotal > 0)
                            SurDocTotal = Util.GetDecimal(Util.round(Util.GetDecimal((SurDocNetTotal * 100) / DocShare)));
                    }

                    if (((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked)
                        TotalPercentage += Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtCharges")).Text);

                    DataRow[] RowCnt =
                        dtItem.Select("ItemID='" + ((Label)gvItem.Rows[i].FindControl("lblItemID")).Text + "'");

                    if (RowCnt.Length == 0)
                    {
                        DataRow row1 = dtItem.NewRow();
                        row1["ItemID"] = ((Label)gvItem.Rows[i].FindControl("lblItemID")).Text;
                        row1["Type"] = ((Label)gvItem.Rows[i].FindControl("lblItemType")).Text;

                        if (((Label)gvItem.Rows[i].FindControl("lblType_ID")).Text == "1" ||
                            ((Label)gvItem.Rows[i].FindControl("lblType_ID")).Text == "2")
                        {
                            row1["DoctorName"] =
                                ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedItem.Text;
                            row1["DoctorID"] =
                                ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedItem.Value.Split('#')[0
                                    ].ToString();
                            row1["DoctorIDIndex"] =
                                ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedIndex;
                        }
                        else
                        {
                            row1["DoctorName"] = "-----";
                            row1["DoctorID"] = "0";
                            row1["DoctorIDIndex"] = 0;
                        }

                        row1["Type_ID"] = ((Label)gvItem.Rows[i].FindControl("lblType_ID")).Text;
                        row1["DoctorCharge"] = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtCharges")).Text);
                        row1["DoctorChargePer"] = DBNull.Value;

                        if (Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscPer")).Text) > 0)
                            row1["DiscountPer"] =
                                Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscPer")).Text);
                        else
                            row1["DiscountAmt"] =
                                Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscAmt")).Text);

                        row1["NetAmt"] = 0;
                        row1["SubCategoryID"] = ((Label)gvItem.Rows[i].FindControl("lblSubCategoryID")).Text;

                        if (((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked)
                            row1["IsSelected"] = "true";
                        else
                            row1["IsSelected"] = "false";

                        dtItem.Rows.Add(row1);
                    }
                    else
                    {
                        if (((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked)
                        {
                            RowCnt[0]["IsSelected"] = "true";
                            RowCnt[0]["NetAmt"] = 0;
                            RowCnt[0]["DoctorCharge"] = 0;

                            if (((Label)gvItem.Rows[i].FindControl("lblType_ID")).Text == "1" ||
                                ((Label)gvItem.Rows[i].FindControl("lblType_ID")).Text == "2")
                            {
                                RowCnt[0]["DoctorName"] =
                                    ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedItem.Text;
                                RowCnt[0]["DoctorID"] =
                                    ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedItem.Value.Split(
                                        '#')[0].ToString();
                                RowCnt[0]["DoctorIDIndex"] =
                                    ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedIndex;
                            }
                            else
                            {
                                RowCnt[0]["DoctorName"] = "-----";
                                RowCnt[0]["DoctorID"] = "0";
                                RowCnt[0]["DoctorIDIndex"] = 0;
                            }
                        }
                        else
                        {
                            RowCnt[0]["IsSelected"] = "false";
                            RowCnt[0]["NetAmt"] = 0;
                            RowCnt[0]["DoctorCharge"] = 0;
                        }
                    }

                    dtItem.Rows[i]["IsPanelWiseDiscount"] = Util.GetDecimal(((Label)gvItem.Rows[i].FindControl("lblIsPanelWiseDiscount")).Text);
                }

                for (int i = 0; i < gvItem.Rows.Count; i++)
                {
                    decimal DoctAmt = 0, DocPer = 0, DocAmt = 0, DiscountPer = 0, Discamt = 0, NetAmt = 0;
                    string strItemType = ((Label)gvItem.Rows[i].FindControl("lblItemType")).Text.ToUpper();

                    if (Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtCharges")).Text) > 0)
                    {
                        if (((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked)
                        {
                            //DoctAmt = Util.GetDecimal(txtDocCharges.Text.Trim()); //SurDocTotal
                            DoctAmt = SurDocTotal;


                            if (surgeryCalculation == 2)
                            {
                                DocPer = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtCharges")).Text);
                                if (TotalSurgeryAmt == 0)
                                    DocAmt = (DoctAmt * DocPer) / 100;
                                else
                                    DocAmt = TotalSurgeryAmt * DocPer / TotalPercentage;
                            }
                            else
                            {
                                DocAmt = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtchargesAmt")).Text);
                                if (TotalSurgeryAmt > 0)
                                    DocPer = Math.Round(Util.GetDecimal(Util.GetDecimal(DocAmt * 100) / Util.GetDecimal(TotalSurgeryAmt)), 2, MidpointRounding.AwayFromZero);
                                else
                                    DocPer = 0;

                            }

                            NetAmt = DocAmt;
                            if (Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscPer")).Text) > 0)
                            {
                                DiscountPer = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscPer")).Text);
                                Discamt = (DocAmt * DiscountPer) / 100;
                                NetAmt -= Discamt;
                            }
                            else if (Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscAmt")).Text) > 0)
                            {
                                Discamt = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscAmt")).Text);
                                DiscountPer = (Discamt * 100) / DocAmt;
                                NetAmt -= Discamt;
                            }
                            foreach (DataRow dr in dtItem.Rows)
                            {
                                if (dr["ItemID"].ToString() == ((Label)gvItem.Rows[i].FindControl("lblItemID")).Text)
                                {
                                    dr["DoctorCharge"] = DocAmt;
                                    dr["DoctorChargePer"] = DocPer;
                                    dr["DiscountPer"] = DiscountPer;
                                    dr["DiscountAmt"] = Discamt;
                                    dr["NetAmt"] = NetAmt;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            foreach (DataRow dr in dtItem.Rows)
                            {
                                if (dr["ItemID"].ToString() == ((Label)gvItem.Rows[i].FindControl("lblItemID")).Text)
                                {
                                    dr["DoctorChargePer"] = dr["DoctorCharge"];
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (((CheckBox)gvItem.Rows[i].FindControl("chkSelect")).Checked)
                        {

                            DocAmt = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtchargesAmt")).Text);
                            if (surgeryCalculation == 2)
                            {
                                DocPer = (DocAmt * 100) / SurDocTotal;
                            }
                            else
                            {
                                if (TotalSurgeryAmt > 0)
                                    DocPer = Math.Round(Util.GetDecimal(Util.GetDecimal(DocAmt * 100) / Util.GetDecimal(TotalSurgeryAmt)), 2, MidpointRounding.AwayFromZero);
                                else
                                    DocPer = 0;
                            }
                            NetAmt = DocAmt;
                            if (Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscPer")).Text) > 0)
                            {
                                DiscountPer = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscPer")).Text);
                                Discamt = (DocAmt * DiscountPer) / 100;
                                NetAmt -= Discamt;
                            }
                            else if (Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscAmt")).Text) > 0)
                            {
                                Discamt = Util.GetDecimal(((TextBox)gvItem.Rows[i].FindControl("txtDiscAmt")).Text);
                                DiscountPer = (Discamt * 100) / DocAmt;
                                NetAmt -= Discamt;
                            }
                            dtItem.Rows[i]["DoctorCharge"] = DocAmt;
                            dtItem.Rows[i]["DoctorChargePer"] = DocPer;
                            dtItem.Rows[i]["DiscountPer"] = DiscountPer;
                            dtItem.Rows[i]["DiscountAmt"] = Discamt;
                            dtItem.Rows[i]["NetAmt"] = NetAmt;

                        }
                    }

                    dtItem.Rows[i]["IsPanelWiseDiscount"] = Util.GetDecimal(((Label)gvItem.Rows[i].FindControl("lblIsPanelWiseDiscount")).Text);
                }
                dtItem.AcceptChanges();
                lblTotalAmt.Text = Util.GetString(Math.Round(Util.GetDecimal(dtItem.Compute("sum(NetAmt)", "")), 2));
                ViewState["SurgeryItem"] = dtItem;
                gvItem.DataSource = dtItem;
                gvItem.DataBind();
                //gvItem.Enabled = false;
            }
        }
        catch (Exception ex)
        {
            var cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
    }

    private bool ValidateCharges()
    {

        if (gvItem.Rows.Count == 0)
            return false;

        if (Util.GetDecimal(txtDocCharges.Text.Trim()) == 0 && Util.GetDecimal(txtDocShared.Text.Trim()) == 0 &&
            Util.GetDecimal(txtSurgeryAmt.Text.Trim()) == 0 && Util.GetInt(rdoSurgeryCalculate.SelectedValue) == 2)
            return false;


        foreach (GridViewRow row in gvItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked == true &&
                ((TextBox)row.FindControl("txtCharges")).Text == string.Empty &&
                ((TextBox)row.FindControl("txtchargesAmt")).Text == string.Empty)
            {
                lblMsg.Text = "Charges Cannot be left blank";
                return false;
            }
        }
        return true;
    }

    #endregion

    #region Save Surgery

    private string SaveData()
    {
        if (ViewState["SurgeryItem"] != null)
        {
            var dtItem = (DataTable)ViewState["SurgeryItem"];
            DataTable dtDesc = GetDescTable();
            string LedTxnID = string.Empty,
                PatientID = string.Empty,
                LedgerNo = string.Empty,
                TransactionID = string.Empty,
                DiscApproval = string.Empty,
            patientType = string.Empty, SurgeryName = string.Empty;
            int PanelID = 0;
            if (ddlApproveBy.Text != "")
            {
                DiscApproval = ddlApproveBy.Text + " " + txtNarration.Text.Trim();
            }
            else
            {
                DiscApproval = txtNarration.Text.Trim();
            }
            for (int i = 0; i < gvSurgeryDetail.Rows.Count; i++)
            {
                if (SurgeryName == string.Empty)
                    SurgeryName = SurgeryName + Util.GetString(((Label)gvSurgeryDetail.Rows[i].FindControl("lblSurgeryName")).Text);
                else
                    SurgeryName = SurgeryName + "," + Util.GetString(((Label)gvSurgeryDetail.Rows[i].FindControl("lblSurgeryName")).Text);
            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

            TransactionID = ViewState["TID"].ToString();
            if (ViewState["strLedgerTnxNo"] != null)
            {
                string LedTnxNo = ViewState["strLedgerTnxNo"].ToString();
                int DeleteSurgery = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "call DeleteSurgery('" + LedTnxNo + "')");
                if (DeleteSurgery == 0)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    lblMsg.Text = "Error occurred, Please contact administrator";
                }
            }
            string str =
                "select LM.LedgerNumber,PMH.panelID,PMH.PatientID,PMH.Patient_Type from patient_medical_history PMH inner join f_ledgermaster LM on LM.LedgerUserID=PMH.PatientID where PMH.Type='IPD' and PMH.TransactionID='" +
                TransactionID + "'";
            var dtPatient = new DataTable();
            dtPatient = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, str).Tables[0];
            PatientID = Util.GetString(dtPatient.Rows[0]["PatientID"]);
            PanelID = Util.GetInt(dtPatient.Rows[0]["panelID"]);
            LedgerNo = Util.GetString(dtPatient.Rows[0]["LedgerNumber"]);
            patientType = Util.GetString(dtPatient.Rows[0]["Patient_Type"]);
            decimal GrossAmt = 0, NetAmt = 0, Discount = 0;
            GrossAmt = Util.GetDecimal(dtItem.Compute("sum(DoctorCharge)", ""));
            NetAmt = Util.GetDecimal(dtItem.Compute("sum(NetAmt)", ""));
            Discount = ((GrossAmt - NetAmt) * 100) / GrossAmt;

            //Insert into LedgerTransaction single Row Effect
            try
            {
                var objLedTran = new Ledger_Transaction(Tranx);
                objLedTran.LedgerNoCr = LedgerNo;
                objLedTran.LedgerNoDr = "HOSP0001";
                objLedTran.Hospital_ID = HttpContext.Current.Session["HOSPID"].ToString();
                objLedTran.TypeOfTnx = "IPD Surgery";
                objLedTran.Date = Util.GetDateTime(ucSurDate.Text);
                objLedTran.Time = DateTime.Now;
                objLedTran.DiscountOnTotal = Discount;
                objLedTran.GrossAmount = Util.GetDecimal(GrossAmt);
                objLedTran.NetAmount = Util.GetDecimal(NetAmt);
                objLedTran.UserID = ViewState["USERID"].ToString();
                objLedTran.PatientID = PatientID;
                objLedTran.TransactionID = TransactionID;
                objLedTran.PanelID = PanelID;
                objLedTran.DiscountReason = DiscApproval;
                objLedTran.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                objLedTran.PatientType = patientType;
                objLedTran.IpAddress = HttpContext.Current.Request.UserHostAddress;
                LedTxnID = objLedTran.Insert();
                if (LedTxnID == string.Empty)
                {
                    Tranx.Rollback();
                    Tranx.Dispose();
                    con.Close();
                    con.Dispose();
                    return string.Empty;
                }


                //Checking if Patient is prescribed any IPD Packages
                DataTable dtPkg = StockReports.GetIPD_Packages_Prescribed(TransactionID, con);

                for (int i = 0; i < dtDesc.Rows.Count; i++)
                {
                    if (dtDesc.Rows[i]["IsSelected"].ToString().ToUpper() == "TRUE")
                    {
                        var objLTDetail = new LedgerTnxDetail(Tranx);

                        objLTDetail.Hospital_Id = HttpContext.Current.Session["HOSPID"].ToString();
                        objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objLTDetail.LedgerTransactionNo = LedTxnID;
                        objLTDetail.TransactionID = TransactionID;
                        objLTDetail.ItemID = Util.GetString(dtDesc.Rows[i]["ItemId"]);
                        objLTDetail.Rate = Util.GetDecimal((dtDesc.Rows[i]["ItemCharge"]));
                        objLTDetail.SubCategoryID = Util.GetString(dtDesc.Rows[i]["SubCategoryID"]);
                        objLTDetail.Quantity = 1;
                        objLTDetail.ConfigID = Util.GetInt(StockReports.GetConfigIDbySubCategoryID(Util.GetString(dtDesc.Rows[i]["SubCategoryID"]), con));


                        objLTDetail.IsPayable = StockReports.GetIsPayableItems(objLTDetail.ItemID, objLedTran.PanelID);


                        var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(objLedTran.PanelID), Util.GetString(dtDesc.Rows[i]["ItemId"]), Util.GetInt(ViewState["PatientTypeID"]));

                        if (dtPkg != null && dtPkg.Rows.Count > 0)
                        {
                            int iCtr = 0;
                            foreach (DataRow drPkg in dtPkg.Rows)
                            {
                                if (iCtr == 0)
                                {
                                    DataTable dtPkgDetl = StockReports.ShouldSendToIPDPackage(TransactionID,
                                        drPkg["PackageID"].ToString(), dtDesc.Rows[i]["ItemID"].ToString(),
                                        Util.GetDecimal(dtDesc.Rows[i]["ItemCharge"]), Util.GetInt("1"), Util.GetInt(ViewState["IPDCaseTypeID"].ToString()), con);

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
                                            objLTDetail.DiscountPercentage = Util.GetDecimal(dtDesc.Rows[i]["Discount"]);
                                            objLTDetail.Amount = Util.GetDecimal(dtDesc.Rows[i]["NetCharge"]);
                                            objLTDetail.DiscAmt = Util.GetDecimal(dtDesc.Rows[i]["DiscountAmt"]);
                                            objLTDetail.NetItemAmt = Util.GetDecimal(dtDesc.Rows[i]["NetCharge"]);
                                            objLTDetail.TotalDiscAmt = Util.GetDecimal(dtDesc.Rows[i]["DiscountAmt"]);
                                            iCtr = 1;
                                        }
                                    }
                                    else
                                    {
                                        objLTDetail.DiscountPercentage = Util.GetDecimal(dtDesc.Rows[i]["Discount"]);
                                        objLTDetail.Amount = Util.GetDecimal(dtDesc.Rows[i]["NetCharge"]);
                                        objLTDetail.DiscAmt = Util.GetDecimal(dtDesc.Rows[i]["DiscountAmt"]);
                                        objLTDetail.NetItemAmt = Util.GetDecimal(dtDesc.Rows[i]["NetCharge"]);
                                        objLTDetail.TotalDiscAmt = Util.GetDecimal(dtDesc.Rows[i]["DiscountAmt"]);
                                        iCtr = 1;
                                    }
                                }
                            }
                        }
                        else
                        {
                            objLTDetail.DiscountPercentage = Util.GetDecimal(dtDesc.Rows[i]["Discount"]);
                            objLTDetail.Amount = Util.GetDecimal(dtDesc.Rows[i]["NetCharge"]);
                            objLTDetail.DiscAmt = Util.GetDecimal(dtDesc.Rows[i]["DiscountAmt"]);
                            objLTDetail.NetItemAmt = Util.GetDecimal(dtDesc.Rows[i]["NetCharge"]);
                            objLTDetail.TotalDiscAmt = Util.GetDecimal(dtDesc.Rows[i]["DiscountAmt"]);
                        }

                        objLTDetail.EntryDate = Util.GetDateTime(ucSurDate.Text);
                        objLTDetail.UserID = ViewState["USERID"].ToString();
                        objLTDetail.ItemName = Util.GetString(dtDesc.Rows[i]["Type"]);
                        objLTDetail.IsSurgery = 1;
                        objLTDetail.SurgeryID = Util.GetString(dtDesc.Rows[i]["SurgeryID"]);
                        // objLTDetail.SurgeryName = Util.GetString(dtDesc.Rows[i]["SurgeryName"]);
                        objLTDetail.SurgeryName = SurgeryName;
                        objLTDetail.IsVerified = 1;
                        objLTDetail.CentreID = Util.GetInt(HttpContext.Current.Session["CentreID"].ToString());
                        objLTDetail.IPDCaseTypeID = ViewState["IPDCaseTypeID"].ToString();
                        objLTDetail.pageURL = All_LoadData.getCurrentPageName();
                        objLTDetail.RoleID = Util.GetInt(HttpContext.Current.Session["RoleID"].ToString());
                        objLTDetail.Type = "I";
                        objLTDetail.IpAddress = HttpContext.Current.Request.UserHostAddress;
                        if (dtDesc.Rows[i]["DoctorID"].ToString() != "0")
                            objLTDetail.DoctorID = dtDesc.Rows[i]["DoctorID"].ToString();
                        objLTDetail.RoomID = ViewState["RoomID"].ToString();
                        objLTDetail.VarifiedUserID = ViewState["USERID"].ToString();
                        objLTDetail.VerifiedDate = Util.GetDateTime(ucSurDate.Text);
                        objLTDetail.typeOfTnx = "IPD Surgery";
                        objLTDetail.IsPayable = Util.GetInt(dataTableCoPayDiscont.Rows[0]["IsPayble"]);
                        objLTDetail.CoPayPercent = Util.GetDecimal(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);
                        objLTDetail.isPanelWiseDisc = Util.GetInt(dtItem.Rows[i]["IsPanelWiseDiscount"]);

                        int LTDetailID = objLTDetail.Insert();
                        if (LTDetailID == 0)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }

                        //Insert into Surgery Description

                        var objSD = new Surgery_Description(Tranx);
                        objSD.LedgerTransactionNo = LedTxnID;
                        objSD.TransactionID = TransactionID;
                        objSD.PatientID = PatientID;
                        objSD.ItemID = Util.GetString(dtDesc.Rows[i]["ItemId"]);
                        objSD.Surgery_ID = Util.GetString(dtDesc.Rows[i]["SurgeryID"]);
                        objSD.Rate = Util.GetDecimal(dtDesc.Rows[i]["ItemCharge"]);
                        objSD.Amount = Util.GetDecimal(dtDesc.Rows[i]["NetCharge"]);
                        objSD.Discount = Util.GetDecimal(dtDesc.Rows[i]["Discount"]);
                        string SurgeryTransactionID = objSD.Insert();
                        if (SurgeryTransactionID == string.Empty)
                        {
                            Tranx.Rollback();
                            Tranx.Dispose();
                            con.Close();
                            con.Dispose();
                            return string.Empty;
                        }
                        //Insert into Surgery Doctor
                        var objSDoc = new Surgery_Doctor(Tranx);
                        DataRow[] dr = dtItem.Select("ItemId='" + objSD.ItemID + "' and DoctorID <> '0'");
                        if (dr.Length > 0)
                        {
                            foreach (DataRow row in dr)
                            {
                                objSDoc.SurgeryTransactionID = SurgeryTransactionID;
                                objSDoc.DoctorID = Util.GetString(row["DoctorID"]);
                                objSDoc.Percentage = Util.GetDecimal(row["DoctorChargePer"]);
                                objSDoc.Amount = Util.GetDecimal(row["NetAmt"]);
                                objSDoc.Discount = Util.GetDecimal(row["DiscountPer"]);
                                objSDoc.ItemID = Util.GetString(row["ItemId"]);

                                int SurDoc = objSDoc.Insert();
                                if (SurDoc == 0)
                                {
                                    Tranx.Rollback();
                                    Tranx.Dispose();
                                    con.Close();
                                    con.Dispose();
                                    return string.Empty;
                                }
                            }
                        }
                    }
                }
                if (gvSurgeryDetail.Rows.Count > 0)
                {
                    for (int i = 0; i < gvSurgeryDetail.Rows.Count; i++)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("insert into f_surgery_detail_ipd(TransactionID,SurgeryCode,SurgeryID,SurgeryName,Department,Rate,ReducePerOn,CalReducePerOn,NewRate,RateCalon,LedgerTnxNo,Remark,CreatedBy,SurgeryCalon)");
                        sb.Append("values('" + TransactionID + "','" + Util.GetString(((Label)gvSurgeryDetail.Rows[i].FindControl("lblSurgeryCode")).Text) + "','" + Util.GetString(((Label)gvSurgeryDetail.Rows[i].FindControl("lblSurgeryID")).Text) + "', ");
                        sb.Append("'" + Util.GetString(((Label)gvSurgeryDetail.Rows[i].FindControl("lblSurgeryName")).Text) + "','" + Util.GetString(((Label)gvSurgeryDetail.Rows[i].FindControl("lblDepartment")).Text) + "', ");
                        sb.Append("'" + Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[i].FindControl("txtRate")).Text) + "','" + Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[i].FindControl("txtReducePerOn")).Text) + "','" + Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[i].FindControl("txtCalReducePerOn")).Text) + "','" + Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[i].FindControl("txtNewRate")).Text) + "','" + Util.GetInt(rdoRateType.SelectedValue) + "','" + LedTxnID + "','" + Util.GetString(((TextBox)gvSurgeryDetail.Rows[i].FindControl("txtRemark")).Text) + "','" + ViewState["USERID"].ToString() + "','" + Util.GetInt(rdoSurgeryCalculate.SelectedValue) + "')");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
                    }
                }
                Tranx.Commit();
                Tranx.Dispose();
                con.Close();
                con.Dispose();
                return LedTxnID;
            }
            catch (Exception ex)
            {
                var c1 = new ClassLog();
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

    #endregion

    protected void btnRate_Click(object sender, EventArgs e)
    {
        rate();
        var dtItem = new DataTable();
        if (ViewState["SurgeryDetail"] != null)
        {
            dtItem = (DataTable)ViewState["SurgeryDetail"];
            if (dtItem != null & dtItem.Rows.Count > 0)
            {
                for (int j = 0; j < gvSurgeryDetail.Rows.Count; j++)
                {
                    for (int i = 0; i < dtItem.Rows.Count; i++)
                    {
                        if (Util.GetString(dtItem.Rows[i]["SurgeryID"]) == Util.GetString(((Label)gvSurgeryDetail.Rows[j].FindControl("lblSurgeryID")).Text))
                        {
                            dtItem.Rows[i]["Rate"] = Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[j].FindControl("txtRate")).Text);
                            dtItem.Rows[i]["CalReducePerOn"] = Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[j].FindControl("txtCalReducePerOn")).Text);
                            dtItem.Rows[i]["NewRate"] = Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[j].FindControl("txtNewRate")).Text);
                            dtItem.Rows[i]["Remark"] = Util.GetString(((TextBox)gvSurgeryDetail.Rows[j].FindControl("txtRemark")).Text);
                        }
                    }
                }
                ViewState["SurgeryDetail"] = dtItem;
            }
        }
        else
            dtItem = GetSurgeryDetail();
        
                if (dtItem.Select("SurgeryID='" +txtSurgeryID.Text + "'", "").Length == 0)
                {
                    DataRow row = dtItem.NewRow();
                    row["IsSelected"] = "true";
                    row["SurgeryCode"] = Util.GetString(lblCode.Text);
                    row["SurgeryID"] = txtSurgeryID.Text;
                    row["SurgeryName"] = txtSurgeryName.Text;
                    row["Department"] = Util.GetString(lblDept.Text);
                    if (rdoRateType.SelectedValue == "1") // Surgery
                        row["Rate"] = Util.GetDecimal(txtSurgeryAmt.Text);
                    else if (rdoRateType.SelectedValue == "2") // Surgeon
                        row["Rate"] = Util.GetDecimal(txtDocCharges.Text);
                    row["NewRate"] = "0.00";
                    row["ReducePerOn"] = 0.00;
                    row["CalReducePerOn"] = 0.00;
                    row["LedgerTnxNo"] = "";
                    row["Remark"] = "";
                    dtItem.Rows.Add(row);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM240','" + lblMsg.ClientID + "');", true);
                }
        if (dtItem != null)
        {
            dtItem.DefaultView.Sort = "rate desc";
            dtItem = dtItem.DefaultView.ToTable();
        }
        gvSurgeryDetail.DataSource = dtItem;
        gvSurgeryDetail.DataBind();
        ViewState["SurgeryDetail"] = dtItem;

        BindDocType();
    }

    public void rate()
    {
        try
        {
            var sb = new StringBuilder();

            sb.Append(
                " Select pmh.panelID,pmh.ScheduleChargeID,(Select ReferenceCode from f_panel_master where panelID=pmh.panelID)ReferenceCode, ");
            sb.Append(" (Select IPDCaseTypeID_Bill from patient_ipd_profile where TransactionID='" +
                      ViewState["TID"].ToString() + "' ");
            sb.Append(" order by PatientIPDProfile_ID desc limit 1)IPDCaseTypeID ");
            sb.Append(" from patient_medical_history pmh where pmh.TransactionID='" + ViewState["TID"].ToString() + "'");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt != null && dt.Rows.Count > 0)
            {
                sb = new StringBuilder();
                sb.Append(" Select srt.ID rateListID,srt.Rate DocCharge,srt.SurgeonRate SurgeonCharge,sm.* from f_surgery_rate_List srt ");
                sb.Append(" inner join (Select Surgery_ID,Department,SurgeryCode from f_surgery_master ");

                sb.Append(" Where Surgery_ID='" + txtSurgeryID.Text + "'");
                sb.Append(" )sm on sm.Surgery_ID = srt.Surgery_ID");

                sb.Append(" where srt.panelID ='" + Util.GetString(dt.Rows[0]["ReferenceCode"]) + "'");
                sb.Append(" and srt.IPDCaseTypeID='" + Util.GetString(dt.Rows[0]["IPDCaseTypeID"]) + "'");
                sb.Append(" and srt.ScheduleChargeID=" + Util.GetString(dt.Rows[0]["ScheduleChargeID"]) + "");

                DataTable dtSur = StockReports.GetDataTable(sb.ToString());

                string str =
                    "SELECT ItemId,DATE_FORMAT(entryDate,'%d-%b-%Y')EntryDate,(SELECT NAME FROM employee_master WHERE EmployeeID=userID)UserName FROM f_ledgertnxdetail WHERE TransactionID='" +
                    ViewState["TID"].ToString() + "' and Date(entryDate)=CURDATE() and SurgeryID='" +
                    Util.GetString(txtSurgeryID.Text) + "' AND IsVerified=1";
                DataTable Item = StockReports.GetDataTable(str);
                if (Item.Rows.Count > 0)
                {
                    if (Flag == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "key1",
                            "ConfirmSave('" + Item.Rows[0]["EntryDate"].ToString() + "','" +
                            Item.Rows[0]["UserName"].ToString() + "');", true);
                        ViewState["dtItemForChk"] = dtSur;
                    }
                }
                else
                {
                    if (dtSur != null && dtSur.Rows.Count > 0)
                    {
                        if (rdoRateType.SelectedValue == "1")
                        {
                            txtSurgeryAmt.Text = dtSur.Rows[0]["DocCharge"].ToString();
                            string amount = StockReports.ExecuteScalar("SELECT SC.Rate DoctorCharge FROM f_itemmaster IM INNER JOIN f_surgery_calculator SC ON IM.ItemID = SC.ItemID WHERE  SC.SurgeryID = '" + Util.GetString(txtSurgeryID.Text) + "' AND im.IsActive = 1 ");
                            txtSurgeryAmt.Text = amount; //Util.GetString(Util.round(Util.GetDecimal(dtSur.Rows[0]["DocCharge"]) * Util.GetDecimal(lblScaleOfCost.Text)));
                            txtDocCharges.Text = "0.00";
                        }
                        else
                        {
                            txtDocCharges.Text = dtSur.Rows[0]["SurgeonCharge"].ToString();
                            txtSurgeryAmt.Text = "0.00";
                        }
                        lblDept.Text = dtSur.Rows[0]["Department"].ToString();
                        lblCode.Text = dtSur.Rows[0]["SurgeryCode"].ToString();

                        lblSurgeryName.Text = dtSur.Rows[0]["Name"].ToString();
                    }
                    else
                    {
                        txtSurgeryAmt.Text = "0.00";
                        txtDocCharges.Text = "0.00";
                        lblCode.Text = "";
                        lblDept.Text = "";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            var cl = new ClassLog();
            cl.errLog(ex);
        }

        ViewState["Selected"] = 0;
    }

    protected void btnAddDirect_Click(object sender, EventArgs e)
    {
        var dtitemforChk = (DataTable)ViewState["dtItemForChk"];
        Flag = 1;
        txtSurgeryAmt.Text = Util.GetString(Util.round(Util.GetDecimal(dtitemforChk.Rows[0]["DocCharge"])));
        lblDept.Text = dtitemforChk.Rows[0]["Department"].ToString();
        lblCode.Text = dtitemforChk.Rows[0]["SurgeryCode"].ToString();
        // lstSurgery.SelectedIndex =lstSurgery.Items.IndexOf(lstSurgery.Items.FindByValue(dtitemforChk.Rows[0]["Surgery_ID"].ToString()));
        ViewState["IsSelected"] = 0;
    }

    protected void Button2_Click1(object sender, EventArgs e)
    {
        var dtChkCancel = (DataTable)ViewState["dtItemForChk"];
        int count = dtChkCancel.Rows.Count;
        dtChkCancel.Rows[count - 1].Delete();
        ViewState["dtItems"] = dtChkCancel;
    }


    protected void btn_set_Click(object sender, EventArgs e)
    {
        txtSurgeryAmt.Text = "";
        txtDocCharges.Text = "";
        lblCode.Text = "";
        lblDept.Text = "";
        lblTotalAmt.Text = "";
        BindDocType();

        for (int i = 0; i < gvItem.Rows.Count; i++)
        {
            if (((DropDownList)gvItem.Rows[0].FindControl("ddlDoctor")).Visible == true)
            {
                ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedIndex = 0;
            }
        }


        gvItem.Enabled = true;
    }

    protected void gvItem_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        string MembershipNo = StockReports.ExecuteScalar("SELECT IF(DATE(pm.MemberShipDate)>=CURDATE(),IFNULL(pm.MemberShip,''),'')MemberShipCardNo from patient_master pm where PatientID='" + ViewState["PatientID"].ToString() + "'");

        DataRowView row;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            var dtDoctor = (DataTable)ViewState["dtDoctor"];
            row = (DataRowView)e.Row.DataItem;
            if (((Label)e.Row.FindControl("lblType_ID")).Text == "2" ||
                ((Label)e.Row.FindControl("lblType_ID")).Text == "1")
            {
                ((DropDownList)e.Row.FindControl("ddlDoctor")).DataSource = dtDoctor;
                ((DropDownList)e.Row.FindControl("ddlDoctor")).DataTextField = "Name";
                ((DropDownList)e.Row.FindControl("ddlDoctor")).DataValueField = "DoctorID";
                ((DropDownList)e.Row.FindControl("ddlDoctor")).DataBind();
                ((DropDownList)e.Row.FindControl("ddlDoctor")).Items.Insert(0, new ListItem("-", "0#0"));
                ((Label)e.Row.FindControl("lblDoctor")).Visible = false;

                var dtItem = (DataTable)ViewState["SurgeryItem"];

                if (dtItem != null && dtItem.Rows.Count > 0)
                {
                    if (dtItem.Columns.Contains("DoctorIDIndex") == false)
                        dtItem.Columns.Add(new DataColumn("DoctorIDIndex", typeof(int)));

                    foreach (DataRow dr in dtItem.Rows)
                    {
                        if (((Label)e.Row.FindControl("lblItemID")).Text == dr["ItemID"].ToString())
                        {

                            if (dr.Table.Columns.Contains("DoctorIDIndex") == true &&
                                dr["DoctorIDIndex"].ToString() != "")
                            {
                                ((DropDownList)e.Row.FindControl("ddlDoctor")).SelectedIndex =
                                    Util.GetInt(dr["DoctorIDIndex"]);
                                break;
                            }

                            else
                            {
                                var ddlDoc = ((DropDownList)e.Row.FindControl("ddlDoctor"));

                                foreach (ListItem li in ddlDoc.Items)
                                {
                                    if (Util.GetString(li.Value.Split('#')[0]) == Util.GetString(dr["DoctorID"]))
                                    {
                                        ddlDoc.SelectedIndex = ddlDoc.Items.IndexOf(li);
                                        break;
                                    }
                                }

                                break;
                            }
                        }
                    }
                }
            }
            else
            {
                ((DropDownList)e.Row.FindControl("ddlDoctor")).Visible = false;
                ((Label)e.Row.FindControl("lblDoctor")).Visible = true;
            }


            string PatientType = ViewState["PatientType"].ToString();
            string ScheduleChargeID = ViewState["ScheduleChargeID"].ToString();
            string SubCategoryID = ((Label)e.Row.FindControl("lblSubCategoryID")).Text;
            string ItemID = ((Label)e.Row.FindControl("lblItemID")).Text;

            if (ViewState["IsEdit"] != null && Util.GetBoolean(ViewState["IsEdit"]) == true)
            {
                decimal aa = Util.GetDecimal(((TextBox)e.Row.FindControl("txtDiscPer")).Text);

                if (aa == 0)
                {
                    ((TextBox)e.Row.FindControl("txtDiscPer")).Text = "0";
                    ((TextBox)e.Row.FindControl("txtDiscAmt")).Text = "0";
                }
            }
            else
            {
                var ds = new GetDiscount();

                decimal DiscPerc = 0;
                if (Resources.Resource.IsmembershipInIPD == "1")
                {
                    if (Util.GetInt(ViewState["PanelID"].ToString()) == 1)
                    {
                        if (MembershipNo != "")
                        {
                            DiscPerc = Util.GetDecimal(ds.GetDefaultDiscount_Membership(Util.GetString(((Label)e.Row.FindControl("lblItemID")).Text), MembershipNo, "IPD").Split('#')[0].ToString());
                        }
                        else
                        {
                            //DiscPerc = ds.GetDefaultDiscount(SubCategoryID, Util.GetInt(ViewState["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");
                        }
                    }
                    else
                    {
                        //DiscPerc = ds.GetDefaultDiscount(SubCategoryID, Util.GetInt(ViewState["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");
                    }
                }
                else
                {
                    //DiscPerc = ds.GetDefaultDiscount(SubCategoryID, Util.GetInt(ViewState["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");
                }

                //   decimal DiscPerc = ds.GetDefaultDiscount(SubCategoryID, Util.GetInt(ViewState["PanelID"].ToString()), Util.GetDateTime(DateTime.Now.ToString()), PatientType, "IPD");

                decimal aa = Util.GetDecimal(((TextBox)e.Row.FindControl("txtDiscPer")).Text);

                if (DiscPerc > 0)
                {
                    ((TextBox)e.Row.FindControl("txtDiscPer")).Text = DiscPerc.ToString();
                    ((TextBox)e.Row.FindControl("txtDiscAmt")).Text = "0";
                }
                else
                {
                    if (aa == 0)
                    {
                        ((TextBox)e.Row.FindControl("txtDiscPer")).Text = "0";
                        ((TextBox)e.Row.FindControl("txtDiscAmt")).Text = "0";
                    }
                }
            }

            var discountPercent = Util.GetDecimal(((TextBox)e.Row.FindControl("txtDiscPer")).Text);
            var dataTableCoPayDiscont = AllLoadData_IPD.getIPDPanelDiscPer(Util.GetInt(ViewState["PanelID"]), Util.GetString(ItemID), Util.GetInt(ViewState["PatientTypeID"]));
            decimal ispanelWiseDiscount = 0;
            if (discountPercent <= 0)
            {
                ((TextBox)e.Row.FindControl("txtDiscPer")).Text = Util.GetString(dataTableCoPayDiscont.Rows[0]["IPDPanelDiscPercent"]);
                ispanelWiseDiscount = Util.GetDecimal(((TextBox)e.Row.FindControl("txtDiscPer")).Text);

            }
            ((Label)e.Row.FindControl("lblNonPayable")).Text = Util.GetString(dataTableCoPayDiscont.Rows[0]["isPayble"]) == "1" ? "Yes" : "No";
            ((Label)e.Row.FindControl("lblCoPayment")).Text = Util.GetString(dataTableCoPayDiscont.Rows[0]["IPDCoPayPercent"]);
            if (ispanelWiseDiscount > 0)
            {
                ((Label)e.Row.FindControl("lblIsPanelWiseDiscount")).Text = "1";
            }
            if (Util.GetInt(((Label)e.Row.FindControl("lblIsPanelWiseDiscount")).Text) == 1)
            {
                ((TextBox)e.Row.FindControl("txtDiscPer")).Enabled = false;
                ((TextBox)e.Row.FindControl("txtDiscAmt")).Enabled = false;
            }

        }
    }

    private bool CheckValidation()
    {



        //max Discount Validation\
        DataTable dt = GetDescTable();


        string userID = HttpContext.Current.Session["ID"].ToString();
        var maxEligibleDiscountPercent = Util.round(All_LoadData.GetEligiableDiscountPercent(userID));
        int invalidDiscountItems = 0;

        //var maxDiscountItems = dataLTD.Where(d => d.DiscountPercentage > maxEligibleDiscountPercent).ToList();


        //if (maxDiscountItems.Count > 0)
        //{
        //    tnx.Rollback();
        //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>" });
        //}



        for (int i = 0; i < dt.Rows.Count; i++)
        {

            var discountPercent = Util.GetDecimal(dt.Rows[i]["Discount"]);
            if (discountPercent > maxEligibleDiscountPercent)
                invalidDiscountItems += 1;

        }




        var message = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>";

        if (invalidDiscountItems > 0)
        {

            Page.ClientScript.RegisterStartupScript(this.GetType(), "AuthorizationScript56", "$(function () { modelAlert('" + message + "')  });", true);
            return false;
            //return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.maxDiscountValidationErrorMessage + maxEligibleDiscountPercent + "</b>" });
        }

        //max Discount Validation




        if (Util.GetDecimal(lblTotalAmt.Text) == 0)
        {
            lblMsg.Text = "Please Enter Total Amount";
            return false;
        }

        if (txtDocCharges.Text == "" && txtSurgeryAmt.Text == "")
        {
            lblMsg.Text = "Please Enter either Total Surgery Amt. or Total Surgeon Charges";
            return false;
        }

        if ((Util.GetDecimal(txtDocShared.Text) > 0 && Util.GetDecimal(txtDocCharges.Text) > 0) ||
            (Util.GetDecimal(txtDocShared.Text) > 0 && Util.GetDecimal(txtSurgeryAmt.Text) > 0) ||
            (Util.GetDecimal(txtSurgeryAmt.Text) > 0 && Util.GetDecimal(txtDocCharges.Text) > 0))
        {
            lblMsg.Text = "Please Enter any one, either Total Surgery Amt. or Total Surgeon Charges";
            return false;
        }

        foreach (GridViewRow row in gvItem.Rows)
        {
            if (((CheckBox)row.FindControl("chkSelect")).Checked == true &&
                ((Label)row.FindControl("lblType_ID")).Text == "2" ||
                ((Label)row.FindControl("lblType_ID")).Text == "1")
            {
                if (((DropDownList)row.FindControl("ddlDoctor")).SelectedIndex == 0)
                {
                    lblMsg.Text = "Please Select Doctor";
                    ((DropDownList)row.FindControl("ddlDoctor")).Focus();
                    return false;
                }
            }
            if ((((CheckBox)row.FindControl("chkSelect")).Checked == true) && (((TextBox)row.FindControl("txtDiscAmt")).Text != "0" ||
                (((TextBox)row.FindControl("txtDiscPer")).Text != "0.00")))
            {
                if (ddlApproveBy.SelectedIndex == 0)
                {
                    lblMsg.Text = "Please Select Approval ";
                    return false;
                }
            }
        }
        string a = "";
        string b = "";
        foreach (GridViewRow row in gvItem.Rows)
        {
            if (a == "")
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked == true &&
                    ((Label)row.FindControl("lblType_ID")).Text == "2" ||
                    ((Label)row.FindControl("lblType_ID")).Text == "1")
                {
                    a = ((DropDownList)row.FindControl("ddlDoctor")).SelectedValue;
                }
            }
            else
            {
                if (((CheckBox)row.FindControl("chkSelect")).Checked == true &&
                    ((Label)row.FindControl("lblType_ID")).Text == "2" ||
                    ((Label)row.FindControl("lblType_ID")).Text == "1")
                {
                    b = ((DropDownList)row.FindControl("ddlDoctor")).SelectedValue;
                }
            }
            if (a == b)
            {
                lblMsg.Text = "Surgeon Name Cannot Be Same as Second Surgeon Name";
                return false;
            }
        }

        return true;
    }
    protected void rdoSurgeryCalculate_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDocType();
        txtSurgeryAmt.Text = "";
        txtDocCharges.Text = "";
        lblTotalAmt.Text = "";
        gvItem.Enabled = true;
        for (int i = 0; i < gvItem.Rows.Count; i++)
        {
            if (((DropDownList)gvItem.Rows[0].FindControl("ddlDoctor")).Visible == true)
            {
                ((DropDownList)gvItem.Rows[i].FindControl("ddlDoctor")).SelectedIndex = 0;
            }

            if (Util.GetInt(((Label)gvItem.Rows[i].FindControl("lblIsPanelWiseDiscount")).Text) == 1)
            {
                ((TextBox)gvItem.Rows[i].FindControl("txtDiscPer")).Enabled = false;
                ((TextBox)gvItem.Rows[i].FindControl("txtDiscAmt")).Enabled = false;
            }
        }



    }
    protected void BtnCalSurgery_Click(object sender, EventArgs e)
    {
        decimal TotalSurgeryAmt = 0, Rate = 0, ReducePer = 0; var dtItem = new DataTable();
        for (int i = 0; i < gvSurgeryDetail.Rows.Count; i++)
        {
            Rate = Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[i].FindControl("txtRate")).Text);
            ReducePer = Util.GetDecimal(((TextBox)gvSurgeryDetail.Rows[i].FindControl("txtCalReducePerOn")).Text);
            TextBox NewRate = (TextBox)gvSurgeryDetail.Rows[i].FindControl("txtNewRate");
            TextBox Remark = (TextBox)gvSurgeryDetail.Rows[i].FindControl("txtRemark");
            NewRate.Text = Util.GetString(Math.Round(Rate - (Rate * (ReducePer) * Util.GetDecimal(0.01)), 2, MidpointRounding.ToEven));
            TotalSurgeryAmt += Util.GetDecimal(NewRate.Text);
            if (ViewState["SurgeryDetail"] != null)
            {
                dtItem = (DataTable)ViewState["SurgeryDetail"];
                if (dtItem != null & dtItem.Rows.Count > 0)
                {
                    for (int j = 0; j < dtItem.Rows.Count; j++)
                    {
                        if (Util.GetString(dtItem.Rows[j]["SurgeryID"]) == Util.GetString(((Label)gvSurgeryDetail.Rows[i].FindControl("lblSurgeryID")).Text))
                        {
                            dtItem.Rows[j]["Rate"] = Util.GetDecimal(Rate);
                            dtItem.Rows[j]["CalReducePerOn"] = Util.GetDecimal(ReducePer);
                            dtItem.Rows[j]["NewRate"] = Util.GetDecimal(NewRate.Text);
                            dtItem.Rows[j]["Remark"] = Util.GetString(Remark.Text);
                        }
                    }
                }
            }
            ViewState["SurgeryDetail"] = dtItem;
        }
        Label lbl = (Label)gvSurgeryDetail.FooterRow.FindControl("lblTotal");
        lbl.Text = Math.Round(TotalSurgeryAmt, 2, MidpointRounding.ToEven).ToString();
        txttotal.Text = Math.Round(TotalSurgeryAmt, 2, MidpointRounding.ToEven).ToString();
        if (rdoRateType.SelectedValue == "1")// Surgery
            txtSurgeryAmt.Text = Math.Round(TotalSurgeryAmt, 2, MidpointRounding.ToEven).ToString();
        else if (rdoRateType.SelectedValue == "2") // Surgeon
            txtDocCharges.Text = Math.Round(TotalSurgeryAmt, 2, MidpointRounding.ToEven).ToString();
        if (dtItem != null)
        {
            dtItem.DefaultView.Sort = "rate desc";
            dtItem = dtItem.DefaultView.ToTable();
        }
        gvSurgeryDetail.DataSource = dtItem;
        gvSurgeryDetail.DataBind();
    }
    protected void gvSurgeryDetail_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        decimal Rate = 0, ReducePer = 0, NewRate = 0;
        GridViewRow gvr = e.Row;
        TextBox txtReducePerold = ((TextBox)e.Row.FindControl("txtReducePerOn"));
        TextBox txtReducePer = ((TextBox)e.Row.FindControl("txtCalReducePerOn"));
        TextBox txtRate = ((TextBox)e.Row.FindControl("txtRate"));
        TextBox txtNewRate = ((TextBox)e.Row.FindControl("txtNewRate"));
        TextBox txtSurgeryremarks = ((TextBox)e.Row.FindControl("txtRemark"));
        int panelid = Util.GetInt(ViewState["PanelID"]);
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT psrm.Reduce_per,psrm.SequenceNo,psrm.Remarks FROM  Panelwise_Service_Reduce_Master psrm WHERE Panelid=" + panelid + " AND ServiceName='Surgery' AND isactive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        int ss = gvSurgeryDetail.Rows.Count;
        string Reduce_Per = "";
        string remarks = "";
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            double TotalAmount;
            TotalAmount = Util.GetDouble(Session["TotalAmount"]);
            if (e.Row.RowIndex == 0)
            {
                Rate = Util.GetDecimal(txtRate.Text); ReducePer = 0; txtReducePer.Text = "0";
                NewRate = Rate;
            }
            else if (e.Row.RowIndex > 0)
            {
                Rate = Util.GetDecimal(txtRate.Text); // ReducePer = 50; txtReducePer.Text = "50";
                if (dt.Rows.Count > 0)
                {
                    DataRow[] dr = dt.Select("SequenceNo='" + ss + "'");
                    foreach (DataRow row in dr)
                    {
                        Reduce_Per = Util.GetString(row["Reduce_per"]);
                        remarks = Util.GetString(row["Remarks"]);
                    }
                    if (txtReducePer.Text == "0")
                        txtReducePer.Text = Reduce_Per.ToString();
                    txtSurgeryremarks.Text = remarks.ToString();
                }
                else
                {
                    if (txtReducePer.Text == "0")
                        txtSurgeryremarks.Text = remarks.ToString();
                }
                ReducePer = Util.GetDecimal(txtReducePer.Text);
                NewRate = Util.GetDecimal((Rate - (Rate * ReducePer) / 100));
            }
            txtNewRate.Text = Util.GetString(Math.Round(NewRate, 2, MidpointRounding.ToEven));
            e.Row.Cells[9].Enabled = false;
            Total += NewRate;
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label lbl = (Label)e.Row.FindControl("lblTotal");
            lbl.Text = Total.ToString();
            txttotal.Text = Total.ToString();
            if (rdoRateType.SelectedValue == "1")// Surgery
                txtSurgeryAmt.Text = Total.ToString();
            else if (rdoRateType.SelectedValue == "2") // Surgeon
            {
                txtDocCharges.Text = Total.ToString();
                txtSurgeryAmt.Text = "";
            }
        }
    }
    protected void gvSurgeryDetail_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable dtItem = (DataTable)ViewState["SurgeryDetail"];
        dtItem.Rows[e.RowIndex].Delete();
        dtItem.AcceptChanges();
        lblTotalAmt.Text = "0.00";
        gvSurgeryDetail.DataSource = dtItem;
        gvSurgeryDetail.DataBind();
    }
    private DataTable GetSurgeryDetail()
    {
        var dtSurgeryDetail = new DataTable();
        dtSurgeryDetail.Columns.Add("IsSelected");
        dtSurgeryDetail.Columns.Add("SurgeryCode");
        dtSurgeryDetail.Columns.Add("SurgeryID");
        dtSurgeryDetail.Columns.Add("SurgeryName");
        dtSurgeryDetail.Columns.Add("Department");
        dtSurgeryDetail.Columns.Add("Rate", typeof(decimal));
        dtSurgeryDetail.Columns.Add("ReducePerOn", typeof(decimal));
        dtSurgeryDetail.Columns.Add("CalReducePerOn", typeof(decimal));
        dtSurgeryDetail.Columns.Add("NewRate", typeof(decimal));
        dtSurgeryDetail.Columns.Add("LedgerTnxNo");
        dtSurgeryDetail.Columns.Add("Remark");
        return dtSurgeryDetail;
    }
    private void LoadSurgeryDetail(string LedTnxID)
    {
        var sb = new StringBuilder();
        sb.Append("SELECT 'true' IsSelected,SurgeryCode,SurgeryID,SurgeryName,Department,Rate,ReducePerOn,CalReducePerOn,NewRate,LedgerTnxNo,Remark,RateCalon,SurgeryCalon FROM f_surgery_detail_ipd");
        sb.Append(" WHERE LedgerTnxNo='" + LedTnxID + "'");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["RateCalon"].ToString() == "2")
            {
                rdoRateType.SelectedValue = "2";
            }
            rdoSurgeryCalculate.SelectedValue = dt.Rows[0]["SurgeryCalon"].ToString();
            ViewState["SurgeryDetail"] = dt;
            gvSurgeryDetail.DataSource = dt;
            gvSurgeryDetail.DataBind();
        }
    }
}