<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCAdmissionBedDetails.ascx.cs" Inherits="Design_Controls_UCAdmissionBedDetails" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript">

    $IPDAdmissionDetailsControlInit = function (callback) {
        $bindBillingCategory(function () {
            $bindRoomType(function () {
                $bindAdmissionType(function () {
                    $bindDeliverytypes(function () {
                        $bindDeliveryWeeks(function () {
                            $bindDeliveryDays(function () {
                                $init(function () {
                                    callback(true);
                                });
                            });
                        });
                    });
                });
            });
        });
    }



    $init = function (callback) {
        $('#spnIPDNo').on('DOMSubtreeModified', function () {
            if (!String.isNullOrEmpty(this.innerText)) {
                $('.deliveryDetails').show();
                $('.deliveryDetails').find('input,select').not('#ddlIgnoreDelivery,#txtDeliveryIgnoreReason').val('').prop('selectedIndex', 0).prop('disabled', false).addClass('requiredField');
            }
            else {
                $('.deliveryDetails').hide();
                $('.deliveryDetails').find('input,select').not('#ddlIgnoreDelivery,#txtDeliveryIgnoreReason').val('').prop('selectedIndex', 0).prop('disabled', false).removeClass('requiredField');
            }
        });


        //$('#ddlDoctor').change(function (e) {
        //    if (this.value == '0')
        //        return false;

        //    var data = {
        //        value: this.value,
        //        text: $(this.selectedOptions).text()
        //    }

        //    bindAdmissionDoctors(data, function () { });
        //});


        callback();
    }


    var _onUserControlDoctorChange = function (el, event, callback) {

        if (el.value == '0')
            return false;

        var data = {
            value: el.value,
            text: $(el.selectedOptions).text()
        }

        bindAdmissionDoctors(data, function () { });

    }




    var bindAdmissionDoctors = function (data, callback) {
        var doctorList = $('#divDoctorList')
        //var totalDoctors = doctorList.find('li').length;
        //if (totalDoctors == 2) {
        //    modelAlert('More Then Two Doctor Not Allow');
        //    return false;
        //}
        var URL = window.location.href.split('?')[0];
        var pageName = URL.split('/')[URL.split('/').length - 1];
		
        $isAlreadyExits = doctorList.find('#' + data.value);
        if ($isAlreadyExits.length > 0) {
            modelAlert('Doctor Already Seleted');
            return false;
        
		}
         
       
        if (pageName == "IPDAdmissionNew.aspx") {
            bindCunsultentByTeamID(data.value);
            hideshowconsultant(1);
        } else {
            hideshowconsultant(0);
        }

        doctorList.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a></li>');
        callback(doctorList);
    }

    function appendTeamMember() {
        var doctorList = $('#divDoctorList');
        var oldData = document.getElementById("ulDoctorList").innerHTML;

        if( $('#ddlConsultent').val()=="0")
        {
            modelAlert('Please Select Billing Consultant');
            return false;
        }

        $isAlreadyExits = doctorList.find('#' + $('#ddlConsultent').val());
        if ($isAlreadyExits.length > 0) {
            modelAlert('Doctor Already Seleted');
            return false;

        }
        $("#ulDoctorList").empty();

        doctorList.find('ul').append('<li id=' + $('#ddlConsultent').val() + ' class="search-choice"><span>' + $('#ddlConsultent option:selected').text() + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + $('#ddlConsultent').val() + '</a></li>');
        doctorList.find('ul').append(oldData);
    }

    function bindCunsultentByTeamID(TeamID) {
        $ddlteamMember = $('#ddlConsultent');
        serverCall('Services/IPDAdmission.asmx/bindTeamMember', {TeamID:TeamID}, function (response) {
            if (!String.isNullOrEmpty(response)) {
                $ddlteamMember.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ID', textField: 'Name', isSearchAble: true });
                
            }
             
        });
    }

    function hideshowconsultant(typ) {

        if (typ==1) {
            $("#divConDr").show();
            $("#divConDrs").show();
        } else {
            $("#divConDr").hide();
            $("#divConDrs").hide();
        }
    }


    $bindBillingCategory = function (callback) {
        $ddlRoomBilling = $('#ddlRoomBilling');
        serverCall('Services/IPDAdmission.asmx/bindBillingCategory', {}, function (response) {
            if (!String.isNullOrEmpty(response)) {
                $ddlRoomBilling.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'IPDCaseTypeID', textField: 'Name', isSearchAble: true });
                callback($ddlRoomBilling.val());
            }
            else {
                $ddlRoomBilling.empty();
                callback($ddlRoomBilling.val());
            }
        });
    }

    $bindRoomType = function (callback) {
        $ddlRoomType = $('#ddlRoomType');
        $ddlRequestRoomType = $('#ddlRequestRoomType');
        serverCall('Services/IPDAdmission.asmx/bindRoomType', {}, function (response) {
            if (!String.isNullOrEmpty(response)) {
                $ddlRoomType.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'IPDCaseTypeID', textField: 'Name', isSearchAble: true });
                $ddlRequestRoomType.bindDropDown({ data: JSON.parse(response), defaultValue: 'No', valueField: 'IPDCaseTypeID', textField: 'Name', isSearchAble: true });
                callback($ddlRoomType.val());
            }
            else {
                $ddlRoomType.empty();
                $ddlRequestRoomType.empty();
                callback($ddlRoomType.val());
            }
        });
    };

    var $bindRoomBed = function (roomType, callback) {
        debugger;
        $ddlRoomNo = $('#ddlRoomNo');
        serverCall('Services/IPDAdmission.asmx/bindRoomBed', { caseType: roomType, IsDisIntimated: '0', type: $("#lblAdvanceRoomBooking").length, bookingDate: $('#txtAdmissionDate').val().trim() }, function (response) {
            if (!String.isNullOrEmpty(response)) {
                $ddlRoomNo.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'RoomID', textField: 'Name', isSearchAble: true });
                $('#ddlRoomBilling').val(roomType.trim());
                callback($ddlRoomNo.val());
            }
            else {
                $ddlRoomNo.empty();
                callback($ddlRoomNo.val());
            }
        });
    };


    var $bindAdmissionType = function (callback) {
        $ddlAdmissionType = $('#ddlAdmissionType');
        serverCall('Services/IPDAdmission.asmx/AdmissionType', {}, function (response) {
            if (!String.isNullOrEmpty(response)) {
                $ddlAdmissionType.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ADMISSIONTYPE', textField: 'ADMISSIONTYPE', dataAttr: ['ADMISSIONTYPE'] });
                callback($ddlAdmissionType.val());
            }
            else {
                $ddlAdmissionType.empty();
                callback($ddlAdmissionType.val());
            }
        });
    };

    var $getAdmissionDoctors = function (callback) {
        var doctorsList = [];
        $('#divDoctorList ul li').each(function () {
            doctorsList.push({
                doctorID: this.id,
                doctorName: $(this).find('span').text()
            });
        });
        //if (doctorsList.length > 0)
        //    callback(doctorsList);
        //    // console.log(doctorsList);
        //else
        //    modelAlert("Please Select Doctor's");
        callback(doctorsList);

    }

    $getAdmissionDetails = function (callback) {
        $getAdmissionDoctors(function (doctorsList) {
            var inValidElem = null;
            $('#divAdmissionBedDetails .requiredField').each(function (index, elem) {
                if (String.isNullOrEmpty(elem.value) || elem.value == '0') {
                    inValidElem = elem;
                    modelAlert(this.attributes['errorMessage'].value, function () {
                        inValidElem.focus();
                    });
                    return false;
                }
            });
            if (String.isNullOrEmpty(inValidElem)) {
                var ignoreDelivery = $('#ddlIgnoreDelivery').val() == 'NO' ? true : false;
                var data = {
                    admissionDate: $('#txtAdmissionDate').val(),
                    admissionHour: $('#txtAdmissionTimeHour').val(),
                    admissionMinute: $('#txtAdmissionTimeMinute').val(),
                    admissionTimeMeridiem: $('#ddlAdmissionTimeMeridiem').val(),
                    roomType: $('#ddlRoomType').val(),
                    roomNo: $('#ddlRoomNo').val(),
                    roomBilling: $('#ddlRoomBilling').val(),
                    admissionType: $('#ddlAdmissionType').val(),
                    referSource: $('#ddlReferSource').val(),
                    requestRoomType: $('#ddlRequestRoomType').val(),
                    mlcNo: $('#txtMLCNO').val(),
                    mlcType: $('#ddlMlcType').val() == '0' ? '' : $('#ddlMlcType').val(),
                    IssuedVisitorCardNo: $('#txtIssuedVisitorCardNo').val(),
                    childWeight: (ignoreDelivery ? ($('#txtChildHeight').val() + '#' + $('#ddlChildHeight').val()) : ''),
                    childHeight: (ignoreDelivery ? ($('#txtChildWeight').val() + '#' + $('#ddlChildWeight').val()) : ''),
                    TypeOfDelivery: (ignoreDelivery ? $('#ddlDeliveryType').val() : ''),
                    DeliveryWeeks: (ignoreDelivery ? ($('#ddlDeliveryWeeks').val() + '.' + $('#ddlDeliveryDays').val()) : ''),
                    BirthIgnoreReason: $('#txtDeliveryIgnoreReason').val(),
                    isBirthDetail: $('.deliveryDetails').is(':visible') ? 1 : 0,
                    MotherTID: $('#spnIPDNo').text(),
                    AdmissionReason: $('#txtAdmissionReason').val(),
                    isIPDAdmissionAgainstAdvanceBooking: Number($('#lblIpdAdmissionAgainstAdvanceBooking').text()),
                    advanceId: Number($("#lblAdvanceId").text())
                }
                data.admissionTime = data.admissionHour + ':' + data.admissionMinute + ' ' + data.admissionTimeMeridiem;
                data.doctorsList = doctorsList;
                console.log(data);
                callback(data);
            }
        });
    }

    var $setAdmissionDetails = function (data, callback) {
        $('#txtAdmissionDate').val(data.DateOfAdmit).prop('disabled', true);
        $('#txtAdmissionTimeHour').val(data.Admithour);
        $('#txtAdmissionTimeMinute').val(data.AdmitMin);
        $('#ddlAdmissionTimeMeridiem').val(data.AdmitAMPM);
        $('#ddlRoomBilling').val(data.RommType_BillID).prop('disabled', true).chosen('destroy').chosen();
        $('#ddlAdmissionType').val(data.Admission_Type);
        $('#ddlReferSource').val(data.Source);
        $('#ddlRequestRoomType').val(data.RequestedRoomType);
        $('#txtMLCNO').val(data.MLC_NO);
        $('#ddlMlcType').val(data.MLC_Type);
        $('#txtIssuedVisitorCardNo').val(data.IssuedVisitorCardNo);
        $('#txtChildHeight').val(data.Height);
        $('#ddlChildWeight').val(data.Weight);
        /// childHeight: (ignoreDelivery ? ($('#txtChildWeight').val() + '#' + $('#ddlChildWeight').val()) : ''),
        $('#ddlDeliveryType').val(data.typeofdelivery);
        $('#ddlDeliveryWeeks').val(data.DeliveryWeeks);
        $('#txtAdmissionReason').val(data.AdmissionReason);
        $('#ddlDeliveryDays').val();
        $('#txtDeliveryIgnoreReason').val('');
        $('#ddlRoomType').val(data.RoomTypeID).prop('disabled', true).chosen('destroy').chosen();
        getAdmitedBedDetails(data.RoomTypeID, function () {
            $('#ddlRoomNo').val(data.RoomId).prop('disabled', true);//
        });
        var Count = 0;
        $(data.doctorsList).each(function () {
            if (!String.isNullOrEmpty(this.value)) {
                 
                if (this.IsTeam == 1) {
                    if (Count == 0) { 
                        $('#ddlDoctor').val(this.value).chosen("destroy").chosen();
                        Count = Count + 1;
                       
                    } 

                } else {
                    if (Count == 0) {
                       
                        $('#ddlDoctor').val(this.value).chosen("destroy").chosen();

                    }
                   
                } 
                bindAdmissionDoctors(this, function () {
                   
                });



            }
        });
        callback();
        //isBirthDetail: $('.deliveryDetails').is(':visible')?1:0,
    }


    var getAdmitedBedDetails = function (caseType, callback) {
        $ddlRoomNo = $('#ddlRoomNo');
        serverCall('Services/IPDAdmission.asmx/bindAdmittedRoomBed', { caseType: caseType, IsDisIntimated: '1' }, function (response) {
            if (!String.isNullOrEmpty(response)) {
                $ddlRoomNo.bindDropDown({ data: JSON.parse(response), valueField: 'RoomID', textField: 'Name' });
                callback($ddlRoomNo.val());
            }
            else {
                $ddlRoomNo.empty();
                callback($ddlRoomNo.val());
            }
        });
    }

    function Advanceroomcheck() {
        jQuery.ajax({
            url: "Services/IPDAdmission.asmx/AdvanceRoomCheck",
            data: '{Roomid:"' + jQuery('#ddlRoomNo').val() + '"}',
            type: "Post",
            contentType: "application/json;charset=utf-8",
            timeout: 120000,
            async: false,
            dataType: "json",
            success: function (result) {
                Data = jQuery.parseJSON(result.d);
                if (Data != null) {


                    $('#spnMRNo').text(Data[0].PatientID);
                    $('#spnPatientName').text(Data[0].PName);
                    $('#spnAdvanRoom').text(Data[0].Name);
                    $('#spnAddDate').text(Data[0].AdDate);
                    $('#divAdvancepatient').showModel();
                }

                else {
                    $('#spnMRNo').text('');
                    $('#spnPatientName').text('');
                    $('#spnAdvanRoom').text('');
                    $('#spnAddDate').text('');
                }
            }

        })
    }
</script>




<div id="divAdmissionBedDetails" class="row">
    <div class="col-md-21">
        <div class="row doctorName">
            <div class="col-md-3">
                <label class="pull-left">Doctor's Name     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-21">
                <div id="divDoctorList"  class="chosen-container-multi">
                    <ul id="ulDoctorList" style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                    </ul>
                </div>
            </div>
        </div>
        <div style="display: none" class="row deliveryDetails">
            <div class="col-md-3">
                <label class="pull-left">Baby Height     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2">
                <input type="text" autocomplete="off" errormessage="Enter Baby Height" id="txtChildHeight" />
            </div>
            <div class="col-md-3">
                <select id="ddlChildHeight" errormessage="Select Baby Height Unit" title="Select Child Height">
                    <option value="0">Select</option>
                    <option value="CM">CM</option>
                    <option value="MM">MM</option>
                    <option value="FT">FT</option>
                    <option value="INCH">INCH</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="pull-left">Baby Weight </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2">
                <input type="text" errormessage="Enter Baby Weight" id="txtChildWeight" />
            </div>
            <div class="col-md-3">
                <select id="ddlChildWeight" errormessage="Select Baby Weight Unit" title="Select Child Weight">
                    <option value="0">Select</option>
                    <option value="gm">gm</option>
                    <option value="kg">kg</option>
                    <option value="lb">lb</option>
                </select>
            </div>

            <div class="col-md-3">
                <label class="pull-left">Delivery Type</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlDeliveryType" errormessage="Select Delivery Type" title="Select Delivery Type">
                </select>
            </div>
        </div>
        <div style="display: none" class="row deliveryDetails">
            <div class="col-md-3">
                <label class="pull-left">Delivery Time     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
                <select id="ddlDeliveryWeeks" errormessage="Select Delivery Week" title="Select Weeks">
                    <option value="1">1 Week</option>
                    <option value="2">2 Weeks</option>
                </select>
            </div>
            <div class="col-md-2">
                <select id="ddlDeliveryDays" errormessage="Select Delivery Day" title="Select Days">
                    <option value="1">1 Day</option>
                    <option value="2">2 Days</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="pull-left">Ignore Delivery </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2">
                <select id="ddlIgnoreDelivery" onchange="$onDeliveryInfoIgnoreChange(this.value)" title="">
                    <option value="NO">NO</option>
                    <option value="YES">YES</option>
                </select>
            </div>
            <div class="col-md-11">
                <input type="text" autocomplete="off" errormessage="Enter Delivery Information Ignore Reason" id="txtDeliveryIgnoreReason" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">Admission Date     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <asp:TextBox ID="txtAdmissionDate" runat="server" ReadOnly="true" autocomplete="off" ClientIDMode="Static" ToolTip="Select Admission Date"></asp:TextBox>
                <cc1:CalendarExtender ID="CalendarExteAdmissionDate" TargetControlID="txtAdmissionDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
            </div>
            <div class="col-md-3">
                <label class="pull-left">Admission Time </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-1">
                <asp:TextBox ID="txtAdmissionTimeHour" onlynumber="2" max-value="12" runat="server" ClientIDMode="Static" ToolTip="Enter Hour" MaxLength="2"></asp:TextBox>
            </div>
            <div class="col-md-1">
                <asp:TextBox ID="txtAdmissionTimeMinute" onlynumber="2" max-value="59" runat="server" ClientIDMode="Static" ToolTip="Enter Minutes" MaxLength="2"></asp:TextBox>
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlAdmissionTimeMeridiem" runat="server" ClientIDMode="Static" ToolTip="Select Admission Time Meridiem">
                    <asp:ListItem Value="AM">AM</asp:ListItem>
                    <asp:ListItem Value="PM">PM</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-md-3">
                <label class="pull-left">Admission Type </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlAdmissionType" title="Select Admission Type"></select>
            </div>

        </div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">Ward Type </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlRoomType" onchange="$bindRoomBed(this.value,function(){})" title="Select Room Type"></select>
            </div>
            <div class="col-md-3">
                <label class="pull-left">Ward/BedNo     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlRoomNo" title="Select Bed No" onchange="Advanceroomcheck();"></select>
            </div>
            <div class="col-md-3">
                <label class="pull-left">Billing Category </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlRoomBilling" title="Select Billing Category"></select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">Refered Source     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlReferSource" title="Select Refered Source">
                    <option value="0">Select</option>
                    <option value="OPD">OPD</option>
                    <option value="Emergency">Emergency</option>
                    <option value="OutSide">OutSide</option>
                </select>
            </div>
           <div class="col-md-3">
                <label class="pull-left">AdmissionReason</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-13">
                <input type="text" id="txtAdmissionReason" maxlength="500" autocomplete="off" data-title="Enter Admission Reason" />
            </div>

        </div>
        <div class="row" style="display:none">
             <div class="col-md-3">
                <label class="pull-left">Request Ward </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlRequestRoomType" title="Select Billing Category"></select>
            </div>

            <div class="col-md-3">
                <label class="pull-left" >Visitor Card Qty</label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5" >
                <input type="text" id="txtIssuedVisitorCardNo" onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)});" autocomplete="off" data-title="Enter issued visitor card No." onlynumber="50" />
            </div>

        </div>
        <div class="row mlcDetail">
            <%--  <div class="col-md-3">
                <label class="pull-left">MLC NO.     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2">
                <input type="text" autocomplete="off" id="txtMLCNO" />

            </div>
            <div class="col-md-3">
                <select id="ddlMlcType" title="Select MLC Type">
                    <option value="0">Select</option>
                    <option value="RTA">RTA</option>
                    <option value="Poisoining">Poisoining</option>
                    <option value="Burns">Burns</option>
                    <option value="Hanging">Hanging</option>
                    <option value="Assaults">Assaults</option>
                </select>
            </div>--%>
            <div class="col-md-3">
            </div>
            <div class="col-md-5">
            </div>

            <div class="col-md-3">
                <label class="pull-left"></label>
                <b class="pull-right"></b>
            </div>
            <div class="col-md-5">
            </div>

            <div class="col-md-3">
                <label class="pull-left"></label>
                <b class="pull-right"></b>
            </div>
            <div class="col-md-5">
            </div>
        </div>

    </div>
    <div class="col-md-3">
    </div>
</div>

<div id="divAdvancepatient" class="modal fade ">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 450px;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divAdvancepatient" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Advance Room Booked Patient Details</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-10">
                        <label class="pull-left">UHID</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-14">
                        <span id="spnMRNo"></span>
                    </div>
                </div>


                <div class="row">
                    <div class="col-md-10">
                        <label class="pull-left">PatientName</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-14">
                        <span id="spnPatientName"></span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-10">
                        <label class="pull-left">Room Name/BedNo.</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-14">
                        <span id="spnAdvanRoom"></span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-10">
                        <label class="pull-left">AddmissionDate</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-14">
                        <span id="spnAddDate"></span>
                    </div>

                </div>

                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var $bindDeliverytypes = function (callback) {
        var $ddlDeliveryType = $('#ddlDeliveryType');
        serverCall('Services/IPDAdmission.asmx/bindDeliveryType', {}, function (response) {
            $ddlDeliveryType.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select' });
            callback($ddlDeliveryType.val());
        });
    }

    var $bindDeliveryWeeks = function (callback) {
        var $ddlDeliveryWeeks = $('#ddlDeliveryWeeks');
        serverCall('Services/IPDAdmission.asmx/bindDeliveryWeeks', {}, function (response) {
            $ddlDeliveryWeeks.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select' });
            callback($ddlDeliveryWeeks.val());
        });
    }

    var $bindDeliveryDays = function (callback) {
        var $ddlDeliveryDays = $('#ddlDeliveryDays');
        serverCall('Services/IPDAdmission.asmx/bindDeliveryDays', {}, function (response) {
            $ddlDeliveryDays.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select' });
            callback($ddlDeliveryDays.val());
        });
    }

    var $onDeliveryInfoIgnoreChange = function (deliveryIgnore) {
        if (deliveryIgnore == 'NO') {
            $('.deliveryDetails').find('input,select').not('#ddlIgnoreDelivery,#txtDeliveryIgnoreReason').val('').prop('selectedIndex', 0).prop('disabled', false).addClass('requiredField');
            $('#txtDeliveryIgnoreReason').val('').removeClass('requiredField').prop('disabled', true);
        }
        else {
            $('.deliveryDetails').find('input,select').not('#ddlIgnoreDelivery,#txtDeliveryIgnoreReason').val('').prop('selectedIndex', 0).prop('disabled', false).removeClass('requiredField');
            $('#txtDeliveryIgnoreReason').addClass('requiredField').prop('disabled', false);
        }
    }

</script>
