using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CPOE_MedicationRecord : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                ViewState["UserID"] = Session["ID"].ToString();
                ViewState["TID"] = Request.QueryString["TransactionID"].ToString();
                ViewState["PID"] = Request.QueryString["PatientID"].ToString();
                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                BindMedicineGrid();
                BindOtherMedicine();
                txtDateOther.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
                ddlOtherRoute.DataSource = AllGlobalFunction.Route;
                ddlOtherRoute.DataBind();
                ddlOtherFrequency.DataSource = AllGlobalFunction.FreQuency;
                ddlOtherFrequency.DataBind();
            }
            txtDateOther.Attributes.Add("readonly", "true");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private DataTable BindMedicine()
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT 'OPD'STATUS,  ");
            sb.Append(" im.ItemID,SoldUnits IssueQty,sd.Date Date1,DATE_FORMAT(CONCAT(sd.Date,' ',sd.time),'%d-%b-%y %l:%i %p')DATE, ");
            sb.Append(" ltd.ItemName FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID   ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID  ");
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID  ");
            sb.Append(" INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
            sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID   ");
            sb.Append(" LEFT join patient_medicine pme on pme.Medicine_ID=im.itemid AND pme.OPDLedgertansactionNO=LT.LedgerTransactionNo ");
            sb.Append(" WHERE lt.TypeOfTnx='Pharmacy-Issue' AND LT.IsCancel =0  AND pme.TransactionID='" + ViewState["TID"].ToString() + "'   ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw;
        }
    }

    protected void BindMedicineGrid()
    {
        try
        {
            DataTable dt = BindMedicine();
            if (dt.Rows.Count > 0)
            {
                rptMedicine.DataSource = dt;
                rptMedicine.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void rptMedicine_ItemCommand(object sender, RepeaterCommandEventArgs e)
    {
        try
        {
            string opType = ((ImageButton)e.CommandSource).AlternateText.ToUpper();
            Repeater rpt = (Repeater)e.Item.FindControl("rptMedicineDetails");
            if (opType == "SHOW")
            {
                string ID_Date = Convert.ToString(e.CommandArgument);

                ((ImageButton)e.CommandSource).AlternateText = "Hide";
                ((ImageButton)e.CommandSource).ImageUrl = "~/Images/minus.png";
                DataTable dt = BindMedicineDetail(ID_Date.Split('#')[0], Util.GetDateTime(ID_Date.Split('#')[1]));

                rpt.DataSource = dt;
                rpt.DataBind();
                lblMsg.Text = string.Empty;
            }
            else
            {
                ((ImageButton)e.CommandSource).AlternateText = "Show";
                ((ImageButton)e.CommandSource).ImageUrl = "~/Images/plus.png";

                rpt.DataSource = null;
                rpt.DataBind();
                lblMsg.Text = "";
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ac1", "window.top.location.hash='" + ((ImageButton)e.CommandSource).ClientID + "';", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void rptMedicineDetails_ItemCommand(object sender, RepeaterCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "cancel")
            {
                StockReports.ExecuteDML("Delete from cpoe_medication_record where ID='" + e.CommandArgument.ToString().Split('#')[3] + "' ");
                DataTable dt = BindMedicineDetail(e.CommandArgument.ToString().Split('#')[0], Util.GetDateTime(((Label)e.Item.Parent.Parent.FindControl("lblIssueDate")).Text));
                Repeater rpt1 = (Repeater)e.Item.Parent.Parent.FindControl("rptMedicineDetails");
                rpt1.DataSource = dt;
                rpt1.DataBind();
                lblMsg.Text = "Item Removed Successfully";
            }
            else
            {
                Repeater rpt = (Repeater)e.Item.Parent.Parent.FindControl("rptMedicineDetails");

                Control HeaderTemplate = rpt.Controls[0].Controls[0];
                TextBox txtDate = HeaderTemplate.FindControl("txtDate") as TextBox;
                TextBox txttime = HeaderTemplate.FindControl("txttime") as TextBox;
                TextBox txtDose = HeaderTemplate.FindControl("txtDose") as TextBox;
                //     TextBox txtRoute = HeaderTemplate.FindControl("txtRoute") as TextBox;
                //      TextBox txtFrequency = HeaderTemplate.FindControl("txtFrequency") as TextBox;
                RadioButtonList rdoStatus = HeaderTemplate.FindControl("rdoStatus") as RadioButtonList;
                DropDownList ddlStatusType = HeaderTemplate.FindControl("ddlStatusType") as DropDownList;
                DropDownList ddlRouteHos = HeaderTemplate.FindControl("ddlRouteHos") as DropDownList;
                DropDownList ddFreHos = HeaderTemplate.FindControl("ddFreHos") as DropDownList;

                string ItemID = ((Label)e.Item.Parent.Parent.FindControl("lblItemID")).Text;
                string ItemName = ((Label)e.Item.Parent.Parent.FindControl("lblItemName")).Text;
                string IssueDate = Util.GetDateTime(((Label)e.Item.Parent.Parent.FindControl("lblIssueDate")).Text).ToString("yyyy-MM-dd");
                string MedicineDate = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
                string Status = rdoStatus.SelectedValue;
                string StatusType = ddlStatusType.SelectedItem.Text;

                string str = "Insert into cpoe_medication_record(TransactionID,ItemID,ItemName,IssueDate,DATE,TIME,Dose,Route,Frequency,EntryBy,STATUS,StatusType,indentno)values(";
                str = str + " '" + ViewState["TID"].ToString() + "','" + ItemID + "','" + ItemName + "','" + IssueDate + "','" + MedicineDate + "',";
                str = str + " '" + Util.GetDateTime(txttime.Text).ToString("HH:mm:ss") + "','" + txtDose.Text + "','" + ddlRouteHos.SelectedItem.Text + "','" + ddFreHos.SelectedItem.Text + "','" + ViewState["UserID"].ToString() + "','" + Status + "','" + StatusType + "','Emergency')";
                bool IsSave = StockReports.ExecuteDML(str);
                if (IsSave == true)
                {
                    lblMsg.Text = "Record Save Successfully";
                    DataTable dt = BindMedicineDetail(ItemID, Util.GetDateTime(IssueDate));
                    rpt.DataSource = dt;
                    rpt.DataBind();
                }
                else
                    lblMsg.Text = "Error...";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected DataTable BindMedicineDetail(string ItemID, DateTime IssueDate)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT ID,ItemID,TransactionID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%l:%i %p')TIME,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE Employee_ID=EntryBy)EntryBy,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %l:%i %p')EntryDateTime,Dose,Route,Frequency,StatusType FROM cpoe_medication_record WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND IssueDate='" + Util.GetDateTime(IssueDate).ToString("yyyy-MM-dd") + "' and ItemID='" + ItemID + "' order by date desc,time desc");
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw;
        }
    }

    protected void gridMedicine_RowDataBound(object sender, GridViewRowEventArgs e)
    {
    }

    protected void rptMedicine_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        try
        {
            if (e.Item.ItemIndex >= 0)
            {
                if (((Label)e.Item.FindControl("lblStatus")).Text == "Stopped")
                    ((Label)e.Item.FindControl("lblStatus")).ForeColor = System.Drawing.Color.Red;

                DataTable dt = BindMedicineDetail(((Label)e.Item.FindControl("lblItemID")).Text, Util.GetDateTime(((Label)e.Item.FindControl("lblIssueDate")).Text));
                if (dt.Rows.Count > 0)
                {
                    ((ImageButton)e.Item.FindControl("imbShow")).AlternateText = "Hide";
                    ((ImageButton)e.Item.FindControl("imbShow")).ImageUrl = "~/Images/minus.png";
                    Repeater rpt = (Repeater)e.Item.FindControl("rptMedicineDetails");
                    rpt.DataSource = dt;
                    rpt.DataBind();
                    lblMsg.Text = string.Empty;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void rptMedicineDetails_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        try
        {
            if (((Label)e.Item.Parent.Parent.FindControl("lblStatus")).Text == "Stopped")
            {
                Repeater rpt = (Repeater)e.Item.Parent.Parent.FindControl("rptMedicineDetails");
                Control HeaderTemplate = rpt.Controls[0].Controls[0];
                Button btnSave = HeaderTemplate.FindControl("btnSave") as Button;
                btnSave.Enabled = false;
                RadioButtonList rbtStatus = HeaderTemplate.FindControl("rdoStatus") as RadioButtonList;
                rbtStatus.Enabled = false;
            }
            if (e.Item.ItemIndex >= 0)
            {
                Repeater rpt = (Repeater)e.Item.Parent.Parent.FindControl("rptMedicineDetails");
                Control HeaderTemplate = rpt.Controls[0].Controls[0];
                TextBox textdate = HeaderTemplate.FindControl("txtDate") as TextBox;
                textdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
                textdate.Attributes.Add("readonly", "true");
                DropDownList ddlRouteHos = HeaderTemplate.FindControl("ddlRouteHos") as DropDownList;
                ddlRouteHos.DataSource = AllGlobalFunction.Route;
                ddlRouteHos.DataBind();
                DropDownList ddFreHos = HeaderTemplate.FindControl("ddFreHos") as DropDownList;
                ddFreHos.DataSource = AllGlobalFunction.FreQuency;
                ddFreHos.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSaveOther_Click(object sender, EventArgs e)
    {
        try
        {
            string str = "";
            if (txtMedicineNameOther.Text.Trim() == "")
            {
                lblMsg.Text = "Enter Medicine Name";
                txtMedicineNameOther.Focus();
                return;
            }
            if (txtOtherTime.Text.Trim() == "")
            {
                lblMsg.Text = "Enter Medicine Time";
                txtOtherTime.Focus();
                return;
            }
            if (ddlOtherRoute.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Select Medicine Route";
                ddlOtherRoute.Focus();
                return;
            }
            if (ddlOtherFrequency.SelectedIndex == 0)
            {
                lblMsg.Text = "Please Select Medicine Frequency";
                ddlOtherFrequency.Focus();
                return;
            }
            if (btnSaveOther.Text == "Save")
            {
                str = "Insert into cpoe_medication_record_other(TransactionID,ItemName,DATE,TIME,Dose,Route,Frequency,EntryBy,StatusType)values(";
                str += "'" + ViewState["TID"].ToString() + "','" + txtMedicineNameOther.Text + "','" + Util.GetDateTime(txtDateOther.Text).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(txtOtherTime.Text).ToString("HH:mm:ss") + "','" + txtDoseOther.Text + "','" + ddlOtherRoute.SelectedItem.Text + "','" + ddlOtherFrequency.SelectedItem.Text + "',";
                str += "'" + ViewState["UserID"].ToString() + "','" + ddlStatusTypeOther.SelectedItem.Text + "')";
                lblMsg.Text = "Record Saved Successfully";
            }
            if (btnSaveOther.Text == "Update")
            {
                str = "UPDATE cpoe_medication_record_other SET ItemName = '" + txtMedicineNameOther.Text + "' ,Dose='" + txtDoseOther.Text + "',DATE='" + Util.GetDateTime(txtDateOther.Text).ToString("yyyy-MM-dd") + "',TIME='" + Util.GetDateTime(txtOtherTime.Text).ToString("HH:mm:ss") + "',Entryby='" + ViewState["UserID"].ToString() + "',Frequency='" + ddlOtherFrequency.SelectedItem.Text + "',Route='" + ddlOtherRoute.SelectedItem.Text + "' WHERE ID='" + lblOtherID.Text + "' ";
                lblMsg.Text = "Record Update Successfully";
                btnSaveOther.Text = "Save";
                btnOtherCancel.Visible = false;
            }
            if (!StockReports.ExecuteDML(str))
            {
                lblMsg.Text = "Error....";
            }
            else
            {
                BindOtherMedicine();
                txtMedicineNameOther.Text = "";
                txtDateOther.Text = "";
                txtOtherTime.Text = "";
                txtDoseOther.Text = "";
                ddlOtherRoute.SelectedIndex = -1;
                ddlOtherFrequency.SelectedIndex = -1;
                ddlStatusTypeOther.SelectedIndex = -1;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    private DataTable SearchOtherMedicine()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("Select ID,ItemName,ItemID,TransactionID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%l:%i %p')TIME,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE Employee_ID=EntryBy)EntryBy,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %l:%i %p')EntryDate,Dose,Route,Frequency,StatusType,EntryBy EntryByID from cpoe_medication_record_other where TransactionID='" + ViewState["TID"].ToString() + "' AND isActive='1' ORDER BY EntryDateTime DESC");
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw;
        }
    }

    protected void BindOtherMedicine()
    {
        try
        {
            DataTable dt = SearchOtherMedicine();
            if (dt.Rows.Count > 0)
            {
                grdOtherMedicine.DataSource = dt;
                grdOtherMedicine.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void grdOtherMedicine_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "Change")
            {
                lblMsg.Text = "";
                int id = Convert.ToInt16(e.CommandArgument.ToString());
                string EntryByID = ((Label)grdOtherMedicine.Rows[id].FindControl("lblEntryByID")).Text;
                if (EntryByID == Session["ID"].ToString())
                {
                    lblOtherID.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblID")).Text;
                    txtMedicineNameOther.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblMedicineName")).Text;
                    txtDateOther.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblDate")).Text;
                    txtOtherTime.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblTime")).Text;
                    txtDoseOther.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblDose")).Text;
                    ddlOtherRoute.SelectedItem.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblRoute")).Text;
                    ddlOtherFrequency.SelectedItem.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblFrequency")).Text;
                    btnSaveOther.Text = "Update";
                    btnOtherCancel.Visible = true;
                }
                else
                {
                    lblMsg.Text = "You are Not Able to Edit This Record";
                }
            }
            if (e.CommandName == "CancelOther")
            {
                lblMsg.Text = "";
                int id = Convert.ToInt16(e.CommandArgument.ToString());
                string EntryByID = ((Label)grdOtherMedicine.Rows[id].FindControl("lblEntryByID")).Text;
                if (EntryByID == Session["ID"].ToString())
                {
                    lblOtherID.Text = ((Label)grdOtherMedicine.Rows[id].FindControl("lblID")).Text;
                    string sql = "update cpoe_medication_record_other set isActive='0' where ID=" + lblOtherID.Text + " ";
                    StockReports.ExecuteDML(sql);
                    BindOtherMedicine();
                }
                else
                {
                    lblMsg.Text = "You are Not Able to Delete This Record";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnOtherMedicine_Click(object sender, EventArgs e)
    {
        lblOtherID.Text = "";
        txtMedicineNameOther.Text = "";
        txtDateOther.Text = "";
        ddlStatusTypeOther.Text = "";
        txtDoseOther.Text = "";
        ddlOtherRoute.SelectedIndex = -1;
        ddlOtherFrequency.SelectedIndex = -1;
        btnSaveOther.Text = "Save";
        btnOtherCancel.Visible = false;
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = new DataSet();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[0].TableName = "logo";
            AllQuery AQ = new AllQuery();
            DataTable dtStatus = AQ.GetPatientDischargeStatus(ViewState["TID"].ToString());
            string Status = dtStatus.Rows[0]["Status"].ToString();
            DataTable dtInfo = AQ.GetPatientIPDInformation("", ViewState["TID"].ToString(), Status);
            ds.Tables.Add(dtInfo.Copy());
            ds.Tables[1].TableName = "PatientInfo";
            DataTable dtOther = SearchOtherMedicine();
            ds.Tables.Add(dtOther.Copy());
            ds.Tables[2].TableName = "OutSideMedicine";
            DataTable dt = StockReports.GetDataTable("SELECT ID,ItemID,Itemname,TransactionID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%l:%i %p')TIME,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE Employee_ID=EntryBy)EntryBy,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %l:%i %p')EntryDateTime,Dose,Route,Frequency,StatusType FROM cpoe_medication_record WHERE TransactionID='" + ViewState["TID"].ToString() + "'  order by date desc,time desc");
            ds.Tables.Add(dt.Copy());
            ds.Tables[3].TableName = "HospitalMedicine";
            if (dt.Rows.Count > 0 || dtOther.Rows.Count > 0)
            {
                // ds.WriteXmlSchema(@"E:\MedicationRecord.xml");
                Session["ReportName"] = "MedicationRecord";
                Session["ds"] = ds;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }
            else
            {
                lblMsg.Text = "No Record Found";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}