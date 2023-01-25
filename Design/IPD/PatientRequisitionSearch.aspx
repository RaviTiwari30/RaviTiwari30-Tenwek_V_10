<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientRequisitionSearch.aspx.cs"
    Inherits="Design_IPD_PatientRequisitionSearch" %>
    <%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">

     <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
      <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Patient Requisition Details</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                           <div class="col-md-16">
                <div style="text-align: center" class="col-md-4">
                    <asp:Button ID="btnSN" runat="server" 
                                Width="25px" Height="25px" BackColor="LightBlue"
                                BorderStyle="Solid"  CssClass="circle" 
                                OnClick="btnSN_Click" ToolTip="Click for Open Requisition" style="cursor:pointer; margin-left: 5px; float: left;"   />
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Open</b></div>             
                <div style="text-align: center" class="col-md-4">
                      <asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="yellowgreen"
                                BorderStyle="Solid"  CssClass="circle" OnClick="btnRN_Click" ToolTip="Click for Close Requisition" style="cursor:pointer; margin-left: 5px; float: left;" />      
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Close</b>
                     </div><div style="text-align: center" class="col-md-4">
                         <asp:Button ID="btnNA" runat="server" Width="25px" Height="25px" BackColor="LightPink"
                                BorderStyle="Solid"  CssClass="circle" OnClick="btnNA_Click" ToolTip="Click for Reject Requisition" style="cursor:pointer; margin-left: 5px; float: left;" />
                       
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Reject</b>
                     </div><div style="text-align: center" class="col-md-4">
                       <asp:Button ID="btnA" runat="server" Width="25px" Height="25px" BackColor="Yellow"
                                BorderStyle="Solid"  CssClass="circle" OnClick="btnA_Click" ToolTip="Click for Partial Requisition" style="cursor:pointer; margin-left: 5px; float: left;" />
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Partial</b>
                            </div></div>
                          </div>              </div>
       <div class="POuter_Box_Inventory">
        <div style=" overflow: scroll">
            <asp:GridView ID="grdRequsition" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                Width="100%" onrowcommand="grdRequsition_RowCommand"  
                 onrowdatabound="grdRequsition_RowDataBound">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Requisition Date">
                        <ItemTemplate>
                            <asp:Label ID="lblIndentDate" runat="server" Text='<%#Eval("dtentry") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Requisition No.">
                        <ItemTemplate>
                            <asp:Label ID="lblIndent" runat="server" Text='<%#Eval("IndentNo") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Department From">
                        <ItemTemplate>
                            <asp:Label ID="lblDeptfrom" runat="server" Text='<%#Eval("Deptfrom") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="Raised By">
                        <ItemTemplate>
                            <asp:Label ID="lblEmpName" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                    </asp:TemplateField>

                      <asp:TemplateField HeaderText="Ack Status">
                        <ItemTemplate>
                            <asp:Label ID="lblAckStatus" runat="server" Text='<%#Eval("AckStatus") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle CssClass="GridViewItemStyle" />
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="StatusNew" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblStatusNew" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                      <asp:TemplateField HeaderText="View">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                    ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>'/>
                               
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView1" runat="server" CausesValidation="false" CommandName="APrint"
                                    ImageUrl="~/Images/print.gif" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle"/>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                </Columns>
            </asp:GridView>
            </div>
        </div>
    </div>
        <asp:Panel ID="panel" runat="server" CssClass="pnlItemsFilter" Style="display: none;
        width: 850px; height: 350px;" ScrollBars="Auto">
   
    <div>
            <table>
                <tr>
                    <td style="text-align: center;">
                        <label>
                            <strong>Requisition Detail:</strong></label>
                        <asp:Label ID="lblMsgNew" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="text-align: center;">
                    <asp:GridView ID="grdindent" runat="server" CssClass="GridViewStyle" 
                            AutoGenerateColumns="false" onrowdatabound="grdindent_RowDataBound" >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                    <ItemTemplate>
                    <%#Container.DataItemIndex+1 %>
                        <asp:CheckBox ID="chkSelect" runat="server" />
                        <asp:Label ID="lblIndentNo" Width="100%" runat="server" ClientIDMode="Static" Style="display: none;" Text='<%#Eval("IndentNo") %>'></asp:Label>
                        <asp:Label ID="lblItemID" Width="100%" runat="server" ClientIDMode="Static" Style="display: none;" Text='<%#Eval("ItemID") %>'></asp:Label>
                        <asp:Label ID="lblisAcknowledge" Width="100%" runat="server" ClientIDMode="Static" Style="display: none;" Text='<%#Eval("isAcknowledge") %>'></asp:Label>
                        <asp:Label ID="lblIndentID" Width="100%" runat="server" ClientIDMode="Static" Style="display: none;" Text='<%#Eval("IndentID") %>'></asp:Label>
                    </ItemTemplate>
                     <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                     <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Requisition No." DataField="IndentNo" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                    <asp:BoundField HeaderText="Depatment From" DataField="DeptFrom"  ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                      <asp:BoundField HeaderText="Department To" DataField="DeptTo" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Item Name" DataField="ItemName" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Unit Type" DataField="UnitType" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Requested Qty" DataField="ReqQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Received Qty" DataField="ReceiveQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Pending Qty" DataField="PendingQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Rejected Qty" DataField="RejectQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="Narration" DataField="Narration" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Date" DataField="DATE" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Raised By" DataField="EmpName" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                       <asp:TemplateField HeaderText="StatusNew" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatusNew1" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                              
                    </Columns>
                    
                    </asp:GridView>
                    </td>
                </tr>
                 <tr>
                    <td style="text-align: center;">
                        <asp:Button ID="btnAcknowledge" runat="server" Text="Acknowledge" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnAcknowledge_Click" />
                        <asp:Button ID="btnCancel1" runat="server" Text="Cancel" CssClass="ItDoseButton" />
                    </td>
                </tr>
                 </table>
        </div>
    </asp:Panel>
      <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="panel"
        TargetControlID="btn1" X="80" Y="100">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton"/></div>
    </form>
</body>
</html>
