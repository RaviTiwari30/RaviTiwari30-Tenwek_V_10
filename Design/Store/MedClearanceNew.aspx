<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedClearanceNew.aspx.cs" Inherits="Design_Store_MedClearanceNew" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
      <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>


      <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">


        var onBlockUI = function () {
            modelConfirmation('Attention !!', 'Some Return Requisition Pending...!!!', '', '', function () { });
        }

    </script>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>Medicine Clearance</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
              
                      <div class="row">
                           <div class="col-md-16">         
                <div style="text-align: center" class="col-md-4">
                                <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;background-color:lightblue" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b></div>             
                <div style="text-align: center" class="col-md-4">
                                      <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;background-color:yellowgreen" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Close</b>
                     </div><div style="text-align: center" class="col-md-4">
                       <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;background-color:lightpink" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Reject</b>
                     </div><div style="text-align: center" class="col-md-4">
                         <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left;background-color:yellow" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Partial</b>
                            </div></div>
                          </div></div>
                <div class="POuter_Box_Inventory" style="text-align: center">
                      <div class="Purchaseheader">
                    Search Results
                </div>
                    <asp:GridView ID="grdIndentSearch" runat="server" CssClass="GridViewStyle" OnRowDataBound="gvGRN_RowDataBound" Width="100%"
                        OnRowCommand="gvGRN_RowCommand" PageSize="8" AutoGenerateColumns="False">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" HorizontalAlign="Center"  />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CR.No">
                                <ItemTemplate>
                                    <%#Eval("TransactionID") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="RequisitionDate">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentDate" runat="server" Text='<%# Eval("dtEntry")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="RequisitionNo">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ToDepartment">
                                <ItemTemplate>
                                    <asp:Label ID="lblToDepartment" runat="server" Text='<%# Eval("DeptTo") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="StatusNew" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatusNew" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                    <asp:Label ID="lblView" runat="server" Text='<%# Eval("VIEW")  %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View Requisition">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                        ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("DeptTo")+"#"+Eval("StatusNew")   %>' />
                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status")%>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            <div class="POuter_Box_Inventory">
                <table style="width: 100%">
                    <tr>
                        <td style="height: 20px; text-align: center;" colspan="2">
                            <asp:CheckBox ID="chkIsMedCleared" runat="server" CssClass="ItDoseCheckbox" Font-Bold="true" Text="Check for clearance Medicion / Pharmacy" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <asp:Button ID="btnIsMedClear" runat="server" CssClass="ItDoseButton" Text="Save" Font-Bold="true" OnClick="btnIsMedClear_Click" OnClientClick="return confirm('Are You Sure ??');" />
                </div>
            </div>
        </div>
        <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 810px; height: 300px;" ScrollBars="Auto">
            <div>
                <table>
                    <tr>
                        <td style="text-align: center;">
                            <label><strong>Requisition Detail:</strong></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">
                            <asp:GridView ID="grdIndentdtl" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="810px" OnRowDataBound="grdIndentdtl_RowDataBound">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="RequisitionNo" DataField="IndentNo" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="ItemName" DataField="ItemName" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="UnitType" DataField="UnitType" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="BatchNo" DataField="BatchNumber" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="ReqQty" DataField="ReqQty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="ReceiveQty" DataField="ReceiveQty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="RejectQty" DataField="RejectQty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="DATE" DataField="DATE" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStatusNew1" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">
                            <asp:Button ID="btnRejectAll" runat="server" Text="Reject Pending" Width="100px" OnClick="btnRejectAll_Click" Enabled="false" CssClass="ItDoseButton" />
                            <asp:Button ID="btnCancel1" runat="server" Text="Close" CssClass="ItDoseButton" />&nbsp;&nbsp;<asp:Label ID="lblRejectMsg" runat="server" Visible="false" CssClass="ItDoseLblError"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true"
            BackgroundCssClass="filterPupupBackground" PopupDragHandleControlID="dragHandle"
            CancelControlID="btnCancel1"
            PopupControlID="Panel2" TargetControlID="btn1" X="100" Y="80">
        </cc1:ModalPopupExtender>
        <div style="display: none;">
            <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton" />
        </div>
    </form>
</body>
</html>
