<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OTBooking.aspx.cs" Inherits="Design_OT_OTBooking" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCOTScheduling.ascx" TagName="OTSchedulingControl" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UcOtschedulingDetails.ascx" TagName="OTSchedulingDetailsControl" TagPrefix="UC2" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style type="text/css">
        .rescheduledBooking {
            background-color: yellow !important;
        }

        .canceledBooking {
            background-color: pink !important;
        }

        .confirmedBooking {
            background-color: green !important;
        }
    </style>


    <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>


    <script type="text/javascript">


        $(document).ready(function () {
            ShowHideOtherSurgeryTextBox();
            var patientType = Number(2);
            switchPatientTypeCategory(patientType, function () {

            });
            bindSurgeryDoctor('All', function () {
                bindAllSurgery(function () {

                });
            });
        })



        var onPatientTypeChangeForSurgery = function (el) {
            var patientType = Number(el.value);
            switchPatientTypeCategory(patientType, function () {

            });
        }


        var switchPatientTypeCategory = function (patientType, callback) {
            var divGeneralPatientDetails = $('.divGeneralPatientDetails');
            var divRegisteredPatientDetails = $('.divRegisteredPatientDetails');
            divGeneralPatientDetails.find('input[type=text]').val('');
            divRegisteredPatientDetails.find('.lblRegisteredPatientDetails').text('');
            if (patientType == 1) {
                divGeneralPatientDetails.removeClass('hidden');
                divRegisteredPatientDetails.addClass('hidden');
                $('#lblIsRegistredPatient').text('0');
            }
            else {
                divRegisteredPatientDetails.removeClass('hidden');
                divGeneralPatientDetails.addClass('hidden');
                $('#lblIsRegistredPatient').text('1');
            }
            $('#divOTSlotList ul li').remove();
            $('#ddlSurgeryDoctor,#ddlSurgery').removeAttr('disabled').val('0').trigger("chosen:updated");
            $('#lblBookingID').text(0);
            $('#lblIsBookingReschedule').text('0');
            callback();
        }







        var openOTScheduling = function () {
            var doctorID = $('#ddlSurgeryDoctor').val();

            if (doctorID == '0') {
                modelAlert('Please Select Doctor First.');
                return false;
            }

            doctorID = doctorID == '0' ? '' : doctorID;

            var isDayWiseSelection = 0;
            var scheduleDate = $('#txtSurgeryDate').val();
            var scheduleDay = '';
            getAllocatedSlotDetails(function (selectedSlots) {
                var alreadySelectedSlots = selectedSlots.slotLists.filter(function (s) { return s.id == 0 });
                var isDoctorLogin = Number('<%=Util.GetInt(ViewState["IsDoctorLogin"]) %>');
                //isDoctorLogin = 1;
                _openOTScheduling({
                    allowMultipleOTSlotSelection: 0,
                    checkedDoctorBookedSlots: 0,
                    checkedPatientBookedSlots: 1,
                    doctorID: doctorID,
                    selectedSlots: alreadySelectedSlots,
                    isDayWiseSelection: isDayWiseSelection,
                    scheduleDate: scheduleDate,
                    scheduleDay: scheduleDay,
                    applyExpiredFilter: isDayWiseSelection > 0 ? 0 : 1,
                    isForDoctorSlotAllocation: 0,
                    filterDoctorSpecifiedSlot: (isDoctorLogin > 0 ? 1 : 0)
                }, function () {


                }, onSlotSelection);
            });
        }



        var onSlotSelection = function (data) {


            if (data.slots.length == 0)
                return false;

            var scheduleOnText = [];
            var divOTSlotList = $('#divOTSlotList')
            divOTSlotList.find('li').remove();

            var bookingID = Number($('#lblBookingID').text());
            if (bookingID > 0)
                $('#lblIsBookingReschedule').text(1);
            else
                $('#lblIsBookingReschedule').text(0);



            for (var i = 0; i < data.slots.length; i++) {
                data.slots[i].isDayWiseSelection = data.slots[i].isDayWiseSelection;

                scheduleOnText = data.slots[i].scheduleOnText;
                for (var j = 0; j < scheduleOnText.length; j++) {
                    data.slots[i].scheduleOnText = scheduleOnText[j];
                    addOTSlotLists({ data: data.slots[i], value: 0, text: data.slots[i].OTName + ' : ' + data.slots[i].startTime + ' - ' + data.slots[i].endTime + ' ' + 'On ' + scheduleOnText[j] })
                }
            }
        }


        var addOTSlotLists = function (data) {

            var divOTSlotList = $('#divOTSlotList');
            divOTSlotList.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a><span class="hidden tdData">' + JSON.stringify(data.data) + '</span></li>');

        }


        var getAllocatedSlotDetails = function (callback) {

            var doctorID = $('#ddlSurgeryDoctor').val();

            if (doctorID == '0') {
                modelAlert('Please Select Doctor First.');
                return false;
            }


            var data = {
                doctorID: doctorID,
                slotLists: []
            };
            $('#divOTSlotList ul li .tdData').each(function () {
                var tdData = JSON.parse($(this).text());
                data.slotLists.push({
                    OTID: tdData.OTID,
                    startTime: tdData.startTime,
                    endTime: tdData.endTime,
                    id: tdData.id,
                    startSlotUniqueID: tdData.startSlotUniqueID,
                    endSlotUniqueID: tdData.endSlotUniqueID,
                    isDayWiseSelection: tdData.isDayWiseSelection,
                    scheduleOnText: tdData.scheduleOnText,
                });

            });

            callback(data);
        }





        var bindSurgeryDoctor = function (department, callBack) {
            var ddlSurgeryDoctor = $('#ddlSurgeryDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                ddlSurgeryDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callBack(true);
            });
        }



        var bindAllSurgery = function (callBack) {
            serverCall('OTBooking.aspx/GetAllSurgery', {}, function (response) {
                ddlSurgery = $('#ddlSurgery');
                ddlSurgery.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Surgery_ID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                callBack(true);
            });
        }





        var getBookingDetails = function (callback) {
            $getAddedSurgery(function (surgeryList) {
                var isRegistredPatient = Number($('#lblIsRegistredPatient').text());
                var divRegisteredPatientDetails = $('.divRegisteredPatientDetails');
                var divGeneralPatientDetails = $('.divGeneralPatientDetails');
                var booking = { otNumber: '', patientID: '', patientName: '', age: '', gender: '', address: '', contactNo: '', doctorID: '', surgeryID: '', OTID: '', surgeryDate: '', slotFromTime: '', slotToTime: '', outPatientID: '' };
                if (isRegistredPatient > 0) {
                    booking.patientID = $.trim(divRegisteredPatientDetails.find('#lblPatientID').text());
                    booking.patientName = $.trim(divRegisteredPatientDetails.find('#lblPatientName').text());
                    booking.age = $.trim(divRegisteredPatientDetails.find('#lblAge').text());
                    booking.gender = $.trim(divRegisteredPatientDetails.find('#lblGender').text());
                    booking.address = $.trim(divRegisteredPatientDetails.find('#lblAddress').text());
                    booking.contactNo = $.trim(divRegisteredPatientDetails.find('#lblContactNo').text());
                }
                else {
                    booking.patientID = '';
                    booking.patientName = $.trim(divGeneralPatientDetails.find('#txtPatientName').val());
                    booking.age = $.trim(divGeneralPatientDetails.find('#txtAge').val()) + ' ' + $.trim(divGeneralPatientDetails.find('#ddlAgeIn').val());
                    booking.gender = $.trim(divGeneralPatientDetails.find('input[type=radio][name=sex]:checked').val());
                    booking.address = $.trim(divGeneralPatientDetails.find('#txtAddress').val());
                    booking.contactNo = $.trim(divGeneralPatientDetails.find('#txtPhoneNumber').val());
                }
                booking.doctorID = $.trim($('#ddlSurgeryDoctor').val());

                booking.surgeryID = $.trim($('#ddlSurgery').val());
                booking.SurgeryName = $.trim($("#ddlSurgery option:selected").text());
                booking.SurgeryNameForOther = $.trim($('#txtOtherSurgeryName').val());

                var selectedSlots = $('#divOTSlotList li');

                if (booking.surgeryID == '<%=Resources.Resource.OtherSurgeryId%>') {

                    if (booking.SurgeryNameForOther == "" || booking.SurgeryNameForOther == null || booking.SurgeryNameForOther == undefined) {
                        modelAlert('Please Enter Surgery Name For Other', function () {

                        });
                        return false;
                    }

                }


                if (selectedSlots.length < 1) {
                    modelAlert('Please Select OT Slot.', function () {

                    });
                    return false;
                }


                if (String.isNullOrEmpty(booking.patientName)) {
                    modelAlert((isRegistredPatient > 0 ? 'Please Select Patient Name.' : 'Please Enter Patient Name.'), function () {

                    });
                    return false;
                }

                if (String.isNullOrEmpty(booking.age)) {
                    modelAlert('Please Enter Patient Age.', function () {

                    });
                    return false;
                }


                if ((booking.surgeryID) == '0') {
                    modelAlert('Please Select Surgery.', function () {
                        $('#ddlSurgery').focus();
                    });
                    return false;
                }



                var slotDetails = JSON.parse(selectedSlots.find('.tdData').text());
                booking.OTID = slotDetails.OTID,
                booking.surgeryDate = slotDetails.scheduleByDate;
                booking.slotFromTime = slotDetails.startTime;
                booking.slotToTime = slotDetails.endTime;
                booking.outPatientID = '';
                booking.otNumber = '';



                callback(booking, surgeryList);
            });
            }


            var _saveBooking = function (btnSave) {

                var isBookingReschedule = Number($('#lblIsBookingReschedule').text());
                var bookingID = Number($('#lblBookingID').text());
                if (isBookingReschedule > 0) {
                    var divBookingRescheduleModel = $('#divBookingRescheduleModel');
                    divBookingRescheduleModel.showModel();
                    divBookingRescheduleModel.find('textarea').val('').focus();
                }
                else
                    save(btnSave, bookingID, '');
            }
        


        var confirmBooking = function (el) {
            var tdData = JSON.parse($(el).closest('tr').find('.tdData').text());

            validateExpiredBooking({ bookingID: tdData.bookingID }, function () {
                getAdmittedPatient({ patientID: tdData.PatientID }, function () {

                    var params = {
                        scheduleDate: tdData.SurgeryDate,
                        startTime: tdData.SlotFromTime,
                        endTime: tdData.SlotToTime,
                    };
                    getEquipments(params, function (response) {
                        var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
                        divBookingConfirmationDetails.find('#ddlIPDPatient').val('0');
                        divBookingConfirmationDetails.find('#divEquipmentDetails ul li').remove();
                        onAdmitPatientSelect(divBookingConfirmationDetails.find('#ddlIPDPatient')[0], function () {

                            divBookingConfirmationDetails.find('.lblOTNumber').text(tdData.OTNumber);
                            divBookingConfirmationDetails.find('.lblBookingConfirmationData').text(JSON.stringify(tdData));
                            divBookingConfirmationDetails.showModel();
                        });
                    });
                });
            });
        }

        var validateExpiredBooking = function (data, callback) {
            serverCall('Services/OTBooking.asmx/ValidateExpiredBooking', data, function (response) {
                //var responseData = JSON.parse(response);
                //if (responseData.status)
                //    callback()
                //else
                //    modelAlert(responseData.response, function () {

                //    });
                callback();
            });
        }


        var _confirmBooking = function (btnSave) {
            debugger;
            getSelectedEquipmentDetails(function (e) {
                var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');

                var selectedPatientIPDNo = divBookingConfirmationDetails.find('#ddlIPDPatient').val();
                //if (selectedPatientIPDNo == '0') {
                //    modelAlert('Please Select Admitted Patient.', function () {
                //        divBookingConfirmationDetails.find('#ddlIPDPatient').focus();
                //    });

                //    return false;
                //}


                var bookingData = JSON.parse(divBookingConfirmationDetails.find('.lblBookingConfirmationData').text());
                var patientDetails = JSON.parse(divBookingConfirmationDetails.find('.lblIPDPatientDetailsData').text());

                var data = {
                    bookingID: bookingData.bookingID,
                    remark: '',
                    patientID: bookingData.PatientID,
                    transactionID: '',// patientDetails.TransactionID,
                    equipmentDetails: e
                }
                $(btnSave).attr('disabled', true).text('Submitting...');
                serverCall('Services/OTBooking.asmx/ConfirmBooking', data, function (response) {
                    var responseData = JSON.parse(response);
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            window.location.reload();
                        }
                        else
                            $(btnSave).removeAttr('disabled').text('Save');
                    });
                });
            });
        }



        var getSelectedEquipmentDetails = function (callback) {

            var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
            var selectedEquipments = divBookingConfirmationDetails.find('#divEquipmentDetails ul li');

            //if ($('#ddlEquipment').val() > 0) {
            //    modelAlert('Please Add The Equipment.', function () {

            //    });
            //    return false;
            //}

            var equipmentDetails = [];
            for (var i = 0; i < selectedEquipments.length; i++) {
                var equipmentData = JSON.parse($(selectedEquipments[i]).find('.tdData').text());

                equipmentDetails.push({
                    equipmentName: equipmentData.equipmentName,
                    quantity: equipmentData.quantity,
                    equipmentID: equipmentData.value
                });
            }

            callback(equipmentDetails);
        }




        var getEquipments = function (data, callback) {
            serverCall('Services/OTBooking.asmx/getEquipments', data, function (response) {
                var responseData = JSON.parse(response);
                var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
                divBookingConfirmationDetails.find('#ddlEquipment').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'EquipmentID', textField: 'DisplayString', isSearchAble: true, selectedValue: 'Select' });
                callback(responseData);
            });
        }


        var getAdmittedPatient = function (data, callback) {
            serverCall('Services/OTBooking.asmx/GetAdmittedPatient', data, function (response) {
                var responseData = JSON.parse(response);
                var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
                divBookingConfirmationDetails.find('#ddlIPDPatient').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'TransactionID', textField: 'TransactionID', isSearchAble: true, selectedValue: 'Select' });
                callback(responseData);
            });
        }


        var onAdmitPatientSelect = function (el, callback) {

            var selectedIPD = 'ISHHI' + el.value;
            var data = {
                transactionID: selectedIPD
            };
            getAdmitPatientDetails(data, function (p) {
                bindSelectedIPDDetails(p, function () {
                    callback();
                });
            });
        }


        var bindSelectedIPDDetails = function (data, callback) {
            var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
            divBookingConfirmationDetails.find('.lblPatientName').text(data.PatientName);
            divBookingConfirmationDetails.find('.lblAge').text(data.Age);
            divBookingConfirmationDetails.find('.lblDoctor').text(data.DoctorName);
            divBookingConfirmationDetails.find('.lblGender').text(data.Gender);
            divBookingConfirmationDetails.find('.lblWardRoomNo').text(data.BedDetail);
            divBookingConfirmationDetails.find('.lblContactNo').text(data.Phone);
            divBookingConfirmationDetails.find('.lblIPDPatientDetailsData').text(JSON.stringify(data));
            callback();
        }


        var getAdmitPatientDetails = function (data, callback) {
            serverCall('Services/OTBooking.asmx/GetAdmitPatientDetails', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0)
                    callback(responseData[0]);
                else
                    callback({ PatientName: '', Age: '', DoctorName: '', Gender: '', BedDetail: '', Phone: '' });

            });

        }




        var addEquipmentOnBooking = function (e, el, callback) {


            var code = (e.keyCode ? e.keyCode : e.which);
            if (code != 13)
                return false;


            var divBookingConfirmationDetails = $('#divBookingConfirmationDetails');
            var quantity = Number(el.value);
            if (quantity < 1) {
                modelAlert('Please Enter Quantity.', function () {
                    $(el).focus();
                });
                return false;
            }


            var equipmentID = Number(divBookingConfirmationDetails.find('#ddlEquipment').val());

            if (equipmentID < 1) {
                modelAlert('Please Select Equipment.', function () {
                    divBookingConfirmationDetails.find('#ddlEquipment').focus();
                });
                return false;
            }

            debugger;
            var alreadyAddedEquipment = divBookingConfirmationDetails.find('#' + equipmentID);

            if (alreadyAddedEquipment.length > 0) {
                modelAlert('Equipment Already Added.', function () {
                    $(el).focus();
                });
                return false;
            }



            var equipmentName = divBookingConfirmationDetails.find('#ddlEquipment option:selected').text();




            var data = {
                value: equipmentID,
                text: quantity + ' x ' + equipmentName.split('-')[0],
                equipmentName: equipmentName.split('-')[0],
                quantity: quantity
            }
            var divEquipmentDetails = divBookingConfirmationDetails.find('#divEquipmentDetails');
            divEquipmentDetails.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a><span class="hidden tdData">' + JSON.stringify(data) + '</span></li>');


            divBookingConfirmationDetails.find('#ddlEquipment').val('0').trigger("chosen:updated");;
            el.value = '';
            callback();
        }




        var cancelBooking = function (el) {
            var tdData = JSON.parse($(el).closest('tr').find('.tdData').text());
            var divBookingCancelModel = $('#divBookingCancelModel');
            divBookingCancelModel.find('.lblBookingID').text(tdData.bookingID);
            divBookingCancelModel.showModel();
            divBookingCancelModel.find('textarea').val('').focus();
        }


        var _cancelBooking = function (btnCancel) {
            var divBookingCancelModel = $('#divBookingCancelModel');
            var cancelReason = $.trim(divBookingCancelModel.find('textarea').val());
            var bookingID = Number(divBookingCancelModel.find('.lblBookingID').text());

            if (String.isNullOrEmpty(cancelReason)) {
                modelAlert('Please Enter Cancel Reason.', function () {
                    divBookingCancelModel.find('textarea').focus();
                });
                return false;
            }
            $(btnCancel).attr('disabled', true).text('Submitting...');
            serverCall('Services/OTBooking.asmx/CancelBooking', { bookingID: bookingID, reason: cancelReason }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        window.location.reload();
                    }
                    else
                        $(btnCancel).removeAttr('disabled').text('Save');
                });
            });
        }


        var saveBookingReschedule = function (btnSave) {
            var divBookingRescheduleModel = $('#divBookingRescheduleModel');
            var bookingRescheduleReason = $.trim(divBookingRescheduleModel.find('textarea').val());
            var bookingID = Number($('#lblBookingID').text());
            if (String.isNullOrEmpty(bookingRescheduleReason)) {
                modelAlert('Please Enter Reschedule Reason.', function () {
                    divBookingRescheduleModel.find('textarea').focus();
                });
                return false;
            }




            save(btnSave, bookingID, bookingRescheduleReason);
        }

        var save = function (btnSave, bookingID, rescheduleReason) {
            getBookingDetails(function (data,surgeryList) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/OTBooking.asmx/Save', { booking: data, bookingID: bookingID, rescheduleReason: rescheduleReason, surgeryList: surgeryList }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        if (responseData.status) {
                            modelAlert('OT Number :  <span class="patientInfo">' + responseData.otNumber + '</span>', function () {
                                window.location.reload();
                            });
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }




        //var searchBookingIDOnEnter = function (e, el) {
        //    var code = (e.keyCode ? e.keyCode : e.which);
        //    if (code == 13) {
        //        var bookingID = el.value;
        //        getPatientBookingDetails({ bookingID: bookingID, patientID: '' }, function () {

        //        });
        //    }
        //}


        var searchBookingIDOn = function () {

            var bookingID = "";
            var UHID = "";
            var fromdate = $('#ucFromDate').val();
            var todate = $('#ucToDate').val();
            if ($('#ddlot').val() == 1) {
                bookingID = $('#txtOTNumber').val();
            }
            else if ($('#ddlot').val() == 2) {
                UHID = $('#txtOTNumber').val();
            }



            getPatientBookingDetails({ bookingID: bookingID, patientID: UHID, Fromdate: fromdate, Todate: todate }, function () {
            });

        }




        var getPatientBookingDetails = function (data, callback) {
            serverCall('Services/OTBooking.asmx/GetPatientBookingDetails', data, function (response) {
                responseData = JSON.parse(response);
                var parseHTML = $('#template_bookingDetails').parseTemplate(responseData);
                $('.divPatientOTDetails').html(parseHTML);
                callback(responseData);
            });
        }



        var onBookingEdit = function (el) {

            var tdData = JSON.parse($(el).closest('tr').find('.tdData').text());
            switchPatientTypeCategory((tdData.IsRegistredPatient > 0 ? 2 : 1), function () {
                var data = {
                    PName: tdData.PatientName,
                    PatientID: tdData.PatientID,
                    bookingID: tdData.bookingID,
                    TransactionID: '',
                    EmergencyNo: '',
                    Age: tdData.Age,
                    Gender: tdData.Gender,
                    Address: tdData.Address,
                    ContactNo: tdData.ContactNo,
                    DoctorID: tdData.DoctorID,
                    SurgeryID: tdData.SurgeryID,
                    bookingID: tdData.bookingID,
                    IsRegistredPatient: tdData.IsRegistredPatient,
                    isForEdit: true
                };

                _bindPatientDetails(data, function () {
                    var slot = {
                        id: tdData.bookingID,
                        OTName: tdData.OTName,
                        OTID: tdData.OTID,
                        startTime: tdData.SlotFromTime,
                        endTime: tdData.SlotToTime,
                        startSlotUniqueID: '',
                        endSlotUniqueID: '',
                        isDayWiseSelection: 0,
                        scheduleByDay: '',
                        scheduleByDate: tdData.SurgeryDate,
                        scheduleOnText: [tdData.SurgeryDate]
                    };
                    addOTSlotLists({ data: slot, value: slot.id, text: slot.OTName + ' : ' + slot.startTime + ' - ' + slot.endTime + ' ' + 'On ' + slot.scheduleOnText[0] });
                });
            });
        }



        function cleartxtOTNumber() {
            $('#txtOTNumber').val('');
        }

    </script>













    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b>OT Booking</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Search
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPatientType" onchange="onPatientTypeChangeForSurgery(this)">
                                <option value="1">General Patient</option>
                                <option value="2" selected="selected">Registered Patient</option>
                            </select>
                        </div>



                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <input type="text" id="txtPatientID" onkeyup="patientSearchByOnEnter(event,function(){})" />
                        </div>
                        <div class="col-md-3">
                            <input type="button" value="Search" onclick="patientSearchByOnBtnClick(function () { })" />

                        </div>
                        <div class="col-md-3">
                            <input type="button" value="Old Patient Search" onclick="$showOldPatientSearchModel(this)" />

                        </div>


                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Details
                <label id="lblIsRegistredPatient" class="hidden">0</label>
                <label id="lblBookingID" class="hidden">0</label>
                <label id="lblIsBookingReschedule" class="hidden">0</label>
            </div>
            <div class="row  ">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row divGeneralPatientDetails">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <input type="text" class="requiredField" id="txtPatientName" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Age
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-2">
                            <input type="text" class="requiredField" id="txtAge" onlynumber="5"  decimalplace="2"/>
                        </div>
                        <div class="col-md-3">
                            <select id="ddlAgeIn">
                                <option value="YRS">YRS</option>
                                <option value="MONTH(S)">MONTH(S)</option>
                                <option value="DAYS(S)">DAYS(S)</option>
                            </select>
                        </div>




                        <div class="col-md-3">
                            <label class="pull-left">
                                Gender
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <input id="rdoMale" type="radio" name="sex" checked="checked" value="Male" class="pull-left" />
                            <span class="pull-left">Male</span>
                            <input id="rdoFemale" type="radio" name="sex" value="Female" class="pull-left" />
                            <span class="pull-left">Female</span>
                            <input id="rdoTGender" type="radio" name="sex" value="TransGender" class="pull-left" />
                            <span class="pull-left">Others</span>

                        </div>
                    </div>
                    <div class="row divGeneralPatientDetails">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPhoneNumber" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtAddress" />
                        </div>
                    </div>

                    <div class="row divRegisteredPatientDetails hidden">

                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <label class="patientInfo lblRegisteredPatientDetails" id="lblPatientID"></label>
                            <label class="patientInfo lblRegisteredPatientDetails hidden" id="lblIPDNo"></label>
                            <label class="patientInfo lblRegisteredPatientDetails hidden" id="lblEMGNo"></label>
                        </div>


                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <label class="patientInfo lblRegisteredPatientDetails" id="lblPatientName"></label>
                        </div>


                        <div class="col-md-3">
                            <label class="pull-left">
                                Age
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <label class="patientInfo lblRegisteredPatientDetails" id="lblAge"></label>
                        </div>


                    </div>
                    <div class="row divRegisteredPatientDetails hidden">

                        <div class="col-md-3">
                            <label class="pull-left">
                                Gender
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label class="patientInfo lblRegisteredPatientDetails" id="lblGender"></label>
                        </div>




                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label class="patientInfo lblRegisteredPatientDetails" id="lblContactNo"></label>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label class="patientInfo lblRegisteredPatientDetails" id="lblAddress"></label>
                        </div>




                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select class="ddlSurgeryDoctor requiredField" id="ddlSurgeryDoctor"></select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Surgery
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSurgery" class="requiredField" onchange="ShowHideOtherSurgeryTextBox(); OnSurgeryChange(this,event);"></select>
                        </div>

                        <div class="col-md-5">
                         <input type="text" id="txtOtherSurgeryName" placeholder="Enter Other Surgery Here" class="requiredField" style="display:none" />
                        </div>

                    </div>
                    <div class="row surgeryName">
                        <div class="col-md-3">
                            <label class="pull-left">Surgery Added </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <div id="divSurgeryList" class="chosen-container-multi">
                                <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Slot Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtSurgeryDate" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="Calendarextender1" TargetControlID="txtSurgeryDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <a href="javascript:void(0)" style="width: 100%" onclick="openOTScheduling(this)">Get Available OT Slots</a>
                        </div>

                        <div class="col-md-4">
                            <a href="javascript:void(0)" style="width: 100%" onclick="openOTSchedulingDetails(this)">Review OT Schedules</a>
                        </div>

                        
                    </div>


                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Selected OT Slots
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-21">
                            <div id="divOTSlotList" class="chosen-container-multi">
                                <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices"></ul>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory textCenter">
            <input type="button" value="Save" class="save margin-top-on-btn" onclick="_saveBooking(this);" />
        </div>
         <div class="POuter_Box_Inventory">
           
        <div class="row" style="text-align:center;font-size:22px;font-weight:bolder;background-color:green;height:26px;color:white">
            <span>Search Booked Cases</span>
        </div>

       </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               <select id="ddlot" onchange="cleartxtOTNumber()">
                                    <option value="2">UHID</option>
                                    <option value="1">OT Number</option>                               
                            </select>
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <input type="text" id="txtOTNumber"  /><%--  onkeyup="searchBookingIDOnEnter(event,this);" />--%>
                        </div>
                        <div class="col-md-3">
							<label class="pull-left">
								From Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						 <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ReadOnly="true"  ClientIDMode="Static" TabIndex="13" onkeyup="if(event.keyCode==13){Search(0);};"></asp:TextBox>
						<cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
						   <div class="col-md-3">
							<label class="pull-left">
								To Date
							</label>
							<b class="pull-right">:</b>
						</div>
						<div class="col-md-5">
						<asp:TextBox ID="ucToDate" runat="server"   ReadOnly="true"  onkeyup="if(event.keyCode==13){Search(0);};" ClientIDMode="Static" TabIndex="14" ToolTip="Click To Select To Date"></asp:TextBox>
						<cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
						</div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
         <div class="POuter_Box_Inventory">
             <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle confirmedBooking" onclick="statusbuttonsearch('Sample Collected')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Approved</b>
                            <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle canceledBooking" onclick="statusbuttonsearch('Pending')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Cancel</b>
                             <button type="button"  style="width:25px;height:25px;margin-left:5px;float:left;" class="circle rescheduledBooking" onclick="statusbuttonsearch('Machine Data')"></button>
                            <b style="margin-top:5px;margin-left:5px;float:left">Reschedule</b>
             <b style="margin-top:5px;margin-left:297px;float:left"></b>
            <input type="button" value="Search" id="btnsearch" onclick="searchBookingIDOn()" class="save margin-top-on-btn"  />
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <div class="Purchaseheader">
                Patient OT Details
            </div>
            <div class="row">
                <div class="col-md-24 divPatientOTDetails" style="min-height: 230px; max-height: 230px; height: 230px; overflow: auto">
                </div>
            </div>
        </div>
    </div>


    <div id="divBookingRescheduleModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divBookingRescheduleModel" aria-hidden="true">×</button>
                    <h4 class="modal-title">Reschedule Reason</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <textarea cols="" rows="" style="height: 75px; width: 276px; max-height: 75px; max-width: 276px; min-height: 75px; min-width: 276px" class="requiredField" id="txtBookingRescheduleReason"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="save" onclick="saveBookingReschedule(this)">Save</button>
                    <button type="button" class="save" data-dismiss="divBookingRescheduleModel">Close</button>
                </div>
            </div>
        </div>
    </div>




    <div id="divBookingCancelModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divBookingCancelModel" aria-hidden="true">×</button>
                    <h4 class="modal-title">Cancel Reason</h4>
                    <label class="hidden lblBookingID">0</label>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <textarea cols="" rows="" style="height: 75px; width: 276px; max-height: 75px; max-width: 276px; min-height: 75px; min-width: 276px" class="requiredField"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="save" onclick="_cancelBooking(this)">Save</button>
                    <button type="button" class="save" data-dismiss="divBookingCancelModel">Close</button>
                </div>
            </div>
        </div>
    </div>



    <div id="divBookingConfirmationDetails" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 300px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divBookingConfirmationDetails" aria-hidden="true">×</button>
                    <h4 class="modal-title">Booking Confirmation Details</h4>
                    <label class="lblBookingConfirmationData hidden"></label>
                    <label class="lblIPDPatientDetailsData hidden"></label>
                </div>
                <div class="modal-body">
                    <div class="row">
                      <h4>  <span>Are you sure to approve booking? </span></h4>
                    </div>

                    <div class="row" style="display:none">
                        <div class="col-md-4">
                            <label class="pull-left">
                                OT Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" >
                            <label class="patientInfo lblOTNumber"></label>
                        </div>
                        <div class="col-md-4" style="display:none">
                            <label class="pull-left">
                                Map IPD Patient
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" style="display:none">
                            <select id="ddlIPDPatient" class="requiredField" onchange="onAdmitPatientSelect(this,function(){})"></select>
                        </div>
                    </div>

                    <div class="row" style="display:none">

                        <div class="col-md-4" style="display:none">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" style="display:none">
                            <label class="patientInfo lblPatientName"></label>
                        </div>
                        <div class="col-md-4" style="display:none">
                            <label class="pull-left">
                                Age
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" style="display:none">
                            <label class="patientInfo lblAge"></label>
                        </div>

                       

                    </div>


                    <div class="row" style="display:none">
                        <div class="col-md-4" style="display:none">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" style="display:none">
                            <label class="patientInfo lblDoctor"></label>
                        </div>

                         <div class="col-md-4" style="display:none">
                            <label class="pull-left">
                                Gender
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" style="display:none">
                            <label class="patientInfo lblGender"></label>
                        </div>
                      
                    </div>

                    <div class="row" style="display:none">
                        <div class="col-md-4" style="display:none">
                            <label class="pull-left">
                                Ward/Room No 
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11" style="display:none">
                               <label class="patientInfo lblWardRoomNo"></label>
                        </div> 

                         

                          <div class="col-md-4" style="display:none">
                            <label class="pull-left">
                                Contact
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5" style="display:none">
                            <label class="patientInfo lblContactNo"></label>
                        </div>

                    </div>



                    <div class="row" style="display:none">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Equipment 
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-11">
                            <select id="ddlEquipment" onchange="checkqty()"></select>
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-5">
                            <input type="text" class="txtEquipmentQuantity ItDoseTextinputNum" placeholder="Enter To Add"   onlynumber="2" decimalplace="0" max-value="99" onkeyup="addEquipmentOnBooking(event,this,function(){})" />
                        </div>
                        


                    </div>


                    


                    <div class="row" style="display:none">
                           <div class="col-md-4">
                            <label class="pull-left">
                                Equipment's
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-20">
                            <div id="divEquipmentDetails" class="chosen-container-multi">
                                <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0;min-height: 150px;max-height:250px;overflow:auto" class="chosen-choices"></ul>
                                </div>
                        </div>
                    </div>

                  <%--  <div class="row">
                           <div class="col-md-4">
                            <label class="pull-left">
                                Remark
                            </label>
                            <b class="pull-right">:</b>
                        </div>

                        <div class="col-md-20">
                            <textarea cols="" rows="" style="min-height:29px;max-height:29px;height:29px;min-width:634px;max-width:634px;width:634px" class="txtConfirmationRemarks"></textarea>
                        </div>
                    </div>--%>

                </div>
                <div class="modal-footer">
                    <button type="button" class="save" style="width:40px" onclick="_confirmBooking(this)">Yes</button>
                    <button type="button" class="save"  style="width:40px" data-dismiss="divBookingConfirmationDetails">No</button>
                </div>
            </div>
        </div>
    </div>







    <div id="oldPatientModel" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$closeOldPatientSearchModel()"   aria-hidden="true">&times;</button>
                <h4 class="modal-title">Old Patient Search</h4>
            </div>
            <div class="modal-body">
                 <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  UHID    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">

                          <input type="text" id="txtSearchModelMrNO"  />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left">   </label>
                           <b class="pull-right"></b>
                     </div>
                     <div  class="col-md-8"></div>
                 </div>
                  <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  First Name    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <input type="text" id="txtSearchModelFirstName" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Last Name   </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <input type="text" id="txtSearchModelLastName" />
                     </div>
                 </div>

                  <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  Contact No.   </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                         <input type="text" id="txtSerachModelContactNo" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Address    </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                         <input type="text" id="txtSearchModelAddress" />
                     </div>
                 </div>
                 <div class="row">
                     <div  class="col-md-4">
                          <label class="pull-left">  From Date    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                           <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                           <cc1:calendarextender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> To Date    </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                          <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                          <cc1:calendarextender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                 </div>


                <div style="text-align:center" class="row">
                       <button type="button"  onclick="$searchOldPatientDetail()">Search</button>
                </div>
                <div style="height:200px"  class="row">
                    <div id="divSearchModelPatientSearchResults" class="col-md-24">


                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button"  onclick="$closeOldPatientSearchModel()">Close</button>
            </div>
        </div>
    </div>
</div>




        <script id="template_bookingDetails" type="text/html">
        <table  id="tableBills" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" >UHID</th>
            <th class="GridViewHeaderStyle" >Name</th>
            <th class="GridViewHeaderStyle" style="width:160px">OT Number</th>
            <th class="GridViewHeaderStyle" >OT Name</th>
            <th class="GridViewHeaderStyle" style="width:100px">Surgery Date</th>
            <th class="GridViewHeaderStyle" style="width:85px">Start Time</th>
            <th class="GridViewHeaderStyle" style="width:85px">End Time</th>
            <th class="GridViewHeaderStyle" >Doctor</th>
            <th class="GridViewHeaderStyle" >Surgery</th>  
            <th class="GridViewHeaderStyle" ></th>  
                                 
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=responseData.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = responseData[j];
                #>          
                

                    <tr style='cursor:pointer;'
                        


                         <#if(objRow.IsCancel>0){#>
                             class='canceledBooking'
                         <#}#>


                        <#if(objRow.IsConfirm>0){#>
                             class='confirmedBooking'
                         <#}#>
                        

                        <#if(objRow.RescheduledRefID>0){#>
                             class='rescheduledBooking'
                        <#}#>

                       

                        
                        >                            
       
                        <td class="GridViewLabItemStyle">  <#=j+1#>  </td> 
                         <td class="GridViewLabItemStyle"><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.PatientName#></td>                                  
                        <td class="GridViewLabItemStyle"><#=objRow.OTNumber#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.OTName#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.SurgeryDate#></td> 
                        <td class="GridViewLabItemStyle"><#=objRow.SlotFromTime#></td>   
                        <td class="GridViewLabItemStyle"><#=objRow.SlotToTime#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.DoctorName#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.SurgeryName#></td>
                        <td class="GridViewLabItemStyle">
                             <#if(objRow.IsCancel==0 && objRow.IsConfirm==0){#>
                                  <a href="javascript:void(0);" onclick="onBookingEdit(this);">Edit</a>&nbsp
                                  <a href="javascript:void(0);" onclick="confirmBooking(this)">Approve</a>&nbsp
                                  <a href="javascript:void(0);" onclick="cancelBooking(this)">Cancel</a>
                            <#}else{#>      
                             <a href="javascript:void(0);" onclick="onBookingEdit(this);">Edit</a>&nbsp
                                  
                                  <a href="javascript:void(0);" onclick="cancelBooking(this)">Cancel</a>
                             <#}#>
                        </td>
                        
                         <td class="GridViewLabItemStyle tdData"  style="display:none"><#=JSON.stringify(objRow)#></td>  
                                      
                        </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>


    <script type="text/javascript">
        checkqty = function () {
            if ($('#ddlEquipment').val() > 0) {
                $('.txtEquipmentQuantity').addClass('requiredField');
            }
            else
                $('.txtEquipmentQuantity').removeClass('requiredField');
        }
        var _PageSize = 9;
        var _PageNo = 0;
        var $searchOldPatientDetail = function () {
            var data = {
                PatientID: $('#txtSearchModelMrNO').val(),
                PName: $('#txtSearchModelFirstName').val(),
                LName: $('#txtSearchModelLastName').val(),
                ContactNo: $('#txtSerachModelContactNo').val(),
                Address: $('#txtSearchModelAddress').val(),
                FromDate: $('#txtSearchModelFromDate').val(),
                ToDate: $('#txtSerachModelToDate').val(),
                PatientRegStatus: 1,
                isCheck: '0',
                AadharCardNo: '',
                MembershipCardNo: '',
                DOB: '',
                IsDOBChecked: '0',
                Relation: '0',
                RelationName: '',
                IPDNO: '',
                panelID: '',
                cardNo: '',
                IDProof: '',
                visitID: '',
                emailID: '',
                patientType: '2',
                FamilyNo: ''
            }
            serverCall('../Common/CommonService.asmx/oldPatientSearch', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    OldPatient = JSON.parse(response);
                    if (OldPatient != null) {
                        _PageCount = OldPatient.length / _PageSize;
                        showPage(0);
                    }
                    else {
                        $('#divSearchModelPatientSearchResults').html('');
                    }
                }
                else
                    $('#divSearchModelPatientSearchResults').html('');

            });
        }
        var $searchPatient = function (data, IPDDetails, callback) {
            var IPDAdmissionDetails = IPDDetails.split('#');
            var IPDTransactionID = IPDAdmissionDetails[0];
            var IPDAdmissionRoomType = IPDAdmissionDetails[1];
            if (!String.isNullOrEmpty(IPDTransactionID)) {
                modelConfirmation('<span style="color: red;">Patient is Already Admited !</span>', '<span style="color: black;"> With IPD NO. :<span> &nbsp;<span style="color: blue;"> ' + IPDTransactionID.replace('ISHHI', '') + '</span></br><span style="color: black;">IN Room Type :</span>&nbsp; <span style="color: blue;">' + IPDAdmissionRoomType + '</span>', '', 'Close', function (response) {
                    $getPatientDetails(data.PatientID, function (response) {
                        callback(response);
                    });
                });
            }
            else {
                $getPatientDetails(data.PatientID, function (response) {
                    callback(response);
                });
            }
        }


        var patientSearchByOnEnter = function (e, callback) {


            var code = (e.keyCode ? e.keyCode : e.which);
            if (code != 13)
                return false;

            var selectPatientID = e.target.value;

            if (String.isNullOrEmpty(selectPatientID)) {
                modelAlert('Please Enter UHID.', function () {
                    $(e.target).focus();
                });
                return false;
            }


            $getPatientDetails(selectPatientID, function (response) {
                $bindPatientDetails(response, function () { });
            });


        }


        var patientSearchByOnBtnClick = function (callback) {


            var selectPatientID = $("#txtPatientID").val();

            if (String.isNullOrEmpty(selectPatientID)) {
                modelAlert('Please Enter UHID.', function () {
                    $(e.target).focus();
                });
                return false;
            }


            $getPatientDetails(selectPatientID, function (response) {
                $bindPatientDetails(response, function () { });
            });


        }


        var $getPatientDetails = function (selectPatientID, callback) {

            var data = {
                patientID: selectPatientID,
                IPDNo: '',
                EMGNo: '',
            }

            if (!String.isNullOrEmpty(selectPatientID))
                data.patientID = selectPatientID

            serverCall('OTBooking.aspx/bindData', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    if (responseData.data.length > 0)
                        callback(responseData.data[0]);
                    else
                        modelAlert(responseData.message);
                }
                else
                    modelAlert(responseData.message)
            })
        }



        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
            $('#divSearchModelPatientSearchResults').html(outputPatient);
        }


        var $showOldPatientSearchModel = function () {
            $('#oldPatientModel').showModel();
        }

        var $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }

        var $bindPatientDetails = function (data, callback) {
            switchPatientTypeCategory(2, function () {
                getPatientBookingDetails({ bookingID: '', patientID: data.PatientID, Fromdate: '', Todate: '' }, function () {
                    data.isForEdit = false;
                    _bindPatientDetails(data, function () {
                        $closeOldPatientSearchModel();
                        callback(true);
                    });
                });
            });
        }


        var _bindPatientDetails = function (data, callback) {
            debugger;
            var divGeneralPatientDetails = $('.divGeneralPatientDetails');
            if (data.IsRegistredPatient == 0) {
                divGeneralPatientDetails.find('#txtPatientName').val(data.PName);
                var ageDetail = data.Age.split(' ');
                divGeneralPatientDetails.find('#txtAge').val(ageDetail[0]);
                if (ageDetail.length > 1)
                    divGeneralPatientDetails.find('#ddlAgeIn').val(ageDetail[1]);

                divGeneralPatientDetails.find('input[type=radio][name=sex][value=' + data.Gender + ']').prop('checked', true);
                divGeneralPatientDetails.find('#txtAddress').val(data.Address);
                divGeneralPatientDetails.find('#txtPhoneNumber').val(data.ContactNo)
            }
            else {
                $('#lblPatientName').text(data.PName);
                $('#lblPatientID').text(data.PatientID);
                $('#lblIPDNo').text($.trim(data.Status) == 'IN' ? data.TransactionID : '');
                $('#lblEMGNo').text($.trim(data.Status) == 'IN' ? data.EmergencyNo : '');
                $('#lblAge').text(data.Age)
                $('#lblGender').text(data.Gender);
                $('#lblAddress').text(data.Address);
                $('#lblContactNo').text(data.ContactNo);
            }
            $('#lblBookingID').text(data.bookingID);
            var isDisabledDoctorChange = false;
            if (data.isForEdit)
                isDisabledDoctorChange = true;
            else {
                isDoctorLogin = Number('<%=Util.GetInt(ViewState["IsDoctorLogin"]) %>');
                if (isDoctorLogin > 0) {
                    isDisabledDoctorChange = true;
                    data.DoctorID = '<%=Util.GetString(ViewState["defaultDoctorID"]) %>'
                }
            }

            $('#ddlSurgeryDoctor').val(data.DoctorID).prop('disabled', isDisabledDoctorChange).trigger("chosen:updated");
            $('#ddlSurgery').val(data.SurgeryID).trigger("chosen:updated");
            callback();
        }











    </script>


    <script id="tb_OldPatient" type="text/html">
    <table  id="tablePatient" cellspacing="0" rules="all" border="1" 
    style="width:876px;border-collapse :collapse;">
        <thead>
        <tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
            <th class="GridViewHeaderStyle" scope="col" >Title</th>
            <th class="GridViewHeaderStyle" scope="col" >First Name</th>
            <th class="GridViewHeaderStyle" scope="col" >L.Name</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >Age</th>
            <th class="GridViewHeaderStyle" scope="col" >Sex</th>
            <th class="GridViewHeaderStyle" scope="col" >Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Address</th>
            <th class="GridViewHeaderStyle" scope="col" >Contact&nbsp;No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Card No.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Valid To</th>                          
    
        </tr>
            </thead>
        <tbody>
        <#     
             
              var dataLength=OldPatient.length;
        if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }
        for(var j=_StartIndex;j<_EndIndex;j++)
            {           
       var objRow = OldPatient[j];
        #>
                        <tr id="<#=j+1#>"  
                             <#if(objRow.PatientRegStatus =="2"){#>
                        style="background-color:coral;cursor:pointer;"
                         
                        <#}
                         else {#>
                        style="cursor:pointer;"
                        <#}
                        #>
                            >                            
                        <td class="GridViewLabItemStyle">
                       <a  class="btn" onclick="$searchPatient({PatientID:$.trim($(this).closest('tr').find('#tdPatientID').text()),PatientRegStatus:1},$(this).find('#spnIPDDetails').text(),function(response){$bindPatientDetails(response,function(){  })});" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
                          Select
                           <span style="display:none" id="spnIPDDetails"><#=objRow.IPDDetails#></span>
                       </a>    </td>                                                    
                        <td  class="GridViewLabItemStyle" id="tdTitle"  ><#=objRow.Title#></td>
                        <td class="GridViewLabItemStyle" id="tdPFirstName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PFirstName#></td>
                        <td class="GridViewLabItemStyle" id="tdPLastName" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PLastName#></td>
                        <td class="GridViewLabItemStyle" id="tdPatientID"  ><#=objRow.MRNo#></td>
                        <td class="GridViewLabItemStyle" id="tdAge" ><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle" id="tdGender" ><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle" id="tdDate" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.Date#></td>
                        <td class="GridViewLabItemStyle" id="tdHouseNo" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"  ><#=objRow.SubHouseNo#></td>
                        <td class="GridViewLabItemStyle" id="tdContactNo" ><#=objRow.ContactNo#></td>  
                        <td class="GridViewLabItemStyle" id="tdCardNo" ><#=objRow.MemberShipCardNo#></td>   
                        <td class="GridViewLabItemStyle" id="tdValidTo" ><#=objRow.MemberShipValidTo#></td>                      
                        
                        <td class="GridViewLabItemStyle" id="tdPatientRegStatus" style="width:80px;display:none"><#=objRow.PatientRegStatus#></td>                         
                        </tr>            
        <#}        
        #>
            </tbody>      
     </table>  
     <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
       <tr>
   <# if(_PageCount>1) {
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
   }
#>
     </tr>     
     </table>  
    </script>

    <UC1:OTSchedulingControl ID="sch" runat="server"/>    
    <UC2:OTSchedulingDetailsControl ID="OTSchedulingDetailsControl1" runat="server"/>


    
    <div id="divGetBookedDetailsModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width:100%">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divGetBookedDetailsModel" aria-hidden="true">×</button>
                    <h4 class="modal-title">Get Booked Slot</h4>
                   
                    <div class="row">
                        <div class="col-md-5">
                             <asp:TextBox runat="server" ID="txtShedulingDate" ClientIDMode="Static" onchange="GetBookingDeatils()"></asp:TextBox>
                            <cc1:CalendarExtender ID="Calendarextender2" TargetControlID="txtShedulingDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                    </div>  
                    
                </div>
                <div class="modal-body">
                    <div class="row" id="divOtBookeddataAppend"  style="overflow-y:auto;overflow-x:auto;height:400px">
                          
                    </div>
                </div>
                <div class="modal-footer">
                    
                    <button type="button" class="save" data-dismiss="divGetBookedDetailsModel">Close</button>
                </div>
            </div>
        </div>
    </div>



    <script type="text/javascript">

        function ShowGetBookedDetails() {

            GetBookingDeatils();
            $("#divGetBookedDetailsModel").showModel();

        }

        function GetBookingDeatils() {
            var date = $("#txtShedulingDate").val();
            GetOtName(date);
        }
         
        function GetOtName(Date) {

            serverCall('OTBooking.aspx/GetOtDetils', {}, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    $('#divOtBookeddataAppend').empty();
                    data = responseData.data;
                    $.each(data, function (i, item) {                         
                        GetPatientDetails(Date, item,i,function () { })
                    });

                }
                    

            });


        }
        var GetPatientDetails = function (Date, item, i)
          { 
            serverCall('OTBooking.aspx/GetPatientDetails', { Date: Date, OtId: item.Id }, function (response) {
                var resData = JSON.parse(response);
                if (resData.status) {
                    BindPatientDetails(item, resData.data, i, 1)
                }  
            });
        }
       
        function BindPatientDetails(DataOt,DataPatient,i,IsHavePatientDet) {
           

            var rows = "<div class='row' style='border:solid thin;'>";

            rows += "<div class='col-md-24' style='padding: 10px;text-align: center;font-size: 15px;font-weight: bolder;color: blue;' id='divOtDetails" + DataOt.Id + "_" + i + "'>" + DataOt.Name + "</div>";

            if (IsHavePatientDet == 1) {
                rows += "<div class='col-md-24' style='border-top:solid thin;'>";
                rows += "<div class='row' id='divpatientDetails" + DataOt.Id + "_" + i + "'>";

                $.each(DataPatient, function (i, item) {
                    rows += "<div class='col-md-8' style='margin-bottom: 10px;'>";
                    rows += "<div class='row' style='background-color: aqua;padding:05px;'>";
                    rows += "<div class='col-md-10'>Name :</div>";
                    rows += "<div class='col-md-14'>" + item.PatientName + "</div>";
                    rows += "<div class='col-md-10'>UHID :</div>";
                    rows += "<div class='col-md-14'>" + item.PatientID + "</div>";
                    rows += "<div class='col-md-10'>Slot :</div>";
                    rows += "<div class='col-md-14'>" + item.SlotTime + "</div>";
                    rows += "<div class='col-md-10'>Doctor Name :</div>";
                    rows += "<div class='col-md-14'>" + item.Doctor + "</div>";
                    rows += "<div class='col-md-10'>Procedure Name:</div>";
                    rows += "<div class='col-md-14'>" + item.Surgery + "</div>";

                    rows += "</div>";
                    rows += "</div>";
                });
                rows += "</div></div>";

            }
           
          
            rows += "</div>";

            $('#divOtBookeddataAppend').append(rows);
 
            
        }

    </script>


    <script type="text/javascript">


        var openOTSchedulingDetails = function () {
            var doctorID = $('#ddlSurgeryDoctor').val();

            doctorID = doctorID == '0' ? '' : doctorID;

            var isDayWiseSelection = 0;
            var scheduleDate = $('#txtSurgeryDate').val();
            var scheduleDay = '';
            getAllocatedSlotDetailsNew(function (selectedSlots) {
                var alreadySelectedSlots = selectedSlots.slotLists.filter(function (s) { return s.id == 0 });
                var isDoctorLogin = Number('<%=Util.GetInt(ViewState["IsDoctorLogin"]) %>');
                //isDoctorLogin = 1;
                _openOTSchedulingDetails({
                    allowMultipleOTSlotSelection: 0,
                    checkedDoctorBookedSlots: 0,
                    checkedPatientBookedSlots: 1,
                    doctorID: doctorID,
                    selectedSlots: alreadySelectedSlots,
                    isDayWiseSelection: isDayWiseSelection,
                    scheduleDate: scheduleDate,
                    scheduleDay: scheduleDay,
                    applyExpiredFilter: isDayWiseSelection > 0 ? 0 : 1,
                    isForDoctorSlotAllocation: 0,
                    filterDoctorSpecifiedSlot: (isDoctorLogin > 0 ? 1 : 0)
                }, function () {


                }, onSlotSelection);
            });
        }


        var getAllocatedSlotDetailsNew = function (callback) {

            var doctorID = $('#ddlSurgeryDoctor').val();

            var data = {
                doctorID: doctorID,
                slotLists: []
            };
            $('#divOTSlotList ul li .tdData').each(function () {
                var tdData = JSON.parse($(this).text());

                data.slotLists.push({
                    OTID: tdData.OTID,
                    startTime: tdData.startTime,
                    endTime: tdData.endTime,
                    id: tdData.id,
                    startSlotUniqueID: tdData.startSlotUniqueID,
                    endSlotUniqueID: tdData.endSlotUniqueID,
                    isDayWiseSelection: tdData.isDayWiseSelection,
                    scheduleOnText: tdData.scheduleOnText,
                });

            });

            callback(data);
        }



        function GetPatientDetailsForRescheduling(bookingID, UHID) {

            serverCall('Services/OTBooking.asmx/GetPatientBookingDetailsForEdit', { bookingID: bookingID, patientID: UHID, Fromdate: "", Todate: "" }, function (response) {
                var tdData = JSON.parse(response);

                switchPatientTypeCategory((tdData[0].IsRegistredPatient > 0 ? 2 : 1), function () {
                    var data = {
                        PName: tdData[0].PatientName,
                        PatientID: tdData[0].PatientID,
                        bookingID: tdData[0].bookingID,
                        TransactionID: '',
                        EmergencyNo: '',
                        Age: tdData[0].Age,
                        Gender: tdData[0].Gender,
                        Address: tdData[0].Address,
                        ContactNo: tdData[0].ContactNo,
                        DoctorID: tdData[0].DoctorID,
                        SurgeryID: tdData[0].SurgeryID,
                        bookingID: tdData[0].bookingID,
                        IsRegistredPatient: tdData[0].IsRegistredPatient,
                        isForEdit: true
                    };

                    _bindPatientDetails(data, function () {
                        var slot = {
                            id: tdData[0].bookingID,
                            OTName: tdData[0].OTName,
                            OTID: tdData[0].OTID,
                            startTime: tdData[0].SlotFromTime,
                            endTime: tdData[0].SlotToTime,
                            startSlotUniqueID: '',
                            endSlotUniqueID: '',
                            isDayWiseSelection: 0,
                            scheduleByDay: '',
                            scheduleByDate: tdData[0].SurgeryDate,
                            scheduleOnText: [tdData[0].SurgeryDate]
                        };
                        addOTSlotLists({ data: slot, value: slot.id, text: slot.OTName + ' : ' + slot.startTime + ' - ' + slot.endTime + ' ' + 'On ' + slot.scheduleOnText[0] });
                    });
                });

                _onOTSchedulingModalCloseDetails();
                openOTScheduling();

            });


        }



        function ShowHideOtherSurgeryTextBox() {


            if ($("#ddlSurgery").val() == '<%=Resources.Resource.OtherSurgeryId%>') {
                
                $("#txtOtherSurgeryName").show();
            } else {
                
                $("#txtOtherSurgeryName").hide();
            }


        }

        var OnSurgeryChange = function (el, event) {
            if (el.value == '0')
                return false;

            var data = {
                value: el.value,
                text: $(el.selectedOptions).text()
            }

            bindSurgeryDiv(data, function () { });

        }
        var bindSurgeryDiv = function (data, callback) {
            var surgeryList = $('#divSurgeryList')


            $isAlreadyExits = surgeryList.find('#' + data.value);
            if ($isAlreadyExits.length > 0) {
                modelAlert('Surgery Already Seleted');
                return false;
            }
            surgeryList.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a></li>');
            callback(surgeryList);
        }

        var $getAddedSurgery = function (callback) {
            var surgeryList = [];
            $('#divSurgeryList ul li').each(function () {
                surgeryList.push({
                    surgeryID: this.id,
                    surgeryName: $(this).find('span').text()
                });
            });

            callback(surgeryList);

        }

    </script>




</asp:Content>

