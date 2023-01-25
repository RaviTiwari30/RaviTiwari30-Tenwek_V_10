<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RequestRegister.aspx.cs" Inherits="Design_Equipment_Transactions_RequestRegiste" %>

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
                <b>&nbsp;Register Request<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="showheader">Asset</div>
            <div>
                <table style="text-align:left;">
                                                <tr>
                                                    <td >Request Date</td>
                                                    <td >
                            <uc1:EntryDate ID="ucrequestdate" runat="server" />
                                                    </td>
                                                    <td >
                                                        Asset</td>
                                                    <td >
                                                        <asp:DropDownList ID="ddlasset" runat="server" width="204px" AutoPostBack="True" OnSelectedIndexChanged="ddlasset_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                        <asp:Label ID="lb" runat="server" Visible="false"></asp:Label>
                                                    </td>
                                                    <td class="auto-style5">
                                                        Model No</td>
                                                    <td>
                                                        <asp:TextBox ID="txtmodel" runat="server" ReadOnly="True" width="200px"></asp:TextBox></td>
                                                </tr>
                                                  <tr>
                                                    <td >Serial No</td>
                                                    <td > 
                                                        <asp:TextBox ID="txtserial" runat="server" ReadOnly="True" width="200px"></asp:TextBox></td>
                                                    <td> Department</td>
                                                    <td > 
                                                        <asp:TextBox ID="txtdept" runat="server" ReadOnly="True" width="200px"></asp:TextBox>
                                                      </td>
                                                    <td > Location</td>
                                                    <td > 
                                                        <asp:TextBox ID="txtlocation" runat="server" ReadOnly="True" width="200px"></asp:TextBox>
                                                        <asp:Label ID="lb0" runat="server" Visible="false"></asp:Label>
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td >&nbsp;</td>
                                                    <td > &nbsp;</td>
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
            <div class="showheader">Complaint Detail</div>
            <table style="text-align:left;">
                                                <tr>
                                                    <td>Nature of Problem</td>
                                                    <td>
                                                        <asp:DropDownList width="204px" ID="ddlproblem" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlproblem_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td>
                                                        Problem Description</td>
                                                    <td>
                                                        <asp:TextBox ID="txtprobdesc" width="200px" runat="server" ReadOnly="True" TextMode="MultiLine"></asp:TextBox>
                                                    </td>
                                                    <td>
                                                        &nbsp;</td>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td>Call Type Code</td>
                                                    <td> 
                                                        <asp:TextBox ID="txtcalltype" runat="server" ReadOnly="True" width="200px"></asp:TextBox>
                                                      </td>
                                                    <td> Call Type Description</td>
                                                    <td> 
                                                        <asp:TextBox ID="txtcalltypedesc" runat="server" ReadOnly="True" TextMode="MultiLine" width="200px"></asp:TextBox>
                                                      </td>
                                                    <td> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td>Priority</td>
                                                    <td> 
                                                        <asp:RadioButton ID="rbregular" runat="server" GroupName="a" Text="Regular" Checked="True" />
                                                        <asp:RadioButton ID="rbemer" runat="server" GroupName="a" Text="Emergency" />
                                                      </td>
                                                    <td> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                    <td> &nbsp;</td>
                                                    <td> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td>Complaint Entry</td>
                                                    <td >  
                                                        <asp:TextBox ID="txtcomentry" runat="server" TextMode="MultiLine" width="200px"></asp:TextBox>
                                                      </td>
                                                    <td > Required Date</td>
                                                    <td > 
                            <uc1:EntryDate ID="ucrequireddate" runat="server" />
                                                      </td>
                                                    <td > &nbsp;</td>
                                                    <td > 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td>Remark</td>
                                                    <td>   
                                                        <asp:TextBox ID="txtremark" runat="server" TextMode="MultiLine" width="200px"></asp:TextBox>
                                                      </td>
                                                    <td> Request By</td>
                                                    <td> 
                                                        <asp:TextBox ID="txtreqby" runat="server" width="200px"></asp:TextBox>
                                                      </td>
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
           <div class="showheader">Request List</div>
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
                         <asp:TemplateField HeaderText="Problem Type">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                             
                             <ItemTemplate>
                                <%#Eval("problemtypename") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                         <asp:TemplateField HeaderText="Request Date">
                              <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                             <%#Eval("requestdate") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                         <asp:TemplateField HeaderText="Required Date">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("requireddate") %>
                             </ItemTemplate>
                         </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Priority">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("priority") %>
                             </ItemTemplate>
                         </asp:TemplateField>

                         <asp:TemplateField HeaderText="Requistation_Status">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("REQUISTATION_STATUS") %>
                             </ItemTemplate>
                         </asp:TemplateField>

                        <asp:TemplateField HeaderText="Completion_Status">
                             <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                             <ItemTemplate>
                                <%# Eval("com") %>
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