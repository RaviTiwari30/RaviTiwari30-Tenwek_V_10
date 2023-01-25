<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MISOPDAnalysis.aspx.cs" Inherits="Design_MIS_MISOPD" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
    
<head runat="server">
<link href="../../../Styles/PurchaseStyle.css"  rel="stylesheet" type="text/css" />
        <title>MIS-OPD Analysis</title>
        <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../../Scripts/ScrollableGrid.js"></script>

    <script type="text/javascript" src="../../../Scripts/jquery.tooltip.js"></script>
    
    
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

    
    <div>

   <script type="text/javascript" language="javascript">
    $(document).ready(function() {
        
      //  $('#<%=grdDetails.ClientID %>').Scrollable({ScrollHeight: 400});
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
                                                        ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDateC">
                                                    </cc1:CalendarExtender>
                                                </td>
                                                <td style="width: 5%; text-align: center;">
                                                    To
                                                </td>
                                                <td style="width: 15%; text-align: left;">
                                                    <asp:TextBox ID="txtToDateC" runat="server" Width="96px" BackColor="#FFFFC0" CssClass="ItDoseTextinputText"></asp:TextBox><cc1:CalendarExtender ID="CalendarExtender1"
                                                        runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDateC">
                                                    </cc1:CalendarExtender>
                                                </td>
                                                <td style="width: 26%; text-align: left;">
                                                    <asp:RadioButtonList ID="rbtViewType" runat="server" RepeatDirection="Horizontal" CssClass="ItDoseRadiobuttonlist">
                                                        <asp:ListItem Selected="True" Value="1">By Actual Figure</asp:ListItem>
                                                        <asp:ListItem Value="2">By Avg Per Day</asp:ListItem>
                                                    </asp:RadioButtonList></td>
                                                    <td style="width: 20%; text-align: left;">
                                                    <asp:Button ID="btnCompare" runat="server" OnClick="btnCompare_Click" Text="View" CssClass="ItDoseButton" />
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
                                        <asp:Label ID="lblItemwiseC" runat="server" ForeColor="Maroon" Text="Service-Wise" Visible="False"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%;" valign="top">
                                        <asp:GridView ID="grdDocC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowDataBound="grdDocC_RowDataBound" OnRowCommand="grdDocC_RowCommand">                                            
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">                                                    
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex+1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Name" HeaderText="Name">
                                                    <ItemStyle Width="140px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Net" HeaderText="Net">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%#Eval("DoctorID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompDoc" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblDocQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblDocGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblDocDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblDocNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                        <asp:Label ID="lblDocCollectedGrowth" runat="server" Visible="false" Text='<%# Eval("CollectedGrowth") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                    <td style="width: 50%" valign="top">
                                        <asp:GridView ID="grdSpecC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowDataBound="grdSpecC_RowDataBound" OnRowCommand="grdSpecC_RowCommand">
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemStyle Width="25px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex+1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Name" HeaderText="Name">
                                                    <ItemStyle Width="140px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Net" HeaderText="Net">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompSpec" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblSpecQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblSpecGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblSpecDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblSpecNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                        <asp:Label ID="lblSpecCollectedGrowth" runat="server" Visible="false" Text='<%# Eval("CollectedGrowth") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%; text-align: center;" valign="top">
                                        <asp:Label ID="lblGroupC" runat="server" ForeColor="Maroon" Text="Dept-wise / Group-wise" Visible="False"></asp:Label>
                                    </td>
                                    <td style="width: 50%; text-align: center;" valign="top">
                                        <asp:Label ID="lblPanelC" runat="server" ForeColor="Maroon" Text="Panel-wise" Visible="False"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 50%; ">
                                        <asp:GridView ID="grdSubCatC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowDataBound="grdSubCatC_RowDataBound" OnRowCommand="grdSubCatC_RowCommand">
                                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemStyle Width="25px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex+1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Name" HeaderText="Name">
                                                    <ItemStyle Width="140px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Net" HeaderText="Net">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("SubCategoryID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompSubcat" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblSubCatQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblSubCatGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblSubCatDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblSubCatNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                        <asp:Label ID="lblSubCatCollectedGrowth" runat="server" Visible="false" Text='<%# Eval("CollectedGrowth") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                    <td style="width: 50%">
                                        <asp:GridView ID="grdPanelC" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            Width="465px" OnRowDataBound="grdPanelC_RowDataBound" OnRowCommand="grdPanelC_RowCommand">
                                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemStyle Width="25px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex+1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Name" HeaderText="Name">
                                                    <ItemStyle Width="140px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                    <ItemStyle HorizontalAlign="Center" Width="40px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Gross" HeaderText="Gross">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Disc" HeaderText="Disc.">
                                                    <ItemStyle HorizontalAlign="Right" Width="60px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Net" HeaderText="Net">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Collected" HeaderText="Collected">
                                                    <ItemStyle HorizontalAlign="Right" Width="80px" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="V" >
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                    <ItemTemplate>
                                                        <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="~/Images/view.GIF" CausesValidation="false" CommandArgument='<%# Eval("PanelID")+"#"+Eval("CompType")%>' CommandName="View" />
                                                        <asp:Label ID="lblCompPanel" runat="server" Visible="false" Text='<%# Eval("CompType") %>' />
                                                        <asp:Label ID="lblPanelQtyGrowth" runat="server" Visible="false" Text='<%# Eval("QtyGrowth") %>' />
                                                        <asp:Label ID="lblPanelGrossGrowth" runat="server" Visible="false" Text='<%# Eval("GrossGrowth") %>' />
                                                        <asp:Label ID="lblPanelDiscGrowth" runat="server" Visible="false" Text='<%# Eval("DiscGrowth") %>' />
                                                        <asp:Label ID="lblPanelNetGrowth" runat="server" Visible="false" Text='<%# Eval("NetGrowth") %>' />
                                                        <asp:Label ID="lblPanelCollectedGrowth" runat="server" Visible="false" Text='<%# Eval("CollectedGrowth") %>' />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                       
    </div>
    <asp:Panel ID="pnlDetail" runat="server" CssClass="pnlItemsFilter" Height="420px" Style="display: none;overflow:auto"
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
        <div class="content">
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 100%;">
                        <asp:GridView ID="grdDetails" runat="server" AutoGenerateColumns="False" 
                        CssClass="GridViewStyle" ShowFooter="true" Width="875px" OnRowDataBound="grdDetails_RowDataBound" >
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle"  />
                            <Columns>
                                <asp:BoundField DataField="Date" HeaderText="Date">
                                    <ItemStyle Width="70px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                    <FooterStyle CssClass="GridVsiewFooterStyle" Width="70px" />
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
                                
                                <asp:TemplateField  HeaderText="Disc">
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
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpSelect" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlDetail" PopupDragHandleControlID="dragHandle"
        TargetControlID="Button1" X="50" Y="50">
    </cc1:ModalPopupExtender>
    <div style="display:none;"> <asp:Button ID="Button1" runat="server" Text="Button" /></div>
    
    </form>

    <script type="text/javascript">
         $('.example3tooltip').tooltip({ 
tooltipSourceID:'#example3Content', 
loader:1, 
loaderImagePath:'animationProcessing.gif', 
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
