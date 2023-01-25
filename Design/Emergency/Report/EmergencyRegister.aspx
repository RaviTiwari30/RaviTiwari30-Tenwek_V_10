<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EmergencyRegister.aspx.cs" Inherits="Design_Emergency_Report_EmergencyRegister" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript" >
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();

            });

            $('#ucToDate').change(function () {
                ChkDate();

            });

        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });

        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }

    </script>
    <div id="Pbody_box_inventory">
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
                <b>Emergency Bill Register Report</b><br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal" Height="16px">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Group Wise</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:RadioButtonList ID="rdbgroupwise" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="B" Selected="True">Bill Wise</asp:ListItem>
                                <asp:ListItem Value="C">Category Wise</asp:ListItem>
                                <asp:ListItem Value="S">Sub Category</asp:ListItem>
                                <asp:ListItem Value="I">Item Wise</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                        <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                             <asp:RadioButtonList ID="rbtnReportType" runat="server" RepeatDirection="Horizontal">
                             <asp:ListItem Text="All" Value="-1" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Admitted" Value="0" ></asp:ListItem>
                            <asp:ListItem Text="Discharged From Emergency" Value="1"></asp:ListItem>
                                 <asp:ListItem Text="Released For IPD" Value="2"></asp:ListItem>
                                 <asp:ListItem Text="Shift To IPD" Value="3"></asp:ListItem>
                                 <asp:ListItem Text="Bill Not Generated" Value="4"></asp:ListItem>
                                 <asp:ListItem Text="Released Not Done" Value="5"></asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                                 From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                             <asp:TextBox ID="ucFromDate" runat="server" Width="120px" ToolTip="Select From Date"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="ucFromDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                          <asp:TextBox ID="txtFromTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                TabIndex="2" />
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtFromTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                             <asp:TextBox ID="ucToDate" runat="server" Width="120px" ToolTip="Select From Date"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="ucToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                               <asp:TextBox ID="txtToTime" runat="server" MaxLength="8" Width="100px" ToolTip="Enter Time"
                                            TabIndex="4" />
                                        <cc1:MaskedEditExtender ID="masksTimes" Mask="99:99" runat="server" MaskType="Time"
                                            TargetControlID="txtToTime" AcceptAMPM="true">
                                        </cc1:MaskedEditExtender>
                                        <cc1:MaskedEditValidator ID="maskTimes" runat="server" ControlToValidate="txtToTime"
                                            ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                            InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">Bill No.</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtBillNo" runat="server" AutoCompleteType="Disabled"></asp:TextBox> 
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">UHID</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtUHID" runat="server" AutoCompleteType="Disabled"></asp:TextBox> 
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Emergency No.</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <asp:TextBox ID="txtEmergencyNo" runat="server" AutoCompleteType="Disabled"></asp:TextBox> 
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            &nbsp;<asp:Button ID="btnSearch" ClientIDMode="Static" runat="server" Text="Report" OnClick="btnSearch_Click" ValidationGroup="Weekly" CssClass="ItDoseButton" /></div>
    </div>
</asp:Content>

