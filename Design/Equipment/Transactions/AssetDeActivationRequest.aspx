<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetDeActivationRequest.aspx.cs" Inherits="Design_Equipment_Transactions_AssetDeActivationRequest" %>


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
        <div class="POuter_Box_Inventory">
            <asp:ScriptManager ID="smManager" runat="server">
            </asp:ScriptManager>
            <div class="content" style="text-align: center">
                <b>&nbsp;Asset Deactivation Request<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="showheader">Asset</div>
            <div>
                <table style="text-align:left;">
                                                <tr>
                                                    <td >Asset</td>
                                                    <td >
                                                        <asp:DropDownList ID="ddlasset" runat="server" width="154px" AutoPostBack="True" OnSelectedIndexChanged="ddlasset_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td >
                                                        <asp:Label ID="lb" runat="server" Visible="false"></asp:Label>
                                                        Serial No</td>
                                                    <td >
                                                        <asp:TextBox ID="txtserial" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                    </td>
                                                    <td class="auto-style5">
                                                        Model No</td>
                                                    <td>
                                                        <asp:TextBox ID="txtmodel" runat="server" ReadOnly="True" width="150px"></asp:TextBox></td>
                                                </tr>
                                                  <tr>
                                                    <td >Deactive Cause</td>
                                                    <td > <asp:TextBox ID="txtdeact" runat="server" Width="150px" TextMode="MultiLine"></asp:TextBox></td>
                                                    <td > &nbsp;</td>
                                                    <td > 
                                                        &nbsp;</td>
                                                    <td > &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="showheader">Purchaser Detail</div>
            <table style="text-align:left;">
                                                <tr>
                                                    <td>Sold&nbsp; To</td>
                                                    <td>
                                                        <asp:DropDownList width="154px" ID="ddlSupplier" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSupplier_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        Address</td>
                                                    <td>
                                                        <asp:TextBox ID="txtaddess" width="150px" runat="server" ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        &nbsp;</td>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td>Amount</td>
                                                    <td> 
                                                        <asp:TextBox ID="txtamt" runat="server" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td> Remark</td>
                                                    <td> 
                                                        <asp:TextBox ID="txtremark" runat="server" TextMode="MultiLine" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td>Contact Person Name</td>
                                                    <td> 
                                                        <asp:TextBox ID="txtcontact" runat="server" width="150px" Height="16px"></asp:TextBox>
                                                      </td>
                                                    <td> Contact Person Ph.</td>
                                                    <td> 
                                                        <asp:TextBox ID="txtcontactph" runat="server" width="150px" Height="16px"></asp:TextBox>
                                                      </td>
                                                    <td> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td colspan="4">&nbsp;</td>
                                                    <td> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td colspan="4" style="text-align:center;">
                                                        
                                                        <table border="1" style="text-align:left;width:70%;">
                                                <tr><td colspan="2"><div class="showheader">Approved Persons</div></td></tr>            
                                   <tr>
                                       <td class="auto-style1">Approved By</td><td>
                                       <asp:DropDownList ID="ddlemp" runat="server"  Width="154px">
                                       </asp:DropDownList>
                                       </td>
                                     
                                   </tr>
                                   <tr>
                                         <td colspan="2" style="text-align:center;">
                        <asp:Button ID="btnadd" runat="server" Text="Add Emp"  CssClass="ItDoseButton" OnClick="btnadd_Click" />
                                         </td>
                                   </tr>
                                                            <tr>
                                                                <td colspan="2" style="text-align:center;">
                                                                    <asp:GridView ID="gridacc" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" EnableModelValidation="True" OnRowCommand="gridacc_RowCommand">
                                                                        <Columns>
                                                                            <asp:TemplateField HeaderText="Item Name">
                                                                                <ItemStyle CssClass="GridViewItemStyle" />
                                                                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                                                <ItemTemplate>
                                                                                    <asp:Label ID="lb1" runat="server" Text='<%#Eval("empid") %>' Visible="false" />
                                                                                    <%#Eval("empname") %>
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField HeaderText="Remove">
                                                                                <ItemStyle CssClass="GridViewItemStyle" />
                                                                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                                                <ItemTemplate>
                                                                                    <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument="<%# Container.DataItemIndex %>" CommandName="imbRemove" ImageUrl="../../Purchase/Image/Delete.gif" ToolTip="Remove Item" />
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                    </asp:GridView>
                                                                </td>
                                                            </tr>
                               </table></td>
                                                    <td> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <table>
                <tr>
                    <td style="text-align: center;" colspan="2">
                        <asp:Button ID="btnsave" runat="server"  Text="Save" OnClick="btnsave_Click" />
                        <asp:Button ID="btnclear" runat="server"  Text="Clear" OnClick="btnclear_Click" />
                       
                    
                    </td>
                </tr>
                </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
           <div class="showheader">Deactivtion List</div>
            <div class="content" style="overflow: scroll; height: 200px; width: 95%;">
           
                <asp:GridView ID="grddetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    EnableModelValidation="True" Width="1019px" OnRowCommand="grddetail_RowCommand"  >
                    <Columns>
                         <asp:TemplateField HeaderText="Edit">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit" ToolTip="Edit Asset" runat="server" ImageUrl="../../Purchase/Image/edit.png"
                                    CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="EditData" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Log">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" ToolTip="View Log Details" runat="server" ImageUrl="../../Purchase/Image/view.gif"
                                    CausesValidation="false" CommandArgument='<%# Eval("ID")%>' CommandName="ViewLog" />
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