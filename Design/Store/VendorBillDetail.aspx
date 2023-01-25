<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="VendorBillDetail.aspx.cs" Inherits="Design_Finance_MISReport" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript">
        $(function () {
            checkAllCentre();
        });
        function checkAllCentre() {
            if ($('#<%= chkAllCentre.ClientID %>').is(':checked') == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
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

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Supplier Invoice Details</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
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
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbstore" runat="server" ToolTip="Select Store Type" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbstore_SelectedIndexChanged">
                                <asp:ListItem Value="Medical">Medical</asp:ListItem>
                                <asp:ListItem Value="General">General</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbDate" runat="server" ToolTip="Select Search Type" RepeatDirection="Horizontal" AutoPostBack="false">
                                <asp:ListItem Value="Invoice" Selected="True">Invoice Date</asp:ListItem>
                                <asp:ListItem Value="GRN">GRN Date</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"
                                Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"
                                Width=""></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                           <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbReportType" runat="server" ToolTip="Select Report Type" RepeatDirection="Horizontal" AutoPostBack="false">
                                <asp:ListItem Value="1" Selected="True">Detail </asp:ListItem>
                                <asp:ListItem Value="2">Summary</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" Checked="true" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="5" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="Purchaseheader">
                Supplier List
            </div>
            <div class="">
                <asp:Panel ID="pnl" runat="server" Height="320px" Width="100%" ScrollBars="Vertical">
                    <table>
                        <tr>
                            <td>
                                <asp:CheckBox ID="ChkAll" runat="server" AutoPostBack="True"
                                    OnCheckedChanged="ChkAll_CheckedChanged" Text="All" CssClass="ItDoseCheckboxlist" />
                            </td>
                            <td style="text-align: right; width: 50%">Search By Any Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>:</b></td>
                            <td>
                                <asp:TextBox ID="txtSearch" Width="250px" runat="server" ClientIDMode="Static" onkeyup="SearchCheckbox(this,'#chkVendor');"></asp:TextBox></td>
                        </tr>

                    </table>
                    <table>
                        <tr>
                            <td>
                                <div>
                                    <asp:CheckBoxList ID="chkVendor" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" ClientIDMode="Static"
                                        CssClass="ItDoseCheckboxlist" RepeatLayout="Table" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" ClientIDMode="Static" />

        </div>
    </div>
</asp:Content>
