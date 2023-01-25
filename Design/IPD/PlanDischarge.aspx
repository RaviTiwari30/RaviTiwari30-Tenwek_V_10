<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PlanDischarge.aspx.cs" Inherits="Design_IPD_PlanDischarge" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div style="text-align: center;">
                    <b>Plan Discharge</b><br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>                    
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="MainDiv" runat="server">
                <div class="Purchaseheader">
                    Plan Discharge Details
                </div>
                <table style="width: 100%">
                    <tr>
                        <td align="right" style="width: 20%" class="ItDoseLabel">Plan Type :</td>
                        <td colspan="3" class="ItDoseLabel">
                            <asp:RadioButtonList ID="rbtPlanDisc" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rbtPlanDisc_SelectedIndexChanged" RepeatDirection="Horizontal" RepeatColumns="2">
                                <asp:ListItem Selected="True" Value="1">Plan Discharge</asp:ListItem>
                                <asp:ListItem Value="2">Un-Plan Discharge</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr id="trPlanDischargeType" runat="server">
                        <td align="right" style="width: 20%" class="ItDoseLabel">Discharge :</td>
                        <td colspan="3" class="ItDoseLabel">
                            <asp:RadioButtonList ID="rbtVisitType" runat="server" RepeatDirection="Horizontal" RepeatColumns="2">
                                <asp:ListItem Value="1" Selected="True">After Doctor Visit</asp:ListItem>
                                <asp:ListItem Value="2">Before Doctor Visit</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr id="trPlan" runat="server">
                        <td style="width: 25%" align="right" class="ItDoseLabel">Plan Discharge Date :</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtDischargeDate" runat="server" ToolTip="Click To Select Date" Width="140px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDischangeDate" runat="server" TargetControlID="txtDischargeDate" Format="dd-MMM-yyyy" Animated="true"></cc1:CalendarExtender>
                        </td>
                        <td colspan="2" style="text-align: left">Time :&nbsp;<uc1:Time runat="server" ID="txtDischargeTime" />
                        </td>
                    </tr>
                    <tr id="trUnplan" runat="server">
                        <td style="width: 20%" align="right" class="ItDoseLabel">Plan Discharge Type :</td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlUnPlan" runat="server">
                                <%--<asp:ListItem Value="Select" Text="--Select--"></asp:ListItem>
                                <asp:ListItem Value="Normal" Text="Normal"></asp:ListItem>
                                <asp:ListItem Value="Expired" Text="Expired"></asp:ListItem>
                                <asp:ListItem Value="Lama" Text="Lama"></asp:ListItem>
                                <asp:ListItem Value="Discharge On Request" Text="Discharge On Request"></asp:ListItem>
                                <asp:ListItem Value="Absconding" Text="Absconding"></asp:ListItem>--%>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%" align="right" class="ItDoseLabel"></td>
                        <td colspan="3">
                            <asp:Button ID="btnSave" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>

