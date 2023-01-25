<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TransportDetailsReport.aspx.cs" Inherits="Design_Transport_TransportDetailsReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />

    <script type="text/javascript">
        jQuery(document).ready(function () {            
            jQuery('#<%=ddlDepFrom.ClientID%>').chosen();
        });
    </script>

    <div class="body_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <div style="height: 40px;"></div>

        <div style="border: solid thin; padding: 2px; height: 157px; width: 1303px; margin-left: 20px;">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b><span id="lblHeader" style="font-weight: bold;">Department wise Transactions Report</span></b><br />
                <asp:Label runat="server" ID="lblErrorMsg" CssClass="ItDoseLblError"></asp:Label>

            </div>


            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="Purchaseheader">
                    Search Criteria
                </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">


                <div class="row">
                    <div class="col-md-24">

                        <div class="row">
                            <div class="col-md-3">
                                From Date
                            <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left">
                                <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Select From Date" ClientIDMode="Static" />
                                <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>

                            <div class="col-md-3">
                                To Date
							<b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left">
                                <asp:TextBox ID="txtToDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static" />
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                Type of Vehicle
							<b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left">
                                <asp:DropDownList ID="ddlVehicleType" runat="server">
                                    <asp:ListItem Text="All" Value="0" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Normal" Value="Normal"></asp:ListItem>
                                    <asp:ListItem Text="Ambulance" Value="Ambulance"></asp:ListItem>
                                </asp:DropDownList>

                            </div>

                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                Department From
							<b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align: left">

                                <asp:DropDownList runat="server" ID="ddlDepFrom"></asp:DropDownList>
                                <asp:Label ID="lblLoginType" runat="server" ClientIDMode="Static" Style="display: none;" />

                            </div>


                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-24" style="text-align: center;">
                                <asp:Button ID="btnReport" Text="Report" runat="server" OnClick="btnReport_Click" />

                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>


            </div>

        </div>

    </div>


</asp:Content>

