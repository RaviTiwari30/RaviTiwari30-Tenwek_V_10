<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AccomodationMaster.aspx.cs" Inherits="Design_Payroll_AccomodationMaster" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">
        function HidePopup() {
            $find('mpeAcc').hide();
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
       
        function ValidateAccomodation() {
            if (typeof (Page_Validators) == "undefined") return;
            var AccomodationAmt = document.getElementById("<%=reqAccomodationAmt.ClientID%>");

            var AccomodationTaxAmt = document.getElementById("<%=reqAccomodationTaxAmt.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopup.ClientID%>");
            ValidatorValidate(AccomodationAmt);
            if (!AccomodationAmt.isvalid) {
                LblName.innerText = AccomodationAmt.errormessage;
                return false;
            }

            ValidatorValidate(AccomodationTaxAmt);
            if (!AccomodationTaxAmt.isvalid) {
                LblName.innerText = AccomodationTaxAmt.errormessage;
                return false;
            }
            if ($("#<%=txtAccomodationAmt.ClientID %>").val() == "0") {
                $("#<%=lblmsgpopup.ClientID%>").text('Please Enter Accomodation Amount');
                var input = $("#<%=txtAccomodationAmt.ClientID %>");
                input.focus();
                input.setCursorToTextEnd();
                return false;
            }
        }
        (function ($) {
            $.fn.setCursorToTextEnd = function () {
                $initialVal = this.val();
                this.val($initialVal + ' ');
                this.val($initialVal);
            };
        })(jQuery);
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
        function CalAccomodation() {
            try {
                var Amt = $("#<%=txtAccomodationAmt.ClientID %>").val();
                $("#<%=txtAccomodationAmt.ClientID %>").val(Number(Amt));
                var AccomodationAmt = $.trim($("#<%=txtAccomodationAmt.ClientID %>").val());
                if (AccomodationAmt > 0) {
                    $("#<%=txtAccomodationTaxAmt.ClientID %>").val(parseFloat((AccomodationAmt * 10) / 100).toFixed(2));
                    var AccomodationTaxAmt = $("#<%=txtAccomodationTaxAmt.ClientID %>").val();

                }
                else {
                    $("#<%=txtAccomodationTaxAmt.ClientID %>").val('0');

                }
            }
            catch (e) {

            }
        }
        $(document).ready(function () {
            var modalPopup = $find("mpeCreateGroup");
            if (modalPopup != null) {
            }
            $("#<%= txtAccomodationAmt.ClientID %>").bind("blur keyup keydown", function (e) {
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
                    if ($("#<%= txtAccomodationAmt.ClientID %>").val() == "0.") {
                        $(this).val('0');
                        $("#<%=txtAccomodationTaxAmt.ClientID %>").val('0');

                        return false;
                    }
                }

                if (keycode == 46) { // delete
                    if ($("#<%= txtAccomodationAmt.ClientID %>").val() == "0.") {
                        $(this).val('0');
                        $("#<%=txtAccomodationTaxAmt.ClientID %>").val('0');

                        return false;
                    }
                }
                if ($(this).val() == "") {
                    $(this).val('0');
                    $("#<%=txtAccomodationTaxAmt.ClientID %>").val('0');

                }
            });

        });
        //        function pageLoad() {
        //            $find('mpeAcc').add_shown(function () {
        //                $get("<%= txtAccomodationAmt.ClientID %>").focus();
        //            });
        //        }
        function pageLoad() {
            var popupGroup = $find('mpeAcc'); //ModalPopupExtender Behviour ID
            if (popupGroup != null)
                popupGroup.add_shown(SetGroupFocus); // It will Fire while u clicking Control to show modal

        }

        function SetGroupFocus() {
            $get('<%= txtAccomodationAmt.ClientID %>').focus(); // Set Focus on TextBox.

        }
        function clearpopup() {
            $("#<%=txtAccomodationAmt.ClientID %>").val('0');
             $("#<%=txtAccomodationTaxAmt.ClientID %>").val('0');

         }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="sc" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Accomodation </b>
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
                                    <asp:BoundField DataField="EmployeeID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
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
                                                CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")%>' CommandName="Select" />
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
        TargetControlID="btnHidden" BehaviorID="mpeAcc" OnCancelScript="clearpopup()">
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
                <td align="right" style="width: 10%; height: 16px"></td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:Label ID="lblWorkedDays" runat="server" Style="display: none" CssClass="ItDoseLabelSp"></asp:Label>
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
            <b>Accomodation</b>
        </div>
        <asp:Panel ID="pnlArrear" runat="server" Width="750" Height="100px" ScrollBars="auto">
            <table cellpadding="0" cellspacing="0" style="width: 458px">

                <tr>
                    <td align="right">Accomodation Amount :&nbsp;
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtAccomodationAmt" MaxLength="8" ToolTip="Enter Accomodation Amount" TabIndex="1"
                            AutoCompleteType="Disabled" Width="100px" Text="0" runat="server" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                        <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:FilteredTextBoxExtender ID="f1" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtAccomodationAmt" Enabled="True" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                        <asp:RequiredFieldValidator ID="reqAccomodationAmt" runat="server" ControlToValidate="txtAccomodationAmt"
                            Display="None" ErrorMessage="Enter Accomodation Amount" SetFocusOnError="True" ValidationGroup="Acc"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right">Accomodation Tax Amount :&nbsp;
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtAccomodationTaxAmt" MaxLength="8" Text="0"
                            AutoCompleteType="Disabled" Width="100px" runat="server" ReadOnly="True" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                        <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                            TargetControlID="txtAccomodationTaxAmt" Enabled="True" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                        <asp:RequiredFieldValidator ID="reqAccomodationTaxAmt" runat="server" ControlToValidate="txtAccomodationTaxAmt"
                            Display="None" ErrorMessage="Enter Accomodation Tax Amount" SetFocusOnError="True" ValidationGroup="Acc"></asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td align="left"></td>
                    <td align="left">
                        <asp:Button ID="btnAccomodation" ValidationGroup="Acc" runat="server" Text="Save" TabIndex="2"
                            ToolTip="Click to Save" OnClick="btnAccomodation_Click" CssClass="ItDoseButton" OnClientClick="return ValidateAccomodation();" />&nbsp;
                        <input id="btnClose1" type="button" value="Close" onclick="HidePopup();" class="ItDoseButton"/>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </asp:Panel>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
</asp:Content>