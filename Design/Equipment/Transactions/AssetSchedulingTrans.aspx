<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AssetSchedulingTrans.aspx.cs" Inherits="Design_Equipment_Transactions_AssetSchedulingTrans" %>

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
                <b>Asset Scheduling<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="showheader">Asset Detail</div> 
            <div>
                  
                <table style="text-align:left;">
                                                <tr>
                                                    <td class="auto-style2">Asset</td>
                                                    <td class="auto-style1">
                                                        <asp:DropDownList ID="ddlasset" width="204px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlasset_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style6">
                                                        Serial No</td>
                                                    <td class="auto-style3">
                                                        <asp:TextBox ID="txtserial"  width="200px" runat="server" ReadOnly="True"></asp:TextBox></td>
                                                    <td class="auto-style5">
                                                        Model No</td>
                                                    <td>
                                                        <asp:TextBox ID="txtmodel" width="200px" runat="server" ReadOnly="True"></asp:TextBox></td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style7">Department</td>
                                                    <td class="auto-style8"> <asp:TextBox ID="txtdept" width="200px" runat="server" ReadOnly="True"></asp:TextBox></td>
                                                    <td class="auto-style9"> Location</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtlocation" runat="server" width="200px" ReadOnly="True"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> Floor</td>
                                                    <td class="auto-style7"> 
                                                        <asp:TextBox ID="txtfloor" runat="server" width="200px" ReadOnly="True"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style2">Room </td>
                                                    <td class="auto-style1"> <asp:TextBox ID="txtroom" width="200px" runat="server" ReadOnly="True"></asp:TextBox></td>
                                                    <td class="auto-style6"> &nbsp;</td>
                                                    <td class="auto-style3"> 
                                                        &nbsp;</td>
                                                    <td class="auto-style5"> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
             <div class="showheader">Scheduling Detail</div>
            <table style="text-align:left;">
                                                <tr>
                                                    <td class="auto-style2">Maintance Type</td>
                                                    <td class="auto-style1">
                                                        <asp:DropDownList ID="ddlmain" width="204px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlasset_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style6">
                                                        Schedule Type</td>
                                                    <td class="auto-style3">
                                                        <asp:DropDownList ID="ddlschedule" width="204px" runat="server">
                                                            <asp:ListItem>Select</asp:ListItem>
                                                            <asp:ListItem>Continous </asp:ListItem>
                                                            <asp:ListItem>Discontinous </asp:ListItem>
                                                        </asp:DropDownList>
                                                      </td>
                                                    <td class="auto-style5">
                                                        &nbsp;</td>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style7">Remark</td>
                                                    <td class="auto-style8"> 
                                                        <asp:TextBox ID="txtrem" runat="server" TextMode="MultiLine" width="200px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Schedule Date</td>
                                                    <td class="auto-style10"> 
                            <uc1:EntryDate ID="ucDateTo" runat="server" />
                                                      </td>
                                                    <td class="auto-style11"> &nbsp;</td>
                                                    <td class="auto-style7"> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style7">To Do</td>
                                                    <td class="auto-style8">  
                                                        <asp:TextBox ID="txtnot" runat="server" width="200px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> &nbsp;</td>
                                                    <td class="auto-style10"> 
                                                        &nbsp;</td>
                                                    <td class="auto-style11"> &nbsp;</td>
                                                    <td class="auto-style7"> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style2">&nbsp;</td>
                                                    <td class="auto-style1"> &nbsp;</td>
                                                    <td class="auto-style6"> &nbsp;</td>
                                                    <td class="auto-style3"> 
                                                        &nbsp;</td>
                                                    <td class="auto-style5"> &nbsp;</td>
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
     <div class="showheader">Scheduling List</div>
            <div class="content" style="overflow: scroll; height: 200px; width: 95%;">
           
                <asp:GridView ID="grddetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    EnableModelValidation="True" Width="833px" OnRowCommand="grddetail_RowCommand" >
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
                         <asp:TemplateField HeaderText="Maintance Type">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                             
                             <ItemTemplate>
                                 <asp:Label ID="Label2" runat="server" Text='<%# Bind("mt") %>'></asp:Label>
                             </ItemTemplate>
                         </asp:TemplateField>
                         <asp:TemplateField HeaderText="Schedule Type">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                 <asp:Label ID="Label1" runat="server" Text='<%# Bind("scheduletype") %>'></asp:Label>
                             </ItemTemplate>
                         </asp:TemplateField>
                         <asp:TemplateField HeaderText="Schedule Date">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                 <asp:Label ID="Label3" runat="server" Text='<%# Bind("sdate") %>'></asp:Label>
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
