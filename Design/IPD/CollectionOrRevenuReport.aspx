<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CollectionOrRevenuReport.aspx.cs" Inherits="Design_IPD_CollectionOrRevenuReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Collection &amp; Revenue Report</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Critaria &nbsp;
                <br />
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" Width=""
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ucFromDate_CalendarExtender" runat="server" TargetControlID="ucFromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" MaxLength="8" Width="" ToolTip="Enter Time"
                                TabIndex="2" />
                            <cc1:CalendarExtender ID="ucToDate_CalendarExtender" runat="server" TargetControlID="ucToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Report Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtReportType" runat="server" AutoPostBack="True"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="0">Summary</asp:ListItem>
                                <asp:ListItem Value="1">Detail</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Filter Option</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:CheckBox ID="chkOPD" runat="server" OnCheckedChanged="chkOPD_CheckedChanged"
                                Text="OPD" ValidationGroup="OPDIPD" AutoPostBack="True" />&nbsp;
                            <asp:CheckBox ID="chkIPD" runat="server" OnCheckedChanged="chkIPD_CheckedChanged"
                                Text="IPD" ValidationGroup="OPDIPD" AutoPostBack="True" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"></label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            
                             <asp:DropDownList ID="ddlPanel" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <asp:CheckBoxList ID="chkOPDDtl" runat="server" Visible="False">
                                <asp:ListItem Value="1">OPD SameDay Collection</asp:ListItem>
                                <asp:ListItem Value="2">OPD BackDay Collection</asp:ListItem>
                                <asp:ListItem Value="3">OPD Outstanding</asp:ListItem>
                            </asp:CheckBoxList>
                        </div>
                        <div class="col-md-6">
                            <asp:CheckBoxList ID="chkIPDDtl" runat="server" Visible="False">
                                <asp:ListItem Value="4">IPD Advance</asp:ListItem>
                                <asp:ListItem Value="5">IPD BillGenerated</asp:ListItem>
                                <asp:ListItem Value="6">IPD FinalSettlement</asp:ListItem>
                                <%--<asp:ListItem Value="7">IPD Outstanding</asp:ListItem>--%>
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1">
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <asp:Button ID="btnPreview" runat="server" Text="Search" CssClass="ItDoseButton"
                    OnClick="btnPreview_Click" />
            </div>
        </div>
    </div>

</asp:Content>

