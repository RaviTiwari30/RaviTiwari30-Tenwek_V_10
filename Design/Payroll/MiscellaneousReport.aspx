<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="MiscellaneousReport.aspx.cs" Inherits="Design_Payroll_MiscellaneousReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
    <script type="text/javascript" >
        $(function () {
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
                        $('#<%=lblmsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblmsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Miscellaneous Reports</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Miscellaneous Report
            </div>
            <div class="content">
                <div style="text-align: left;">
                    <table width="100%">
                        <tr>
                            <td style="width: 8%" align="center"></td>
                            <td style="width: 8%" align="right"></td>
                            <td align="center" style="width: 10%"></td>
                            <td style="width: 2%"></td>
                            <td style="width: 20%"></td>
                        </tr>
                        <tr>
                            <td align="center" style="width: 8%; height: 18px"></td>
                            <td style="width: 8%; height: 18px" align="right">
                                <asp:Label ID="lblFromDate" runat="server" Text="From Date :&nbsp;"></asp:Label>
                            </td>
                            <td style="width: 10%; height: 18px">
                                <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server" TabIndex="1" ToolTip="Click to Select From Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate"
                                    Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </td>
                            <td style="width: 12%; height: 18px" align="right">
                                <asp:Label ID="lblTo" runat="server" Text="To Date :&nbsp;"></asp:Label>
                            </td>
                            <td style="width: 20%; height: 18px" align="left">
                                <asp:TextBox ID="txtToDate" ClientIDMode="Static" runat="server" TabIndex="2" ToolTip="Click to Select To Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td align="center" style="width: 8%; height: 18px"></td>
                            <td style="width: 8%; height: 18px; text-align: right;">Report Format :&nbsp;</td>
                            <td style="width: 10%; height: 18px">
                                <asp:RadioButtonList ID="RadioButtonList2" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True">PDF</asp:ListItem>
                                    <asp:ListItem>Excel</asp:ListItem>
                                </asp:RadioButtonList>
                            </td>
                            <td style="width: 2%; height: 18px"></td>
                            <td style="width: 20%; height: 18px"></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                TabIndex="3" ToolTip="Click to Search" CssClass="ItDoseButton" />
        </div>
    </div>
</asp:Content>