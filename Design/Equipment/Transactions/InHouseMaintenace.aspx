<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InHouseMaintenace.aspx.cs" Inherits="Design_Equipment_Transactions_InHouseMaintenace" %>


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
                <b>&nbsp;In House Maintenace<br />
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
                                                        <asp:DropDownList ID="ddlloc" runat="server" Width="200px">
                                                        </asp:DropDownList>
                                                    </td>
                                                    <td class="auto-style20">
                                                        Priority</td>
                                                    <td class="auto-style15">
                                                        <asp:DropDownList ID="ddlpriority" runat="server" Width="200px">
                                                            <asp:ListItem>Select</asp:ListItem>
                                                            <asp:ListItem>Regular</asp:ListItem>
                                                            <asp:ListItem>Emergency</asp:ListItem>
                                                        </asp:DropDownList>
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
                                                    <td class="auto-style17">Request Id</td>
                                                    <td class="auto-style1">
                                                        <asp:TextBox ID="txtreq" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
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
                                                        <asp:TextBox ID="txtasset" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Serial No</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtserial" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> Nature of Problem</td>
                                                    <td class="auto-style7"> 
                                                        <asp:TextBox ID="txtnop" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style18">Location</td>
                                                    <td class="auto-style8"> 
                                                        <asp:TextBox ID="txtlocation" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Department</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtdept" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> Complaint by User</td>
                                                    <td class="auto-style7"> 
                                                        <asp:TextBox ID="txtcou" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                  <tr>
                                                    <td class="auto-style18">Remark</td>
                                                    <td class="auto-style8">  
                                                        <asp:TextBox ID="txtremark" runat="server" ReadOnly="True" TextMode="MultiLine" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style9"> Request By</td>
                                                    <td class="auto-style10"> 
                                                        <asp:TextBox ID="txtreqby" runat="server" ReadOnly="True" Width="150px"></asp:TextBox>
                                                      </td>
                                                    <td class="auto-style11"> Assignment</td>
                                                    <td class="auto-style7"> 
                                                        <asp:TextBox ID="txtassig" runat="server" ReadOnly="True" TextMode="MultiLine" Width="150px"></asp:TextBox>
                                                      </td>
                                                </tr>
                                                  </table>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center" id="divcost" runat="server">
            <div class="showheader"></div>
          
        </div>
                   <div class="POuter_Box_Inventory" style="text-align: left;">
            <table style="width: 100%;">
                <tr style="text-align:center;">
                    <td style="text-align: left;" class="auto-style33" colspan="4">
                    

                        <asp:RadioButton ID="ch1" runat="server" Text="Complete" Checked="True" GroupName="a" AutoPostBack="True" OnCheckedChanged="ch1_CheckedChanged" />
                        <asp:RadioButton ID="ch2" runat="server" Text="Transfer"  GroupName="a" AutoPostBack="True" OnCheckedChanged="ch2_CheckedChanged"/>
                       
                    </td>
                </tr>
                <tr style="text-align:center;">
                    <td class="auto-style31" colspan="4">
                        <asp:Panel runat="server" ID="pnl1">
                        <table class="auto-style34">
                            <tr>
                                <td class="auto-style40">Complete Date </td>
                                <td class="auto-style51">
                                    <uc1:EntryDate ID="uccomplete" runat="server" />
                                </td>
                                <td class="auto-style45">Feedback</td>
                                <td class="auto-style39">
                                    <asp:TextBox ID="txtfeedback" runat="server" TextMode="MultiLine" Width="150px"></asp:TextBox>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="auto-style47" colspan="2" style="vertical-align:top;">
                                    <table border="1" style="text-align:left; width: 352px;">
                                        <tr><td colspan="2"><div class="showheader">Item</div></td></tr>
                                        <tr>
                                            <td class="auto-style1">Select Item </td>
                                            <td class="auto-style52">
                                                <asp:DropDownList ID="ddlitem" runat="server" Width="154px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style1">Quantity</td>
                                            <td class="auto-style52">
                                                <asp:TextBox ID="txtqty" runat="server"  Width="150px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style1" colspan="2">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align:center;">
                                                <asp:Button ID="btnadd" runat="server" CssClass="ItDoseButton" OnClick="btnadd_Click" Text="Add Accessory" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align:center;">
                                                <asp:GridView ID="gridacc" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" EnableModelValidation="True" OnRowCommand="gridacc_RowCommand">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Item Name">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lb1" runat="server" Text='<%#Eval("itemid") %>' Visible="false" />
                                                                <%#Eval("Itemname") %>
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Quantity">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lb2" runat="server" Text='<%#Eval("Qty") %>' Visible="false" />
                                                                <%#Eval("Qty") %>
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Remove">
                                                            <ItemTemplate>
                                                                <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument="<%# Container.DataItemIndex %>" CommandName="imbRemove" ImageUrl="../../Purchase/Image/Delete.gif" ToolTip="Remove Item" />
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="auto-style45" colspan="3" style="vertical-align:top;">
                                    <table border="1" style="text-align:left;">
                                        <tr><td colspan="2"><div class="showheader">Technician</div></td></tr>
                                        <tr>
                                            <td class="auto-style49">Select Technician </td>
                                            <td class="auto-style53">
                                                <asp:DropDownList ID="ddltech" runat="server"  Width="154px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style49">Worked Date</td>
                                            <td class="auto-style53">
                                                <uc1:EntryDate ID="ucworked" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style49">Time Spent</td>
                                            <td class="auto-style53">
                                                <asp:TextBox ID="txttimespent" runat="server"  Width="150px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style49">Remark</td>
                                            <td class="auto-style53">
                                                <asp:TextBox ID="txtremarkbytech" runat="server" TextMode="MultiLine"  Width="150px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="auto-style1" colspan="2">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align:center;">
                                                <asp:Button ID="btnaddtech" runat="server" CssClass="ItDoseButton" OnClick="btnaddtech_Click" Text="Add Technician" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="text-align:center;">
                                                <asp:GridView ID="grdtech" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" EnableModelValidation="True" OnRowCommand="grdtech_RowCommand" Width="606px">
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="Technician">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lb1" runat="server" Text='<%#Eval("techid") %>' Visible="false" />
                                                                <%#Eval("techname") %>
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Worked Date">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lb2" runat="server" Text='<%#Eval("wdate") %>' Visible="false" />
                                                                <%#Eval("wdate") %>
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Time Spent">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lb3" runat="server" Text='<%#Eval("time") %>' Visible="false" />
                                                                <%#Eval("time") %>
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Remark">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lb4" runat="server" Text='<%#Eval("remark") %>' Visible="false" />
                                                                <%#Eval("remark") %>
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Remove">
                                                            <ItemTemplate>
                                                                <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument="<%# Container.DataItemIndex %>" CommandName="imbRemove" ImageUrl="../../Purchase/Image/Delete.gif" ToolTip="Remove Item" />
                                                            </ItemTemplate>
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>


                             


                        </table>
                        </asp:Panel>

                    </td>
                </tr>
                <tr style="text-align:center;">
                    <td class="auto-style32" colspan="4"> 
                        <asp:Panel runat="server" ID="pnl2" Visible="False" >
                        <table class="auto-style34">
                            <tr>
                                <td class="auto-style42">Reason</td>
                                <td style="text-align:left;">
                                    <asp:TextBox ID="txtresonoftr" runat="server" TextMode="MultiLine"  Width="200px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="auto-style42">&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </table></asp:Panel>
                    </td>
                </tr>
                <tr style="text-align:center;">
                    <td class="auto-style33" style="text-align: right;">&nbsp;</td>
                    <td class="auto-style29" style="text-align: right;">&nbsp;</td>
                    <td class="auto-style30" style="text-align: right;">&nbsp;</td>
                    <td style="text-align: right;">&nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: center;" colspan="4">
                        <asp:Button ID="btnsave" runat="server"  Text="Save" OnClick="btnsave_Click" />
                        <asp:Button ID="btnclear" runat="server" Text="Clear" OnClick="btnclear_Click" />
                    </td>
                </tr>
            </table>
        </div>
              
         </asp:Panel>
                   <div class="POuter_Box_Inventory" style="text-align: center">
               <div class="showheader">InHouse Maintenance List</div>
            <div class="content" style="overflow: scroll; height: 150px; width: 95%;">
           
                <asp:GridView ID="gridviewoutdetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    EnableModelValidation="True" Width="833px" OnRowCommand="gridviewoutdetail_RowCommand"  >
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
       



        


         <%--   </ContentTemplate>
</asp:UpdatePanel>--%>
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