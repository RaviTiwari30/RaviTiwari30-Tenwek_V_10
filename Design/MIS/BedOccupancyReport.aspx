<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="BedOccupancyReport.aspx.cs" Inherits="Design_MIS_BedOccupancyReport" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            
                <div style="text-align: center;">
                    <b>Bed Occupancy Report</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                </div>
                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                    MaskType="Time" UserTimeFormat="TwentyFourHour" Mask="99:99:99">
                </cc1:MaskedEditExtender>
            </div>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                              <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblFromDate" runat="server" Text="From Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>:</b>"></asp:Label>
                                </label>

                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                    ></asp:TextBox>
                                <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblToDate" runat="server" Text="To Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>:</b>"></asp:Label>
                                </label>

                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                    ></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    At Time 
                                </label>
                                   <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTime" runat="server"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Report Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-7">
                                <asp:RadioButtonList ID="rbtType" RepeatDirection="Horizontal" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rbtType_SelectedIndexChanged">
                                    <asp:ListItem Selected="True" Value="1">Summarised</asp:ListItem>
                                    <asp:ListItem Value="2">Detailed</asp:ListItem>
                                    <asp:ListItem Value="3">Administrative</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                             <div class="col-md-3">
                                <asp:RadioButtonList ID="rbtPDF" RepeatDirection="Horizontal" runat="server" Visible="False" AutoPostBack="True"
                                    OnSelectedIndexChanged="rbtPDF_SelectedIndexChanged">
                                    <asp:ListItem Selected="True" Value="PDF">PDF</asp:ListItem>
                                    <asp:ListItem Value="Excel">Excel</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-8">
                                <asp:RadioButtonList ID="rbtReportType" runat="server" Visible="False">
                                    <asp:ListItem Selected="True">All</asp:ListItem>
                                    <asp:ListItem Value="Specialization,BedCategory">Specialization Wise,Room Type Wise</asp:ListItem>
                                    <asp:ListItem Value="PanelGroup,Company_Name,Specialization">Panel Group Wise,Panel Wise,Specialization Wise</asp:ListItem>
                                    <asp:ListItem Value="Specialization,ConsultantName">Specialization Wise,Doctor Wise</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" OnClick="Button1_Click" Text="Search" CssClass="ItDoseButton" />&nbsp;<br />
        </div>
    </div>
    <div>
        &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
    </div>
</asp:Content>
