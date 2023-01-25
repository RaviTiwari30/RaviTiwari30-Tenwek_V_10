<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="EmployeeReport.aspx.cs" Inherits="Design_Payroll_EmployeeReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Employee Report </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 20%" align="right">Department :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="1" ToolTip="Select Department"
                            Width="235px">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 20%" align="right">Designation :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:DropDownList ID="ddlDesignation" runat="server" TabIndex="2" ToolTip="Select Designation"
                            Width="235px">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 25%"></td>
                    <td style="width: 20%"></td>
                </tr>
                <tr>
                    <td style="width: 20%" align="right">Report Type :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:RadioButtonList ID="RadioButtonList1" runat="server" TabIndex="3" ToolTip="Select Report Type">
                            <asp:ListItem Selected="True">Department Wise</asp:ListItem>
                            <asp:ListItem>Designation Wise</asp:ListItem>
                            <asp:ListItem>Employee Sign. List</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 20%" align="right">Report Format :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:RadioButtonList ID="RadioButtonList2" runat="server" RepeatDirection="Horizontal"
                            TabIndex="4" ToolTip="Select Report Format">
                            <asp:ListItem Selected="True">PDF</asp:ListItem>
                            <asp:ListItem>Word</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="width: 25%"></td>
                    <td style="width: 20%"></td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                    <td style="width: 20%"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSubmit" runat="server" OnClick="btnSubmit_Click" CssClass="ItDoseButton"
                Text="Search" ToolTip="Click to Open Report" />
        </div>
    </div>
</asp:Content>