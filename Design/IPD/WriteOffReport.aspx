<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="WriteOffReport.aspx.cs" Inherits="Design_IPD_WriteOffReport" %>

<%-- Add content controls here --%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel" TagPrefix="uc2" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>User Previlage Report</b>
            <br />
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">
                        UHID 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtUhid" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                    <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                    <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">
                        IPD No/Encounter No. 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtIpdNo" runat="server"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <label class="pull-left">
                        Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlType" runat="server" ClientIDMode="Static">
                        <asp:ListItem Text="Write Off" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Patient Clearance" Value="1"></asp:ListItem>
                         <asp:ListItem Text="Opd Debts(paid service) " Value="2"></asp:ListItem>
                    </asp:DropDownList>

                </div>
            </div>
    </div>

    <div class="POuter_Box_Inventory" style="text-align: center;">
        <div class="row">
            <asp:Button ID="btnReport" Text="Report" runat="server" OnClick="btnReport_Click" />
        </div>

    </div>

    </div>
    <script type="text/javascript">
        $(document).ready(function () {

        });
    </script>
</asp:Content>
