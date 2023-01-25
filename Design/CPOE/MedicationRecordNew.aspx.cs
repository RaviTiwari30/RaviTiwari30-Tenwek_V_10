using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Design_CPOE_MedicationRecordNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!IsPostBack)
            {
                ViewState["UserID"] = Session["ID"].ToString();
                if (Request.QueryString["Transaction_ID"] == null)
                    ViewState["TID"] = Request.QueryString["TID"].ToString();
                else
                    ViewState["TID"] = Request.QueryString["Transaction_ID"].ToString();

                if (Request.QueryString["PatientID"] == null)
                    ViewState["PID"] = Request.QueryString["PID"].ToString();
                else
                    ViewState["PID"] = Request.QueryString["PatientID"].ToString();

                ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
                ViewState["CanEditMedicationRecord"] = "0";
                DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
                if (dtAuthority.Rows.Count > 0)
                {
                    if (dtAuthority.Rows[0]["CanEditMedicationRecord"].ToString() == "1")
                    {
                        ViewState["CanEditMedicationRecord"] = "1";
                    }
                }
                BindMedicineGrid();
                ddlPopTimes.DataSource = AllGlobalFunction.MedicineTimes;
                ddlPopTimes.DataBind();

                DataTable dtTimes = StockReports.GetDataTable("SELECT NAME,concat(Quantity,'#',Name)Val, TYPE FROM phar_label_master WHERE isActive = 1 and Type='Time' ORDER BY SequenceNo");
                DataTable dtDuration = StockReports.GetDataTable("SELECT NAME,Quantity FROM phar_label_master WHERE isActive = 1 and TYPE='Duration' ORDER BY SequenceNo");
                
                if (dtTimes.Rows.Count>0)
                {
                    ddlTime.DataSource = dtTimes;
                    ddlTime.DataTextField = "NAME";
                    ddlTime.DataValueField = "Val";
                    ddlTime.DataBind();

                    ddlDuration.DataSource = dtDuration;
                    ddlDuration.DataTextField = "NAME";
                    ddlDuration.DataValueField = "Quantity";
                    ddlDuration.DataBind();

                    ddlRoute.DataSource = AllGlobalFunction.Route;
                    ddlRoute.DataBind();
                }
                
            }
            txtPopDuration.Attributes.Add("readonly", "readonly");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void BindMedicineGrid()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT t.*,if(ReceiveQty=0,'Not Issued',IF((ReceiveQty-IFNULL(GivenQty,0))=0,'Completed',IF(DATE(duration)<DATE(NOW()),'Completed',IF(IFNULL(a,'0')=0,'Running',IF(a=2,'Stopped','')))))STATUS,ROUND((ReceiveQty-IFNULL(GivenQty,0)),0)RemainingQty  FROM (SELECT om.IndentNo,");
            sb.Append("  (SELECT STATUS FROM cpoe_medication_record mr WHERE itemID=om.MedicineID AND TransactionID=pmh.TransactionID AND IndentNo=om.IndentNo ORDER BY id DESC LIMIT 1 )a,");
            sb.Append("  ROUND((SELECT SUM(Qty) FROM cpoe_medication_record mr WHERE itemID=om.MedicineID AND TransactionID=pmh.TransactionID AND IF(SUBSTRING(om.MedicineID,1,3)='OTH',IndentNo=IndentNo,IndentNo=om.IndentNo) ),0)GivenQty,");
            sb.Append("  om.IsInHouseMedicine, om.MedicineID AS ItemID,om.MedicineName AS ItemName,ROUND(IFNULL(id.ReqQty,om.ReqQty),0)IssueQty,IF(SUBSTRING(om.MedicineID,1,3)='OTH',om.ReqQty,ROUND(IFNULL(id.ReceiveQty,om.ReqQty),0))ReceiveQty,om.Dose,om.Timing,om.Route,om.Duration,DATE_FORMAT(om.Entrydate,'%d-%b-%y %l:%i %p')DATE,");
            sb.Append("  (SELECT CONCAT(title,' ',NAME) FROM employee_master WHERE EmployeeID=om.EntryBy)EName,om.Subcategoryid  ");
           // sb.Append("  FROM orderset_Outsidemedication om INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID = om.TransactionID");
            sb.Append("  FROM orderset_Outsidemedication om INNER JOIN patient_medical_history pmh ON pmh.TransactionID = om.TransactionID ");
            sb.Append("  LEFT OUTER JOIN f_indent_detail_patient id ON om.IndentNo=id.IndentNo AND om.MedicineID=id.ItemId");
           // sb.Append("  LEFT OUTER JOIN `f_indent_detail_patient_return` idRtn ON idrtn.`ReceivedOnIndentNo`=om.`IndentNo` ");
            sb.Append("  LEFT OUTER JOIN f_salesdetails sd ON sd.IndentNo=id.IndentNo AND sd.ItemID=id.ItemId AND sd.TrasactionTypeID='3'");
            //sb.Append("  left JOIN f_itemmaster im ON im.ItemID=om.MedicineID ");
            //sb.Append("  left JOIN f_subcategorymaster scm ON scm.SubCategoryID=im.SubCategoryID ");
            //sb.Append("  left JOIN f_categorymaster cm ON cm.CategoryID=scm.CategoryID ");
            //sb.Append("  WHERE pmh.Transaction_ID = '" + ViewState["TID"].ToString() + "' AND cm.CategoryID='"+ ddldrugType.SelectedValue +"' GROUP BY om.IndentNo,om.MedicineID ORDER BY om.EntryDate DESC");
            sb.Append("  WHERE pmh.TransactionID = '" + ViewState["TID"].ToString() + "'  GROUP BY om.IndentNo,om.MedicineID ORDER BY om.EntryDate DESC");
            sb.Append("  )t");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
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
                DataTable dt = BindMedicineDetail(ID_Date.Split('#')[0], Util.GetString(ID_Date.Split('#')[1]));

                rpt.DataSource = dt;
                rpt.DataBind();
                lblMsg.Text = string.Empty;
            }
            else if (opType == "EDIT")
            {
                string Val = Convert.ToString(e.CommandArgument);
                txtPopDose.Text = Util.GetString(Val.Split('#')[2]);
                ddlPopTimes.SelectedIndex = ddlPopTimes.Items.IndexOf(ddlPopTimes.Items.FindByText(Util.GetString(Val.Split('#')[3])));
                txtPopDuration.Text = Util.GetDateTime(Val.Split('#')[4]).ToString("dd-MMM-yyyy");
                lblIndentNo.Text = Val.Split('#')[1].ToString();
                lblPopItemID.Text = Val.Split('#')[0].ToString();

                mpDose.Show();

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

    protected DataTable BindMedicineDetail(string ItemID, string IndentNo)
    {
        try
        {
            DataTable dt;
            if (ItemID.Substring(0, 3).ToString().ToUpper() == "OTH")
                dt = StockReports.GetDataTable("SELECT ID,Remark,Round(Qty,0)Qty,IndentNo,ItemID,TransactionID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%l:%i %p')TIME,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %l:%i %p')EntryDateTime,Dose,Route,Frequency,StatusType FROM cpoe_medication_record WHERE TransactionID='" + ViewState["TID"].ToString() + "' and ItemID='" + ItemID + "' order by date desc,time desc");
            else
                dt = StockReports.GetDataTable("SELECT ID,Remark,Round(Qty,0)Qty,IndentNo,ItemID,TransactionID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%l:%i %p')TIME,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %l:%i %p')EntryDateTime,Dose,Route,Frequency,StatusType FROM cpoe_medication_record WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND IndentNo='" + Util.GetString(IndentNo) + "' and ItemID='" + ItemID + "' order by date desc,time desc");
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw;
        }
    }

    protected void rptMedicineDetails_ItemCommand(object sender, RepeaterCommandEventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            if (e.CommandName == "cancel")
            {
                string qry = "Delete from cpoe_medication_record where ID=" + e.CommandArgument.ToString().Split('#')[3] + " and TransactionID='" + e.CommandArgument.ToString().Split('#')[2] + "' and ItemID='" + e.CommandArgument.ToString().Split('#')[0] + "' and IndentNo='" + e.CommandArgument.ToString().Split('#')[1] + "'";
                StockReports.ExecuteDML(qry);
                DataTable dt = BindMedicineDetail(e.CommandArgument.ToString().Split('#')[0], e.CommandArgument.ToString().Split('#')[1]);
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
                DropDownList ddlRoute = HeaderTemplate.FindControl("ddlRouteHos") as DropDownList;
                DropDownList ddFreequency = HeaderTemplate.FindControl("ddFreHos") as DropDownList;
                TextBox txtRemark = HeaderTemplate.FindControl("txtRemark") as TextBox;
                TextBox txtQty = HeaderTemplate.FindControl("txtQty") as TextBox;
                RadioButton rdoStop = HeaderTemplate.FindControl("rdoStop") as RadioButton;

                string ItemID = ((Label)e.Item.Parent.Parent.FindControl("lblItemID")).Text;
                string ItemName = ((Label)e.Item.Parent.Parent.FindControl("lblItemName")).Text;
                string IssueDate = Util.GetDateTime(((Label)e.Item.Parent.Parent.FindControl("lblIssueDate")).Text).ToString("yyyy-MM-dd");
                string IndentNo = ((Label)e.Item.Parent.Parent.FindControl("lblIndentNo")).Text;

                string MedicineDate = Util.GetDateTime(txtDate.Text).ToString("yyyy-MM-dd");
                string StatusType = ((Label)e.Item.Parent.Parent.FindControl("lblStatus")).Text;
                //string status = ((Label)e.Item.Parent.Parent.FindControl("lblStatusID")).Text;

                decimal IssuedQty = 0;
                if (ItemID.Substring(0, 3).ToString().ToUpper() != "OTH")
                    IssuedQty = Util.GetDecimal(StockReports.ExecuteScalar("Select Sum(ifnull(Qty,0)) from cpoe_medication_record where TransactionID='" + ViewState["TID"].ToString() + "' and IndentNo='" + IndentNo + "' and ItemID='" + ItemID + "'"));
                else
                    IssuedQty = Util.GetDecimal(StockReports.ExecuteScalar("Select Sum(ifnull(Qty,0)) from cpoe_medication_record where TransactionID='" + ViewState["TID"].ToString() + "' and ItemID='" + ItemID + "'"));
               
                decimal ReceivedQty = 0;
                if (ItemID.Substring(0, 3).ToString().ToUpper() != "OTH")               
                    ReceivedQty = Util.GetDecimal(StockReports.ExecuteScalar("Select Sum(ifnull(ReceiveQty,0)) from f_indent_detail_patient where Transaction_ID='" + ViewState["TID"].ToString() + "' and IndentNo='" + IndentNo + "' and ItemID='" + ItemID + "'"));               
                else
                    ReceivedQty = Util.GetDecimal(StockReports.ExecuteScalar("Select Sum(ifnull(ReqQty,0)) from orderset_Outsidemedication where TransactionID='" + ViewState["TID"].ToString() + "' and MedicineID='" + ItemID + "'"));

                decimal ReturnQty = 0;
                if (ItemID.Substring(0, 3).ToString().ToUpper() != "OTH")
                    ReturnQty = Util.GetDecimal(StockReports.ExecuteScalar("Select Sum(ifnull(ReceiveQty,0)) from f_indent_detail_patient_return where Transaction_ID='" + ViewState["TID"].ToString() + "' and ReceivedOnIndentNo='" + IndentNo + "' and ItemID='" + ItemID + "'"));

                if ((ReceivedQty - (Util.GetDecimal(txtQty.Text) + IssuedQty + ReturnQty)) < 0)
                {
                    lblMsg.Text = "Can not give qty. more than remainign qty.";
                    return;
                }
                if (Session["RoleID"].ToString() != "52")
                {
                    if (txtDose.Text.Trim() == "")
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Enter Dose');", true);
                        txtDose.Focus();
                        return;
                    }
                    if (txtQty.Text.Trim() == "")
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Enter Qty.');", true);
                        txtQty.Focus();
                        return;
                    }
                    if (ddlRoute.SelectedIndex == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Select Route');", true);
                        ddlRoute.Focus();
                        return;
                    }
                    if (ddFreequency.SelectedIndex == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Please Select Frequency');", true);
                        ddFreequency.Focus();
                        return;
                    }
                }

                string str = "";
                if (rdoStop.Checked == true)
                {
                    int status;
                    string Status = "";
                    if (rdoStop.Text == "Stop")
                    {
                        status = 2;
                        Status = "Stopped";
                    }
                    else
                    {
                        status = 0;
                        Status = "Started";
                    }
                    str = "Insert into cpoe_medication_record(TransactionID,IndentNo,ItemID,ItemName,IssueDate,DATE,TIME,Dose,EntryBy,StatusType,Remark,Qty,status,Frequency,Route)values(";
                    str = str + " '" + ViewState["TID"].ToString() + "','" + IndentNo + "','" + ItemID + "','" + ItemName + "','" + IssueDate + "','" + MedicineDate + "',";
                    str = str + " '" + Util.GetDateTime(txttime.Text).ToString("HH:mm:ss") + "','" + txtDose.Text + "','" + ViewState["UserID"].ToString() + "','" + StatusType + "','" + Status + ": " + txtRemark.Text + "'," + Util.GetDecimal(txtQty.Text) + "," + status + ",'" + ddFreequency.SelectedItem.Text + "','" + ddlRoute.SelectedItem.Text + "')";
                }
                else
                {
                    str = "Insert into cpoe_medication_record(TransactionID,IndentNo,ItemID,ItemName,IssueDate,DATE,TIME,Dose,EntryBy,StatusType,Remark,Qty,Frequency,Route)values(";
                    str = str + " '" + ViewState["TID"].ToString() + "','" + IndentNo + "','" + ItemID + "','" + ItemName + "','" + IssueDate + "','" + MedicineDate + "',";
                    str = str + " '" + Util.GetDateTime(txttime.Text).ToString("HH:mm:ss") + "','" + txtDose.Text + "','" + ViewState["UserID"].ToString() + "','" + StatusType + "','" + txtRemark.Text + "'," + Util.GetDecimal(txtQty.Text) + ",'" + ddFreequency.SelectedItem.Text + "','" + ddlRoute.SelectedItem.Text + "')";
                }

                bool IsSave = StockReports.ExecuteDML(str);
                if (IsSave == true)
                {
                    lblMsg.Text = "Record Save Successfully";
                    BindMedicineGrid();
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

    protected void rptMedicine_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        try
        {
            if (e.Item.ItemIndex >= 0)
            {
                Repeater rpt = new Repeater();

                if (((Label)e.Item.FindControl("lblItemID")).Text.Substring(0, 3).ToString().ToUpper() == "OTH")
                {

                    string IsInHouse = ((Label)e.Item.FindControl("lblIsinhouseMed")).Text.ToString();


                    if (!Util.GetBoolean(IsInHouse))
                    {
                        ((Label)e.Item.FindControl("lblItemName")).ForeColor = System.Drawing.Color.Brown;

                        ((Label)e.Item.FindControl("lblItemName")).Style.Add("font-size", "15px");  
                    }
                    


                }
                if (((Label)e.Item.FindControl("lblStatus")).Text == "Completed")
                {
                    ((HtmlTableRow)e.Item.FindControl("trHead")).BgColor = "Yellow";
			((ImageButton)e.Item.FindControl("imbShow")).Visible = false;
                    DataTable dt = BindMedicineDetail(((Label)e.Item.FindControl("lblItemID")).Text, Util.GetString(((Label)e.Item.FindControl("lblIndentNo")).Text));
                    if (dt.Rows.Count > 0)
                    {
                       // ((ImageButton)e.Item.FindControl("imbShow")).AlternateText = "Hide";
                        //((ImageButton)e.Item.FindControl("imbShow")).ImageUrl = "~/Images/minus.png";
			
                        rpt = (Repeater)e.Item.FindControl("rptMedicineDetails");
                        rpt.DataSource = dt;
                        rpt.DataBind();
                        lblMsg.Text = string.Empty;

                        Control HeaderTemplate = rpt.Controls[0].Controls[0];
                        TextBox txtDose = HeaderTemplate.FindControl("txtDose") as TextBox;
                        txtDose.Text = ((Label)e.Item.FindControl("lblDose")).Text;
                        HtmlTableRow trMedDetail = HeaderTemplate.FindControl("trMedDetail") as HtmlTableRow;
                        trMedDetail.Visible = false;

                        for (int i = 0; i < rpt.Items.Count; i++)
                        {
                            ImageButton imbCancel = rpt.Items[i].FindControl("imbCancel") as ImageButton;
                            imbCancel.Visible = false;
                        }
                        if (Util.GetDecimal(((Label)e.Item.FindControl("lblRemainingQty")).Text) > 0)
                        {
                            ((ImageButton)e.Item.FindControl("imgEdit")).Visible = true;
                        }
                        else
                        {
                            ((ImageButton)e.Item.FindControl("imgEdit")).Visible = false;
                        }
                    }
                }
                if (((Label)e.Item.FindControl("lblStatus")).Text == "Running")
                {
                    ((HtmlTableRow)e.Item.FindControl("trHead")).BgColor = "white";
                    DateTime Date = Util.GetDateTime(((Label)e.Item.FindControl("lblIssueDate")).Text);
                    if (System.DateTime.Now.ToString("dd-MM-yyyy") == Date.ToString("dd-MM-yyyy"))
                    {
                        ((HtmlTableRow)e.Item.FindControl("trHead")).BgColor = "lightgreen";
                    }
                    DataTable dt = BindMedicineDetail(((Label)e.Item.FindControl("lblItemID")).Text, Util.GetString(((Label)e.Item.FindControl("lblIndentNo")).Text));
                    if (dt.Rows.Count > 0)
                    {
                        ((ImageButton)e.Item.FindControl("imbShow")).AlternateText = "Hide";
                        ((ImageButton)e.Item.FindControl("imbShow")).ImageUrl = "~/Images/minus.png";
                        rpt = (Repeater)e.Item.FindControl("rptMedicineDetails");
                        rpt.DataSource = dt;
                        rpt.DataBind();
                        lblMsg.Text = string.Empty;
                        if (Session["RoleID"].ToString() == "52")
                        {
                            Control HeaderTemplate = rpt.Controls[0].Controls[0];
                            HtmlTableRow trStatus = HeaderTemplate.FindControl("trStatus") as HtmlTableRow;
                            trStatus.Visible = true;
                            RadioButton rdoStop = HeaderTemplate.FindControl("rdoStop") as RadioButton;
                            rdoStop.Text = "Stop";
                        }
                        if (Util.GetDecimal(((Label)e.Item.FindControl("lblRemainingQty")).Text) > 0)
                        {
                            ((ImageButton)e.Item.FindControl("imgEdit")).Visible = true;
                        }
                        else
                        {
                            ((ImageButton)e.Item.FindControl("imgEdit")).Visible = false;
                        }
                    }
                }
                if (((Label)e.Item.FindControl("lblStatus")).Text == "Stopped")
                {
                    ((ImageButton)e.Item.FindControl("imbShow")).Visible = false;
                    ((HtmlTableRow)e.Item.FindControl("trHead")).BgColor = "red";
                    DataTable dt = BindMedicineDetail(((Label)e.Item.FindControl("lblItemID")).Text, Util.GetString(((Label)e.Item.FindControl("lblIndentNo")).Text));
                    if (dt.Rows.Count > 0)
                    {
                        ((ImageButton)e.Item.FindControl("imbShow")).AlternateText = "Hide";
                        ((ImageButton)e.Item.FindControl("imbShow")).ImageUrl = "~/Images/minus.png";
                        rpt = (Repeater)e.Item.FindControl("rptMedicineDetails");
                        rpt.DataSource = dt;
                        rpt.DataBind();
                        lblMsg.Text = string.Empty;

                        Control HeaderTemplate = rpt.Controls[0].Controls[0];
                        TextBox txtDose = HeaderTemplate.FindControl("txtDose") as TextBox;
                        txtDose.Text = ((Label)e.Item.FindControl("lblDose")).Text;
                        HtmlTableRow trMedDetail = HeaderTemplate.FindControl("trMedDetail") as HtmlTableRow;
                        trMedDetail.Visible = false;

                        if (Session["RoleID"].ToString() == "52")
                        {
                            HtmlTableRow trStatus = HeaderTemplate.FindControl("trStatus") as HtmlTableRow;
                            trStatus.Visible = true;
                            RadioButton rdoStop = HeaderTemplate.FindControl("rdoStop") as RadioButton;
                            rdoStop.Text = "Start";
                        }
                        for (int i = 0; i < rpt.Items.Count; i++)
                        {
                            ImageButton imbCancel = rpt.Items[i].FindControl("imbCancel") as ImageButton;
                            imbCancel.Visible = false;
                        }
                        if (Util.GetInt(((Label)e.Item.FindControl("lblRemainingQty")).Text) > 0)
                        {
                            ((ImageButton)e.Item.FindControl("imgEdit")).Visible = true;
                        }
                        else
                        {
                            ((ImageButton)e.Item.FindControl("imgEdit")).Visible = false;
                        }
                    }
                }
                if (((Label)e.Item.FindControl("lblStatus")).Text == "Not Issued")
                {
                    ((HtmlTableRow)e.Item.FindControl("trHead")).BgColor = "lightblue";
                    ((ImageButton)e.Item.FindControl("imbShow")).Visible = false;
                }
                if (((Label)e.Item.FindControl("lblIssueDate")).Text == DateTime.Now.ToString("dd-MM-yyyy"))
                {
                    ((Image)e.Item.FindControl("imbNewMedicine")).Visible = true;
                }
                if (Session["RoleID"].ToString() != "52")
                {
                    ((ImageButton)e.Item.FindControl("imgEdit")).Visible = false;
                }
                if (Util.GetString(ViewState["CanEditMedicationRecord"]) == "1")
                {
                    ((ImageButton)e.Item.FindControl("imgEdit")).Visible = true;
                }
                else
                {
                    ((ImageButton)e.Item.FindControl("imgEdit")).Visible = false;
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
            Repeater rpt = (Repeater)e.Item.Parent.Parent.FindControl("rptMedicineDetails");
            Control HeaderTemplate = rpt.Controls[0].Controls[0];
            TextBox textdate = HeaderTemplate.FindControl("txtDate") as TextBox;
            TextBox txttime = HeaderTemplate.FindControl("txttime") as TextBox;
            string Dose = ((Label)e.Item.Parent.Parent.FindControl("lblDose")).Text;
            TextBox txtDose = HeaderTemplate.FindControl("txtDose") as TextBox;
            txtDose.Text = Dose;
            textdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            textdate.Attributes.Add("readonly", "true");
            txttime.Text = DateTime.Now.ToString("hh:mm tt");
            DropDownList ddlRouteHos = HeaderTemplate.FindControl("ddlRouteHos") as DropDownList;
            ddlRouteHos.DataSource = AllGlobalFunction.Route;
            ddlRouteHos.DataBind();
            DropDownList ddFreHos = HeaderTemplate.FindControl("ddFreHos") as DropDownList;
            ddFreHos.DataSource = AllGlobalFunction.FreQuency;
            ddFreHos.DataBind();
            if (e.Item.ItemIndex >= 0)
            {
                if (Util.GetString(ViewState["CanEditMedicationRecord"]) == "0")
                {
                    ((ImageButton)e.Item.FindControl("imbCancel")).Visible = false;
                    HtmlTableRow trMedDetail = HeaderTemplate.FindControl("trMedDetail") as HtmlTableRow;
                    trMedDetail.Visible = false;
                    HtmlTableRow trStatus = HeaderTemplate.FindControl("trStatus") as HtmlTableRow;
                    trStatus.Visible = false;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void btnSaveDose_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtPopDose.Text.Trim() != "")
            {
                bool IsSave = StockReports.ExecuteDML("UPDATE orderset_Outsidemedication SET Dose='" + txtPopDose.Text + "',Timing='" + ddlPopTimes.SelectedItem.Text + "',Duration='" + Util.GetDateTime(txtPopDuration.Text).ToString("yyyy-MM-dd") + "',UpdatedBy='" + ViewState["UserID"].ToString() + "',UpdateDateTime=NOW() WHERE TransactionID='" + ViewState["TID"].ToString() + "' AND IndentNo='" + lblIndentNo.Text + "' AND MedicineID='" + lblPopItemID.Text + "'");
                if (IsSave)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Record Updated Successfully');", true);
                    BindMedicineGrid();
                }
                else
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "alert('Error...');", true);
            }
            else
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Enter Dose');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
    protected void ddldrugType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindMedicineGrid();
    }

    protected void chkOtherMedicne_CheckedChanged(object sender, EventArgs e)
    {
        if (chkOtherMedicne.Checked == true)
        {
            txtOtherMedicine.Focus();
            trOtherMedicine.Visible = true;

            chkInHouse.Visible = true;
        }
        else
        {

            chkInHouse.Visible = false;
            trOtherMedicine.Visible = false;
            txtOtherMedicine.Focus();
        }
    }

    protected void btnOtherMedicine_Click(object sender, EventArgs e)
    {
        if (txtOtherMedicine.Text == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key6", "alert('Enter Medicine Name');", true);
            txtOtherMedicine.Focus();
            return;
        }
        if (txtQtyIssued.Text=="")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key7", "alert('Enter Qty');", true);
            txtQtyIssued.Focus();
            return;
        }
        if(txtDose.Text=="")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key8", "alert('Enter Dose');", true);
            txtDose.Focus();
            return;
        }
        var duration = DateTime.Now.AddDays(Util.GetInt(ddlDuration.SelectedValue)).ToString("yyyy-MM-dd");
        var EntryID = StockReports.ExecuteScalar("Select Max(EntryID)+1 from orderset_Outsidemedication");
        if (EntryID == "")
            EntryID = Util.GetInt("1").ToString();
        
        StockReports.ExecuteDML("INSERT INTO orderset_Outsidemedication(EntryID,TransactionID,PatientID,MedicineID,MedicineName,ReqQty,Dose,Timing,Duration,Route,EntryBy,EntryDate,IsInHouseMedicine)VALUES('" + EntryID + "','" + ViewState["TID"].ToString() + "','" + ViewState["PID"] + "','OTH" + EntryID + "','" + txtOtherMedicine.Text + "','" + txtQtyIssued.Text + "','" + txtDose.Text + "','" + ddlTime.SelectedValue + "','" + duration + "','" + ddlRoute.SelectedValue + "','" + ViewState["UserID"] + "',NOW()," + chkInHouse.Checked + ")");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key5", "alert('Record Saved');", true);
        BindMedicineGrid();
        chkOtherMedicne.Checked = false;
        trOtherMedicine.Visible = false;

        chkInHouse.Visible = false;
        txtOtherMedicine.Text = "";
        txtQtyIssued.Text = "";
        txtDose.Text = "";
        ddlTime.SelectedIndex = -1;
        ddlDuration.SelectedIndex = -1;
        ddlRoute.SelectedIndex = -1;
    }
}