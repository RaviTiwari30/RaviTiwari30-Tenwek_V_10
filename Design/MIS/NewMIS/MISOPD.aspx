<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MISOPD.aspx.cs" Inherits="Design_MIS_MISOPD" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
    
<head runat="server">
<link href="../../../Styles/PurchaseStyle.css"  rel="stylesheet" type="text/css" />
        <title>MIS-OPD</title>

        <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../../Scripts/ScrollableGrid.js"></script>

    <script type="text/javascript" src="../../../Scripts/jquery.tooltip.js"></script>
   
   <script type="text/javascript" language="javascript">
       $(document).ready(function () {
           $('#<%=grdDoc.ClientID %>').Scrollable({ ScrollHeight: 200 });
           $('#<%=grdSpec.ClientID %>').Scrollable({ ScrollHeight: 200 });
           $('#<%=grdSubCat.ClientID %>').Scrollable({ ScrollHeight: 195 });
           $('#<%=grdPanel.ClientID %>').Scrollable({ ScrollHeight: 195 });
       });
    
        </script> 
    
  <script language="javascript" type="text/javascript">
    
     function showDiv(str)
     {     
        $('#example3Content').html(document.getElementById(str).innerHTML);
     }

    </script>
    
    
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
        &nbsp;<table cellpadding="0" cellspacing="0" style="width: 100%; height: 100%; overflow-x:scroll;">
                                <tr>
                                    <td colspan="2" style="text-align: center; width: 50%;" valign="top">
                                        <asp:Label ID="lblClicked" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%; text-align: center" valign="top">
                                        <asp:Label ID="lblDoc" runat="server" ForeColor="Maroon" Font-Bold="true" Text="Doctor-wise"></asp:Label>
                                    </td>
                                    <td style="width: 50%; text-align: center" valign="top">
                                        <asp:Label ID="lblItemwise" runat="server" ForeColor="Maroon" Font-Bold="true" Text="Service-Wise"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%;" valign="top">
                                        <asp:GridView ID="grdDoc" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowCommand="grdDoc_RowCommand" OnSelectedIndexChanged="grdDoc_SelectedIndexChanged">
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
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
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
                                            Width="490px" OnRowCommand="grdSpec_RowCommand">
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
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
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
                                        <asp:Label ID="lblGroup" runat="server" ForeColor="Maroon" Font-Bold="true"  Text="Dept-wise / Group-wise"></asp:Label>
                                    </td>
                                    <td style="width: 50%; text-align: center;" valign="top">
                                        <asp:Label ID="lblPanel" runat="server" ForeColor="Maroon" Font-Bold="true" Text="Panel-wise"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%; ">
                                        <asp:GridView ID="grdSubCat" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="476px" OnRowCommand="grdSubCat_RowCommand">
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
                                                    <ItemStyle CssClass="GridViewItemStyle" Width="100px" />
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
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("SubCategoryID")%>' CommandName="View" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                    <td style="width: 50%">
                                        <asp:GridView ID="grdPanel" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowCommand="grdPanel_RowCommand">
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
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
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

    
    <div>
        &nbsp;</div>
    <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlItemsFilter"  Height="420px" style="display:none;overflow:auto"
        TabIndex="3" Width="910px"  >
        <div id="dragHandle" runat="server" classclass="Purchaseheader" >
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 95%" >
           <b>Details :</b></td>
                    <td style="width: 5%;" align="right">
                        <asp:ImageButton ID="btnRCancel" runat="server" CssClass="ItDoseButton" TabIndex="3"
                         ImageUrl="~/Images/Delete.gif"  Width="15px" Height="16px" /></td>
                </tr>
            </table>
        </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 100%">
                        <asp:GridView ID="grdDetails" runat="server" AutoGenerateColumns="False" 
                        CssClass="GridViewStyle" ShowFooter="true" Width="875px" OnRowDataBound="grdDetails_RowDataBound" >
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
                                <asp:BoundField DataField="Specialization" HeaderText="Specialization">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="100px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="100px" />
                                </asp:BoundField>    
                                <asp:BoundField DataField="Panel" HeaderText="Panel" >
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" Width="120px" />
                                </asp:BoundField>
                                 <asp:TemplateField HeaderText="Receipt No." FooterText="Total">
                                    <ItemTemplate>                                       
                                        <asp:Label ID="lblReceiptNo" runat="server" Text='<% #Eval("ReceiptNo") %>'></asp:Label>
                                        <div id="dvDetail" runat="server" style="position: absolute; display: none;">
                                        
                                        </div>
                                    </ItemTemplate>                                    
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="120px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right"  Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Gross">
                                    <ItemTemplate>
                                        <%# Eval("Gross")%>
                                        <asp:Label ID="lblLedgerTransactionNo" runat="server" Visible="false" Text='<% #Eval("LedgerTransactionNo") %>'></asp:Label>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblGrossT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right"  Width="80px" />
                                </asp:TemplateField>
                                
                                <asp:TemplateField  HeaderText="Disc.">
                                <ItemTemplate>
                                        <%# Eval("Disc")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblDiscT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="60px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right"  Width="60px" />
                                </asp:TemplateField>
                                <asp:TemplateField  HeaderText="Net">
                                <ItemTemplate>
                                        <%# Eval("Net")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblNetT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right"  Width="80px" />
                                 </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Collected">
                                    <ItemTemplate>
                                        <%# Eval("Collected")%>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <asp:Label ID="lblCollectedT" runat="server"></asp:Label>
                                    </FooterTemplate>
                                    
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="80px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                    <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="80px" />                                    
                                    
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100%; text-align: center">
                        &nbsp;</td>
                </tr>
            </table>           
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpSelect" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlDetail" PopupDragHandleControlID="dragHandle"
        TargetControlID="Button1" X="50" Y="50"  BehaviorID="mpSelect">
    </cc1:ModalPopupExtender>
        
    <div style="display:none;"> <asp:Button ID="Button1" runat="server" Text="Button" /></div>
    
    </form>

    <script type="text/javascript">
         $('.example3tooltip').tooltip({ 
tooltipSourceID:'#example3Content', 
loader:1, 
loaderHeight:16, 
loaderWidth:17, 
width:'auto', 
height:'auto', 
tooltipSource:'inline', 
borderSize:'1', 
borderColor:'black', 
tooltipBGColor:'#FFFFC0' 
});
    </script>
    <div id="example3Content" style="display:none; "> 
</div>
    
</body>
</html>
