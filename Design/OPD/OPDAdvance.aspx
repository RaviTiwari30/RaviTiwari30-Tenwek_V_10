<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OPDAdvance.aspx.cs" Inherits="Design_OPD_OPDAdvance" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="PatientInfo" TagPrefix="uc1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
           // $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
            $getHashCode(function () {
                bindAdvanceReason(function () {
                    $bindMandatory(function () {
                        $patientControlInit(function () {
                            $panelControlInit(function () {
                                $paymentControlInit(function () {
                                    //for Advance Room Booking Amount Update
                                    var IsAdvanceRoomBookingAmount = Number('<%=Util.GetString(Request.QueryString["IsAdvanceRoomBookingAmountUpdate"])%>');
                                    if (IsAdvanceRoomBookingAmount == 1) {
                                        var patientID = '<%=Util.GetString(Request.QueryString["PatientID"])%>';
                                        $patientSearchByPatientId({ PatientID: patientID, PatientRegStatus: 1 }, function (response) {
                                            $bindPatientDetails(response, function () {
                                                $("#ddlType").val('1').attr('disabled', true);
                                            });
                                        });
                                    }
                                    else
                                        $("#ddlType").attr('disabled', false);

                                    onPatientIDChange(function () { });
                                  //  $.unblockUI();
                                });
                            });
                        });
                    });
                });
            });
        });




        var bindAdvanceReason = function (callback) {
            serverCall('../Common/CommonService.asmx/GetAdvanceReason', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlAdvanceReason = $('#ddlAdvanceReason');
                ddlAdvanceReason.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ID', textField: 'Reason', isSearchAble: true });
                callback(ddlAdvanceReason.val());
            });
        }


        var onCreateNewAdvanceReasonModelOpen = function () {
            var divNewAdvanceReasonModel = $('#divNewAdvanceReasonModel');
            divNewAdvanceReasonModel.find('#txtNewAdvanceReason').val('');
            divNewAdvanceReasonModel.showModel();
        }


        var onCreateNewAdvanceReasonModelClose = function () {
            bindAdvanceReason(function () {
                var divNewAdvanceReasonModel = $('#divNewAdvanceReasonModel');
                divNewAdvanceReasonModel.closeModel();
            });
        }

        var createNewAdvanceReason = function () {
            var txtNewAdvanceReason = $('#txtNewAdvanceReason');
            var advanceReason = $.trim(txtNewAdvanceReason.val());

            if (String.isNullOrEmpty(advanceReason)) {
                modelAlert('Please Enter Advance Reason.', function () {
                    txtNewAdvanceReason.focus();
                });
            }


            serverCall('../Common/CommonService.asmx/CreateAdvanceReason', { advanceReason: advanceReason }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    onCreateNewAdvanceReasonModelClose();
                }
                else {
                    modelAlert(responseData.message);
                }
            });
        }



        var onPatientIDChange = function () {
            $('#txtPID').change(function () {
                getPatientBasicDetails(function (a) {
                    $('#lblAvilableAdvanceAmount').text(a.patientAdvanceAmount);
                });
            });
        }

        var onTypeChange = function (val) {
            $('#txtAdvanceAmount').val('');
            $clearPaymentControl(function () { });
            if (val == "2") {
                getPatientBasicDetails(function (a) {
                    $('#txtAdvanceAmount').attr('max-value', a.patientAdvanceAmount);
                });
            }
            else {
                $('#txtAdvanceAmount').attr('max-value', 10000000);
            }
        }


        var onAdvanceAmountChange = function (e) {
            var totalBillAmount = Number(e.target.value);
            if (totalBillAmount > 0) {
                $addBillAmount({
                    panelId: 1,
                    billAmount: totalBillAmount,
                    disCountAmount: 0,
                    isReceipt: true,
                    patientAdvanceAmount: 0,
                    minimumPayableAmount: 0,
                    disableDiscount: true,
                    panelAdvanceAmount: 0,
                    disableCredit: true,
                    refund: { status: false }
                }, function () { });
            }
            else {
                $clearPaymentControl(function () { });
            }
        }

        var $getOPDAdvanceDetails = function (callback) {
            var hashCode = $('#spnHashCode').text();
            var PaymentType = $('#ddlType').val();
            var advanceReason ={value:Number($('#ddlAdvanceReason').val()),text:$('#ddlAdvanceReason option:selected').text()}
            //for Advance Room Booking Amount Update
            var IsAdvanceRoomBookingAmount = Number('<%=Util.GetString(Request.QueryString["IsAdvanceRoomBookingAmountUpdate"])%>');
        var AdvanceBookingId = Number('<%=Util.GetString(Request.QueryString["AdvanceBookingId"])%>');
        $getPatientDetails(function (patientDetails) {
            $getPaymentDetails(function (paymentDetails) {
                $PM = patientDetails.defaultPatientMaster;
                $PaymentDetail = [];
                $(paymentDetails.paymentDetails).each(function () {
                    $PaymentDetail.push({
                        PaymentMode: this.PaymentMode,
                        PaymentModeID: this.PaymentModeID,
                        S_Amount: this.S_Amount,
                        S_Currency: this.S_Currency,
                        S_CountryID: this.S_CountryID,
                        BankName: this.BankName,
                        RefNo: this.RefNo,
                        BaceCurrency: this.BaceCurrency,
                        C_Factor: this.C_Factor,
                        Amount: this.Amount,
                        S_Notation: this.S_Notation,
                        PaymentRemarks: paymentDetails.paymentRemarks,
                        swipeMachine: this.swipeMachine,
                        currencyRoundOff: paymentDetails.currencyRoundOff / paymentDetails.paymentDetails.length
                    });
                });



                if ($PaymentDetail.length < 1) {
                    modelAlert('Please Select Payment Details');
                    return false;
                }

                if (advanceReason.value < 1) {
                    modelAlert('Please Select Advance Reason.', function () {
                        $('#ddlAdvanceReason').focus();
                    });
                    return false;
                }



                console.log({ PM: [$PM], patientDocuments: patientDetails.patientDocuments, PaymentDetail: $PaymentDetail, advAmount: paymentDetails, UhashCode: hashCode, isAdvanceRoomBookingAmount: IsAdvanceRoomBookingAmount, advanceBookingId: AdvanceBookingId });
                callback({ PM: [$PM], patientDocuments: patientDetails.patientDocuments, PaymentDetail: $PaymentDetail, advAmount: paymentDetails.adjustment, UhashCode: hashCode, Type: PaymentType, isAdvanceRoomBookingAmount: IsAdvanceRoomBookingAmount, advanceBookingId: AdvanceBookingId, advanceReason: advanceReason.text, DoctorID:patientDetails.Doctor.value });
            });
        });
    };


    var $getHashCode = function (callback) {
        serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
            $('#spnHashCode').text(response);
            callback(true);
        });
    }

    var $bindMandatory = function (callback) {
        var manadatory = [
            { control: '#ddlTitle', isRequired: true, erroMessage: 'Please Select Title', tabIndex: 1, isSearchAble: false },
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPLastName', isRequired: false, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
				{ control: '#txtDOB', isRequired: false, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                { control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                { control: '#ddlMarried', isRequired: false, erroMessage: 'Select Marital Status', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 4, isSearchAble: false },
                { control: '#txtIDProofNo', isRequired: false, erroMessage: 'Enter NIC No.', tabIndex: 4, isSearchAble: false },
               // { control: '#txtAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 5, isSearchAble: false },
               { control: '#txtParmanentAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 5, isSearchAble: false },
                { control: '#txtRelationName', isRequired: false, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
                { control: '#ddlCountry', isRequired: true, erroMessage: 'Please Select Country', tabIndex: 6, isSearchAble: true },
                { control: '#ddlState', isRequired: true, erroMessage: 'Please Select State', tabIndex: 6, isSearchAble: true },
                { control: '#ddlDistrict', isRequired: true, erroMessage: 'Please Select DIstrict', tabIndex: 7, isSearchAble: true },
                { control: '#ddlCity', isRequired: true, erroMessage: 'Please Select City', tabIndex: 8, isSearchAble: true },
                { control: '#ddlDoctor', isRequired: true, erroMessage: 'Please Select Doctor', tabIndex: 6, isSearchAble: true },
				{ control: '#ddlTaluka', isRequired: true, erroMessage: 'Please Select Village', tabIndex: 8, isSearchAble: true },
                { control: '#txtControlRemarks', isRequired: true, erroMessage: 'Please Enter Remarks', tabIndex: 10, isSearchAble: true }
                
        ];

        $(manadatory).each(function (index, item) {
            $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
            $(manadatory[0].control).focus();
        });
        callback(true);
    }
    var savePatientAdvance = function (btnSave) {
        var IsAdvanceRoomBookingAmount = Number('<%=Util.GetString(Request.QueryString["IsAdvanceRoomBookingAmountUpdate"])%>');
        if (IsAdvanceRoomBookingAmount == 1) {
            var advanceReason = Number($('#ddlAdvanceReason').val());
            if (advanceReason == 0) {
                modelAlert('Please Select Advance Reason.');
                return false;
            }
        }
        if ($('#txtControlRemarks').val() == '') {
            modelAlert('Please Enter Remarks');
            return;
        }
        $getOPDAdvanceDetails(function (advanceDetails) {
            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('OPDAdvance.aspx/SaveAdvanceAmount', advanceDetails, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                            window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '&IsBill=0&Duplicate=0');
                        else
                           // window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '&IsBill=0&Duplicate=0&Type=OPD');
                            window.open('../common/CommonPrinterOPDThermal.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '&IsBill=0&Duplicate=0&Type=OPD');
                        //for Advance Room Booking Amount Update
                        if (IsAdvanceRoomBookingAmount == 1)
                            window.location = '../IPD/AdvanceRoomBooking.aspx';
                        else
                            window.location.reload();
                    }
                    else
                        $(btnSave).removeAttr('disabled').val('Save');
                });
            });
        });
    }
    </script>




    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager runat="server" ID="scrtp1"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Patient Advance/Refund</b>
        </div>
        <uc1:PatientInfo runat="server" ID="PatientInfo" />
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Available Amt. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <b>
                                <label id="lblAvilableAdvanceAmount" class="pull-left patientInfo">0</label></b>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Type </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select onchange="onTypeChange(this.value);" id="ddlType" class="requiredField">
                                <option value="1" selected="selected">Advance</option>
                                <option value="2">Refund</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Amount </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="txtAdvanceAmount" onlynumber="8" decimalplace="3" max-value="10000000" onkeyup="onAdvanceAmountChange(event)" class="ItDoseTextinputNum requiredField" type="text" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Reason </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select class="requiredField" id="ddlAdvanceReason"></select>
                        </div>
                        <div style="padding-left: 0px;" class="col-md-1">
				           <input type="button" value="New"  title="Click To Add New Discount Reason." onclick="onCreateNewAdvanceReasonModelOpen()"/>
		           </div>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>


        <div style="width: 100%" id="paymentControlDiv">
            <UC2:PaymentControl ID="paymentControl" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <span id="spnHashCode" style="display: none"></span>
            <input type="button" style="margin-top: 7px" value="Save" id="btnSave" onclick="savePatientAdvance(this)" tabindex="20" class="save ItDoseButton" />
        </div>
    </div>




    <div id="divNewAdvanceReasonModel" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 400px;">
                <div class="modal-header">
                    <button type="button" class="close" onclick="onCreateNewAdvanceReasonModelClose()" aria-hidden="true">×</button>
                    <h4 class="modal-title">Add Advance Reason</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-10">
                            <label class="pull-left">Reason   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-14">
                            <input type="text" onlytext="20" id="txtNewAdvanceReason">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="save" onclick="createNewAdvanceReason();">Save</button>
                    <button type="button" class="save" onclick="onCreateNewAdvanceReasonModelClose()">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>



