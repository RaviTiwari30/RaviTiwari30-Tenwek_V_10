<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="SalaryProcessEmployeeWise.aspx.cs" Inherits="Design_Payroll_SalaryProcessEmployeeWise" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
    <script type="text/javascript">
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
    <script type="text/javascript">
        function Disabele() {
            document.getElementById("ctl00$ContentPlaceHolder1$btnSave").disabled = true;
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave')
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Salary Process Employee Wise </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <br />
            <table width="100%">
                <tr>
                    <td style="width: 30%" align="right">Salary Month :&nbsp;
                    </td>
                    <td style="width: 22%" align="left">
                        <%-- <uc1:EntryDate ID="txtDate" runat="server" />--%>
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                        &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;
                    </td>
                    <td align="left" style="width: 16%; display: none">
                        <asp:RadioButtonList ID="rbtnCalOn" AutoPostBack="true" runat="server" RepeatDirection="horizontal"
                            Enabled="False">
                            <asp:ListItem Text="Days" Selected="True" Value="Days"></asp:ListItem>
                            <asp:ListItem Text="Hours" Value="Hours"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 30%"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <div class="content">
                <div style="float: left; clear: right; text-align: center;">
                    <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="False" OnCheckedChanged="CheckBox1_CheckedChanged"
                        CssClass="ItDoseCheckbox" Text="Select All" onclick="javascript:SelectAllCheckboxes(this);" />
                </div>
                <div style="float: left; padding-left: 150px; width: 472px;">
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<asp:Button ID="btnSave" runat="server"
                        Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" ToolTip="Click to Save" />&nbsp;
                </div>
                <br />
                <br />
                <div style="text-align: center;">
                    <asp:Panel ID="pnlgv1" runat="server" ScrollBars="vertical" Width="950" Height="450px">
                        <asp:GridView ID="GridView1" runat="server" ShowFooter="true" CssClass="GridViewStyle"
                            AutoGenerateColumns="False">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="server" Checked="false" />
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                        <asp:Label ID="lblEmployeeID" runat="server" Text='<%#Eval("Employee_ID") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Employee_ID" HeaderText="Employee ID">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="270px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Dept_Name" HeaderText="Department">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="170px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Desi_Name" HeaderText="Designation">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="180px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PayableDays" HeaderText="Payable Days">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                        <br />
                        <asp:GridView ID="EmpGrid" runat="server" HeaderStyle-CssClass="GridViewHeaderStyle"
                            RowStyle-CssClass="GridViewItemStyle" CssClass="GridViewStyle">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                        &nbsp;
                    </asp:Panel>
                    &nbsp;
                </div>
            </div>
        </div>
    </div>
    <div style="display: none;">
        &nbsp;
    </div>
    &nbsp;&nbsp;
</asp:Content>