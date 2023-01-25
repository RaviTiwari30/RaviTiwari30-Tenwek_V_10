<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MISIPDPackageAnalysis.aspx.cs"
    Inherits="Design_MIS_MISIPDPackageAnalysis" %>

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
        $('#<%=grdSubCatC.ClientID %>').Scrollable({ScrollHeight: 200});
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
                                        ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" 
                                        TargetControlID="txtFromDateC" PopupButtonID="txtFromDateC">
                                    </cc1:CalendarExtender>
                                </td>
                                <td style="width: 5%; text-align: center;">
                                    To
                                </td>
                                <td style="width: 15%; text-align: left;">
                                    <asp:TextBox ID="txtToDateC" runat="server" Width="96px" BackColor="#FFFFC0" CssClass="ItDoseTextinputText"></asp:TextBox><cc1:CalendarExtender
                                        ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" 
                                        TargetControlID="txtToDateC" PopupButtonID="txtToDateC">
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
                            OnRowCommand="grdDocC_RowCommand" Width="465px" OnRowDataBound="grdDocC_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="140px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Net" HeaderText="Net">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%#Eval("DoctorID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompDoc" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblDocQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblDocGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblDocDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblDocNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                           
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="width: 50%" valign="top">
                        <asp:GridView ID="grdSpecC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdSpecC_RowCommand" Width="465px" OnRowDataBound="grdSpecC_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="140px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Net" HeaderText="Net">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                       <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompSpec" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblSpecQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblSpecGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblSpecDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblSpecNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                        
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="width: 50%; text-align: center;" valign="top">
                        <asp:Label ID="lblGroupC" runat="server" ForeColor="Maroon" Text="Dept-wise / Group-wise"
                            Visible="False"></asp:Label>
                    </td>
                    <td style="width: 50%; text-align: center;" valign="top">
                        <asp:Label ID="lblPanelC" runat="server" ForeColor="Maroon" Text="Panel-wise" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 50%;">
                        <asp:GridView ID="grdSubCatC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdSubCatC_RowCommand" Width="465px" OnRowDataBound="grdSubCatC_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="140px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Net" HeaderText="Net">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                       <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("SubCategoryID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompSubcat" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblSubCatQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblSubCatGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblSubCatDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblSubCatNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                        
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="width: 50%">
                        <asp:GridView ID="grdPanelC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdPanelC_RowCommand" Width="465px" OnRowDataBound="grdPanelC_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="140px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Net" HeaderText="Net">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("PanelID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompPanel" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblPanelQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblPanelGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblPanelDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblPanelNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                        
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlItemsFilter" Height="420px"
            Style="display: none" TabIndex="3" Width="910px">
            <div id="dragHandle" runat="server" class="Purchaseheader">
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td style="width: 95%">
            Details :</td>
                        <td align="right" style="width: 5%">
                            <asp:ImageButton ID="btnRCancel" runat="server" CssClass="ItDoseButton" Height="16px"
                                ImageUrl="~/Images/Delete.gif" TabIndex="3" Width="15px" /></td>
                    </tr>
                </table>
            </div>
            <div style="overflow: auto; max-width: 895px; max-height: 365px">
                <table cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td style="width: 100%">
                            <asp:GridView ID="grdDetails" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                ShowFooter="true" Width="875px">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:BoundField DataField="Date" HeaderText="Date">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="70px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="70px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MR_No" HeaderText="UHID">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="40px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PName" HeaderText="PName">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="DocName" HeaderText="Doc. Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Department" HeaderText="Department">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ItemName" FooterText="Total :" HeaderText="Item Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Qty.">
                                        <ItemTemplate>
                                            <%# Eval("Qty")%>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Label ID="lblQtyT" runat="server"></asp:Label>
                                        </FooterTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="80px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Gross">
                                        <ItemTemplate>
                                            <%# Eval("Gross")%>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Label ID="lblGrossT" runat="server"></asp:Label>
                                        </FooterTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="80px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Disc.">
                                        <ItemTemplate>
                                            <%# Eval("Disc")%>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Label ID="lblDiscT" runat="server"></asp:Label>
                                        </FooterTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="60px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Net">
                                        <ItemTemplate>
                                            <%# Eval("Net")%>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            <asp:Label ID="lblNetT" runat="server"></asp:Label>
                                        </FooterTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="80px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Panel" HeaderText="Panel">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="GivenBy" HeaderText="Given By">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                        <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
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
