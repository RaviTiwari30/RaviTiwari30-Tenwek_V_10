<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CollectionAndRevenueReport.aspx.cs"
    Inherits="Design_Finance_CollectionAndRevenueReport" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Revenue Vs Collection Report</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" Width="150px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" Width="150px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Patient Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rbtPatientType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="OPD">OPD</asp:ListItem>
                                 <asp:ListItem Value="EMG">Emergency </asp:ListItem>
                                <asp:ListItem Value="Both" Selected="True">Both</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Report Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0">Summary</asp:ListItem>
                                <asp:ListItem Value="1" Selected="True">Detail</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                       
                        <div class="col-md-3">
                            <label class="pull-left">Group Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:RadioButtonList ID="rbtGroupType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1">Departmentwise </asp:ListItem>
                                <asp:ListItem Value="2">Patientwise</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                         <div class="col-md-5">
                              <asp:Button ID="btnPreview" runat="server" Text="Search" CssClass="ItDoseButton"
                                OnClick="btnPreview_Click" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>
</asp:Content>
