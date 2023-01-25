<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FinalDocVisit.aspx.cs" Inherits="Design_IPD_FinalDocVisit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div id="Pbody_box_inventory" runat="server">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Final Doctor Visit</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            <div id="MainDiv" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Final Visit Date Time
                    </div>
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 25%; text-align: right;">Final Visit Date : &nbsp;</td>
                            <td style="width: 20%; text-align: left;">
                                <asp:TextBox ID="txtVisitDate" runat="server" ToolTip="Click To Select Date" Width="140px"></asp:TextBox>
                                <cc1:CalendarExtender ID="calVisitDate" runat="server" TargetControlID="txtVisitDate" Format="dd-MMM-yyyy" Animated="true"></cc1:CalendarExtender>
                            </td>
                            <td style="width: 15%; text-align: right;">Time :&nbsp;</td>
                            <td style="width: 40%; text-align: left;">
                                <uc1:Time runat="server" ID="txtTime" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 25%;"></td>
                            <td style="width: 20%;"></td>
                            <td style="width: 15%;"></td>
                            <td style="width: 40%;"></td>
                        </tr>
                    </table>
                </div>
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <asp:Button ID="btnSave" Text="Save" OnClick="btnSave_Click" CssClass="ItDoseButton" runat="server" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>

