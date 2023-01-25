<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MISIPDAdmission.aspx.cs" Inherits="Design_MIS_MISIPDAdmission" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
    
<head runat="server">
<link href="../../../Styles/PurchaseStyle.css"  rel="stylesheet" type="text/css" />
        <title>MIS-IPD</title>
    
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../../Scripts/ScrollableGrid.js"></script>
      
    
</head>
<body>
    <form id="form1" runat="server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    
    <div>

        <script type="text/javascript" language="javascript">
$(document).ready(function() {
$('#<%=grdDoc.ClientID %>').Scrollable({ScrollHeight: 200});
$('#<%=grdSpec.ClientID %>').Scrollable({ScrollHeight: 200});
$('#<%=grdRoom.ClientID %>').Scrollable({ScrollHeight: 200});
$('#<%=grdPanel.ClientID %>').Scrollable({ScrollHeight: 200});



}
)
        </script>
    
     <table cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                                <tr>
                                    <td colspan="2" style="text-align: center; width: 50%;" valign="top">
                                        <asp:Label ID="lblClicked" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%; text-align: center" valign="top">
                                        <asp:Label ID="lblDoc" runat="server" ForeColor="Maroon" Font-Bold="True" Text="Doctor-wise"></asp:Label>
                                    </td>
                                    <td style="width: 50%; text-align: center" valign="top">
                                        <asp:Label ID="lblItemwise" runat="server" ForeColor="Maroon" Font-Bold="True" Text="Specialization-wise"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%;" valign="top">
                                        <asp:GridView ID="grdDoc" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowCommand="grdDoc_RowCommand">
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
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="340px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>                                                
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("DoctorID")%>' CommandName="View" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                    <td style="width: 50%" valign="top">
                                        <asp:GridView ID="grdSpec" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowCommand="grdSpec_RowCommand">
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
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="340px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>                                                
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("ItemID")%>' CommandName="View" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%; text-align: center;" valign="top">
                                        <asp:Label ID="lblGroup" runat="server" ForeColor="Maroon" Font-Bold="True" Text="RoomType-wise"></asp:Label>
                                    </td>
                                    <td style="width: 50%; text-align: center;" valign="top">
                                        <asp:Label ID="lblPanel" runat="server" ForeColor="Maroon" Font-Bold="True" Text="Panel-wise"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%; ">
                                        <asp:GridView ID="grdRoom" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowCommand="grdRoom_RowCommand">
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
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="340px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>
                                                
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("IPDCaseType_ID")%>' CommandName="View" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                    <td style="width: 50%">
                                        <asp:GridView ID="grdPanel" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowCommand="grdPanel_RowCommand">
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
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="340px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                                </asp:BoundField>  
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>                                              
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("PanelID")%>' CommandName="View" />
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
                        CssClass="GridViewStyle" ShowFooter="true" OnRowDataBound="grdDetails_RowDataBound" >
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
                                 <asp:BoundField DataField="ActualDayStay" HeaderText="Actual Day  Stay" FooterText="Total :">
                                 <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>                                
                                 <asp:TemplateField HeaderText="Total Billed Amt.">
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
    <div style="display:none;"> <asp:Button ID="Button1" runat="server" Text="Button" />&nbsp;</div>
    
    </form>    
</body>
</html>
