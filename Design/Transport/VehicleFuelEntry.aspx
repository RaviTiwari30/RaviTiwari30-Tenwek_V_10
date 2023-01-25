<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="VehicleFuelEntry.aspx.cs" Inherits="Design_Transport_VehicleFuelEntry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            bindVehicle();
            bindDriver();
            $("#txtRemarks").keypress(function (e) {
                var keynum
                var keychar
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                //List of special characters you want to restrict

                if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/" || keychar == "`") {
                    return false;
                }
                else {
                    return true;
                }
            });

            $("#txtAmount").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if ((charCode != 46 || $(this).val().indexOf('.') != -1) && ((charCode < 48 || charCode > 57) && (charCode != 0 && charCode != 8))) {
                    e.preventDefault();
                }
                var text = $(this).val();
                if ((text.indexOf('.') != -1) &&
                  (text.substring(text.indexOf('.')).length > 2) &&
                  (charCode != 0 && charCode != 8) &&
                  ($(this)[0].selectionStart >= text.length - 2)) {
                    e.preventDefault();
                }
            });

            $("#btnSave").click(function () {

                $("#lblErrorMsg").text("");
                if ($("#ddlVehicle").val() == "0") {
                    $("#ddlVehicle").focus();
                    $("#lblErrorMsg").text("Select Vehicle");
                    return;
                }

                if ($("#ddlDriver").val() == "0") {
                    $("#ddlDriver").focus();
                    $("#lblErrorMsg").text("Select Driver Name");
                    return;
                }

                if ($("#txtAmount").val() == "") {
                    $("#txtAmount").focus();
                    $("#lblErrorMsg").text("Enter Total Amount");
                    return;
                }

                if ($("#txtLetter").val() == "") {
                    $("#txtLetter").focus();
                    $("#lblErrorMsg").text("Enter Letter");
                    return;
                }

                $("#btnSave").val("Submitting...");
                $("#btnSave").attr("disabled", true);
                $.ajax({
                    url: "Services/Transport.asmx/saveFuelEntry",
                    data: '{VehicleID:"' + $("#ddlVehicle").val() + '",DriverID:"' + $("#ddlDriver").val() + '",Amount:"' + $("#txtAmount").val() + '",Letter:"' + $.trim($("#txtLetter").val()) + '",Remarks:"' + $.trim($("#txtRemarks").val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            clearControls();
                            DisplayMsg("MM01", "lblErrorMsg");
                        }
                        else {
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            DisplayMsg("MM05", "lblErrorMsg");
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                });
            });
        });

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
                        $("#ddlVehicle").append($("<option></option>").val("0").html("Select"));
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
                        $("#ddlDriver").append($("<option></option>").val("0").html("Select"));
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

        function clearControls() {
            $("#ddlVehicle").val("0");
            $("#ddlDriver").val("0");
            $("#txtAmount").val("");
            $("#txtLetter").val("");
            $("#txtRemarks").val("");
        }

    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Vehicle Fuel Entry</span></b>
            <br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Vehicle Fuel Detail
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
                            <select id="ddlVehicle" class="requiredField" title="Select Vehicle"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purchase By
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDriver" class="requiredField" title="Select Driver Name"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Total Amount
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="txtAmount" type="text" style="text-align: right;" title="Enter Total Amount" maxlength="10" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Letter
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="txtLetter" type="text" title="Enter Letter" maxlength="15" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtRemarks" style="height: 50px; resize: none;" cols="1" rows="1" title="Enter Remarks" maxlength="500"></textarea>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" id="btnSave" class="ItDoseButton" value="Save" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divServiceResult" style="display: none; max-height: 400px;">
            <div class="Purchaseheader">
                Vehicle Services 
            </div>
            <div id="divVehicleService" style="overflow: auto;">
            </div>
        </div>
    </div>
</asp:Content>

