<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Mortuary_CorpseReport.aspx.cs" Inherits="Design_Mortuary_Mortuary_CorpseReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            bindStatus();
            $("#btnReport").click(function () {
                $("#lblErrorMsg").text("");
                $("#btnReport").val("Searching...");
                $("#btnReport").attr("disabled", true);

                $.ajax({
                    url: "Services/Mortuary.asmx/mortuaryCorpseReport",
                    data: '{PatientStatus:"' + $("#ddlStatus").val() + '",Status:"' + $("#rblStatus input[type='radio']:checked").val() + '",FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",StatusReport:"' + $("#RBLReportType input[type='radio']:checked").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            if ($("#RBLReportType input[type='radio']:checked").val() == 1) {
                                window.open("../common/Commonreport.aspx");
                            }
                            else {
                                window.open("../common/ExportToExcel.aspx");
                            }
                            $("#btnReport").val("Report");
                            $("#btnReport").attr("disabled", false);
                        }
                        else {
                            $("#btnReport").val("Report");
                            $("#btnReport").attr("disabled", false);
                            DisplayMsg("MM04", "lblErrorMsg");
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg("MM05", "lblErrorMsg");
                        $("#btnReport").val("Report");
                        $("#btnReport").attr("disabled", false);
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                });
            });
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
                        $('#lblErrorMsg').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblErrorMsg').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });
        }
        function bindStatus() {
            $("#ddlStatus option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/bindPatientType",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientType = jQuery.parseJSON(result.d);
                    $("#ddlStatus").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < PatientType.length; i++) {
                        $("#ddlStatus").append($("<option></option>").val(PatientType[i].id).html(PatientType[i].PatientType));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            Mortuary Corpse Report<br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                From Deposite Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" Width="" ClientIDMode="static" onchange="ChkDate();" ToolTip="Clieck To Select FromDate" />
                            <cc1:CalendarExtender ID="clFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                To Deposite Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" Width="" ClientIDMode="static" onchange="ChkDate();" ToolTip="Clieck To Select ToDate" />
                            <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Patient Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus" title="Select Vehicle"></select>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Report Print Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="RBLReportType" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Pdf" Value="1" Selected="True" />
                                <asp:ListItem Text="Excel" Value="0" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-5">
                           <asp:RadioButtonList ID="rblStatus" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal">
                                <asp:ListItem Text="IN" Value="0" />
                                <asp:ListItem Text="OUT" Value="1" />
                                <asp:ListItem Selected="True" Text="Both IN & OUT" Value="2" />
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnReport" class="ItDoseButton" value="Report" />
        </div>
    </div>
</asp:Content>

