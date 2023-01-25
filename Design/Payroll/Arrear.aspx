<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Arrear.aspx.cs" Inherits="Design_Payroll_Arrear" %>

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
        function HidePopup() {
            $find('mpeCreateGroup').hide();
            $find('<%=TabContainer1.ClientID%>').set_activeTabIndex(1);
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
        $(document).ready(function () {
            var MaxLength = 100;

            $("#<% =txtSalnarration.ClientID %>,#<%=txtNarration.ClientID %>").bind("cut copy paste", function (event) {

                event.preventDefault();
            });

            $('#<%=txtSalnarration.ClientID%>,#<%=txtNarration.ClientID %>').bind("keypress", function (e) {
                // For Internet Explorer
                if (window.event) {
                    keynum = e.keyCode
                }

                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }

                }
            });
        });
        function validateSalary() {
            if (typeof (Page_Validators) == "undefined") return;
            var SalPayableDays = document.getElementById("<%=reqSalPayableDays.ClientID%>");
            var Narration = document.getElementById("<%=reqNarration.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopup.ClientID%>");
            ValidatorValidate(SalPayableDays);
            if (!SalPayableDays.isvalid) {
                LblName.innerText = SalPayableDays.errormessage;
                return false;
            }
            ValidatorValidate(Narration);
            if (!Narration.isvalid) {
                LblName.innerText = Narration.errormessage;
                return false;
            }
        }

        function validateInc() {
            if (typeof (Page_Validators) == "undefined") return;
            var IncrementAmount = document.getElementById("<%=reqIncrementAmount.ClientID%>");
            var payableDays = document.getElementById("<%=reqpayableDays.ClientID%>");
            var NarrationIn = document.getElementById("<%=reqNarrationIn.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopup.ClientID%>");
            ValidatorValidate(IncrementAmount);
            if (!IncrementAmount.isvalid) {
                LblName.innerText = IncrementAmount.errormessage;
                return false;
            }
            ValidatorValidate(payableDays);
            if (!payableDays.isvalid) {
                LblName.innerText = payableDays.errormessage;
                return false;
            }
            ValidatorValidate(NarrationIn);
            if (!NarrationIn.isvalid) {
                LblName.innerText = NarrationIn.errormessage;
                return false;
            }
        }
        function TabChange() {
            var tabContainer = $find("<%=TabContainer1.ClientID%>");
            var i = tabContainer._activeTabIndex;
            if (i == '1') {
                $("#<%=lblmsgpopup.ClientID%>").text('');
                return;
            }
            if (i == '0') {
                $("#<%=lblmsgpopup.ClientID%>").text('');
                return;
            }
        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)

            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == "." || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>BackPay </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 21%; " align="right">Employee ID :&nbsp;
                    </td>
                    <td style="width: 18%; ">
                        <asp:TextBox ID="txtEmpID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID" onkeypress="return check(event);"></asp:TextBox>
                    </td>
                    <td style="width: 20%; " align="right">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; ">
                        <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name" onkeypress="return check(event)"></asp:TextBox>
                    </td>
                    <td style="width: 25%; "></td>
                </tr>
                <tr>
                    <td style="width: 21%; " align="right">Salary Month :&nbsp;
                    </td>
                    <td style="width: 18%; ">
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                    </td>
                    <td style="width: 20%; "></td>
                    <td style="width: 20%; "></td>
                    <td style="width: 25%; "></td>
                </tr>
                <tr>
                    <td style="width: 21%"></td>
                    <td style="width: 18%"></td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                            ToolTip="Click to Search" TabIndex="3" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
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
                                        <asp:BoundField DataField="FatherName" HeaderText="FatherName" Visible="false" ReadOnly="true">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="DOJ" HeaderText="D.O.J." ReadOnly="true">
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
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
                        <tr>
                            <td align="center" colspan="5">
                                <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" BackgroundCssClass="filterPupupBackground"
                                    CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle"
                                    TargetControlID="btnHidden" BehaviorID="mpeCreateGroup">
                                </cc1:ModalPopupExtender>
                                <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none">
                                    <div id="dragUpdate" runat="server" class="Purchaseheader">
                                        <b>Employee Detail </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        &nbsp;&nbsp; &nbsp;&nbsp; Press esc to close
                                        <asp:ImageButton ID="btnClose" runat="server" ImageUrl="~/Images/Delete.gif" ToolTip="Close"
                                            Style="display: none" />
                                    </div>
                                    <table cellpadding="0" cellspacing="0" style="width: 658px">
                                        <tr>
                                            <td style="height: 16px;" align="center" colspan="4">
                                                <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 20%; height: 16px;" align="right">Employee&nbsp;ID :&nbsp;
                                            </td>
                                            <td style="width: 20%; height: 16px;" align="left">
                                                <asp:Label ID="lblEmpID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                            </td>
                                            <td style="width: 20%; height: 16px;" align="right">Employee&nbsp;Name :&nbsp;
                                            </td>
                                            <td style="width: 20%; height: 16px;" align="left">
                                                <asp:Label ID="lblEmpName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 20%; height: 16px">Department :&nbsp;
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px">
                                                <asp:Label ID="lblDept" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                            </td>
                                            <td align="right" style="width: 20%; height: 16px">Designation :&nbsp;
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px">
                                                <asp:Label ID="lblDesi" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 20%; height: 16px">Date&nbsp;Of&nbsp;Joining :&nbsp;
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px">
                                                <asp:Label ID="lblDOJ" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                            </td>
                                            <td align="right" style="width: 20%; height: 16px">Father&nbsp;Name :&nbsp;
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px">
                                                <asp:Label ID="lblFatherName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="width: 20%; height: 16px">Basic :&nbsp;
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px">
                                                <asp:Label ID="lblBasic" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px">
                                                <asp:Label ID="lblDeptID" runat="server" Visible="False"></asp:Label>
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px">
                                                <asp:Label ID="lblAccNo" runat="server" Visible="False"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px">
                                                <asp:Label ID="lblDesiID" runat="server" Visible="False"></asp:Label>
                                            </td>
                                            <td align="left" style="width: 20%; height: 4px">
                                                <asp:Label ID="lblLetter" runat="server" Visible="False"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                            <td align="left" style="width: 20%; height: 4px"></td>
                                        </tr>
                                    </table>
                                    <div id="Div1" runat="server" class="Purchaseheader">
                                        <b>BackPay Detail </b>
                                        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
                                        </Ajax:ScriptManager>
                                    </div>
                                    <table cellpadding="0" cellspacing="0" style="width: 658px">
                                        <tr>
                                            <td align="left" style="width: 20%; height: 16px"></td>
                                            <td align="left" colspan="2" style="height: 16px">&nbsp;
                                            </td>
                                            <td align="left" style="width: 20%; height: 16px"></td>
                                        </tr>
                                        <tr>
                                            <td align="center" style="height: 16px" colspan="4">
                                                <asp:Panel ID="pnlArrear" runat="server" Width="550" Height="250" ScrollBars="auto">
                                                    <cc1:TabContainer ActiveTabIndex="1" ID="TabContainer1" runat="server" Width="500px"
                                                        Height="150px" OnClientActiveTabChanged="TabChange">
                                                        <cc1:TabPanel ID="TabPanel1" runat="server" ScrollBars="Auto" HeaderText="TabPanel1">
                                                            <HeaderTemplate>
                                                                <b style="font-size: 12px">Salary BackPay&nbsp;</b>
                                                            </HeaderTemplate>
                                                            <ContentTemplate>
                                                                <table width="90%">
                                                                    <tr>
                                                                        <td align="right">BackPay Month :&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:TextBox ID="txtSalArrar" Width="100px" runat="server"></asp:TextBox><cc1:CalendarExtender
                                                                                ID="calucDate" runat="server" TargetControlID="txtSalArrar" Format="dd-MMM-yyyy">
                                                                            </cc1:CalendarExtender>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">Payable Days :&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:TextBox ID="txtSalPayableDays" onkeypress="return checkForSecondDecimal(this,event)"
                                                                                AutoCompleteType="Disabled" Width="100px" MaxLength="3" runat="server" ToolTip="Enter Payable Days"></asp:TextBox><asp:Label
                                                                                    ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label><cc1:FilteredTextBoxExtender
                                                                                        ID="f1" runat="server" FilterType="Custom, Numbers" TargetControlID="txtSalPayableDays"
                                                                                        ValidChars="." Enabled="True">
                                                                                    </cc1:FilteredTextBoxExtender>
                                                                            <asp:RequiredFieldValidator ID="reqSalPayableDays" runat="server" ControlToValidate="txtSalPayableDays"
                                                                                Display="None" ErrorMessage="Enter Payable Days" SetFocusOnError="True" ValidationGroup="SalaryArrear"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">Narration :&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:TextBox ID="txtSalnarration" runat="server" AutoCompleteType="Disabled" TextMode="MultiLine"
                                                                                Width="250px" Height="30px" ToolTip="Enter Narration"></asp:TextBox><asp:Label ID="Label1"
                                                                                    runat="server" Style="color: Red; font-size: 10px;">*</asp:Label><asp:RequiredFieldValidator
                                                                                        ID="reqNarration" runat="server" ControlToValidate="txtSalnarration" Display="None"
                                                                                        ErrorMessage="Enter Narration" SetFocusOnError="True" ValidationGroup="SalaryArrear"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left"></td>
                                                                        <td align="left">
                                                                            <asp:Button ID="btnSaveSalaryArrear" ValidationGroup="SalaryArrear" runat="server"
                                                                                OnClick="btnSaveSalaryArrear_Click" Text="Save" CssClass="ItDoseButton" ToolTip="Click to Save"
                                                                                OnClientClick="return validateSalary();" />&nbsp;
                                                                            <input id="Button1" type="button" value="Close" class="ItDoseButton" onclick="HidePopup();" />
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </cc1:TabPanel>
                                                        <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="TabPanel2">
                                                            <HeaderTemplate>
                                                                <b style="font-size: 12px">Incremental BackPay</b>
                                                            </HeaderTemplate>
                                                            <ContentTemplate>
                                                                <table width="90%">
                                                                    <tr>
                                                                        <td align="right">BackPay Month :&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:TextBox ID="txtIncArrear" runat="server" Width="100px"></asp:TextBox><cc1:CalendarExtender
                                                                                ID="calMonth" runat="server" TargetControlID="txtIncArrear" Format="dd-MMM-yyyy">
                                                                            </cc1:CalendarExtender>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">Increment Amount :&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:TextBox ID="txtIncrementAmount" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"
                                                                                Width="100px" runat="server" MaxLength="8" ToolTip="Enter Increment Amount"></asp:TextBox><asp:Label
                                                                                    ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label><cc1:FilteredTextBoxExtender
                                                                                        ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers" TargetControlID="txtIncrementAmount"
                                                                                        ValidChars="." Enabled="True">
                                                                                    </cc1:FilteredTextBoxExtender>
                                                                            <asp:RequiredFieldValidator ID="reqIncrementAmount" runat="server" ControlToValidate="txtIncrementAmount"
                                                                                Display="None" ErrorMessage="Enter Increment Amount" SetFocusOnError="True" ValidationGroup="IncrementalArrear"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">Payable Days :&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:TextBox ID="txtpayableDays" AutoCompleteType="Disabled" Width="100px" runat="server"
                                                                                onkeypress="return checkForSecondDecimal(this,event)" MaxLength="3" ToolTip="Enter Payable Days"></asp:TextBox><asp:Label
                                                                                    ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label><cc1:FilteredTextBoxExtender
                                                                                        ID="FilteredTextBoxExtender2" runat="server" FilterType="Custom, Numbers" TargetControlID="txtpayableDays"
                                                                                        ValidChars="." Enabled="True">
                                                                                    </cc1:FilteredTextBoxExtender>
                                                                            <asp:RequiredFieldValidator ID="reqpayableDays" runat="server" ControlToValidate="txtpayableDays"
                                                                                Display="None" ErrorMessage="Enter Payable Days" SetFocusOnError="True" ValidationGroup="IncrementalArrear"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="right">Narration :&nbsp;
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:TextBox AutoCompleteType="Disabled" ID="txtNarration" runat="server" TextMode="MultiLine"
                                                                                Width="250px" Height="30px" ToolTip="Enter Narration"></asp:TextBox><asp:Label ID="Label4"
                                                                                    runat="server" Style="color: Red; font-size: 10px;">*</asp:Label><asp:RequiredFieldValidator
                                                                                        ID="reqNarrationIn" runat="server" ControlToValidate="txtNarration" Display="None"
                                                                                        ErrorMessage="Enter Narration" SetFocusOnError="True" ValidationGroup="IncrementalArrear"></asp:RequiredFieldValidator>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td align="left">
                                                                            <br />
                                                                        </td>
                                                                        <td align="left">
                                                                            <asp:Button ID="btnSaveInc" ValidationGroup="IncrementalArrear" runat="server" Text="Save"
                                                                                OnClick="btnSaveInc_Click" CssClass="ItDoseButton" ToolTip="Click to Save" OnClientClick="return validateInc();" />
                                                                            <input id="btnClose1" type="button" value="Close" class="ItDoseButton" onclick="HidePopup();" />
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
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <div style="display: none;">
                    <asp:Button ID="btnHidden" runat="server" Text="Button" OnClick="btnHidden_Click" CssClass="ItDoseButton"/>
                </div>
            </div>
        </div>
    </div>
</asp:Content>