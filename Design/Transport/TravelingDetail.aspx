<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="TravelingDetail.aspx.cs" Inherits="Design_Transport_TravelingDetail" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
            chkStatus();
            binPurpose();
            binApprovedBy();
        });
        function binVehicle() {
            var vehicleCon = 0;
            if ($('#rdoIn').is(':checked'))
                vehicleCon = 1;
            $('#lblErrormsg').text('');
            $("#ddlVehicle option").remove();
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindVehicle",
                data: '{Status: "' + vehicleCon + '"}',
                dataType: "json",
                async: false,
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Vehicle = $.parseJSON(response.d);
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
        function binDriver() {
            var driverCon = 0;
            if ($('#rdoIn').is(':checked'))
                driverCon = 1;
            $("#ddlDriver option").remove();
            $('#lblErrormsg').text('');
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindDriver",
                data: '{Status: "' + driverCon + '"}',
                async: false,
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    driver = $.parseJSON(response.d);
                    if (driver != null) {
                        $("#ddlDriver").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < driver.length; i++) {
                            $("#ddlDriver").append($("<option></option>").val(driver[i].Id).html(driver[i].Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function binPurpose() {
            $('#lblErrormsg').text('');
            $("#ddlPurpose").empty();
            $("#ddlPurposeUpdate").empty();
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindPurpose",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    purpose = $.parseJSON(response.d);
                    if (purpose != null) {
                        $("#ddlPurpose").append($("<option></option>").val("0").html("Select"));
                        $("#ddlPurposeUpdate").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < purpose.length; i++) {
                            $("#ddlPurpose").append($("<option></option>").val(purpose[i].Id).html(purpose[i].Purpose));
                            $("#ddlPurposeUpdate").append($("<option></option>").val(purpose[i].Id).html(purpose[i].Purpose));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function binApprovedBy() {
            $('#lblErrormsg').text('');
            $.ajax({
                type: "POST",
                url: "Services/Transport.asmx/bindTravelingApproval",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    approved = $.parseJSON(response.d);
                    if (approved != null) {
                        $("#ddlApprovedBy").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < approved.length; i++) {
                            $("#ddlApprovedBy").append($("<option></option>").val(approved[i].Id).html(approved[i].Name));
                        }
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function chkStatus() {
            if ($('#rdoOut').is(':checked')) {
                $('#txtDepartureTime,#txtDepartureDate,#txtDepartureRemark,#ddlDriver,#txtStanding,#ddlApprovedBy,#ddlPurpose').removeProp('disabled');
                $('#txtArrivalTime,#txtArrivalDate,#txtArrivalRemark,#txtEnding').prop('disabled', 'disabled');
                $('#spnEnding').hide();
                $('#spnStanding').show();
                //////////
                $("#trDeptRqst,#trPatientRqst,#trRqstDate,#divSearchCommand,#divSearchResult,#divRequestDetail").hide();
                $("#divInOutEntry").hide();
                $("#divSearchCriteria").show();
                $("#rblType input[type='radio']").removeAttr("checked");
                $("#lblFor,#rblFor,#lblForColon").show();
                //////////
                binVehicle();
                binDriver();
            }
            else {
                $('#txtDepartureTime,#txtDepartureDate,#txtDepartureRemark,#ddlApprovedBy').prop('disabled', 'disabled');
                $('#txtArrivalTime,#txtArrivalDate,#txtArrivalRemark,#txtEnding,#ddlPurpose').removeProp('disabled');
                $('#spnEnding').show();
                $('#spnStanding').hide();
                //////////
                $("#trDeptRqst,#trPatientRqst,#trRqstDate,#divSearchCommand,#divSearchResult,#divRequestDetail").hide();
                $("#divInOutEntry").show();
                $("#divSearchCriteria").hide();
                $("#rblType input[type='radio']").removeAttr("checked");
                $("#lblFor,#rblFor,#lblForColon").hide();
                //////////
                binVehicle();
                binDriver();

            }
        }
        function saveTravelingDetail() {
            if ($('#rdoOut').is(':checked')) {
                saveDetail();
            }
            else {
                updateTravelingDetail();
            }
        }

        function saveDetail() {
            if (chkCondition() == true) {

                var type = "0";
                if ($("#rblType input[value='1']").is(":checked")) {
                    if ($("#rblType input[type='radio']").val() == "1" && $("#rblType input[type='radio']:checked").val() == "1") {
                        type = $("#rblFor input[type='radio']:checked").val();
                    }
                }
                else if ($("#rblType input[value='2']").is(":checked")) {
                    type = "3";
                }
                else if ($("#rblType input[value='3']").is(":checked")) {
                    type = "4";
                }

                $.ajax({
                    type: "POST",
                    url: "Services/Transport.asmx/saveTravelingDetail",
                    data: '{VehicleID:"' + $.trim($("#ddlVehicle").val()) + '",DriverID:"' + $("#ddlDriver").val() + '",DriverName:"' + $("#ddlDriver option:selected").text() + '",Purpose:"' + $("#ddlPurpose option:selected").val() + '",Opening:"' + $("#txtStanding").val() + '",Closing:"' + $("#txtEnding").val() + '",Place:"' + $("#txtPlace").val() + '",ApprovedBy:"' + $("#ddlApprovedBy option:selected").text() + '",DepartureDate:"' + $("#txtDepartureDate").val() + '", DepartureTime:"' + $("#txtDepartureTime").val() + '",DepartureRemark:"' + $("#txtDepartureRemark").val() + '",Type:"' + type + '",VehicleRequest:"' + $("#lblRequestNo").text() + '",PatientRequest:"' + $("#lblRequestID").text() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        if (response.d == "1") {
                            clearDetail();
                            DisplayMsg('MM01', 'lblErrormsg');
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
        function updateTravelingDetail() {
            if (chkCondition() == true) {
                $.ajax({
                    type: "POST",
                    url: "Services/Transport.asmx/updateTravelingDetail",
                    data: '{VehicleID:"' + $.trim($("#ddlVehicle").val()) + '",DriverID:"' + $("#ddlDriver").val() + '",Opening:"' + $("#txtStanding").val() + '",Closing:"' + $("#txtEnding").val() + '",ApprovedBy:"' + $("#ddlApprovedBy").val() + '",ArrivalDate:"' + $("#txtArrivalDate").val() + '", ArrivalTime:"' + $("#txtArrivalTime").val() + '",ArrivalRemark:"' + $("#txtArrivalRemark").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        if (response.d == "1") {
                            clearDetail();
                            $("#ddlDriver,#txtDepartureDate,#txtDepartureTime").removeProp('disabled');
                            DisplayMsg('MM02', 'lblErrormsg');
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

        function bindDetail() {
            if ($("#rdoIn").is(':checked')) {
                if ($("#ddlVehicle").val() != "0") {
                    $.ajax({
                        type: "POST",
                        url: "Services/Transport.asmx/bindDetail",
                        data: '{VehicleID:"' + $.trim($("#ddlVehicle").val()) + '"}',
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        async: false,
                        success: function (response) {
                            detail = $.parseJSON(response.d);
                            if (detail != null) {
                                $("#ddlDriver").val(detail[0].DriverID).prop('disabled', 'disabled');
                                $("#txtStanding").val(detail[0].Opening).prop('disabled', 'disabled');
                                $("#txtPlace").val(detail[0].PlaceVisited);

                                $("#ddlApprovedBy option:contains(" + detail[0].ApprovedBy + ")").attr('selected', 'selected');

                                $("#txtDepartureDate").val(detail[0].DepartureDate);
                                $("#txtDepartureTime").val(detail[0].DepartureTime);
                                $("#txtDepartureRemark").val(detail[0].DepartureRemark);


                                $("#ddlPurpose").val(detail[0].Purpose);
                                $("#ddlPurpose").attr("disabled", true);

                            }
                            else {
                                $("#txtStanding").val('').prop('disabled', false);
                            }
                        },
                        error: function (xhr, status) {
                            DisplayMsg('MM05', 'lblErrormsg');
                            window.status = status + "\r\n" + xhr.responseText;

                        }

                    });
                }

                else {
                    $("input[type=text],textarea").val('');
                    $("#ddlDriver,#ddlPurpose,#ddlApprovedBy").prop('selectedIndex', 0);
                }
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "Services/Transport.asmx/bindStandingOdometer ",
                    data: '{VehicleID:"' + $.trim($("#ddlVehicle").val()) + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    success: function (response) {
                        if (response.d != "") {
                            $("#txtStanding").val(response.d).prop('disabled', 'disabled');

                        }
                        else {
                            $("#txtStanding").val('').prop('disabled', false);
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'lblErrormsg');
                        window.status = status + "\r\n" + xhr.responseText;

                    }

                });
            }
        }

        function chkCondition() {
            if ($("#ddlVehicle").val() == "0") {
                $("#lblErrormsg").text('Please Select Vehicle');
                $("#ddlVehicle").focus();
                return false;
            }
            if ($("#ddlDriver").val() == "0") {
                $("#lblErrormsg").text('Please Select Driver');
                $("#ddlDriver").focus();
                return false;
            }
            if ($("#ddlPurpose").val() == "0") {
                $("#lblErrormsg").text('Please Select Purpose');
                $("#ddlPurpose").focus();
                return false;
            }

            if ($("#rdoOut").is(':checked')) {

                if ($("#ddlApprovedBy").val() == "0") {
                    $("#lblErrormsg").text('Please Select Approved By');
                    $("#ddlApprovedBy").focus();
                    return false;
                }
                if ($("#txtStanding").val() == "") {
                    $("#lblErrormsg").text('Please Enter Standing Odometer');
                    $("#txtStanding").focus();
                    return false;
                }
                if ($("#txtDepartureDate").val() == "") {
                    $("#lblErrormsg").text('Please Enter Departure Date');
                    $("#txtDepartureDate").focus();
                    return false;

                }
                if ($("#txtDepartureTime").val() == "") {
                    $("#lblErrormsg").text('Please Enter Departure Time');
                    $("#txtDepartureTime").focus();
                    return false;
                }
            }
            else {
                if ($("#txtEnding").val() == "") {
                    $("#lblErrormsg").text('Please Enter Ending Odometer ');
                    $("#txtStanding").focus();
                    return false;
                }
                if ($("#txtArrivalDate").val() == "") {
                    $("#lblErrormsg").text('Please Enter Arrival Date');
                    $("#txtArrivalDate").focus();
                    return false;
                }
                if ($("#txtArrivalTime").val() == "") {
                    $("#lblErrormsg").text('Please Enter Arrival Time');
                    $("#txtArrivalTime").focus();
                    return false;
                }
                if ((parseFloat($("#txtStanding").val())) >= (parseFloat($("#txtEnding").val()))) {
                    $("#lblErrormsg").text('Ending Odometer always greater then Standing Odometer');
                    $("#txtEnding").focus();
                    return false;
                }

                var DepDateTime = moment($("#txtDepartureDate").val() + " " + $("#txtDepartureTime").val(), 'DD-MMM-yyyy HH:mm A');
                var ArrDateTime = moment($("#txtArrivalDate").val() + " " + $("#txtArrivalTime").val(), 'DD-MMM-yyyy HH:mm A');
                var Dep = new Date(DepDateTime.format('MMMM DD,YYYY HH:mm:ss'));
                var Arr = new Date(ArrDateTime.format('MMMM DD,YYYY HH:mm:ss'));

                if (Dep.getTime() >= Arr.getTime()) {
                    $("#lblErrormsg").text('Arrival Time can not be less than from Departure Time!');
                    $("#txtArrivalTime").focus();
                    return false;
                }


            }
            return true;
        }

        function clearDetail() {
            $("#rdoOut").prop('checked', true);
            $("#ddlVehicle,#ddlDriver,#ddlPurpose,#ddlApprovedBy").prop('selectedIndex', 0);
            $("#txtStanding,#txtEnding,#txtPlace,#txtDepartureRemark,#txtArrivalRemark").val('');
            $("#lblRequestID,#lblRequestNo").text("");
            chkStatus();
        }
        $(document).ready(function () {
            $("#txtStanding,#txtEnding").keypress(function (e) {
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

    </script>
    <script type="text/javascript">
        $(document).ready(function () {

            $('#txtArrivalDate').change(function () {
                ChkDate();
            });

        });


        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtDepartureDate').val() + '",DateTo:"' + $('#txtArrivalDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblErrormsg').text('To date can not be less than from date!');
                        $('#btnSave').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblErrormsg').text('');
                        $('#btnSave').removeAttr('disabled');
                    }
                }
            });

        }

        function saveNewPurpose() {

            $("#spnPurpose").text("");
            if ($.trim($("#txtPurpose").val()) == "") {
                $("#spnPurpose").text("Please Enter New Purpose");
                return;
            }

            $.ajax({

                url: "Services/Transport.asmx/savePurpose",
                data: '{Purpose:"' + $.trim($("#txtPurpose").val()) + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == "1") {
                        binPurpose();
                        $("#lblErrormsg").text("Purpose Saved Successfully");
                        closePurpose();
                    }
                    else if (data == "2") {
                        $('#lblErrormsg').text("Purpose Already Exist");
                        closePurpose();
                    }
                    else if (data == "0") {
                        $('#lblErrormsg').text("Error occurred, Please contact administrator");
                        closePurpose();
                    }
                }
            });
        }

        function closePurpose() {
            $find('mpPurpose').hide();
            $("#txtPurpose").val('');
            $("#spnPurpose").text('');
        }
        function cancelPurpose() {
            $("#txtPurpose").val('');
            $("#spnPurpose").text('');
        }

        function closeUpdate() {
            $find('mpeUpdateRqst').hide();
            $("#spnErrorMsg").text("");
            $("#txtCancelReason").val("");
            $("#chkCancelUpdate").attr("checked", false);
        }

        function cancelUpdate() {
            $("#spnErrorMsg").text("");
            $("#txtCancelReason").val("");
            $("#chkCancelUpdate").attr("checked", false);
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            bindDepartment();
            $("#txtPurpose,#txtCancelReason").keypress(function (e) {
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

            $("#rblType input[type='radio']").change(function () {

                $("#lblErrormsg").text("");
                $("#ddlPurpose").attr("disabled", false);

                if ($(this).val() == "1") {
                    $("#trDeptRqst,#trPatientRqst,#trRqstDate,#divSearchCommand,#divSearchResult,#divRequestDetail").hide();
                    $("#divInOutEntry").show();
                    $("#lblFor,#rblFor,#lblForColon").show();
                    $("#rblFor input[value='1']").attr("checked", "checked");

                }
                else if ($(this).val() == "2") {
                    $("#divSearchResult,#divRequestDetail,#trDeptRqst").hide();
                    $("#divInOutEntry").hide();
                    $("#trPatientRqst,#trRqstDate,#divSearchCommand").show();
                    $("#lblFor,#rblFor,#lblForColon").hide();
                }
                else if ($(this).val() == "3") {
                    $("#divSearchResult,#divRequestDetail,#trPatientRqst").hide();
                    $("#divInOutEntry").hide();
                    $("#trDeptRqst,#trRqstDate,#divSearchCommand").show();
                    $("#lblFor,#rblFor,#lblForColon").hide();

                }
            });

            $("#btnSearch").click(function () {

                if ($("#rblType input[value='2']").is(":checked")) {
                    SearchPatientRqst();
                }
                else if ($("#rblType input[value='3']").is(":checked")) {
                    SearchDepartmentRqst();
                }

            });
        });

        function ChkDate1() {

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
                        $('#lblErrormsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblErrormsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }

        function bindDepartment() {
            $("#ddlDepFrom").empty();
            $.ajax({
                url: "../common/CommonService.asmx/bindRoleDepartment",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d != null && result.d != "") {
                        var Dept = $.parseJSON(result.d);
                        $("#ddlDepFrom").append($("<option></option>").val("All").html("All"));
                        for (var i = 0; i < Dept.length; i++) {
                            $("#ddlDepFrom").append($("<option></option>").val(Dept[i].DeptLedgerNo).html(Dept[i].DeptName));
                        }
                    }
                    else {
                        $("#ddlDepFrom").append($("<option></option>").val("All").html("--No Data--"));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function SearchDepartmentRqst() {
            $("#lblErrormsg").text("");
            $("#divSearchResult").empty().hide();
            $("#divInOutEntry,#divRequestDetail").hide();

            $("#btnSearch").val("Searching...");
            $("#btnSearch").attr("disabled", true);
            $.ajax({
                url: "TravelingDetail.aspx/SearchDepartmentRqst",
                data: '{FromDept:"' + $("#ddlDepFrom").val() + '",RequestNo:"' + $.trim($("#txtRequestNo").val()) + '",FromDate:"' + $("#txtFromDate").val() + '",ToDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    VehicleRequest = $.parseJSON(result.d);
                    if (VehicleRequest != null && VehicleRequest != "0") {
                        var HtmlOutput = $("#VehicleRqst").parseTemplate(VehicleRequest);
                        $("#divSearchResult").html(HtmlOutput);
                        $("#divSearchResult").show();
                        $("#btnSearch").val("Search");
                        $("#btnSearch").attr("disabled", false);
                    }
                    else {
                        $("#btnSearch").val("Search");
                        $("#btnSearch").attr("disabled", false);
                        DisplayMsg("MM04", "lblErrormsg");
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "lblErrormsg");
                }
            });
        }

        function SearchPatientRqst() {

            $("#lblErrormsg").text("");
            $("#divSearchResult").empty().hide();
            $("#divInOutEntry,#divRequestDetail").hide();

            $("#btnSearch").val("Searching...");
            $("#btnSearch").attr("disabled", true);
            $.ajax({
                url: "TravelingDetail.aspx/SearchPatientRqst",
                data: '{MRNo:"' + $.trim($("#txtMRNo").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",Name:"' + $.trim($("#txtName").val()) + '",FromDate:"' + $("#txtFromDate").val() + '",ToDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientRequest = $.parseJSON(result.d);
                    if (PatientRequest != null && PatientRequest != "0") {
                        var HtmlOutput = $("#PatientRqst").parseTemplate(PatientRequest);
                        $("#divSearchResult").html(HtmlOutput);
                        $("#divSearchResult").show();
                        $("#btnSearch").val("Search");
                        $("#btnSearch").attr("disabled", false);
                    }
                    else {
                        $("#btnSearch").val("Search");
                        $("#btnSearch").attr("disabled", false);
                        DisplayMsg("MM04", "lblErrormsg");
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "lblErrormsg");
                }

            });
        }

        function SelectRequest(rowID) {

            if ($("#rblType input[value='2']").is(":checked")) {

                $("#lblMRNo").text($(rowID).closest("tr").find("#tdMRNo").text());
                $("#lblName").text($(rowID).closest("tr").find("#tdPName").text());
                $("#lblTransactionNo").text($(rowID).closest("tr").find("#tdIPDNo").text());
                $("#lblPVehicleType").text($(rowID).closest("tr").find("#tdPVehicleType").text());
                $("#lblRequestID").text($(rowID).closest("tr").find("#tdId").text());
                $("#ddlPurpose").val($(rowID).closest("tr").find("#tdPPurposeID").text());
                $("#ddlPurpose").attr("disabled", true);
                $("#divSearchResult,#tblDeptDetails").hide();
                $("#divInOutEntry,#divRequestDetail").show(); lblPVehicleType
            }
            else if ($("#rblType input[value='3']").is(":checked")) {
                $("#lblRequestNo").text($(rowID).closest("tr").find("#tdRequestNo").text());
                $("#lblVehicleType").text($(rowID).closest("tr").find("#tdType").text());
                $("#lblFrom").text($(rowID).closest("tr").find("#tdFromDept").text());
                $("#lblID").text($(rowID).closest("tr").find("#tdID").text());
                $("#ddlPurpose").val($(rowID).closest("tr").find("#tdPurposeID").text());
                $("#ddlPurpose").attr("disabled", true);

                $("#divSearchResult,#tblPatientDetails,#tblPatientDetails1").hide();
                $("#divInOutEntry,#divRequestDetail").show();
            }
        }

        function showUpdatePopup(rowID) {
            var row = $(rowID).closest("tr");
            if ($("#rblType input[value='2']").is(":checked")) {
                $("#lblRqstID").text(row.find("#tdId").text());
                $("#lblType").text("0");
                $("#txtTravelDateUpdate").val(row.find("#tdTravelDateTime").html().split("<br>")[0]);
                $("#ctl00_ContentPlaceHolder1_ucTravelTimeUpdate_txtTime").val(row.find("#tdTravelDateTime").html().split("<br>")[1]);
                $("#ddlPurposeUpdate").val(row.find("#tdPPurposeID").text());
            }
            else if ($("#rblType input[value='3']").is(":checked")) {
                $("#lblRqstID").text(row.find("#tdID").text());
                $("#lblType").text("1");
                $("#txtTravelDateUpdate").val(row.find("#tdTravelDate").text());
                $("#ctl00_ContentPlaceHolder1_ucTravelTimeUpdate_txtTime").val(row.find("#tdTravelTime").text());
                $("#ddlPurposeUpdate").val(row.find("#tdPurposeID").text());
            }
            $find("mpeUpdateRqst").show();
        }

        function UpdateRequest() {

            if ($("#chkCancelUpdate").is(':checked')) {
                if ($("#txtCancelReason").val() == "") {
                    $("#txtCancelReason").focus();
                    $("#spnErrorMsg").text("Please Enter Cancel Reason");
                    return;
                }
            }

            $.ajax({
                url: "Services/Transport.asmx/updateRequest",
                data: '{ID:"' + $.trim($("#lblRqstID").text()) + '",Date:"' + $.trim($("#txtTravelDateUpdate").val()) + '",Time:"' + $.trim($("#ctl00_ContentPlaceHolder1_ucTravelTimeUpdate_txtTime").val()) + '",Purpose:"' + $("#ddlPurposeUpdate").val() + '",Cancel:"' + ($("#chkCancelUpdate").is(':checked') ? 1 : 0) + '",Type:"' + $("#lblType").text() + '",Reason:"' + $("#txtCancelReason").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d == "1") {
                        $("#divSearchResult").empty().hide();
                        $("#divInOutEntry,#divRequestDetail").hide();
                        closeUpdate();
                        DisplayMsg("MM02", "lblErrormsg");
                    }
                    else {
                        $("#btnSearch").val("Search");
                        $("#btnSearch").attr("disabled", false);
                        DisplayMsg("MM04", "lblErrormsg");
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "lblErrormsg");
                }
            });
        }
    </script>
      <div id="body_box_inventory">
          <div style="height:40px;"></div>
        <div  style="text-align: center;">
            <b>LogBook Entry</b><br />
            <span id="lblErrormsg" class="ItDoseLblError"></span>
            <br />
            <input type="radio" id="rdoOut" value="0" name="status" checked="checked" onclick="chkStatus()" />OUT
            <input type="radio" id="rdoIn" value="1" name="status" onclick="chkStatus()" />IN
        </div>
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" id="divSearchCriteria">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-8">
                        </div>
                        <div class="col-md-8">
                            <asp:RadioButtonList ID="rblType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="Direct" Value="1" />
                                <asp:ListItem Text="Patient Request" Value="2" />
                                <asp:ListItem Text="Department Request" Value="3" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-8">
                        </div>
                    </div>
                    <div class="row" id="trPatientRqst">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtMRNo" maxlength="20" title="Enter Patient No" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtIPDNo" maxlength="20" title="Enter IPD No" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtName" maxlength="20" title="Enter Patient Name" />
                        </div>
                    </div>
                    <div class="row" id="trDeptRqst">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle Req. No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtRequestNo" maxlength="20" title="Enter Vehicle Request No" />
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
                                Department From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDepFrom" title="Select From Department"></select>
                        </div>

                    </div>
                    <div class="row" id="trRqstDate">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Travel Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="static" onchange="ChkDate1();" ToolTip="Click to Select From Date" />
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
                                To Travel Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="static" onchange="ChkDate1();" ToolTip="Click to Select To Date" />
                            <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnSearch" class="ItDoseButton" value="Search" />
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div id="divSearchResult" class="POuter_Box_Inventory" style="text-align: center; max-height: 350px; overflow: auto;">
            <div style="text-align: center;">
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divRequestDetail" style="text-align: center;">
            <div class="Purchaseheader">
                Vehicle Request
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" id="tblDeptDetails">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Request No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblRequestNo" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblFrom" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblVehicleType" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />
                            <asp:Label ID="lblID" runat="server" Style="display: none"></asp:Label>
                        </div>
                    </div>
                    <div class="row" id="tblPatientDetails">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblMRNo" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblName" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblTransactionNo" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />
                            <asp:Label ID="lblRequestID" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" Style="display: none;" />
                        </div>
                    </div>
                    <div class="row" id="tblPatientDetails1">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Vehicle Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblPVehicleType" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div id="divInOutEntry">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
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
                                <select id="ddlVehicle" class="requiredField" onchange="bindDetail()"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <span id="lblFor">For</span>
                                </label>
                                <b id="lblForColon" class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rblFor" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                                    <asp:ListItem Text="Patient" Value="1" />
                                    <asp:ListItem Text="Department" Value="2" />
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Driver
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDriver" class="requiredField"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Purpose
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlPurpose" class="requiredField"></select>

                            </div>
                            <div class="col-md-1">
                                <asp:Button ID="btnPurpose" runat="server" CssClass="ItDoseButton" Text="New" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Current Odometer
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtStanding" class="requiredField" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Ending Odometer
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtEnding" class="requiredField" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Place
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtPlace" maxlength="50" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Approved By
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlApprovedBy" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Departure Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtDepartureDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="calDepDate" runat="server" TargetControlID="txtDepartureDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtDepartureTime" AcceptAMPM="True">
                                </cc1:MaskedEditExtender>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtDepartureTime" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtDepartureTime"
                                    ControlExtender="masTime" IsValidEmpty="false"
                                    InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Arrival Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtArrivalDate" runat="server" ClientIDMode="Static" onchange="ChkDate();"></asp:TextBox>
                                <cc1:CalendarExtender ID="calArrDate" runat="server" TargetControlID="txtArrivalDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtArrivalTime" AcceptAMPM="True">
                                </cc1:MaskedEditExtender>
                            </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtArrivalTime" runat="server" ClientIDMode="Static"></asp:TextBox>
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtArrivalTime"
                                    ControlExtender="masTime" IsValidEmpty="false"
                                    InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Departure Remark
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <textarea id="txtDepartureRemark" style="height: 60px"></textarea>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Arrival Remark
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <textarea id="txtArrivalRemark" style="height: 60px"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-10">
                            </div>
                            <div class="col-md-4">
                                <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="saveTravelingDetail()" />
                            </div>
                            <div class="col-md-10">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <cc1:ModalPopupExtender ID="mpPurpose" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnPurposeCancel" DropShadow="true" PopupControlID="pnlPurpopse"
        TargetControlID="btnPurpose" OnCancelScript="cancelPurpose()" BehaviorID="mpPurpose">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlPurpopse" runat="server" CssClass="pnlItemsFilter" Style="display: none" Width="450px">
        <div id="Div3" class="Purchaseheader" runat="server">
            Create New Purpose&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePurpose()" />
                  to close</span></em>
        </div>
        <table style="width: 100%">
            <tr>
                <td style="text-align: center" colspan="2">
                    <span id="spnPurpose" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">&nbsp;Purpose :&nbsp;
                </td>
                <td>
                    <input type="text" id="txtPurpose" maxlength="500" title="Enter Purpose" style="width:300px;"/>
                    <span style="color: red; font-size: 10px;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveNewPurpose();" value="Save" class="ItDoseButton" id="btnPurposeSave" title="Click To Save" />&nbsp;
                    <asp:Button ID="btnPurposeCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>

</div>

        <script type="text/html" id="VehicleRqst">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width:100%;">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">RequestID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">From Department</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Type Of Vehicle</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Requested By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Requested Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Travel Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Travel Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Purpose</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;display:none;">PurposeID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Select</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Edit</th>
            </tr>
            <#
                var dataLength=VehicleRequest.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    objRow=VehicleRequest[j];
            #>
                    <tr>                      
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:center;"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdID"  style="width:100px;text-align:center;display:none;" ><#=objRow.ID#></td>
                        <td class="GridViewLabItemStyle" id="tdRequestNo"  style="width:100px;text-align:center;" ><#=objRow.VehicleRequestID#></td>
					    <td class="GridViewLabItemStyle" id="tdFromDept"  style="width:100px;text-align:center;" ><#=objRow.DeptFrom#></td>
                        <td class="GridViewLabItemStyle" id="tdType" style="width:50px;text-align:center; "><#=objRow.VehicleType#></td>    
					    <td class="GridViewLabItemStyle" id="tdRqstBy" style="width:100px;text-align:center; "><#=objRow.RaisedBy#></td>
					    <td class="GridViewLabItemStyle" id="tdRqstDate" style="width:100px;text-align:center;"><#=objRow.RaisedDate#></td>
					    <td class="GridViewLabItemStyle" id="tdTravelDate" style="width:80px;text-align:center"><#=objRow.TravelDate#></td>
					    <td class="GridViewLabItemStyle" id="tdTravelTime" style="width:80px;text-align:center"><#=objRow.TravelTime#></td>
					    <td class="GridViewLabItemStyle" id="tdPurpose" style="width:150px;text-align:left;"><#=objRow.Purpose#></td>
                        <td class="GridViewLabItemStyle" id="tdPurposeID" style="width:150px;text-align:center;display:none;"><#=objRow.PurposeID#></td>
                        <td class="GridViewLabItemStyle" style="width:60px;text-align:center;">
                            <img id="imgView" src="../../Images/view.GIF" style="cursor:pointer;" title="Click To View" onclick="SelectRequest(this);"/>
                        </td>
                        <td class="GridViewLabItemStyle" style="width:60px;text-align:center;">
                            <img id="img2" src="../../Images/edit.png" style="cursor:pointer;" title="Click To View" onclick="showUpdatePopup(this);"/>
                        </td>                                               
                    </tr>                           
            <#    
                }                
            #>
        </table>
    </script>

    <script type="text/html" id="PatientRqst">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" style="border-collapse: collapse;width:100%;">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">IPD No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">UHID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Patient Name</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Request Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Traveling Date Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Vehicle Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Purpose</th>   
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">Purpose ID</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Select</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 60px;">Edit</th>
            </tr>
            <#
                var dataLength=PatientRequest.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    objRow=PatientRequest[j];
            #>
                    <tr>                      
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:center;"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdId"  style="width:100px;text-align:center;display:none;" ><#=objRow.ID#></td>
                        <td class="GridViewLabItemStyle" id="tdIPDNo" style="width:50px;text-align:center; "><#=objRow.IPDNo#></td>
                        <td class="GridViewLabItemStyle" id="tdMRNo"  style="width:150px;text-align:center;" ><#=objRow.PatientID#></td>
					    <td class="GridViewLabItemStyle" id="tdPName"  style="width:150px;text-align:left;" ><#=objRow.PName#></td>    
					    <td class="GridViewLabItemStyle" id="tdDate" style="width:100px;text-align:center; "><#=objRow.RequestDate#></td>
                        <td class="GridViewLabItemStyle" id="tdTravelDateTime" style="width:100px;text-align:center; "><#=objRow.TravelDate#><br/><#=objRow.TravelTime#></td>
                        <td class="GridViewLabItemStyle" id="tdPVehicleType" style="width:100px;text-align:center; "><#=objRow.VehicleType#></td>
                        <td class="GridViewLabItemStyle" id="tdPPurpose" style="width:150px;text-align:left; "><#=objRow.Purpose#></td>
                        <td class="GridViewLabItemStyle" id="tdPPurposeID" style="width:100px;text-align:center;display:none; "><#=objRow.PurposeID#></td>
                        <td class="GridViewLabItemStyle" style="width:60px;text-align:center;">
                            <img id="img1" src="../../Images/view.GIF" style="cursor:pointer;" title="Click To View" onclick="SelectRequest(this);"/>
                        </td>   
                        <td class="GridViewLabItemStyle" style="width:60px;text-align:center;">
                            <img id="img3" src="../../Images/edit.png" style="cursor:pointer;" title="Click To View" onclick="showUpdatePopup(this);"/>
                        </td>                                             
                    </tr>                           
            <#    
                }                
            #>
        </table>
    </script>    

    <asp:Panel ID="pnlUpdateRqst" runat="server" CssClass="pnlItemsFilter" Style="Width:700px;display:none;">
        <div class="Purchaseheader" runat="server">
            Update Request Detail&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeUpdate()" />
                  to close</span></em>
        </div>
        <table style="width: 100%">
            <tr>
                <td style="text-align: center" colspan="4">
                    <span id="spnErrorMsg" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td>
                    <span id="lblRqstID" style="display:none;"></span>
                    <span id="lblType" style="display:none;"></span>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>            
            <tr>
                <td style="text-align: right;width:15%;">Travel Date&nbsp;:&nbsp;</td>
                <td style="text-align: left;width:30%;">
                      <asp:TextBox ID="txtTravelDateUpdate" runat="server" Width="165px" ToolTip="Click To Select Date" ClientIDMode="Static"/> 
                      <cc1:CalendarExtender ID="calTravelDate" runat="server" TargetControlID="txtTravelDateUpdate" Format="dd-MMM-yyyy" />              
                </td>
                <td style="text-align: right;width:15%;">Travel Date&nbsp;:&nbsp;</td>
                <td style="text-align: left;width:30%;">
                    <uc1:Time runat="server" ID="ucTravelTimeUpdate" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right;width:10%;">Purpose&nbsp;:&nbsp;</td>
                <td style="text-align: left;width:35%;">
                    <select id="ddlPurposeUpdate" title="Select Purpose" style="width: 170px"></select>
                </td>                
            </tr>
            <tr>
                <td style="text-align: right;width:15%;">Cancel&nbsp;:&nbsp;</td>
                <td style="text-align: left;width:30%;">
                    <input type="checkbox" id="chkCancelUpdate" />
                </td>
                <td style="text-align: right;width:10%;">Reason&nbsp:&nbsp;</td>
                <td style="text-align: left;width:35%;">
                    <input type="text" id="txtCancelReason" title="Enter Cancel Reason" maxlength="100" style="width:170px;" />
                </td>
            </tr>
            <tr>
                <td colspan="4" style="text-align: center">
                    <input type="button" onclick="UpdateRequest();" value="Update" class="ItDoseButton" title="Click To Update" />&nbsp;
                    <asp:Button ID="btnUpdateCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Button ID="btnUpdateHide" runat="server" style="display:none;" />
     <cc1:ModalPopupExtender ID="mpeUpdateRqst" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnUpdateCancel" DropShadow="true" PopupControlID="pnlUpdateRqst"
        TargetControlID="btnUpdateHide" OnCancelScript="cancelUpdate()" BehaviorID="mpeUpdateRqst">
    </cc1:ModalPopupExtender>
</asp:Content>
