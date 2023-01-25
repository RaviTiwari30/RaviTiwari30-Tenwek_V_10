<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="CustomReport.aspx.cs" Inherits="Design_Payroll_CustomReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Employee Custom Report </b>
            <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                <asp:ListItem Value="0">Deactive</asp:ListItem>
            </asp:RadioButtonList>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Employee General Detail
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td colspan="5" style="height: 11px">
                        <asp:CheckBoxList RepeatDirection="horizontal" RepeatColumns="7" ID="chklEmpGeneralDetail"
                            runat="server">
                        </asp:CheckBoxList>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Employee Other Detail
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td colspan="5" style="height: 11px">
                        <asp:CheckBoxList RepeatDirection="Horizontal" RepeatColumns="6" ID="chklistRemuneration"
                            runat="server">
                        </asp:CheckBoxList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 21%; height: 18px;"></td>
                    <td style="width: 18%; height: 18px;"></td>
                    <td style="width: 20%; height: 18px;" align="center"></td>
                    <td style="width: 20%; height: 18px;"></td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Condition's
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td style="width: 9%; height: 25px;">Condition1
                    </td>
                    <td style="width: 14%; height: 25px;">
                        <asp:DropDownList ID="ddlCondition1" runat="server" Width="115px">
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlOperator1" runat="server">
                            <asp:ListItem>=</asp:ListItem>
                            <asp:ListItem>&gt;</asp:ListItem>
                            <asp:ListItem>&gt;=</asp:ListItem>
                            <asp:ListItem>&lt;</asp:ListItem>
                            <asp:ListItem>&lt;=</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="width: 11%; height: 25px;">
                        <asp:TextBox ID="txtCondition1" runat="server" Width="125px"></asp:TextBox>
                    </td>
                    <td style="width: 33px">
                        <asp:DropDownList ID="ddlOperator" runat="server">
                            <asp:ListItem>AND</asp:ListItem>
                            <asp:ListItem>OR</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="width: 10%; height: 23px;">Condition2
                    </td>
                    <td style="width: 14%; height: 23px;">
                        <asp:DropDownList ID="ddlCondition2" runat="server" Width="115px">
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlOperator2" runat="server">
                            <asp:ListItem>=</asp:ListItem>
                            <asp:ListItem>&gt;</asp:ListItem>
                            <asp:ListItem>&gt;=</asp:ListItem>
                            <asp:ListItem>&lt;</asp:ListItem>
                            <asp:ListItem>&lt;=</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="width: 15%; height: 25px;">
                        <asp:TextBox ID="txtCondition2" runat="server" Width="125px"></asp:TextBox>
                    </td>
                    <td style="width: 9%; height: 25px;"></td>
                    <td style="width: 25%; height: 25px">
                        <asp:DropDownList ID="ddlOperator3" runat="server">
                            <asp:ListItem>AND</asp:ListItem>
                            <asp:ListItem>OR</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 9%; height: 25px"></td>
                    <td style="width: 14%; height: 25px"></td>
                    <td></td>
                    <td style="width: 11%; height: 25px;" valign="top">
                        <span style="font-size: smaller">Date : (YYYY-MM-DD)</span>
                    </td>
                    <td style="width: 33px"></td>
                    <td style="width: 10%; height: 25px"></td>
                    <td style="width: 14%; height: 25px"></td>
                    <td></td>
                    <td style="width: 15%; height: 25px" valign="top">
                        <span style="font-size: smaller">Date : (YYYY-MM-DD)</span>
                    </td>
                    <td style="width: 9%; height: 25px"></td>
                    <td style="width: 25%; height: 25px"></td>
                </tr>
                <tr>
                    <td style="width: 9%; height: 25px">Condition3
                    </td>
                    <td style="width: 14%; height: 25px">
                        <asp:DropDownList ID="ddlCondition3" runat="server" Width="115px">
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlOperator4" runat="server">
                            <asp:ListItem>=</asp:ListItem>
                            <asp:ListItem>&gt;</asp:ListItem>
                            <asp:ListItem>&gt;=</asp:ListItem>
                            <asp:ListItem>&lt;</asp:ListItem>
                            <asp:ListItem>&lt;=</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="width: 11%; height: 25px">
                        <asp:TextBox ID="txtCondition3" runat="server" Width="125px"></asp:TextBox>
                    </td>
                    <td style="width: 33px"></td>
                    <td style="width: 10%; height: 25px"></td>
                    <td style="width: 14%; height: 25px"></td>
                    <td></td>
                    <td style="width: 15%; height: 25px"></td>
                    <td style="width: 9%; height: 25px"></td>
                    <td style="width: 25%; height: 25px"></td>
                </tr>
                <tr>
                    <td style="width: 9%; height: 25px"></td>
                    <td style="width: 14%; height: 25px"></td>
                    <td></td>
                    <td style="width: 11%; height: 25px" valign="top">
                        <span style="font-size: smaller">Date : (YYYY-MM-DD)</span>
                    </td>
                    <td style="width: 33px"></td>
                    <td style="width: 10%; height: 25px"></td>
                    <td style="width: 14%; height: 25px"></td>
                    <td></td>
                    <td style="width: 15%; height: 25px"></td>
                    <td style="width: 9%; height: 25px"></td>
                    <td style="width: 25%; height: 25px"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Create Report" CssClass="ItDoseButton"/>
                &nbsp;
            </div>
        </div>
    </div>
</asp:Content>