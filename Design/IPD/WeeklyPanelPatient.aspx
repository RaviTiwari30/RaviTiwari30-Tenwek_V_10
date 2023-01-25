<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="WeeklyPanelPatient.aspx.cs" Inherits="Reports_IPD_WeeklyPanelPatient" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch,#rdoReportType,#btnSearch,#ddlFromMonth,#ddlToMonth,#btnMonthReport').attr('disabled', 'disabled');


                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch,#rdoReportType,#btnSearch,#ddlFromMonth,#ddlToMonth,#btnMonthReport').removeAttr('disabled');

                    }
                }
            });

        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
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

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Admitted Panel Patient </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Weekly Report
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
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
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucFromDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucToDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-15">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" ClientIDMode="Static" CssClass="ItDoseRadiobuttonlist" RepeatColumns="4" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1">Detail Report</asp:ListItem>
                                <asp:ListItem Value="2">Panel Wise Summary</asp:ListItem>
                                <asp:ListItem Value="3">Department Wise Summary</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-6"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" Text="Report" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory" style="display: none">
            <div class="Purchaseheader">
                Monthly Report
            </div>
            <div class="content" style="text-align: center;">
                <div>
                    <div style="float: left; clear: right;">
                        From Month :
                        <asp:DropDownList ID="ddlFromMonth" runat="server" Width="75px" ClientIDMode="Static">
                            <asp:ListItem Value="1">JAN</asp:ListItem>
                            <asp:ListItem Value="2">FEB</asp:ListItem>
                            <asp:ListItem Value="3">MAR</asp:ListItem>
                            <asp:ListItem Value="4">APR</asp:ListItem>
                            <asp:ListItem Value="5">MAY</asp:ListItem>
                            <asp:ListItem Value="6">JUN</asp:ListItem>
                            <asp:ListItem Value="7">JUL</asp:ListItem>
                            <asp:ListItem Value="8">AUG</asp:ListItem>
                            <asp:ListItem Value="9">SEP</asp:ListItem>
                            <asp:ListItem Value="10">OCT</asp:ListItem>
                            <asp:ListItem Value="11">NOV</asp:ListItem>
                            <asp:ListItem Value="12">DEC</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div style="float: left; padding-left: 50px;">
                        To Month :
                        <asp:DropDownList ID="ddlToMonth" runat="server" Width="75px" ClientIDMode="Static">
                            <asp:ListItem Value="1">JAN</asp:ListItem>
                            <asp:ListItem Value="2">FEB</asp:ListItem>
                            <asp:ListItem Value="3">MAR</asp:ListItem>
                            <asp:ListItem Value="4">APR</asp:ListItem>
                            <asp:ListItem Value="5">MAY</asp:ListItem>
                            <asp:ListItem Value="6">JUN</asp:ListItem>
                            <asp:ListItem Value="7">JUL</asp:ListItem>
                            <asp:ListItem Value="8">AUG</asp:ListItem>
                            <asp:ListItem Value="9">SEP</asp:ListItem>
                            <asp:ListItem Value="10">OCT</asp:ListItem>
                            <asp:ListItem Value="11">NOV</asp:ListItem>
                            <asp:ListItem Value="12">DEC</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display: none;">
            <asp:Button ID="btnMonthReport" runat="server" Text="Monthly Report" OnClick="btnMonthReport_Click"
                CssClass="ItDoseButton" ClientIDMode="Static" />
        </div>
    </div>
</asp:Content>
