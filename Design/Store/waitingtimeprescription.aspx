<%@ Page Language="C#" AutoEventWireup="true" CodeFile="waitingtimeprescription.aspx.cs" Inherits="Design_Store_waitingtimeprescription" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="scrManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b id="pageTitle">Prescription Average waiting Time</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Searching Criteria
            </div>
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
            <div class="row">
                <div class="col-md-3">
                   <label class="pull-left">Pharmacy Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddldepartment" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                   <label class="pull-left">UHID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:TextBox ID="txtUHID" runat="server" ToolTip="Enter Patient UHID"></asp:TextBox>
                </div>
            </div>
            <div class="row">
               	<div class="col-md-3">
							<label class="pull-left">From Date  </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
								<asp:TextBox ID="txtSearchFromDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select From Date" ></asp:TextBox>
							<cc1:CalendarExtender ID="calExdTxtSearchFromDate" TargetControlID="txtSearchFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
						 <div class="col-md-3">
							<label class="pull-left">To Date </label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
							  <asp:TextBox ID="txtSearchToDate"  runat="server"   ClientIDMode="Static"   ToolTip="Select To Date" ></asp:TextBox>
							  <cc1:CalendarExtender ID="calExdSearchToDate" TargetControlID="txtSearchToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
						</div>
            </div>
                    <div class="col-md-1"></div>
                    </div>
          
</div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSearch1" runat="server" CssClass="ItDoseButton" TabIndex="5"
                    Text="Report" OnClick="btnSearch1_Click" />
            </div>
        </div>

    </asp:Content>
