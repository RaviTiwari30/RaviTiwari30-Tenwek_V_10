<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Experience_Letter.aspx.cs"
    Inherits="Design_Payroll_Experience_Letter" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:content id="Content1" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <b>Reference Letter </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22" align="center">
                        <div class="row">
                            <div class="col-md-4">
                                <label class="pull-left">
                                    Employee ID 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmp_ID" runat="server" ToolTip="Enter Employee ID" TabIndex="1"></asp:TextBox>
                            </div>
                             <div class="col-md-4">
                                <label class="pull-left">
                                    Employee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtEmpName" runat="server" ToolTip="Enter Employee Name" TabIndex="2"></asp:TextBox>
                                </div> 
                            <div class="col-md-4">
                            <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" TabIndex="3" ToolTip="Click to Search" Text="Search" CssClass="ItDoseButton" style="width:100px;" />
                            </div>
                            </div>
                       
                        </div>
                </div>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div class="row">
                <div class="col-md-24" align="center">
                    <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="EmpGrid_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:BoundField ReadOnly="true" DataField="Employee_ID" HeaderText="Employee&nbsp;ID">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" ReadOnly="true" HeaderText="Employee&nbsp;Name">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" Width="240px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Gender" HeaderText="Sex" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" Width="80px" />
                                </asp:BoundField>

                                <asp:BoundField DataField="DOJ" HeaderText="Date&nbsp;of&nbsp;Joining" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="DOL" HeaderText="Date&nbsp;of&nbsp;Leaving" ReadOnly="true">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" Width="120px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Edit">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbedit" runat="server" ImageUrl="~/Images/edit.png" CausesValidation="false"
                                            CommandArgument='<%# Eval("Employee_ID")%>' CommandName="editemp" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Print">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false"
                                            CommandName="Print" ToolTip="Click to Print" ImageUrl="~/Images/print.gif" CommandArgument='<%# Eval("Employee_ID") %>' />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                </div>
            </div>
               
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton"/>
    </div>
    <cc1:ModalPopupExtender ID="mpeAttributes" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnClose" DropShadow="true" PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnHidden" BehaviorID="mpeCreateGroup">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlOrderItemsFilter" Width="430px" Style="display: none">
        <div id="dragUpdate" runat="server" class="Purchaseheader">
            <b>Employee Detail </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Press esc to close
            <asp:ImageButton ID="btnClose" runat="server" ImageUrl="~/Images/Delete.gif" ToolTip="Close"
                Style="display: none" />
        </div>
        <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22" align="center">
                        <div class="row">
                            <div class="col-md-12">
                                <label class="pull-left">
                                    Employee ID 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <asp:Label ID="lblEmpID" runat="server" CssClass="ItDoseLabelSp pull-left"></asp:Label>
                             </div>
                       </div>
                        <div class="row">
                            <div class="col-md-12">
                                <label class="pull-left">
                                    Employee Attributes 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12">
                                <label class="pull-left">
                                1.</label><asp:TextBox ID="txtEmp_attributes" runat="server" TabIndex="2"
                    ToolTip="Enter Attributes" width="90%"></asp:TextBox>
                                    
                                </div>
                            </div>
                        <div class="row">
                            <div class="col-md-12">
                               <label class="pull-left">2.</label><asp:TextBox ID="txtEmp_attributes1" runat="server" TabIndex="2"
                    ToolTip="Enter Attributes" width="90%" ></asp:TextBox>
                                </div>
                            <div class="col-md-12">
                                <label class="pull-left">3.</label><asp:TextBox ID="txtEmpAttributes2" runat="server" TabIndex="2"
                    ToolTip="Enter Attributes" width="90%"></asp:TextBox>
                                </div>
                            </div>
                        <div class="row">
                            <div class="col-md-12">
                                <label class="pull-left">4.</label><asp:TextBox ID="txtEmp_Attributes3" runat="server" TabIndex="2"
                    ToolTip="Enter Attributes" width="90%"></asp:TextBox>
                                </div>
                            <div class="col-md-12">
                                <label class="pull-left">5.</label><asp:TextBox ID="txtEmp_Attribtes4" runat="server" TabIndex="2"
                    ToolTip="Enter Attributes" width="90%"></asp:TextBox>
                                </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <label class="pull-left">
                                    Authority Name
                                </label>
                                <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-12">
                                <asp:TextBox ID="txtAuthority" runat="server" TabIndex="2"
                    ToolTip="Enter Authority Name"></asp:TextBox>
                                </div>
                        
                        </div>
                        <div class="row">
                            <div class="col-md-24">
<asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton"
                        OnClick="btnSave_Click" TabIndex="3" Text="Save" ToolTip="Click to Save" style="margin-top:7px; margin-bottom:5px; width:100px;" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" TabIndex="3"
                        Text="Cancel" ToolTip="Click to Cancel" style="margin-top:7px; margin-bottom:5px; width:100px;" />
                            </div>
                            </div>
            </div>
    </asp:Panel>
</asp:content>
