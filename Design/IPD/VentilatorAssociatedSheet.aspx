<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VentilatorAssociatedSheet.aspx.cs" Inherits="Design_IPD_VentilatorAssociatedSheet" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server" EnableScriptGlobalization="true" EnableScriptLocalization="true"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>VAP(Ventilator Associated Pneumonia) Prevention Work Sheet</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: right">Date of Insertion :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtDateInsertion" runat="server" Width="100px" ToolTip="Click To Select Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="cclDateInsertion" runat="server" TargetControlID="txtDateInsertion" Format="dd-MMM-yyyy" Animated="true"></cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right">Date of Removal :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtDateRemoval" runat="server" Width="100px" ToolTip="Click To Select Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="cclDateRemoval" runat="server" TargetControlID="txtDateRemoval" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right">No. of Ventilator days :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:Label ID="lblVentilatorDays" runat="server" Text="0" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Culture Report :&nbsp;</td>
                        <td colspan="3" style="text-align: left">
                            <asp:TextBox ID="txtCultureReport" runat="server" TextMode="MultiLine" Width="346px"></asp:TextBox></td>
                        <td style="text-align: right">&nbsp;</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Any Sign of Infection :&nbsp;</td>
                        <td colspan="3" style="text-align: left">
                            <asp:TextBox ID="txtInfection" runat="server" TextMode="MultiLine" Width="344px"></asp:TextBox></td>
                        <td class="auto-style1" style="text-align: right"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="text-align: right">Nurse Name :&nbsp;</td>
                        <td colspan="3" style="text-align: left">
                            <asp:DropDownList ID="ddlUser" runat="server" Width="250px"></asp:DropDownList></td>
                        <td class="auto-style1" style="text-align: right"></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td style="text-align: right">&nbsp;</td>
                        <td colspan="3" style="text-align: center">
                            <asp:Label ID="lblVapID" runat="server" Visible="false"></asp:Label>
                            <asp:Button ID="btnSaveInsertion" runat="server" CssClass="ItDoseButton" OnClick="btnSaveInsertion_Click" Text="Save" /></td>
                        <td class="auto-style1" style="text-align: right"></td>
                        <td></td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <table style="width: 100%" id="tb_Record" runat="server">
                    <tr>
                        <td style="text-align: right">Date :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtVapDate" runat="server" Width="100px" AutoPostBack="true" OnTextChanged="txtVapDate_TextChanged" ToolTip="Click To Select Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcVapDate" runat="server" TargetControlID="txtVapDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <asp:GridView ID="grdVAP" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" Width="800px" OnRowDataBound="grdVAP_RowDataBound">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                            <asp:Label ID="lblVapID" runat="server" Text='<%#Eval("VapID") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblVap" runat="server" Text='<%#Eval("VAPPrevention") %>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblVAPPreventionID" runat="server" Text='<%#Eval("VAPPreventionID") %>' Visible="false"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="VAPPrevention" HeaderText="VAP Prevention Worksheet" HeaderStyle-Width="200px"
                                        ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center" />
                                    <asp:TemplateField HeaderText="Morning" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblM" runat="server" Visible="false" Text='<%#Eval("VAPM") %>'></asp:Label>
                                            <asp:Label ID="lblUserIDM" runat="server" Visible="false" Text='<%#Eval("MorEntryBy") %>'></asp:Label>
                                            <asp:Label ID="lblUserIDE" runat="server" Visible="false" Text='<%#Eval("EveEntryBy") %>'></asp:Label>
                                            <asp:RadioButtonList ID="rblM" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="2">
                                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Evening" HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                        HeaderStyle-CssClass="GridViewHeaderStyle" HeaderStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:Label ID="lblE" runat="server" Visible="false" Text='<%#Eval("VAPE") %>'></asp:Label>
                                            <asp:RadioButtonList ID="rblE" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="2">
                                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" CssClass="ItDoseButton" Text="Save" ToolTip="Click To Save" />
            </div>
        </div>
    </form>
</body>
</html>
