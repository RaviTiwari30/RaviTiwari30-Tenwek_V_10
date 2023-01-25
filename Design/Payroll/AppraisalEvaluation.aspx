<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="AppraisalEvaluation.aspx.cs" Inherits="Design_Payroll_AppraisalEvaluation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <b>Appraisal Evaluation</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <table border="0" style="width: 100%">
                <tr>
                    <td align="right" style="width: 20%; height: 18px;">Employee ID :&nbsp;
                    </td>
                    <td style="width: 20%; height: 18px;">
                        <asp:TextBox ID="txtEmp_ID" runat="server" MaxLength="20" TabIndex="1" ToolTip="Enter Employee ID"></asp:TextBox>
                    </td>
                    <td align="right" style="width: 20%; height: 18px;">Employee Name :&nbsp;
                    </td>
                    <td style="width: 20%; height: 18px;">
                        <asp:TextBox ID="txtEmpName" runat="server" MaxLength="50" TabIndex="2" ToolTip="Enter Employee Name"></asp:TextBox>
                    </td>
                    <td style="width: 25%; height: 18px;"></td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%">Department :&nbsp;
                    </td>
                    <td style="width: 20%">
                        <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="3" ToolTip="Select Department" Width="235px">
                        </asp:DropDownList>
                    </td>
                    <td align="right" style="width: 20%">Designation :&nbsp;
                    </td>
                    <td colspan="2">
                        <asp:DropDownList ID="ddlDesignation" runat="server" TabIndex="4" ToolTip="Select Designation" Width="235px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%; height: 24px;">Appraisal :&nbsp;
                    </td>
                    <td style="width: 20%; height: 24px;">
                        <asp:DropDownList ID="ddlAppraisal" runat="server" TabIndex="5" ToolTip="Select Appraisal">
                        </asp:DropDownList>
                    </td>
                    <td align="right" style="width: 20%; height: 24px;">Grade :&nbsp;
                    </td>
                    <td style="width: 20%; height: 24px;">
                        <asp:DropDownList ID="ddlGrade" runat="server" TabIndex="6" ToolTip="Select Grade">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 25%; height: 24px;"></td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 20%" align="center">
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search" TabIndex="7" ToolTip="Click to Search" CssClass="ItDoseButton" />&nbsp;
                        <asp:Button ID="btnGraph" runat="server" OnClick="btnGraph_Click" Text="Graph" TabIndex="8" ToolTip="Click to Print Graph" CssClass="ItDoseButton" />
                    </td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 20%"></td>
                    <td style="width: 25%"></td>
                </tr>
                <tr>
                    <td align="center" colspan="5">
                        <asp:GridView ID="EmpGrid" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                            OnRowCommand="EmpGrid_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Employee&nbsp;ID" Visible="true">
                                    <ItemTemplate>
                                        <%#Eval("EmployeeID")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Employee&nbsp;Name">
                                    <ItemTemplate>
                                        <%#Eval("Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation">
                                    <ItemTemplate>
                                        <%#Eval("Desi_Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Department">
                                    <ItemTemplate>
                                        <%#Eval("Dept_Name")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Score">
                                    <ItemTemplate>
                                        <asp:Label ID="lblScore" runat="server" Text='<%#Eval("Scores")%>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Grade">
                                    <ItemTemplate>
                                        <asp:Label ID="lblGrade" Text='<%#Eval("Grade") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Print">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbPrint" runat="server" CausesValidation="false" CommandArgument='<%# Eval("EmployeeID")%>'
                                            CommandName="RPrint" ImageUrl="~/Images/Print.gif" ToolTip="Click to Print" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>