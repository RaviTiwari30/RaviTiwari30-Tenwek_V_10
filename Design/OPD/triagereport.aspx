<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TriageReport.aspx.cs" Inherits="Design_OPD_TriageReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <div id="Pbody_box_inventory">

        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Triage Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Search Criteria
            </div>

            <div class="row" id="divDateCariteria">

                <div class="col-md-3">
                    From Date :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"> </asp:TextBox>
                    <cc1:CalendarExtender ID="fromdate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>

                <div class="col-md-3">To Date  :</div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"> </asp:TextBox>
                    <cc1:CalendarExtender ID="todate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>


                 <div class="col-md-3">
                    Report Type :
                </div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlReportType" ClientIDMode="Static" onchange="hideShowFieldInPatient()">
                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                        <asp:ListItem Text="Appointments Outpatient Report(Triage)" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Casulty Reports" Value="2"></asp:ListItem>                        
                       
                       
                        
                    </asp:DropDownList>
                </div>

            </div>






        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click" />
        </div>

    </div>


</asp:Content>
