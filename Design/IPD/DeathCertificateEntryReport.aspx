<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DeathCertificateEntryReport.aspx.cs" Inherits="Design_IPD_DeathCertificateEntryReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>

        <script type="text/javascript">
            $(document).ready(function () {
                $('#txtFromDate').change(function () {
                    ChkDate();
                });
                $('#txtTodate').change(function () {
                    ChkDate();
                });
            });
            function ChkDate() {
                debugger;
                $.ajax({

                    url: "../common/CommonService.asmx/CompareDate",
                    data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtTodate').val() + '"}',
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

        </script>


        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Death Certificate Entry Report</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <table style="width: 100%; border-collapse: collapse">

                <tr>
                    <td style="width: 30%; text-align: right;">From&nbsp;Date&nbsp;:&nbsp;
                    </td>
                    <td style="width: 20%; text-align: left">
                        <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date"
                            ClientIDMode="Static" Width="110px"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtFromDate_CalendarExtender" runat="server" TargetControlID="txtFromDate"
                            Animated="true" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 10%; text-align: right;">To&nbsp;Date&nbsp;:&nbsp;
                    </td>
                    <td style="width: 40%; text-align: left">
                        <asp:TextBox ID="txtTodate" runat="server" ToolTip="Click To Select From Date"
                            Width="110px" TabIndex="1"
                            ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtToDate_CalendarExtender" runat="server" TargetControlID="txtTodate"
                            Animated="true" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" ClientIDMode="Static"
                Text="Report" ToolTip="Click To Search" OnClick="btnReport_Click" />
        </div>
    </div>
</asp:Content>

