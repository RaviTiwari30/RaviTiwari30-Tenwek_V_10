<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PanelOutstanding.aspx.cs"
    Inherits="Design_CommonReports_PanelOutstanding" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript">
        $(function () {
            $('#ddlPanel').chosen();
        });
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Panel Outstanding Report</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCentre" OnSelectedIndexChanged="ddlCentre_SelectedIndexChanged" AutoPostBack="true" runat="server"></asp:DropDownList>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Panel </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Patient Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPatientType" runat="server">
                                <asp:ListItem Value="OPD">OPD</asp:ListItem>
                                <asp:ListItem Value="EMG">Emergency </asp:ListItem>
                                <asp:ListItem Value="IPD">IPD </asp:ListItem>
                                <asp:ListItem Value="Both" Selected="True">ALL</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>


                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" ></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" AutoCompleteType="Disabled"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Date Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDateType" runat="server">
                                <asp:ListItem Value="1">Addmision Date</asp:ListItem>
                                <asp:ListItem Value="2">Discharge Date </asp:ListItem>
                                <asp:ListItem Value="3" Selected="True">Bill Date </asp:ListItem>
                                <asp:ListItem Value="4">Invoice/Dispatch Date</asp:ListItem>
                                <asp:ListItem Value="5">Allocation Date</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Bill No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillNo" runat="server"></asp:TextBox>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Receipt No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReceiptNo" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">UHID </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Aging Criteria</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlAgingCriteria" runat="server">
                                <asp:ListItem Value="0" Selected="True">ALL</asp:ListItem>
                                <asp:ListItem Value="0-31" >0-31 (Days)</asp:ListItem>
                                <asp:ListItem Value="31-90">31-90 (Days)</asp:ListItem>
                                <asp:ListItem Value="91-120">91-120 (Days)</asp:ListItem>
                                <asp:ListItem Value="121-180">121-180 (Days)</asp:ListItem>
                                 <asp:ListItem Value="181-360">181-360 (Days)</asp:ListItem>
                                <asp:ListItem Value="361-1000000">>361 (Days)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Report Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtReportType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" >PDF</asp:ListItem>
                                 <asp:ListItem Value="2" Selected="True">Excel</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Amount Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTotalOutstanding" runat="server">
                                <asp:ListItem Selected="True" Value="1">Outstanding Wise</asp:ListItem>
                                <asp:ListItem Value="2">Allocation Wise</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                     <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">Report Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlReportType" runat="server">
                                <asp:ListItem Selected="True" Value="1">Detail</asp:ListItem>
                                <asp:ListItem Value="2">Summary</asp:ListItem>
                                 <asp:ListItem Value="3">Patient Summary</asp:ListItem>
                                <asp:ListItem Value="4">Panel Outsanding</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                     </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align:center;">
             <asp:Button ID="btnSearch" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click" />
        </div>
</asp:Content>
