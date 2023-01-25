<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Antenatal_patient_report.aspx.cs" Inherits="Design_Lab_PragnancyReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                      
                    }
                }
            });
        }
    </script>
     <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Antenatal Patient Report</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal"
                                onclick="show();">
                                <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="All" Value="ALL"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server" TabIndex="1" ToolTip="Enter UHID"
                                MaxLength="20" />
                        </div>
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Contact 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:TextBox ID="txtContact" runat="server" ToolTip="Contact" MaxLength="11"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" runat="server" TargetControlID="txtContact"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" TabIndex="11" ToolTip="Select From Date" onchange="ChkDate();"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" TabIndex="12" onchange="ChkDate();"
                                ToolTip="Select To Date"></asp:TextBox>
                             <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-22">
                            <center>
                                <asp:Button ID="btnSearch" Text="Report" runat="server"  CssClass="ItDoseButton" OnClick="btnSearch_Click" />
                            </center>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

