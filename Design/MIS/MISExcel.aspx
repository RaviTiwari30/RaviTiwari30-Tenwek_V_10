<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MISExcel.aspx.cs" Inherits="Design_MIS_MISExcel" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>MIS Report (Excel)</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Search Criteria
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%">
                <tr>
                    <td style="text-align: right">From Date :&nbsp;</td>
                    <td>
                            <asp:TextBox ID="ucDateFrom" runat="server" ClientIDMode="Static"
                                 Width="154px"></asp:TextBox>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="ucDateFrom" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>

                        </td>
                    <td style="text-align: right">To Date :&nbsp; 
                        </td>
                    <td>
                            <asp:TextBox ID="ucDateTo" runat="server" ClientIDMode="Static"
                                 Width="154px"></asp:TextBox>
                            <cc1:CalendarExtender ID="dateto" TargetControlID="ucDateTo" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>

                        </td>
                </tr>
                <tr>
                    <td style="text-align: right">Report Type :&nbsp;</td>
                    <td>
                            <asp:RadioButtonList ID="rblReportType" runat="server"
                                 RepeatDirection="Horizontal">
                                <asp:ListItem Text="Transactional" Selected="True" Value="1" />
                                <asp:ListItem Text="Clinical" Value="2" style="display:none" />
                            </asp:RadioButtonList>
                        </td>
                    <td style="text-align: right">&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            &nbsp;&nbsp;
            <asp:Button ID="btnReport" runat="server" TabIndex="11"
                Text="Generate Report" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnReport_Click" />
        </div>
    </div>
</asp:Content>

