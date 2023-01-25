<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Attendance.aspx.cs" Inherits="Design_Payroll_Attendance" %>

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
        function Calpayday(Ctrl) {
            //alert("hi");
            var txtCon = Ctrl.parentNode.parentNode.getElementsByTagName("input");
            txtCon[5].value = Number(txtCon[0].value) + Number(txtCon[1].value) + Number(txtCon[2].value) + Number(txtCon[3].value) + Number(txtCon[4].value);
            if (Number(txtCon[5].value) > Number(txtCon[6].value)) {
                alert("Payble days can not be greater than working days");

            }
        }

        $(document).ready(function () {
            $("table[id*=EmpGrid] input[id*=txtwdays]").bind('keyup keydown', function (e) {

                if ($(this).closest("tr").find("input[id*=txtwdays]").val() == "") {
                    $(this).closest("tr").find("input[id*=txtwdays]").val('0');
                }
                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                var keychar = String.fromCharCode(keynum)
                if ($(this).closest("tr").find("input[id*=txtwdays]").val().charAt(0) == "0") {
                    if (keycode >= "49" && keycode <= "57") {
                        $(this).closest("tr").find("input[id*=txtwdays]").val(keychar);
                        return false;
                    }
                }

            });
            $("table[id*=EmpGrid] input[id*=txtcl]").bind('keyup keydown', function (e) {

                if ($(this).closest("tr").find("input[id*=txtcl]").val() == "") {
                    $(this).closest("tr").find("input[id*=txtcl]").val('0');
                }
                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                var keychar = String.fromCharCode(keynum)
                if ($(this).closest("tr").find("input[id*=txtcl]").val().charAt(0) == "0") {
                    if (keycode >= "49" && keycode <= "57") {
                        $(this).closest("tr").find("input[id*=txtcl]").val(keychar);
                        return false;
                    }
                }

            });
            $("table[id*=EmpGrid] input[id*=txtel]").bind('keyup keydown', function (e) {

                if ($(this).closest("tr").find("input[id*=txtel]").val() == "") {
                    $(this).closest("tr").find("input[id*=txtel]").val('0');
                }
                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                var keychar = String.fromCharCode(keynum)
                if ($(this).closest("tr").find("input[id*=txtel]").val().charAt(0) == "0") {
                    if (keycode >= "49" && keycode <= "57") {
                        $(this).closest("tr").find("input[id*=txtel]").val(keychar);
                        return false;
                    }
                }

            });
            $("table[id*=EmpGrid] input[id*=txtother]").bind('keyup keydown', function (e) {

                if ($(this).closest("tr").find("input[id*=txtother]").val() == "") {
                    $(this).closest("tr").find("input[id*=txtother]").val('0');
                }
                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                var keychar = String.fromCharCode(keynum)
                if ($(this).closest("tr").find("input[id*=txtother]").val().charAt(0) == "0") {
                    if (keycode >= "49" && keycode <= "57") {
                        $(this).closest("tr").find("input[id*=txtother]").val(keychar);
                        return false;
                    }
                }

            });
            $("table[id*=EmpGrid] input[id*=txtPayabledays]").bind('keyup keydown', function (e) {

                if ($(this).closest("tr").find("input[id*=txtPayabledays]").val() == "") {
                    $(this).closest("tr").find("input[id*=txtPayabledays]").val('0');
                }
                var keycode = e.keyCode ? e.keyCode : e.which;
                var keynum
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera
                else if (e.which) {
                    keynum = e.which
                }
                var keychar = String.fromCharCode(keynum)
                if ($(this).closest("tr").find("input[id*=txtPayabledays]").val().charAt(0) == "0") {
                    if (keycode >= "49" && keycode <= "57") {
                        $(this).closest("tr").find("input[id*=txtPayabledays]").val(keychar);
                        return false;
                    }
                }

            });
        });

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
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Edit Employee Attendance </b>
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
                    <td align="right" style="width: 21%; height: 11px">Salary Month :&nbsp;
                    </td>
                    <td style="width: 18%; height: 11px">
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                    </td>
                    <td align="right" style="width: 20%; height: 11px"></td>
                    <td style="width: 20%; height: 11px"></td>
                    <td style="width: 25%; height: 11px"></td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;"></td>
                    <td style="width: 18%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;" align="center">
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                            TabIndex="3" ToolTip="Click to Search" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <asp:Panel ID="pnl1" runat="server" ScrollBars="Auto" Height="330" Width="960">
                        <asp:GridView ID="EmpGrid" AutoGenerateColumns="false" runat="server" HeaderStyle-CssClass="GridViewHeaderStyle"
                            RowStyle-CssClass="GridViewItemStyle" CssClass="GridViewStyle" OnRowDataBound="EmpGrid_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        S.No.
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        Employee&nbsp;ID
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblID" Visible="False" Width="50" Text='<%#Eval("ID") %>' runat="server"></asp:Label>
                                        <asp:Label ID="lblEmployeeID" Width="90px" Text='<%#Eval("Employee_ID") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name" ItemStyle-HorizontalAlign="Center"
                                    ItemStyle-Width="180px" />
                                <asp:BoundField DataField="FromDate" HeaderText="From&nbsp;Date" />
                                <asp:BoundField DataField="ToDate" HeaderText=" To&nbsp;Date" />
                                <asp:BoundField DataField="WorkDays" HeaderText="Day&nbsp;In&nbsp;Month" />
                                <%-- <asp:BoundField DataField="WorkHours" HeaderText="WorkHours" />
                            <asp:BoundField DataField="PresentDays" HeaderText="PresentDays" />
                            <asp:BoundField DataField="PresentHours" HeaderText="PresentHours" />--%>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        Working&nbsp;Days
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtwdays" Width="30" Text='<%#Eval("WorkingDays") %>' runat="server"
                                            CssClass="ItDoseTextinputNum" onKeyUp="Calpayday(this);" MaxLength="4" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="wdays" runat="server" FilterType="Numbers,Custom"
                                            ValidChars="." TargetControlID="txtwdays">
                                        </cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        Weekly&nbsp;Off
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtWeeklyOff" MaxLength="4" Width="30" onkeypress="return checkForSecondDecimal(this,event)"
                                            runat="server" ReadOnly="false" Text='<%#Eval("WeekOff") %>' onKeyUp="Calpayday(this);" CssClass="ItDoseTextinputNum"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="week" runat="server" FilterType="Numbers,Custom"
                                            ValidChars="." TargetControlID="txtWeeklyOff">
                                        </cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        CL
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtcl" Width="30" MaxLength="4" Text='<%#Eval("CL") %>' CssClass="ItDoseTextinputNum"
                                            runat="server" onKeyUp="Calpayday(this);" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="cl" runat="server" FilterType="Numbers,Custom" ValidChars="."
                                            TargetControlID="txtcl">
                                        </cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        EL
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtel" MaxLength="4" Width="30" Text='<%#Eval("EL") %>' CssClass="ItDoseTextinputNum"
                                            onkeypress="return checkForSecondDecimal(this,event)" runat="server" onKeyUp="Calpayday(this);"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="El" runat="server" FilterType="Numbers,Custom" ValidChars="."
                                            TargetControlID="txtel">
                                        </cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        Other&nbsp;Leave
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtother" MaxLength="4" Width="30" Text='<%#Eval("MedicalLeave") %>'
                                            runat="server" CssClass="ItDoseTextinputNum" onKeyUp="Calpayday(this);" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="other" runat="server" FilterType="Numbers,Custom"
                                            ValidChars="." TargetControlID="txtother">
                                        </cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        Payable&nbsp;Days
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtPayabledays" MaxLength="4" Width="30" onkeypress="return checkForSecondDecimal(this,event)"
                                            runat="server" ReadOnly="false" Text='<%#Eval("PayableDays") %>' CssClass="ItDoseTextinputNum"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="Payabledays" runat="server" FilterType="Numbers,Custom"
                                            ValidChars="." TargetControlID="txtPayabledays">
                                        </cc1:FilteredTextBoxExtender>
                                        <asp:RangeValidator ID="RangeValidator1" runat="server" Type="Double" MinimumValue="0"
                                            ControlToValidate="txtPayabledays" MaximumValue='<%#Eval("WorkDays") %>' ErrorMessage="*"></asp:RangeValidator>
                                        <asp:TextBox ID="txtwork" Width="40" Text='<%#Eval("WorkDays") %>' runat="server"
                                            Style="display: none"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtpayableHours" Visible="False" Width="40" Text='<%#Eval("PayableHours") %>'
                                            runat="server"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField Visible="false">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgbtn" Visible="false" CommandArgument='<%#Eval("Employee_ID") %>'
                                            ImageUrl="~/Images/edit.png" ToolTip="Edit" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="ItDoseButton"/>
            </div>
        </asp:Panel>
    </div>
</asp:Content>