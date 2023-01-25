<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Increment.aspx.cs" Inherits="Design_Payroll_Increment" %>

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
        function NewBasic() {
            try {
                var OldBasic = document.getElementById('ctl00_ContentPlaceHolder1_lblBasic').innerText;
                var Increment = document.getElementById('ctl00_ContentPlaceHolder1_txtIncrementAmount').value;
                if (Increment != '') {
                    var NewBasic = eval(OldBasic) + eval(Increment);
                    document.getElementById('ctl00_ContentPlaceHolder1_lblNewBasic').innerText = NewBasic;
                }
                else {
                    var NewBasic1 = eval(OldBasic);
                    document.getElementById('ctl00_ContentPlaceHolder1_lblNewBasic').innerText = NewBasic1;
                }
            }
            catch (e) {

            }
        }
        function NewBasic1() {

            var val1 = $("#<%=lblBasic.ClientID %>").text();
            var val2 = $("#<%=txtIncrementAmount.ClientID %>").val();
            if (!isNaN(val1) || !isNaN(val2)) {
                $("#<%=lblNewBasic.ClientID %>").html((parseFloat(val1)) + (parseFloat(val2)));

            }

        }
        //        $(document).ready(function () {
        //            $('input').focus(function () {
        //                $("label[for='" + this.id + "']").addClass('focus');
        //            }).blur(function () {
        //                $("label[for='" + this.id + "']").removeClass('focus');
        //            });
        //        });
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpeCreateGroup")) {
                    $find("mpeCreateGroup").hide();
                    $("#<%=txtIncrementAmount.ClientID %>").val('');

                }
            }
        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer
            if (window.event) {
                alert();
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            var Empid = $('#<%=txtEmpID.ClientID %>').val();
            var EmpName = $('#<%=txtEmpName.ClientID %>').val();
            if (Empid.charAt(0) == ' ') {
                $('#<%=txtEmpID.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            if (EmpName.charAt(0) == ' ') {
                $('#<%=txtEmpName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=txtIncrementAmount.ClientID %>").bind('keypress keyup keydown', function () {
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
        $(document).ready(function () {
            $("#<%=txtIncrementAmount.ClientID %>").bind("blur keyup keydown", function (e) {
                if ($(this).val().charAt(0) == ".") {
                    $(this).val('0.');
                    return false;
                }
                var keycode = e.keyCode ? e.keyCode : e.which;

                if (keycode == 8) { // backspace
                    if ($("#<%=txtIncrementAmount.ClientID %>").val() == "0.") {
                        $("#<%=txtIncrementAmount.ClientID %>").val('');
                    }
                }

                if (keycode == 46) { // delete
                    if ($("#<%=txtIncrementAmount.ClientID %>").val() == "0.") {
                        $("#<%=txtIncrementAmount.ClientID %>").val('');
                    }
                }
            });

        });
        function clear() {
            $("#<%=txtIncrementAmount.ClientID %>").val('');
        }
        function validate() {
            var IntAmt = $("#<%=txtIncrementAmount.ClientID %>").val();
            if (IntAmt == "" || IntAmt <= 0) {
                $("#<%=lblmsgpopup.ClientID%>").text('Please Enter Increment Amount');
                $("#<%=txtIncrementAmount.ClientID %>").val('');
                $("#<%=txtIncrementAmount.ClientID %>").focus();
                return false;
            }
            if (IntAmt.charAt(0) == ".") {
                $("#<%=lblmsgpopup.ClientID%>").text('Please Enter Valid Increment Amount');
                $("#<%=txtIncrementAmount.ClientID %>").focus();
                return false;
            }

            else {
                $("#<%=lblmsgpopup.ClientID %>").text('');
            }

        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Increment </b>
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
                        <asp:TextBox ID="txtEmpID" runat="server" MaxLength="20" ToolTip="Enter Employee ID"
                            TabIndex="1" ClientIDMode="Static" onkeypress="return check(event)"></asp:TextBox>
                    </td>
                    <td style="width: 20%; height: 11px;" align="right">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 11px;">
                        <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" ToolTip="Enter Employee Name"
                            TabIndex="2" ClientIDMode="Static" onkeypress="return check(event)"></asp:TextBox>
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
            <asp:Panel ID="pnl" runat="server" ScrollBars="Vertical" Height="300" Style="text-align: center">
                <table border="0" style="text-align: center">
                    <tr align="center">
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
            Employee Detail &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
            &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
            &nbsp;&nbsp; &nbsp;&nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp; Press esc to close
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 758px">
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
                <td style="width: 20%; height: 16px;" align="right">Employee Name :&nbsp;
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
            <tr>
                <td align="right" style="width: 20%; height: 16px">Last Increment :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblIncrement" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
                <td align="right" style="width: 20%; height: 16px">Increment Date :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblIncrementDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
        </table>
        <div id="Div1" runat="server" class="Purchaseheader">
            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
        </div>
        <table cellpadding="0" cellspacing="0" style="width: 758px">
            <tr>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 19%; height: 16px"></td>
                <td align="left" style="width: 16%; height: 16px"></td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
            <tr>
                <td align="right" style="width: 20%; height: 16px">Increment Amount :&nbsp;
                </td>
                <td align="left" style="width: 25%; height: 16px">
                    <asp:TextBox ID="txtIncrementAmount" AutoCompleteType="disabled" runat="server" MaxLength="6"
                        ToolTip="Enter Increment Amount"></asp:TextBox>
                    <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
                <td align="right" style="width: 16%; height: 16px">New Basic :&nbsp;
                </td>
                <td align="left" style="width: 20%; height: 16px">
                    <asp:Label ID="lblNewBasic" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="left" style="width: 19%; height: 16px">
                    <cc1:FilteredTextBoxExtender ID="f2" FilterType="Custom, numbers" ValidChars="."
                        FilterMode="validChars" TargetControlID="txtIncrementAmount" runat="server">
                    </cc1:FilteredTextBoxExtender>
                </td>
                <td align="left" style="width: 16%; height: 16px">
                    <asp:RequiredFieldValidator ValidationGroup="Save" ID="reqIncrementAmount" runat="server"
                        ControlToValidate="txtIncrementAmount" Display="None" ErrorMessage="Enter Increment Amount"
                        SetFocusOnError="True"></asp:RequiredFieldValidator>
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
            <tr>
                <td align="left" style="width: 20%; height: 16px"></td>
                <td align="center" colspan="2" style="height: 16px">
                    <asp:Button ValidationGroup="Save" ID="btnSave" runat="server" OnClick="btnSave_Click"
                        Text="Save" OnClientClick="return validate();" CssClass="ItDoseButton" ToolTip="Click to Save" />&nbsp;
                    <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="ItDoseButton" ToolTip="Click to Close" />
                </td>
                <td align="left" style="width: 20%; height: 16px"></td>
            </tr>
        </table>
        <br />
    </asp:Panel>
    <br />
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
</asp:Content>