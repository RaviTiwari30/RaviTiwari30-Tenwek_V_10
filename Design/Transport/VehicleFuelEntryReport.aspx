<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="VehicleFuelEntryReport.aspx.cs" Inherits="Design_Transport_VehicleFuelEntryReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            bindVehicle();
            bindDriver();

            $("#btnReport").click(function () {
                $("#lblErrorMsg").text("");
                $("#btnReport").val("Searching...");
                $("#btnReport").attr("disabled", true);
                $.ajax({
                    url: "Services/Transport.asmx/vehicleFuelEntryReport",
                    data: '{VehicleID:"' + $("#ddlVehicle").val() + '",DriverID:"' + $("#ddlDriver").val() + '",FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            window.open("../common/Commonreport.aspx");
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

        function bindVehicle() {
            $.ajax({
                url: "Services/Transport.asmx/bindVehicle1",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        var Vehicle = $.parseJSON(result.d);
                        $("#ddlVehicle").append($("<option></option>").val("0").html("All"));
                        for (var i = 0; i < Vehicle.length; i++) {
                            $("#ddlVehicle").append($("<option></option>").val(Vehicle[i].Id).html(Vehicle[i].Name));
                        }
                    }
                    else {
                        $("#ddlVehicle").append($("<option></option>").val("0").html("--No Data--"));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindDriver() {
            $.ajax({
                url: "Services/Transport.asmx/bindDriver1",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        var Driver = $.parseJSON(result.d);
                        $("#ddlDriver").append($("<option></option>").val("0").html("All"));
                        for (var i = 0; i < Driver.length; i++) {
                            $("#ddlDriver").append($("<option></option>").val(Driver[i].Id).html(Driver[i].Name));
                        }
                    }
                    else {
                        $("#ddlDriver").append($("<option></option>").val("0").html("--No Data--"));
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
            <b><span id="lblHeader" style="font-weight: bold;">Vehicle Fuel Report</span></b><br />
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
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlVehicle" title="Select Vehicle"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Driver
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDriver" title="Select Driver"></select>
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
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="static" onchange="ChkDate();" ToolTip="Clieck To Select FromDate" />
                            <cc1:CalendarExtender ID="clFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="static" onchange="ChkDate();" ToolTip="Clieck To Select ToDate" />
                            <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" id="btnReport" class="ItDoseButton" value="Report" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>
</asp:Content>

