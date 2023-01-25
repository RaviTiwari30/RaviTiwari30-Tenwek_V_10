<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Physical_VerificationApproval.aspx.cs" Inherits="Design_Store_Physical_VerificationApproval" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script> 
    <script type="text/javascript">
        $(document).ready(function () {
            blockUIOnRequest();
        });
        var blockUIOnRequest = function () {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
            });
            prm.add_endRequest(function () {
                $.unblockUI();
            });
        }
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Physical Verification Approval</b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Adjustment
            </div>
                <div style="float: left; padding-left: 150px;">
                    <asp:RadioButtonList ID="rdbStoreType" CssClass="ItDoseRadiobuttonlist" runat="server" OnSelectedIndexChanged="rdbStoreType_SelectedIndexChanged"
                        RepeatDirection="Horizontal" RepeatLayout="Flow" AutoPostBack="true">
                    </asp:RadioButtonList>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:RadioButtonList ID="rdbPRApproval" Style="display:none" CssClass="ItDoseRadiobuttonlist" runat="server" Enabled="false"
                        RepeatDirection="Horizontal" RepeatLayout="Flow">
                        <asp:ListItem Text="Approve" Value="Approve" Selected="True" />
                        <asp:ListItem Text="Reject" Value="Reject" />
                    </asp:RadioButtonList>
                </div>
                <br />
                <br />
                <div style="text-align: center;">
                    <asp:Panel ID="pnlgv1" runat="server" ScrollBars="vertical" Height="150px" style="width:auto">
                        <asp:GridView ID="GridView1" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowCommand="GridView1_RowCommand" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="30px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="EntryNo" HeaderText="Entry No." ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="80px" />
                                 <asp:BoundField DataField="CenterName" HeaderText="Center Name" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="200px" />
                                 <asp:BoundField DataField="RoleName" HeaderText="Department Name" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="200px" />
                                <asp:BoundField DataField="GroupName" HeaderText="Store Type" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="200px" />
                                <asp:BoundField DataField="EntryBy" HeaderText="Raised User" HeaderStyle-Width="250px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="EntryDate" HeaderText="Raised Date" HeaderStyle-Width="150px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:TemplateField HeaderText="Reject" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                            ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("EntryNo") %>' />
                                        <asp:Label ID="lblEntryNo" runat="server" Text='<%# Eval("EntryNo") %>'
                                            Visible="False"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Save" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:Button ID="btnSaveEntry" Text="Save" runat="server" CausesValidation="false" CommandName="Save" CommandArgument='<%# Eval("EntryNo") %>' CssClass="ItDoseButton" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="View" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:Button ID="btnViewEntry" Text="View" runat="server" CausesValidation="false" CommandName="View" CommandArgument='<%# Eval("EntryNo") %>' CssClass="ItDoseButton" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
      
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                          <div class="col-md-3">
                            <asp:Button ID="btnA" runat="server" Width="25px" Height="25px" BackColor="yellow"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Partial Purchase Order" Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Pending</b>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="yellowgreen"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Close Purchase Order" Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Approved</b>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnNA" runat="server" Width="25px" Height="25px" BackColor="LightPink"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Reject Purchase Order"  Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Rejected</b>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                <div style="text-align: center;">
                    <asp:Panel ID="Panel1" runat="server" ScrollBars="vertical" Height="285px" style="width:auto">
                        <asp:GridView ID="grdItemDetails" runat="server" CssClass="GridViewStyle" OnRowDataBound="grdItemDetails_RowDataBound"
                            AutoGenerateColumns="False" OnRowCommand="grdItemDetails_RowCommand" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                 <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="30px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="EntryNo" HeaderText="Entry No." ReadOnly="True"
                                    HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="ItemName" HeaderText="Item Name" ReadOnly="True" HeaderStyle-Width="250px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Rate" HeaderText="Unit Price" HeaderStyle-Width="80px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="MRP" HeaderText="Selling Price" HeaderStyle-Width="80px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="BatchNumber" HeaderText="Batch No." HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                 <asp:BoundField DataField="CurrentStock" HeaderText="Current Stock" HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="InitialCount" HeaderText="Quantity" ReadOnly="True" HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="TypeOfTnx" HeaderText="Type" ReadOnly="True" HeaderStyle-Width="40px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />
                             <%--   <asp:BoundField DataField="Department" HeaderText="Department" ReadOnly="True" HeaderStyle-Width="100px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                                <asp:TemplateField HeaderText="Tax" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Repeater ID="rpTax" runat="server">
                                            <ItemTemplate>
                                                <%#Eval("PurTaxType" )%>&nbsp;&nbsp;&nbsp;&nbsp;<%#Eval("PurTaxPer") %>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Reject" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-Width="50px">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                            ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("ID") %>' />
                                        <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblEntryNo" runat="server" Text='<%# Eval("EntryNo") %>'
                                            Visible="False"></asp:Label>
                                         <asp:Label ID="lblApproved" runat="server" ClientIDMode="Static" Text='<%#Eval("Approved")%>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
        </div>
    </div>
</asp:Content>

