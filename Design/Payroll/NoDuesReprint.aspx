<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="NoDuesReprint.aspx.cs" Inherits="Design_NoDuesReprint" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Clearance Form Search</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee ID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEid" runat="server" AutoCompleteType="Disabled" TabIndex="1"
                                ToolTip="Enter Employee ID"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled" ToolTip="Enter Employee Name" TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        </div>
                        <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                   
                </div>

            </div>

        </div>
        <div class="POuter_Box_Inventory" align="center">
        
                        <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton"
                            TabIndex="4" Text="Search" OnClick="btnSearch_Click" Style="margin-top: 7px; width: 100px" />
                    
                    </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row">
                <div class="col-md-24">
                    <asp:GridView ID="grdEmployee" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="grdEmployee_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="emp_id" HeaderText="Employee&nbsp;ID">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_name" HeaderText="Employee&nbsp;Name">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="350px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="dept_name" HeaderText="Department">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="220px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="IssueDate" HeaderText="Date&nbsp;of&nbsp;Issue">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Print">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbprint" runat="server" ImageUrl="~/Images/print.gif" CausesValidation="false"
                                        CommandArgument='<%# Eval("ID")%>' CommandName="print" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbedit" runat="server" ImageUrl="~/Images/edit.png" CausesValidation="false"
                                        CommandArgument='<%# Eval("ID")%>' CommandName="editemp" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbreject" Visible='<%#Util.GetBoolean(Eval("STATUS")) %>' runat="server"
                                        ImageUrl="~/Images/Delete.gif" CausesValidation="false" CommandArgument='<%# Eval("ID")%>'
                                        CommandName="reject" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Approve">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbpost" Visible='<%#Util.GetBoolean(Eval("STATUS")) %>' runat="server"
                                        ImageUrl="~/Images/Post.gif" CausesValidation="false" CommandArgument='<%# Eval("ID")%>'
                                        CommandName="post" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Employee Details
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-4">
                                <asp:Label ID="lbl_name" runat="server" Text="Employee Name" Visible="False" CssClass="pull-left"></asp:Label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lbl_name1" runat="server" Visible="False" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lbl_empid" runat="server" Text="Employee Id" Visible="False" CssClass="pull-left"></asp:Label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lbl_empid1" runat="server" Visible="False" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lbl_dept" runat="server" Text="Department" Visible="False" CssClass="pull-left"></asp:Label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lbl_dept1" runat="server" Visible="False" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <asp:Label ID="lbl_doj" runat="server" Text="D.O.J." Visible="False" CssClass="pull-left"></asp:Label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lbl_doj1" runat="server" Visible="False" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblIssueDate" runat="server" Text="Issue Date" Visible="False" CssClass="pull-left"></asp:Label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtIssueDate" runat="server" Visible="false"></asp:TextBox>
                                <cc1:CalendarExtender ID="calIssueDate" runat="server" TargetControlID="txtIssueDate"
                                    Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-4">
                                <asp:Label ID="lblDOL" runat="server" Text="Last Working Day" Visible="False" CssClass="pull-left"></asp:Label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtDOL" runat="server" Visible="false"></asp:TextBox>
                                <cc1:CalendarExtender ID="calDOL" runat="server" TargetControlID="txtDOL" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" align="center">
                <asp:Label ID="lblID" Visible="false" runat="server"></asp:Label>
                <asp:Button ID="btnupdate" runat="server" Text="Update" OnClick="btnupdate_Click"
                    Visible="False" CssClass="ItDoseButton" Style="margin-top: 7px; width: 100px" />
                <asp:Button ID="btncancel" CssClass="ItDoseButton" runat="server" Text="Cancel" Visible="False"
                    OnClick="btncancel_Click1" Style="margin-top: 7px; width: 100px" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
