<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DoctorChargesDetails.aspx.cs"
    MasterPageFile="~/DefaultHome.master" Inherits="Design_OPD_DoctorChargesDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(function () {
            show();
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });
            $('#ddlDoctor,#ddlDoctorGroup').chosen();
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnReport.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');
                    }
                }
            });

        }
        function show() {
            if ($("#<%=rdbReportType.ClientID %> input[type=radio]:checked").val() == '1') {
                $('#tdPatientType').show();
                $('#tdVisitType').show();
            }
            else {
                $('#tdPatientType').hide();
                $('#tdVisitType').hide();
            }
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
        <cc1:ToolkitScriptManager ID="sc" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Doctor Wise Appointment Details</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtFromDate_CalendarExtender" runat="server" TargetControlID="txtFromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date"
                                TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtToDate_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbReportType" runat="server" ClientIDMode="Static" onchange="show()" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">App. Detail</asp:ListItem>
                                <asp:ListItem Value="1">Patient Type</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctor" runat="server" TabIndex="3" ToolTip="Select Doctor Name" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctorGroup" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkPackageCondition" runat="server" Text="Include Package" Visible="true" />
                        </div>
                    </div>
                    <div class="row">
                        <div style="display: none;" id="tdPatientType" class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div style="display: none;" id="tdVisitType" class="col-md-12">
                            <asp:RadioButtonList ID="rdbVisitType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0" Selected="True">ALL</asp:ListItem>
                                <asp:ListItem Value="1">Review Patient</asp:ListItem>
                                <asp:ListItem Value="2">New Patient</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                TabIndex="4" ToolTip="Click to Open Report" />
        </div>
    </div>
</asp:Content>
