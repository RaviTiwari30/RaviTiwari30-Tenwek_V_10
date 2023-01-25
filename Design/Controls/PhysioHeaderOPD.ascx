<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PhysioHeaderOPD.ascx.cs"
    Inherits="Design_Controls_PhysioHeaderOPD" %>
<link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
<table width="100%">
    <tr>
        <td rowspan="3" style="width: 10%;">
            <img src="../../Images/logo.png" alt="FOCOS Orthopedic Hospital" style="text-align: left;
                height: 80px; width: 100px;" />
        </td>
        <td align="center" colspan="4">
            <b><span style="font-size: medium">
                <asp:Label ID="lblHeader" Text="<%$ Resources:Resource, ReportHeader %>" runat="server"></asp:Label></span></b>
            </span></b>
        </td>
    </tr>
    <tr>
        <td style="width: 6%;" align="right">
            UHID :
        </td>
        <td align="left" style="width: 20%">
            <asp:Label ID="lblMRNo" ClientIDMode="Static" runat="server"></asp:Label>
        </td>
        <td style="width: 6%" align="right">
            Patient&nbsp;Name :
        </td>
        <td align="left" style="width: 20%">
            <asp:Label ID="lblPname" ClientIDMode="Static" runat="server"></asp:Label>
        </td>
    </tr>
    <tr>
        <td style="width: 6%" align="right">
            Age/Sex :
        </td>
        <td align="left" style="width: 20%">
            <asp:Label ID="lblAgeSex" runat="server"></asp:Label>
        </td>
        <td align="right" style="width: 6%" align="right">
            Doctor :
        </td>
        <td align="left" style="width: 20%">
            <asp:Label ID="lblDoctor" ClientIDMode="Static" runat="server" Text=""></asp:Label>
        </td>
    </tr>
</table>
