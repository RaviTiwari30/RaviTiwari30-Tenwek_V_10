<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReturnRequisitionSearch.aspx.cs"
    Inherits="Design_IPD_ReturnRequisitionSearch" %>
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
                <b>Return Requisition Details</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="content" style="text-align: center;">
            <div id="colorindication" runat="server">
                <table width="100%">
                    <tr>
                        <td style="height: 22px">
                            &nbsp;<asp:Button ID="btnSN" runat="server" 
                                Width="20px" Height="20px" BackColor="LightBlue"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" 
                                OnClick="btnSN_Click" ToolTip="Click for Open Requisition" style="cursor:pointer;"  />
                        </td>
                        <td style="text-align: left; height: 22px;">
                            Pending
                        </td>
                        <td style="height: 22px">
                            <asp:Button ID="btnRN" runat="server" Width="20px" Height="20px" BackColor="BurlyWood"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnRN_Click" ToolTip="Click for Close Requisition" style="cursor:pointer;" />
                        </td>
                        <td style="text-align: left; height: 22px;">
                            Closed
                        </td>
                        <td style="height: 22px">
                            &nbsp;<asp:Button ID="btnNA" runat="server" Width="20px" Height="20px" BackColor="LightPink"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnNA_Click" ToolTip="Click for Reject Requisition" style="cursor:pointer;" />
                        </td>
                        <td style="text-align: left; height: 22px;">
                            Reject
                        </td>
                        <td style="height: 22px">
                            &nbsp;<asp:Button ID="btnA" runat="server" Width="20px" Height="20px" BackColor="Yellow"
                                BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnA_Click" ToolTip="Click for Partial Requisition" style="cursor:pointer;" />
                        </td>
                        <td style="text-align: left; height: 22px; width: 145px;">
                            &nbsp;Partial
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div style=" overflow: auto;max-height:250px; padding:5px;">
            <asp:GridView ID="grdRequsition" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                onrowcommand="grdRequsition_RowCommand"  
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
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView1" runat="server" CausesValidation="false" CommandName="APrint"
                                    ImageUrl="~/Images/print.gif" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>
                </Columns>
            </asp:GridView>
            </div>
        </div>
    </div>
        <asp:Panel ID="panel" runat="server" CssClass="pnlItemsFilter" Style="display: none;
        width: 1000px; max-height: 350px; overflow:auto;">
   
    <div>
            <table>
                <tr>
                    <td style="text-align: center;">
                        <label>
                            <strong>Requisition Detail:</strong></label>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="text-align: center;">
                    <asp:GridView ID="grdindent" runat="server" CssClass="GridViewStyle" 
                            AutoGenerateColumns="false" onrowdatabound="grdindent_RowDataBound"  style="width:990px; padding:5px;" >
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                    <ItemTemplate>
                    <%#Container.DataItemIndex+1 %>
                    </ItemTemplate>
                     <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                     <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Requisition No." DataField="IndentNo" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                    <asp:BoundField HeaderText="Depatment From" DataField="DeptFrom"  ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                      <asp:BoundField HeaderText="Department To" DataField="DeptTo" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false" />
                                <asp:BoundField HeaderText="Item Name" DataField="ItemName" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Unit Type" DataField="UnitType" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Requested Qty" DataField="ReqQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Return Qty" DataField="ReceiveQty" ItemStyle-CssClass="GridViewItemStyle"
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
                                    HeaderStyle-CssClass="GridViewHeaderStyle"  Visible="false" />
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
                        <asp:Button ID="btnCancel1" runat="server" Text="Cancel" CssClass="ItDoseButton" />
                    </td>
                </tr>
                 </table>
        </div>
    </asp:Panel>
      <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="panel"
        TargetControlID="btn1" X="30" Y="100">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton"/></div>
    </form>
</body>
</html>
