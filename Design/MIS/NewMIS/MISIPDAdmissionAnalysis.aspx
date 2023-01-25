<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MISIPDAdmissionAnalysis.aspx.cs"
    Inherits="Design_MIS_MISIPDAdmissionAnalysis" %>

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
        $('#<%=grdRoomC.ClientID %>').Scrollable({ScrollHeight: 200});
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
                            Width="465px" OnRowCommand="grdDocC_RowCommand" OnRowDataBound="grdDocC_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle Width="340px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCompDoc" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblDocQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("DoctorID")+"#"+Eval("CompType")%>' CommandName="View" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="width: 50%" valign="top">
                        <asp:GridView ID="grdSpecC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            Width="465px" OnRowCommand="grdSpecC_RowCommand" OnRowDataBound="grdSpecC_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle Width="340px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCompSpec" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblSpecQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("CompType")%>' CommandName="View" />
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
                        <asp:GridView ID="grdRoomC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            Width="465px" OnRowCommand="grdRoomC_RowCommand" OnRowDataBound="grdRoomC_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle Width="340px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCompRoom" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblRoomQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF"
                                            CausesValidation="false" CommandArgument='<%# Eval("IPDCaseType_ID")+"#"+Eval("CompType")%>' CommandName="View" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                    <td style="width: 50%">
                        <asp:GridView ID="grdPanelC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            Width="465px" OnRowCommand="grdPanelC_RowCommand" OnRowDataBound="grdPanelC_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle Width="25px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name">
                                    <ItemStyle Width="340px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="V">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCompPanel" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                        <asp:Label ID="lblPanelQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
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
                       <asp:GridView ID="grdDetails" runat="server" AutoGenerateColumns="False" width="850px"
                        CssClass="GridViewStyle" ShowFooter="true" >
                            <AlternatingRowStyle CssClass="GridViewAltItemStyleMIS" />
                            <Columns>
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
                                <asp:BoundField DataField="PatientName" HeaderText="PName">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Age" HeaderText="Age/Sex">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                </asp:BoundField>                                
                                 <asp:BoundField DataField="AdmitDate" HeaderText="Admit Date">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="AdmitTime" HeaderText="Admit Time">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="DischargeDate" HeaderText="Disch. Date">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="DischargeTime" HeaderText="Disch. Time">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="Cunsultant1" HeaderText="Cunsultant">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="Status" HeaderText="Status">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="Panel" HeaderText="Panel">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="140px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="140px" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="DischargeType" HeaderText="Discharge Type">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="AdmittedIn" HeaderText="Admitted In">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DischargeFrom" HeaderText="Discharge From">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DatewiseStay" HeaderText="Datewise Stay">
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>
                                
                                 <asp:BoundField DataField="HourlyStay" HeaderText="Hourly Stay">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>                                
                                 <asp:BoundField DataField="ActualDayStay" HeaderText="ActualDayStay" FooterText="Total :">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>                                
                                 <asp:TemplateField HeaderText="TotalBilledAmt">
                                    <ItemTemplate>
                                        <%# Eval("TotalBilledAmt")%>                                        
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalBilledAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Total Disc.">
                                    <ItemTemplate>
                                        <%# Eval("TotalDiscount")%>                                        
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblTotalDiscountT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Net Bill Amt.">
                                    <ItemTemplate>
                                        <%# Eval("NetBillAmount")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblNetBillAmountT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Receive Amt.">
                                    <ItemTemplate>
                                        <%# Eval("ReceiveAmt")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblReceiveAmtT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OutStanding">
                                    <ItemTemplate>
                                        <%# Eval("OutStanding")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblOutStandingT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="120px" />
                                </asp:TemplateField>
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
