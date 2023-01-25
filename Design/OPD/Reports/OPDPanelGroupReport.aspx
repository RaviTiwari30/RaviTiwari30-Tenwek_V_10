<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDPanelGroupReport.aspx.cs" Inherits="Design_OPD_OPDPanelGroupReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
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

            <b>OPD Patient Panel Group Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report&nbsp;Criteria
            </div>

            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right; width: 15%;border:groove">
                        <asp:CheckBox ID="chkAllPanelGroup"  ClientIDMode="Static" AutoPostBack="true" OnCheckedChanged="chkAllPanelGroup_CheckedChanged" runat="server" onclick="checkAllPanelGroup();" Text="PanelGroup :&nbsp;" />


                    </td>
                    <td colspan="3" style="width: 85%;border:groove">
                        <asp:CheckBoxList ID="chklPanelGroup" onclick="chkPanelGroupCon()" ClientIDMode="Static" runat="server" AutoPostBack="true" OnSelectedIndexChanged="chklPanelGroup_SelectedIndexChanged" RepeatDirection="Horizontal" CssClass="chkAllPanelGroupCheck ItDoseCheckboxlist" RepeatLayout="Table" RepeatColumns="7"></asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 15%;border:groove">
                        <asp:CheckBox ID="chkPanel" ClientIDMode="Static" runat="server" onclick="checkAllPanel();" Text="Panel :&nbsp;" />


                    </td>
                    <td colspan="3">
                        <div  style="width: 100%;border:groove; overflow:auto; height:400px;">
                            <asp:CheckBoxList ID="chkAllPanel" onclick="chkPanelCon()" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" CssClass="chkAllPanelCheck ItDoseCheckboxlist" RepeatLayout="Table" RepeatColumns="3"></asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
                
                <tr style="border:groove">
                    <td style="text-align: right; width: 15%;border-bottom:groove;border-left:groove">UHID :&nbsp;
                            
                    </td>
                    <td style="width: 30%; text-align: left;border-bottom:groove">
                        <asp:TextBox ID="txtMRNo" runat="server" Width="170px" MaxLength="50"></asp:TextBox>
                    </td>
                    <td style="text-align: right; width: 20%;border-bottom:groove">Bill No. :&nbsp;
                            
                    </td>
                    <td style="width: 35%; text-align: left;border-bottom:groove;border-right:groove">
                        <asp:TextBox ID="txtBillNo" runat="server" Width="170px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 15%;border-bottom:groove;border-left:groove"> From Date :&nbsp;
                            
                    </td>
                    <td style="width: 30%; text-align: left;border-bottom:groove">
                        <asp:TextBox ID="txtFromDate" runat="server" Width="170px" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" Animated="true" runat="server"></cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right; width: 20%;border-bottom:groove"> To Date :&nbsp;
                            
                    </td>
                    <td style="width: 35%; text-align: left;border-bottom:groove;border-right:groove">
                         <asp:TextBox ID="txtToDate" runat="server" Width="170px" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 15%;border:groove">
                        <asp:CheckBox ID="chkAllCentre" Checked="True" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" />

                    </td>
                    <td colspan="3" style="width: 85%;border:groove">
                        <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                        </asp:CheckBoxList>
                    </td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click"
                CssClass="ItDoseButton" />
        </div>
    </div>



</asp:Content>

