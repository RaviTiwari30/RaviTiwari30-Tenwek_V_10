<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ApprovedUnapprovedLog.aspx.cs" Inherits="Design_Lab_Reports_ApprovedUnapprovedLog" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" >

        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();
            });

            $('#ToDate').change(function () {
                ChkDate();
            });
        });
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
                      //  $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        modelAlert('To date can not be less than from date');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                       // $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

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
    </script>
     <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <b>Lab Sample Collection Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-24">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Lab Type</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-13">
                        <asp:RadioButtonList ID="rdbReportType" runat="server" RepeatDirection="Horizontal" >
                           <asp:ListItem Value="0" Selected="True">ALL</asp:ListItem>
                           <asp:ListItem Value="1">OPD</asp:ListItem>
                           <asp:ListItem Value="2">IPD</asp:ListItem>
                           <asp:ListItem Value="3">Emergency</asp:ListItem>
                       </asp:RadioButtonList>
                    </div>
                    <div class="col-md-3">
                         <label class="pull-left"> Barcode No.</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                         <asp:TextBox ID="txtLabNo" runat="server" AutoCompleteType="Disabled" />
                    </div>
                </div>
                <div class="row">
                       <div class="col-md-3">
                         <label class="pull-left"> User</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlUsers" runat="server" ></asp:DropDownList>
                    </div>
                     <div class="col-md-3">
                         <label class="pull-left"> From Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                      <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" AutoCompleteType="Disabled" Width="144px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                        </cc1:CalendarExtender>
                        <asp:TextBox ID="txtFromTime" runat="server" Width="80px" AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="meetxtFromTime" Mask="99:99" TargetControlID="txtFromTime"
                                    AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="metxtFrTime" ControlExtender="meetxtFromTime"
                                    ControlToValidate="txtFromTime" InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>
                     <div class="col-md-3">
                         <label class="pull-left"> To Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" Width="144px" ToolTip="Select To Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                            TargetControlID="ToDate">
                        </cc1:CalendarExtender>
                        <asp:TextBox ID="txtToTime" runat="server" Width="80px"></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="meetxtToTime" Mask="99:99" TargetControlID="txtToTime"
                                    AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime" ControlExtender="meetxtToTime"
                                    ControlToValidate="txtToTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>
                        <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <asp:CheckBox ID="chkAllCentre" runat="server" Text="All Centre" onclick="checkAllCentre();" />
                    </div>
                    <div class="col-md-21">
                         <asp:CheckBoxList ID="chkCentre" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" CssClass="chkAllCentreCheck">
                        </asp:CheckBoxList>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" />
        </div>
    </div>
</asp:Content>

