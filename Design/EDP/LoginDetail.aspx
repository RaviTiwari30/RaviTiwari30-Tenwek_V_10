<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="LoginDetail.aspx.cs" Inherits="Design_EDP_LoginDetail" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="sc" runat="server"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div>
                <b>Log Report</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-9">
                    <asp:DropDownList ID="ddlType" runat="server">
                        <asp:ListItem Value="0" Selected="True">Select</asp:ListItem>
                        <asp:ListItem Value="1">Employee Create (Current Status)</asp:ListItem>
                       <%-- <asp:ListItem Value="2">Employee Details Log</asp:ListItem>--%>
                        <asp:ListItem Value="3">Doctor Create (Current Status)</asp:ListItem>
                       <%-- <asp:ListItem Value="4">Doctor Details Log</asp:ListItem>--%>
                        <asp:ListItem Value="17">Panel Create (Current Status)</asp:ListItem>
                        <%--<asp:ListItem Value="18">Panel Details Log</asp:ListItem>--%>
                        <asp:ListItem Value="5">Centre Wise Doctor Mapping (Current Status)</asp:ListItem>
                        <asp:ListItem Value="6">Centre Wise Doctor Mapping Log</asp:ListItem>
                        <asp:ListItem Value="7">Centre Wise Employee Mapping (Current Status)</asp:ListItem>
                        <asp:ListItem Value="8">Centre Wise Employee Mapping Log</asp:ListItem>
                        <asp:ListItem Value="9">Centre Wise Panel Mapping (Current Status)</asp:ListItem>
                        <asp:ListItem Value="10">Centre Wise Panel Mapping Log</asp:ListItem>
                        <asp:ListItem Value="11">Centre Wise Role Mapping (Current Status)</asp:ListItem>
                        <asp:ListItem Value="12">Centre Wise Role Mapping Log</asp:ListItem>
                       <%-- <asp:ListItem Value="13">User Authorization (Current Status)</asp:ListItem>--%>
                      <%--  <asp:ListItem Value="14">User Authorization Log</asp:ListItem>--%>
                        <asp:ListItem Value="15">User Page Rights (Current Status)</asp:ListItem>
                      <%--  <asp:ListItem Value="16">User Page Rights Log</asp:ListItem>--%>
			            <asp:ListItem Value="19">User Login Details</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select From Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="cdfrom" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click to Select To Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="cdTo" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                    </cc1:CalendarExtender>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row " style="text-align: center">
                <asp:Button ID="btnReport" runat="server" OnClick="btnReport_Click" CssClass="ItDoseButton" Text="Report" />

            </div>
        </div>
    </div>
</asp:Content>

