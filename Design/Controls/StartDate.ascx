<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StartDate.ascx.cs" Inherits="Design_Controls_StartDate" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    
<asp:TextBox ID="txtStartDate" runat="server" Width="140px"></asp:TextBox>
<cc1:CalendarExtender ID="calStartDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtStartDate"></cc1:CalendarExtender>