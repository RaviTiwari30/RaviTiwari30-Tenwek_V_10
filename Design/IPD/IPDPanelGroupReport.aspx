<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="IPDPanelGroupReport.aspx.cs" Inherits="Design_IPD_IPDPanelGroupReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
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
        $(function () {
            checkAllCentre();
            // checkAllPanelGroup();
            // checkAllPanel();
        });
        function checkAllCentre() {
            if ($('#<%= chkAllCentre.ClientID %>').is(':checked')) {
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

        function checkAllPanelGroup() {
            if ($('#<%= chkAllPanelGroup.ClientID %>').is(':checked')) {
                $('.chkAllPanelGroupCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllPanelGroupCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkPanelGroupCon() {
            if (($('#<%= chklPanelGroup.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chklPanelGroup.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllPanelGroup.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllPanelGroup.ClientID %>').attr("checked", false);
            }
        }
        function checkAllPanel() {
            if ($('#<%= chkPanel.ClientID %>').is(':checked')) {
                $('.chkAllPanelCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllPanelCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkPanelCon() {
            if (($('#<%= chkAllPanel.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkAllPanel.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkPanel.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkPanel.ClientID %>').attr("checked", false);
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>IPD Patient Panel Group Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report&nbsp;Criteria
            </div>

            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right; width: 15%; border: groove">
                        <asp:CheckBox ID="chkAllCentre" Checked="True" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />

                    </td>
                    <td colspan="3" style="width: 85%; border: groove">
                        <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                        </asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 15%; border: groove">
                        <asp:CheckBox ID="chkAllPanelGroup" ClientIDMode="Static" AutoPostBack="true" OnCheckedChanged="chkAllPanelGroup_CheckedChanged" runat="server" onclick="checkAllPanelGroup();" Text="PanelGroup :&nbsp;" />


                    </td>
                    <td colspan="3" style="width: 85%; border: groove;">
                        <asp:CheckBoxList ID="chklPanelGroup" onclick="chkPanelGroupCon()" ClientIDMode="Static" runat="server" AutoPostBack="true" OnSelectedIndexChanged="chklPanelGroup_SelectedIndexChanged" RepeatDirection="Horizontal" CssClass="chkAllPanelGroupCheck ItDoseCheckboxlist" RepeatLayout="Table" RepeatColumns="12"></asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 15%; border: groove">
                        <asp:CheckBox ID="chkPanel" ClientIDMode="Static" runat="server" onclick="checkAllPanel();" Text="Panel :&nbsp;" />


                    </td>
                    <td colspan="3" style="width: 85%; border: groove;height:200px;overflow-x:scroll">
                        <div style="text-align: left;height:200px;">
                            <asp:CheckBoxList ID="chkAllPanel" onclick="chkPanelCon()" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" CssClass="chkAllPanelCheck ItDoseCheckboxlist" RepeatLayout="Table" RepeatColumns="5"></asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" MaxLength="10"></asp:TextBox>
                            
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:RadioButtonList ID="rblReportType" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="3">
                                <asp:ListItem Text="Admit Date" Selected="True" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Discharge Date" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Bill Date" Value="3"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbreportformat" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="P">PDF</asp:ListItem>
                                <asp:ListItem Value="E">Excel</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click"
                CssClass="ItDoseButton" />
        </div>
    </div>



</asp:Content>

