<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDAdvance_OutStanding.aspx.cs" Inherits="Design_OPD_OPDAdvance_OutStanding" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />

    
    <script type="text/javascript" >
        $(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });
            $('#chkAllCentre').change(function () {
                if ($('#chkAllCentre').prop('checked') == true) {
                    $("INPUT[id^='chkCentre']").prop('checked', 'checked');
                }
                else {
                    $("INPUT[id^='chkCentre']").removeAttr('checked');
                }
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnReport').removeAttr('disabled');

                    }
                }
            });

        }
        function CheckAll() {
            $("INPUT[id^='chkCentre']").prop('checked', 'checked');
        }
    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <%--<b>OPD Advance / OutStanding Report</b>--%>
            <b>OPD OutStanding Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
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
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtFromDate" runat="server" Width="195px" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-2">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtToDate" runat="server" Width="195px" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Payment Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:RadioButtonList ID="rdoPaymentModeType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">ALL</asp:ListItem>
                                <asp:ListItem Value="1">Cash/Cheque/Credit Card</asp:ListItem>
                                <asp:ListItem Value="2">Credit</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                MR No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMrNo" runat="server" CssClass="ItDoseTextinputText" Width="195px" ToolTip="Enter MR No."></asp:TextBox>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:RadioButtonList ID="rdbAdvanceOutStan" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="ALL" Selected="True">ALL</asp:ListItem>
                                <%--<asp:ListItem Value="OPDAdvance"> Advance</asp:ListItem>--%>
                                <asp:ListItem Value="OutStanding">Out Standing</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>

                    <div class="row" style="display: none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                As on
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:TextBox ID="ucFromDate" runat="server" Width="119px"></asp:TextBox>
                            <asp:TextBox ID="txtFromTime" runat="server" CssClass="inputtext1" Width="100px" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtFromTime"
                                Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                            <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucFromDate">
                            </cc1:CalendarExtender>
                            <cc1:MaskedEditValidator ID="mask" runat="server" ControlExtender="MaskedEditExtender1"
                                ControlToValidate="txtFromTime" IsValidEmpty="false" MaximumValue="23:59:59"
                                MinimumValue="00:00:00" EmptyValueMessage="Enter Time" InvalidValueBlurredMessage="Envalid Time"
                                ToolTip="Enter time between 00:00:00 to 23:59:59" MinimumValueMessage="Time must be grater than 00:00:00"></cc1:MaskedEditValidator>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal" Height="16px">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                TabIndex="5" ToolTip="Click to Open Report" />
        </div>
    </div>
</asp:Content>



