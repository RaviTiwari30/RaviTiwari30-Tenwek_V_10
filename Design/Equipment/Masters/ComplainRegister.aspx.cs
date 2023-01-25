using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Text;

public partial class Design_Equipment_Masters_EditAssetWoGRN : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            btnsave.Enabled = true;
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["IPAddress"] = All_LoadData.IpAddress().ToString();
            BindAssetType();
            BindSupplierType();
            ////BindLocation();
            BindAMCType();
            BindFloor();
            BindData();
            BindSolveByProcessBy();
            response_bind();

            ucPurDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucInstallationDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucWarrantyFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucWarrantyTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucFreeServiceFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucFreeServiceTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucServiceFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucServiceTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucLastServiceDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucNextServiceDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucAssignedOn.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            
        }

    

        Session["fileUpload1"] = null;

       // if (flServiceAgreement.HasFile)
       //     ViewState["FileName"] = flServiceAgreement.PostedFile;

        //flServiceAgreement. = ViewState["FileName"].ToString();
     
        lblMsg.Text = "";


        ucPurDate.Attributes.Add("readonly", "readonly");
        ucInstallationDate.Attributes.Add("readonly", "readonly");
        ucWarrantyFrom.Attributes.Add("readonly", "readonly");
        ucWarrantyTo.Attributes.Add("readonly", "readonly");
        ucFreeServiceFrom.Attributes.Add("readonly", "readonly");
        ucFreeServiceTo.Attributes.Add("readonly", "readonly");
        ucServiceFrom.Attributes.Add("readonly", "readonly");
        ucServiceTo.Attributes.Add("readonly", "readonly");
        ucLastServiceDate.Attributes.Add("readonly", "readonly");
        ucNextServiceDate.Attributes.Add("readonly", "readonly");
        ucAssignedOn.Attributes.Add("readonly", "readonly");
    }

    public void reply_bind(string TicketID)
    {
        DataTable dt = new DataTable();
        string s = "select DATE_FORMAT(e.REPLY_TIME,'%d-%b-%Y %h:%m:%s%p')AS REPLY_TIME,D.Name,Replace(E.DESCRIPTION,'\n','<br>') DESCRIPTION from f_ticket_reply e,employee_master d where e.USERID=D.Employee_ID and TicketID='" + TicketID + "'";
        dt = StockReports.GetDataTable(s);
        rpReply.DataSource = dt;
        rpReply.DataBind();
    }

    public void BindData()
    {
        string str = "SELECT am.AssetID,AssetName,AssetCode,AssetTypeID,SerialNo,ModelNo,TagNo,SupplierID,SupplierTypeID,TechnicalDtl, DATE_FORMAT(PurchaseDate, '%d-%b-%y ')PurchaseDate,DATE_FORMAT(InstallationDate, '%d-%b-%y ')InstallationDate,DATE_FORMAT(WarrantyFrom, '%d-%b-%y ')WarrantyFrom,DATE_FORMAT(WarrantyTo, '%d-%b-%y ')WarrantyTo,";
        str += "DATE_FORMAT(FreeServiceFrom, '%d-%b-%y ') FreeServiceFrom,DATE_FORMAT(FreeServiceTo, '%d-%b-%y ')FreeServiceTo,WarrantyTerms,AmcTypeID,ServiceSupplierID,DATE_FORMAT(ServiceDateFrom, '%d-%b-%y ')ServiceDateFrom,DATE_FORMAT(ServiceDateTo, '%d-%b-%y ')ServiceDateTo, DATE_FORMAT(LastServiceDate, '%d-%b-%y ')LastServiceDate,DATE_FORMAT(NextServiceDate, '%d-%b-%y ')NextServiceDate,LocationID,";
        str += "  FloorID,RoomID,AssignedTo,am.STATUS,Isactive,insertby,updateby,DATE_FORMAT(updatedate, '%d-%b-%y ')updatedate,Ipnumber,AgreementFileName,rp.Description,rp.TICKETID FROM (SELECT MAX(id)id FROM eq_MachineTicket_reply GROUP BY TicketID) rp1 INNER JOIN  eq_MachineTicket_reply rp ON rp.id=rp1.id INNER JOIN f_ticket tk ON rp.TICKETID=tk.TicketID INNER JOIN eq_asset_master am ON am.AssetID=rp.AssetID ";
        //if (txtsearchassetname.Text != "")
        //{
        //    str += " WHERE As     setname LIKE '" + txtsearchassetname.Text + "%'";
        //}
        //if (txtseatchAssetcode.Text != "")
        //{
        //    str += " WHERE AssetCode LIKE '" + txtseatchAssetcode.Text + "%'";
        //}

        //if (txtsearchsuppliername.Text != "")
        //{
        //    str += " WHERE   SupplierTypeID=(SELECT SupplierTypeID FROM f_vendormaster WHERE VendorName LIKE '" + txtsearchsuppliername.Text + "%' AND  isActive=1 )";
        //}
        //if (ddlserchassettype.SelectedIndex != 0)
        //{
        //    str += "  WHERE  AssetTypeID='" + ddlserchassettype.SelectedValue + "' ";
        //}
        DataTable dt = StockReports.GetDataTable(str);
        grdasset.DataSource = dt;
        grdasset.DataBind();
        //Panel1.Visible = false;
        //Panel2.Visible = true;
        //divtop.Attributes.Add("style", "height: 250px;");

    }

    private void BindSolveByProcessBy()
    {
        DataTable dt = StockReports.GetDataTable("SELECT em.Employee_ID,em.Name FROM f_login l INNER JOIN employee_master em ON em.Employee_ID=l.EmployeeID AND l.RoleID IN (133,144,229) AND isactive=1 GROUP BY l.EmployeeID ORDER BY em.name");
        ddlProcessBy.DataSource = dt;
        ddlProcessBy.DataTextField = "Name";
        ddlProcessBy.DataValueField = "Employee_ID";
        ddlProcessBy.DataBind();
        ddlProcessBy.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlProcessBy.SelectedIndex = 0;

        ddlSolvedBy.DataSource = dt;
        ddlSolvedBy.DataTextField = "Name";
        ddlSolvedBy.DataValueField = "Employee_ID";
        ddlSolvedBy.DataBind();
        ddlSolvedBy.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlSolvedBy.SelectedIndex = 0;
    }

    private void BindFloor()
    {
        DataTable dt = StockReports.GetDataTable("select FloorName,FloorID FROM eq_floor_master where isActive=1 order by FloorName");
        ddlFloor.DataSource = dt;
        ddlFloor.DataTextField = "FloorName";
        ddlFloor.DataValueField = "FloorID";
        ddlFloor.DataBind();
        ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlFloor.SelectedIndex = 0;
    }
    
    //public void LoadData()
    //{
    //    string str = "SELECT AssetID,AssetName,AssetCode,AssetTypeID,SerialNo,ModelNo,TagNo,SuppierID,SupplierTypeID,TechnicalDtl, DATE_FORMAT(PurchaseDate, '%d-%b-%y ')PurchaseDate,DATE_FORMAT(InstallationDate, '%d-%b-%y ')InstallationDate,DATE_FORMAT(WarrantyFrom, '%d-%b-%y ')WarrantyFrom,DATE_FORMAT(WarrantyTo, '%d-%b-%y ')WarrantyTo,";
    //    str += "DATE_FORMAT(FreeServiceFrom, '%d-%b-%y ') FreeServiceFrom,DATE_FORMAT(FreeServiceTo, '%d-%b-%y ')FreeServiceTo,WarrantyTerms,AmcTypeID,ServiceSupplierID,DATE_FORMAT(ServiceDateFrom, '%d-%b-%y ')ServiceDateFrom,DATE_FORMAT(ServiceDateTo, '%d-%b-%y ')ServiceDateTo, DATE_FORMAT(LastServiceDate, '%d-%b-%y ')LastServiceDate,DATE_FORMAT(NextServiceDate, '%d-%b-%y ')NextServiceDate,LocationID,";
    //    str += "  FloorID,RoomID,AssignedTo,STATUS,Isactive,insertby,updateby,DATE_FORMAT(updatedate, '%d-%b-%y ')updatedate,Ipnumber,AgreementFileName FROM eq_asset_master";
    //    if (txtsearchassetname.Text != "")
    //    {
    //        str += " WHERE Assetname LIKE '" + txtsearchassetname.Text + "%'";
    //    }
    //    if (txtseatchAssetcode.Text != "")
    //    {
    //        str += " WHERE AssetCode LIKE '" + txtseatchAssetcode.Text + "%'";
    //    }

    //    if (txtsearchsuppliername.Text != "")
    //    {
    //        str += " WHERE   SupplierTypeID=(SELECT SupplierTypeID FROM f_vendormaster WHERE VendorName LIKE '" + txtsearchsuppliername.Text + "%' AND  isActive=1 )";
    //    }
    //    if (ddlserchassettype.SelectedIndex != 0)
    //    {
    //        str += "  WHERE  AssetTypeID='" + ddlserchassettype.SelectedValue + "' ";
    //    }
    //    DataTable dt = StockReports.GetDataTable(str);
    //    grdasset.DataSource= dt;
    //    grdasset.DataBind();
    //    Panel1.Visible = false;
    //    Panel2.Visible = true;
    //    //divtop.Attributes.Add("style", "height: 250px;");

    //}
    protected void grdasset_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        DivGrid.Visible = false;
        string AssetID = Util.GetString(e.CommandArgument).Split('#')[0];
        string TicketID = Util.GetString(e.CommandArgument).Split('#')[1];
        ViewState["AssetID"] = AssetID;
        if (e.CommandName == "EditAT")
        {
            grdasset.DataSource = null;
            grdasset.DataBind();
           // Panel2.Visible = false;
           
               // divtop.Attributes.Add("style", "height: 0px;");
            Panel1.Visible = true;
            
            DataTable dt = StockReports.GetDataTable("SELECT * FROM eq_asset_master WHERE AssetID='" + AssetID + "' ");
            if (dt != null && dt.Rows.Count > 0)
            {
                lblAssetID.Text = AssetID;
                txtAssetName.Text = dt.Rows[0]["AssetName"].ToString();
                txtAssetCode.Text = dt.Rows[0]["AssetCode"].ToString();
                txtSerialNo.Text = dt.Rows[0]["SerialNo"].ToString();
                txtModelNo.Text = dt.Rows[0]["ModelNo"].ToString();
                txtTagNo.Text = dt.Rows[0]["TagNo"].ToString();
                lblMachineid.Text = dt.Rows[0]["AssetID"].ToString();
                
                ddlAssetType.SelectedIndex = ddlAssetType.Items.IndexOf(ddlAssetType.Items.FindByValue(dt.Rows[0]["AssetTypeID"].ToString()));
                ddlAmcType.SelectedIndex = ddlAmcType.Items.IndexOf(ddlAmcType.Items.FindByValue(dt.Rows[0]["AMCtypeID"].ToString()));
                // ravi do below for tyhe same
                
                ddlSupplierType.SelectedIndex = ddlSupplierType.Items.IndexOf(ddlSupplierType.Items.FindByValue(dt.Rows[0]["SupplierTypeID"].ToString()));
                BindSupplierList(dt.Rows[0]["SupplierTypeID"].ToString());
                ddlSupplier.SelectedIndex = ddlSupplier.Items.IndexOf(ddlSupplier.Items.FindByValue(dt.Rows[0]["SupplierID"].ToString()));
                ddlSupplierService.SelectedIndex = ddlSupplierService.Items.IndexOf(ddlSupplierService.Items.FindByValue(dt.Rows[0]["SupplierID"].ToString()));
                txtTechnical.Text = dt.Rows[0]["TechnicalDtl"].ToString();
                txtWarrantyCondition.Text = dt.Rows[0]["WarrantyTerms"].ToString();
                ucPurDate.Text = Util.GetDateTime(dt.Rows[0]["PurchaseDate"]).ToString("dd-MMM-yyyy");
                ucInstallationDate.Text = Util.GetDateTime(dt.Rows[0]["InstallationDate"]).ToString("dd-MMM-yyyy");
                ucWarrantyFrom.Text = Util.GetDateTime(dt.Rows[0]["WarrantyFrom"]).ToString("dd-MMM-yyyy");
                ucWarrantyTo.Text = Util.GetDateTime(dt.Rows[0]["WarrantyTo"]).ToString("dd-MMM-yyyy");
                ucFreeServiceFrom.Text = Util.GetDateTime(dt.Rows[0]["FreeServiceFrom"]).ToString("dd-MMM-yyyy");
                ucFreeServiceTo.Text = Util.GetDateTime(dt.Rows[0]["FreeServiceTo"]).ToString("dd-MMM-yyyy");
                ucServiceFrom.Text = Util.GetDateTime(dt.Rows[0]["ServiceDateFrom"]).ToString("dd-MMM-yyyy");
                ucServiceTo.Text = Util.GetDateTime(dt.Rows[0]["ServiceDateTo"]).ToString("dd-MMM-yyyy");
                ucLastServiceDate.Text = Util.GetDateTime(dt.Rows[0]["LastServiceDate"]).ToString("dd-MMM-yyyy");
                ucNextServiceDate.Text = Util.GetDateTime(dt.Rows[0]["NextServiceDate"]).ToString("dd-MMM-yyyy");

                ddlLocation.SelectedValue = dt.Rows[0]["LocationID"].ToString();
                //BindFloor(dt.Rows[0]["LocationID"].ToString());
                BindLocation(dt.Rows[0]["FloorID"].ToString());
                // do theb below line in all codes  gaurav to ravi 26092014)
                ddlFloor.SelectedIndex = ddlFloor.Items.IndexOf(ddlFloor.Items.FindByValue(dt.Rows[0]["FloorID"].ToString()));
                BindRoom(dt.Rows[0]["FloorID"].ToString(), dt.Rows[0]["LocationID"].ToString());
                ddlRoom.SelectedIndex = ddlRoom.Items.IndexOf(ddlRoom.Items.FindByValue(dt.Rows[0]["RoomID"].ToString()));
                txtAssignedTo.Text = dt.Rows[0]["AssignedTo"].ToString();
                ucAssignedOn.Text = Util.GetDateTime(dt.Rows[0]["AssigneDate"]).ToString("dd-MMM-yyyy");
            }

            //string select = "SELECT tk.Employee_ID InformByID,(select Name from Employee_master where Employee_id=tk.Employee_id)InformByName,TicketID TicketNo,RoleID,ErrorDeptID,closeby,Date_Format(CloseDate,'%d %b %Y %h %i %p')CloseDate,Department,FLOOR,EmployeeID,Attachment,DATE_FORMAT(ProblemStartTime,'%d %b %Y %h %i %p')ProblemStartTime,Description,NAME,Errortype,(SELECT Description FROM eq_machineticket_reply rp WHERE id=(SELECT MAX(id) FROM eq_machineticket_reply WHERE TicketID=" + TicketID + "))Description,SELECT ProcessBy FROM eq_machineticket_reply rp WHERE id=(SELECT MAX(id) FROM eq_machineticket_reply WHERE TicketID=" + TicketID + "))ProcessBy,SELECT BillAttachment FROM eq_machineticket_reply rp WHERE id=(SELECT MAX(id) FROM eq_machineticket_reply WHERE TicketID=" + TicketID + "))BillAttachment,SELECT ImageAttachment FROM eq_machineticket_reply rp WHERE id=(SELECT MAX(id) FROM eq_machineticket_reply WHERE TicketID=" + TicketID + "))ImageAttachment,SELECT SolvedBy FROM eq_machineticket_reply rp WHERE id=(SELECT MAX(id) FROM eq_machineticket_reply WHERE TicketID=" + TicketID + "))SolvedBy,PeopleEffeced,Priority,DATE_FORMAT(Date,'%d %b %Y %h %i %p')DATE,(CASE WHEN STATUS = '0' THEN 'Open' WHEN STATUS = '1' THEN 'Process' WHEN STATUS = '2' THEN 'Close' ELSE 'STOP' END) STATUS,DATE_FORMAT(LastUpdate,'%d %b %Y')LastUpdate FROM f_ticket tk INNER JOIN employee_master emp ON tk.EmployeeID=emp.Employee_ID WHERE Active=1  AND TicketID=" + TicketID + " ";
            string select = " SELECT tk.EmployeeID InformByID,(SELECT NAME FROM Employee_master WHERE Employee_id=tk.Employeeid)InformByName,tk.TicketID TicketNo,tk.RoleID,";
                   select+="  tk.ErrorDeptID,tk.CloseBy,DATE_FORMAT(tk.CloseDate,'%d %b %Y %h:%i %p')CloseDate,tk.Department,tk.FLOOR,tk.EmployeeID,tk.Attachment, ";
                   select+="  DATE_FORMAT(tk.ProblemStartTime,'%d %b %Y %h %i %p')ProblemStartTime,(SELECT NAME FROM Employee_master WHERE Employee_id=tk.Employeeid)NAME,tk.Errortype,eqm.Description,eqm.ProcessBy,eqm.BillAttachment, ";
                   select+="  eqm.ImageAttachment,eqm.SolvedBy,tk.PeopleEffeced,tk.Priority,DATE_FORMAT(tk.DATE,'%d %b %Y %h %i %p')DATE,(CASE WHEN tk.STATUS = '0' THEN 'Open' ";
                   select+="  WHEN tk.STATUS = '1' THEN 'Process' WHEN tk.STATUS = '2' THEN 'Close' ELSE 'STOP' END)STATUS,DATE_FORMAT(tk.LastUpdate,'%d %b %Y')LastUpdate, ";
                   select+="  eqm.Solve,eqm.CompDetail,eqm.PersonDetail,eqm.BillAmount,eqm.WorkDetail,eqm.PartChange,eqm.partDetail,eqm.PartCost,eqm.Comments ";
                   select+="  FROM f_ticket tk ";
                   select+="  INNER JOIN (SELECT e.TicketID,e.id,e.DESCRIPTION,e.ProcessBy,e.BillAttachment,e.ImageAttachment,e.SolvedBy, ";
                   select+="  e.Solve,e.CompDetail,e.PersonDetail,e.BillAmount,e.WorkDetail,e.PartChange,e.partDetail,e.PartCost,e.Comments ";
                   select += "  FROM eq_MachineTicket_reply e WHERE id=(SELECT MAX(ID) FROM eq_MachineTicket_reply WHERE TicketID=" + TicketID + "))eqm ";
                   select += " ON eqm.TicketID=tk.TicketID WHERE tk.Active=1 ";
            DataTable dt1 = StockReports.GetDataTable(select);

            reply_bind(TicketID);
            lblname.Text = dt1.Rows[0]["NAME"].ToString();
            ViewState["Role"] = dt1.Rows[0]["RoleID"].ToString();
            ViewState["ErrorDeptID"] = dt1.Rows[0]["ErrorDeptID"].ToString();

            lblstatus1.Text = dt1.Rows[0]["Status"].ToString();            
            //lblstatus.Text = dt1.Rows[0]["Status "].ToString();
            lblpriority.Text = dt1.Rows[0]["Priority"].ToString();
            lbldept.Text = dt1.Rows[0]["Department"].ToString();
            lblfloor.Text = dt1.Rows[0]["FLOOR"].ToString();
            ViewState["Close"] = dt1.Rows[0]["closeby"].ToString();
            ViewState["CloseDate"] = dt1.Rows[0]["CloseDate"].ToString();


            lblticketid.Text = dt1.Rows[0]["TicketNo"].ToString();
            lbldate.Text = dt1.Rows[0]["Date"].ToString();
            lbldescription.Text = dt1.Rows[0]["Description"].ToString();
            lblProblemStartTime.Text = dt1.Rows[0]["ProblemStartTime"].ToString();
            lblInformedByID.Text = dt1.Rows[0]["InformByID"].ToString();
            txtInformedBy.Text = dt1.Rows[0]["InformByName"].ToString();
            ddlProcessBy.SelectedIndex = ddlProcessBy.Items.IndexOf(ddlProcessBy.Items.FindByValue(dt1.Rows[0]["ProcessBy"].ToString()));
            ddlSolvedBy.SelectedIndex = ddlSolvedBy.Items.IndexOf(ddlSolvedBy.Items.FindByValue(dt1.Rows[0]["SolvedBy"].ToString()));

            if (dt1.Rows[0]["BillAttachment"].ToString() != "")
            {
                lnkBill.Visible = true;

                lblBillAttachment.Text = lblticketid.Text+ lblAssetID.Text + dt1.Rows[0]["BillAttachment"].ToString().Substring(dt1.Rows[0]["BillAttachment"].ToString().LastIndexOf("."));
            }

            if (dt1.Rows[0]["ImageAttachment"].ToString() != "")
            {
                lnkPartImage.Visible = true;

                lblImageAttachment.Text = "Part" + lblticketid.Text + lblAssetID.Text + dt1.Rows[0]["ImageAttachment"].ToString().Substring(dt1.Rows[0]["ImageAttachment"].ToString().LastIndexOf("."));
            }

           // lblBillAttachment.Text = dt1.Rows[0]["BillAttachment"].ToString();
           // lblImageAttachment.Text = dt1.Rows[0]["ImageAttachment"].ToString();
            if (dt1.Rows[0]["Solve"].ToString() != "")
            {
                ddlSolve.SelectedIndex = ddlSolve.Items.IndexOf(ddlSolve.Items.FindByText(dt1.Rows[0]["Solve"].ToString()));
                if (dt1.Rows[0]["Solve"].ToString() == "InHouse")
                {                     
                    trOutSource.Visible = false;
                    trOutSource2.Visible = false;
                }
                else if (dt1.Rows[0]["Solve"].ToString() == "OutSource")
                {
                    trOutSource.Visible = true;
                    trOutSource2.Visible = true;
                }
            }
            if (dt1.Rows[0]["PartChange"].ToString() != "")
            {
                ddlPartChange.SelectedIndex = ddlPartChange.Items.IndexOf(ddlPartChange.Items.FindByText(dt1.Rows[0]["PartChange"].ToString()));
                if (dt1.Rows[0]["PartChange"].ToString() == "YES")
                {
                    divPartDetail.Visible = true;
                    txtPartDetails.Visible = true;
                    trPart2.Visible = true;
                }
                else if(dt1.Rows[0]["PartChange"].ToString() == "NO")
                {
                    divPartDetail.Visible = false;
                    txtPartDetails.Visible = false;
                    trPart2.Visible = false;
                }
            }
            txtCompDetails.Text = dt1.Rows[0]["CompDetail"].ToString();
            txtpersonDetail.Text = dt1.Rows[0]["PersonDetail"].ToString();
            txtamt.Text = dt1.Rows[0]["BillAmount"].ToString();
            txtwrkDetails.Text = dt1.Rows[0]["WorkDetail"].ToString();           
            txtPartDetails.Text = dt1.Rows[0]["partDetail"].ToString();
            txtCost.Text = dt1.Rows[0]["PartCost"].ToString();
            txtComment.Text = dt1.Rows[0]["Comments"].ToString();

            if (dt1.Rows[0]["Attachment"].ToString() != "")
            {
                lnkbtnattachment.Visible = true;

                lblattachment.Text = lblticketid.Text + "" + dt1.Rows[0]["Attachment"].ToString().Substring(dt1.Rows[0]["Attachment"].ToString().LastIndexOf("."));
            }


            lblerrortype.Text = dt1.Rows[0]["Errortype"].ToString();

           // ddlPriority.Text = lblpriority.Text;
            ddlaction.SelectedIndex = ddlaction.Items.IndexOf(ddlaction.Items.FindByText(lblstatus1.Text));


            if (lblstatus1.Text.Trim() == "Close")
            {
                btnReply.Enabled = false;
                btnUpdate.Enabled = false;
            }
            if (dt1.Rows[0]["Status"].ToString() == "Close")
            {
                string select1 = "select Name from employee_master where Employee_ID='" + ViewState["Close"] + "'";
                DataTable dt11 = StockReports.GetDataTable(select1);

                if (dt11 != null && dt11.Rows.Count > 0)
                {
                    lblClose.Text = dt11.Rows[0]["Name"].ToString() + "  " + ViewState["CloseDate"].ToString();
                    lbl1.Visible = true;
                }
            }
        }

        //if (e.CommandName == "AView")
        //{

        //    string TId = e.CommandArgument.ToString().Split('$')[0];
        //    ViewState["AssetID"] = TId;
        //    string FileAppName = e.CommandArgument.ToString().Split('$')[1];
        // //   string lblFName = ((Label)grdasset.FindControl("lblFileName")).Text;
        //    string url = "SELECT fileUrl FROM eq_asset_master WHERE AssetID='" + ViewState["AssetID"] + "'";
        //  url=  StockReports.ExecuteScalar(url);
        //    filesearch(url);
        //}
    }


    private void BindAssetType()
    {
        DataTable dt = StockReports.GetDataTable("Select AssetTypeName,AssetTypeID from eq_assettype_master where isActive=1 order by AssetTypeName");
        ddlAssetType.DataSource = dt;
        ddlAssetType.DataTextField = "AssetTypeName";
        ddlAssetType.DataValueField = "AssetTypeID";
        ddlAssetType.DataBind();

        ddlAssetType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlAssetType.SelectedIndex = 0;

        //ddlserchassettype.DataSource = dt;
        //ddlserchassettype.DataTextField = "AssetTypeName";
        //ddlserchassettype.DataValueField = "AssetTypeID";
        //ddlserchassettype.DataBind();

        //ddlserchassettype.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        //ddlserchassettype.SelectedIndex = 0;

    }
    private void BindAMCType()
    {
        DataTable dt = StockReports.GetDataTable("Select AMCtypeName,AMCtypeID from eq_amctype_master where isActive=1 order by AMCtypeName");
        ddlAmcType.DataSource = dt;
        ddlAmcType.DataTextField = "AMCtypeName";
        ddlAmcType.DataValueField = "AMCtypeID";
        ddlAmcType.DataBind();

        ddlAmcType.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlAmcType.SelectedIndex = 0;

    }
   
    private void BindSupplierType()
    {
         DataTable dt = StockReports.GetDataTable("Select SupplierTypeName,SupplierTypeID from eq_SupplierType_master where isActive=1 order by SupplierTypeName");
        ddlSupplierType.DataSource = dt;
       
        ddlSupplierType.DataTextField = "SupplierTypeName";
        ddlSupplierType.DataValueField = "SupplierTypeID";
        ddlSupplierType.DataBind();

        ddlSupplierType.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlSupplierType.SelectedIndex = 0;


        ddlSupplierService.DataSource = dt;
        ddlSupplierService.DataTextField = "SupplierTypeName";
        ddlSupplierService.DataValueField = "SupplierTypeID";
        ddlSupplierService.DataBind();
        //BindSupplierList();
    }
    private void BindSupplierList(string SupplierTypeID)
    {


       // string str = "Select SupplierName,SupplierID from eq_Supplier_master where isActive=1";
        string str = "SELECT VendorName,SupplierTypeID FROM f_servicetypemaster WHERE isActive=1 ";
        //if (ddlSupplierType.SelectedValue != "SELECT")
        str += " AND SupplierTypeID = '" + SupplierTypeID + "' ";

       // str += " order by SupplierName";
        str += "ORDER BY VendorName";

        DataTable dt = StockReports.GetDataTable(str);
        ddlSupplier.DataSource = dt;
        ddlSupplier.DataTextField = "VendorName";
        ddlSupplier.DataValueField = "SupplierTypeID";
        ddlSupplier.DataBind();

        ddlSupplier.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlSupplier.SelectedIndex = 0;
        ddlSupplierService.DataSource = dt;
        ddlSupplierService.DataTextField = "VendorName";
        ddlSupplierService.DataValueField = "SupplierTypeID";
        ddlSupplierService.DataBind();
    }
    //private void BindLocation()
    //{
    //    DataTable dt = StockReports.GetDataTable("SELECT locationid,locationname FROM eq_location_master WHERE isactive=1 ORDER BY locationname ASC");
    //    ddlLocation.DataSource = dt;
    //    ddlLocation.DataTextField = "locationname";
    //    ddlLocation.DataValueField = "locationid";
    //    ddlLocation.DataBind();
    //    ddlLocation.Items.Insert(0, new ListItem("SELECT", "SELECT"));
    //    ddlLocation.SelectedIndex = 0;
    //    BindFloor(ddlLocation.SelectedValue);

    //}    

    private void BindFloor(string loction)
    {
        DataTable dt = StockReports.GetDataTable("SELECT floorid,floorname FROM eq_floor_master WHERE isactive=1 AND locationid='" + loction + "' ORDER BY floorname ASC");
        ddlFloor.DataSource = dt;
        ddlFloor.DataTextField = "floorname";
        ddlFloor.DataValueField = "floorid";
        ddlFloor.DataBind();
        ddlFloor.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlFloor.SelectedIndex = 0;
        BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
    }
    private void BindLocation(string FlooID)
    {
        DataTable dt = StockReports.GetDataTable("Select LocationName,LocationId from eq_location_master where IsActive=1 AND FloorID='" + FlooID + "' Order BY LocationName ASC");
        ddlLocation.DataSource = dt;
        ddlLocation.DataTextField = "LocationName";
        ddlLocation.DataValueField = "LocationID";
        ddlLocation.DataBind();
        ddlLocation.SelectedIndex = 0;
        BindRoom(ddlLocation.SelectedValue, ddlFloor.SelectedValue);
    }
    private void BindRoom(string floor, string location)
    {
        DataTable dt = StockReports.GetDataTable("SELECT roomid,roomname FROM eq_room_master WHERE floorid='" + floor + "' AND locationid='" + location + "' AND isactive=1 ORDER BY roomname ASC ");
        ddlRoom.DataSource = dt;
        ddlRoom.DataTextField = "roomname";
        ddlRoom.DataValueField = "roomid";
        ddlRoom.DataBind();

        ddlRoom.Items.Insert(0, new ListItem("SELECT", "SELECT"));
        ddlRoom.SelectedIndex = 0;
    }
    //private bool CheckValidation()
    //{
    //    try
    //    {
           
    //        if (ddlAssetType.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select Asset Type..";
    //            ddlAssetType.Focus();
    //            return false;
    //        }

    //        if (fileUpload1.PostedFile.ContentLength == 0)
    //        {
    //            lblMsg.Visible = true;
    //            lblMsg.Text = "Please Browse File ..";
    //            return false ;
    //        }

    //        if (txtAssetName.Text.Trim() == string.Empty)
    //        {
    //            lblMsg.Text = "Select Asset Name..";
    //            txtAssetName.Focus();
    //            return false;
    //        }

    //        if (txtSerialNo.Text.Trim() == string.Empty)
    //        {
    //            lblMsg.Text = "Select Serial Number..";
    //            txtSerialNo.Focus();
    //            return false;
    //        }

    //        if (txtAssetCode.Text.Trim() == string.Empty)
    //        {
    //            lblMsg.Text = "Select Asset Code..";
    //            txtAssetCode.Focus();
    //            return false;
    //        }

    //        if (ddlSupplierType.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select Supplier Type..";
    //            ddlSupplierType.Focus();
    //            return false;
    //        }

    //        if (ddlSupplier.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select Supplier...";
    //            ddlSupplier.Focus();
    //            return false;
    //        }

    //        //if (ucFreeServiceFrom.IsLessThanDate(Util.GetDateTime(ucPurDate.GetDateForDataBase())))
    //        //{
    //        //    lblMsg.Text = "Start of Free Service Date cannot be less then Purchase Date...";
    //        //    ucFreeServiceFrom.Focus();
    //        //    return false;
    //        //}

    //        //if (ucWarrantyFrom.IsLessThanDate(Util.GetDateTime(ucPurDate.GetDateForDataBase())))
    //        //{
    //        //    lblMsg.Text = "Start of Warranty Date cannot be less then Purchase Date...";
    //        //    ucWarrantyFrom.Focus();
    //        //    return false;
    //        //}

    //        if (ddlAmcType.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select AMC Type..";
    //            ddlAmcType.Focus();
    //            return false;
    //        }

    //        if (ddlSupplierService.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select Service Supplier Name..";
    //            ddlSupplierService.Focus();
    //            return false;
    //        }

    //        if (ddlLocation.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select Location..";
    //            ddlLocation.Focus();
    //            return false;
    //        }

    //        if (ddlFloor.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select Floor..";
    //            ddlFloor.Focus();
    //            return false;
    //        }

    //        if (ddlRoom.SelectedValue.ToUpper() == "SELECT")
    //        {
    //            lblMsg.Text = "Select Room..";
    //            ddlRoom.Focus();
    //            return false;
    //        }

    //        if (txtAssignedTo.Text.Trim() == string.Empty)
    //        {
    //            lblMsg.Text = "Provide Name of the person whom Asset is assigned to..";
    //            txtAssignedTo.Focus();
    //            return false;
    //        }
            
    //        //if (ucAssignedOn.GetDateForDataBase() == string.Empty)
    //        //{
    //        //    lblMsg.Text = "Provide the Date when asset is assigned on...";
    //        //    ucAssignedOn.Focus();
    //        //    return false;
    //        //}

    //        string IsExist = "", str="";
    //        //str = "Select AssetID from eq_asset_master where AssetTypeID=" + ddlAssetType.SelectedValue + " and AssetName ='" + txtAssetName.Text.Trim() + "'";
    //        //IsExist = StockReports.ExecuteScalar(str);

    //        //if (IsExist != "")
    //        //{
    //        //    lblMsg.Text = "Asset Name already exists in this Asset Type...";
    //        //    return false;
    //        //}

    //        //IsExist = "";
    //        //str = "Select AssetID from eq_asset_master where AssetCode ='" + txtAssetCode.Text.Trim() + "'";
    //        //IsExist = StockReports.ExecuteScalar(str);

    //        //if (IsExist != "")
    //        //{
    //        //    lblMsg.Text = "Asset Code already exists...";
    //        //    return false;
    //        //}


    //        return true;
    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog cl = new ClassLog();
    //        cl.errLog(ex);
    //        return false;
    //    }
    //}

    protected void ddlSupplierType_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindSupplierList();
    }
    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindFloor(ddlLocation.SelectedValue);
        BindRoom(ddlLocation.SelectedValue, ddlFloor.SelectedValue);
    }
    protected void ddlFloor_SelectedIndexChanged(object sender, EventArgs e)
    {
        //BindRoom(ddlFloor.SelectedValue, ddlLocation.SelectedValue);
        BindLocation(ddlFloor.SelectedValue);
    }
    //protected void btnsave_Click(object sender, EventArgs e)
    // {
    //    // string strrrr = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
    //    bool IsValid = CheckValidation();
    //    if (!IsValid)
    //        return;

    //    MySqlConnection conn = Util.GetMySqlCon();
    //    conn.Open();
    //    MySqlTransaction tnx = conn.BeginTransaction();

    //    string str = "";
        
      
    //    if (btnsave.Text  == "UPDATE")
    //    {

    //        try
    //        {
    //            fileupload();
    //            str = "";
    //            str += "UPDATE  eq_asset_master set AssetName ='" + txtAssetName.Text.Trim() + "',AssetCode='" + txtAssetCode.Text.Trim() + "',AssetTypeID='" + ddlAssetType.SelectedValue + "',";
    //            str += "SerialNo='" + txtSerialNo.Text.Trim() + "',ModelNo='" + txtModelNo.Text.Trim() + "',TagNo='" + txtTagNo.Text.Trim() + "',SuppierID='" + ddlSupplier.SelectedValue + "',SupplierTypeID='" + ddlSupplierType.SelectedValue + "',TechnicalDtl='" + txtTechnical.Text.Trim() + "',";
    //            str += "PurchaseDate='" + Util.GetDateTime(ucPurDate.Text).ToString("yyyy-MM-dd") + "',InstallationDate='" + Util.GetDateTime(ucInstallationDate.Text).ToString("yyyy-MM-dd") + "',WarrantyFrom='" + Util.GetDateTime(ucWarrantyFrom.Text).ToString("yyyy-MM-dd") + "',WarrantyTo='" + Util.GetDateTime(ucWarrantyTo.Text).ToString("yyyy-MM-dd") + "',";
    //            str += "FreeServiceFrom='" + Util.GetDateTime(ucFreeServiceFrom.Text).ToString("yyyy-MM-dd") + "',FreeServiceTo='" + Util.GetDateTime(ucFreeServiceTo.Text).ToString("yyyy-MM-dd") + "',WarrantyTerms='" + txtWarrantyCondition.Text.Trim() + "',AmcTypeID='" + ddlAmcType.SelectedValue + "',";
    //            str += "ServiceSupplierID='" + ddlSupplierService.SelectedValue + "',ServiceDateFrom='" + Util.GetDateTime(ucServiceFrom.Text).ToString("yyyy-MM-dd") + "',ServiceDateTo='" + Util.GetDateTime(ucServiceTo.Text).ToString("yyyy-MM-dd") + "',";
    //            str += "LastServiceDate='" + Util.GetDateTime(ucLastServiceDate.Text).ToString("yyyy-MM-dd") + "',NextServiceDate='" + Util.GetDateTime(ucNextServiceDate.Text).ToString("yyyy-MM-dd") + "',LocationID='" + ddlLocation.SelectedValue + "',";
    //            str += "FloorID='" + ddlFloor.SelectedValue + "',RoomID='" + ddlRoom.SelectedValue + "',AssignedTo='" + txtAssignedTo.Text.Trim() + "',STATUS='" + ddlStatus.SelectedValue + "',Isactive='" + ddlStatus.SelectedValue + "',";
    //            str += "updateby='" + ViewState["ID"].ToString() + "',updatedate='" + Util.GetDateTime(System.DateTime.Now).ToString("yyyy-MM-dd") + "',Ipnumber='" + ViewState["IPAddress"].ToString() + "'";
    //            if (fileUpload1.PostedFile.ContentLength != 0)
    //        {
    //            upld = upld.Replace("\\", "''");
    //            upld = upld.Replace("'", "\\");

    //            str += ",AgreementFileName= '" + fileUpload1.FileName + "',FileUrl='" + upld + "'";
    //            }
    //            str += " where AssetID='" + lblMachineid.Text + "' ";
    //            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
               
              

    //            tnx.Commit();
    //            conn.Close();
    //            conn.Dispose();

    //            lblMsg.Text = "Record Saved";
    //            btnsave.Text = "UPDATE";
    //            LoadData();

    //        }
    //        catch (Exception ex)
    //        {
    //            tnx.Rollback();
    //            conn.Close();
    //            conn.Dispose();

    //            ClassLog cl = new ClassLog();
    //            cl.errLog(ex);
    //            lblMsg.Text = ex.Message;
    //        }
    //    }        
    //}
    protected void btnclear_Click(object sender, EventArgs e)
    {  
        btnsave.Text = "UPDATE";
        //LoadData();
    }
    //protected void btnsearch_Click(object sender, EventArgs e)
    //{
    //    LoadData();
    //}

    //public void fileupload()
    //{

    //    try
    //    {
    //        string File, path = "";
    //        upld = "";
         
    //        string Ext = fileUpload1.PostedFile.FileName.ToString().Split('.')[1];
    //        DirectoryInfo folder = new DirectoryInfo(@"C:\MachineServiceAgreement");

    //        if (folder.Exists)
    //        {
    //            DirectoryInfo[] SubFolder = folder.GetDirectories(ViewState["AssetID"].ToString());

    //            if (SubFolder.Length > 0)
    //            {
    //                foreach (DirectoryInfo Sub in SubFolder)
    //                {
    //                    if (Sub.Name == ViewState["AssetID"].ToString())
    //                    {
    //                        FileInfo[] files = Sub.GetFiles();
    //                        foreach (FileInfo fl in files)
    //                        {
    //                            string fil = fl.Name;
    //                            if (fil == fileUpload1.PostedFile.FileName.ToString())
    //                            {
    //                                lblMsg.Visible = true;
    //                                lblMsg.Text = "File Already Exist..";
    //                                return;
    //                            }

    //                        }
    //                        string doc = fileUpload1.FileName;
    //                        string IpFolder = Sub.Name;
    //                        string Ip = Path.Combine(@"C:\MachineServiceAgreement", IpFolder);
    //                        upld = Path.Combine(Ip, doc);
    //                        fileUpload1.PostedFile.SaveAs(upld);
    //                        lblMsg.Visible = true;
    //                        lblMsg.Text = "File Uploaded Sucessfully..";

    //                        break;
    //                    }
    //                }
    //            }
    //            else
    //            {
    //                DirectoryInfo subFold = folder.CreateSubdirectory(ViewState["AssetID"].ToString());
    //                string IpFolder = subFold.Name;
    //                string doc = fileUpload1.FileName;
    //                string Ip = Path.Combine(@"C:\MachineServiceAgreement", IpFolder);
    //                upld = Path.Combine(Ip, doc);
    //                fileUpload1.PostedFile.SaveAs(upld);
    //                lblMsg.Visible = true;
    //                lblMsg.Text = "File Uploaded Sucessfully..";

    //            }

    //        }
    //        else
    //        {
    //            DirectoryInfo subfolder = folder.CreateSubdirectory(ViewState["AssetID"].ToString());
    //            DirectoryInfo[] sub = subfolder.GetDirectories();

    //            string IpFolder = subfolder.Name;
    //            string doc = fileUpload1.FileName;
    //            string Ip = Path.Combine(@"C:\MachineServiceAgreement", IpFolder);
    //            upld = Path.Combine(Ip, doc);
    //            fileUpload1.PostedFile.SaveAs(upld);
    //            lblMsg.Visible = true;
    //            lblMsg.Text = "File Uploaded Sucessfully..";




    //        }

    //    }
    //    catch (Exception ex)
    //    {
    //        ClassLog objErr = new ClassLog();
    //        objErr.errLog(ex);
    //    }  

    
    //}

    public void filesearch(string URL)
    {
        try
        {
            DirectoryInfo MyDir = new DirectoryInfo(@"C:\MachineServiceAgreement");
            DirectoryInfo[] f1 = MyDir.GetDirectories(ViewState["AssetID"].ToString());
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
                            string path1 = Path.Combine(@"C:\MachineServiceAgreement", di.Name);
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

    protected void btnupdate_Click(object sender, EventArgs e)
    {

    }

    protected void btnReply_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            if (txtDecription.Text != "")
            {
                string solvedBy, ProcessBy = "";
                if (ddlSolve.SelectedIndex == 0)
                {
                    lblMsg.Text = "Select Solve (Inhouse/OutSource)";
                    return;
                }

                if (ddlSolve.SelectedItem.Text == "OutSource")
                {
                    if (txtCompDetails.Text == "" && txtpersonDetail.Text == "" && txtamt.Text == "")
                    {
                        lblMsg.Text = "Kindly put Oursource details";
                        return;
                    }
                }
                if (ddlPartChange.SelectedItem.Text == "YES")
                {
                    if (txtPartDetails.Text == "")
                        return;
                }


                if (ddlSolvedBy.SelectedIndex > 0)
                    solvedBy = Util.GetString(ddlSolvedBy.SelectedValue);
                else
                    solvedBy = "";

                if (ddlProcessBy.SelectedIndex > 0)
                    ProcessBy = Util.GetString(ddlProcessBy.SelectedValue);
                else
                    ProcessBy = "";
                if (txtamt.Text == "")
                    txtamt.Text = "0";
                if (txtCost.Text == "")
                    txtCost.Text = "0";

                string str = "INSERT INTO f_ticket_reply(TICKETID,USERID,DESCRIPTION,REPLY_TIME,STATUS1 )VALUE ('" + lblticketid.Text + "','" + ViewState["ID"].ToString() + "','" + txtDecription.Text.Replace("'", "''") + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + ddlaction.SelectedItem.Text + "' )";
                //StockReports.ExecuteDML(str);
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str);

                string StrEq = " INSERT INTO  eq_MachineTicket_reply(TICKETID,AssetID,USERID,DESCRIPTION,REPLY_TIME,STATUS1,ProcessBy,SolvedBy,BillAttachment,ImageAttachment,Solve,CompDetail,PersonDetail,BillAmount,WorkDetail,PartChange,partDetail,PartCost,Comments)VALUES(" + lblticketid.Text + "," + lblAssetID.Text + ",'" + Session["ID"].ToString() + "','" + txtDecription.Text.Replace("'", "''") + "','" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + ddlaction.SelectedItem.Text + "','" + ProcessBy + "','" + solvedBy + "','" + lblBillAttachment.Text + "','" + lblImageAttachment.Text + "','" + ddlSolve.SelectedItem.Text + "','" + txtCompDetails.Text + "','" + txtpersonDetail.Text + "','" + txtamt.Text + "','" + txtwrkDetails.Text + "','" + ddlPartChange.SelectedItem.Text + "','" + txtPartDetails.Text + "'," + txtCost.Text + ",'" + txtComment.Text + "') ";
                //StockReports.ExecuteDML(StrEq);
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, StrEq);
                
                string ID = StockReports.ExecuteScalar("SELECT MAX(id) FROM eq_MachineTicket_reply WHERE TicketID='" + lblticketid.Text + "' AND AssetID='" + lblAssetID.Text + "' ");

                string Attachment = "";
                if (fldBill.HasFile)
                {
                    string filename = fldBill.PostedFile.FileName;
                    string Ext = filename.Substring(filename.LastIndexOf("."));
                    Attachment = string.Concat(lblticketid.Text + lblAssetID.Text + Ext);
                    fldBill.PostedFile.SaveAs(Server.MapPath("~/Design/Equipment/Attachment/" + Attachment));

                   // StockReports.ExecuteDML("update eq_MachineTicket_reply set BillAttachment='" + Attachment + "' where ID=" + ID + "");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text,"update eq_MachineTicket_reply set BillAttachment='" + Attachment + "' where ID=" + ID + "");
                }


                string ImageAttachment = "";
                if (fldPartImage.HasFile)
                {
                    string filename = fldPartImage.PostedFile.FileName;
                    string Ext = filename.Substring(filename.LastIndexOf("."));
                    ImageAttachment = string.Concat("Part" + lblticketid.Text + lblAssetID.Text + Ext);
                    fldPartImage.PostedFile.SaveAs(Server.MapPath("~/Design/Equipment/Attachment/" + ImageAttachment));

                   // StockReports.ExecuteDML("update eq_MachineTicket_reply set ImageAttachment='" + ImageAttachment + "' where ID=" + ID + "");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update eq_MachineTicket_reply set ImageAttachment='" + ImageAttachment + "' where ID=" + ID + "");
                }

                //StockReports.ExecuteDML("update f_ticket set LastUpdate='" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where TicketId=" + lblticketid.Text + "");
                txtDecription.Text = "";
                lblMsg.Text = "saved";
                btnReply.Enabled = false;
            }
            else
                lblMsg.Text = "Enter Desription";
        }
        catch (Exception ex)
        {
            lblMsg.Text = "Record not saved";
            tranX.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

    protected void ddlreplyrspnce_SelectedIndexChanged(object sender, EventArgs e)
    {
        txtDecription.Text = StockReports.ExecuteScalar("SELECT Description FROM f_premade_reply_master WHERE ID LIKE '" + ddlreplyrspnce.SelectedItem.Value + "' ");
    }

    private void response_bind()
    {
        DataTable dt = new DataTable();

        string asd = "select ID,TITLE from  f_premade_reply_master WHERE STATUS=1";
        dt = StockReports.GetDataTable(asd);
        ddlreplyrspnce.DataSource = dt;
        ddlreplyrspnce.DataTextField = "TITLE";
        ddlreplyrspnce.DataValueField = "ID";
        ddlreplyrspnce.DataBind();
        ddlreplyrspnce.Items.Insert(0, "Select Premade reply");


    }
    protected void lnkbtnattachment_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../../Support/SupportAttachment/" + lblattachment.Text + "');", true);
    }
    protected void lnkBill_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../Attachment/" + lblBillAttachment.Text + "');", true);
    }
    protected void lnkPartImage_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.open('../Attachment/" + lblImageAttachment.Text + "');", true);
    }
    protected void ddlSolve_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlSolve.SelectedItem.Text.Trim() == "InHouse")
        {
            trOutSource.Visible = false;
            trOutSource2.Visible = false;
        }
        else if (ddlSolve.SelectedItem.Text.Trim() == "OutSource")
        {
            trOutSource.Visible = true;
            trOutSource2.Visible = true;
        }
    }
    protected void ddlPartChange_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlPartChange.SelectedItem.Text.Trim() == "YES")
        {
            divPartDetail.Visible = true;
            txtPartDetails.Visible = true;
            trPart2.Visible = true;
        }
        else if (ddlPartChange.SelectedItem.Text.Trim() == "NO")
        {
            divPartDetail.Visible = false;
            txtPartDetails.Visible = false;
            trPart2.Visible = false;
        }
    }
}