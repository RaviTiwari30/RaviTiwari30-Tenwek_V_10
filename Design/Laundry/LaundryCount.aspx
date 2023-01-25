<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="LaundryCount.aspx.cs" Inherits="Design_Laundry_LaundryCount" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
     $(document).ready(function () {
            $("#<%=ddlItem.ClientID %>").chosen();
            $("#<%=ddlWard.ClientID %>").chosen();
              });
       </script>
	<cc1:ToolkitScriptManager runat="server" ID="scriptManager"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Laundry Count</b><br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="content">
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">

                <div class="col-md-3">
                    <label class="pull-left">From Date  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtSearchFromDate" runat="server" ClientIDMode="Static" ToolTip="Select From Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="calExdTxtSearchFromDate" TargetControlID="txtSearchFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtSearchToDate" runat="server" ClientIDMode="Static" ToolTip="Select To Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="calExdSearchToDate" TargetControlID="txtSearchToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                   <label class="pull-left">Department </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">

                    <asp:DropDownList ID="ddlWard" runat="server" TabIndex="2" AutoPostBack="true" CssClass="requiredField" ToolTip="Select Department">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    Item
                </div>
                <div class="col-md-4">

                    <asp:DropDownList ID="ddlItem" runat="server" TabIndex="2" AutoPostBack="true"
                        ToolTip="Select Department">
                    </asp:DropDownList>
                </div>

            </div>
        </div>
                
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">

                <div style="text-align: center" class="col-md-6"></div>


                <div style="text-align: center" class="col-md-12">
                    <span id="spanPatInfoID" runat="server" style="display: none;"></span>

                    <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" TabIndex="5" OnClientClick="target ='_blank';"
                        Text="Report" OnClick="btnReport_Click" />
                </div>

                <div style="text-align: center" class="col-md-6"></div>



            </div>
        </div>
</asp:Content>