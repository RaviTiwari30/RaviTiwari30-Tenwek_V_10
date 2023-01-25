<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SearchPatientTransferOnRequest.aspx.cs" Inherits="Design_IPD_SearchPatientTransferOnRequest" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <script type="text/javascript">
      
        $(document).ready(function () {
            $bindAllCentre(function () { });
            $bindMandatory(function () { });
            $bindRoomType(function () { });

        });
        $bindRoomType = function (callback) {
            $ddlRoomType = $('#ddlRoomType');
            serverCall('Services/IPDAdmission.asmx/bindRoomType', {}, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    $ddlRoomType.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'IPDCaseTypeID', textField: 'Name', isSearchAble: true });
                    callback($ddlRoomType.val());
                }
                else {
                    $ddlRoomType.empty();
                    callback($ddlRoomType.val());
                }
            });
        };
        var $bindRoomBed = function (roomType, callback) {
            debugger;
            $ddlRoomNo = $('#ddlRoomNo');
            serverCall('Services/IPDAdmission.asmx/bindRoomBed', { caseType: roomType, IsDisIntimated: '0', type: '0', bookingDate:'' }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    $ddlRoomNo.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'RoomId', textField: 'Name', isSearchAble: true });
                    $('#ddlRoomBilling').val(roomType.trim());
                    callback($ddlRoomNo.val());
                }
                else {
                    $ddlRoomNo.empty();
                    callback($ddlRoomNo.val());
                }
            });
        };
        var $bindMandatory = function (callback) {
            var manadatory = [
				{ control: '#txtNameofcaller', isRequired: true, erroMessage: 'Please Enter Caller Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtReturnPhoneNo', isRequired: true, erroMessage: 'Enter Return PhoneNo', tabIndex: 2, isSearchAble: false },
                { control: '#txtRefferingHospital', isRequired: true, erroMessage: 'Enter Reffering Hospital Name', tabIndex: 3, isSearchAble: false },
                { control: '#txtInchargeDoctor', isRequired: true, erroMessage: 'Enter Doctor Incharge Name', tabIndex: 4, isSearchAble: false },
                { control: '#txtPname', isRequired: true, erroMessage: 'Enter Patient Name', tabIndex: 5, isSearchAble: false },
                { control: '#txtAge', isRequired: true, erroMessage: 'Enter Age', tabIndex: 6, isSearchAble: false },
            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
                $(manadatory[0].control).focus();
            });
            callback(true);
        }

        var $bindAllCentre = function (callback) {
            serverCall('../EDP/CenterManagement/CenterManagement.asmx/BindAllCentre', {}, function (response) {
                $Centre = $('#ddlRefferingHospital');
                var responseData = JSON.parse(response);
                var Centredata = responseData.filter(function (i) { return i.CentreID != '<%=Session["CentreID"]%>' });
                var DefaultValue = "Select";
                $Centre.bindDropDown({ defaultValue: DefaultValue, data: Centredata, valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: DefaultValue });
                callback($Centre);
            });

           }

        function Search() {
            var data = {
                FromDate: $('#txtFromDate').val(),
                ToDate: $('#txtToDate').val(),
                patientID: $('#txtPatientID').val(),
                PatientCategory: $('input[type=radio][name=PatientTransferCategory]:checked').val(),
            }

            serverCall('../IPD/Services/IPD.asmx/PatientTransferSearch', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    bindTransferonrequestPatient(responseData);
                    $('#divEditTransferRequest').hide();
                }
                else { modelAlert(responseData.response); }
            });
        }
        function bindTransferonrequestPatient(data) {
            $('#tblTrnasferDetail tbody').empty();

            for (var i = 0; i < data.length; i++) {
                var j = $('#tblTrnasferDetail tbody tr').length + 1;
                var row = '<tr style="background-color:' + data[i].rowcolour + ';">';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdPatientID" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PatientID + '</td>';
                if (data[i].PatientTransferCategory == '1') {
                    row += '<td id="tdTransferFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TransferFrom + '</td>';
                } else { row += '<td id="tdTransferFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].OutsidePDetails.split('#')[4] + '</td>'; }
                row += '<td id="tdPName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Pname + '</td>';
                row += '<td id="tdAge" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Age + '</td>';
                row += '<td id="tdMobile" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Mobile + '</td>';
                row += '<td id="tdMobile" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].InchargeDoctor + '</td>';
                row += '<td id="tdTransferDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TransferDate + '</td>';
                row += '<td id="tdDiagnosisReason" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DiagnosisReason + '</td>';
                row += '<td id="tdManagmentStatusReason" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ManagmentStatusReason + '</td>';
                row += '<td id="tdNeedIcuandHdu" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].NeedIcuandHdu + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/print.gif" onclick="print(' + data[i].ID + ');" style="cursor: pointer;" title="Click To print" /></td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '<td id="tdFromCentreID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CentreIDFrom + '</td>';
                row += '<td id="tdCentreIDTo" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CentreIDTo + '</td>';
                row += '<td id="tdInchargeDoctorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].InchargeDoctorID + '</td>';
                row += '<td id="tdStatusDetails" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].StatusDetails + '</td>';
                row += '<td id="tdAlldiscussionDetails" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].AlldiscussionDetails + '</td>';
                row += '<td id="tdGender" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Gender + '</td>';
                row += '<td id="tdTransactionID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TransactionID + '</td>';
                row += '<td id="tdCallerName" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CallerName + '</td>';
                row += '<td id="tdReturnPhoneNo" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ReturnPhoneNo + '</td>';
                row += '<td id="tdOutsidePatientVital" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].OutsidePatientVital + '</td>';
                row += '<td id="tdOutsidePDetails" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].OutsidePDetails + '</td>';
                

                row += '</tr>';
                $('#tblTrnasferDetail tbody').append(row);

            }

        }

        function Edit(el) {
            $('#divEditTransferRequest').show();
            var PTCategory = $('input[type=radio][name=PatientTransferCategory]:checked').val();
            if (PTCategory == '1') { $('.InternalTransfer').show(); $('.OutsideTransfer').hide(); }
            else { $('.InternalTransfer').hide(); 
                $('.OutsideTransfer').show(); }

            
            var row = $(el).closest('tr');
            $('#spnTransferRequestID').text($(row).find('#tdAID').text());
            $('#spnPatientID').text($(row).find('#tdPatientID').text());
            $('#spnTransactionID').text($(row).find('#tdTransactionID').text());
            $('#spnGender').text($(row).find('#tdGender').text());
            var ToCentreID = $(row).find('#tdCentreIDTo').text();
            $('#ddlRefferingHospital').val(ToCentreID).chosen('destroy').chosen();
            var InchargeDoctorID = $(row).find('#tdInchargeDoctorID').text();
            var FromCentreID = $(row).find('#tdFromCentreID').text();
            $bindSelectedReffereingHospitalDoctor(FromCentreID, function () {
                $('#ddlInchargeDoctor').val(InchargeDoctorID).trigger("chosen:updated");
            });
            $('#txtNameofcaller').val($(row).find('#tdCallerName').text());
            $('#txtReturnPhoneNo').val($(row).find('#tdReturnPhoneNo').text());
            $('#txtDiagnosisReason').val($(row).find('#tdDiagnosisReason').text());
            $('#txtManagementReason').val($(row).find('#tdManagmentStatusReason').text());
            if ($(row).find('#tdNeedIcuandHdu').text() == "Yes") {
                $('#chkUseICU').prop('checked', true);
            }
            if ($(row).find('#tdStatusDetails').text().split('#')['0'] == "0") {
                $('#btnReceived').prop('disabled', true);
                $('#btnAdmission').prop('disabled', true); 
                $('#btnPatientRegister').prop('disabled', true); 
            }

            else if ($(row).find('#tdStatusDetails').text().split('#')['1'] == "0") {
                $('#btnAdmission').prop('disabled', true);
                $('#btnReceived').prop('disabled', false);
                $('#btnAcknowledge').prop('disabled', true);
                $('#btnPatientRegister').prop('disabled', true);
            }
            else if ($(row).find('#tdStatusDetails').text().split('#')['3'] == "0") {
                $('#btnReceived').prop('disabled', true);
                $('#btnAcknowledge').prop('disabled', true);
                $('#btnAdmission').prop('disabled', false);
                $('#btnPatientRegister').prop('disabled', true);
            }
            else if ($(row).find('#tdStatusDetails').text().split('#')['2'] == "0")  {
                $('#btnReceived').prop('disabled', true);
                $('#btnAcknowledge').prop('disabled', true);
                var CurrentCentreID='<%=Session["CentreID"].ToString()%>';
                if(CurrentCentreID==$(row).find('#tdCentreIDTo').text())
                {
                    $('#btnAdmission').prop('disabled', false);
                }else{ $('#btnAdmission').prop('disabled', true);}
                $('#btnPatientRegister').prop('disabled', true);
            }


            if ($(row).find('#tdAlldiscussionDetails').text().split('#')[0] != "") {
                RefferedDoctor($('#ddlRefferingHospital').val(), function () {
                    $('#ddlDiscussInchargeName').val($(row).find('#tdAlldiscussionDetails').text().split('#')[0]).trigger("chosen:updated");
                    $('#chkDiscusswithcons').prop('checked', true);
                });
                $('#txtDiscussInchargeName').val($(row).find('#tdAlldiscussionDetails').text().split('#')[0]); $('#txtDiscussInchargeName').show();
            }
            else { $('#ddlDiscussInchargeName').hide(); RefferedDoctor($('#ddlRefferingHospital').val(), function () { }); }

            if ($(row).find('#tdAlldiscussionDetails').text().split('#')[1] != "")
            { $('#chkDiscusswithresident').prop('checked', true); $('#txtDiscusswithResident').val($(row).find('#tdAlldiscussionDetails').text().split('#')[1]); $('#txtDiscusswithResident').show(); }
            if ($(row).find('#tdAlldiscussionDetails').text().split('#')[2] != "")
            { $('#chkDiscusswithintern').prop('checked', true); $('#txtDiscusswithintern').val($(row).find('#tdAlldiscussionDetails').text().split('#')[2]); $('#txtDiscusswithintern').show(); }
            if ($(row).find('#tdAlldiscussionDetails').text().split('#')[3] != "")
            { $('#chkCallbackdiscussion').prop('checked', true); $('#txtcallbackDiscussion').val($(row).find('#tdAlldiscussionDetails').text().split('#')[3]); $('#txtcallbackDiscussion').show(); }

            $('#txtRefferingHospital').val($(row).find('#tdOutsidePDetails').text().split('#')[4]);
            $('#txtInchargeDoctor').val($(row).find('#tdOutsidePDetails').text().split('#')[5]);
            if ($(row).find('#tdOutsidePDetails').text().split('#')[0] != "CASH") {
                $('#rdNHIF').prop('checked', true); $('#txtNHIFCardNo').val($(row).find('#tdOutsidePDetails').text().split('#')[1]); $('#txtNHIFCardNo').show();
            }
            if ($(row).find('#tdOutsidePDetails').text().split('#')[0] != "0") { $('#chkBillingOfficer').prop('checked', true); }
            $('#txtReason').val($(row).find('#tdOutsidePDetails').text().split('#')[3]);

            $('#txtVitalGCS').val($(row).find('#tdOutsidePatientVital').text().split('#')[0]);
            $('#txtPulse').val($(row).find('#tdOutsidePatientVital').text().split('#')[1]);
            $('#txtBPsystolic').val($(row).find('#tdOutsidePatientVital').text().split('#')[2].split('/')[0]);
            $('#txtBPdiastolic').val($(row).find('#tdOutsidePatientVital').text().split('#')[2].split('/')[1]);
            $('#txtRR').val($(row).find('#tdOutsidePatientVital').text().split('#')[3]);
            $('#txtSAT').val($(row).find('#tdOutsidePatientVital').text().split('#')[4]);
            $('#txtTemperature').val($(row).find('#tdOutsidePatientVital').text().split('#')[5]);
            $('#txtAge').val($(row).find('#tdAge').text().split(' ')[0]);
            $('#ddlAge').val($(row).find('#tdAge').text().split(' ')[1]);
            $('#txtPname').val($(row).find('#tdPName').text());
        }

        var $bindSelectedReffereingHospitalDoctor = function (FromCentreID, callback) {
            serverCall('../IPD/Services/IPD.asmx/BindSelctedReffereHospital', { RefferingHospital: FromCentreID }, function (response) {
                var $DoctorList = $('#ddlInchargeDoctor');
                $DoctorList.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Dname', isSearchAble: true, selectedValue: 'Select' });
                callback($DoctorList);
            });

        }
        function Discusswithresident() {
            var i = $('#chkDiscusswithresident').is(":checked")
            if (i == true) {
                $('#txtDiscusswithResident').show();
            }
            else { $('#txtDiscusswithResident').hide(); }
        }
        function Discusswithcallback() {
            var i = $('#chkCallbackdiscussion').is(":checked")
            if (i == true) {
                $('#txtcallbackDiscussion').show();
            }
            else { $('#txtcallbackDiscussion').hide(); }
        }
        function DiscusswithConsultant() {
            var i = $('#chkDiscusswithcons').is(":checked")
            if (i == true) {
                $('#ddlDiscussInchargeName').show().chosen();
                $('#txtDiscussInchargeName').show();

            }
            else { $('#ddlDiscussInchargeName').hide(); $('#txtDiscussInchargeName').hide(); }
        }
        function Discusswithintern() {
            var i = $('#chkDiscusswithintern').is(":checked")
            if (i == true) {
                $('#txtDiscusswithintern').show();
            }
            else { $('#txtDiscusswithintern').hide(); }
        }
        function NHIFCardNo() {
            var i = $('#rdNHIF').is(":checked");
            if (i == true)
            { $('#txtNHIFCardNo').show(); }
            else { $('#txtNHIFCardNo').hide(); }
        }
        function Save() {
          
            $getPatientRequestDetails(function (PatientRequestDetails) {
                serverCall('../IPD/Services/IPD.asmx/SaveEditPatientTransferRequest', PatientRequestDetails, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status)
                    { modelAlert(responseData.response); }
                    else { modelAlert(responseData.response); }
                });
            });
        }
        $getPatientRequestDetails = function (callback) {

            var validateStatus = true;
            $('#Pbody_box_inventory .requiredField').each(function (index, elem) {
                if ($.trim($(elem).val()) == '' || $.trim($(elem).val()) == '0') {
                    validateStatus = false;
                    modelAlert(this.attributes['errorMessage'].value, function () {
                    });
                    return false;
                }
            });
            if (!validateStatus)
                return false;

            var DiscussWithConsultantName = "";
            if ($('input[type=radio][name=PatientTransferCategory]:checked').val() == "1")
            { DiscussWithConsultantName = $('#chkDiscusswithcons').is(':checked') ? $('#ddlDiscussInchargeName').val() : ''; }
            else { DiscussWithConsultantName = $('#chkDiscusswithcons').is(':checked') ? $('#txtDiscussInchargeName').val() : ''; }

            PTransferDetail = [];
            PTransferDetail.push({
                CallerName: $('#txtNameofcaller').val().trim(),
                ReturnPhoneNo: $('#txtReturnPhoneNo').val().trim(),
                OutSideRefferingHospitalName: $('#txtRefferingHospital').val().trim(),
                OutSideInchargeDoctor: $('#txtInchargeDoctor').val().trim(),
                OutSidePName: $('#txtPname').val().trim(),
                OutSideAge: $('#txtAge').val() + ' ' + $('#ddlAge').val(),
                OutSideVitalGCS: $('#txtVitalGCS').val().trim(),
                OutSideVitalPulse: $.trim($('#txtPulse').val()),
                OutSideVitalBP: $.trim($('#txtBPsystolic').val()) + '/' + $.trim($('#txtBPdiastolic').val()),
                OutSideVitalRR: $.trim($('#txtRR').val()),
                OutSideVitalSAT: $.trim($('#txtSAT').val()),
                OutSideVitalTemp: $.trim($('#txtTemperature').val()),
                OutSideModeofPayment: $('input[type=radio][name=PaymentMode]:checked').val(),
                OutSideNHIFCardNo: $.trim($('#txtNHIFCardNo').val()),
                OutSideIsBillingOfficer: $('#chkBillingOfficer').is(':checked') ? '1' : '0',
                OutSideReason: $.trim($('#txtReason').val()),
                OutSideRefferingHospitalName: $.trim($('#txtRefferingHospital').val()),
                DiagnosisReason: $.trim($('#txtDiagnosisReason').val()),
                ManagmentStatusReason: $.trim($('#txtManagementReason').val()),
                NeedIcuandHdu: $('#chkUseICU').is(':checked') ? '1' : '0',
                DiscussWithConsultantName: DiscussWithConsultantName,
                DiscussWithResidentName: $('#chkDiscusswithresident').is(':checked') ? $('#txtDiscusswithResident').val() : '',
                DiscussWithInternName: $('#chkDiscusswithintern').is(':checked') ? $('#txtDiscusswithintern').val() : '',
                CallBackAfterDiscussionName: $('#chkCallbackdiscussion').is(':checked') ? $('#txtcallbackDiscussion').val() : '',
                CentreIDTo: $('#ddlRefferingHospital').val(),
                InchargeDoctorID: $('#ddlInchargeDoctor').val(),
                ID: $('#spnTransferRequestID').text(),
                PatientTransferCategory: $('input[type=radio][name=PatientTransferCategory]:checked').val(),
                RoomTypeID: $('#ddlRoomType').val(),
                RoomNoId: $('#ddlRoomNo').val(),

            });
            callback({ PTransferDetail: PTransferDetail });
        }
        function CheckAge(sender) {
            var AfterDecimal = sender.value.split('.')[1];
            var BrforeDecimal = sender.value.split('.')[0];
            if ($('#ddlAge').val() == 'YRS') {
                if (AfterDecimal > 11) {
                    modelAlert('Invalid Age', function () {
                        sender.focus();
                        sender.value = '';
                    });
                }
            }
            else if ($('#ddlAge').val() == 'MONTH(S)') {
                if (AfterDecimal > 30 || BrforeDecimal > 11) {
                    modelAlert('Invalid Age', function () {
                        sender.focus();
                        sender.value = '';
                    });
                }
            }
            else {
                if (BrforeDecimal > 30 || AfterDecimal > 23) {
                    modelAlert('Invalid Age', function () {
                        sender.focus();
                        sender.value = '';
                    });

                }
            }
        }

        function RefferingDoctor(el) {
            RefferedDoctor(el, function () { });
        }
        var RefferedDoctor = function (el, callback) {
            serverCall('../IPD/Services/IPD.asmx/RefferingDoctor', { centreID: el }, function (response) {
                $RefferingDoctorList = $('#ddlDiscussInchargeName');
                $RefferingDoctorList.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Dname', isSearchAble: true, selectedValue: 'Select' });
                callback($RefferingDoctorList);
            });
        }

        function wopen(url, name, w, h) {

            //w += 200;
            //h += 100;
            var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
            win.resizeTo(w, h);
            win.moveTo(10, 100);
            win.focus();
        }


        function OpenVitalPage(el) {
            wopen('../IPD/IPD_Patient_ObservationChart.aspx?TID=' + $('#spnTransactionID').text() + '&TransactionID=' + $('#spnTransactionID').text() + '&App_ID=&PID=' + $('#spnPatientID').text() + '&PatientId=' + $('#spnPatientID').text() + '&Sex=' + $('#spnGender').text() + '&IsIPDData, popup1', 5000, 1200);
        } 
        function Admission() {
            
           // wopen('../IPD/IPDAdmissionNew.aspx?PID=' + $('#spnPatientID').text() + '&IsIPDAdmission=1', 5000, 1200);
            wopen('../Emergency/EmergencyAdmission.aspx?PName=' + $('#txtPname').val() + '&TransferRequestID=' + $('#spnTransferRequestID').text() + '&MobileNo=' + $('#txtReturnPhoneNo').val() + '&Age=' + $('#txtAge').val() + '&Type=' + $('#ddlAge').val(), 5000, 1200);
        }
        function PatientRegistration() {
            wopen('../OPD/DirectPatientReg.aspx?PName=' + $('#txtPname').val() + '&MobileNo=' + $('#txtReturnPhoneNo').val() + '&Age=' + $('#txtAge').val() + " " + $('#ddlAge').val() + '&TransferRequestID=' + $('#spnTransferRequestID').text() + '', 5000, 1200);
        }
        function AckPatient() {
            modelConfirmation('Confirmation!!!', 'Are You Sure To Acknowledge This Patient', 'Continue', 'Close', function (response) {
                if (response) {
                    serverCall('../IPD/Services/IPD.asmx/PatientTransferRequestAcknowledge', { ID: $('#spnTransferRequestID').text() }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) { modelAlert(responseData.response, function () { Search(); }); }
                        else { modelAlert(responseData.response); }
                    });
                }
            });
        }
        function ReceivePatient() {
            modelConfirmation('Confirmation!!!', 'Are You Sure To Receive The Patient', 'Continue', 'Close', function (response) {
                if (response) {
                    serverCall('../IPD/Services/IPD.asmx/PatientTransferRequestReceive', { ID: $('#spnTransferRequestID').text() }, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) { modelAlert(responseData.response, function () { Search(); }); }
                        else { modelAlert(responseData.response); }
                    });
                }
            });
        }
        function print(id)
        {
            window.open(
                         "./TenwekReferralDocumentationForm.aspx?TestID=O23&LabType=&LabreportType=11&PID=" + id,
                          '_blank' // <- This is what makes it open in a new window.
                        );
            
        }
        function ClearPatientDetails()
        {
            $('#tblTrnasferDetail tbody').empty();
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Transfer On Request</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>           
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">UHID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtPatientID" title="Please Enter Patient UHID" />
                </div>
            </div>
             <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Patient Transfer Category</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-20">
                    <input type="radio" id="rdoInternalCentres" value="1" name="PatientTransferCategory" checked="checked"  onclick="ClearPatientDetails();"/>All Internal Centres
                    <input type="radio" id="rdoOtherHospital" value="2" name="PatientTransferCategory" onclick="ClearPatientDetails();" />Other Hospitals
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">             
            <div class="row" >
                 <div class="col-md-7">
                       <label style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color:lightgreen ;" class="circle"></label>
                       <b style="margin-top: 5px; margin-left: 5px; float: left">Acknowledged</b>
                       <label style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color:yellow;" class="circle"></label>
                       <b style="margin-top: 5px; margin-left: 5px; float: left">Received</b>
                       <label style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: orange;" class="circle"></label>
                       <b style="margin-top: 5px; margin-left: 5px; float: left">Register</b>
                 </div>
                <div class="col-md-17" style="text-align: center;">
                    <input type="button" id="btnSearch" value="Search" onclick="Search()" />
                </div>
            </div>
        </div>          
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblTrnasferDetail" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle">PatientID</th>
                                <th class="GridViewHeaderStyle">Transfer Hos.Name</th>
                                <th class="GridViewHeaderStyle">PName</th>
                                <th class="GridViewHeaderStyle">Age/Gender</th>
                                <th class="GridViewHeaderStyle">Mobile</th>
                                <th class="GridViewHeaderStyle">Incharge Doctor</th>
                                <th class="GridViewHeaderStyle">Transfer Date</th>
                                <th class="GridViewHeaderStyle">Diagnosis Reason</th>
                                <th class="GridViewHeaderStyle">ManagmentStatusReason</th>
                                <th class="GridViewHeaderStyle">NeedIcuandHdu</th>
                                <th class="GridViewHeaderStyle">Edit</th>
                                <th class="GridViewHeaderStyle">Print</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div id="divEditTransferRequest" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 474px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divEditTransferRequest" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Edit Patient Transfer Request </h4>
                    <span class="hidden" id="spnTransferRequestID"></span>
                    <span class="hidden" id="spnPatientID"></span>
                    <span class="hidden" id="spnTransactionID"></span>
                    <span class="hidden" id="spnGender"></span>
                </div>
                <div class="modal-body">
                    <div id="divPatientRequestFromCentre">
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Name Of Caller</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtNameofcaller" title="Please Enter Name Of Caller " />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">Return Phone No</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtReturnPhoneNo" title="Please Enter Phone " onlynumber="10" />
                            </div>
                            <div class="col-md-4">
                            </div>
                        </div>
                        <div class="row OutsideTransfer">
                            <div class="col-md-5">
                                <label class="pull-left">Patient Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtPname" title="Please Enter Patient Name" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">Patient Age</label>
                                <b class="pull-right">:</b>
                            </div>
                           <div class="col-md-2">
						        <input type="text" id="txtAge" onlynumber="5"  decimalplace="2"   max-value="120"  autocomplete="off" onkeyup="CheckAge(this);"  maxlength="5" data-title="Enter Age"   />
		           </div>
		          <div class="col-md-3">
						        <select id="ddlAge"   >
								        <option value="YRS">YRS</option>
								        <option value="MONTH(S)">MONTH(S)</option>
								        <option value="DAYS(S)">DAYS(S)</option>
							        </select>
		           </div>
                            <div class="col-md-4">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Reffering Hospital</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 InternalTransfer">
                                <select id="ddlRefferingHospital" onchange="RefferingDoctor(this.value);"></select>

                            </div>
                            <div class="col-md-5 OutsideTransfer">
                                <input type="text" id="txtRefferingHospital" onchange="RefferingDoctor(this.value);" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">Incharge Doctor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5 InternalTransfer">
                                <select id="ddlInchargeDoctor"></select>
                            </div>
                            <div class="col-md-5 OutsideTransfer">
                                <input type="text" id="txtInchargeDoctor" />
                            </div>
                            <div class="col-md-4 InternalTransfer">
                                <input type="button" id="btnVital" title="Enter Vital" value="Enter Vital" onclick="OpenVitalPage();" class="ItDoseButton" />
                            </div>
                        </div>
                        <div class="row OutsideTransfer">
                            <div class="col-md-5">
                                <label class="pull-left">Patient Vital</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">GCS</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="text" id="txtVitalGCS" title="Please Enter GCS" />
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">Pul.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="text" id="txtPulse" title="Please Enter Pulse Value" />
                            </div>
                            <div class="col-md-1">
                                <label class="pull-left">BP</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="text" id="txtBPsystolic" title="Please Enter Systolic Value" />
                            </div>
                            <div class="col-md-1"><span class="pull-centre">/</span></div>
                            <div class="col-md-1">

                                <input type="text" id="txtBPdiastolic" title="Please Enter Diastolic Value" />
                            </div>
                            <div class="col-md-1">
                                <label class="pull-left">RR</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="text" id="txtRR" title="Please Enter RR" />
                            </div>
                            <div class="col-md-1">
                                <label class="pull-left">O2</label>
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">SAT</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="text" id="txtSAT" title="Please Enter SAT Value" />

                            </div>
                            <div class="col-md-1">
                                <label class="pull-left">%</label>
                            </div>

                            <div class="col-md-1">
                                <label class="pull-left">T</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="text" id="txtTemperature" title="Please Enter Temperature" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Diagnosis Reason</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-19">
                                <input type="text" id="txtDiagnosisReason" title="Please Enter Patient Diagnosis Reason" class="requiredField" />

                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Management Done</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-19">

                                <input type="text" id="txtManagementReason" title="Please Enter Reason" />

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Need ICU/HUD</label>
                                <b class="pull-right">:</b>

                            </div>
                            <div class="col-md-19">

                                <input type="checkbox" id="chkUseICU" title="If You Need ICU/HDU" />
                            </div>
                        </div>
                    </div>
                    <div id="divPatientRequestToCentre">
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Discuss With Consultant</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="checkbox" id="chkDiscusswithcons" title="If Check'It Means Yes'" onclick="DiscusswithConsultant();" />

                            </div>
                            <div class="col-md-4 InternalTransfer">
                                <select id="ddlDiscussInchargeName" title="Please Enter Discusse Incharge Name" style="display: none"></select>
                            </div>
                            <div class="col-md-4 OutsideTransfer">
                                <input type="text" id="txtDiscussInchargeName" title="Please Enter Discusse Incharge Name" style="display: none" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">Discuss With Resident</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">
                                <input type="checkbox" id="chkDiscusswithresident" title="If Check'It Means Yes'" onclick="Discusswithresident();" />
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtDiscusswithResident" title="Please Enter Discuss With Resident Name" style="display: none" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">Discuss With Intern</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">

                                <input id="chkDiscusswithintern" type="checkbox" title="If Check'It Means Yes'" onclick="Discusswithintern();" />
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtDiscusswithintern" title="Please Enter Discuss With Intern Name" style="display: none" />
                            </div>
                            <div class="col-md-5">
                                <label class="pull-left">Call Back After Discussion</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-1">

                                <input type="checkbox" id="chkCallbackdiscussion" title="If Check'It Means Yes'" onclick="Discusswithcallback();" />
                            </div>
                            <div class="col-md-4">
                                <input type="text" id="txtcallbackDiscussion" title="Please Enter Discuss With Call Back After Discussion Name" style="display: none" />
                            </div>

                        </div>
                         <div class="row">
                            <div class="col-md-5">
                                <label class="pull-left">RoomType</label>
                                <b class="pull-right">:</b>
                            </div>
                              <div class="col-md-5">
                <select id="ddlRoomType" onchange="$bindRoomBed(this.value,function(){})" title="Select Room Type"></select>
            </div>
                             <div class="col-md-5">
                <label class="pull-left">Room/BedNo     </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <select id="ddlRoomNo" title="Select Bed No" "></select>
            </div>
                             </div>
                    </div>

                    <div class="Purchaseheader OutsideTransfer">
                        Billing 
                    </div>
                    <div class="row OutsideTransfer">
                        <div class="col-md-5">
                            <label class="pull-left">Mode Of Payment?</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" id="rdCash" name="PaymentMode" onclick="NHIFCardNo();" checked="checked" value="CASH" />Cash
                    <input type="radio" id="rdNHIF" name="PaymentMode" onclick="NHIFCardNo();" value="NHIF" />NHIF
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtNHIFCardNo" title="Please Enter NHIF Card" style="display: none" />
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">Billing Officer/NHIF</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <input id="chkBillingOfficer" type="checkbox" title="If Check'It Means Yes'" onclick="Discusswithintern();" />
                        </div>

                    </div>
                    <div class="row OutsideTransfer">
                        <div class="col-md-5">
                            <label class="pull-left">Reason</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <input type="text" id="txtReason" title="Please Enter Reason" />
                        </div>
                    </div>

                    <div class="row" style="text-align: center">
                        <div class="col-md-3"></div>
                        <div class="col-md-3">
                            <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="Save();" />
                        </div>
                        <div class="col-md-3">
                            <input type="button" value="AckPatient" id="btnAcknowledge" title="Acknowledge A Patient Request" onclick="AckPatient();" />
                        </div>
                        <div class="col-md-3">
                            <input type="button" value="Received" id="btnReceived" title="Recived A patient" onclick="ReceivePatient();" />
                        </div>
                          <div class="col-md-3" style="display:none">
                            <input type="button" value="Register" id="btnPatientRegister" title="Patient Register" onclick="PatientRegistration();"/>
                        </div>
                        <div class="col-md-3">
                            <input type="button" value="Admission" id="btnAdmission" title="Patient Admission" onclick="Admission();"/>
                        </div>
                        <div class="col-md-6"></div>

                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="divEditTransferRequest">Close</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
