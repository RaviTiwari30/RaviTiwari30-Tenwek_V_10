<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="OverTime.aspx.cs" Inherits="Design_Payroll_OverTime" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">

        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
        function CalOverTime_Days() {
            try {
                var GrossSalary = (document.getElementById('<%=lblBasic.ClientID %>').innerHTML);
                var MonthDays = document.getElementById('<%=LblMonthInDaysD.ClientID %>').innerHTML;
                var NoOfOverTimeDays = document.getElementById('<%=txtOverTime.ClientID %>').value;

                var OverTime = (eval(GrossSalary) / eval(MonthDays)) * eval(NoOfOverTimeDays);
                document.getElementById('<%=txtOverTimeAmountD.ClientID %>').value = Math.round(OverTime * 100) / 100;
                var OverTimeAmountD = document.getElementById('<%=txtOverTimeAmountD.ClientID %>').value;
                var WorkedDays = $("#<%=lblWorkedDays.ClientID %>").text();
                var WorkingHours = $("#<%=lblWorkingHours.ClientID %>").text();
                var DailyBasicSalary = (eval(GrossSalary) / eval(WorkedDays));
                var CalBasicSalary = (eval(NoOfOverTimeDays) * eval(DailyBasicSalary));
                $("#<%=txtOverTimeAmountD.ClientID %>").val(parseFloat(CalBasicSalary).toFixed(2));
                var OverTimeAmountHNew = $("#<%=txtOverTimeAmountD.ClientID %>").val();
                if (eval(OverTimeAmountHNew) > eval(GrossSalary / 2)) {
                    $("#<%=txtOverTaxD.ClientID %>").val(parseFloat((OverTimeAmountHNew * 10) / 100).toFixed(2));
                    $("#<%=txtNetPayD.ClientID %>").val(parseFloat((OverTimeAmountHNew) - $("#<%=txtOverTaxD.ClientID %>").val()).toFixed(2));

                }
                else {
                    $("#<%=txtOverTaxD.ClientID %>").val(parseFloat((OverTimeAmountHNew * 5) / 100).toFixed(2));
                    $("#<%=txtNetPayD.ClientID %>").val(parseFloat((OverTimeAmountHNew) - $("#<%=txtOverTaxD.ClientID %>").val()).toFixed(2));

                }
                if ($.trim($("#<%=txtOverTime.ClientID %>").val()) == "") {
                    $("#<%=txtOverTaxD.ClientID %>").val('');
                    $("#<%=txtOverTimeAmountD.ClientID %>").val('');
                    $("#<%=txtNetPayD.ClientID %>").val('');
                }
            }
            catch (e) {

            }
        }
        function CalOverTime_Hours() {
            try {
                var GrossSalary = (document.getElementById('<%=lblBasic.ClientID %>').innerHTML);
                var MonthDays = document.getElementById('<%=lblDayInMonthH.ClientID %>').innerHTML;
                var HoursInDays = document.getElementById('<%=lblWorkingHours.ClientID %>').innerHTML;
                var NoOfOverTimeHours = document.getElementById('<%=txtOverTimeHours.ClientID %>').value;

                var OverTime = ((eval(GrossSalary) / eval(MonthDays)) / eval(HoursInDays)) * eval(NoOfOverTimeHours);

                document.getElementById('<%=txtOverTimeAmountH.ClientID %>').value = Math.round(OverTime * 100) / 100;
                var OverTimeAmountH = document.getElementById('<%=txtOverTimeAmountH.ClientID %>').value;

                var WorkedDays = $("#<%=lblWorkedDays.ClientID %>").text();
                var WorkingHours = $("#<%=lblWorkingHours.ClientID %>").text();
                var DailyBasicSalary = (eval(GrossSalary) / eval(WorkedDays));
                var HourlySalary = (eval(DailyBasicSalary)) / (eval(WorkingHours));
                $("#<%=txtOverTimeAmountH.ClientID %>").val(parseFloat(eval(NoOfOverTimeHours) * eval(HourlySalary)).toFixed(2));
                var OverTimeAmountHNew = $("#<%=txtOverTimeAmountH.ClientID %>").val();

                if (eval(OverTimeAmountHNew) > eval(GrossSalary / 2)) {
                    $("#<%=txtOverTimeTaxH.ClientID %>").val(parseFloat((OverTimeAmountHNew * 10) / 100).toFixed(2));
                    $("#<%=txtNetPayH.ClientID %>").val(parseFloat((OverTimeAmountHNew) - $("#<%=txtOverTimeTaxH.ClientID %>").val()).toFixed(2));
                }
                else {
                    $("#<%=txtOverTimeTaxH.ClientID %>").val(parseFloat((OverTimeAmountHNew * 5) / 100).toFixed(2));
                    $("#<%=txtNetPayH.ClientID %>").val(parseFloat((OverTimeAmountHNew) - $("#<%=txtOverTimeTaxH.ClientID %>").val()).toFixed(2));
                }
                if ($.trim($("#<%=txtOverTimeHours.ClientID %>").val()) == "") {
                    $("#<%=txtOverTimeTaxH.ClientID %>").val('');
                    $("#<%=txtOverTimeAmountH.ClientID %>").val('');
                    $("#<%=txtNetPayH.ClientID %>").val('');
                }
            }
            catch (e) {

            }
        }
        function HidePopup() {
            $find('mpeCreateGroup').hide();
            $find('<%=TabContainer1.ClientID%>').set_activeTabIndex(1);
        }
        $(document).ready(function () {
            var modalPopup = $find("mpeCreateGroup");
            if (modalPopup != null) {
            }

            $("#<%= txtOverTimeHours.ClientID %>").bind("blur keyup keydown", function (e) {
                if ($(this).val().charAt(0) == ".") {
                    $(this).val('0.');
                    return false;
                }
                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum;
                if (window.event) {
                    keynum = e.keyCode;
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which;
                }
                if (keycode == 8) { // backspace
                    if ($("#<%= txtOverTimeHours.ClientID %>").val() == "0.") {
                        $(this).val('');
                        $("#<%=txtOverTimeAmountH.ClientID %>").val('');
                        $("#<%=txtOverTimeTaxH.ClientID %>").val('');
                        return false;
                    }
                }

                if (keycode == 46) { // delete
                    if ($("#<%= txtOverTimeHours.ClientID %>").val() == "0.") {
                        $(this).val('');
                        $("#<%=txtOverTimeAmountH.ClientID %>").val('');
                        $("#<%=txtOverTimeTaxH.ClientID %>").val('');
                        return false;
                    }
                }
                if ($(this).val() == "") {
                    $("#<%=txtOverTimeAmountH.ClientID %>").val('');
                    $("#<%=txtOverTimeTaxH.ClientID %>").val('');

                }
            });
            $("#<%= txtOverTime.ClientID %>").bind("blur keyup keydown", function (e) {
                if ($(this).val().charAt(0) == ".") {
                    $(this).val('0.');
                    return false;
                }
                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum;
                if (window.event) {
                    keynum = e.keyCode;
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which;
                }
                if (keycode == 8) { // backspace
                    if ($("#<%= txtOverTime.ClientID %>").val() == "0.") {
                        $(this).val('');
                        $("#<%=txtOverTaxD.ClientID %>").val('');
                        $("#<%=txtOverTimeAmountD.ClientID %>").val('');
                        return false;
                    }
                }

                if (keycode == 46) { // delete
                    if ($("#<%= txtOverTime.ClientID %>").val() == "0.") {
                        $(this).val('');
                        $("#<%=txtOverTaxD.ClientID %>").val('');
                        $("#<%=txtOverTimeAmountD.ClientID %>").val('');
                        return false;
                    }
                }

                if ($(this).val() == "") {
                    $("#<%=txtOverTaxD.ClientID %>").val('');
                    $("#<%=txtOverTimeAmountD.ClientID %>").val('');
                    $("#<%=txtNetPayD.ClientID %>").val('');
                }
            });
        });
        function TabChange() {
            var tabContainer = $find("<%=TabContainer1.ClientID%>");
            var i = tabContainer._activeTabIndex;
            if (i == '1') {
                // $("#<%=txtOverTimeHours.ClientID%>").focus();
                //  document.getElementById('<%= txtOverTimeHours.ClientID %>').focus().focus();
                $("#<%=lblmsgpopup.ClientID%>").text('');
                return;
            }
            if (i == '0') {
                $("#<%=lblmsgpopup.ClientID%>").text('');

                return;
            }
        }
        //        function RegisteredUser1_TabCliked(sender, e) {
        //            var tabContainer = $get("<%=TabContainer1.ClientID%>");
        //            var i = tabContainer._activeTabIndex;

        //            if (i == '1') {
        //                alert('hi');
        //                var OverTimeHours = $get('<%=txtOverTimeHours.ClientID%>');
        //                            OverTimeHours.focus();
        //                return;
        //            }
        //            if (i == '0') {
        //                alert('hii');
        //                var OverTime = $get('<%=txtOverTime.ClientID%>');
        //                OverTime.focus();
        //                return;
        //            }
        //        }
        function RegisteredUser1_TabCliked(sender, e) {
            var UserName_Control = $get('<%=txtOverTimeHours.ClientID%>');
            UserName_Control.focus();
        }
        function RegisteredUser2_TabCliked(sender, e) {
            var UserName_Control1 = $get('<%=txtOverTime.ClientID%>');
            UserName_Control1.focus();
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {

            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpeCreateGroup")) {
                    $find("mpeCreateGroup").hide();
                }
            }
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
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
        function ValidateHours() {
            if (typeof (Page_Validators) == "undefined") return;
            var OverTimeHours = document.getElementById("<%=reqOverTimeHours.ClientID%>");
            var OverTimeAmountH = document.getElementById("<%=reqOverTimeAmountH.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopup.ClientID%>");
            ValidatorValidate(OverTimeHours);
            if (!OverTimeHours.isvalid) {
                LblName.innerText = OverTimeHours.errormessage;
                return false;
            }
            ValidatorValidate(OverTimeAmountH);
            if (!OverTimeAmountH.isvalid) {
                LblName.innerText = OverTimeAmountH.errormessage;
                return false;
            }
            //            if ($("#<%=txtOverTimeHours.ClientID %>").val() == "") {
            //                $("#<%=txtOverTimeHours.ClientID %>").focus();
            //                $("#<%=lblmsgpopup.ClientID %>").text('Enter');
            //                return false;
            //            }
            //            if ($("#<%=txtOverTimeAmountH.ClientID %>").val() == "") {
            //                $("#<%=txtOverTimeAmountH.ClientID %>").focus();
            //                return false;
            //            }
        }
        function Validatedays() {
            if (typeof (Page_Validators) == "undefined") return;
            var OverTimeAmountD = document.getElementById("<%=reqOverTimeAmountD.ClientID%>");
            var OverTimeD = document.getElementById("<%=reqOverTime.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopup.ClientID%>");
            ValidatorValidate(OverTimeAmountD);
            if (!OverTimeAmountD.isvalid) {
                LblName.innerText = OverTimeAmountD.errormessage;
                return false;
            }
            ValidatorValidate(OverTimeD);
            if (!OverTimeD.isvalid) {
                LblName.innerText = OverTimeD.errormessage;
                return false;
            }
            //            if ($("#<%=txtOverTimeAmountD.ClientID %>").val() == "") {
            //                $("#<%=txtOverTimeAmountD.ClientID %>").focus();
            //                return false;
            //            }
            //            if ($("#<%=txtOverTime.ClientID %>").val() == "") {
            //                $("#<%=txtOverTime.ClientID %>").focus();
            //                return false;
            //            }
        }
    </script>
    <script type="text/javascript" >

        //         var control;
        //         function getControl_TabClicked1(sender, e) {
        //             control = $get('<%=txtOverTime.ClientID%>');
        //             alert(control);
        //         }

        //         function getControl_TabClicked2(sender, e) {
        //             control = $get('<%=txtOverTimeHours.ClientID%>');
        //         }
        //

        //         function setFocus(sender, e) {
        //             control.TrackFocus();
        //         }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sc" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Over Time </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 21%; height: 11px;" align="right">Employee ID :&nbsp;
                    </td>
                    <td style="width: 18%; height: 11px;">
                        <asp:TextBox ID="txtEmpID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID"></asp:TextBox>
                    </td>
                    <td style="width: 20%; height: 11px;" align="right">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 11px;">
                        <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name"></asp:TextBox>
                    </td>
                    <td style="width: 25%; height: 11px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;" align="right">Salary Month :&nbsp;
                    </td>
                    <td style="width: 18%; height: 18px;">
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                    </td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%"></td>
                    <td style="width: 18%"></td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                            TabIndex="3" ToolTip="Click to Search" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Panel ID="pnl" runat="server" ScrollBars="Vertical" Height="400">
                <table border="0" style="width: 500">
                    <tr>
                        <td align="center" colspan="5">
                            <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowCommand="EmpGrid_RowCommand">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Employee_ID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FatherName" HeaderText="Father Name" Visible="false" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DOJ" HeaderText="D.O.J." ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Select">
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbSelect" ToolTip="Click to Select" runat="server" ImageUrl="~/Images/Post.gif"
                                                CausesValidation="false" CommandArgument='<%# Eval("Employee_ID")%>' CommandName="Select" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
    </div>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnHidden" BehaviorID="mpeCreateGroup">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none">
        <div id="dragUpdate" runat="server" class="Purchaseheader">
            <b>Employee Detail </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Press esc
            to close
            <asp:ImageButton ID="btnClose" runat="server" ImageUrl="~/Images/Delete.gif" ToolTip="Close"
                Style="display: none" />
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 658px">
            <tr>
                <td style="height: 16px;" align="center" colspan="4">
                    <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" style="width: 658px">
            <tr>
                <td style="width: 10%; height: 16px;" align="right">Employee&nbsp;ID :&nbsp;
                </td>
                <td style="width: 30%; height: 16px;" align="left">
                    <asp:Label ID="lblEmpID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td style="width: 10%; height: 16px;" align="right">Employee&nbsp;Name :&nbsp;
                </td>
                <td style="width: 30%; height: 16px;" align="left">
                    <asp:Label ID="lblEmpName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 10%; height: 16px">Department :&nbsp;
                </td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:Label ID="lblDept" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td align="right" style="width: 10%; height: 16px">Designation :&nbsp;
                </td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:Label ID="lblDesi" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 10%; height: 16px">Date&nbsp;Of&nbsp;Joining :&nbsp;
                </td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:Label ID="lblDOJ" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td align="right" style="width: 10%; height: 16px">Father&nbsp;Name :&nbsp;
                </td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:Label ID="lblFatherName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 10%; height: 16px">Basic :&nbsp;
                </td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:Label ID="lblBasic" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td align="right" style="width: 10%; height: 16px">Worked Days :&nbsp;
                </td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:Label ID="lblWorkedDays" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 10%; height: 4px"></td>
                <td align="left" style="width: 30%; height: 4px"></td>
                <td align="left" style="width: 10%; height: 4px">
                    <asp:Label ID="lblTypeName" Visible="false" runat="server"></asp:Label>
                </td>
                <td align="left" style="width: 30%; height: 4px"></td>
            </tr>
        </table>
        <div id="Div1" runat="server" class="Purchaseheader">
            <b>Over Time </b>
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 658px">
            <tr>
                <td align="center" style="height: 16px" colspan="4">
                    <asp:Panel ID="pnlArrear" runat="server" Width="750" Height="200px" ScrollBars="auto">
                        <cc1:TabContainer ActiveTabIndex="0" ID="TabContainer1" runat="server" Width="500px"
                            Height="150px" OnClientActiveTabChanged="TabChange">
                            <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="TabPanel1" OnClientPopulated="RegisteredUser1_TabCliked">
                                <HeaderTemplate>
                                    <b style="font-size: 12px">Days&nbsp;</b>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <table cellpadding="0" cellspacing="0" style="width: 458px">
                                        <tr>
                                            <td align="right">Month In Days :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:Label ID="LblMonthInDaysD" runat="server" Font-Names="Verdana" Font-Size="10pt"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Days :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtOverTime" MaxLength="4" ToolTip="Enter Over Time Days" TabIndex="1"
                                                    AutoCompleteType="Disabled" Width="100px" runat="server" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                                <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <cc1:FilteredTextBoxExtender ID="f1" runat="server"
                                                    FilterType="Custom, Numbers" TargetControlID="txtOverTime"
                                                    Enabled="True" ValidChars=".">
                                                </cc1:FilteredTextBoxExtender>
                                                <asp:RequiredFieldValidator ID="reqOverTime" runat="server" ControlToValidate="txtOverTime"
                                                    Display="None" ErrorMessage="Enter Over Time Days" SetFocusOnError="True" ValidationGroup="DaysOverTime"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Amount :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtOverTimeAmountD" runat="server" AutoCompleteType="Disabled" ReadOnly="True"
                                                    Width="100px"></asp:TextBox>
                                                <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <asp:RequiredFieldValidator ID="reqOverTimeAmountD" runat="server" Display="None"
                                                    SetFocusOnError="True" ValidationGroup="DaysOverTime" ControlToValidate="txtOverTimeAmountD"
                                                    ErrorMessage="Enter Over Time Amount"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Tax Amount :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtOverTaxD" runat="server" AutoCompleteType="Disabled" ReadOnly="True"
                                                    Width="100px"></asp:TextBox>
                                                <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <asp:RequiredFieldValidator ID="reqOverTaxD" runat="server" Display="None" SetFocusOnError="True"
                                                    ValidationGroup="DaysOverTime" ControlToValidate="txtOverTaxD" ErrorMessage="Enter Over Time Tax Amount"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Net Pay :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtNetPayD" runat="server" AutoCompleteType="Disabled" ReadOnly="True"
                                                    Width="100px"></asp:TextBox>
                                                <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <asp:RequiredFieldValidator ID="reqNetPayD" runat="server" Display="None"
                                                    SetFocusOnError="True" ValidationGroup="DaysOverTime" ControlToValidate="txtNetPayD"
                                                    ErrorMessage="Enter Over Time Net Pay"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Actual OverTime Hrs :&nbsp;</td>
                                            <td align="left">
                                                <asp:TextBox ID="txtActualOverTimeHrsD" runat="server"
                                                    AutoCompleteType="Disabled" Width="100px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left"></td>
                                            <td align="left">
                                                <asp:Button ID="btnDaysOverTime" ValidationGroup="DaysOverTime" runat="server" Text="Save"
                                                    ToolTip="Click to Save" OnClick="btnDaysOverTime_Click" CssClass="ItDoseButton"
                                                    OnClientClick="return Validatedays();" />&nbsp;
                                                <input id="btnClose1" type="button" value="Close" onclick="HidePopup();" class="ItDoseButton"/>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </cc1:TabPanel>
                            <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="TabPanel2" Width="500px"
                                OnClientPopulated="RegisteredUser2_TabCliked">
                                <HeaderTemplate>
                                    <b style="font-size: 12px">Hours</b>
                                </HeaderTemplate>
                                <ContentTemplate>
                                    <table style="width: 458px" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td align="right">Working Hours :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:Label ID="lblWorkingHours" runat="server" Font-Names="Verdana" Font-Size="10pt"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Day In Month :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:Label ID="lblDayInMonthH" runat="server" Font-Names="Verdana" Font-Size="10pt"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Hours :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtOverTimeHours" MaxLength="6" ToolTip="Enter Over Time Hours"
                                                    TabIndex="1" class="OverTimeHours" AutoCompleteType="Disabled" Width="100px"
                                                    runat="server" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                                <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                                                    TargetControlID="txtOverTimeHours" ValidChars="." Enabled="True">
                                                </cc1:FilteredTextBoxExtender>
                                                <asp:RequiredFieldValidator ID="reqOverTimeHours" runat="server" ControlToValidate="txtOverTimeHours"
                                                    Display="None" ErrorMessage="Enter Over Time Hours" SetFocusOnError="True" ValidationGroup="HoursOverTime"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Amount :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtOverTimeAmountH" ReadOnly="true" runat="server" AutoCompleteType="Disabled"
                                                    Width="100px"></asp:TextBox>
                                                <asp:Label ID="lblV1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <asp:RequiredFieldValidator ID="reqOverTimeAmountH" runat="server" ControlToValidate="txtOverTimeAmountH"
                                                    Display="None" ErrorMessage="Enter Over Time Amount" SetFocusOnError="True" ValidationGroup="HoursOverTime"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Tax Amount :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtOverTimeTaxH" runat="server" AutoCompleteType="Disabled" ReadOnly="True"
                                                    Width="100px"></asp:TextBox>
                                                <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <asp:RequiredFieldValidator ID="reqOverTimeTaxH" runat="server" Display="None" SetFocusOnError="True"
                                                    ValidationGroup="HoursOverTime" ControlToValidate="txtOverTimeTaxH" ErrorMessage="Enter Over Time Tax Amount"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Over Time Net Pay :&nbsp;
                                            </td>
                                            <td align="left">
                                                <asp:TextBox ID="txtNetPayH" runat="server" AutoCompleteType="Disabled" ReadOnly="True"
                                                    Width="100px"></asp:TextBox>
                                                <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="None"
                                                    SetFocusOnError="True" ValidationGroup="HoursOverTime" ControlToValidate="txtNetPayH"
                                                    ErrorMessage="Enter Over Time Net Pay"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">Actual OverTime Hrs :&nbsp;</td>
                                            <td align="left">
                                                <asp:TextBox ID="txtActualOverTimeHrsH" runat="server"
                                                    AutoCompleteType="Disabled" Width="100px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left">
                                                <br />
                                            </td>
                                            <td align="left">
                                                <asp:Button ID="btnHoursOverTime" ValidationGroup="HoursOverTime" runat="server"
                                                    CssClass="ItDoseButton" Text="Save" OnClick="btnHoursOverTime_Click" OnClientClick="return ValidateHours();"
                                                    ToolTip="Click to Save" />&nbsp;<input id="btnClose2" type="button" value="Close"
                                                        onclick="HidePopup();" class="ItDoseButton"/>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </cc1:TabPanel>
                        </cc1:TabContainer>
                    </asp:Panel>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
</asp:Content>