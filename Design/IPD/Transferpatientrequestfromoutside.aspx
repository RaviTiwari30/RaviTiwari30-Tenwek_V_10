<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TransferPatientRequestFromOutside.aspx.cs" Inherits="Design_IPD_TransferPatientRequestFromOutside" MasterPageFile="~/DefaultHome.master" %>

<asp:Content ID="Conent1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <script type="text/javascript">
        $(document).ready(function () {
            $bindMandatory(function () { });
        });
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
        function DiscusswithConsultant() {
            var i = $('#chkDiscusswithcons').is(":checked")
            if (i == true) {
                $('#txtDiscussInchargeName').show();
            }
            else { $('#txtDiscussInchargeName').hide(); }
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
        function Discusswithintern() {
            var i = $('#chkDiscusswithintern').is(":checked")
            if (i == true) {
                $('#txtDiscusswithintern').show();
            }
            else { $('#txtDiscusswithintern').hide(); }
        }
        function NHIFCardNo()
        {
            var i = $('#rdNHIF').is(":checked");
            if (i == true)
            { $('#txtNHIFCardNo').show(); }
            else { $('#txtNHIFCardNo').hide(); }
        }
        function Save(el) {
            $getPatientRequestDetails(function (PatientRequestDetails) {
                serverCall('../IPD/Services/IPD.asmx/SavePatientTransferFromOutside', PatientRequestDetails, function (response) {

                    var responseData = JSON.parse(response);
                    if (responseData.status)
                    { modelAlert(responseData.response, function () { window.location.reload(); }); }
                    else { modelAlert(responseData.response);}
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

            PTransferDetail = [];
            PTransferDetail.push({
                CallerName: $('#txtNameofcaller').val().trim(),
                ReturnPhoneNo:$('#txtReturnPhoneNo').val().trim(),
                OutSideRefferingHospitalName:$('#txtRefferingHospital').val().trim(),
                OutSideInchargeDoctor:$('#txtInchargeDoctor').val().trim(),
                OutSidePName:$('#txtPname').val().trim(),
                OutSideAge:$('#txtAge').val() + ' ' + $('#ddlAge').val(),
                OutSideVitalGCS:$('#txtVitalGCS').val().trim(),
                OutSideVitalPulse:$.trim($('#txtPulse').val()),
                OutSideVitalBP: $.trim($('#txtBPsystolic').val()) +'/'+ $.trim($('#txtBPdiastolic').val()),
                OutSideVitalRR:$.trim($('#txtRR').val()),
                OutSideVitalSAT:$.trim($('#txtSAT').val()),
                OutSideVitalTemp:$.trim($('#txtTemperature').val()),
                OutSideModeofPayment:$('input[type=radio][name=PaymentMode]:checked').val(),
                OutSideNHIFCardNo:$.trim($('#txtNHIFCardNo').val()),
                OutSideIsBillingOfficer:$('#chkBillingOfficer').is(':checked')?'1':'0',
                OutSideReason:$.trim($('#txtReason').val()),
                OutSideRefferingHospitalName:$.trim($('#txtRefferingHospital').val()),
                DiagnosisReason:$.trim($('#txtDiagnosisReason').val()),
                ManagmentStatusReason:$.trim($('#txtManagementReason').val()),
                NeedIcuandHdu:$('#chkUseICU').is(':checked')?'1':'0',
                DiscussWithConsultantName:$('#chkDiscusswithcons').is(':checked') ? $('#txtDiscussInchargeName').val() : '',
                DiscussWithResidentName:$('#chkDiscusswithresident').is(':checked') ? $('#txtDiscusswithResident').val() : '',
                DiscussWithInternName:$('#chkDiscusswithintern').is(':checked') ? $('#txtDiscusswithintern').val() : '',
                CallBackAfterDiscussionName: $('#chkCallbackdiscussion').is(':checked') ? $('#txtcallbackDiscussion').val() : '',
                
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
    </script>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Transfer From Outside Faclities</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Name Of Caller</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtNameofcaller" title="Please Enter Name Of Caller "  />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Return Phone No</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtReturnPhoneNo" title="Please Enter Phone " onlynumber="10"  />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Reffering Hospital</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtRefferingHospital" onchange="RefferingDoctor(this.value);" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Incharge Doctor</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtInchargeDoctor"  />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Patient Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="text" id="txtPname" title="Please Enter Patient Name" />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Age</label>
                    <b class="pull-right">:</b>
                </div>
                       <div class="col-md-1">
						        <input type="text" id="txtAge" onlynumber="5"  decimalplace="2"   max-value="120"  autocomplete="off" onkeyup="CheckAge(this);"  maxlength="5" data-title="Enter Age"   />
		           </div>
		          <div class="col-md-3">
						        <select id="ddlAge"   >
								        <option value="YRS">YRS</option>
								        <option value="MONTH(S)">MONTH(S)</option>
								        <option value="DAYS(S)">DAYS(S)</option>
							        </select>
		           </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Patient Vital</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1">
                    <label class="pull-left">GCS</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1">
                    <input type="text" id="txtVitalGCS" title="Please Enter GCS" />
                </div>
                <div class="col-md-1">
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
                <div class="col-md-1">
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

                <div class="col-md-4">
                    <label class="pull-left">Daignosis Reason</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-20">
                    <input type="text" id="txtDiagnosisReason" title="Please Enter Patient Diagnosis Reason"  />

                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Management Done</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-20">

                    <input type="text" id="txtManagementReason" title="Please Enter Reason" />

                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Need ICU/HUD</label>
                    <b class="pull-right">:</b>

                </div>
                <div class="col-md-4">
                    <input type="checkbox" id="chkUseICU" title="If You Need ICU/HDU" />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Discuss With Consultant</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1">
                    <input type="checkbox" id="chkDiscusswithcons" title="If Check'It Means Yes'" onclick="DiscusswithConsultant();" />
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtDiscussInchargeName" title="Please Enter Discusse Incharge Name" style="display: none"/>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Discuss With Resident</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1">
                    <input type="checkbox" id="chkDiscusswithresident" title="If Check'It Means Yes'" onclick="Discusswithresident();" />
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtDiscusswithResident" title="Please Enter Discuss With Resident Name" style="display: none" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Discuss With Intern</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1">

                    <input id="chkDiscusswithintern" type="checkbox" title="If Check'It Means Yes'" onclick="Discusswithintern();" />
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtDiscusswithintern" title="Please Enter Discuss With Intern Name" style="display: none" />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Call Back After Discussion</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-1">

                    <input type="checkbox" id="chkCallbackdiscussion" title="If Check'It Means Yes'" onclick="Discusswithcallback();" />
                </div>
                <div class="col-md-3">
                    <input type="text" id="txtcallbackDiscussion" title="Please Enter Discuss With Call Back After Discussion Name" style="display: none" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-24"></div>
            </div>
            <div class="Purchaseheader">
                Billing 
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Mode Of Payment?</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input  type="radio" id="rdCash" name="PaymentMode" onclick="NHIFCardNo();" checked="checked" value="CASH"/>Cash
                    <input  type="radio" id="rdNHIF" name="PaymentMode" onclick="NHIFCardNo();" value="NHIF"/>NHIF
                </div>
                <div class="col-md-4">
                    <input  type="text" id="txtNHIFCardNo" title="Please Enter NHIF Card" style="display:none"/>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Billing Officer/NHIF</label>
                    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-1">

                    <input id="chkBillingOfficer" type="checkbox" title="If Check'It Means Yes'" onclick="Discusswithintern();" />
                </div>
              
            </div>
            <div class="row">
                  <div class="col-md-4">
                      <label class="pull-left">Reason</label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-20">
                    <input type="text" id="txtReason" title="Please Enter Reason"  />
                </div>
            </div>           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                 <div class="row" >
                     <div class="col-md-24">
                        <input type="button" value="Save" id="btnSave" title="Save All Details" onclick="Save(this);" />
                     </div>
                 </div>
         </div>
    </div>
</asp:Content>
