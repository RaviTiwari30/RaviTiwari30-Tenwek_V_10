<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ViewAppointmentLetter.aspx.cs" Inherits="Design_Payroll_ViewAppointmentLetter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
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
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtJoinDateFrom').change(function () {
                ChkDate();

            });

            $('#txtJoinDateTo').change(function () {
                ChkDate();

            });

        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtJoinDateFrom').val() + '",DateTo:"' + $('#txtJoinDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtAppointmentDateFrom').change(function () {
                ChkDates();

            });

            $('#txtAppointmentDateTo').change(function () {
                ChkDates();

            });

        });

        function getDates() {

            $.ajax({

                url: "../common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    return;
                }
            });
        }

        function ChkDates() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtAppointmentDateFrom').val() + '",DateTo:"' + $('#txtAppointmentDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblmsg.ClientID %>').text('To date can not be less than from date!');
                        getDate();

                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
    <script type="text/javascript">

        function validatespace() {
            var card = $('#<%=txtName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblmsg.ClientID %>').text('');
                return true;
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
            var card = $('#<%=txtName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtName.ClientID %>').val('');
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
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Appointment Letter Search<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4"></div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Employee Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" ToolTip="Enter Employee Name"
                                TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Designation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtDesignation" runat="server" MaxLength="50" ToolTip="Enter Designation"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <asp:CheckBox ID="chkDate" runat="server" AutoPostBack="True" OnCheckedChanged="chkDate_CheckedChanged" CssClass="pull-right" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                From Appointment Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtAppointmentDateFrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calAppointmentDateFrom" runat="server" TargetControlID="txtAppointmentDateFrom"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                To Appointment Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtAppointmentDateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calAppointmentDateTo" runat="server" TargetControlID="txtAppointmentDateTo"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <asp:CheckBox ID="chkJoinDate" runat="server" AutoPostBack="True" OnCheckedChanged="chkJoinDate_CheckedChanged" CssClass="pull-right" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Join Date From 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtJoinDateFrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calJoinDateFrom" runat="server" TargetControlID="txtJoinDateFrom"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Join Date To 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtJoinDateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calJoinDateTo" runat="server" TargetControlID="txtJoinDateTo"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24" align="center">
                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                ValidationGroup="v1" CssClass="ItDoseButton" ToolTip="Click to Search" />&nbsp;&nbsp; &nbsp;
                        
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row">
                <div class="col-md-24" align="center">
                    <asp:GridView ID="grirecord" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        OnRowCommand="grirecord_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblid" runat="server" Text='<%#Eval("ID")%>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee&nbsp;Name">
                                <ItemTemplate>
                                    <%#Eval("Name")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Designation">
                                <ItemTemplate>
                                    <%#Eval("Designation")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Appointment&nbsp;Date">
                                <ItemTemplate>
                                    <%#Eval("AppointmentDate")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Joining&nbsp;Date">
                                <ItemTemplate>
                                    <%#Eval("JoinDate")%>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Total&nbsp;Remuneration">
                                <ItemTemplate>
                                    <asp:Label ID="lblTotalEarning" runat="server" Text='<%#Eval("TotalRemuneration")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="AEdit" ToolTip="Click to Edit" ImageUrl="~/Images/edit.png" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Print">
                                <ItemTemplate>
                                    <asp:Label ID="lblAppointmentLetterType" Visible="false" runat="server" Text='<%#Eval("AppointmentLetterType") %>'></asp:Label>
                                    <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID")%>'
                                        CommandName="RPrint" ImageUrl="~/Images/Print.gif" ToolTip="Click to Print" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Acce. Print">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbPrintAcc" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID")%>'
                                        CommandName="RPrintAcc" ImageUrl="~/Images/Print.gif" ToolTip="Click to Print" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

            </div>

            <table border="0" style="width: 100%; border-collapse: collapse">

                <tr>
                    <td align="center" colspan="5"></td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
