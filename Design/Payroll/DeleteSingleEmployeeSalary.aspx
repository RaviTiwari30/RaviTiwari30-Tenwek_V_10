<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="DeleteSingleEmployeeSalary.aspx.cs" Inherits="Design_Payroll_DeleteSingleEmployeeSalary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
        function validate() {
            if ($("#<%=txtEmpID.ClientID %>").val() == '') {
                $("#<%=txtEmpID.ClientID %>").focus();
                $("#<%=lblmsg.ClientID %>").text('Enter Employee ID');
                return false;
            }
            else {
                $("#<%=lblmsg.ClientID %>").text('');
            }
        }
    </script>
    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Delete Salary </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 21%; height: 11px;" align="right">Employee ID :&nbsp;
                    </td>
                    <td style="width: 18%; height: 11px;">
                        <asp:TextBox ID="txtEmpID" runat="server" TabIndex="1" ToolTip="Enter Employee ID"></asp:TextBox>
                    </td>
                    <td style="width: 20%; height: 11px;" align="left">
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmpID"
                            ErrorMessage="Employee ID Required"></asp:RequiredFieldValidator>--%>
                    </td>
                    <td style="width: 16%; height: 11px;" align="right">Salary Month :
                    </td>
                    <td style="width: 25%; height: 11px;">
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;"></td>
                    <td style="width: 18%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 16%; height: 18px;"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
                <tr>
                    <td style="width: 21%"></td>
                    <td style="width: 18%"></td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" OnClick="btnSearch_Click" ToolTip="Click to Search" Text="Search" OnClientClick="return validate();" />
                    </td>
                    <td style="width: 16%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5" style="height: 18px"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5" style="height: 18px">
                        <asp:GridView ID="empGrid" runat="server" ShowFooter="true" CssClass="GridViewStyle"
                            AutoGenerateColumns="False" Width="900px" OnRowCommand="empGrid_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <%--  <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="server" Checked="True" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>--%>
                                <asp:TemplateField HeaderText="S.No">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="EmployeeID" HeaderText="Employee&nbsp;ID">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Employee&nbsp;Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="SalaryType" HeaderText="Salary&nbsp;Type">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="PayableDays" HeaderText="Payable&nbsp;Days">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="TotalEarning" HeaderText="Total&nbsp;Earning">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="TotalDeduction" HeaderText="Total&nbsp;Deduction">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                                </asp:BoundField>
                                <%--   <asp:BoundField DataField="ERound" HeaderText="Round">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="125px" />
                            </asp:BoundField>--%>
                                <asp:BoundField DataField="NetPayable" HeaderText="Net&nbsp;Payable">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Remove">
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbSelect" OnClientClick="return confirm('Are you Sure?');"
                                            ToolTip="Click to Remove" runat="server" ImageUrl="~/Images/Delete.gif"
                                            CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")+"#"+ Eval("ID")+"#"+Eval("SalaryType")%>'
                                            CommandName="Select" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>