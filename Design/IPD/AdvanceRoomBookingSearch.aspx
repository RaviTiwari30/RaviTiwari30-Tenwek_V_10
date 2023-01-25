<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AdvanceRoomBookingSearch.aspx.cs" Inherits="Design_IPD_AdvanceRoomBookingSearch" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13)
                    if ($(this).val() != "")
                        $("#btnSearch").click();
            });
            //Bind Controls
            $bindRoomType();
            $("#txtMRNo").focus();

            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });

            $("#btnSearch").click(function () {
                $("#dvSearchResult,#dvBookingDetail").hide();
                $("#lblErrorMsg").text("");
                $("#btnSearch").val("Searching...").attr("disabled", true);
                $.ajax({
                    url: "AdvanceRoomBookingSearch.aspx/SearchAdvanceBooking",
                    data: '{mrNo:"' + $.trim($("#txtMRNo").val()) + '",roomType:"' + $("#ddlRoomType").val() + '",firstName:"' + $.trim($("#txtFirstName").val()) + '",lastName:"' + $.trim($("#txtLastName").val()) + '",fromDate:"' + $.trim($("#txtFromDate").val()) + '",toDate:"' + $.trim($("#txtToDate").val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        advanceBooking = $.parseJSON(result.d);
                        if (advanceBooking != null && result.d != "0") {
                            var htmlOutPut = $("#scrptAdvanceBooking").parseTemplate(advanceBooking);
                            $("#dvBookingDetail").html(htmlOutPut);
                            $("#dvSearchResult,#dvBookingDetail").show();
                        }
                        else {
                            $("#dvSearchResult,#dvBookingDetail").hide();
                            DisplayMsg("MM04", "lblErrorMsg");
                        }
                        $("#btnSearch").val("Search").attr("disabled", false);
                    },
                    error: function (xhr, status) {
                        DisplayMsg("MM05", "lblErrorMsg");
                        $("#btnSearch").val("Search").attr("disabled", false);
                    }
                });
            });
        });

        $bindRoomType = function () {
            $ddlRoomType = $('#ddlRoomType');
            serverCall('Services/IPDAdmission.asmx/bindRoomType', {}, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    $ddlRoomType.bindDropDown({ data: JSON.parse(response), defaultValue: 'All', valueField: 'IPDCaseTypeID', textField: 'Name', isSearchAble: true });
                }
                else {
                    $ddlRoomType.empty();
                }
            });
        };

        $printBookingReport = function (img) {
            serverCall('Services/AdvanceRoomBooking.asmx/RoomBookingPrintOut', { booking_ID: $(img).closest("tr").find("#tdID").text().trim(), userID: $("#lblUserID").text().trim() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    window.open('../../Design/common/Commonreport.aspx');
                }
            });
        }

        function cancelAdvanceBooking(img) {
            var row = $(img).closest("tr");
            $("#spnMRNo").text($(row).find("#tdMRNo").text());
            $("#spnName").text($(row).find("#tdPName").text());
            $("#spnRoomType").text($(row).find("#tdRoomType").text());
            $("#spnRoomNo").text($(row).find("#tdRoomName").text());
            $("#spnBookingDate").text($(row).find("#tdBookingDate").text());
            $("#spnBookingID").text($(row).find("#tdID").text());

            $find("mpCancelBooking").show();
        }
        function RescheduleAdvanceBooking(img) {
            var row = $(img).closest("tr");
            var aa = $(row).find("#tdRoom_ID").text();
            //var IPDCaseTypeID = //tdIPDCaseType_ID
            $bindRoomBed($(row).find("#tdIPDCaseType_ID").text());
            $("#spnRescheduleMRNo").text($(row).find("#tdMRNo").text());
            $("#spnRescheduleName").text($(row).find("#tdPName").text());
            $("#spnRescheduleRoomType").text($(row).find("#tdRoomType").text());
            $("#spnRescheduleRoomNo").text($(row).find("#tdRoomName").text());
            $("#spnRescheduleBookingDate").text($(row).find("#tdBookingDate").text());
            $("#spnRescheduleBookingID").text($(row).find("#tdID").text());
            $('#ddlRoomNo').val($(row).find("#tdRoom_ID").text());
            //
            $find("mpReschedule").show();
        }
        function AdmissionBooking(img) {
            var row = $(img).closest("tr");
            var advanceBookingID=Number($(row).find("#tdID").text());
            var advRoom_ID=$(row).find("#tdRoom_ID").text();
            var advIPDCaseType_ID=$(row).find("#tdIPDCaseType_ID").text();
            var advPatientID = $(row).find("#tdMRNo").text();

            location.href = '../IPD/IPDAdmissionNew.aspx?IsAvailAdvanceRoomBooking=1&advPatientID=' + advPatientID + '&advanceBookingID=' + advanceBookingID + '&advRoom_ID='+ advRoom_ID +'&advIPDCaseType_ID='+ advIPDCaseType_ID;
        }
        

        function cancelBooking() {
            $("#lblErrorMsg,#spnError").text("");

            if ($.trim($("#txtCancelReason").val()) == "") {
                $("#spnError").text("Please Enter Reason of Cancellation");
                $("#txtCancelReason").focus();
                return;
            }

            $.ajax({
                url: "AdvanceRoomBookingSearch.aspx/CancelAdvanceBooking",
                data: '{id:"' + $("#spnBookingID").text() + '",cancelReason:"' + $.trim($("#txtCancelReason").val()) + '",userID:"' + $("#lblUserID").text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d != "0") {
                        DisplayMsg("MM02", "lblErrorMsg");
                        $("#dvBookingDetail").html("");
                        $("#dvSearchResult,#dvBookingDetail").hide();
                    }
                    else {
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                    closeCancelingPopup();
                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "lblErrorMsg");
                }
            });
        }
        function rescheduleBooking() {
            $("#lblErrorMsg,#spnError").text("");

            if ($.trim($("#txtRescheduleReason").val()) == "") {
                $("#spnError").text("Please Enter Reason of Reschedule");
                $("#txtRescheduleReason").focus();
                return;
            }
           
            $.ajax({
                url: "AdvanceRoomBookingSearch.aspx/RescheduleAdvanceBooking",
                data: '{id:"' + $("#spnRescheduleBookingID").text() + '",rescheduleReason:"' + $.trim($("#txtRescheduleReason").val()) + '",userID:"' + $("#lblUserID").text() + '",rescheduleDate:"' + $("#txtRescheduleDate").val() + '",RoomID:"' + $('#ddlRoomNo').val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d != "0") {
                        DisplayMsg("MM02", "lblErrorMsg");
                        $("#dvBookingDetail").html("");
                        $("#dvSearchResult,#dvBookingDetail").hide();
                    }
                    else {
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                    closeReschedulePopup();
                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "lblErrorMsg");
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(document).on("keydown", function (e) {
            if ((e.which == 13) && e.target.id != "btnSearch") {
                e.preventDefault();
            }
        });

        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }

        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpCancelBooking")) {
                    closeCancelingPopup()
                }
            }
        }

        function closeCancelingPopup() {
            $("#spnError").text("");
            $("#txtCancelReason").val("");
            $find("mpCancelBooking").hide();
        }
        function closeReschedulePopup() {
            $("#spnError").text("");
            $("#txtRescheduleReason").val("");
            $find("mpReschedule").hide();
        }
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblErrorMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblErrorMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }

        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                return false;
            else
                return true;
        }



        var getAdvancePayment = function (el) {
            var data = JSON.parse($(el).closest('tr').find('.tdData').text());
            var $responseData = {
                booking_ID: data.ID,
                patientID: data.PatientID,
            };

            location.href = '../OPD/OPDAdvance.aspx?IsAdvanceRoomBookingAmountUpdate=1&PatientID=' + $responseData.patientID + '&AdvanceBookingId=' + $responseData.booking_ID;
        }
        var $bindRoomBed = function (roomType) {
            $ddlRoomNo = $('#ddlRoomNo');
            serverCall('Services/IPDAdmission.asmx/bindRoomBed', { caseType: roomType, IsDisIntimated: '0', type: 1, bookingDate: $('#spnRescheduleBookingDate').text().trim() }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    $ddlRoomNo.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'RoomId', textField: 'Name' });
                }
                else {
                    $ddlRoomNo.empty();
                }
            });
        };
    </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="sc" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <strong>Advance Room Booking Search</strong>
            <br />            
            <asp:Label ID="lblErrorMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            <asp:Label ID="lblUserID" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" Style="display: none;" />
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
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtMRNo" data-title="Enter UHID" maxlength="20" autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">First Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtFirstName" data-title="Enter First Name" autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Last Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtLastName" data-title="Enter Last Name" autocomplete="off" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Room Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlRoomType" title="Select Room Type" class="searchable"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSearch" value="Search" class="ItDoseButton" title="Click To Search" />
            <input type="button" id="btnReport" value="Report" class="ItDoseButton" style="display: none;" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2" style="text-align: center;"></div>
                <div class="col-md-4" style="text-align: center">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('Confirmed',function(){})" class="circle badge-avilable"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Booking Confirm</b>
                </div>
                <div class="col-md-4" style="text-align: center;">
                    <div class="pull-right">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('Cancel',function(){})" class="circle badge-warning"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Booking Cancel</b>
                    </div>
                </div>   
                   <div class="col-md-4" style="text-align: center;">
                    <div class="pull-right">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('Expired',function(){})" class="circle badge-grey"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Expired Booking</b>
                    </div>
                </div> 
                   <div class="col-md-4" style="text-align: center;">
                    <div class="pull-right">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('Rescheduled',function(){})" class="circle badge-info"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Rescheduled Booking</b>
                    </div>
                </div> 
                   <div class="col-md-4" style="text-align: center;">
                    <div class="pull-right">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left" onclick="labelSearch('Admission',function(){})" class="circle badge-purple"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Admission Done</b>
                    </div>
                </div>              
                <div class="col-md-2" style="text-align: center;"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvSearchResult" style="display: none;">
            <div class="Purchaseheader">
                Advance Room Booking Details
            </div>
       
                <div id="dvBookingDetail" style="overflow: auto;" >
                </div>
           
        </div>
    </div>    

    <asp:Panel ID="pnlCancelBooking" runat="server" Style="display: none;">
        <div style="margin: 0px; background-color: #eaf3fd; border: solid 1px Green; display: inline-block; padding: 1px 1px 1px 1px; margin: 0px 10px 3px 10px; width: 600px;">
            <div class="Purchaseheader">
                <table width="590">
                    <tr>
                        <td style="text-align: left;">
                            <b>Cancel Advance Room Booking</b>
                        </td>
                        <td style="text-align: right;">
                            <em><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeCancelingPopup()" />to close</span></em>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 595px;">
                <span id="spnError" class="ItDoseLblError"></span>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%; text-align: right;">UHID :&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnMRNo" class="ItDoseLabelBl"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Name :&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnName" class="ItDoseLabelBl"></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Room Type :&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnRoomType" class="ItDoseLabelBl"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Booking Date:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnBookingDate" class="ItDoseLabelBl"></span>
                            <span id="spnBookingID" style="display: none;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Room Name. :&nbsp</td>
                        <td style="width: 20%; text-align: left;" colspan="3">
                            <span id="spnRoomNo" class="ItDoseLabelBl"></span>
                        </td>
                    </tr>
                </table>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 593px;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 40%; text-align: right;">Cancel Reason :&nbsp</td>
                            <td style="width: 60%; text-align: left;">
                                <textarea id="txtCancelReason" title="Enter Purposencel Reason" style="height: 50px; width: 300px;" maxlength="200" class="requiredField" onkeypress="return check(this,event)"></textarea>
                              
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 595px;">
                <input type="button" id="btnSave" value="Save" onclick="cancelBooking();" class="ItDoseButton" />&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" />
            </div>
        </div>
    </asp:Panel>
    <asp:Button ID="btnHide" runat="server" Style="display: none;" />
    <cc1:ModalPopupExtender ID="mpCancelBooking" BehaviorID="mpCancelBooking" runat="server" DropShadow="true" TargetControlID="btnHide" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlCancelBooking" RepositionMode="RepositionOnWindowResize" CancelControlID="btnCancel" OnCancelScript="closeCancelingPopup()">
    </cc1:ModalPopupExtender>

      <asp:Panel ID="pnlReschedule" runat="server" Style="display: none;">
        <div style="margin: 0px; background-color: #eaf3fd; border: solid 1px Green; display: inline-block; padding: 1px 1px 1px 1px; margin: 0px 10px 3px 10px; width: 600px;">
            <div class="Purchaseheader">
                <table width="590">
                    <tr>
                        <td style="text-align: left;">
                            <b>Reschedule Advance Room Booking</b>
                        </td>
                        <td style="text-align: right;">
                            <em><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeReschedulePopup()" />to close</span></em>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 595px;">
                <span id="Span1" class="ItDoseLblError"></span>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%; text-align: right;">UHID :&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnRescheduleMRNo" class="ItDoseLabelBl"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Name :&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnRescheduleName" class="ItDoseLabelBl"></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Room Type :&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnRescheduleRoomType" class="ItDoseLabelBl"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Booking Date:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnRescheduleBookingDate" class="ItDoseLabelBl"></span>
                            <span id="spnRescheduleBookingID" style="display: none;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Room Name. :&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <select id="ddlRoomNo"></select>
                            <span id="spnRescheduleRoomNo" style="display:none" class="ItDoseLabelBl"></span>
                        </td>
                          <td style="width: 20%; text-align: right;">Reschedule Date:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                          <asp:TextBox ID="txtRescheduleDate" runat="server" CssClass="requiredField" ClientIDMode="Static" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="cdRescheduleDate" runat="server" TargetControlID="txtRescheduleDate" Format="dd-MMM-yyyy" />
                        </td>
                    </tr>
                </table>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 593px;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 40%; text-align: right;">Reschedule Reason :&nbsp</td>
                            <td style="width: 60%; text-align: left;">
                                <textarea id="txtRescheduleReason" title="Enter Purpose od Reschedule Reason" style="height: 50px; width: 300px;" maxlength="200" class="requiredField" onkeypress="return check(this,event)"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 595px;">
                <input type="button" id="btnReschedule" value="Save" onclick="rescheduleBooking();" class="ItDoseButton" />&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnCancelReschedule" runat="server" Text="Cancel" CssClass="ItDoseButton" />
            </div>
        </div>
    </asp:Panel>
    <asp:Button ID="btnreschedulehide" runat="server" Style="display: none;" />
    <cc1:ModalPopupExtender ID="mpReschedule" BehaviorID="mpReschedule" runat="server" DropShadow="true" TargetControlID="btnreschedulehide" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlReschedule" RepositionMode="RepositionOnWindowResize" CancelControlID="btnCancelReschedule" OnCancelScript="closeReschedulePopup()">
    </cc1:ModalPopupExtender>

    <script type="text/html" id="scrptAdvanceBooking">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:200%" >
		    <tr id="tdHeader"> 
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Cancel</th>                   
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Reschedule</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Admission</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Print</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:102px">Get Payment</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">#</th>                
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Age/Gender</th>
                <th class="GridViewHeaderStyle" scope="col" >Contact No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Booking Date</th> 
                <th class="GridViewHeaderStyle" scope="col" >Room Type</th>
                <th class="GridViewHeaderStyle" scope="col" >Room Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Entry By</th>
                <th class="GridViewHeaderStyle" scope="col" >Entry Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Advance Amount</th>
                <th class="GridViewHeaderStyle" scope="col" >Receipt No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Cancel Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Cancel By</th>
                <th class="GridViewHeaderStyle" scope="col" >Cancel Reason</th>
                <th class="GridViewHeaderStyle" scope="col" >Remarks</th> 
                
                <th class="GridViewHeaderStyle" scope="col" >Rescheduled Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Rescheduled By</th>
                <th class="GridViewHeaderStyle" scope="col" >Rescheduled Reason</th>
                <th class="GridViewHeaderStyle" scope="col" >Admitted Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Admitted By</th>
                <th class="GridViewHeaderStyle" scope="col">IPD No.</th> 
                                              		    
                <th class="GridViewHeaderStyle" scope="col" style="display:none;">ID</th>        
                <th class="GridViewHeaderStyle" scope="col" style="display:none;">Room_ID</th>   
                <th class="GridViewHeaderStyle" scope="col" style="display:none;">IPDCaseType_ID</th>   

             </tr>
            <#       
		    var dataLength=advanceBooking.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow; 
            var strStyle="";            
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = advanceBooking[j];
                strStyle="badge-avilable";   
                if(objRow.IsCancel=="1")
                    strStyle="badge-warning"; 
               else if(objRow.IsAdmitted=="1")
                    strStyle="badge-purple"; 
                else if(objRow.IsExpired=="1")
                    strStyle="badge-grey"; 
                else if(objRow.IsRescheduled=="1")
                    strStyle="badge-info"; 
                      
		    #>
            <tr id="tdRow_<#=(j+1)#>" class="<#=strStyle#>">                
                <td class="GridViewLabItemStyle" id="tdCancel" style="width:30px;text-align:center;">
                    <#if(objRow.IsAdmitted=="0" && objRow.IsExpired=="0" && objRow.IsCancel=="0"){#>
                        <img id="imgCancel" src="../../Images/Delete.gif" style="cursor:pointer;" title="Click To Cancel Advance Booking" onclick="cancelAdvanceBooking(this);"/>
                    <#}#>
                </td> 
                  <td class="GridViewLabItemStyle" id="tdReschedule" style="width:50px;text-align:center;">
                    <#if(objRow.IsAdmitted=="0" && objRow.IsExpired=="0" && objRow.IsCancel=="0"){#>
                        <img id="imgreschedule" src="../../Images/edit.png" style="cursor:pointer;" title="Click To Reschedule Advance Booking" onclick="RescheduleAdvanceBooking(this);"/>
                    <#}#>
                </td> 
                  <td class="GridViewLabItemStyle" id="tdAdmission" style="width:50px;text-align:center;">
                    <#if(objRow.IsAdmitted=="0" && objRow.IsExpired=="0" && objRow.IsCancel=="0"){#>
                        <img id="imgAdmition" src="../../Images/Post.gif" style="cursor:pointer;" title="Click To Avail Advance Booking" onclick="AdmissionBooking(this);"/>
                    <#}#>
                </td>
                <td class="GridViewLabItemStyle" id="td1" style="width:30px;text-align:center;">
                    <#if(objRow.IsCancel=="0"){#>
                        <img id="img1" src="../../Images/print.gif" style="cursor:pointer;" title="Click To Print" onclick="$printBookingReport(this);"/>
                    <#}#>
                </td>
                 <td class="GridViewLabItemStyle" id="td2" style="width:50px;text-align:center;">
                    <#if(objRow.IsAdmitted=="0" && objRow.IsExpired=="0" && objRow.IsCancel=="0"){#>
                        <img id="img2" src="../../Images/Post.gif" style="cursor:pointer;" title="Click To Avail Advance Booking." onclick="getAdvancePayment(this);"/>
                    <#}#>
                </td>


                <td class="GridViewLabItemStyle" style="width:20px;text-align:center;" ><#=(j+1)#></td>                                      
                <td class="GridViewLabItemStyle" id="tdMRNo" style="text-align:left;"><#=objRow.PatientID#></td>    
				<td class="GridViewLabItemStyle" id="tdPName" style="text-align:left;"><#=objRow.PName#></td>
				<td class="GridViewLabItemStyle" id="tdAge" style="text-align:center;"><#=objRow.Age#>/<#=objRow.Gender#></td>  
                <td class="GridViewLabItemStyle" id="tdMobile" style="text-align:center;"><#=objRow.Mobile#></td>
                <td class="GridViewLabItemStyle" id="tdBookingDate" style="text-align:center;"><#=objRow.BookingDate#></td>  
                <td class="GridViewLabItemStyle" id="tdRoomType" ><#=objRow.RoomType#></td>
                <td class="GridViewLabItemStyle" id="tdRoomName" ><#=objRow.RoomName#></td> 
                <td class="GridViewLabItemStyle" id="tdEntryBy" ><#=objRow.EntryBy#></td>
                <td class="GridViewLabItemStyle" id="tdEntryDate" style="text-align:center;"><#=objRow.EntryDate#></td> 
                <td class="GridViewLabItemStyle" id="tdPatientAdvance" ><#=objRow.PatientAdvance#></td>
                <td class="GridViewLabItemStyle" id="tdReceiptNo" style="text-align:center;"><#=objRow.ReceiptNo#></td> 
                <td class="GridViewLabItemStyle" id="tdCanceledDate" ><#=objRow.CancelDate#></td>
                <td class="GridViewLabItemStyle" id="tdCancelBy" ><#=objRow.CancelBy#></td>
                <td class="GridViewLabItemStyle" id="tdCancelReason" ><#=objRow.CancelReason#></td>
                <td class="GridViewLabItemStyle" id="tdRemarks"><#=objRow.Remarks#></td> 
                <td class="GridViewLabItemStyle" id="tdRescheduledDateTime" ><#=objRow.RescheduledDateTime#></td>
                <td class="GridViewLabItemStyle" id="tdRescheduledBy" style="text-align:center;"><#=objRow.RescheduledBy#></td> 
                <td class="GridViewLabItemStyle" id="tdRescheduledReason" ><#=objRow.RescheduledReason#></td>
                <td class="GridViewLabItemStyle" id="tdAdmittedDateTime" ><#=objRow.AdmittedDateTime#></td>
                <td class="GridViewLabItemStyle" id="tdAdmittedBy" ><#=objRow.AdmittedBy#></td>
                <td class="GridViewLabItemStyle" id="tdTransactionID" style="text-align:center;"><#=objRow.TransactionID#></td> 
                <td class="GridViewLabItemStyle" id="tdID" style="width:10px;display:none;"><#=objRow.ID#></td>  
                <td class="GridViewLabItemStyle" id="tdRoom_ID" style="width:10px;display:none;"><#=objRow.Room_ID#></td>
                <td class="GridViewLabItemStyle" id="tdIPDCaseType_ID" style="width:10px;display:none;"><#=objRow.IPDCaseType_ID#></td>
                <td class="GridViewLabItemStyle tdData" style="display:none"><#=JSON.stringify(objRow) #></td>                             
            </tr>              
		    <#}        
		    #>                    
        </table>
    </script>
</asp:Content>

