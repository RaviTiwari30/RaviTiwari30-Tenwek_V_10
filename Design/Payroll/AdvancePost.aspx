<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AdvancePost.aspx.cs" Inherits="Design_Payroll_AdvancePost" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
    <script type="text/javascript" >
        $(document).ready(function () {
        });
        function SelectAllCheckboxes(chk) {
            $('#<%=GridView1.ClientID %>').find("input:checkbox").each(function () {
                if (this != chk) {
                    this.checked = chk.checked;
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <div style="text-align: center;">
                    <b>Loan Posting </b>&nbsp;<br />
                    <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content">
                <br />
                <table width="100%">
                    <tr>
                        <td style="width: 30%" align="right">Salary Month :&nbsp;
                        </td>
                        <td style="width: 30%" align="left">
                            <%--<uc1:EntryDate ID="txtDate" runat="server" />--%>
                            <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                            <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                        </td>
                        <td style="width: 30%">
                            <asp:Button ID="btnSearch" Visible="false" runat="server" ToolTip="Click to Search" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Loan Details
            </div>
            <div class="content">
                <div style="float: left; clear: right; text-align: center;">
                    <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="False" Checked="True" OnCheckedChanged="CheckBox1_CheckedChanged"
                        CssClass="ItDoseCheckbox" Text="Request" onclick="javascript:SelectAllCheckboxes(this);" />
                </div>
                <div style="float: left; padding-left: 150px; width: 472px;">
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;<asp:Button ID="btnSave" runat="server"
                        Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" TabIndex="1" ToolTip="Click to Save" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                </div>
                <br />
                <br />
                <div style="text-align: left;">
                    <asp:Panel ID="pnlgv1" runat="server" ScrollBars="vertical" Width="950" Height="450px">
                        <asp:GridView ID="GridView1" runat="server" ShowFooter="true" CssClass="GridViewStyle"
                            AutoGenerateColumns="False" Width="900px" OnRowCommand="GridView1_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" Checked="True" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Loan No." ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAdvID" runat="server" Text='<%# Eval("AdV_ID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Employee ID" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEmpID" runat="server" Text='<%# Eval("EmployeeID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Amount" HeaderText="Loan&nbsp;Amt.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Deduction Amt." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblInstallmentAmt" runat="server" Text='<%# Eval("InstallmentAmount") %>'></asp:Label>
                                        <asp:Label ID="lblTypeID" runat="server" Visible="false" Text='<%# Eval("AdvanceID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        <%=TotalAmount %>
                                    </FooterTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Remaining" HeaderText="Remaining">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Date" HeaderText="Entry Date">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Remove">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbSelect" ToolTip="Click to Remove" runat="server" ImageUrl="~/Images/Delete.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")+"#"+ Eval("AdV_ID")%>'
                                            CommandName="Select" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                    <div class="content">
                        <div style="text-align: center;">
                            <asp:Panel ID="Panel1" runat="server" ScrollBars="None" Style="display: none; width: 403px;"
                                BackColor="#F3F7FA">
                                <div class="POuter_Box_Inventory" style="text-align: center; width: 400px; background-color: #f3f7fa;">
                                    <div class="Purchaseheader">
                                        Enter Narration
                                    </div>
                                    <asp:Label ID="lblEmpID" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="lblAdvanceNo" runat="server"></asp:Label><br />
                                    <asp:TextBox ID="txtreasion" TextMode="MultiLine" Width="390" Height="60" EnableTheming="false"
                                        runat="server"></asp:TextBox>
                                    <br />
                                    <asp:Button ID="btnsaveReasion" runat="server" Text="Save" OnClick="btnsaveReasion_Click" CssClass="ItDoseButton"/>
                                    &nbsp;&nbsp;<asp:Button ID="btncancel" runat="server" Text="Cancel" CssClass="ItDoseButton"/>
                                </div>
                            </asp:Panel>
                        </div>
                        <div id="d1" runat="server" style="visibility: hidden">
                            <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton"/>
                        </div>
                        <cc1:ModalPopupExtender ID="mAdmit" runat="server" DropShadow="true" TargetControlID="btnHidden"
                            BackgroundCssClass="filterPupupBackground" PopupControlID="Panel1" X="250" Y="125">
                        </cc1:ModalPopupExtender>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>