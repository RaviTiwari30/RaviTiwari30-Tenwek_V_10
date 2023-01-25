<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IncometaxProcessing.aspx.cs"
    Inherits="Design_Payroll_IncometaxProcessing" MasterPageFile="~/DefaultHome.master"
    EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script  type="text/javascript">
        function Disabele() {
            document.getElementById('<%=btnCurrentSalary.ClientID%>').disabled = true;
            document.getElementById('<%=btnCurrentSalary.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00_ContentPlaceHolder1_btnCurrentSalary', '');
        }
        $(document).ready(function () {
            $("#<%=btnCurrentSalary.ClientID %>").click(function () {
                document.getElementById('<%=btnCurrentSalary.ClientID%>').disabled = true;
                document.getElementById('<%=btnCurrentSalary.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnCurrentSalary', '');
            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Income Tax Process </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 20%;" align="right">Salary Month :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                    </td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnCurrentSalary" runat="server" OnClick="btnCurrentSalary_Click"
                            Text="Income Tax Process" CssClass="ItDoseButton" ToolTip="Click to Start Income Tax Process" />
                    </td>
                    <td style="width: 14%; display: none">Salary&nbsp;Calculate&nbsp;On :&nbsp;
                    </td>
                    <td style="width: 25%; display: none">
                        <asp:RadioButtonList ID="rbtnCalOn" OnSelectedIndexChanged="rbtnCalOn_SelectedIndexChanged"
                            AutoPostBack="true" runat="server" RepeatDirection="horizontal" Enabled="False">
                            <asp:ListItem Text="Days" Selected="True" Value="Days"></asp:ListItem>
                            <asp:ListItem Text="Hours" Value="Hours"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 3px"></td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td align="center" style="width: 20%"></td>
                    <td style="width: 14%"></td>
                    <td style="width: 25%"></td>
                    <td style="width: 3px"></td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td align="center" style="width: 20%">
                        <asp:Button Visible="false" ID="Button1" runat="server" Text="Search" ToolTip="Click to Search"
                            CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 14%"></td>
                    <td style="width: 25%"></td>
                    <td style="width: 3px"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5">&nbsp;&nbsp;
                    </td>
                    <td style="width: 3px"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Panel ID="pnl1" runat="server" ScrollBars="Auto" Height="450" Width="950">
                    <asp:GridView ID="EmpGrid" runat="server" HeaderStyle-CssClass="GridViewHeaderStyle"
                        AutoGenerateColumns="False" HorizontalAlign="Center" CssClass="GridViewStyle"
                        Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Master ID" HeaderStyle-Width="20px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblMasterID" runat="server" Text='<%#Eval("MasterID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Employee&nbsp;ID">
                                <ItemTemplate>
                                    <asp:Label ID="lblEmployeeID" runat="server" Text='<%#Eval("EmployeeID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="210px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Designation">
                                <ItemTemplate>
                                    <asp:Label ID="lblDesignation" runat="server" Text='<%#Eval("Designation") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Basic">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                <ItemTemplate>
                                    <%# Eval("Basic")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="SSNIT">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                <ItemTemplate>
                                    <%# Eval("SSNIT")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Taxable Amount">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblTaxableAmount" runat="server" Text='<%# Eval("TaxableAmount")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tax">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                <ItemTemplate>
                                    <%# Eval("Tax")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>