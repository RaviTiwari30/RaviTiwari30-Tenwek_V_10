<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BirthCertificateEntryReport.aspx.cs" Inherits="Design_IPD_BirthCertificateEntryReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $("#txtFromDate").change(function () {
                ChkDate();
            });

            $("#txtToDate").change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            jQuery.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $("#txtFromDate").val() + '",DateTo:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#lblMsg").text("To date can not be less than from date!");
                        $("#btnSearch").attr("disabled", "disabled");
                    }
                    else {
                        $("#lblMsg").text("");
                        $("#btnSearch").removeAttr("disabled");
                    }
                }
            });
        }

        function validate() {
            $("#lblMsg").text("");
            $("#btnSearch").val("Searching...").attr("disabled", "disabled");
            __doPostBack("ctl00$ContentPlaceHolder1$btnSearch", "");
            return true;
        }
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Birth Certificate Entry Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Reiteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Delivery Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDeliveryType" runat="server" ClientIDMode="Static" ToolTip="Select Nature of Delivery" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" Width="170px" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" Animated="true" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" Animated="true" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Format 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblFormat" runat="server" ClientIDMode="Static" ToolTip="Select Report Format" RepeatDirection="Horizontal">
                                <asp:ListItem Text="PDF" Selected="True" />
                                <asp:ListItem Text="Excel" />
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Search" ToolTip="Click To Search" OnClick="btnSearch_Click" OnClientClick="return validate();" />
        </div>
    </div>
</asp:Content>

