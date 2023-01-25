<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleCollectionReport.aspx.cs" Inherits="Design_Lab_SampleCollectionReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >

        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();
            });

            $('#ToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

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
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <b>Lab Sample Collection Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="text-align:right; width: 133px;" >
                       Report Type :&nbsp;</td>
                    <td>
                       <asp:RadioButtonList ID="rdbReportType" runat="server" RepeatDirection="Horizontal" >
                           <asp:ListItem Value="0">ALL</asp:ListItem>
                           <asp:ListItem Value="1" Selected="True">OPD</asp:ListItem>
                           <asp:ListItem Value="2">IPD</asp:ListItem>
                           <asp:ListItem Value="3">Emergency</asp:ListItem>
                       </asp:RadioButtonList></td>
                    <td style="text-align:right; width: 93px;" >
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align:right; width: 133px;" >
                        Lab No. :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtLabNo" runat="server" Width="144px" />
                    </td>
                    <td style="text-align:right; width: 93px;" >
                        User :&nbsp;
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlUsers" runat="server" Width="150px" >
                        </asp:DropDownList>
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align:right; width: 133px;" >
                        From Date :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" Width="144px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                        </cc1:CalendarExtender>
                        <asp:TextBox ID="txtFromTime" runat="server" Width="80px"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="meetxtFromTime" Mask="99:99" TargetControlID="txtFromTime"
                                    AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="metxtFrTime" ControlExtender="meetxtFromTime"
                                    ControlToValidate="txtFromTime" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </td>
                    <td style="text-align:right; width: 93px;" >
                        To Date :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" Width="144px" ToolTip="Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                            TargetControlID="ToDate">
                        </cc1:CalendarExtender>
                        <asp:TextBox ID="txtToTime" runat="server" Width="80px"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="meetxtToTime" Mask="99:99" TargetControlID="txtToTime"
                                    AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime" ControlExtender="meetxtToTime"
                                    ControlToValidate="txtToTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </td>
                </tr>

                <tr>
                    <td style="text-align:right; width: 133px;" >
                        Centre :&nbsp;</td>
                    <td>
                        <asp:CheckBox ID="chkAllCentre" runat="server" Text="All Centre" onclick="checkAllCentre();" />
                    </td>
                    <td style="text-align:right; width: 93px;" >
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>

                <tr>
                    <td style="text-align:right; width: 133px;" >
                        &nbsp;</td>
                    <td colspan="3">
                        <asp:CheckBoxList ID="chkCentre" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" CssClass="chkAllCentreCheck">
                        </asp:CheckBoxList>
                    </td>
                </tr>

            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
           
        </div>
    </div>
</asp:Content>
