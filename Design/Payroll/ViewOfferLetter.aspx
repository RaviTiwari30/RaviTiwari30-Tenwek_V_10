<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ViewOfferLetter.aspx.cs" Inherits="Design_Transport_ViewOfferLetter" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
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
            $('#txtOfferDateFrom').change(function () {
                ChkDate();

            });

            $('#txtOfferDateTo').change(function () {
                ChkDate();

            });

        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtOfferDateFrom').val() + '",DateTo:"' + $('#txtOfferDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=btnReport.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtJoinDateFrom').change(function () {
                ChkDates();

            });

            $('#txtJoinDateTo').change(function () {
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
                    $('#<%=btnReport.ClientID %>').attr('disabled', 'disabled');
                    return;
                }
            });
        }

        function ChkDates() {

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
                        getDate();

                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');
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
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Offer Letter Search </b>
            <br />
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
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Designation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtDesignation" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-right">
                            <asp:CheckBox ID="chkDate" runat="server" AutoPostBack="True" OnCheckedChanged="chkDate_CheckedChanged" />
                                </label>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                From Offer Letter Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtOfferDateFrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calOfferDateFrom" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtOfferDateFrom">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                To Offer Letter Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtOfferDateTo" runat="server"  ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calOfferDateTo" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtOfferDateTo">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-right">
                                <asp:CheckBox ID="chkJoinDate" runat="server" AutoPostBack="True" OnCheckedChanged="chkJoinDate_CheckedChanged" />
                            </label>
                        </div>
                            <div class="col-md-4">
                            <label class="pull-left">
                                From Joining Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                             <asp:TextBox ID="txtJoinDateFrom" runat="server"  ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calJoinDateFrom" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtJoinDateFrom">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                To Joining Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtJoinDateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calJoinDateTo" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtJoinDateTo">
                            </cc1:CalendarExtender>
                        </div>
                        </div>
                    <div class="row" align="center">
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
                                ValidationGroup="v1" CssClass="ItDoseButton" ToolTip="Click to Search" style="margin-top:7px; width:100px" />&nbsp;&nbsp; &nbsp;
                        <asp:Button ID="btnReport" runat="server" OnClick="btnReport_Click" ToolTip="Click to Print Report" Text="Report" CssClass="ItDoseButton" style="margin-top:7px; width:100px" />
                        
                    </div>
                    </div>
                </div>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22" align="center">
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
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Designation">
                                        <ItemTemplate>
                                            <%#Eval("Designation")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Offer&nbsp;Date">
                                        <ItemTemplate>
                                            <%#Eval("OfferDate")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Joining&nbsp;Date">
                                        <ItemTemplate>
                                            <%#Eval("JoinDate")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Joining&nbsp;Time">
                                        <ItemTemplate>
                                            <%#Eval("JoinTime")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Salary">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTotalEarning" runat="server" Text='<%#Eval("TotalEarning")%>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Edit">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID") %>'
                                                CommandName="AEdit" ImageUrl="~/Images/edit.png" ToolTip="Click to Edit" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Print">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%# Eval("ID")%>'
                                                CommandName="RPrint" ImageUrl="~/Images/Print.gif" ToolTip="Click to Print" />
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>
