<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="NewItemReport.aspx.cs" Inherits="Design_Store_NewItemReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#ucDateFrom').change(function () {
                ChkDate();
            });
            $('#ucDateTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucDateFrom').val() + '",DateTo:"' + $('#ucDateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $("#tbAppointment table").remove();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>New Item Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-11">
                            <asp:RadioButtonList ID="rbtnMedNonMed" runat="server" RepeatDirection="horizontal"
                                AutoPostBack="True" OnSelectedIndexChanged="rbtnMedNonMed_SelectedIndexChanged">
                                <asp:ListItem Text="Medical Store" Value="5" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="General Store" Value="8"></asp:ListItem>
                                <asp:ListItem Value="3">All</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGroup" runat="server" AutoPostBack="True" Width="">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left">
                                Search Name By First character
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtSearch" runat="server" Width=""></asp:TextBox>
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">
                                Search Name By Any character
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearchchar" runat="server" Width=""></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date Filter
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList ID="rbtFilter" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Enabled="true" Value="0">Creation Date</asp:ListItem>
                                <asp:ListItem Value="1">Update Date</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucDateFrom" runat="server" ClientIDMode="Static" Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="ucDateFrom" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucDateTo" runat="server" ClientIDMode="Static" Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="todate" TargetControlID="ucDateTo" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Items Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoActive" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">Active</asp:ListItem>
                                <asp:ListItem Value="0">DeActive</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee&nbsp;By
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlEmployeeName" runat="server" Width="">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>

                    <td style="text-align: right; display: none;">Filter Type :&nbsp;
                    </td>
                    <td style="display: none;" class="left-align">
                        <asp:RadioButtonList ID="rbtType" runat="server" RepeatColumns="2">
                            <asp:ListItem Value="ALL">ALL</asp:ListItem>
                            <asp:ListItem Value="GP">Shri Gopal Pharmacy</asp:ListItem>
                            <asp:ListItem Value="HS" Selected="True">Hospital Store</asp:ListItem>
                            <asp:ListItem Value="IMP">Implants</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            &nbsp;&nbsp;
            <asp:Button ID="btnSearch" runat="server" TabIndex="11" Text="Search" CssClass="ItDoseButton"
                OnClick="btnSearch_Click" ClientIDMode="Static" />
        </div>
    </div>
</asp:Content>
