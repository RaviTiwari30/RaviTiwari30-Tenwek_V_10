<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="HoldBloodIssue.aspx.cs" Inherits="Design_BloodBank_HoldBloodIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript"  src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Hold Blood Issue</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientName" runat="server" TabIndex="1" ToolTip="Enter Patient Name"
                            MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtRegNo" runat="server"  MaxLength="20" TabIndex="2"
                            ToolTip="Enter UHID"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" MaxLength="10" TabIndex="3"
                            ToolTip="Enter IPD No." />
                      
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" ToolTip="Click To Search" CssClass="save margin-top-on-btn" Text="Search" TabIndex="4" OnClick="btnSearch_Click" />
        </div>
        <asp:Panel ID="pnlSearch" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grdSearchList" TabIndex="22" runat="Server" CssClass="GridViewStyle"
                    OnRowCommand="grdSearchList_RowCommand" AutoGenerateColumns="False" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientId1" runat="server" Text='<%# Util.GetString(Eval("PatientID"))%>' />
                                <asp:Label ID="lblTransactionID1" runat="server" Text='<%# Eval("TransactionID")%>'
                                    Visible="false" />
                                <asp:Label ID="lblLedgerTransactionNo1" runat="server" Text='<%# Eval("LedgerTransactionNo")%>'
                                    Visible="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionID3" runat="server" Text='<%# Util.GetString(Eval("TransactionID")).Replace("LLSHHI","").Replace("LSHHI","").Replace("LISHHI","").Replace("ISHHI","")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("PName")%>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component Name">
                            <ItemTemplate>
                                <asp:Label ID="lblComponentName" runat="server" Text='<%# Eval("ComponentName")%>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Stock ID">
                            <ItemTemplate>
                                <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("Stock_ID")%>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type">
                            <ItemTemplate>
                                <asp:Label ID="lblBagType" runat="server" Text='<%# Eval("BagType")%>' />
                                <asp:Label ID="lblIssuevolumn" runat="server" Text='<%# Eval("ReleaseCount") %>'
                                    Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tube No.">
                            <ItemTemplate>
                                <asp:Label ID="lblTubeNo" runat="server" Text='<%# Eval("BBTubeNo")%>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Issue">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/view.gif" ToolTip="ReIssue of Holded Stock to the Same Patient"
                                    CommandName="AResult" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false"
                                    OnClientClick="return confirm('Are you Sure to ReIssue of Holded Stock to the Same Patient ?');" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Add Stock">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult1" runat="server" ImageUrl="../../Images/view.gif"
                                    ToolTip="Added Holded Stock to the Main Stock" CommandName="AStock" CommandArgument='<%# Container.DataItemIndex %>'
                                    CausesValidation="false" OnClientClick="return confirm('Are you Sure to Add Holded Stock to the Main Stock ?');" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
