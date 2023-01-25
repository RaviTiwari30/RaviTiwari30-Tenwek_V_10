<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AdvanceReport.aspx.cs" Inherits="Design_Payroll_AdvanceReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
    <script type="text/javascript" >
        $(document).ready(function () {
            var chk = $("#<%=rbtnReportType.ClientID%>").find("input[name='<%=rbtnReportType.UniqueID%>']:radio:checked").val();
            if (chk == "1") {
                $(".show").hide();
            }
            else if (chk == "2") {
                $(".show").show();
            }
            $("#<%=rbtnReportType.ClientID%>").change(function () {
            var rbvalue = $("input[name='<%=rbtnReportType.UniqueID%>']:radio:checked").val();
            if (rbvalue == "1") {
                $(".show").hide();
            }
            if (rbvalue == "2") {
                $(".show").show();
            }
        });

        });
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Loan Report</b><br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Loan Report
            </div>
            <div style="text-align: left;">
                <table width="100%">
                    <tr>
                        <td align="center" style="width: 14%; height: 18px"></td>
                        <td rowspan="2" style="width: 19%">
                            <asp:RadioButtonList OnSelectedIndexChanged="rbtnReportType_SelectedIndexChanged"
                                ID="rbtnReportType" runat="server" AutoPostBack="False">
                                <asp:ListItem Selected="True" Value="1">Loan O.S. Report</asp:ListItem>
                                <asp:ListItem Value="2">Month Wise Report</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="width: 20%; height: 18px" align="right">Report Format :
                        </td>
                        <td style="width: 20%; height: 18px">
                            <asp:RadioButtonList ID="RadioButtonList2" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">PDF</asp:ListItem>
                                <asp:ListItem>Word</asp:ListItem>
                                <asp:ListItem>Excel</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                    </tr>
                    <tr style="display: none" class="show">
                        <td align="center" style="width: 14%; height: 18px"></td>
                        <td style="width: 20%; height: 18px" align="right">
                            <asp:Label ID="lbldate" runat="Server" Text="Salary Month :"></asp:Label>
                            <br />
                        </td>
                        <td style="width: 20%; height: 18px">
                            <%--<uc1:entrydate Visible="false" ID="txtDate" runat="server" />--%>
                            <asp:TextBox ID="txtDate" runat="server" ToolTip="Select Salary Month"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                    </tr>
                    <tr>
                        <td align="center" style="width: 14%; height: 18px"></td>
                        <td style="width: 19%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" ToolTip="Click to Search" CssClass="ItDoseButton" />
        </div>
    </div>
</asp:Content>