<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="MISNew.aspx.cs" Inherits="Design_MIS_MISNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="600">
    </Ajax:ScriptManager>
   
     <div id="Pbody_box_inventory">
          <div class="POuter_Box_Inventory" style="text-align: center;">               
                    <b>Management Information System</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
 <div class="POuter_Box_Inventory">
       <div class="row">
                <div class="col-md-1"></div>
                 
                <div class="col-md-2">
                      <label class="pull-left bold">From Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                      <label class="pull-left bold">To Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                 <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"></asp:TextBox>
                 <cc1:CalendarExtender ID="CalendarExtender3" runat="server" Animated="true" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                </div>
           <div class="col-md-6">
                         <asp:RadioButtonList ID="rbtDateType" runat="server" RepeatDirection="Horizontal" Style="margin-left: 0px">
                            <asp:ListItem Selected="True" Value="1">Revenue Generated</asp:ListItem>
                            <asp:ListItem Value="2">Service Rendered</asp:ListItem>
                        </asp:RadioButtonList>
                </div>
                <div class="col-md-2">
                                            <asp:Button ID="btnView" runat="server" Text="View" CssClass="ItDoseButton" OnClick="btnView_Click" />
                    <%--<input type="button" class="ItDoseButton" id="btnSearch" value="Search" onclick="return btnSearch_onclick()" />--%>&nbsp;
                </div>
                
            </div>
  </div>
            
      
                 <div class="POuter_Box_Inventory">
                <div class="row">
    <Ajax:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table cellpadding="0" cellspacing="0" style="width: 100%; height: 100%;" >
               
                <tr>
                    <td colspan="7">
                        <cc1:TabContainer ID="TabContainer1" runat="server" Width="100%" Height="500px"
                            ActiveTabIndex="1" OnActiveTabChanged="TabContainer1_ActiveTabChanged" AutoPostBack="True">
                            <cc1:TabPanel ID="tpOverview" runat="server" HeaderText="Overview" Height="495px">
                                <ContentTemplate>
                                    <div style="overflow: scroll; height: 100%">
                                        <table width="100%">
                                            <tr>
                                                <td valign="top">
                                                    <table cellpadding="0"  cellspacing="0" style="width: 100%">
                                                        <tr>
                                                            <td style="width: 40%; text-align: center">
                                                                <label runat="server" id="lblOPD" class="ItDoseLabelBl" style="font: bold"></label></td>
                                                            <td style="width: 20%">&nbsp;</td>
                                                            <td style="width: 40%; text-align: center;"><strong><span runat="server" id="lblOverAllCASH" style="font-size: 8pt; color: #800000"> </span></strong></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 40%" valign="top">
                                                                <asp:GridView ID="grdOPDSummary" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                                                    Width="600px" ShowFooter="True" OnRowCommand="grdOPDSummary_RowCommand">
                                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="S.No.">
                                                                            <ItemTemplate>
                                                                                <%# Container.DataItemIndex+1 %>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="50px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="TypeOfTnx" HeaderText="Type of Transactions" FooterText="Total">
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="240px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="240px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="60px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="60px" />
                                                                        </asp:BoundField>

                                                                        <asp:TemplateField HeaderText="Gross">
                                                                            <FooterTemplate>
                                                                                <asp:Label ID="lblGrossT" runat="server"></asp:Label>
                                                                            </FooterTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblGrossTItem" runat="server" Text='<% #Eval("Gross")%>'></asp:Label>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="100px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Disc.">
                                                                            <FooterTemplate>
                                                                                <asp:Label ID="lblDiscT" runat="server"></asp:Label>
                                                                            </FooterTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblDiscTItem" runat="server" Text='<% #Eval("Disc")%>'></asp:Label>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="100px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Net">
                                                                            <FooterTemplate>
                                                                                <asp:Label ID="lblNetT" runat="server"></asp:Label>
                                                                            </FooterTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblNetTItem" runat="server" Text='<% #Eval("Net")%>'></asp:Label>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="100px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Collected">
                                                                            <FooterTemplate>
                                                                                <asp:Label ID="lblCollectedT" runat="server"></asp:Label>
                                                                            </FooterTemplate>
                                                                            <ItemTemplate>
                                                                                <asp:Label ID="lblCollTItem" runat="server" Text='<% #Eval("Collected")%>'></asp:Label>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="100px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="V">
                                                                            <ItemTemplate>
                                                                                <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="../../Images/view.GIF"
                                                                                    CausesValidation="false" CommandArgument='<%# Eval("TypeOfTnx")+"#"+Eval("DateFrom")+"#"+Eval("DateTo")+"#"+Eval("DateType")  %>'
                                                                                    CommandName="View" />
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="10px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </td>
                                                            <td style="width: 20%">
                                                                <Ajax:UpdateProgress ID="up1" runat="server">
                                                                    <ProgressTemplate>
                                                                        <img src="../../Design/MIS/NewMIS/progress.gif" alt="" />
                                                                    </ProgressTemplate>
                                                                </Ajax:UpdateProgress>
                                                            </td>
                                                            <td style="width: 40%" valign="top">
                                                                <asp:GridView ID="grdCash" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyleMIS"
                                                                    Width="600px">
                                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="S.No.">
                                                                            <ItemTemplate>
                                                                                <%# Container.DataItemIndex+1 %>
                                                                            </ItemTemplate>

                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="TransactionType" HeaderText="Type of Transactions" FooterText="Total">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="240px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="AmtCash" HeaderText="Cash Amt.">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="60px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="AmtCreditCard" HeaderText="Credit Card Amt.">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="60px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="AmtCheque" HeaderText="Cheque Amt.">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="60px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="AmtCredit" HeaderText="Credit Amt.">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="60px" />
                                                                        </asp:BoundField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 40%" align="center"><strong><span id="lblIPDServices" runat="server" style="font-size: 8pt; color: #800000"></span></strong></td>
                                                            <td style="width: 20%">&nbsp;</td>
                                                            <td align="center" style="width: 40%"><strong><span runat="server" id="lblOverAllRevenue" style="font-size: 8pt; color: #800000"></span></strong></td>

                                                        </tr>
                                                        <tr>
                                                            <td style="width: 40%; vertical-align: top">
                                                                <asp:GridView ID="grdIPDServices" runat="server" ShowFooter="True" AutoGenerateColumns="False" CssClass="GridViewStyleMIS"
                                                                    Width="600px" OnRowCommand="grdIPDServices_RowCommand">
                                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="S.No.">
                                                                            <ItemTemplate>
                                                                                <%# Container.DataItemIndex+1 %>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="25px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="TypeOfTnx" HeaderText="Type of Transactions" FooterText="Total">
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="240px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="240px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="60px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="60px" />
                                                                        </asp:BoundField>
                                                                        <asp:TemplateField HeaderText="Gross">
                                                                            <FooterTemplate>
                                                                                <asp:Label ID="lblGrossT" runat="server"></asp:Label>
                                                                            </FooterTemplate>
                                                                            <ItemTemplate>
                                                                                <%#Eval("Gross") %>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="100px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Disc.">
                                                                            <FooterTemplate>
                                                                                <asp:Label ID="lblDiscT" runat="server"></asp:Label>
                                                                            </FooterTemplate>
                                                                            <ItemTemplate>
                                                                                <%#Eval("Disc") %>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="100px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Net">
                                                                            <FooterTemplate>
                                                                                <asp:Label ID="lblNetT" runat="server"></asp:Label>
                                                                            </FooterTemplate>
                                                                            <ItemTemplate>
                                                                                <%#Eval("Net") %>
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" HorizontalAlign="Right" Width="100px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="V">
                                                                            <ItemTemplate>
                                                                                <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="../../Images/view.GIF"
                                                                                    CausesValidation="false" CommandArgument='<%# Eval("TypeOfTnx")+"#"+Eval("DateFrom")+"#"+Eval("DateTo")+"#"+Eval("DateType")  %>'
                                                                                    CommandName="View" />
                                                                            </ItemTemplate>
                                                                            <FooterStyle CssClass="GridViewFooterStyle" Width="10px" />
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </td>
                                                            <td style="width: 20%">&nbsp;</td>
                                                            <td align="center" style="width: 40%">
                                                                <asp:GridView ID="grdRevenue" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                                                    Width="600px">
                                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="S.No.">
                                                                            <ItemTemplate>
                                                                                <%# Container.DataItemIndex+1 %>
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="TypeOfTnx" HeaderText="Type of Transactions" FooterText="Total">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="240px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="60px" />
                                                                        </asp:BoundField>
                                                                        <asp:TemplateField HeaderText="Gross">
                                                                            <ItemTemplate>
                                                                                <%#Eval("Gross") %>
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Disc.">
                                                                            <ItemTemplate>
                                                                                <%#Eval("Disc") %>
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Net">
                                                                            <ItemTemplate>
                                                                                <%#Eval("Net") %>
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" Width="100px" />
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="center" style="width: 40%"><strong><span id="lblIPDStatistics" runat="server" style="font-size: 8pt; color: #800000"></span></strong></td>
                                                            <td style="width: 20%">&nbsp;</td>
                                                            <td style="width: 40%">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td align="center" style="width: 40%; vertical-align: top">


                                                                <asp:GridView ID="grdIPDSummary" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                                                    OnRowCommand="grdIPDSummary_RowCommand" Width="600px">
                                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="S.No.">
                                                                            <ItemTemplate>
                                                                                <%# Container.DataItemIndex+1 %>
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="25px" />
                                                                        </asp:TemplateField>
                                                                        <asp:BoundField DataField="TypeOfTnx" HeaderText="Name">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" Width="340px" />
                                                                        </asp:BoundField>
                                                                        <asp:BoundField DataField="Qty" HeaderText="Qty.">
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                                                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="40px" />
                                                                        </asp:BoundField>
                                                                        <asp:TemplateField HeaderText="V">
                                                                            <ItemTemplate>
                                                                                <asp:ImageButton ID="imbView" ToolTip="View Details" runat="server" ImageUrl="../../Images/view.GIF"
                                                                                    CausesValidation="false" CommandArgument='<%# Eval("TypeOfTnx")+"#"+Eval("DateFrom")+"#"+Eval("DateTo")+"#"+Eval("DateType")  %>'
                                                                                    CommandName="View" />
                                                                            </ItemTemplate>
                                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                </asp:GridView>
                                                                &nbsp;&nbsp;<asp:Label ID="lblOverview" runat="server" CssClass="ItDoseLblSpBl" Visible="False"></asp:Label>
                                                            </td>
                                                            <td style="width: 20%">&nbsp;</td>
                                                            <td style="width: 40%">&nbsp;</td>
                                                        </tr>

                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </ContentTemplate>
                                <HeaderTemplate>Overview</HeaderTemplate>
                            </cc1:TabPanel>
                            <cc1:TabPanel ID="tpDetail" runat="server" HeaderText="Detail" Height="495px">
                                <ContentTemplate>
                                    <iframe id="frmDetail" name="frmDetail" runat="server"  frameborder="0" scrolling="no" width="100%"
                                        height="495px" marginwidth="0" marginheight="0"></iframe>
                                </ContentTemplate>
                                <HeaderTemplate>Detail</HeaderTemplate>
                            </cc1:TabPanel>
                         
                            <cc1:TabPanel ID="tpTrend" runat="server" HeaderText="Trend" Visible="false">
                                <ContentTemplate>
                                    <iframe id="frmTrend" name="frmTrend" runat="server" src="#" frameborder="0" scrolling="no" width="100%" style="display: none" visible="false"
                                        height="495px" marginwidth="0" marginheight="0"></iframe>
                                </ContentTemplate>
                                <HeaderTemplate>Trend</HeaderTemplate>
                            </cc1:TabPanel>
                        </cc1:TabContainer>
                    </td>
                </tr>
            </table>
                
        </ContentTemplate>
    </Ajax:UpdatePanel>
            </div></div>
       
     <style type="text/css">
     .ajax__tab_xp .ajax__tab_header .ajax__tab_tab {
    height: 21px;
    padding: 4px;
    margin: 0px;
    font-size: 12px;
}
   </style>
    </div>
</asp:Content>
