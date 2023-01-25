<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCOTScheduling.ascx.cs" Inherits="Design_Controls_UCOTScheduling" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>




<script type="text/javascript">


    /*****Global******/

    var _onOTSlotSelection = function () {

    }
    var _otSchedulingControlConfigration = {};

    /*****Global******/




    var _openOTScheduling = function (option, callback, onSlotSelect) {

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

        if ($.isFunction(onSlotSelect))
            _onOTSlotSelection = onSlotSelect;


        if (defaultOption.isDayWiseSelection > 0) {
            var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
            divOTSlotAvailabilityParent.find('.disableDayChange').removeClass('hidden');
            divOTSlotAvailabilityParent.find('.disableDateChange').addClass('hidden');
            divOTSlotAvailabilityParent.find('#ddlSchedulingDay').val(defaultOption.scheduleDay);
        }
        else {
            var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
            divOTSlotAvailabilityParent.find('.disableDayChange').addClass('hidden');
            divOTSlotAvailabilityParent.find('.disableDateChange').removeClass('hidden');
            divOTSlotAvailabilityParent.find('#txtSchedulingDate').val(defaultOption.scheduleDate);
        }



        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
        divOTSlotAvailabilityParent.find('#lblMultiOTSelect').text(defaultOption.allowMultipleOTSlotSelection > 0 ? 1 : 0);

        _otSchedulingControlConfigration = defaultOption;

        //{
        //    scheduleDate: defaultOption.scheduleDate,
        //    scheduleDay: defaultOption.scheduleDay,
        //    doctorID: defaultOption.doctorID,
        //    applyExpiredFilter: defaultOption.applyExpiredFilter,
        //    checkedDoctorBookedSlots: defaultOption.checkedDoctorBookedSlots,
        //    checkedPatientBookedSlots: defaultOption.checkedPatientBookedSlots,
        //    }


        _getOTScheduling(_otSchedulingControlConfigration, function (data) {
            _bindOTSchedulingSlots(data, function () {
                _openOTSchedulingModal(function (p) {
                    _bindAlreadySelectedSlots(p, defaultOption.selectedSlots, function () {
                        callback(p);
                    });
                })
            });
        });
    }



    var _onDateDayChangeForOTSchedule = function (callback) {



        var isDayWiseSelection = (_otSchedulingControlConfigration.isDayWiseSelection);

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
        var scheduleDay = divOTSlotAvailabilityParent.find('#ddlSchedulingDay').val();
        var scheduleDate = divOTSlotAvailabilityParent.find('#txtSchedulingDate').val();
        if (isDayWiseSelection > 0)
            scheduleDate = '';
        else
            scheduleDay = '';

        var _params = jQuery.extend(true, {}, _otSchedulingControlConfigration);
        _params.scheduleDate = scheduleDate;
        _params.scheduleDay = scheduleDay;

        _getOTScheduling(_params, function (data) {
            _bindOTSchedulingSlots(data, function () {
                _bindAlreadySelectedSlots(divOTSlotAvailabilityParent, _otSchedulingControlConfigration.selectedSlots, function () {
                    callback(divOTSlotAvailabilityParent);
                });
            });
        });
    }




    var _bindAlreadySelectedSlots = function (model, data, callback) {
        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
        var scheduleDay = divOTSlotAvailabilityParent.find('#ddlSchedulingDay').val();
        var scheduleDate = divOTSlotAvailabilityParent.find('#txtSchedulingDate').val();

        for (var i = 0; i < data.length; i++) {

            var isOnSameScheduleDayDate = true;

            if (_otSchedulingControlConfigration.isDayWiseSelection > 0) {
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
                model.find('#divSlotAvailabilityBody').find('[ot=' + data[i].OTID + ']').find('#' + data[i].startSlotUniqueID).click();
                model.find('#divSlotAvailabilityBody').find('[ot=' + data[i].OTID + ']').find('#' + data[i].endSlotUniqueID).click();
            }
        }
        callback();
    }

    var _getOTScheduling = function (data, callback) {
        serverCall('../../Design/OT/Services/OT_Scheduling.asmx/GetOTSlots', { _OTSlotCreationParam: data }, function (response) {
            var responseData = JSON.parse(response);
            callback(responseData);
        });
    }


    var _bindOTSchedulingSlots = function (data, callback) {

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
        var divSlotAvailabilityHeader = divOTSlotAvailabilityParent.find('#divSlotAvailabilityHeader').html('');
        var divSlotAvailabilityBody = divOTSlotAvailabilityParent.find('#divSlotAvailabilityBody').html('');
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

    var _openOTSchedulingModal = function (callback) {
        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
        divOTSlotAvailabilityParent.showModel();
        callback(divOTSlotAvailabilityParent);
    }


    var onSelectOTSlot = function (elem) {

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');

        var status = $(elem).hasClass("badge-pink");
        var alreadySeletedOT = 0;
        var selectedSlots = divOTSlotAvailabilityParent.find('#divSlotAvailabilityBody').find('.badge-pink');

        var isMultipleOTAllow = Number(divOTSlotAvailabilityParent.find('#lblMultiOTSelect').text());
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

                if (!isValidSelection) {
                    var _isValidSelection = $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).hasClass('badge-yellow');
                    if (isValidSelection)
                        isValidSelection = _isValidSelection;
                }

            }

            //if (!isValidSelection) {
            //    modelAlert('Invalid Slot Selection !', function () {
            //        $(elem).removeClass('badge-pink');
            //    });
            //    return false;
            //}

            for (var i = firstSelected + 1; i < lastSelected; i++) {
                isValidSelection = $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).hasClass('badge-avilable');

                if (isValidSelection)
                    $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).addClass('badge-pink');
                else {
                    isValidSelection = $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).hasClass('badge-yellow');
                     if (isValidSelection) {                       
                        $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).addClass('badge-pink');
                    }
                    else {
                        break;
                    }


                }



            }
        }

    }




    var _onOTSchedulingModalClose = function () {

        var divOTSlotAvailabilityParent = $('#divOTSlotAvailabilityParent');
        var OTParentDiv = divOTSlotAvailabilityParent.find('.OTParentDiv');

        var scheduleByDay = divOTSlotAvailabilityParent.find('#ddlSchedulingDay').val();
        var scheduleByDate = divOTSlotAvailabilityParent.find('#txtSchedulingDate').val();

        var scheduleOnText = [];

        if (_otSchedulingControlConfigration.isDayWiseSelection > 0)
            scheduleOnText.push(scheduleByDay);
        else
            scheduleOnText.push(scheduleByDate);

        var selectedSlotsData = {};
        selectedSlotsData.slots = [];

        for (var i = 0; i < OTParentDiv.length; i++) {
            var selectedSlots = $(OTParentDiv[i]).find('.badge-pink');
            if (selectedSlots.length > 0) {
                var startTime = $(selectedSlots[0]).find('#spnSlotTime').text().split('-')[0];
                var endTime = $(selectedSlots[selectedSlots.length - 1]).find('#spnSlotTime').text().split('-')[1];

                var startSlotUniqueID = Number($(selectedSlots[0]).attr('ID'));
                var endSlotUniqueID = Number($(selectedSlots[selectedSlots.length - 1]).attr('ID'));

                var OTName = $(OTParentDiv[i]).attr('OTName');
                var OTID = Number($(OTParentDiv[i]).attr('OT'));

                selectedSlotsData.slots.push({
                    id: 0,
                    OTName: OTName,
                    OTID: OTID,
                    startTime: startTime,
                    endTime: endTime,
                    startSlotUniqueID: startSlotUniqueID,
                    endSlotUniqueID: endSlotUniqueID,
                    isDayWiseSelection: _otSchedulingControlConfigration.isDayWiseSelection,
                    scheduleByDay: scheduleByDay,
                    scheduleByDate: scheduleByDate,
                    scheduleOnText: scheduleOnText,
                });
            }
        }
        divOTSlotAvailabilityParent.closeModel();
        debugger;
        _onOTSlotSelection(selectedSlotsData);
        // console.log(selectedSlotsData);
    }

</script>
<div id="divOTSlotAvailabilityParent" class="modal fade">
    <label id="lblMultiOTSelect" class="hidden">0</label>
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divOTSlotAvailabilityParent" aria-hidden="true">×</button>
                <%--  <b class="modal-title disableDateChange">OT  Slots</b>--%>
                <b class="modal-title disableDateChange hidden">OT Date :</b>
                <asp:TextBox CssClass="disableDateChange hidden" runat="server" onchange="_onDateDayChangeForOTSchedule(function(){});" Style="width: 172px" ClientIDMode="Static" ID="txtSchedulingDate"></asp:TextBox>
                <cc1:CalendarExtender runat="server" ID="calendarExteTxtSchedulingDate" Format="dd-MMM-yyyy" TargetControlID="txtSchedulingDate"></cc1:CalendarExtender>
                <%--                <button class="disableDateChange hidden" style="box-shadow: none;" onclick="onPrevOTScheduling()" type="button">Prev</button>
                    <button class="disableDateChange hidden" style="box-shadow: none;" onclick="onNextOTScheduling()" type="button">Next</button>--%>
                <b class="modal-title disableDayChange">OT Day :</b>
                <select id="ddlSchedulingDay" class="disableDayChange" style="width: 140px" onchange="_onDateDayChangeForOTSchedule(function(){});">
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
            <div class="modal-body" style="width: 100%">
                <div>
                    <div id="divSlotAvailabilityHeader" class="row">
                    </div>
                    <div id="divSlotAvailabilityBody" style="width: 100%; height: 370px; overflow: auto" class="row">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
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
                <button onclick="_onOTSchedulingModalClose(this)" type="button">Select</button>
                <button type="button" data-dismiss="divOTSlotAvailabilityParent">Close</button>

            </div>
        </div>
    </div>
</div>
