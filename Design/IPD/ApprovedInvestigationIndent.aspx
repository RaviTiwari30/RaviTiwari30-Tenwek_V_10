<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ApprovedInvestigationIndent.aspx.cs"
    Inherits="Design_IPD_ApprovedInvestigationIndent" %>

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
                    <b>Investigation Requisition Details</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    <asp:TextBox ID="txtHash" CssClass="txtHash" style=" display:none;" runat="server"></asp:TextBox>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <div id="colorindication" runat="server">
                        <table width="75%">
                            <tr>
                                <td style="height: 22px">&nbsp;<asp:Button ID="btnSN" runat="server"
                                    Width="20px" Height="20px" BackColor="LightBlue"
                                    BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11"
                                    OnClick="btnSN_Click" ToolTip="Click for Open Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px;">Pending
                                </td>
                                <td style="height: 22px">
                                    <asp:Button ID="btnRN" runat="server" Width="20px" Height="20px" BackColor="BurlyWood"
                                        BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnRN_Click" ToolTip="Click for Close Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px;">Closed
                                </td>
                                <td style="height: 22px">&nbsp;<asp:Button ID="btnNA" runat="server" Width="20px" Height="20px" BackColor="LightPink"
                                    BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnNA_Click" ToolTip="Click for Reject Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px;">Reject
                                </td>
                                <td style="height: 22px">&nbsp;<asp:Button ID="btnA" runat="server" Width="20px" Height="20px" BackColor="Yellow"
                                    BorderStyle="Solid" BorderColor="Black" CssClass="ItDoseButton11" OnClick="btnA_Click" ToolTip="Click for Partial Requisition" Style="cursor: pointer;" />
                                </td>
                                <td style="text-align: left; height: 22px; width: 145px;">&nbsp;Partial
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div style="overflow: auto">
                    <asp:GridView ID="grdRequsition" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                        Width="100%" OnRowCommand="grdRequsition_RowCommand"
                        OnRowDataBound="grdRequsition_RowDataBound">
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
                                        ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />

                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Approve Pending Inves.">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbApproved" runat="server" CausesValidation="false" CommandName="Approved"
                                        ImageUrl="~/Images/Post.gif" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject Pending Inves.">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                        ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div style="display:none;">
                   <asp:Label ID="lblTransactionNo" runat="server" Visible="False" />
                    <asp:Label ID="lblCaseTypeID" runat="server" Visible="False" />
                    <asp:Label ID="lblReferenceCode" runat="server" Visible="False" />
                    <asp:Label ID="lblPanelID" runat="server" Visible="False" />
                    <asp:Label ID="lblPatientID" runat="server" Visible="False" />
                    <asp:Label ID="lblDoctorID" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblitemid" runat="server" Visible="False" />
                    <asp:Label ID="lblPatientType" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblRoomID" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblMembership" runat="server" Visible="False"></asp:Label>
                
                     <asp:Label ID="lblPatientTypeID" runat="server" Visible="False"></asp:Label>
            </div>
        </div>
        <asp:Panel ID="panel" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 850px; height: 350px;"
            ScrollBars="Auto">

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
                                AutoGenerateColumns="false" OnRowDataBound="grdindent_RowDataBound">
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
                                    <asp:BoundField HeaderText="Depatment From" DataField="DeptFrom" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                    <asp:BoundField HeaderText="Item Name" DataField="ItemName" ItemStyle-CssClass="GridViewItemStyle"
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
            <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton" />
        </div>
    </form>
</body>
</html>
