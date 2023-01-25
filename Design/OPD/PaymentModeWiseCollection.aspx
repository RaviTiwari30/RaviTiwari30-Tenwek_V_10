<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PaymentModeWiseCollection.aspx.cs" Inherits="Design_OPD_PaymentModeWiseCollection" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        function checkAllPaymentMode() {
           
            if ($('#<%= chkAllPaymentMode.ClientID %>').is(':checked')) {
                 $('.chkAllPaymentModeCheck input[type=checkbox]').attr("checked", "checked");
             }
             else {
                 $(".chkAllPaymentModeCheck input[type=checkbox]").attr("checked", false);
             }
        }
        function chkPaymentModeCon() {
            if (($('#<%= chkPaymentMode.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkPaymentMode.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllPaymentMode.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllPaymentMode.ClientID %>').attr("checked", false);
            }
        }
        $(function () {
            checkAllCentre();
        });
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
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Collection Report Payment Mode Wise</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>

            <table style="width: 100%; border-collapse: collapse">
                <tr>
                         <td style="width: 18%; text-align: right;">
                            <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" Checked="true" /></td>
                       <td colspan="3" style="text-align:left">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </td>


                    </tr>
                <tr>
                    <td style="width: 18%; text-align: right;">
                        <asp:CheckBox ID="chkAllPaymentMode" ClientIDMode="Static" runat="server" onclick="checkAllPaymentMode();" Checked="true" Text="Payment Mode :&nbsp;"  />
                    </td>
                    <td colspan="3" style="text-align:left">
                        <asp:CheckBoxList  ID="chkPaymentMode" onclick="chkPaymentModeCon()" CssClass="chkAllPaymentModeCheck" runat="server"  RepeatColumns="6" RepeatDirection="Horizontal"></asp:CheckBoxList>
                    </td>
                </tr>

                <tr>
                    <td style="width: 18%; text-align: right;">From Date :&nbsp;
                    </td>

                    <td>
                        <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date" Width="170px" onchange="ChkDate();"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromdate" runat="server" TargetControlID="txtFromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                        &nbsp;Time :&nbsp;
                            <asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                TabIndex="2" />
                        <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                            TargetControlID="txtFromTime" AcceptAMPM="true">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </td>
                    <td style="width: 12%; text-align: right">To Date :&nbsp;
                    </td>
                    <td colspan="2" style="width: 12%;  text-align: left">
                        <table style="width: 100%; border-collapse: collapse">
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" Width="170px" onchange="ChkDate();"
                                        TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate"
                                        Format="dd-MMM-yyyy" ClearTime="true">
                                    </cc1:CalendarExtender>
                                </td>
                                <td>Time&nbsp;:&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                        TabIndex="4" />
                                    <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtToTime" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                        ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                </td>
                                <td style="width: 40%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>

                </tr>
                <tr>
                        <td style="width: 18%; text-align: right; ">&nbsp;</td>

                        <td style="text-align: left; ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em></td>
                        <td colspan="3" style="text-align: right; ">&nbsp;   <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em></td>
                    </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton"
                OnClick="btnReport_Click" ClientIDMode="Static" ToolTip="Click To Open Report"
                TabIndex="5" OnClientClick="return validate()" />
        </div>
    </div>
    <script type="text/javascript">
        function validate() {
            if ($("#<%=chkPaymentMode.ClientID%> input[type=checkbox]:checked").length == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Payment Mode');
                return false;
            }
            
        }
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
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
</asp:Content>

