<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MISIPDBillGeneratedAnalysis.aspx.cs"
    Inherits="Design_MIS_MISIPDBillGeneratedAnalysis" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <title>MIS-OPD Analysis</title>

    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../../Scripts/ScrollableGrid.js"></script>
    <script type="text/javascript" src="../../../Scripts/jquery.tooltip.js"></script>
 
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div>

            <script type="text/javascript" language="javascript">
    $(document).ready(function() {
        
        $('#<%=grdDocC.ClientID %>').Scrollable({ScrollHeight: 200});
        $('#<%=grdSpecC.ClientID %>').Scrollable({ScrollHeight: 200});
        $('#<%=grdBillDateC.ClientID %>').Scrollable({ScrollHeight: 200});
        $('#<%=grdPanelC.ClientID %>').Scrollable({ScrollHeight: 200});
    }
    )
            </script>

            <table cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                <tr>
                    <td colspan="2" style="text-align: center" valign="top">
                        <table cellpadding="0" cellspacing="0" style="width: 100%">
                            <tr>
                                <td style="width: 19%">
                                </td>
                                <td colspan="3" style="width: 15%;">
                                    <asp:Label ID="lblClickedC" runat="server" Font-Bold="True" ForeColor="Red" CssClass="ItDoseLabel"></asp:Label></td>
                                <td align="left" colspan="2" style="width: 26%; text-align: left" valign="top">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 19%">
                                    Compare Date from
                                </td>
                                <td style="width: 15%; text-align: left;">
                                    <asp:TextBox ID="txtFromDateC" runat="server" Width="96px" BackColor="#FFFFC0" CssClass="ItDoseTextinputText"></asp:TextBox><cc1:CalendarExtender
                                        ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDateC">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 5%; text-align: center;">
                                    To
                                </td>
                                <td style="width: 15%; text-align: left;">
                                    <asp:TextBox ID="txtToDateC" runat="server" Width="96px" BackColor="#FFFFC0" CssClass="ItDoseTextinputText"></asp:TextBox><cc1:CalendarExtender
                                        ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDateC">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 26%; text-align: left;">
                                    <asp:RadioButtonList ID="rbtViewType" runat="server" RepeatDirection="Horizontal"
                                        CssClass="ItDoseRadiobuttonlist">
                                        <asp:ListItem Selected="True" Value="1">By Actual Figure</asp:ListItem>
                                        <asp:ListItem Value="2">By Avg Per Day</asp:ListItem>
                                    </asp:RadioButtonList></td>
                                <td style="width: 20%; text-align: left;">
                                    <asp:Button ID="btnCompare" runat="server" OnClick="btnCompare_Click" Text="View"
                                        CssClass="ItDoseButton" />
                                    <asp:Label ID="lblGrowth" runat="server" BackColor="#80FF80" Font-Size="XX-Small">Growth</asp:Label>
                                    <asp:Label ID="lblDecline" runat="server" BackColor="#FFC0C0" Font-Size="XX-Small">Decline</asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="width: 50%; text-align: center" valign="top">
                        <asp:Label ID="lblDocC" runat="server" ForeColor="Maroon" Text="Doctor-wise" Visible="False"></asp:Label>
                    </td>
                    <td style="width: 50%; text-align: center" valign="top">
                        <asp:Label ID="lblItemwiseC" runat="server" ForeColor="Maroon" Text="Service-Wise"
                            Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 50%;" valign="top">
                        <asp:GridView ID="grdDocC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdDocC_RowCommand" OnRowDataBound="grdDocC_RowDataBound" Width="465px">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="OpenBill" HeaderText="Open Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PkgBill" HeaderText="Pkg. Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MixedBill" HeaderText="Mixed Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCompDoc" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblDocQtyGrowthOpenBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthOpenBill") %>' />
                                        <asp:Label ID="lblDocQtyGrowthPkgBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthPkgBill") %>' />
                                        <asp:Label ID="lblDocQtyGrowthMixedBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthMixedBill") %>' />
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("DoctorID")+"#"+Eval("CompType")%>' CommandName="View" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyleMIS" />
                        </asp:GridView>
                    </td>
                    <td style="width: 50%" valign="top">
                        <asp:GridView ID="grdSpecC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdSpecC_RowCommand" OnRowDataBound="grdSpecC_RowDataBound"  Width="465px">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="OpenBill" HeaderText="Open Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PkgBill" HeaderText="Pkg. Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MixedBill" HeaderText="Mixed Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                       <asp:Label ID="lblCompSpec" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblSpecQtyGrowthOpenBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthOpenBill") %>' />
                                        <asp:Label ID="lblSpecQtyGrowthPkgBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthPkgBill") %>' />
                                        <asp:Label ID="lblSpecQtyGrowthMixedBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthMixedBill") %>' />
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("CompType")%>' CommandName="View" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyleMIS" />
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="width: 50%; text-align: center;" valign="top">
                        <asp:Label ID="lblGroupC" runat="server" ForeColor="Maroon" Text="BillDate-wise"
                            Visible="False"></asp:Label>
                    </td>
                    <td style="width: 50%; text-align: center;" valign="top">
                        <asp:Label ID="lblPanelC" runat="server" ForeColor="Maroon" Text="Panel-wise" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 50%;">
                        <asp:GridView ID="grdBillDateC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdBillDateC_RowCommand" OnRowDataBound="grdBillDateC_RowDataBound" Width="465px">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyleMIS" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="OpenBill" HeaderText="Open Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PkgBill" HeaderText="Pkg. Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MixedBill" HeaderText="Mixed Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCompBillDate" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblBillDateQtyGrowthOpenBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthOpenBill") %>' />
                                        <asp:Label ID="lblBillDateQtyGrowthPkgBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthPkgBill") %>' />
                                        <asp:Label ID="lblBillDateQtyGrowthMixedBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthMixedBill") %>' />
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("Name")+"#"+Eval("CompType")%>' CommandName="View" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="width: 50%">
                        <asp:GridView ID="grdPanelC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdPanelC_RowCommand"  OnRowDataBound="grdPanelC_RowDataBound" Width="465px">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyleMIS" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="220px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="OpenBill" HeaderText="Open Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PkgBill" HeaderText="Pkg. Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MixedBill" HeaderText="Mixed Bill">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCompPanel" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblPanelQtyGrowthOpenBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthOpenBill") %>' />
                                        <asp:Label ID="lblPanelQtyGrowthPkgBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthPkgBill") %>' />
                                        <asp:Label ID="lblPanelQtyGrowthMixedBill" runat="server" Visible="false" Text='<%# Eval("QtyGrowthMixedBill") %>' />
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("PanelID")+"#"+Eval("CompType")%>' CommandName="View" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlItemsFilter" Height="420px" Style="display: none"
        TabIndex="3" Width="910px">
        <div id="dragHandle" runat="server" class="Purchaseheader">
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 95%">
            Details :</td>
                    <td style="width: 5%;" align="right">
                        <asp:ImageButton ID="btnRCancel" runat="server" CssClass="ItDoseButton" TabIndex="3"
                         ImageUrl="~/Images/Delete.gif"  Width="15px" Height="16px" /></td>
                </tr>
            </table>
        </div>
        <div style="overflow:auto;max-width:895px;max-height:365px;">
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 100%">
                        <asp:GridView ID="grdDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            ShowFooter="true" Width="850px">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyleMIS" />
                            <Columns>
                                <asp:BoundField DataField="BillDate" HeaderText="Bill Date">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BillNo" HeaderText="Bill No.">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BillingType" HeaderText="Billing Type">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="IP_No" HeaderText="IPD No.">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MR_No" HeaderText="UHID">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="70px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="70px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PName" HeaderText="PName">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DateOfAdmit" HeaderText="DateOfAdmit">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DateOfDischarge" HeaderText="DateOfDischarge">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Room" HeaderText="Room">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DoctorName" HeaderText="Doctor Name">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Specialization" HeaderText="Specialization">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="GrossBillAmt">
                                    <ItemTemplate>
                                        <%# Eval("GrossBillAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblGrossBillAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TotalDiscount">
                                    <ItemTemplate>
                                        <%# Eval("TotalDiscount")%>                                        
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalDiscountT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="NetBillAmount">
                                    <ItemTemplate>
                                        <%# Eval("NetBillAmount")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblNetBillAmountT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TotalDeposit">
                                    <ItemTemplate>
                                        <%# Eval("TotalDeposit")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalDepositT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TotalRefund">
                                    <ItemTemplate>
                                        <%# Eval("TotalRefund")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalRefundT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ReceiveAmt">
                                    <ItemTemplate>
                                        <%# Eval("ReceiveAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblReceiveAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OutStanding">
                                    <ItemTemplate>
                                        <%# Eval("OutStanding")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblOutStandingT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TDS">
                                    <ItemTemplate>
                                        <%# Eval("TDS")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTDST" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DeductionAcceptable">
                                    <ItemTemplate>
                                        <%# Eval("DeductionAcceptable")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblDeductionAcceptableT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DeductionNonAcceptable">
                                    <ItemTemplate>
                                        <%# Eval("DeductionNonAcceptable")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblDeductionNonAcceptableT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="WriteOff">
                                    <ItemTemplate>
                                        <%# Eval("WriteOff")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblWriteOffT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="CreditAmt">
                                    <ItemTemplate>
                                        <%# Eval("CreditAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblCreditAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="DebitAmt">
                                    <ItemTemplate>
                                        <%# Eval("DebitAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblDebitAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ServiceTaxAmt">
                                    <ItemTemplate>
                                        <%# Eval("ServiceTaxAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblServiceTaxAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ServiceTaxSurChgAmt">
                                    <ItemTemplate>
                                        <%# Eval("ServiceTaxSurChgAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblServiceTaxSurChgAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="DiscountOnBillReason" HeaderText="DiscountOnBillReason">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="150px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="150px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ApprovalBy" HeaderText="ApprovalBy">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Panel" HeaderText="Panel">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="PanelApprovedAmt">
                                    <ItemTemplate>
                                        <%# Eval("PanelApprovedAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblPanelApprovedAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="PolicyNo" HeaderText="PolicyNo">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CardNo" HeaderText="CardNo">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ClaimNo" HeaderText="ClaimNo">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PanelAppRemarks" HeaderText="PanelAppRemarks">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PanelApprovalDate" HeaderText="PanelApprovalDate">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BillGeneratedBy" HeaderText="BillGeneratedBy">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BillingStatus" HeaderText="BillingStatus">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>                
            </table>
        </div>
    </asp:Panel>
        <cc1:ModalPopupExtender ID="mpSelect" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlDetail" PopupDragHandleControlID="dragHandle"
            TargetControlID="Button1" X="50" Y="50">
        </cc1:ModalPopupExtender>
        <div style="display: none;">
            <asp:Button ID="Button1" runat="server" Text="Button" /></div>
    </form>

   
</body>
</html>
