<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MedicationRecord.aspx.cs"
    Inherits="Design_CPOE_MedicationRecord" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" href="../../Styles/PurchaseStyle.css" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script language="javascript" src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript"> 



    </script>
</head>
<body>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Medication Administration Record</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div style="text-align: left; display: none">
                <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" OnClick="btnPrint_Click" /></div>
            <div class="POuter_Box_Inventory">
                <table>
                    <tr>
                        <td>
                            <%--<asp:Panel runat="server" ID="pnlMedicine" ScrollBars="Auto" Width="960px" Height="450px">--%>
                            <asp:Panel runat="server" ID="pnlMedicine" Width="960px">
                                <asp:Repeater ID="rptMedicine" runat="server" OnItemCommand="rptMedicine_ItemCommand"
                                    OnItemDataBound="rptMedicine_ItemDataBound">
                                    <HeaderTemplate>
                                        <table class="GridViewStyle" cellspacing="0" style="border-collapse: collapse;">
                                            <tr style="text-align: center; background-color: #afeeee;">
                                                <th class="GridViewHeaderStyle" scope="col">&nbsp;
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">S.No.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Medicine Name
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Issue Date & Time
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Issue Qty.
                                                </th>
                                                <th class="GridViewHeaderStyle" scope="col">Type
                                                </th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr style="text-align: center; background-color: #afeeee;">
                                            <td class="GridViewItemStyle" style="width: 30px; text-align: left;">
                                                <asp:ImageButton ID="imbShow" runat="server" AlternateText="Show" ImageUrl="~/Images/plus.png"
                                                    CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("Date")+"#"+Eval("ItemName") %>' />
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 30px;">
                                                <%# Container.ItemIndex+1 %>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 200px; text-align: left;">
                                                <b>
                                                    <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label></b>
                                                <asp:Label ID="lblItemID" runat="server" Text='<%#Eval("ItemID") %>' Visible="false"></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 200px;">
                                                <asp:Label ID="lblIssueDate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 100px;">
                                                <%# Eval("IssueQty")%>
                                            </td>
                                            <td class="GridViewItemStyle" style="width: 250px; text-align: left;">
                                                <b>
                                                    <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("Status") %>'></asp:Label></b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="8" style="padding-left: 5px">
                                                <asp:Repeater ID="rptMedicineDetails" runat="server" OnItemCommand="rptMedicineDetails_ItemCommand"
                                                    OnItemDataBound="rptMedicineDetails_ItemDataBound">
                                                    <HeaderTemplate>
                                                        <table>
                                                            <tr>
                                                                <td style="vertical-align: top">Date
                                                                <asp:TextBox ID="txtDate" runat="server" Width="100px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                                                    <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                                                                    </cc1:CalendarExtender>
                                                                </td>
                                                                <td style="vertical-align: top">Time
                                                                <asp:TextBox ID="txttime" runat="server" Width="60px" CssClass="ItDoseTextinputText"></asp:TextBox>
                                                                    <cc1:MaskedEditExtender ID="masEndTime" Mask="99:99" runat="server" MaskType="Time"
                                                                        TargetControlID="txttime" AcceptAMPM="True">
                                                                    </cc1:MaskedEditExtender>
                                                                    <cc1:MaskedEditValidator ID="maskEndTime" runat="server" ControlToValidate="txttime"
                                                                        ControlExtender="masEndTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                                                        InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                                                </td>
                                                                <td style="width: 100px; vertical-align: top">Dose
                                                                <asp:TextBox ID="txtDose" runat="server" Width="50px"></asp:TextBox>
                                                                </td>
                                                                <td style="vertical-align: top">Route
                                                                <%--<asp:TextBox ID="txtRoute" runat="server" Width="50px"></asp:TextBox>--%>
                                                                    <asp:DropDownList ID="ddlRouteHos" runat="server" Width="50px"></asp:DropDownList>
                                                                </td>
                                                                <td style="vertical-align: top">Frequency
                                                              <%--  <asp:TextBox ID="txtFrequency" runat="server" Width="50px"></asp:TextBox>--%>
                                                                    <asp:DropDownList ID="ddFreHos" runat="server" Width="50px"></asp:DropDownList>
                                                                </td>
                                                                <td>&nbsp;&nbsp;&nbsp;<asp:Button ID="btnSave" runat="server" Text="Save" ForeColor="Blue"
                                                                    Font-Bold="true" />
                                                                </td>
                                                                <td style="display: none">Remark :<asp:DropDownList ID="ddlStatusType" runat="server" CssClass="ItDoseDropdownbox" Visible="false">
                                                                    <asp:ListItem Selected="True"></asp:ListItem>
                                                                    <asp:ListItem>Patient Refused</asp:ListItem>
                                                                    <asp:ListItem>Patient Unavailable</asp:ListItem>
                                                                    <asp:ListItem>Medication Unavailable</asp:ListItem>
                                                                    <asp:ListItem>Patient asleep</asp:ListItem>
                                                                </asp:DropDownList>
                                                                </td>
                                                                <td style="display: none">
                                                                    <asp:RadioButtonList runat="server" ID="rdoStatus" RepeatDirection="Horizontal" CssClass="ItDoseRadiobutton" Visible="false">
                                                                        <asp:ListItem Selected="True" Value="0">Running</asp:ListItem>
                                                                        <asp:ListItem Value="1">Stopped/ Completed</asp:ListItem>
                                                                    </asp:RadioButtonList>
                                                                </td>

                                                            </tr>
                                                            <tr style="color: #387C44; background-color: #fafad2;">
                                                                <th scope="col">S.No.
                                                                </th>
                                                                <th scope="col">Medicine Date
                                                                </th>
                                                                <th scope="col">Time
                                                                </th>
                                                                <th scope="col">Dose
                                                                </th>
                                                                <th scope="col">Route
                                                                </th>
                                                                <th scope="col">Frequency
                                                                </th>
                                                                <th scope="col">Entry By
                                                                </th>
                                                                <th scope="col">Entry Date & Time
                                                                </th>
                                                                <th scope="col" style="display: none"></th>
                                                                <th scope="col"></th>
                                                            </tr>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <tr style="background-color: #fafad2; text-align: center;">
                                                            <td style="width: 150px;">
                                                                <%# Container.ItemIndex+1 %>
                                                            </td>
                                                            <td style="width: 150px;">
                                                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("DATE") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 150px;">
                                                                <asp:Label ID="Label1" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblDose" runat="server" Text='<%#Eval("Dose") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblRoute" runat="server" Text='<%#Eval("Route") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 50px;">
                                                                <asp:Label ID="lblFrequency" runat="server" Text='<%#Eval("Frequency") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 250px;">
                                                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 250px;">
                                                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDateTime") %>'></asp:Label>
                                                            </td>
                                                            <td style="width: 250px; display: none">
                                                                <asp:Label ID="lblStatusType" runat="server" Text='<%#Eval("StatusType") %>' ForeColor="Blue"
                                                                    Font-Bold="true"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:ImageButton ID="imbCancel" runat="server" ImageUrl="~/Images/Delete.gif" CommandName="cancel"
                                                                    CausesValidation="false" CommandArgument='<%# Eval("ItemID")+"#"+Eval("Date")+"#"+Eval("TransactionID")+"#"+Eval("ID") %>' />
                                                            </td>
                                                        </tr>
                                                    </ItemTemplate>
                                                    <FooterTemplate>
                                                        </table>
                                                    </FooterTemplate>
                                                </asp:Repeater>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="POuter_Box_Inventory" style="display: none">
                                <div class="Purchaseheader">
                                    Other Medicine
                                </div>
                                <table style="width: 100%">
                                    <tr>
                                        <td style="text-align: right">Medicine:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtMedicineNameOther" runat="server" Width="150px"></asp:TextBox>
                                        </td>
                                        <td style="text-align: right">Date:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDateOther" runat="server" Width="100px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="calucDateOther" runat="server" TargetControlID="txtDateOther"
                                                Format="dd-MMM-yyyy">
                                            </cc1:CalendarExtender>
                                        </td>
                                        <td style="text-align: right">Time:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtOtherTime" runat="server" Width="60px"></asp:TextBox>
                                            <cc1:MaskedEditExtender ID="masEndTimeOther" Mask="99:99" runat="server" MaskType="Time"
                                                TargetControlID="txtOtherTime" AcceptAMPM="True">
                                            </cc1:MaskedEditExtender>
                                            <cc1:MaskedEditValidator ID="maskEndTimeOther" runat="server" ControlToValidate="txtOtherTime"
                                                ControlExtender="masEndTimeOther" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                                InvalidValueMessage="Invalid Time" ValidationGroup="save2"></cc1:MaskedEditValidator>
                                        </td>

                                        <td style="text-align: right"></td>
                                        <td>
                                            <asp:DropDownList ID="ddlStatusTypeOther" runat="server" Width="80px" Visible="false">
                                                <asp:ListItem Selected="True"></asp:ListItem>
                                                <asp:ListItem>Patient Refused</asp:ListItem>
                                                <asp:ListItem>Patient Unavailable</asp:ListItem>
                                                <asp:ListItem>Medication Unavailable</asp:ListItem>
                                                <asp:ListItem>Patient asleep</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right">Dose:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDoseOther" runat="server" Width="50px"></asp:TextBox>
                                        </td>
                                        <td style="text-align: right">Route:
                                        </td>
                                        <td>
                                            <%-- <asp:TextBox ID="txtOtherRoute" runat="server" Width="50px"></asp:TextBox>--%>
                                            <asp:DropDownList ID="ddlOtherRoute" runat="server"></asp:DropDownList>
                                        </td>
                                        <td style="text-align: right">Frequency:
                                        </td>
                                        <td>
                                            <%--  <asp:TextBox ID="txtOtherFrequency" runat="server" Width="50px"></asp:TextBox>--%>
                                            <asp:DropDownList ID="ddlOtherFrequency" runat="server"></asp:DropDownList>
                                            <asp:Label ID="lblOtherID" runat="server" Visible="false"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Button ID="btnSaveOther" runat="server" Text="Save" OnClick="btnSaveOther_Click" CssClass="ItDoseButton" />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnOtherCancel" runat="server" Text="Cancel" OnClick="btnOtherMedicine_Click" CssClass="ItDoseButton" Visible="false" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="11" style="text-align: left">
                                            <%-- <asp:Panel runat="server" ID="Panel1" ScrollBars="Auto" Width="960px" Height="200px">--%>
                                            <asp:Panel runat="server" ID="Panel2" Width="960px">
                                                <asp:GridView ID="grdOtherMedicine" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                                    Width="100%" OnRowCommand="grdOtherMedicine_RowCommand">
                                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="S.No."
                                                            ItemStyle-CssClass="GridViewItemStyle">
                                                            <ItemTemplate>
                                                                <%# Container.DataItemIndex+1 %>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Medicine Name"
                                                            ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblMedicineName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Date" ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDate" runat="server" Text='<%#Eval("DATE") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Time" ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Dose" ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblDose" runat="server" Text='<%#Eval("Dose") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Route"
                                                            ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblRoute" runat="server" Text='<%#Eval("Route") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Frequency"
                                                            ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblFrequency" runat="server" Text='<%#Eval("Frequency") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Entry By"
                                                            ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblEntryBy" runat="server" Text='<%#Eval("EntryBy") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Entry Date"
                                                            ItemStyle-CssClass="GridViewItemStyle">
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblEntryDate" runat="server" Text='<%#Eval("EntryDate") %>'></asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Edit">
                                                            <ItemTemplate>
                                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Cancel">
                                                            <ItemTemplate>
                                                                <asp:ImageButton ID="imgbtnCancel" AlternateText="Cancel" CommandName="CancelOther" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/Delete.gif" runat="server" />
                                                                <asp:Label ID="lblEntryByID" Text='<%#Eval("EntryByID") %>' runat="server" Visible="false"></asp:Label>
                                                            </ItemTemplate>
                                                            <ItemStyle CssClass="GridViewItemStyle" />
                                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="10px" />
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
