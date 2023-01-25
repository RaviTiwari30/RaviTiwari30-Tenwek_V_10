<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetDeactivationApproval.aspx.cs" Inherits="Design_Equipment_Transactions_AssetDeactivationApproval" %>

<%@ Register Src="../../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../Equipment.css" rel="stylesheet" type="text/css" />
   
    </head>
<body style="margin-top: 1px; margin-left: 1px;">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="smManager" runat="server">
            </asp:ScriptManager> 
        <%--<asp:UpdatePanel ID="up1" runat="server">
    <ContentTemplate>--%>
        <div class="POuter_Box_Inventory">
          
            <div class="content" style="text-align: center">
                <b>&nbsp;Asset Deactivation Approval<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b></div>
        </div>

           <div>
  
<div class="POuter_Box_Inventory">
            <div class="showheader">Search</div>
            <div>
                <table style="text-align:left;">
                                                <tr>
                                                    <td class="auto-style21">From Date</td>
                                                    <td class="auto-style22">
                            <uc1:EntryDate ID="ucfromdate" runat="server" />
                                                    </td>
                                                    <td class="auto-style20">
                                                        To Date</td>
                                                    <td class="auto-style15">
                            <uc1:EntryDate ID="uctodate" runat="server" />
                                                    </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style19" colspan="4" style="text-align:center;">
                                                        <asp:Button ID="btn_search" runat="server" Text="Search" OnClick="Button1_Click" />
                                                      </td>
                                                    <td class="auto-style5"> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
               <div class="showheader">Request List</div>
            <div class="content" style="overflow: scroll; height: 150px; width: 95%;">
           
                <asp:GridView ID="gridsaledetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    EnableModelValidation="True" Width="1019px" OnRowCommand="gridsaledetail_RowCommand" >
                    <Columns>
                         <asp:TemplateField HeaderText="Show">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit0" ToolTip="Edit Asset" runat="server" ImageUrl="../../Purchase/Image/edit.png"
                                    CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="EditData" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Asset Name">
                            <ItemStyle CssClass="GridViewItemStyle" Width="180px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                               
                                <%#Eval("itemname") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Purchaser">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                             
                             <ItemTemplate>
                                <%#Eval("vendorname") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                         <asp:TemplateField HeaderText="Deactive Cause">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                             <%#Eval("Deactive_cause") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                       
                        
                        <asp:TemplateField HeaderText="Contact Person">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("CONTACT_PERSON") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                         <asp:TemplateField HeaderText="Contact Person Ph">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("CONTACT_PERSON_Ph") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            
            
            </div>
        </div>

               <asp:Panel ID="pnl" runat="server" Visible="false">

                   <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="showheader">Deactivation Detail</div>
            <table style="text-align:left;">
                                                
                                                <tr>
                                                    <td class="auto-style18">Asset Name</td>
                                                    <td class="auto-style8">
                                                        <asp:TextBox ID="txtasset" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                    </td>
                                                    <td class="auto-style9">
                                                        Serial No</td>
                                                    <td class="auto-style10">
                                                        <asp:TextBox ID="txtserial" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                    </td>
                                                    <td class="auto-style11">
                                                        Model No</td>
                                                    <td class="auto-style7">
                                                        <asp:TextBox ID="txtmodel" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style18">Supplier</td>
                                                    <td class="auto-style8"> 
                                                        <asp:TextBox ID="txtsupplier" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Amount</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtamount" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> Contact Person</td>
                                                    <td class="auto-style7"> 
                                                        <asp:TextBox ID="txtconper" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                              
                                                      <tr>
                                                          <td class="auto-style18">&nbsp;</td>
                                                          <td class="auto-style8">&nbsp;</td>
                                                          <td class="auto-style9">&nbsp;</td>
                                                          <td class="auto-style10">&nbsp;</td>
                                                          <td class="auto-style11">&nbsp;</td>
                                                          <td class="auto-style7">&nbsp;</td>
                                                      </tr>
                                              
                                                  </table>
        </div>

           <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="showheader">Final Approval</div>
            <table style="text-align:left;">
                                                
                                                <tr>
                                                    <td class="auto-style18">Approved&nbsp; By </td>
                                                    <td class="auto-style8">
                                                        <asp:TextBox ID="TextBox1" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                    </td> <td class="auto-style18">Remark</td>
                                                    <td class="auto-style8"> 
                                                        <asp:TextBox ID="TextBox4" runat="server" ReadOnly="True" Width="150px" TextMode="MultiLine"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                                                           
                                                  <tr>
                                                      <td class="auto-style18">&nbsp;</td>
                                                      <td class="auto-style8">&nbsp;</td>
                                                      <td class="auto-style18">&nbsp;</td>
                                                      <td class="auto-style8">&nbsp;</td>
                                                </tr>
                                                                                           
                                                  </table>
        </div>        
         <div class="POuter_Box_Inventory" style="text-align: center">
             <asp:Button ID="btnsave" runat="server" Text="Save" /><asp:Button ID="btnclear" runat="server" Text="Clear" />
         </div> 
              
         </asp:Panel>
                   <div class="POuter_Box_Inventory" style="text-align: center">
               <div class="showheader">InHouse Maintenance List</div>
            <div class="content" style="overflow: scroll; height: 150px; width: 95%;">
           
                <asp:GridView ID="gridviewoutdetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    EnableModelValidation="True" Width="833px"   >
                    <Columns>
                         <asp:TemplateField HeaderText="Show">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit" ToolTip="Edit Asset" runat="server" ImageUrl="../../Purchase/Image/edit.png"
                                    CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="EditData" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Asset">
                            <ItemStyle CssClass="GridViewItemStyle" Width="350px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                               
                                <%#Eval("itemname") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%--<asp:TemplateField HeaderText="Time Spent">
                            <ItemStyle CssClass="GridViewItemStyle" Width="180px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                               
                                <%#Eval("time_spent") %>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                         <asp:TemplateField HeaderText="Completed Date">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                             
                             <ItemTemplate>
                                <%#Eval("cdate") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                         <asp:TemplateField HeaderText="Feedback">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                             <%#Eval("feedback") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                      <%--   <asp:TemplateField HeaderText="Maintenance Cost">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("maintenance_cost") %>
                             </ItemTemplate>
                         </asp:TemplateField>

                        <asp:TemplateField HeaderText="Maintenance Category">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("maintenance_category") %>
                             </ItemTemplate>
                         </asp:TemplateField>--%>
                    </Columns>
                </asp:GridView>
            
            
            </div>
        </div>

                 
        
          </div> 
       



        


         <%#Eval("itemname") %>
        <asp:Panel ID="pnlLog" runat="server" Style="width: 600px; border: outset; background-color: #EAF3FD;
            display: none;">
            <div id="Div1" class="Purchaseheader" style="text-align: center">
                Log Detail
            </div>
            <div style="overflow: scroll; height: 250px; width: 595px; text-align: left; border: groove;">
                <asp:Label ID="lblLog" runat="server"></asp:Label>
            </div>
            <div style="text-align: center;">
                <asp:Button ID="btnClose" runat="server" CssClass="ItDoseButton" Text="Close" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mdpLog" runat="server" CancelControlID="btnClose" TargetControlID="btnHidden"
            BackgroundCssClass="filterPupupBackground" PopupControlID="pnlLog" X="100" Y="80">
        </cc1:ModalPopupExtender>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" Text="Button" />
        </div>
    </form>
</body>
</html>
