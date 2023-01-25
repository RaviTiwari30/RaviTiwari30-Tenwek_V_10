<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DailyRecieptReport.aspx.cs"
    Inherits="Design_OPD_DailyRecieptReport" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Conetent1" runat="server">
    <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" >
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
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <b>Receipt wise Collection</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria</div>
            <table style="width: 100%">                
                    <tr>
                        <td style="width: 12%; text-align: right;">
                            User :&nbsp;<asp:CheckBox ID="chkAll" runat="server" OnCheckedChanged="chkAll_CheckedChanged" AutoPostBack="true" />
                        </td>
                        <td colspan="7" style="width: 17%">
                            <asp:CheckBoxList ID="cblUser" CssClass="ItDoseCheckbox" Font-Size="8" runat="server"
                                RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="3" Width="571px" />
                        </td>
                    </tr>
                 <tr>
                    <td style="text-align: right; width: 153px;">
                        <asp:CheckBox ID="chkIgnoreDate" runat="server" Checked="true" Text="Ignore Date"/>   &nbsp;
                    </td>
                    <td style="width: 264px" colspan="2">
                        &nbsp;
                    </td>
                    <td style="text-align: right; width: 129px;" colspan="2">
                        &nbsp;
                    </td>
                    <td colspan="2">
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                        <td style="width: 12%; text-align: right;">                     
                                From Date :&nbsp;
                        </td>
                        <td style="width: 17%">
                            <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width="100px"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ucFromDate_CalendarExtender" runat="server" TargetControlID="ucFromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 7%" align="right">
                            &nbsp;Time :&nbsp;
                        </td>
                        <td style="width: 12%">
                            <asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="75px" ToolTip="Enter Time"
                                TabIndex="2" />
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99:99" runat="server" MaskType="Time"
                                TargetControlID="txtFromTime">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </td>
                        <td style="width: 12%" align="right">
                            To Date :
                        </td>
                        <td style="width: 17%">
                            <asp:TextBox ID="ucToDate" runat="server" ToolTip="Click To Select To Date" Width="100px"
                                TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ucToDate_CalendarExtender" runat="server" TargetControlID="ucToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 7%">
                            Time :&nbsp;
                        </td>
                        <td style="width: 12%">
                            <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="75px" ToolTip="Enter Time"
                                TabIndex="4" />
                            <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99:99" runat="server" MaskType="Time"
                                TargetControlID="txtToTime">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </td>
                    </tr>
                <tr>
                    <td style="text-align:right" >
                        From Receipt No. :&nbsp;
                    </td>
                    <td  style="width: 264px; text-align:left" colspan="2">
                        <asp:TextBox ID="txtfromreceipt" runat="server" ClientIDMode="Static" 
                            TabIndex="1"></asp:TextBox>
                       
                    </td>
                    <td style="text-align:right" colspan="2">
                        To Receipt No. :&nbsp;
                    </td>
                    <td colspan="2" style="text-align:left">
                        <asp:TextBox ID="txtToreceipt" runat="server" ClientIDMode="Static" 
                            Width="149px" TabIndex="2"></asp:TextBox>
                       
                 
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 153px;">
                        &nbsp;
                    </td>
                    <td style="width: 264px" colspan="2">
                        &nbsp;
                    </td>
                    <td style="text-align: right; width: 129px;" colspan="2">
                        &nbsp;
                    </td>
                    <td colspan="2">
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                ToolTip="Click To Open Report " ClientIDMode="Static" TabIndex="3" />
        </div>
    </div>
</asp:Content>
