<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="NoDuesSearch.aspx.cs" Inherits="Design_NoDuesSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Clearance Form </b>
            <br />
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
                            <asp:TextBox ID="txtEid" runat="server" AutoCompleteType="Disabled"
                                TabIndex="2" ToolTip="Enter Name"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Employee Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled"
                                ToolTip="Enter Patient ID" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddl_dept" runat="server" TabIndex='3'>
                            </asp:DropDownList>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton"
                TabIndex="4" Text="Search" OnClick="btnSearch_Click" Style="margin-top: 7px; width: 100px"  />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-22" align="center">
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
                            <asp:BoundField DataField="Employee_ID" HeaderText="Employee&nbsp;ID">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NAME" HeaderText="Employee&nbsp;Name">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Dept_Name" HeaderText="Department">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="DOJ" HeaderText="D.O.J.">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Select">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbView" runat="server" ImageUrl="~/Images/Post.gif" CausesValidation="false"
                                        CommandArgument='<%# Eval("Employee_ID")%>' CommandName="select" ToolTip="Click to Select" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
        <asp:Panel ID="pnlhide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Employee Details
                </div>
                <div class="row">
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Employee ID 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lbl_empid" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Employee Name 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lbl_name" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lbl_dept" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Date Of Joining
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lbl_doj" runat="server" CssClass="ItDoseLabelSp"></asp:Label>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Issue Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIssueDate" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="calIssueDate" runat="server" TargetControlID="txtIssueDate"
                                    Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Date Of Leaving
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDOL" runat="server"></asp:TextBox>
                                <cc1:CalendarExtender ID="calDOL" runat="server" TargetControlID="txtDOL" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btn_save" runat="server" ValidationGroup="Save" CssClass="ItDoseButton"
                    TabIndex="4" Text="Save" OnClick="btn_save_Click" Style="margin-top: 7px; width: 100px" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
