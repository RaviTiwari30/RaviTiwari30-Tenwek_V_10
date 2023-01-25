<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UcOtschedulingDetails.ascx.cs" Inherits="Design_Controls_UcOtschedulingDetails" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
 
<style type="text/css">
    *[data-tooltip] {
    position: relative;
}

*[data-tooltip]::after {
    content: attr(data-tooltip);

    position:absolute;
    top: -20px;
    
    width: 200px;
    z-index:1000000000;
    pointer-events: none;
    opacity: 0;
    -webkit-transition: opacity .15s ease-in-out;
    -moz-transition: opacity .15s ease-in-out;
    -ms-transition: opacity .15s ease-in-out;
    -o-transition: opacity .15s ease-in-out;
    transition: opacity .15s ease-in-out;

    display: block;
    font-size: 12px;
    line-height: 16px;
    background-color:black;
    color:white;
    padding: 2px 2px;
    border: 1px solid #c0c0c0;   
    margin-left:10px;
    text-align:left;
    white-space: pre-line;
}

*[data-tooltip]:hover::after {
    opacity: 1;
}
</style>
<script type="text/javascript">
    var style = document.createElement('style');
    document.head.appendChild(style);

    var matchingElements = [];
    var allElements = document.getElementsByTagName('*');
    for (var i = 0, n = allElements.length; i < n; i++) {
        var attr = allElements[i].getAttribute('data-tooltip');
        if (attr) {
            allElements[i].addEventListener('mouseover', hoverEvent);
        }
    }

    function hoverEvent(event) {
        event.preventDefault();
        x = event.x - this.offsetLeft;
        y = event.y - this.offsetTop;

        // Make it hang below the cursor a bit.
        y += 10;

        style.innerHTML = '*[data-tooltip]::after { left: ' + x+10 + 'px; top: ' + y + 'px  }'

    }
</script>
<script type="text/javascript">


    /*****Global******/

    var _onOTSlotSelectionDetails = function () {

    }
    var _otSchedulingControlConfigrationDetails = {};

    /*****Global******/




    var _openOTSchedulingDetails = function (option, callback, onSlotSelectDetails) {

        var defaultOption = {
            allowMultipleOTSlotSelection: 0,
            disableDateChange: true,
            scheduleDate: '',
            scheduleDay: '',
            doctorID: '',
            applyExpiredFilter: 0,
            checkedDoctorBookedSlots: 0,
            checkedPatientBookedSlots: 1,
            isDayWiseSelection: 0,
            isForDoctorSlotAllocation: 0,
            filterDoctorSpecifiedSlot: 1,
            selectedSlots: []


        };
        $.extend(defaultOption, option);

        if ($.isFunction(onSlotSelectDetails))
            _onOTSlotSelectionDetails = onSlotSelectDetails;


        if (defaultOption.isDayWiseSelection > 0) {
            var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
            divOTSlotAvailabilityParent.find('.disableDayChange').removeClass('hidden');
            divOTSlotAvailabilityParent.find('.disableDateChange').addClass('hidden');
            divOTSlotAvailabilityParent.find('#ddlSchedulingDay').val(defaultOption.scheduleDay);
        }
        else {
            var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
            divOTSlotAvailabilityParent.find('.disableDayChange').addClass('hidden');
            divOTSlotAvailabilityParent.find('.disableDateChange').removeClass('hidden');
            divOTSlotAvailabilityParent.find('#txtSchedulingDateDetails').val(defaultOption.scheduleDate);
        }



        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
        divOTSlotAvailabilityParent.find('#lblMultiOTSelect').text(defaultOption.allowMultipleOTSlotSelection > 0 ? 1 : 0);

        _otSchedulingControlConfigrationDetails = defaultOption;

        //{
        //    scheduleDate: defaultOption.scheduleDate,
        //    scheduleDay: defaultOption.scheduleDay,
        //    doctorID: defaultOption.doctorID,
        //    applyExpiredFilter: defaultOption.applyExpiredFilter,
        //    checkedDoctorBookedSlots: defaultOption.checkedDoctorBookedSlots,
        //    checkedPatientBookedSlots: defaultOption.checkedPatientBookedSlots,
        //    }


        _getOTSchedulingDetails(_otSchedulingControlConfigrationDetails, function (data) {
            _bindOTSchedulingSlotsDetails(data, function () {
                _openOTSchedulingModalDetails(function (p) {
                    _bindAlreadySelectedSlotsDetails(p, defaultOption.selectedSlots, function () {
                        callback(p);
                    });
                })
            });
        });
    }



    var _onDateDayChangeForOTScheduleDetails = function (callback) {



        var isDayWiseSelection = (_otSchedulingControlConfigrationDetails.isDayWiseSelection);

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
        var scheduleDay = divOTSlotAvailabilityParent.find('#ddlSchedulingDayDetails').val();
        var scheduleDate = divOTSlotAvailabilityParent.find('#txtSchedulingDateDetails').val();
        if (isDayWiseSelection > 0)
            scheduleDate = '';
        else
            scheduleDay = '';

        var _params = jQuery.extend(true, {}, _otSchedulingControlConfigrationDetails);
        _params.scheduleDate = scheduleDate;
        _params.scheduleDay = scheduleDay;

        _getOTSchedulingDetails(_params, function (data) {
            _bindOTSchedulingSlotsDetails(data, function () {
                _bindAlreadySelectedSlotsDetails(divOTSlotAvailabilityParent, _otSchedulingControlConfigrationDetails.selectedSlots, function () {
                    callback(divOTSlotAvailabilityParent);
                });
            });
        });
    }




    var _bindAlreadySelectedSlotsDetails = function (model, data, callback) {
        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
        var scheduleDay = divOTSlotAvailabilityParent.find('#ddlSchedulingDayDetails').val();
        var scheduleDate = divOTSlotAvailabilityParent.find('#txtSchedulingDateDetails').val();

        for (var i = 0; i < data.length; i++) {

            var isOnSameScheduleDayDate = true;

            if (_otSchedulingControlConfigrationDetails.isDayWiseSelection > 0) {
                if (scheduleDay == data[i].scheduleOnText)
                    isOnSameScheduleDayDate = true;
                else
                    isOnSameScheduleDayDate = false;
            }
            else {
                if (scheduleDate == data[i].scheduleOnText)
                    isOnSameScheduleDayDate = true;
                else
                    isOnSameScheduleDayDate = false;
            }

            if (isOnSameScheduleDayDate) {
                model.find('#divSlotAvailabilityBodyDetails').find('[ot=' + data[i].OTID + ']').find('#' + data[i].startSlotUniqueID).click();
                model.find('#divSlotAvailabilityBodyDetails').find('[ot=' + data[i].OTID + ']').find('#' + data[i].endSlotUniqueID).click();
            }
        }
        callback();
    }

    var _getOTSchedulingDetails = function (data, callback) {
        serverCall('../../Design/OT/Services/OT_SchedulingDetails.asmx/GetOTSlots', { _OTSlotCreationParam: data }, function (response) {
            var responseData = JSON.parse(response);
            callback(responseData);
        });
    }


    var _bindOTSchedulingSlotsDetails = function (data, callback) {

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
        var divSlotAvailabilityHeader = divOTSlotAvailabilityParent.find('#divSlotAvailabilityHeaderDetails').html('');
        var divSlotAvailabilityBody = divOTSlotAvailabilityParent.find('#divSlotAvailabilityBodyDetails').html('');
        for (var i = 0; i < data.length; i++) {
            var OTheader = '<div style="" class="col-md-2 textCenter "><b class="">' + data[i].OTName + '</b></div>';
            divSlotAvailabilityHeader.append(OTheader);
            var OTSlots = '';
            for (var j = 0; j < data[i].slots.length; j++) {
                OTSlots += data[i].slots[j].htmlDisplayString;
            }
            var OTAvilableSlots = '<div   OT=' + data[i].OTID + ' OTName="' + data[i].OTName + '" style="padding-left: none;" class="' + i + '_slotParent OTParentDiv ' + (false ? 'col-md-2 textCenter' : 'col-md-2 textCenter') + '">' + OTSlots + '</div>';
            divSlotAvailabilityBody.append(OTAvilableSlots);
        }
        callback();
    }

    var _openOTSchedulingModalDetails = function (callback) {
        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
        divOTSlotAvailabilityParent.showModel();
        callback(divOTSlotAvailabilityParent);
    }


    var onSelectOTSlotDetails = function (elem) {

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');

        var status = $(elem).hasClass("badge-pink");
        var alreadySeletedOT = 0;
        var selectedSlots = divOTSlotAvailabilityParent.find('#divSlotAvailabilityBodyDetails').find('.badge-pink');

        var isMultipleOTAllow = Number(divOTSlotAvailabilityParent.find('#lblMultiOTSelectDetails').text());
        if (isMultipleOTAllow == 0) {
            if (selectedSlots.length > 0) {
                alreadySeletedOT = Number($(selectedSlots[0]).closest("div[class*='_slotParent']").attr('OT'));
                var selectedOT = Number($(elem).closest("div[class*='_slotParent']").attr('OT'));
                if (alreadySeletedOT != selectedOT) {
                    modelAlert('Single  OT Room  at a time.');
                    return false;
                }
            }
        }

        if (status)
            $(elem).removeClass('badge-pink');
        else
            $(elem).addClass('badge-pink');

        var OTParent = $(elem).closest("div[class*='_slotParent']");

        selectedSlots = OTParent.find('.badge-pink');

        if (selectedSlots.length > 0) {
            var startTime = $(selectedSlots[0]).find('#spnSlotTime').text().split('-')[0];
            var endTime = $(selectedSlots[selectedSlots.length - 1]).find('#spnSlotTime').text().split('-')[1];


            var firstSelected = Number($(selectedSlots[0]).attr('id'));
            var lastSelected = Number($(selectedSlots[selectedSlots.length - 1]).attr('id'));

            var isValidSelection = true;

            for (var i = firstSelected + 1; i < lastSelected; i++) {
                var _isValidSelection = $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).hasClass('badge-avilable');

                if (isValidSelection)
                    isValidSelection = _isValidSelection;
            }

            if (!isValidSelection) {
                modelAlert('Invalid Slot Selection !', function () {
                    $(elem).removeClass('badge-pink');
                });
                return false;
            }


            for (var i = firstSelected + 1; i < lastSelected; i++) {
                isValidSelection = $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).hasClass('badge-avilable');

                if (isValidSelection)
                    $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).addClass('badge-pink');
                else
                    break;
            }
        }

    }




    var _onOTSchedulingModalCloseDetails = function () {

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParentDetails');
        var OTParentDiv = divOTSlotAvailabilityParent.find('.OTParentDiv');
         
        divOTSlotAvailabilityParent.closeModel(); 
    }

</script>
<div id="divOTSlotAvailabilityParentDetails" class="modal fade">
    <label id="lblMultiOTSelectDetails" class="hidden">0</label>
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divOTSlotAvailabilityParentDetails" aria-hidden="true">×</button>
                <%--  <b class="modal-title disableDateChange">OT  Slots</b>--%>
                <b class="modal-title disableDateChange hidden">OT Date :</b>
                <asp:TextBox CssClass="disableDateChange hidden" runat="server" onchange="_onDateDayChangeForOTScheduleDetails(function(){});" Style="width: 172px" ClientIDMode="Static" ID="txtSchedulingDateDetails"></asp:TextBox>
                <cc1:CalendarExtender runat="server" ID="calendarExteTxtSchedulingDate" Format="dd-MMM-yyyy" TargetControlID="txtSchedulingDateDetails"></cc1:CalendarExtender>
                <%--                <button class="disableDateChange hidden" style="box-shadow: none;" onclick="onPrevOTScheduling()" type="button">Prev</button>
                    <button class="disableDateChange hidden" style="box-shadow: none;" onclick="onNextOTScheduling()" type="button">Next</button>--%>
                <b class="modal-title disableDayChange">OT Day :</b>
                <select id="ddlSchedulingDayDetails" class="disableDayChange" style="width: 140px" onchange="_onDateDayChangeForOTScheduleDetails(function(){});">
                    <option value="Mon">Mon</option>
                    <option value="Tue">Tue</option>
                    <option value="Wed">Wed</option>
                    <option value="Thu">Thu</option>
                    <option value="Fri">Fri</option>
                    <option value="Sat">Sat</option>
                    <option value="Sun">Sun</option>
                </select>
                <%--<span class="icon icon-color icon-triangle-w"></span>--%>
            </div>
            <div class="modal-body" style="width:100%">
                <div>
                    <div id="divSlotAvailabilityHeaderDetails" class="row">
                    </div>
                    <div id="divSlotAvailabilityBodyDetails" style="width:100%; height: 370px; overflow: auto" class="row">
                    </div>
                </div>
            </div>
            <div class="modal-footer">

                <div class="row" style="font-size:15px;font-weight:bolder;text-align:left;color:red">

                    <span>1:-Please double click on booked slot to reschedule</span> <br />
                    <span>2:-Reschedule Can be done before approved </span><br /><br />
                     
                </div>
                <div class="row">

                <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-avilable"></button>
                <b style="float: left; margin-top: 5px; margin-left: 5px">Available</b>
                <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-yellow"></button>
                <b style="float: left; margin-top: 5px; margin-left: 5px">Booked</b>
                <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-purple"></button>
                <b style="float: left; margin-top: 5px; margin-left: 5px">Approved</b>
                <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-pink"></button>
                <b style="float: left; margin-top: 5px; margin-left: 5px">Selected</b>
                <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-grey"></button>
                <b style="float: left; margin-top: 5px; margin-left: 5px">Expired</b>
                 <button type="button" data-dismiss="divOTSlotAvailabilityParentDetails">Close</button>
                
                </div>
            </div>
        </div>
    </div>
</div>
