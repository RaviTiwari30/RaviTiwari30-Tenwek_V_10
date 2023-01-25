<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AdvanceAnainstSalary.aspx.cs" Inherits="Design_Payroll_AdvanceAnainstSalary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=txtAdvance.ClientID %>").bind('keypress keyup keydown', function () {
                while (($(this).val().split(".").length - 1) > 1) {

                    $(this).val($(this).val().slice(0, -1));

                    if (($(this).val().split(".").length - 1) > 1) {
                        continue;
                    } else {
                        return false;
                    }
                }

            });
        });
    </script>
    <script type="text/javascript">
       
        function displayValidationResult() {
            if (typeof (Page_Validators) == "undefined") return;
            var AdvAmt = document.getElementById("<%=reqAdvanceAmt.ClientID%>");
            var EMI = document.getElementById("<%=reqEMI.ClientID%>");
            var LblName = document.getElementById("<%=lblmsgpopup.ClientID%>");
            ValidatorValidate(AdvAmt);
            if (!AdvAmt.isvalid) {
                LblName.innerText = AdvAmt.errormessage;
                return false;
            }

            ValidatorValidate(EMI);
            if (!EMI.isvalid) {
                LblName.innerText = EMI.errormessage;
                return false;
            }

        }
        function validate() {
            var AdvAmt = $("#<%=txtAdvance.ClientID %>").val();
            var EMI = $("#<%=txtEMINO.ClientID %>").val();
            if (AdvAmt == "" || AdvAmt <= 0) {
                $("#<%=lblmsgpopup.ClientID%>").text('Please Enter Advance Amount');
                $("#<%=txtAdvance.ClientID %>").val('');
                $("#<%=txtAdvance.ClientID %>").focus();
                return false;
            }
            if (AdvAmt.charAt(0) == ".") {
                $("#<%=lblmsgpopup.ClientID%>").text('Please Enter Valid Advance Amount');
                $("#<%=txtAdvance.ClientID %>").focus();
                return false;
            }
            if (EMI == "" || EMI <= 0) {
                $("#<%=lblmsgpopup.ClientID%>").text('Please Enter No. of EMI');
                $("#<%=txtEMINO.ClientID %>").val('');
                $("#<%=txtEMINO.ClientID %>").focus();
                return false;
            }
            if (EMI == "0") {
                $("#<%=lblmsgpopup.ClientID%>").text('EMI should be greater than 0');
                $("#<%=txtEMINO.ClientID %>").val('');
                $("#<%=txtEMINO.ClientID %>").focus();
                return false;
            }
            else {
                $("#<%=lblmsgpopup.ClientID %>").text('');
            }

        }
        $(document).ready(function () {
            $("#<%=txtAdvance.ClientID %>").bind("blur keyup keydown", function (e) {
                if ($(this).val().charAt(0) == ".") {
                    $(this).val('0.');
                    return false;
                }
                var keycode = e.keyCode ? e.keyCode : e.which;

                if (keycode == 8) { // backspace
                    if ($("#<%=txtAdvance.ClientID %>").val() == "0.") {
                        $("#<%=txtAdvance.ClientID %>").val('');
                    }
                }

                if (keycode == 46) { // delete
                    if ($("#<%=txtAdvance.ClientID %>").val() == "0.") {
                        $("#<%=txtAdvance.ClientID %>").val('');
                    }
                }
            });

        });
        function clear() {
            $("#<%=txtAdvance.ClientID %>").val('');
            $("#<%=txtEMINO.ClientID %>").val('');
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
                    $("#<%=txtAdvance.ClientID %>").val('');
                    $("#<%=txtEMINO.ClientID %>").val('');
                }
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
            var card = $('#<%=txtEmpID.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtEmpID.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
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
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Staff Loan </b>
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
                        <asp:TextBox ID="txtEmpID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID" onkeypress="return check(event)"></asp:TextBox>
                    </td>
                    <td style="width: 20%; height: 11px;" align="right">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 11px;">
                        <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name" onkeypress="return check(event)"></asp:TextBox>
                    </td>
                    <td style="width: 25%; height: 11px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;"></td>
                    <td style="width: 18%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%"></td>
                    <td style="width: 18%"></td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                            CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Search" />
                    </td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5" style="height: 18px"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Panel ID="pnl" runat="server" ScrollBars="Vertical" Height="300">
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
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FatherName" HeaderText="Father&nbsp;Name" Visible="false"
                                        ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
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
        TargetControlID="btnHidden" BehaviorID="mpeCreateGroup" OnCancelScript="clear()">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none">
        <div runat="server" class="Purchaseheader">
            <b>Employee Detail </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp; Press esc to close
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 658px">
            <tr>
                <td style="height: 16px;" align="center" colspan="4">
                    <asp:Label ID="lblmsgpopup" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 20%; height: 16px;" align="right">Employee ID :&nbsp;
                </td>
                <td style="width: 20%; height: 16px;" align="left">
                    <asp:Label ID="lblEmpID" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td style="width: 20%; height: 16px;" align="right">Name :&nbsp;
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
                <td align="right" style="width: 20%; height: 16px">Date Of Joining :&nbsp;
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
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
        </table>
        <div runat="server" class="Purchaseheader">
            <b>Loan Detail </b>
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 658px">
            <tr>
                <td style="height: 16px;" align="center" colspan="4"></td>
            </tr>
            <tr>
                <td align="center" colspan="4" style="height: 16px">
                    <asp:GridView ID="AdvanceGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="EmpGrid_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:BoundField DataField="EmployeeID" HeaderText="Employee&nbsp;ID" ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Adv_ID" HeaderText="Loan&nbsp;ID" ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Amount" HeaderText="Amount" ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Date" HeaderText="Date" ReadOnly="true">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" style="width: 658px">
            <tr>
                <td align="right" style="width: 20%; height: 16px">Loan Amount :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:TextBox AutoCompleteType="disabled" ID="txtAdvance" runat="server" TabIndex="4"
                        ToolTip="Enter Loan Amount" MaxLength="8"></asp:TextBox>
                    <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <cc1:FilteredTextBoxExtender ID="f1" FilterType="Custom, numbers" ValidChars="."
                        FilterMode="validChars" TargetControlID="txtAdvance" runat="server">
                    </cc1:FilteredTextBoxExtender>
                    <asp:RequiredFieldValidator ValidationGroup="Save" ID="reqAdvanceAmt" runat="server"
                        ControlToValidate="txtAdvance" Display="None" ErrorMessage="Enter Loan Amount"
                        SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
            <tr>
                <td align="right" style="width: 29%; height: 16px">No. of Month :&nbsp;
                </td>
                <td align="left" style="width: 30%; height: 16px">
                    <asp:TextBox Visible="true" AutoCompleteType="disabled" ID="txtEMINO" runat="server"
                        TabIndex="5" ToolTip="Enter No. of EMI" MaxLength="5"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <cc1:FilteredTextBoxExtender ID="ftbEMI" FilterType="Numbers" FilterMode="validChars"
                        TargetControlID="txtEMINO" runat="server">
                    </cc1:FilteredTextBoxExtender>
                    <asp:RequiredFieldValidator ID="reqEMI" runat="server" ControlToValidate="txtEMINO"
                        Display="None" ErrorMessage="Enter No. Of EMI" SetFocusOnError="True" ValidationGroup="Save"></asp:RequiredFieldValidator>
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
            <tr>
                <td align="left" style="width: 29%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
            <tr>
                <td align="left" style="width: 29%; height: 16px"></td>
                <td align="center" colspan="2" style="height: 16px">
                    <asp:Button ValidationGroup="Save" ID="btnSave" runat="server" OnClick="btnSave_Click"
                        Text="Save" TabIndex="6" OnClientClick="return validate();" CssClass="ItDoseButton"
                        ToolTip="Click to Save" />&nbsp;
                    <asp:Button ID="btnClose" TabIndex="7" runat="server" Text="Close" CssClass="ItDoseButton"
                        ToolTip="Click to Close" />
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
        </table>
        <br />
    </asp:Panel>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"
            />
    </div>
</asp:Content>