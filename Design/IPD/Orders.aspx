<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Orders.aspx.cs" Inherits="Design_IPD_Orders" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lab Result</title>
    <%--<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />--%>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Common.js" type="text/javascript"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
    <link href="../../Styles/jquery-ui.css" rel="stylesheet" />


</head>
<body>

    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />

    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div style="font-weight: bolder; font-size: 15px">
                  Prescribed Medicine
                </div>

                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" Style="display: none"></asp:TextBox>

                <span id="spnPanelID" style="display: none"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnRoom_ID" style="display: none"></span>
                <span id="spnIPD_CaseTypeID" style="display: none"></span>
                <span id="spnReferenceCodeIPD" style="display: none"></span>
                <span id="spnPatientType" style="display: none"></span>
                <span id="spnScheduleChargeID" style="display: none"></span>
                <span id="spnGender" style="display: none"></span>
                <span id="spnPatientTypeID" style="display: none"></span>
                <span id="spnMembershipNo" style="display: none"></span>
                <span id="spnage" style="display: none;"></span>
                <span id="spnAdmitdate" style="display: none;"></span>
            </div>

            <div class="POuter_Box_Inventory">

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Remainder Type</label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="rblLabDepartmentType" runat="server" ClientIDMode="Static">

                            <asp:ListItem Value="4" Selected="True">Medicine</asp:ListItem>
                   <%--         <asp:ListItem Value="2">Radiology</asp:ListItem>
                            <asp:ListItem Value="3">Ipd Services</asp:ListItem>
                            <asp:ListItem Value="1">Laboratory</asp:ListItem>
                            <asp:ListItem Value="5">Minor Procedure</asp:ListItem>--%>

                        </asp:DropDownList>

                    </div>
                    <div class="col-md-3" style="display: none">
                        <label class="pull-left">Search On Date </label>
                        <b class="pull-right">:</b>

                    </div>
                    <div class="col-md-5" style="display: none">
                        <asp:RadioButtonList ID="rblondate" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1" Selected="True">Start Date</asp:ListItem>
                            <asp:ListItem Value="2">Stop Date</asp:ListItem>
                            <asp:ListItem Value="3">Next Run Time</asp:ListItem>

                            <%--                            <asp:ListItem Value="0" Selected="True">All</asp:ListItem>--%>
                        </asp:RadioButtonList>
                    </div>

                    <div class="col-md-3" style="display: none">
                        Order Status
                         <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-5" style="display: none">
                        <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1">Running</asp:ListItem>
                            <asp:ListItem Value="0">Stopped</asp:ListItem>
                            <asp:ListItem Value="2" Selected="True">All</asp:ListItem>

                        </asp:RadioButtonList>
                    </div>
                    <div class="col-md-3">
                        Indent Status
                         <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-5">
                        <asp:RadioButtonList ID="rblIndentStatus" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="1">Done</asp:ListItem>
                            <asp:ListItem Value="0">Pending</asp:ListItem>
                            <asp:ListItem Value="2" Selected="True">All</asp:ListItem>

                        </asp:RadioButtonList>
                    </div>


                </div>

                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">Select Item</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList runat="server" ID="ddlItem">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">From Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ClientIDMode="Static" TabIndex="1"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">To Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Click To Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                </div>


                <div class="row">

                    <div class="col-md-24" style="text-align: center;">

                        <asp:Button runat="server" ID="btnSearch" OnClick="btnSearch_Click" Text="Search" />

                        <input type="button" id="btnAddInv" value="Generate Indent" onclick="openIndentModel()" />
                         <input type="button" id="btnApprove"   onclick="openApproveModel()" value="Approval/Rejection" />

                        <input type="button" id="btnAck" style="display: none" onclick="AckbyNurse()" value="Acknowledge" />

                    </div>

                </div>


            </div>




            <div class="POuter_Box_Inventory" style="width: 100%; overflow-x: auto">
                <div class="Purchaseheader">
                    Order  Details
                </div>

                <asp:GridView ID="GrdOrder" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="GrdOrder_RowCommand" ClientIDMode="Static">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Pname" HeaderText="Name">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ReminderTypeName" HeaderText="Reminder Type">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="TypOfSch" HeaderText="Schedular Type">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="ItemName" HeaderText="Item Name">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Quantity" HeaderText="Item Qty.">
                            <ItemStyle Width="40px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                            <asp:BoundField DataField="RepeatDuration" HeaderText="Interval Time">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="StartDate" HeaderText="Start Date and Time">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="NextRunTime" HeaderText="NextRunTime">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Doctor" HeaderText="Doctor">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Status" HeaderText="Order Status">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="IndentStatus" HeaderText="Indent Status">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="HiddenField" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblID" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblItemId" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemId") %>'
                                    Visible="False"> </asp:Label>

                                <asp:Label ID="lblPatientId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PatientId") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblTransactionId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"TransactionId") %>'
                                    Visible="False"> </asp:Label>


                                <asp:Label ID="lblPName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Pname") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lbldrId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DoctorId") %>'
                                    Visible="False"> </asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="160px" CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="imbPacksimage" runat="server"
                                    CausesValidation="false" CommandName="Stop"
                                    CommandArgument='<%#Container.DataItemIndex%>' Text="Stop"
                                    Visible='<%# Eval("IsActive").ToString() == "0" ? false:true %>' BackColor="Red" Font-Bold="true"
                                    OnClientClick="return confirm('Are you sure you want to Stopped this event?');" />
                                <input type="button" id="btnrestart" value="Start" style="<%# Eval("IsActive").ToString() == "1" ? "display:none": "" %>" onclick='<%#"openRestartModel("+Eval("ID")+" )" %>' />

                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Select">
                            <ItemTemplate>
                                <input type="checkbox" id="chkSelect" value="<%#Eval("NotiId")%>" style="<%# Eval("IsIndentDone").ToString() == "1" ? "display:none": "" %>" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>


                <asp:GridView ID="grdMedicine" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdMedicine_RowCommand" ClientIDMode="Static">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="SNo" HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ack" HeaderStyle-Width="20px">
                            <ItemTemplate>
                                <input type="checkbox" class="ack_Checkbox" id="chkAck" value="<%#Eval("ID")%>" <%# Eval("IsView").ToString() == "0" ? "checked='checked'": "disabled='disabled'" %> />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>

                        <asp:BoundField DataField="ItemName" HeaderText="M Name">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         <asp:BoundField DataField="Doses" HeaderText="Dose">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                            <asp:BoundField DataField="Route" HeaderText="Route">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Frequency" HeaderText="Frequency" Visible="false">
                            <ItemStyle Width="40px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="StartDate" HeaderText="Start Date">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="ScheduleDose" HeaderText="Schedule Dose">
                            <ItemStyle Width="140px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="StartDoseTime" HeaderText="First Dose Time">
                            <ItemStyle Width="100px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>



                        <asp:BoundField DataField="FinalDoseTime" HeaderText="Final Dose Time">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>


                        <asp:BoundField DataField="Remark" HeaderText="Comments">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="CostQty" HeaderText="Cost Of Medicine">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="IndentStatus" HeaderText="Indent Status">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        
                        <asp:BoundField DataField="PrnView" HeaderText="Is PRN">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:BoundField DataField="OrderBy" HeaderText="Order By">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                        <asp:TemplateField HeaderText="HiddenField" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblID" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblItemId" ClientIDMode="Static" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemId") %>'
                                    Visible="False"> </asp:Label>

                                <asp:Label ID="lblPatientId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PatientId") %>'
                                    Visible="False"> </asp:Label>
                                <asp:Label ID="lblTransactionId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"TransactionId") %>'
                                    Visible="False"> </asp:Label>


                                <asp:Label ID="lbldrId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DoctorId") %>'
                                    Visible="False"> </asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="160px" CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Select">
                            <ItemTemplate>
                                <input type="checkbox" id="chkSelect" value="<%#Eval("Id")%>" style="<%#(Eval("IsIndentDone").ToString() == "1" || Eval("IsApproved").ToString() != "1" ) ? "display:none": "" %>" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField> 

                        <asp:BoundField DataField="ApprovedStatus" HeaderText="Is App">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                         <asp:TemplateField HeaderText="App /Rej">
                            <ItemTemplate>
                                <input type="checkbox" id="chkSelectToApprove" value="<%#Eval("Id")%>" style="<%# Eval("IsApproved").ToString() != "0"   ? "display:none": "" %>" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>
                            <asp:BoundField DataField="ApprovedRemark" HeaderText="App Remark">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ApprovedBy" HeaderText="Appd /Rejd By">
                            <ItemStyle Width="150px" HorizontalAlign="Left" CssClass="GridViewItemStyle"></ItemStyle>
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:BoundField>

                    </Columns>
                </asp:GridView>



            </div>

        </div>


        <div class="modal fade" id="divModelIndent">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 900px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeIndentModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Create Indent</h4>
                    </div>
                    <div class="modal-body">
                        <div id="LabOutput" style="max-height: 400px; overflow-y: auto; overflow-x: hidden;">
                            <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: block" class="GridViewStyle">
                                <thead>
                                </thead>

                            </table>

                        </div>

                        <div style="text-align: center; display: none" id="divTotalAmt" class="row">
                            <div class="col-md-24">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                            <span id="spnTotalAmountText" style="font-size: small; font-weight: bold; color: red;">Gross Amount</span>
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">
                                            <span id="spnGrossAmount" style="font-size: small; font-weight: bold; color: red"></span>
                                        </label>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            <span id="spntotaldiscount" style="font-size: small; font-weight: bold; color: red;">Discount Amount</span></label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">
                                            <span id="spnTotalDiscountAmount" style="font-size: small; font-weight: bold; color: red;"></span>
                                        </label>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="pull-left">
                                            <span id="spnNetAmount" style="font-size: small; font-weight: bold; color: red;">Net Amount</span></label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">
                                            <span id="spnTotalNetAmount" style="font-size: small; font-weight: bold; color: red;"></span>
                                        </label>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="pull-left" style="font-size: small; font-weight: bold; color: red;"></label>
                                        <b class="pull-right"></b>
                                    </div>
                                    <div class="col-md-2">
                                        <label class="pull-left">
                                            <span id="spnTotalRoundOff" style="font-size: small; font-weight: bold; color: red; display: none;"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="POuter_Box_Inventory divDiscountReason" style="display: none">
                            <div class="row">
                                <div class="col-md-24">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label class="pull-left">Discount Reason</label>
                                            <b class="pull-right">:</b>
                                        </div>
                                        <div class="col-md-8">
                                            <select id="ddlDiscountReason" class="required"></select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="pull-left">Approve By</label>
                                            <b class="pull-right">:</b>
                                        </div>
                                        <div class="col-md-8">
                                            <select id="ddlDiscountApproveBy" class="required"></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">

                        <input type="button" value="Save" class="ItDoseButton" id="btnCreateIndent" onclick="Save()" />

                    </div>
                </div>
            </div>
        </div>



        <div class="modal fade" id="myModal">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeRestartModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">RESTART</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-5">Type of Schedular</div>
                            <div class="col-md-7">
                                <select id="ddlTypeOfSchedular" onchange="$OnchangeTypeOfScheduler(function (response) { });" class="required">
                                    <option value="">Select</option>
                                    <option value="1">Run Once</option>
                                    <option value="0" selected="selected">Run At Intervals</option>
                                </select>
                            </div>
                            <div class="col-md-5">
                                Duration Type
                            </div>
                            <div class="col-md-7">
                                <select id="ddlTypeofDuration" class="required">
                                    <option value="">Select Type</option>
                                    <option value="HOUR" selected="selected">HOUR</option>
                                    <option value="MONTH">MONTH</option>
                                    <option value="WEEK">WEEK</option>
                                    <option value="DAY">DAY</option>
                                    <option value="MINUTE">MINUTE</option>
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-5">
                                Repeat Duration
                            </div>
                            <div class="col-md-7">
                                <input type="text" id="txtRepeatDuration" class="form-control btn-sm required" style="float: left;" onkeypress="return isNumber(event)" maxlength="2" autocomplete="off">
                            </div>
                            <div class="col-md-5">
                                No. Of Repetition
                            </div>
                            <div class="col-md-7">
                               
                                <input type="text" id="txtNoOfRepetition" class="form-control btn-sm" style="float: left;" onkeypress="return isNumber(event)"  maxlength="2" autocomplete="off" />
                                
                                 </div>

                        </div>
                        <div class="row">

                            <div class="col-md-5">Start Date</div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtSelectDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSelectDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-5">Start Time</div>
                            <div class="col-md-7">
                                <input type="text" id="txtStartTime" class="ItDoseTextinputText txtTime required" style="z-index: 10000001" readonly="readonly" />
                                <label id="lblNotID" style="display: none"></label>
                            </div>
                        </div>
                        <div class="row" style="display: none">

                            <div class="col-md-5">Stop Date</div>
                            <div class="col-md-7">
                                <asp:TextBox ID="txtStopDate" runat="server" ToolTip="Click to Select Stop Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtStopDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-5">Stop Time</div>
                            <div class="col-md-7">
                                <input type="text" id="txtStopTime" class="ItDoseTextinputText txtTime required" readonly="readonly" />
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnSave" onclick="SaveAfterRestart()" value="Save" style="padding: 2px 5px; border: 1px solid transparent; font-size: 14px;" />
                    </div>
                </div>

            </div>
        </div>


        <div class="modal fade" id="modelApproved">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content" style="width: 800px">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="$closeApproveModel()" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Approved</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">

                            <label id="lblOrderIdToApprove" style="display: none"></label>
                            <div class="col-md-3">
                                Comment :
                            </div>

                            <div class="col-md-13">
                                   <textarea cols="2" rows="5" id="txtComment" class="required"></textarea>
                            </div>

                            <div class="col-md-4">
                                Is Approve :
                                </div>
                            <div class="col-md-4">
                                <input type="checkbox"  id="chkIsApprovd" checked="checked" />
                            </div>

                        </div>
                        
                    </div>
                    <div class="modal-footer">
                        <input type="button" id="btnApproved" onclick="ApproveOrderOfStudent()" value="Submit" style="padding: 2px 5px; border: 1px solid transparent; font-size: 14px;" />
                    </div>
                </div>

            </div>
        </div>


    </form>

    <script type="text/javascript">



        var openIndentModel = function () {
            debugger
            var depType = $("#rblLabDepartmentType").val();
            var refCode = $("#spnReferenceCodeIPD").text();
            var ipdCaseTyp = $("#spnIPD_CaseTypeID").text();

            var SchChargId = $("#spnScheduleChargeID").text();
            var trId = $("#spnTransactionID").text();

            var PanID=$('#spnPanelID').text();
            var ordId = "";
            var count = ""
            debugger;
            if (depType == 4) { 
                $("#grdMedicine #chkSelect:checked").each(function () {
                    if (count == 0) {
                        ordId = this.value;

                    } else {
                        ordId = ordId + ',' + this.value;
                    }
                    count = count + 1;

                });
            }
            else {

                $("#GrdOrder input[type=checkbox]:checked").each(function () {
                    if (count == 0) {
                        ordId = this.value;

                } else {
                    ordId = ordId + ',' + this.value;
                }
                    count = count + 1;

            });
            }

            if (ordId == "") {

                modelAlert("Select Order");
                return false;
            }

           
            if (depType == 3 || depType == 5) {
                var tHead = "";
               
                tHead += ' <tr id="LabHeader">'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:center">CPT Code</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">Item Name</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align:center">Payable</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Date</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Remarks</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Rate</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Quantity</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Discount(%)</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Amount</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>'
                tHead += ' </tr>'
                   
                $('#tbSelected thead').append(tHead);

            } else if (depType == 2 || depType == 1) {
                var tHead = "";
                tHead += ' <tr id="LabHeader" style="">'

                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align: center">CPT Code</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align: center">Item Name</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align: center">Urgent</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 60px; text-align: center; display: none;">Payable</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align: center">Order Date</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align: center">SampleCol. Req.DateTime</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 160px; text-align: center">Remarks</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align: center;">Rate</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: center">Quantity</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: center; display: none;">Discount(%)</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: center; display: none;">Amount</th>'
                tHead += '<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: center">Remove</th>'

                tHead += '</tr>'

                $('#tbSelected thead').append(tHead);
            }
            else if (depType == 4) {
                var tHead = "";
                tHead += ' <tr id="LabHeader" style="">'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left;display:none">Code</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:left">Item Name</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Dose</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left;display:none">Time</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:left">Duration</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Route</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center;display:none">Meal</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:left">Quantity</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Remarks</th>'
                tHead += ' <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>'
                tHead += '</tr>'

                $('#tbSelected thead').append(tHead);
            }


            //return false;
            serverCall('Orders.aspx/GetItemID', { RemainderType: depType, transactionid: trId, PanelId: PanID, OrderID: ordId, ReferenceCode: refCode, IPDCaseTypeID: ipdCaseTyp, ScheduleChargeID: SchChargId, CentreID: 1 }, function (response) {
                console.log(response)


                var ItemData = JSON.parse(response);

                if (ItemData.status) {
                    
                    if (depType == 4) {

                        data = ItemData.data;
                        $('#divAppendMessage').empty();
                        $.each(data, function (i, item) {

                            AddMedicineItem(item.DurationVal, item.RequisitionType, item.Remark, item.ItemID, item.ItemName, item.FromDate, item.Dose, item.Route, item.DoctorId, item.isDischargeMedicine, item.TypeOfMedicine, item.Meal, item.Qty, item.Timing, item.ToDepartment, item.Duration)


                        });
                        $("#divModelIndent").showModel();

                    } else {
                        data = ItemData.data;
                        $('#divAppendMessage').empty();
                        $.each(data, function (i, item) {
                            AddItem(item.ItemId, item.TypeName, item.FromDate, item.Qty, item.DoctorId);
                        });
                        $("#divModelIndent").showModel();
                    }
                } else {
                    $("#divModelIndent").hideModel();
                    modelAlert(ItemData.Message);
                }

            });


        }

        var $closeIndentModel = function () {

            $('#tbSelected thead').empty();

            $('#tbSelected tr:not(#LabHeader)').each(function () {
                $(this).closest('tr').remove();
              
            });




            $("#btnAddInv").removeAttr('disabled');
            $("#divModelIndent").hideModel();

        }





        var openRestartModel = function (Id) {

            $("#lblNotID").text(Id);
            $("#myModal").showModel();
        }

        var $closeRestartModel = function () {
            $("#myModal").hideModel();
            $('#lblNotID').text("");
        }




        function confirm_Stopped() {

            modelConfirmation('Stopped', 'Are you sure you want to Stopped  Notification ?', 'YES', 'NO', function (response) {
                if (response) {

                    return true;
                }
            });
            return false;
        }


        $(document).ready(function () {
            btnhideShowAck();
            bindHashCode();
            BindPatientDetail();
            var time_plus_6 = new Date(new Date().getTime() + 1 * 3600 * 1000);

            $OnchangeTypeOfScheduler(function (response) { });

            $('.txtTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 1,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: time_plus_6,
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });

        });


        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }



        var $OnchangeTypeOfScheduler = function () {
            if ($('#ddlTypeOfSchedular').val() == "1") {
                $("#txtSelectDate").attr("disabled", false);
                $("#txtStartTime").attr("disabled", false);

                $("#txtRepeatDuration").attr("disabled", true);
                $("#ddlTypeofDuration").attr("disabled", true);
                $("#txtNoOfRepetition").attr("disabled", true);



                $("#txtNoOfRepetition").removeClass("required");
                $("#txtRepeatDuration").removeClass("required");
                $("#ddlTypeofDuration").removeClass("required");


            }
            else if ($('#ddlTypeOfSchedular').val() == "0") {
                $("#txtSelectDate").attr("disabled", false);
                $("#txtStartTime").attr("disabled", false);
                $("#txtRepeatDuration").attr("disabled", false);
                $("#ddlTypeofDuration").attr("disabled", false);
                $("#txtNoOfRepetition").attr("disabled", false);

                $("#txtNoOfRepetition").addClass("required");
                $("#txtRepeatDuration").addClass("required");
                $("#ddlTypeofDuration").addClass("required");


            }
            else {

                $("#txtSelectDate").attr("disabled", true);
                $("#txtStartTime").attr("disabled", true);
                $("#txtRepeatDuration").attr("disabled", true);
                $("#ddlTypeofDuration").attr("disabled", true);
                $("#txtNoOfRepetition").attr("disabled", true);


            }

        }



        var SaveAfterRestart = function () {
            var data = {
                Id: $('#lblNotID').text(),
                RepeatDuration: $.trim($("#txtRepeatDuration").val()),
                TypeofDuration: $("#ddlTypeofDuration").val(),
                TypeOfSchedular: $.trim($("#ddlTypeOfSchedular").val()),

                StartDate: $.trim($("#txtSelectDate").val()),
                StartTime: $.trim($("#txtStartTime").val()),
                StopDate: $.trim($("#txtSelectDate").val()),
                StopTime: $.trim($("#txtStartTime").val()),                
                NoOfRepetition :$.trim( $("#txtNoOfRepetition").val()),

            }

            if (data.Id == "") {
                modelAlert("Error Occured! Contact to administrator .");
                return false;
            }
            if (data.StartTime == "") {
                modelAlert("Please Select Start Time");
                return false;
            }

            data.StopDate = data.StartDate;
            data.StopTime = data.StartTime;

            if (data.TypeOfSchedular == 0) {
                if (data.TypeofDuration == "") {
                    modelAlert("Please Select Type of Duration");
                    return false;
                }
                if (data.RepeatDuration == "") {
                    modelAlert("Please Enter repeat Duration");
                    return false;
                }
                if (data.NoOfRepetition == "") {
                    modelAlert("Please Enter No Of Repetition.");
                    return false;
                }
            } 



            serverCall('Orders.aspx/SaveLabAndRadiologyOrder', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        $('#lblNotID').text("");
                        $("#txtRepeatDuration").val("");
                        $("#ddlTypeofDuration").val("");
                        $("#ddlTypeOfSchedular").val("");
                        $("#txtStartTime").val("");

                        $("#txtStopTime").val("");
                        $closeRestartModel();

                        window.location.reload();
                    }
                });
            });
        }


        function BindPatientDetail() {
            $('#spnPanelID,#spnIPD_CaseTypeID,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnScheduleChargeID,#spnPatientType,#spnGender,#spnPatientTypeID,#spnMembershipNo,#spnRoom_ID,#spnage,#spnAdmitdate').text('');
            jQuery.ajax({
                url: "Services/IPDLabPrescription.asmx/BindPatientDetails",
                data: '{TID:"' + $('#spnTransactionID').text() + '",PID:"' + $('#spnPatientID').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = jQuery.parseJSON(result.d);
                    if (data != "") {
                        $('#spnPanelID').text(data[0].PanelID);
                        $('#spnPatientID').text(data[0].PatientID);
                        // modelAlert(data[0].IPDCaseTypeID);
                        $('#spnIPD_CaseTypeID').text(data[0].IPDCaseTypeID);
                        //alert(data[0].IPDCaseTypeID);
                        //  alert(data[0].PanelID);
                        $('#spnReferenceCodeIPD').text(data[0].ReferenceCode);
                        $('#spnScheduleChargeID').text(data[0].ScheduleChargeID);
                        $('#spnPatientType').text(data[0].PatientType);
                        $('#spnGender').text(data[0].Gender);
                        $('#spnPatientTypeID').text(data[0].PatientTypeID);
                        $('#spnMembershipNo').text(data[0].MemberShipCardNo);
                        $('#spnRoom_ID').text(data[0].RoomID);
                        $('#spnage').text(data[0].Age);
                        $('#spnAdmitdate').text(data[0].Dateofadmit);
                    }
                },
                error: function (xhr, status) {
                }
            });
        }




        function AddMedicineItem(DurationVal,RequisitionType,Remark, AppendItemId, ItemName, StartFrom, Dose, Route, DoctorId, isDischargeMedicine, TypeOfMedicine, Meal, Qty, Timing, ToDepartment, Duration) {

            $("#btnAddInv").attr('disabled', 'disabled');
            $("#spnErrorMsg").text('');

            if (AppendItemId === null || AppendItemId === undefined) {
                $("#btnAddInv").removeAttr('disabled');
                $("#spnErrorMsg").text('Please Select Item');

                return;
            }
            $("#spnErrorMsg").text('');
            var ItemID = AppendItemId.split('#')[0];
            var categoryID = AppendItemId.split('#')[9];
            var conDup = 0;
            var AlreadyPreItem = 0;
            var prescribeItem = 0;
            var UserName = "";
            var Date = "";
            var RowColour = "";
            
            var Time=Timing, Duration=Duration, Route=Route, DurationValue, Meal=Meal;
            var ItemName = ItemName;
            var ItemCode = AppendItemId.split('#')[8];
            var SubCategoryID =  AppendItemId.split('#')[1];
            var Dose = Dose;
               
                


            if (categoryID == 'LSHHI5') {

                if (Dose <= 0) {
                    modelAlert('Please Enter Dose.', function () {
                        $('#txtDose').focus();
                    });
                    return false;
                }

                if (Time == '') {
                    modelAlert('Please Select Times.', function () {
                        $('#ddlTime').focus();
                    });
                    return false;
                }

                if (Duration == '') {
                    modelAlert('Please Select Duration.', function () {
                        $('#ddlDuration').focus();
                    });
                    return false;
                }
            }


            var Quantity = Number(Qty);
            if (Quantity <= 0) {
                modelAlert("Please Enter Valid Quantity", function () {
                    $('#txtRequestedQty').focus();
                });

                return false;
            }
            var Remarks = Remark;
            var unitType =  AppendItemId.split('#')[3].trim();
            $('#tbSelected').css('display', 'block');
            $('#tbSelected').append('<tr ' + RowColour + '><td class="GridViewLabItemStyle" style="width:70px;display:none" ><span id="ItemCode">' + ItemCode +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px"><span id="spnItemName">' + ItemName +
                                    '</span><span id="spnSubCategoryID"  style="display:none" > ' + SubCategoryID + ' </span><span id="spnitemID" style="display:none" >' + ItemID +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnDose">' + Dose +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnTime">' + Time +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnDuration">' + Duration +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnDurationValue">' + DurationValue +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnRoute">' + Route +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnMeal">' + Meal +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnQuantity">' + Quantity +
                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnRemarks">' + Remarks +
                                    '</span><span id="spnunitType" style="display:none">' + unitType + '</span></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td>'+
                                    '<td style="display:none"><span id="tdspnDoctorId" style="display:none">' + DoctorId + '</span>'+
                                    '<span id="tdspnIndentType" style="display:none">' + RequisitionType + '</span>'+
                                    ' <span id="tdspnDepartment" style="display:none">' + ToDepartment + '</span> <span id="tdspnisDischargeMedicine" style="display:none">' +isDischargeMedicine+ '</span> </td>');
            $("#btnAddInv").removeAttr('disabled');
            $('#divOutput,#tbSelected').show();
                
            $('#divSave').show();
            $("#spnErrorMsg").text('');
               
            $('.textbox-text').focus();
            
            
        }












        function AddItem(AppendItemId, ItemName, StartFrom, Qty, DoctorId) {
            var depType = $("#rblLabDepartmentType").val();
            if (depType == 1 || depType == 2) {


                if (AppendItemId == "") {
                    modelAlert('Please Select Item')
                    return false;
                }
                $("#btnAddInv").attr('disabled', 'disabled');
                $("#spnErrorMsg").text('');
                if (AppendItemId === null || AppendItemId === undefined) {
                    modelAlert('Please Select Item', function () {
                        $("#btnAddInv").removeAttr('disabled');
                        return false;
                    });
                }
                if (jQuery('#spnGender').text() == "Male" && AppendItemId.split('#')[6] == "F") {
                    modelAlert('This Test Is Not For Male Patient');
                    return false;
                }
                if (jQuery('#spnGender').text() == "Female" && AppendItemId.split('#')[6] == "M") {
                    modelAlert('This Test Is Not For Female Patient');
                    return false;
                }
                var ItemID = AppendItemId.split('#')[0];
                var conDup = 0;
                var UserName = "";
                var Date = "";
                var RowColour = "";

                //    alreadyPrescribeItem({ PatientID: $.trim($('#spnPatientID').text()), ItemID: ItemID }, function (response) {
                //   if (response) {
                //if (CheckDuplicateItem(ItemID)) {
                // modelAlert('Selected Item Already Added');
                ////conDup = 1;

                // return;
                // }
                //if (conDup == "1") {
                //    modelAlert('Selected Item Already Added');
                //    return;
                //}

                var InvestigationID = AppendItemId.split('#')[11].trim();
                var ItemName = ItemName;//$("#cmbItem").combogrid('getText');
                if (AppendItemId.split('#')[2].trim() != "") {
                    ItemName = AppendItemId.split('#')[2].trim();
                }
                var ItemCode = AppendItemId.split('#')[3].trim();
                var ConfigRelation = AppendItemId.split('#')[13].trim();
                var SubCategoryID = AppendItemId.split('#')[12].trim();
                var SampleRequired = AppendItemId.split('#')[7].trim();
                var Disc = 0;
                var CoPayPercent = 0;
                var OutSource = AppendItemId.split('#')[8].trim();
                var OutSourcelabID = AppendItemId.split('#')[9].trim();
                var RateEditable = AppendItemId.split('#')[5].trim();
                var labDoctorID = DoctorId;


                var Payable = '';
                var Urgent = 0;
                var UrStatus = "";
                if ($('#chkUrgent').is(":checked")) {
                    Urgent = 1;
                    UrStatus = 'checked="checked"';
                }
                else {
                    Urgent = 0;
                    UrStatus = '';
                }
                var Rate, ScheduleChargeID, Quantity = Qty, Days = 0, RateListID;
                //if (ConfigRelation != 3)
                //    Quantity = $('#txtQuantity').val();
                //else
                //    Quantity = "1";

                var TID = $("#spnTransactionID").text();
                RateListID = AppendItemId.split('#')[4].trim();
                Rate = AppendItemId.split('#')[1].trim();
                // alert(Rate)
                $.ajax({
                    url: "Services/IPDLabPrescription.asmx/GetDiscount",
                    data: '{PanelID:"' + $("#spnReferenceCodeIPD").text() + '",ItemID:"' + ItemID + '",patientTypeID:"' + $('#spnPatientTypeID').text() + '",MembershipNo:"' + $("#spnMembershipNo").text() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = jQuery.parseJSON(mydata.d);
                        if ('<%=Resources.Resource.IsmembershipInIPD%>' == "1" && $("#spnReferenceCodeIPD").text() == '<%=Resources.Resource.DefaultPanelID%>' && $('#spnMembershipNo').text() != "") {
                            if (data != 0) {
                                Disc = data;
                            }
                            Payable = "";
                            CoPayPercent = 0;
                        }
                        else {
                            Disc = data[0].IPDPanelDiscPercent;
                            if (data[0].IsPayble == "1")
                                Payable = 'checked="checked"';
                            CoPayPercent = data[0].IPDCoPayPercent;
                        }
                    }
                });

                $.ajax({
                    url: "Services/IPDLabPrescription.asmx/CalculateDays",
                    data: '{StartDate:"' + StartFrom + '",EndDate:"' + StartFrom + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        Days = mydata.d;
                    }
                });
                var ratestatus = "";
                if (RateEditable == 1)
                    ratestatus = 'disabled="disabled"';
                var SelectedDate = StartFrom; //$('#ucFromDate').val();
                $('#tbSelected').css('display', 'block');
              //  var ratestatus = '<%=Util.GetInt(ViewState["IsRate"])%>' == '0' ? 'disabled="disabled"' : '';
                var IsDiscount = '<%=Util.GetInt(ViewState["IsDiscount"])%>' == '0' ? 'disabled="disabled"' : '';
                var NetAmount = ((Rate * Quantity) - (((Rate * Quantity) * Disc) / 100));

                $('#tbSelected').append('<tr><td class="GridViewLabItemStyle" style="width:70px" ><span id="ItemCode">' + ItemCode +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px;"><span id="ItemName">' + ItemName +
                                        '</span><span  style="display:none" id="spnInvestigationID" >' + InvestigationID +
                                        '</span><span  style="display:none" id="spnSubCategoryID" > ' + SubCategoryID + ' </span><span  style="display:none" id="spnSampleRequired" > ' + SampleRequired + ' </span></td><td class="GridViewLabItemStyle" style="text-align:center" ><span id="tditemID" style="display:none">' + ItemID +
                                        '</span><span id="tdConfigRelation" style="display:none">' + ConfigRelation +
                                        '</span><span id="spnRateListID" style="display:none"> ' + RateListID + '</span><input type="checkbox" id="chkUrgentItem" ' + UrStatus + '  /></td>' +
                                        '<td style="text-align:center;display:none;"><input type="checkbox" disabled="disabled" id="chkPayable" ' + Payable + '  /></td>' +
                                        '<td class="GridViewLabItemStyle" style="width:100px" ><span id=spnDate>' + SelectedDate +
                                        '</span><span id="spnOutSource" style="display:none">' + OutSource + '</span><span id="tdspnDoctorId" style="display:none">' + labDoctorID + '</span><span id="spnOutSourcelabID" style="display:none">' + OutSourcelabID + '</span><span id="spnRateEditable" style="display:none">' + RateEditable + '</span><span id="spncopayment" style="display:none">' + CoPayPercent + '</span></td>' +
                                        '<td><input type="text"  class="datepicker"  autocomplete="off"/><input type="text" id="SCRequesttime" class="timepicker"  autocomplete="off"/> </td> ' +
                                        '<td class="GridViewLabItemStyle" style="width:100px" ><input id="txtRemarks"  type="text" style="width:160px;" autocomplete="off" value="" /></td>' +
                                        '<td class="GridViewLabItemStyle" style="width:40px;"><input id="txtRate" autocomplete="off"  type="text" class="ItDoseTextinputNum" style="width:100px"  value=' + precise_round(Rate, 2) +
                                        ' class="ItDoseTextinputNum" onkeyup="Rate(this);"  onkeypress="return checkNumeric(event,this);"/></td><td class="GridViewLabItemStyle" style="width:30px"><span id="spnQuantity" >' + precise_round(Quantity, 2) +
                                        ' </span></td><td class="GridViewLabItemStyle" style="width:40px;display:none;"><input id="txtDiscountPer" decimalplace="4"   max-value="100" class="ItDoseTextinputNum" type="text" autocomplete="off" onkeyup="Rate(this);" style="width:100px" class="ItDoseTextinputNum" ' + IsDiscount + ' value=' + precise_round(Disc, 2) +
                                        ' /></td><td class="GridViewLabItemStyle" style="width:40px;display:none;"><input id="txtAmount" class="ItDoseTextinputNum" type="text" autocomplete="off" style="width:100px;" class="ItDoseTextinputNum" readonly="readonly" value=' + precise_round(NetAmount, 2) +
                                        ' /></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
                $.ajax({
                    url: "Services/IPDLabPrescription.asmx/CalculateNextDay",
                    data: '{StartDate:"' + SelectedDate + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        SelectedDate = "";
                        SelectedDate = mydata.d;
                    }
                });

                bindRate();
                $('#divSave').show();
                $("#btnAddInv").removeAttr('disabled');
                $('#LabOutput,#tbSelected').show();

                var admitdate = new window.Date(($('#spnAdmitdate').text()));
                var year = admitdate.getFullYear();
                var Month = admitdate.getMonth();
                var Date = admitdate.getDate();
                $('.datepicker').datepicker({
                    minDate: 0,
                    maxDate: 3

                }

                    );
                $('.timepicker').timepicker({
                    timeFormat: 'h:mm p',
                    interval: 1,
                    minTime: '00:01',
                    maxTime: '11:59pm',
                    // defaultTime: '00:01',
                    startTime: '00:01',
                    dynamic: false,
                    dropdown: true,
                    scrollbar: true
                });
                //}
                //    });

            }
            else if (depType == 3 || depType == 5) {

                if (AppendItemId == "") {
                    modelAlert('Please Select Item')
                    return false;
                }
                $("#btnAddInv").attr('disabled', 'disabled');
                $("#spnErrorMsg").text('');
                if (AppendItemId === null || AppendItemId === undefined) {
                    modelAlert('Please Select Item', function () {
                        $("#btnAddInv").removeAttr('disabled');
                        return false;
                    });
                }
                var ItemID = AppendItemId.split('#')[0];
                var conDup = 0;
                var UserName = "";
                var Date = "";
                var RowColour = "";

                ////if (CheckDuplicateItem(ItemID)) {
                ////    modelAlert('Selected Item Already Added');
                ////    conDup = 1;
                ////    $("#btnAddInv").removeAttr('disabled');

                ////    return;
                ////}
                ////if (conDup == "1") {
                ////    modelAlert('Selected Item Already Added');
                ////    return;
                ////}
                var TypeID = AppendItemId.split('#')[11].trim();
                var ItemName = ItemName;
                if (AppendItemId.split('#')[2].trim() != "") {
                    ItemName = AppendItemId.split('#')[2].trim();
                }
                var ItemCode = AppendItemId.split('#')[3].trim();
                var ConfigRelation = AppendItemId.split('#')[13].trim();
                var SubCategoryID = AppendItemId.split('#')[12].trim();
                var Disc = 0;
                var CoPayPercent = 0;
                var RateEditable = AppendItemId.split('#')[5].trim();
                var Payable = '';
                var GSTDetails = AppendItemId.split('#')[6].trim();
                var Rate, ScheduleChargeID, Quantity = Qty, Days = 0, RateListID;


                if (Quantity == "") {
                    modelAlert("Please Enter Quantity");
                    $('#txtQuantity').focus();
                    return false;
                }
                var TID = $("#spnTransactionID").text();
                RateListID = AppendItemId.split('#')[4].trim();
                Rate = precise_round(AppendItemId.split('#')[1].trim(), 2);
                $.ajax({
                    url: "Services/IPDLabPrescription.asmx/GetDiscount",
                    data: '{PanelID:"' + $("#spnReferenceCodeIPD").text() + '",ItemID:"' + ItemID + '",patientTypeID:"' + $('#spnPatientTypeID').text() + '",MembershipNo:"' + $("#spnMembershipNo").text() + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var data = jQuery.parseJSON(mydata.d);
                        if ('<%=Resources.Resource.IsmembershipInIPD%>' == "1" && $("#spnReferenceCodeIPD").text() == '<%=Resources.Resource.DefaultPanelID%>' && $('#spnMembershipNo').text() != "") {
                            if (data != 0) {
                                Disc = data;
                            }
                            Payable = "";
                            CoPayPercent = 0;
                        }
                        else {
                            Disc = data[0].IPDPanelDiscPercent;
                            if (data[0].IsPayble == "1")
                                Payable = 'checked="checked"';
                            CoPayPercent = data[0].IPDCoPayPercent;
                        }
                    }
                });

                $.ajax({
                    url: "Services/IPDLabPrescription.asmx/CalculateDays",
                    data: '{StartDate:"' + StartFrom + '",EndDate:"' + StartFrom + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        Days = mydata.d;
                    }
                });
                if (ConfigRelation == "14") {
                    Days = 0;
                }
                var ratestatus = "";
                if (RateEditable == 1 || Rate != 0)
                    ratestatus = 'disabled="disabled"';
                //var ratestatus = '<%=Util.GetInt(ViewState["IsRate"])%>' == '0' ? 'disabled="disabled"' : '';
                var SelectedDate = StartFrom; //$('#ucDate').val();
                $('#tbSelected').css('display', 'block');
                var IsDiscount = '<%=Util.GetInt(ViewState["IsDiscount"])%>' == '0' ? 'disabled="disabled"' : '';
                var NetAmount = ((Rate * Quantity) - (((Rate * Quantity) * Disc) / 100));
                for (var i = 0; i <= Days ; i++) {
                    $('#tbSelected').append('<tr><td class="GridViewLabItemStyle" style="width:70px" ><span id="ItemCode">' + ItemCode +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;"><span id="ItemName">' + ItemName +
                                            '</span><span  style="display:none" id="spnInvestigationID" >' + TypeID +
                                            '</span><span  style="display:none" id="spnSubCategoryID" > ' + SubCategoryID + ' </span><span id="tditemID" style="display:none">' + ItemID +
                                            '</span><span id="tdConfigRelation" style="display:none">' + ConfigRelation +
                                            '</span><span id="spnRateListID" style="display:none"> ' + RateListID + '</span><span id="spnGSTDetails" style="display:none">' + GSTDetails + '</span></td>' +
                                            '<td style="text-align:center"><input type="checkbox" disabled="disabled" id="chkPayable" ' + Payable + '  /></td>' +
                                            '<td class="GridViewLabItemStyle" style="width:100px" ><span id=spnDate>' + SelectedDate +
                                            '</span><span id="spnRateEditable" style="display:none">' + RateEditable + '</span><span id="spncopayment" style="display:none">' + CoPayPercent + '</span></td>' +
                                            '<td class="GridViewLabItemStyle" style="width:100px" ><input id="txtRemarks"  type="text" style="width:100px;" autocomplete="off" value="' + $('#txtRemarks').val() + '" /></td>' +
                                            '<td class="GridViewLabItemStyle" style="width:40px"><input id="txtRate" autocomplete="off"  type="text" class="ItDoseTextinputNum" style="width:100px;" ' + ratestatus + ' value=' + Rate +
                                            ' onkeyup="Rate(this);"  onkeypress="return checkNumeric(event,this);"/></td><td class="GridViewLabItemStyle" style="width:30px"><input onkeyup="Rate(this);" type="text" class="ItDoseTextinputNum"  onkeypress="return checkNumericDecimal(event,this);" id="spnQuantity" autocomplete="off" value=' + Quantity +
                                            ' </input></td><td class="GridViewLabItemStyle" style="width:40px"><input id="txtDiscountPer" class="ItDoseTextinputNum" type="text" autocomplete="off" onkeyup="Rate(this);" style="width:100px" class="ItDoseTextinputNum" ' + IsDiscount + ' value=' + Disc +
                                            ' /></td><td class="GridViewLabItemStyle" style="width:40px"><input id="txtAmount" class="ItDoseTextinputNum" type="text" autocomplete="off" style="width:100px" class="ItDoseTextinputNum" readonly="readonly" value=' + NetAmount +
                                            ' /></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
                    $.ajax({
                        url: "Services/IPDLabPrescription.asmx/CalculateNextDay",
                        data: '{StartDate:"' + StartFrom + '"}',
                        type: "POST",
                        async: false,
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function (mydata) {
                            SelectedDate = "";
                            SelectedDate = mydata.d;
                        }
                    });
                }
                bindRate();
                $('#divSave').show();
                $("#btnAddInv").removeAttr('disabled');
                $('#ItemOutput,#tbSelected').show();
                $('#txtQuantity').val('1').attr("placeholder", "Enter Quantity");
                $('#txtRemarks').val('');
                $('#divTotalAmt').show();

                $('.textbox-text').focus();




            }








    }
    var alreadyPrescribeItem = function (data, callBack) {
        if (data.PatientID.trim() != '') {
            serverCall('Services/IPDLabPrescription.asmx/getAlreadyPrescribeItem', data, function (response) {
                responseData = JSON.parse(response);
                if (responseData != null && responseData != "") {
                    modelConfirmation('Do You Want To Prescribe Again  ?', 'This Investigation is Already Prescribed By ' + responseData[0].UserName + '</br> Date On ' + responseData[0].EntryDate, 'Prescribe Again', 'Cancel', function (response) {
                        if (response)
                            callBack(true);
                    });
                }
                else
                    callBack(true);
            });
        }
        else
            callBack(true);
    }



    function Save() {
        var depType = $("#rblLabDepartmentType").val();
        if (depType == 1 || depType == 2) {
            if (Validation()) {
                serverCall('IPDLabPrescriptionNew.aspx/checkEmergencyCharges', {}, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            SaveEntry(function () { });
                        });
                    }
                    else
                        SaveEntry(function () { });
                });
            }
            else
                modelAlert("Please Remove The Zero Rate Item Otherwise Enter The Rate of These Item");

        }
        else if (depType == 4) {

            SaveMedicine(function () { });

        }
        else if (depType == 3 || depType == 5) {
            //if (Validation()) {
            var ordId = "";
            var count = ""
            $("#GrdOrder input[type=checkbox]:checked").each(function () {
                if (count == 0) {
                    ordId = this.value;

                } else {
                    ordId = ordId + ',' + this.value;
                }
                count += count + 1;

            });
            var resultLT = LedgerTransaction();
            var resultLTD = LedgerTransactionDetail();

            if (Number(resultLT[0].DiscountOnTotal) > 0) {

                if (String.isNullOrEmpty(resultLT[0].DiscountReason)) {
                    modelAlert('Please Select Discount Reason.', function () {
                        $('#ddlDiscountReason').focus();
                    });
                    return false;
                }


                if (String.isNullOrEmpty(resultLT[0].DiscountApproveBy)) {
                    modelAlert('Please Select Approve By.', function () {
                        $('#ddlDiscountApproveBy').focus();
                    });
                    return false;
                }
            }


            $('#btnSave').attr('disabled', true).val("Submitting...");


            $.ajax({
                url: "Services/IPDLabPrescription.asmx/SaveServicesBilling",
                data: JSON.stringify({ LT: resultLT, LTD: resultLTD, PatientTypeID: $('#spnPatientTypeID').text(), MembershipNo: $('#spnMembershipNo').text(), NotificationId: ordId }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    var responseData = JSON.parse(result.d);

                    var btnSave = $('#btnSave');

                    modelAlert(responseData.response, function () {

                        if (responseData.status)
                            window.location.reload();
                        else
                            $(btnSave).removeAttr('disabled').val('Save');

                    });




                    //OutPut = result.d;
                    //if (result.d.split('#')[1] == 1) {
                    //    modelAlert("Record Saved Successfully", function () {
                    //        $('#btnSave').attr('disabled', false).val("Save");
                    //        ClearControls();
                    //    });
                    //}
                    //else {
                    //    modelAlert("Error occurred, Please contact administrator", function () {
                    //        $('#btnSave').attr('disabled', false).val("Save");
                    //    });

                    //}
                }
            });
            ///  }
            //else
            //  modelAlert("Please Remove The Zero Rate Item Otherwise Enter The Rate of These Item");
            //Ajeet
        }

    }

    var SaveEntry = function () {
        var resultLT = LedgerTransaction();
        var resultLTD = LedgerTransactionDetail();
        var resultPLI = PatientLabInvestigationIPD();

        if (Number(resultLT[0].DiscountOnTotal) > 0) {

            if (String.isNullOrEmpty(resultLT[0].DiscountReason)) {
                modelAlert('Please Select Discount Reason.', function () {
                    $('#ddlDiscountReason').focus();
                });
                return false;
            }


            if (String.isNullOrEmpty(resultLT[0].DiscountApproveBy)) {
                modelAlert('Please Select Approve By.', function () {
                    $('#ddlDiscountApproveBy').focus();
                });
                return false;
            }
        }
        var ordId = "";
        var count = ""
        $("#GrdOrder input[type=checkbox]:checked").each(function () {
            if (count == 0) {
                ordId = this.value;

            } else {
                ordId = ordId + ',' + this.value;
            }
            count += count + 1;

        });

        $('#btnSave').attr('disabled', true).val("Submitting...");


        $.ajax({
            url: "Services/IPDLabPrescription.asmx/SaveIPDLabPrescription",
            data: JSON.stringify({ LT: resultLT, LTD: resultLTD, PLI: resultPLI, PatientTypeID: $('#spnPatientTypeID').text(), MembershipNo: $('#spnMembershipNo').text(), NotificationId: ordId }),
            type: "Post",
            contentType: "application/json; charset=utf-8",
            timeout: "120000",
            async: false,
            dataType: "json",
            success: function (result) {

                var responseData = JSON.parse(result.d);
                var btnSave = $('#btnSave');

                modelAlert(responseData.response, function () {

                    if (responseData.status)
                        window.location.reload();
                    else
                        $(btnSave).removeAttr('disabled').val('Save');

                });



                //OutPut = result.d;
                //if (result.d.split('#')[1] == 1) {
                //    modelAlert("Patient Barcode No. is : " + result.d.split('#')[0], function () {
                //        $('#btnSave').attr('disabled', false).val("Save");
                //        ClearControls();
                //    });
                //}
                //else {
                //    modelAlert("Error occurred, Please contact administrator", function () {
                //        $('#btnSave').attr('disabled', false).val("Save");
                //    });

                //}
            }
        });

    }



    var SaveMedicine = function () {
        //ajeet
        var ordId = "";
        var count = 0;
        $("#grdMedicine #chkSelect:checked").each(function () {
            if (count == 0) {
                ordId = this.value;

            } else {
                ordId = ordId + ',' + this.value;
            }
            count += count + 1;

        });
        $('#btnSave').text('Saving...').attr('disabled', 'disabled');
        
        var data = new Array();
        var Obj = new Object();
        jQuery("#tbSelected tr").each(function (i) {
            var id = jQuery(this).attr("id");
            var $rowid = jQuery(this).closest("tr");
            if (id != "LabHeader") {
                Obj.ItemID = jQuery.trim($rowid.find("#spnitemID").text());
                Obj.MedicineName = jQuery.trim($rowid.find("#spnItemName").text());
                Obj.Quantity = jQuery.trim($rowid.find("#spnQuantity").text());
                Obj.Dose = jQuery.trim($rowid.find("#spnDose").text());
                Obj.Time = jQuery.trim($rowid.find('#spnTime').text());
                Obj.Duration = jQuery.trim($rowid.find('#spnDuration').text());
                Obj.DurationValue = Number($rowid.find('#spnDurationValue').text());
                Obj.Route = jQuery.trim($rowid.find("#spnRoute").text());
                Obj.Meal = jQuery.trim($rowid.find("#spnMeal").text());
                Obj.TID = $('#spnTransactionID').text();
                Obj.PID = $('#spnPatientID').text();
                Obj.UnitType = jQuery.trim($rowid.find("#spnunitType").text());
                Obj.Dept = jQuery.trim($rowid.find("#tdspnDepartment").text());
                Obj.IndentType = jQuery.trim($rowid.find("#tdspnIndentType").text());
                Obj.DoctorID = jQuery.trim($rowid.find("#tdspnDoctorId").text());
                Obj.IPDCaseTypeID = $("#spnIPD_CaseTypeID").text();
                Obj.Room_ID = $("#spnRoom_ID").text();
                Obj.isDischargeMedicine = jQuery.trim($rowid.find("#tdspnisDischargeMedicine").text());
                data.push(Obj);
                Obj = new Object();
                  
            }
        });

        
        if (data.length > 0) {
            $.ajax({
                url: "Services/IPDLabPrescription.asmx/SaveIndent",
                data: JSON.stringify({ Data: data , NotificationId: ordId}),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    Data = result.d;
                    if (Data == "1") {
                        modelAlert('Record Saved Successfully', function () {
                            $closeIndentModel();
                            window.location.reload();
                        });
                    }
                    else {
                        $('#btnSave').text('Save').removeAttr('disabled');
                    }
                },
                error: function (xhr, status) {
                    modelAlert(status + "\r\n" + xhr.responseText);
                    $('#btnSave').text('Save').removeAttr('disabled');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }






    }



    function Validation() {
        var zerorateiten = 0
        $("#tbSelected tr").each(function () {
            var id = $(this).attr("id");
            var $rowid = $(this).closest("tr");
            if (id != "LabHeader") {
                var SCRequestdate = $.trim($rowid.find('.datepicker').val());
                var SCRequesttime = $.trim($rowid.find('#SCRequesttime').val());
                if (Number($rowid.find("#txtRate").val()) == 0 || $.trim($rowid.find("#txtRate").val()) == '') {
                    zerorateiten += 1;
                }
                if (SCRequestdate != '' && SCRequesttime == '') {
                    zerorateiten += 1;
                    count = 'Please select Sample request date or time';
                }
                if (SCRequestdate == '' && SCRequesttime != '') {
                    zerorateiten += 1;
                    count = 'Please select Sample request date or time';
                }
            }
        });
        if (zerorateiten > 0) {
            return false;
        }
        return true;
    }
    function ckhall(btn) {
        jQuery("#tblSetItem tr").each(function () {
            if ($("#chkheader").attr('checked')) {
                var id = jQuery(this).attr("id");
                var $rowid = jQuery(this).closest("tr");
                $(this).find(btn).attr('checked', true);
            }
            else {
                $(this).find(btn).attr('checked', false);
            }
        });
    }
    function LedgerTransaction() {
        var dataLT = new Array();
        var objLT = new Object();
        objLT.TypeOfTnx = "IPD-Lab";
        objLT.GrossAmount = $('#spnGrossAmount').text();
        objLT.DiscountOnTotal = $('#spnTotalDiscountAmount').text();
        objLT.NetAmount = $('#spnTotalNetAmount').text();
        objLT.PatientID = $('#spnPatientID').text();
        objLT.RoundOff = $('#spnTotalRoundOff').text();
        objLT.TransactionID = $('#spnTransactionID').text();
        objLT.PanelID = $('#spnPanelID').text();
        objLT.UniqueHash = $('#txtHash').val();
        objLT.PatientType = $('#spnPatientType').text();
        objLT.DiscountApproveBy = $.trim($('#ddlDiscountApproveBy option:selected').text());
        objLT.DiscountReason = $.trim($('#ddlDiscountReason option:selected').text());


        dataLT.push(objLT);
        return dataLT;
    }
    function LedgerTransactionDetail() {
        var dataLTD = new Array();
        var objLTD = new Object();
        $("#tbSelected tr").each(function () {
            var id = $(this).attr("id");
            var $rowid = $(this).closest("tr");
            if (id != "LabHeader") {
                objLTD.ItemID = $.trim($rowid.find("#tditemID").text());
                objLTD.Rate = $.trim($rowid.find("#txtRate").val());
                var depType = $("#rblLabDepartmentType").val();

                if (depType == 3 || depType == 5) {
                    objLTD.Quantity = $.trim($rowid.find("#spnQuantity").text());
                    objLTD.DiscAmt = parseFloat($.trim($rowid.find("#txtRate").val()) * parseFloat($.trim($rowid.find("#spnQuantity").text()))) * parseFloat($.trim($rowid.find("#txtDiscountPer").val()) / 100);

                } else {
                    objLTD.Quantity = $.trim($rowid.find("#spnQuantity").text());
                    objLTD.DiscAmt = parseFloat($.trim($rowid.find("#txtRate").val()) * parseFloat($.trim($rowid.find("#spnQuantity").text()))) * parseFloat($.trim($rowid.find("#txtDiscountPer").val()) / 100);

                }

                objLTD.Amount = $.trim($rowid.find("#txtAmount").val());
                objLTD.DiscountPercentage = $.trim($rowid.find("#txtDiscountPer").val());
                // objLTD.DiscAmt = parseFloat($.trim($rowid.find("#txtRate").val()) * parseFloat($.trim($rowid.find("#spnQuantity").text()))) * parseFloat($.trim($rowid.find("#txtDiscountPer").val()) / 100);
                objLTD.IsVerified = 1;
                objLTD.SubCategoryID = $.trim($rowid.find("#spnSubCategoryID").text());
                if ($.trim($rowid.find("#ItemCode").text()) == "")
                    objLTD.ItemName = $.trim($rowid.find("#ItemName").text());
                else
                    objLTD.ItemName = $.trim($rowid.find("#ItemName").text()) + " (" + $.trim($rowid.find("#ItemCode").text()) + ")";
                objLTD.TransactionID = $('#spnTransactionID').text();
                objLTD.EntryDate = $.trim($rowid.find("#spnDate").text());
                objLTD.DoctorID = $.trim($rowid.find("#tdspnDoctorId").text()); //jQuery('#ddlDoctor').val();
                objLTD.ConfigID = $.trim($rowid.find("#tdConfigRelation").text());
                if ($rowid.find("#chkPayable").is(':checked'))
                    objLTD.IsPayable = 1;
                else
                    objLTD.IsPayable = 0;
                objLTD.TotalDiscAmt = 0;
                objLTD.NetItemAmt = $('#spnGrossAmount').text();
                objLTD.IPDCaseTypeID = $('#spnIPD_CaseTypeID').text();
                var RateListID = 0;
                if ($.trim($rowid.find("#spnRateListID").text()) != "")
                    RateListID = $.trim($rowid.find("#spnRateListID").text());
                objLTD.RateListID = RateListID;
                objLTD.RoomID = $.trim($('#spnRoom_ID').text());
                objLTD.CoPayPercent = $.trim($rowid.find('#spncopayment').text());
                objLTD.rateItemCode = $.trim($rowid.find('#ItemCode').text());
                objLTD.typeOfTnx = "IPD-Lab";
                objLTD.SCRequestdatetime = $.trim($rowid.find('.datepicker').val());
                dataLTD.push(objLTD);
                objLTD = new Object();
            }

        });
        return dataLTD;
    }


    function PatientLabInvestigationIPD() {
        var dataPLI = new Array();
        var objPLI = new Object();
        $("#tbSelected tr").each(function () {
            var id = $(this).attr("id");
            var $rowid = $(this).closest("tr");
            var date = $.trim($rowid.find('.datepicker').val());
            var time = $.trim($rowid.find('#SCRequesttime').val());
            var datetime = date + ' ' + time;
            if (id != "LabHeader") {
                objPLI.Investigation_ID = $.trim($rowid.find('#spnInvestigationID').text());
                if ($.trim($rowid.find("#spnSampleRequired").text()) == "R")
                    objPLI.IsSampleCollected = "N";
                else
                    objPLI.IsSampleCollected = "Y";
                objPLI.Remarks = $.trim($rowid.find("#txtRemarks").val());
                if ($rowid.find("#chkUrgentItem").is(':checked'))
                    objPLI.IsUrgent = 1;
                else
                    objPLI.IsUrgent = 0;
                objPLI.IsOutSource = $.trim($rowid.find("#spnOutSource").text());
                objPLI.OutSourceLabID = $.trim($rowid.find("#spnOutSourcelabID").text());
                objPLI.CurrentAge = $('#spnage').text();
                objPLI.SCRequestdatetime = datetime;
                dataPLI.push(objPLI);
                objPLI = new Object();
            }
        });
        return dataPLI;
    }
    var count = '';
    function bindHashCode() {
        jQuery('#txtHash').val('');
        jQuery.ajax({
            url: "../Common/CommonService.asmx/bindHashCode",
            data: '{}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                jQuery('#txtHash').val(result.d);
            },
            error: function (xhr, status) {
            }
        });
    }


    function CheckDuplicateItem(ItemID) {
        var count = 0;
        $('#tbSelected tr:not(#LabHeader)').each(function () {
            var item = $(this).find('#tditemID').text().trim();
            if ($(this).find('#tditemID').text().trim() == ItemID) {
                count = count + 1;
            }
        });
        if (count == 0)
            return false;
        else
            return true;
    }


    function bindRate() {
        var totalGAmount = 0;
        var totalDAmount = 0;
        var totalNAmount = 0;
        var totalNRoundoff = 0;
        $('#tbSelected tr').each(function () {
            var id = $(this).closest("tr").attr("id");
            if (id != "LabHeader") {
                var Grossamount = parseFloat(parseFloat($(this).closest('tr').find("#txtRate").val()) * parseFloat($(this).closest('tr').find("#spnQuantity").text()));
                var DiscountAmount = parseFloat(((parseFloat(Grossamount) * parseFloat($(this).closest('tr').find("#txtDiscountPer").val()) / 100)));
                var NetAmount = Grossamount - DiscountAmount;
                totalGAmount = totalGAmount + Grossamount;
                totalDAmount = totalDAmount + DiscountAmount;
                totalNAmount = totalNAmount + NetAmount;
                $('#spnGrossAmount').text(totalGAmount);
                $('#spnTotalDiscountAmount').text(totalDAmount);
                $('#spnTotalNetAmount').text(precise_round(totalNAmount, 2));
                $('#spnTotalRoundOff').text(precise_round(Math.round(totalNAmount) - totalNAmount, 2))
                if (totalGAmount >= 0) {
                    ('#divTotalAmt').show();
                    $('#divSave').show();
                }
                else {
                    $('#divTotalAmt').hide();
                    $('#divSave').hide();
                }
            }
        });




        if (totalDAmount > 0) {
            $('.divDiscountReason').find('select').val('0');
            $('.divDiscountReason').show()
        }
        else {

            $('.divDiscountReason').find('select').val('0');
            $('.divDiscountReason').hide();
        }


        $('#lblTotalLabItemsCount').text('Count : ' + $('#tbSelected tr:not(#LabHeader)').length);
    }
    function RemoveRows(rowid) {
        if ($("#grdPaymentMode tr").length > 1) {
            return;
        }
        $(rowid).closest('tr').remove();
        if ($('#tbSelected tr:not(#LabHeader)').length == 0) {
            $('#tbSelected').hide();
            $('#spnGrossAmount,#spnTotalDiscountAmount,#spnTotalNetAmount,#spnTotalRoundOff').text('');
            $('#divTotalAmt').hide();
            $('#divSave').hide();
        }
        bindRate();
        $("#spnErrorMsg").text('');
    }

    function checkNumeric(e, sender) {
        var charCode = (e.which) ? e.which : e.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        if (sender.value == "0") {
            sender.value = sender.value.substring(0, sender.value.length - 1);
        }
        strLen = sender.value.length;
        strVal = sender.value;
        hasDec = false;
        e = (e) ? e : (window.event) ? event : null;
        if (e) {
            var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
            if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                for (var i = 0; i < strLen; i++) {
                    hasDec = (strVal.charAt(i) == '.');
                    if (hasDec)
                        return false;
                }
            }
        }
        return true;
    }
    function checkNumericDecimal(e, sender) {
        var charCode = (e.which) ? e.which : e.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }

        if (charCode == 13) {
            e.preventDefault();
            AddItem();
        }
    }
    function Rate(rowid) {
        var DiscPer = $(rowid).closest('tr').find("#txtDiscountPer").val() == "" ? 0 : Number($(rowid).closest('tr').find("#txtDiscountPer").val());
        if (DiscPer > 100) {
            modelAlert("Please Enter Valid Discount Per, Only 100 Per Discount Allowed.", function () { $(rowid).closest('tr').find("#txtDiscountPer").val(0) });
            return;
        }
        var qty = $(rowid).closest('tr').find("#spnQuantity").val();
        var rate = $(rowid).closest('tr').find("#txtRate").val();
        var DigitsAfterDecimal = 2;
        var rateIndex = rate.indexOf(".");
        if (rateIndex > "0") {
            if (rate.length - (rate.indexOf(".") + 1) > DigitsAfterDecimal) {
                modelAlert("Please Enter Valid Rate, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                $(rowid).closest('tr').find("#txtRate").val($(rowid).closest('tr').find("#txtRate").val().substring(0, ($(rowid).closest('tr').find("#txtRate").val().length - 1)))
            }
        }
        if (isNaN(qty) || qty == "") {
            qty = 1;
            Number($(rowid).closest('tr').find("#spnQuantity").val(qty));
        }
        if (isNaN(rate) || rate == "") {
            rate = 0;
            Number($(rowid).closest('tr').find("#txtRate").val(0));
        }
        Number($(rowid).closest('tr').find("#txtAmount").val(parseFloat(qty * rate) - (parseFloat(qty * rate) * parseFloat(DiscPer / 100))));
        bindRate();
    }
    function bindRate() {

        var totalGAmount = 0;
        var totalDAmount = 0;
        var totalNAmount = 0;
        var totalNRoundoff = 0;
        $('#tbSelected tr').each(function () {
            var id = $(this).closest("tr").attr("id");

            if (id != "LabHeader") {

                var Grossamount = parseFloat(parseFloat($(this).closest('tr').find("#txtRate").val()) * parseFloat($(this).closest('tr').find("#spnQuantity").text()));
                var DiscountAmount = parseFloat(((parseFloat(Grossamount) * parseFloat($(this).closest('tr').find("#txtDiscountPer").val()) / 100)));
                var NetAmount = Grossamount - DiscountAmount;
                totalGAmount = totalGAmount + Grossamount;
                totalDAmount = totalDAmount + DiscountAmount;
                totalNAmount = totalNAmount + NetAmount;


                $('#spnGrossAmount').text(totalGAmount);
                $('#spnTotalDiscountAmount').text(totalDAmount);
                $('#spnTotalNetAmount').text(precise_round(totalNAmount, 2));
                $('#spnTotalRoundOff').text(precise_round(Math.round(totalNAmount) - totalNAmount, 2))
                if (totalGAmount >= 0) {
                    var depType = $("#rblLabDepartmentType").val();
                    if (depType == 3 || depType == 5) {
                        $('#divTotalAmt').show();
                        $('#divSave').show();
                    }
                }
                else {
                    $('#divTotalAmt').hide();
                    $('#divSave').hide();
                }
            }
        });
        $('#lblTotalLabItemsCount').text('Count : ' + $('#tbSelected tr:not(#LabHeader)').length);

        if (totalDAmount > 0) {
            $('.divDiscountReason').find('select').val('0');
            $('.divDiscountReason').show()
        }
        else {

            $('.divDiscountReason').find('select').val('0');
            $('.divDiscountReason').hide();
        }




    }



    function btnhideShowAck() {
        var field = 'IsView';
        var url = window.location.href;
        var IsView = "0";
        if (url.indexOf('?' + field + '=') != -1) {
            IsView = "1";
        }
        else if (url.indexOf('&' + field + '=') != -1) {
            IsView = "1";

        }

        if (IsView == "1") {
            $("#btnAck").show();
        } else {
            $("#btnAck").hide();
        }

    }

    function AckbyNurse() {
        var ordId = "";
        var count = ""

        $("#grdMedicine #chkAck:checked").each(function () {
            if (count == 0) {
                ordId = this.value;

            } else {
                ordId = ordId + ',' + this.value;
            }
            count = count + 1;

        });

        if (ordId != "") {
            serverCall('Orders.aspx/ViewOrders', { Id: ordId }, function (response) {
                var responsedata = JSON.parse(response);
                modelAlert(responsedata.response, function () {
                    if (responsedata.status) {
                        window.location.reload();
                    }
                })

            });
        } else {
            modelAlert("Select Orders to Acknowledge.")
        }

    }

    var openApproveModel = function () { 
        var ordId = "";
        var count = ""

        $("#grdMedicine #chkSelectToApprove:checked").each(function () {
            if (count == 0) {
                ordId = this.value;

            } else {
                ordId = ordId + ',' + this.value;
            }
            count = count + 1;

        });

        if (ordId == "" || ordId == undefined || ordId == '' || ordId == null || ordId=="0") {

            modelAlert("Select Orders to Approved. ");
            return false;
        }

        $("#lblOrderIdToApprove").text(ordId);
        $("#modelApproved").showModel();
    }

    var $closeApproveModel = function () {
        $("#modelApproved").hideModel();
        $('#lblOrderIdToApprove').text("");
    }



    

    function ApproveOrderOfStudent() {

        var ordId= $("#lblOrderIdToApprove").text();
        var Comment = $("#txtComment").val();
        var IsApprovd = $('#chkIsApprovd').is(':checked');
        var Approve=2;
        if (IsApprovd) {
            Approve = 1;
        }
       
        serverCall('Orders.aspx/ApproveOrder', { Id: ordId, ApprovedRemark: Comment, isApproved: Approve }, function (response) {
            var responsedata = JSON.parse(response);
            modelAlert(responsedata.response, function () {
                if (responsedata.status) {
                    window.location.reload();
                }
            })

        });
    }

    </script>

</body>
</html>
