<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" EnableEventValidation="false"
    AutoEventWireup="true" CodeFile="PostSalary.aspx.cs" Inherits="Design_Payroll_PostSalary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" >
        $(document).ready(function () {
        });
        function SelectAllCheckboxes(chk) {
            $("#<%=EmpGrid.ClientID %> tr:has(td)").each(function () {
            if (this.style.backgroundColor == "red") {

                $('#<%=EmpGrid.ClientID %>').find("input:checkbox").each(function () {
                    if (this != chk) {
                        this.checked = chk.checked;
                    }
                });
            }

        });
    }
    </script>
    <script  type="text/javascript">
        function Disabele() {
            document.getElementById('<%=btnFinalClosing.ClientID%>').disabled = true;
            __doPostBack('ctl00$ContentPlaceHolder1$btnFinalClosing', '')
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Post Salary </b>
                <br />

                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table width="100%">
                <tr>
                    <td style="width: 25%" align="right">Salary Month :&nbsp;
                    </td>
                    <td style="width: 25%" align="left">
                        <%--<uc1:EntryDate ID="txtDate" runat="server" />--%>
                        <asp:Label ID="txtDate" Visible="false" runat="server"></asp:Label>
                        <asp:Label ID="lblFromDate" Font-Bold="true" runat="server"></asp:Label>
                        <asp:Button OnClick="btnSarch_Click" Visible="false" ID="btnSarch" runat="Server"
                            Text="Search" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 25%" align="center">
                        <asp:Button ID="btnFinalClosing" runat="server" OnClientClick="Disabele()" OnClick="btnFinalClosing_Click"
                            Text="Calculate Net Payable" CssClass="ItDoseButton" />
                        &nbsp; &nbsp;
                        <asp:ImageButton ToolTip="Export To Excel" ImageUrl="~/Images/excelexport.gif"
                            ID="btnExport" runat="server" OnClick="btnExport_Click" Text="Export To Excel"
                            ImageAlign="Baseline" Visible="False" />
                    </td>
                    <td style="width: 25%">
                        <asp:Button ID="btnPost" CssClass="ItDoseButton" runat="server" Visible="false" Text="Post Salary" OnClick="btnPost_Click" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 25%">
                        <asp:CheckBox Visible="false" AutoPostBack="True" ID="chkSelect" Text="Select All"
                            runat="server" OnCheckedChanged="chkSelect_CheckedChanged" />
                    </td>
                    <td align="center" style="width: 25%"></td>
                    <td align="center" style="width: 25%">&nbsp;
                    </td>
                    <td style="width: 25%"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Panel ID="pnl1" runat="server" ScrollBars="Auto" Height="440" Width="960">
                    <asp:GridView ID="EmpGrid" runat="server" HeaderStyle-CssClass="GridViewHeaderStyle"
                        OnRowDataBound="EmpRowDataBound" RowStyle-CssClass="GridViewItemStyle" CssClass="GridViewStyle">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:CheckBox ID="Select" runat="server" />
                                    <asp:Label ID="lblSalaryType" Visible="false" runat="server" Text='<%#Eval("Salary Type") %>'></asp:Label>
                                    <asp:Label ID="lblID" Visible="false" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                    <asp:Label ID="lblEmpID" Visible="false" runat="server" Text='<%#Eval("Employee ID") %>'></asp:Label>
                                    <asp:Label ID="lblIsPost" Visible="false" runat="server" Text='<%#Eval("IsPost") %>'></asp:Label>
                                    <asp:Label ID="lblNetPayalbe" runat="server" Visible="false" Text='<%#Eval("Net Payable") %>'></asp:Label>
                                    <asp:Label ID="lblTotalEarning" runat="server" Visible="false" Text='<%#Eval("Total Earning") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
    </div>
</asp:Content>