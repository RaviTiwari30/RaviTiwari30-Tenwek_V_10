<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="MonthClosing.aspx.cs" Inherits="Design_Transport_MonthClosing" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            binVehicle();
        });
        function binVehicle() {
            $('#lblErrormsg').text('');
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindMonthClosingVehicle",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Vehicle = jQuery.parseJSON(response.d);
                    if (Vehicle != null) {
                        $("#ddlVehicle").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Vehicle.length; i++) {
                            $("#ddlVehicle").append($("<option></option>").val(Vehicle[i].Id).html(Vehicle[i].Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function chkOpening() {
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/chkOpening",
                data: '{VehicleID:"' + $.trim($("#ddlVehicle").val()) + '",Month:"' + $("#txtMonthYear").val() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    if (response.d != "")
                        $("#txtOpening").val(response.d).prop('readOnly', true);
                    else
                        $("#txtOpening").val('').prop('readOnly', false);
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        $(document).ready(function () {
            $("#txtOpening,#txtClosing").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
                strLen = $(this).val().length;
                strVal = $(this).val();
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;
                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                    ((e.keyCode) ? e.keyCode :
                                    ((e.which) ? e.which : 0));
                    if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
            });
        });
        function chkCondition() {
            var con = 0;
            if ($("#ddlVehicle").val() == "0") {
                $("#lblErrormsg").text('Please Select Vehicle');
                $("#ddlVehicle").focus();
                return false;
            }
            if ($("#txtOpening").val() == "") {
                $("#lblErrormsg").text('Please Enter Month Opening');
                $("#txtOpening").focus();
                return false;
            }
            if ($("#txtClosing").val() == "") {
                $("#lblErrormsg").text('Please Enter Month Closing');
                $("#txtClosing").focus();
                return false;
            }
            if ($("#txtOpening").val() > $("#txtClosing").val()) {
                $("#lblErrormsg").text('Month Opening always greater than Month Closing');
                $("#txtClosing").focus();
                return false;
            }
            return true;
        }
        function clearDetail() {
            $("#ddlVehicle").prop('selectedIndex', 0);
            $("#txtOpening,#txtClosing").val('');
        }
        function saveMonthClosing() {
            if (chkCondition() == true) {
                $("#lblErrormsg").text('');
                $.ajax({
                    type: "POST",
                    url: "Services/Transport.asmx/saveMonthClosing",
                    data: '{VehicleID:"' + $.trim($("#ddlVehicle").val()) + '",Month:"' + $("#txtMonthYear").val() + '",MonthOpening:"' + $("#txtOpening").val() + '",MonthClosing:"' + $("#txtClosing").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        if (response.d == "1") {
                            DisplayMsg('MM01', 'lblErrormsg');
                        }
                        else if (response.d == "2") {
                            $("#lblErrormsg").text('Already Closed');
                        }
                        else
                            DisplayMsg('MM05', 'lblErrormsg');
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }
        var cal1;
        function pageLoad() {
            cal1 = $find("calendar1");
            modifyCalDelegates(cal1);
        }
        function modifyCalDelegates(cal) {
            //we need to modify the original delegate of the month cell.
            cal._cell$delegates =
            {
                mouseover: Function.createDelegate(cal, cal._cell_onmouseover),
                mouseout: Function.createDelegate(cal, cal._cell_onmouseout),

                click: Function.createDelegate(cal, function (e) {

                    e.stopPropagation();
                    e.preventDefault();

                    if (!cal._enabled) return;

                    var target = e.target;
                    var visibleDate = cal._getEffectiveVisibleDate();
                    Sys.UI.DomElement.removeCssClass(target.parentNode, "ajax__calendar_hover");
                    switch (target.mode) {
                        case "prev":
                        case "next":
                            cal._switchMonth(target.date);
                            break;
                        case "title":
                            switch (cal._mode) {
                                case "days": cal._switchMode("months"); break;
                                case "months": cal._switchMode("years"); break;
                            }
                            break;
                        case "month":
                            //if the mode is month, then stop switching to day mode.
                            if (target.month == visibleDate.getMonth()) {
                                //this._switchMode("days");
                            }
                            else {
                                cal._visibleDate = target.date;
                                //this._switchMode("days");
                            }
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;

                        case "year":
                            if (target.date.getFullYear() == visibleDate.getFullYear()) {
                                cal._switchMode("months");
                            }
                            else {
                                cal._visibleDate = target.date;
                                cal._switchMode("months");
                            }
                            break;

                        case "today":
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;
                    }
                }
                 )
            }
        }
        function onCalendarShown(sender, args) {
            sender._switchMode("months", true);
            changeCellHandlers(cal1);
        }

        function changeCellHandlers(cal) {
            if (cal._monthsBody) {
                //remove the old handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $common.removeHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
                //add the new handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $addHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Petrol/Diesel Month Closing</b>
            <br />
            <span id="lblErrormsg" class="ItDoseLblError"></span>
        </div>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Month Year
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMonthYear" runat="server" ClientIDMode="Static" onchange="chkOpening()" CssClass="requiredField"></asp:TextBox>
                            <cc1:CalendarExtender ID="cal" OnClientShown="onCalendarShown" BehaviorID="calendar1" runat="server" TargetControlID="txtMonthYear" Format="MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlVehicle" onchange="chkOpening()" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Month Opening
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtOpening" readonly="readonly" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Month Closing
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtClosing" maxlength="10" class="requiredField" />
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
                            <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="saveMonthClosing()" />
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
