<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RequestAcceptance.aspx.cs" Inherits="Design_Equipment_Transactions_RequestAcceptance" %>

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
        <asp:UpdatePanel ID="up1" runat="server">
    <ContentTemplate>
        <div class="POuter_Box_Inventory">
          
            <div class="content" style="text-align: center">
                <b>&nbsp;Accept Request<br />
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
                                                    <td class="auto-style21">Location</td>
                                                    <td class="auto-style22">
                                                        <asp:DropDownList ID="ddlloc" runat="server" width="200px">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style20">
                                                        Priority</td>
                                                    <td class="auto-style15">
                                                        <asp:DropDownList ID="ddlpriority" runat="server" width="200px">
                                                            <asp:ListItem>Select</asp:ListItem>
                                                            <asp:ListItem>Regular</asp:ListItem>
                                                            <asp:ListItem>Emergency</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="auto-style21">Request Status</td>
                                                    <td class="auto-style22">
                                                        <asp:DropDownList ID="ddlreqstatus" runat="server" width="200px">
                                                            <asp:ListItem>Select</asp:ListItem>
                                                            <asp:ListItem>Accepted</asp:ListItem>
                                                            <asp:ListItem>Rejected</asp:ListItem>
                                                            <asp:ListItem>Hold</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style20">
                                                        &nbsp;</td>
                                                    <td class="auto-style15">
                                                        &nbsp;</td>
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
           
                <asp:GridView ID="grddetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    EnableModelValidation="True" Width="833px" OnRowCommand="grddetail_RowCommand"  >
                    <Columns>
                         <asp:TemplateField HeaderText="Show">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit" ToolTip="Edit Asset" runat="server" ImageUrl="../../Purchase/Image/edit.png"
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
                    </Columns>
                </asp:GridView>
            
            
            </div>
        </div>

               <asp:Panel ID="pnl" runat="server" Visible="false">

                   <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="showheader">Requisition detail</div>
            <table style="text-align:left;">
                                                
                                                <tr>
                                                    <td class="auto-style17" colspan="6" style="text-align:center;">
                <b>
                        <asp:Label ID="lblMsg0" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </b></td>
                                                </tr>
                                                <tr>
                                                    <td class="auto-style17">Request Id</td>
                                                    <td class="auto-style1">
                                                        <asp:TextBox ID="txtreq" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                    </td>
                                                    <td class="auto-style6">
                                                        Request Date</td>
                                                    <td class="auto-style3">
                            <uc1:EntryDate ID="ucreqdate" runat="server" />
                                                    </td>
                                                    <td class="auto-style5">
                                                        Required Date</td>
                                                    <td>
                            <uc1:EntryDate ID="ucrequireddate" runat="server" />
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style18">Asset Code</td>
                                                    <td class="auto-style8"> 
                                                        <asp:TextBox ID="txtasset" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Serial No</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtserial" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> Nature of Problem</td>
                                                    <td class="auto-style7"> 
                                                        <asp:TextBox ID="txtnop" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style18">Location</td>
                                                    <td class="auto-style8"> 
                                                        <asp:TextBox ID="txtlocation" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Department</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtdept" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> Complaint by User</td>
                                                    <td class="auto-style7"> 
                                                        <asp:TextBox ID="txtcou" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style18">Remark</td>
                                                    <td class="auto-style8">  
                                                        <asp:TextBox ID="txtremark" runat="server" ReadOnly="True" TextMode="MultiLine" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Request By</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtreqby" runat="server" ReadOnly="True" width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> &nbsp;</td>
                                                    <td class="auto-style7"> 
                                                        &nbsp;</td>
                                                </tr>
                                                  </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="showheader">Requisition Status</div>
            <table style="text-align:left;">
                                                <tr>
                                                    <td class="auto-style17">Requistion Status</td>
                                                    <td class="auto-style1">
                                                        <asp:DropDownList ID="ddlregstatus" width="154px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlregstatus_SelectedIndexChanged">
                                                             <asp:ListItem>Select</asp:ListItem>
                                                            <asp:ListItem>Accepted</asp:ListItem>
                                                            <asp:ListItem>Rejected</asp:ListItem>
                                                           <%-- <asp:ListItem>Hold</asp:ListItem>--%>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style24">
                                                        <asp:Label ID="lbre" runat="server" Text="Reson " Visible="False"></asp:Label>
                                                    </td>
                                                    <td class="auto-style21">
                                                        <asp:TextBox ID="txtre" runat="server" Visible="False" width="154px"></asp:TextBox>
                                                    </td>
                                                    <td class="auto-style6">
                                                        Maintenance Source</td>
                                                    <td class="auto-style3">
                                                        <asp:DropDownList ID="ddlmainttype" runat="server" width="154px">
                                                            <asp:ListItem>Select</asp:ListItem>
                                                            <asp:ListItem>Warrenty</asp:ListItem>
                                                            <asp:ListItem>In House</asp:ListItem>
                                                            <asp:ListItem>Out House</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style5">
                                                        &nbsp;</td>
                                                    <td>
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style18">Assignment</td>
                                                    <td class="auto-style8" colspan="3"> 
                                                        <asp:TextBox ID="txtassig" runat="server" TextMode="MultiLine" width="154px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> &nbsp;</td>
                                                    <td class="auto-style10"> 
                                                        &nbsp;</td>
                                                    <td class="auto-style11"> &nbsp;</td>
                                                    <td class="auto-style7"> 
                                                        &nbsp;</td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style23" colspan="8" style="text-align:center;">
                                                        <asp:Button ID="btn_save" runat="server" Text="Save" OnClick="btn_save_Click" />
                                                        <asp:Button ID="btn_clear" runat="server" Text="Clear" OnClick="btn_clear_Click" />
                                                      </td>
                                                </tr>
                                                  </table>
        </div>
               </asp:Panel>
        
          </div> 
       



        


            </ContentTemplate>
</asp:UpdatePanel>
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
