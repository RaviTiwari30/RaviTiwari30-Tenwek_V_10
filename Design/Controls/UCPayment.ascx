<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCPayment.ascx.cs" Inherits="Design_Controls_UCPayment" %>

<script type="text/javascript">
    var _paymentControlRoundPlace = 2;
    var $paymentControlInit = function (callback) {
        _divPaymentControlParent = $('#divPaymentControlParent');
        //_paymentControlRoundPlace = 2;
        bindApprovedMaster(function () {
            bindDiscReason(function () {
                $getCurrencyDetails(function (baseCountryID) {
                    $getConversionFactor(baseCountryID, function (conversionFactor) {
                        _divPaymentControlParent.find('#spnCFactor').text(conversionFactor);
                        _divPaymentControlParent.find('#spnConvertionRate').text('1 ' + _divPaymentControlParent.find('#ddlCurrency option:selected').text() + ' = ' + precise_round(conversionFactor, _paymentControlRoundPlace) + ' ' + _divPaymentControlParent.find('#spnBaseNotation').text());
                        callback(true);
                    });
                });
            });
        });
    }



    var $bindPaymentMode = function (PanelID, isReceipt, isRefund, disableCredit, callback) {
        if (isReceipt)
            $getPaymentMode(PanelID, isRefund, disableCredit, isReceipt, function () { callback(true) });
        else {
           // $restrictPaymentMode(function () {
            //    $getPaymentMode(PanelID, isRefund, disableCredit, isReceipt, function () { callback(true) });
            // });
            $getPaymentMode(PanelID, isRefund, disableCredit, isReceipt, function () { callback(true) });//
           // $onPaymentModeChange(this, $('#ddlCurrency'), function () { });
        }
    }

    var $getPaymentMode = function (panelId, refund, disableCredit, isReceipt, callback) {
        $bindPaymentModePanelWise(panelId, function (response) {
            paymentModes = $.extend(true, [], response);
            if (refund.status) {
                paymentModes = paymentModes.filter(function (i) { if (i.IsForRefund) { return i; } });

                if (parseInt(refund.refundPaymentMode) == 4)
                    paymentModes = paymentModes.filter(function (i) { if (i.PaymentModeID == 4) { return i; } });
                else
                    paymentModes = paymentModes.filter(function (i) { if (i.PaymentModeID != 4) { return i; } });
            }
            if (disableCredit)
                paymentModes = paymentModes.filter(function (i) { if (i.PaymentModeID != 4) { return i; } });

            if (paymentModes.length > 0) {
                if (isReceipt) {
                    paymentModes.patientAdvanceAmount = Number(_divPaymentControlParent.find('#spnControlPatientAdvanceAmount').text());
                    paymentModes.panelAdvanceAmount = Number(_divPaymentControlParent.find('#spnControlPanelAdvanceAmount').text());


                    //Enable patient Advance PaymentMode
                    var patientAdvancePaymentModeIndex = paymentModes.map(function (item) { return item.PaymentModeID; }).indexOf(7);
                    if (patientAdvancePaymentModeIndex > -1) {
                        if (paymentModes.patientAdvanceAmount < 1)
                            paymentModes.splice(patientAdvancePaymentModeIndex, 1);
                        else
                            paymentModes[patientAdvancePaymentModeIndex].PaymentMode = paymentModes[patientAdvancePaymentModeIndex].PaymentMode + '(' + paymentModes.patientAdvanceAmount + ')';
                    }


                    //Enable Panel Advance PaymentMode
                    var panelAdvancePaymentModeIndex = paymentModes.map(function (item) { return item.PaymentModeID; }).indexOf(8);
                    if (panelAdvancePaymentModeIndex > -1) {
                        if (paymentModes.panelAdvanceAmount < 1)
                            paymentModes.splice(panelAdvancePaymentModeIndex, 1);
                        else
                            paymentModes[panelAdvancePaymentModeIndex].PaymentMode = paymentModes[panelAdvancePaymentModeIndex].PaymentMode + '(' + paymentModes.panelAdvanceAmount + ')';
                    }
                }
                else
                    paymentModes = paymentModes.filter(function (i) { if (i.PaymentModeID == 4) { return i; } });

                var responseData = $('#templatePaymentModes').parseTemplate(paymentModes);
                _divPaymentControlParent.find('#tdPaymentModes').html(responseData);
                callback(true);
            }
            else {
                modelAlert('Panel Have Not Any PaymentMode.', function () {
                    $clearPaymentControl(function () { });
                });
            }
        });
    }


    var $bindPaymentDetails = function (data, callback) {
        $payment = {};
        $payment.billAmount = data.billAmount;
        $payment.$paymentDetails = [];
        $payment.patientAdvanceAmount = data.patientAdvanceAmount;
        $payment.panelAdvanceAmount = data.panelAdvanceAmount;
        var defaultAmount = 0;
        $payment.$paymentDetails = {
            Amount: data.defaultPaidAmount,
            BaceCurrency: data.baseCurrencyName,
            BankName: '',
            C_Factor: data.currencyFactor,
            PaymentMode: data.paymentMode,
            PaymentModeID: data.PaymentModeID,
            PaymentRemarks: '',
            RefNo: '',
            S_Amount: 0,
            baseCurrencyAmount: data.defaultPaidAmount,
            S_CountryID: data.currencyID,
            S_Currency: data.currentCurrencyName,
            S_Notation: data.currentCurrencyName,
        };
        callback($payment);
    }

    var $bindPaymentModeDetails = function (data, callback) {
        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

        isEmgAndOPDReturnInCaseOfCredit = 0;
        if (pageName == 'opd_return.aspx') {
            isEmgAndOPDReturnInCaseOfCredit = 1;
        }
        var isrefund = 0; 
        var refundattr = _divPaymentControlParent.find('#lblPaymentType').attr('isRefund');

        if (typeof refundattr != 'undefined' && refundattr != false) {
            isrefund = Number(_divPaymentControlParent.find('#lblPaymentType').attr('isRefund'));
        }
        var disableBankDetailPaymentModeID = [1, 4, 8, 7];
        var disableManualAmountChange = [4, 8];
        var patientAdvancePaymentModeID = [7];
        var panelAdvancePaymentModeID = [8];
        var panelCreditPaymentModeID = [4];
        var swipeMachineDetailsRequiredPaymentModeID = [3];
        var maxInputValue = 10000000000000;

        if (patientAdvancePaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
            maxInputValue = data.patientAdvanceAmount;
        else if (panelAdvancePaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1)
            maxInputValue = data.panelAdvanceAmount;
        else
            maxInputValue = 10000000000000;

        var $temp = '<tr class="' + data.$paymentDetails.S_CountryID + '"  id="' + data.$paymentDetails.S_CountryID + data.$paymentDetails.PaymentModeID + '">'
        $temp += '<td id="tdPaymentMode" class="GridViewLabItemStyle">' + data.$paymentDetails.PaymentMode.split('(')[0] + '</td>';
        $temp += '<td id="tdAmount" class="GridViewLabItemStyle">';

        if (isEmgAndOPDReturnInCaseOfCredit != 1)
          $temp += '<input type="text" ' + (disableManualAmountChange.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? "disabled=disabled" : "") + ' onlynumber="14" decimalplace="4" max-value="' + maxInputValue + '" autocomplete="off" id="txtPaidAmount" value="' + (panelCreditPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 && isrefund == 0 ? 0 : data.$paymentDetails.Amount) + '" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" onkeyup="$onPaidAmountChanged(event);" /></td>';
        else
        $temp += '<input type="text" ' + (disableManualAmountChange.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? "disabled=disabled" : "") + ' onlynumber="14" decimalplace="4" max-value="' + maxInputValue + '" autocomplete="off" id="txtPaidAmount" value="' + (panelCreditPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? 0 : data.$paymentDetails.Amount) + '" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });" onkeyup="$onPaidAmountChanged(event);" /></td>';


        $temp += '<td id="tdS_Currency" class="GridViewLabItemStyle">' + data.$paymentDetails.S_Currency + '</td>';
        $temp += '<td id="tdBankName" class="GridViewLabItemStyle">' + (disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '' : '<select class="bnk" style="padding: 0px;"></select>') + '</td>';
        if (data.$paymentDetails.PaymentMode.split('(')[0] == 'M-Pesa') {
            $temp += '<td id="tdRefNo" class="GridViewLabItemStyle">' + (disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '' : '<input type="text" autocomplete="off" class="required"  id="txtRefNo" onchange="RemoveAllSpace(this);checkValidReffNo(this);"  value="' + data.$paymentDetails.RefNo + '" maxlength="10"/>') + '</td>';
        }
        else
        {
            $temp += '<td id="tdRefNo" class="GridViewLabItemStyle">' + (disableBankDetailPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '' : '<input type="text" autocomplete="off" class="required"  id="txtRefNo" onchange="RemoveAllSpace(this)" value="' + data.$paymentDetails.RefNo + '" />') + '</td>';
        }
        $temp += '<td id="tdSwipeMachineID" class="GridViewLabItemStyle">' + (swipeMachineDetailsRequiredPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? '<select class="swipeMachine" style="padding: 0px;"><option value="POS 1-BB">POS 1-BB</option><option value="POS 2-SBM">POS 2-SBM</option><option value="POS 3-MCB">POS 3-MCB</option> </select>' : '') + '</td>';
        $temp += '<td id="tdPaymentModeID" style="display:none">' + data.$paymentDetails.PaymentModeID + '</td>';
        $temp += '<td id="tdS_Amount" style="display:none">' + data.$paymentDetails.S_Amount + '</td>';
        $temp += '<td id="tdC_Factor" style="display:none" class="GridViewLabItemStyle">' + data.$paymentDetails.C_Factor + '</td>';

        if (isEmgAndOPDReturnInCaseOfCredit != 1)
        $temp += '<td id="tdBaseCurrencyAmount" class="GridViewLabItemStyle" > ' + (panelCreditPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 && isrefund == 0 ? 0 : data.$paymentDetails.baseCurrencyAmount) + '</td>';
        else
        $temp += '<td id="tdBaseCurrencyAmount" class="GridViewLabItemStyle" > ' + (panelCreditPaymentModeID.indexOf(data.$paymentDetails.PaymentModeID) > -1 ? 0 : data.$paymentDetails.baseCurrencyAmount) + '</td>';

        $temp += '<td id="tdBaceCurrency" style="display:none">' + data.$paymentDetails.BaceCurrency + '</td>';
        $temp += '<td id="tdS_CountryID" style="display:none">' + data.$paymentDetails.S_CountryID + '</td>';
        $temp += '<td id="tdS_Notation" style="display:none">' + data.$paymentDetails.S_Notation + '</td>';
        $temp += '</tr>';
        _divPaymentControlParent.find('#divPaymentDetails table tbody').append($temp);
        var bankControl = _divPaymentControlParent.find('#divPaymentDetails table tbody tr:last-child').find('.bnk');
        callback({ bankControl: bankControl });
    }






    var $onChangeCurrency = function (elem, callback) {
        $getConversionFactor(elem.value, function (conversionFactor) {
            var blanceAmount = $(txtControlBlanceAmount).val();
            var $blanceAmount = String.isNullOrEmpty(blanceAmount) ? 0 : blanceAmount;
            $convertCurrency(elem.value, $blanceAmount, function (convertedCurrency) {
                _divPaymentControlParent.find('#spnCFactor').text(conversionFactor);
                _divPaymentControlParent.find('#spnConvertionRate').text('1 ' + _divPaymentControlParent.find('#ddlCurrency option:selected').text() + ' = ' + precise_round(conversionFactor, _paymentControlRoundPlace) + ' ' + _divPaymentControlParent.find('#spnBaseNotation').text());
                _divPaymentControlParent.find('#spnBlanceAmount').text(convertedCurrency + ' ' + _divPaymentControlParent.find('#ddlCurrency option:selected').text());
                _divPaymentControlParent.find('input[type=checkbox][name=paymentMode]').prop('checked', false);

                var selectedPaymentModeOnCurrency = _divPaymentControlParent.find('#divPaymentDetails').find('.' + elem.value);
                $(selectedPaymentModeOnCurrency).each(function (index, elem) {
                    _divPaymentControlParent.find('#tdPaymentModes').find('input[type:checkbox][name=paymentMode][value=' + $(elem).find('#tdPaymentModeID').text().trim() + ']').prop('checked', true);
                });
                callback(true);
            });
        });
    }

    var $validatePaymentModes = function (elem, billAmount, ddlCurrency, callback) {
        //var currentSelectedPaymentMode = Number(elem.value);
        //	$('input[type=checkbox][name=paymentMode][value=4]').prop('checked', false);
        //	var creditPaymentModeTr = $('#divPaymentDetails').find('#' + ddlCurrency.val() + '4');
        //	creditPaymentModeTr.remove();
        //	//if (creditPaymentModeTr.length > 0)
        //	//	$('#txtControlPaymentAmount').val(0);
        //}

        //if ($('input[type=checkbox][name=paymentMode][value=1]:checked').length > 0)
        //	$('#txtControlTenderExchange').prop('disabled', false);
        //else
        //	$('#txtControlTenderExchange,#txtControlReturnAmount').val('').prop('disabled', true);
       
		if ($('input[type=checkbox][name=paymentMode][value=1]:checked').length > 0)
            $('#txtControlExchange').prop('disabled', false);
        else {
            $('#txtControlExchange').val('0').prop('disabled', true);
            $('#lblControlReturnAmt').text('');
        }
		
        var totalPaidAmount = 0;
        _divPaymentControlParent.find('#divPaymentDetails #tdBaseCurrencyAmount').each(function () { totalPaidAmount += Number($(this).text()); });
        var totalPanelPaidAmount = 0;
        _divPaymentControlParent.find('#divPaymentDetails #tdPaymentModeID').each(function () { if (Number($(this).text()) == 8) { totalPanelPaidAmount += Number($(this).closest('tr').find('#tdBaseCurrencyAmount').text()) } });

        var data = {
            currentSelectedPaymentMode: Number(elem.value),
            totalSelectedPaymentModes: _divPaymentControlParent.find('#tdPaymentModes input[type=checkbox]:checked'),
            billAmount: billAmount,
            totalPaidAmount: totalPaidAmount,
            defaultPaidAmount: 0,
            patientAdvanceAmount: Number(_divPaymentControlParent.find('#spnControlPatientAdvanceAmount').text()),
            panelAdvanceAmount: Number(_divPaymentControlParent.find('#spnControlPanelAdvanceAmount').text()),
            panelPayableAmount: Number(_divPaymentControlParent.find('#txtControlPanelPayable').val()),
            patientPayableAmount: Number(_divPaymentControlParent.find('#txtControlUserPayable').val()),
            patientPaidAmount: totalPaidAmount - totalPanelPaidAmount,
            panelPaidAmount: totalPanelPaidAmount,
            roundOffAmount: Number(_divPaymentControlParent.find('#txtControlRoundOff').val()),
            currentCurrencyName: $.trim($(ddlCurrency).find('option:selected').text()),
            currentCurrencyNotation: $.trim($(ddlCurrency).find('option:selected').text()),
            baseCurrencyName: $.trim($('#spnBaseCurrency').text()),
            baseCurrencyNotation: $.trim($('#spnBaseNotation').text()),
            currencyFactor: Number($('#spnCFactor').text()),
            paymentMode: $.trim($(elem).next('b').text()),
            PaymentModeID: Number(elem.value),
            currencyID: Number(ddlCurrency.val()),
            isInBaseCurrency: false
        }

        if (data.currentSelectedPaymentMode == 4)
            clearAllSelectedPaymentModePaymentDetails(elem, function () {
                data.defaultPaidAmount = 0;
            })
        else
            clearSelectedCreditModePaymentDetails(ddlCurrency, function () { });


        if (data.baseCurrencyNotation.toLowerCase() == data.currentCurrencyNotation.toLowerCase())
            data.isInBaseCurrency = true;

        if (data.isInBaseCurrency) {
            if (data.currentSelectedPaymentMode == 8) {
                if ((data.billAmount - data.totalPaidAmount) >= data.panelPayableAmount) {
                    var restAmount = precise_round(((data.billAmount - data.totalPaidAmount) + data.roundOffAmount), _paymentControlRoundPlace);
                    restAmount = (restAmount > data.panelPayableAmount?data.panelPayableAmount:restAmount);
                    data.defaultPaidAmount = (data.panelAdvanceAmount > restAmount ? restAmount : data.panelAdvanceAmount);
                    //data.defaultPaidAmount = precise_round(data.panelPayableAmount, _paymentControlRoundPlace);
                }
                else {
                    var restAmount = precise_round(((data.billAmount - data.totalPaidAmount) + data.roundOffAmount), _paymentControlRoundPlace);
                    restAmount = (restAmount > data.panelPayableAmount ? data.panelPayableAmount : restAmount);
                    data.defaultPaidAmount = (data.panelAdvanceAmount > restAmount ? restAmount : data.panelAdvanceAmount);
                  //  data.defaultPaidAmount = precise_round(((data.billAmount - data.totalPaidAmount) + data.roundOffAmount), _paymentControlRoundPlace);
                }
            }
            else if (data.currentSelectedPaymentMode == 7) {
                var restAmount = precise_round(((data.billAmount - data.totalPaidAmount) + data.roundOffAmount), _paymentControlRoundPlace);
                data.defaultPaidAmount = (data.patientAdvanceAmount > restAmount ? restAmount : data.patientAdvanceAmount);
            }
            else {
                data.defaultPaidAmount = precise_round(((data.patientPaidAmount >= data.patientPayableAmount) ? ((data.billAmount - data.totalPaidAmount) + data.roundOffAmount) : (data.patientPayableAmount - data.patientPaidAmount)), _paymentControlRoundPlace);
            }
        }

        callback(data);
    }

    var previousFirstSelectedPaymentMode = {};
    var clearAllSelectedPaymentModePaymentDetails = function (expectPaymentModes, callback) {
        var selectedPaymentModes = $(_divPaymentControlParent.find('#divPaymentDetails .' + Number(_divPaymentControlParent.find('#spnBaseCountryID').text()) + ':first-child'));
        previousFirstSelectedPaymentMode.paymentModeID = Number(selectedPaymentModes.find('#tdPaymentModeID').text());
        previousFirstSelectedPaymentMode.bank = $.trim(selectedPaymentModes.find('.bnk').val());
        previousFirstSelectedPaymentMode.refNo = $.trim(selectedPaymentModes.find('#txtRefNo').val());
        previousFirstSelectedPaymentMode.swipeMachine = $.trim(selectedPaymentModes.find('.swipeMachine').val());
        var allCheckedPaymentModes = _divPaymentControlParent.find('input[type=checkbox][name=paymentMode]:checked')
        allCheckedPaymentModes.not(expectPaymentModes).prop('checked', false);
        _divPaymentControlParent.find('#divPaymentDetails table tbody').html('');
        _divPaymentControlParent.find('#txtControlPaymentAmount').val(0);
        callback(allCheckedPaymentModes);
    }



    var clearSelectedCreditModePaymentDetails = function (ddlCurrency, callback) {
        _divPaymentControlParent.find('input[type=checkbox][name=paymentMode][value=4]').prop('checked', false);
        callback(_divPaymentControlParent.find('#divPaymentDetails').find('#' + ddlCurrency.val() + '4').remove());
    }

    var $onPaidAmountChanged = function (e) {
        var row = $(e.target).closest('tr');
        var countryID = Number(row.find('#tdS_CountryID').text());
        var paidAmount = Number(e.target.value);
        $convertToBaseCurrency(countryID, paidAmount, function (baseCurrencyAmount) {
            $(row).find('#tdBaseCurrencyAmount').text(baseCurrencyAmount);
            $calculateTotalPaymentAmount(e, function () { });
        });
    }

    var $onDiscountAmountChanged = function (e, billAmount, roundOffAmount) {
        var $netAmount = (parseFloat(billAmount));
        clearAllSelectedPaymentModePaymentDetails(null, function () {
            var $discountPerCent = precise_round((e.target.value * 100 / $netAmount), _paymentControlRoundPlace);
            var $maxEligibleDiscountPercent = Number(_divPaymentControlParent.find('#spnControlMaxEligibleDiscountPercent').text());
            if ($maxEligibleDiscountPercent < $discountPerCent)
            {
                modelAlert('You are eligible upto ' + $maxEligibleDiscountPercent + '% discount.');
                $discountPerCent = 0;
                e.target.value = 0;
            }
            calculatePayableAmount($discountPerCent, function () {
                _divPaymentControlParent.find('#txtControlDiscountPerCent').val(Number($discountPerCent));
                var netAmount = precise_round(parseFloat($netAmount - Number(e.target.value)), _paymentControlRoundPlace);
                var roundOffNetAmount = precise_round(netAmount, _paymentControlRoundPlace);
                _divPaymentControlParent.find('#txtControlNetAmount').val(roundOffNetAmount);
                _divPaymentControlParent.find('#txtControlRoundOff').val(precise_round(roundOffNetAmount - netAmount, _paymentControlRoundPlace));
                $setDefaultPaymentMode(function () {
                    var isDiscount = !(Number(e.target.value) > 0);
                    _divPaymentControlParent.find('#ddlControlDiscountReason,#ddlControlApprovedBY').val(0).prop('disabled', isDiscount).toggleClass('customRequired', !isDiscount);
                    $calculateTotalPaymentAmount(null, function () { });
                });
            });
        });
		 $onExchangeAmountChanged($('#txtControlExchange').val(), $('#txtControlNetAmount').val());
    }

    var $onDiscountPercentChanged = function (e, billAmount, roundOffAmount) {
        var $maxEligibleDiscountPercent = Number(_divPaymentControlParent.find('#spnControlMaxEligibleDiscountPercent').text());
        if ($maxEligibleDiscountPercent < Number(e.target.value)) {
            modelAlert('You are eligible upto ' + $maxEligibleDiscountPercent + '% discount.');
            e.target.value = 0;
        }
        var $netAmount = (parseFloat(billAmount));
        clearAllSelectedPaymentModePaymentDetails(null, function () {
            calculatePayableAmount(Number(e.target.value), function () {
                var $discountAmount = precise_round(parseFloat(e.target.value * $netAmount / 100), _paymentControlRoundPlace);
                _divPaymentControlParent.find('#txtControlDiscountAmount').val($discountAmount);
                var netAmount = precise_round(parseFloat($netAmount - $discountAmount), _paymentControlRoundPlace);
                var roundOffNetAmount = precise_round(netAmount, _paymentControlRoundPlace);
                _divPaymentControlParent.find('#txtControlNetAmount').val(roundOffNetAmount);
                _divPaymentControlParent.find('#txtControlRoundOff').val(precise_round(roundOffNetAmount - netAmount, _paymentControlRoundPlace));
                $setDefaultPaymentMode(function () {
                    var isDiscount = !(Number(e.target.value) > 0);
                    _divPaymentControlParent.find('#ddlControlDiscountReason,#ddlControlApprovedBY').val(0).prop('disabled', isDiscount).toggleClass('customRequired', !isDiscount);
                    $calculateTotalPaymentAmount(null, function () { });
                });
            });
        });
		 $onExchangeAmountChanged($('#txtControlExchange').val(), $('#txtControlNetAmount').val());
    }

    var calculatePayableAmount = function (discountPercent, callback) {
        var txtControlUserPayable = _divPaymentControlParent.find('#txtControlUserPayable');
        var txtControlPanelPayable = _divPaymentControlParent.find('#txtControlPanelPayable');
        var $userPayableAmount = Number(txtControlUserPayable.attr('TotalUserPayableAmount'));
        var $userPayableAmount = precise_round(($userPayableAmount - (discountPercent * $userPayableAmount / 100)), _paymentControlRoundPlace);
        var _roundOffUserPayable =  precise_round($userPayableAmount, 0)- $userPayableAmount;
        txtControlUserPayable.val($userPayableAmount + Number(_roundOffUserPayable));
        var $panelPayableAmount = Number(txtControlPanelPayable.attr('TotalPanelPayableAmount'));
        var $panelPayableAmount = precise_round(($panelPayableAmount - (discountPercent * $panelPayableAmount / 100)), _paymentControlRoundPlace);
        var _roundOffPanelPayable = precise_round($panelPayableAmount, 0) - $panelPayableAmount;
        txtControlPanelPayable.val($panelPayableAmount + Number(_roundOffPanelPayable));
        callback({ userPayableAmount: $userPayableAmount, panelPayableAmount: $panelPayableAmount });
    }


    $setDefaultPaymentMode = function (callback) {

        var isAutoPaymentMode = Number(_divPaymentControlParent.find('#spnAutoPaymentMode').text());

        if (isAutoPaymentMode == 1) {
            var paymentModes = _divPaymentControlParent.find('input[type=checkbox][name=paymentMode]');
            if (paymentModes.length > 0) {
                _divPaymentControlParent.find('#ddlCurrency').val($.trim(_divPaymentControlParent.find('#spnBaseCountryID').text()));

                //for set default  panel advance payment mode while panelAdvanceAmount is greater then bill amount
                var panelAdvanceAmount = Number(_divPaymentControlParent.find('#spnControlPanelAdvanceAmount').text());
                var panelAdvancePaymentMode = _divPaymentControlParent.find('input[type=checkbox][name=paymentMode][value=8]');
                var panelPayableAmount = Number(_divPaymentControlParent.find('#txtControlPanelPayable').val());
                var isPanelAdvanceAmountApplicable = (panelAdvanceAmount > 0 && panelAdvancePaymentMode.length > 0 && panelAdvanceAmount >= panelPayableAmount);
                $(panelAdvancePaymentMode).attr('disabled', !isPanelAdvanceAmountApplicable);

                var isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;//
                if (isReceipt) {//
                    var DefaultPaymentMode = isPanelAdvanceAmountApplicable ? panelAdvancePaymentMode : _divPaymentControlParent.find('input[type=checkbox][name=paymentMode][value=1],input[type=checkbox][name=paymentMode]')[0];
                }
                else {//
                    var DefaultPaymentMode = isPanelAdvanceAmountApplicable ? panelAdvancePaymentMode : _divPaymentControlParent.find('input[type=checkbox][name=paymentMode][value=4],input[type=checkbox][name=paymentMode]')[0];
                }
                if (previousFirstSelectedPaymentMode.paymentModeID)
                    if (previousFirstSelectedPaymentMode.paymentModeID != 0)
                        DefaultPaymentMode = _divPaymentControlParent.find('input[type=checkbox][name=paymentMode][value=' + previousFirstSelectedPaymentMode.paymentModeID + ']');


                $(DefaultPaymentMode).click();

                var DefaultPaymentModeTr = _divPaymentControlParent.find('#divPaymentDetails tbody tr');
                DefaultPaymentModeTr.find('.bnk').val(previousFirstSelectedPaymentMode.bank);
                DefaultPaymentModeTr.find('#txtRefNo').val(previousFirstSelectedPaymentMode.refNo);
                DefaultPaymentModeTr.find('.swipeMachine').val(previousFirstSelectedPaymentMode.swipeMachine);
            }
        }
        callback(true);
    }

    var $onTenderExchangeAmountChanged = function (e, cashAmount) {
        Number(e.target.value) > 0 ? $('#txtControlReturnAmount').val(e.target.value - cashAmount) : $('#txtControlReturnAmount').val('');
    }

	var $onExchangeAmountChanged = function (cashAmt, NetAmt) {
        (Number(cashAmt) > 0 && Number(NetAmt) > 0) ? (Number(cashAmt) > Number(NetAmt) ? $('#lblControlReturnAmt').text(cashAmt - NetAmt) : $('#lblControlReturnAmt').text('')) : $('#lblControlReturnAmt').text('');
    }



    /// <summary>
    /// Add BillAmout To PaymentControl
    /// </summary>
    /// <param name="panelId">Pass integer PanelID For Bind Payment Mode</param>
    /// <param name="billAmount">Pass decimal Bill Amount Without Discount</param>
    /// <param name="disCountAmount">Pass decimal Discound Amount</param>
    /// <param name="isReceipt">Pass Boolean for Create Receipt or Not</param>
    /// <param name="isRefund">Pass Boolean for configure paymentControl For Refund</param>

    var userMinPayableAmount = 0;
    var $addBillAmount = function (data, callback) {

        debugger;
        if (Number(data.billAmount) < 0) {
            modelAlert('Invalid BillAmount', function () {
                $clearPaymentControl(function () { });
            });
            return;
        }

        if (Number(data.panelId) < 1) {
            modelAlert('Invalid Panel', function () {
                $clearPaymentControl(function () { });
            });
            return;
        }

        if (data.disCountAmount > data.billAmount) {
            modelAlert('Invalid Bill Amount & Discount Amount', function () {
                $clearPaymentControl(function () { });
            })
            return;
        }

        previousFirstSelectedPaymentMode = {};
        var isReciptsBool = _divPaymentControlParent.find('.isReciptsBool');
        data.isReceipt ? isReciptsBool.show() : isReciptsBool.hide();

        var billing = {};
        billing.disableDiscount = false;
        if (data.disableDiscount)
            billing.disableDiscount = data.disableDiscount;

        //var disableCredit = false;
        if (data.disableCredit)
            billing.disableCredit = data.disableCredit;
        else
            billing.disableCredit = false;

        billing.panelAdvanceAmount = 0;
        if (data.panelAdvanceAmount)
            billing.panelAdvanceAmount = Number(data.panelAdvanceAmount);
        else
            billing.panelAdvanceAmount = 0;

        if (data.minimumPayableAmount)
            billing.userMinPayableAmount = Number(data.minimumPayableAmount);
        else
            billing.userMinPayableAmount = 0;

        if (data.patientAdvanceAmount)
            billing.patientAdvanceAmount = Number(data.patientAdvanceAmount);
        else
            billing.patientAdvanceAmount = 0;

        billing.autoPaymentMode = 0;
        if (data.autoPaymentMode)
            billing.autoPaymentMode = data.autoPaymentMode ? 1 : 0;
        else
            billing.autoPaymentMode = 0;

        if (Number(data.panelId) == 1)
            billing.userMinPayableAmount = Number(data.billAmount);


        billing.panelMinPayableAmount = (Number(data.billAmount) - billing.userMinPayableAmount);







        _divPaymentControlParent.find('#txtCopaymentPercent').attr('disabled', !(billing.userMinPayableAmount <= 0)).attr('copayonbill', 1).val(0);
        _divPaymentControlParent.find('#txtCopaymentAmount').attr('disabled', !(billing.userMinPayableAmount <= 0)).attr('max-value', precise_round(Number(data.billAmount), _paymentControlRoundPlace)).val(0);



       // console.log(JSON.stringify(data));


        _divPaymentControlParent.find('#tdPaymentModes,#divPaymentDetails table tbody').html('');
        _divPaymentControlParent.find('#divPaymentControlParent input[type=text]').val('')

        _divPaymentControlParent.find('#spnControlPatientAdvanceAmount').text(Number(data.patientAdvanceAmount));
        _divPaymentControlParent.find('#spnControlPanelAdvanceAmount').text(billing.panelAdvanceAmount);
        _divPaymentControlParent.find('#spnAutoPaymentMode').text(billing.autoPaymentMode);


        _divPaymentControlParent.find('#txtControlUserPayable').val(billing.userMinPayableAmount).attr('TotalUserPayableAmount', billing.userMinPayableAmount);
        _divPaymentControlParent.find('#txtControlPanelPayable').val(billing.panelMinPayableAmount).attr('TotalPanelPayableAmount', billing.panelMinPayableAmount);


        $bindPaymentMode(data.panelId, data.isReceipt, data.refund, billing.disableCredit, function () {
            _divPaymentControlParent.find('#txtControlBillAmount').val(precise_round(Number(data.billAmount), _paymentControlRoundPlace));
            $maxOPDAdvanceAmount = (Number(data.patientAdvanceAmount) > Number(data.billAmount) ? Number(data.billAmount) : Number(data.patientAdvanceAmount));



            var $discountPerCent = precise_round((Number(data.disCountAmount) * 100 / Number(data.billAmount)), _paymentControlRoundPlace);
            $discountPerCent = isNaN($discountPerCent) ? 0 : $discountPerCent;
            calculatePayableAmount($discountPerCent, function () {

                _divPaymentControlParent.find('#txtControlDiscountPerCent').val($discountPerCent);
                var netAmount = Number(data.billAmount) - Number(data.disCountAmount);
                var roundOffNetAmount = precise_round(netAmount, _paymentControlRoundPlace);
                _divPaymentControlParent.find('#txtControlNetAmount').val(roundOffNetAmount);
                _divPaymentControlParent.find('#txtControlDiscountAmount').attr('max-value', roundOffNetAmount);
                _divPaymentControlParent.find('#txtControlRoundOff').val(precise_round(roundOffNetAmount - netAmount, _paymentControlRoundPlace));
                var discountControls = _divPaymentControlParent.find('#txtControlDiscountAmount,#txtControlDiscountPerCent,#ddlControlApprovedBY,#ddlControlDiscountReason');
                if (data.refund.status) {
                    data.refund.status ? discountControls.attr('disabled', true) : discountControls.attr('disabled', false);
                    _divPaymentControlParent.find('#ddlControlApprovedBY,#txtControlRemarks').prop('disabled', false).toggleClass('customRequired', true);
                    _divPaymentControlParent.find('#txtControlDiscountAmount').val(precise_round(parseFloat(data.disCountAmount), _paymentControlRoundPlace)).prop('disabled', true);
                    data.refund.status ? _divPaymentControlParent.find('#lblPaymentType').text('Refundable').attr('isRefund', '1') : _divPaymentControlParent.find('#lblPaymentType').text('Payable').attr('isRefund', '1');
                }
                else {
                    if (parseFloat(data.disCountAmount) > 0 || billing.disableDiscount) {
                        _divPaymentControlParent.find('#txtControlDiscountAmount').val(precise_round(parseFloat(data.disCountAmount), _paymentControlRoundPlace)).prop('disabled', true);
                        _divPaymentControlParent.find('#txtControlDiscountPerCent').prop('disabled', true);
                        _divPaymentControlParent.find('#ddlControlDiscountReason,#ddlControlApprovedBY').prop('disabled', false).toggleClass('customRequired', (Number(data.disCountAmount) > 0));

                        var _disableReasonAndApprovBy = false;
                        if (billing.disableDiscount)
                            _disableReasonAndApprovBy = true;


                        _divPaymentControlParent.find('#ddlControlDiscountReason,#ddlControlApprovedBY').prop('disabled', !(Number(data.disCountAmount) > 0)).toggleClass('customRequired', (Number(data.disCountAmount) > 0));
                    }
                    else {
                        discountControls.val(0.00).prop('disabled', false);
                        _divPaymentControlParent.find('#ddlControlDiscountReason,#ddlControlApprovedBY').prop('disabled', false).toggleClass('customRequired', false);
                    }
                }

                $setDefaultPaymentMode(function () {
                    $calculateTotalPaymentAmount(null, function () { });
                $onChangeCurrency($('#ddlCurrency')[0], function () { });
               });
            });
        });
    }


    var $calculateTotalPaymentAmount = function (event, callback) {
        
        var $totalPaidAmount = 0;
        _divPaymentControlParent.find('#divPaymentDetails table tbody tr #tdBaseCurrencyAmount').each(function () { $totalPaidAmount += Number(this.innerHTML); });
        var $netAmount = parseFloat(_divPaymentControlParent.find('#txtControlNetAmount').val());
        var $roundOffTotalPaidAmount = precise_round($totalPaidAmount, 0);
        _divPaymentControlParent.find('#txtControlCurrencyRoundOff').val($roundOffTotalPaidAmount - $totalPaidAmount);
        var patientPayableAmount = (Number(_divPaymentControlParent.find('#txtControlUserPayable').val()) + Number($roundOffTotalPaidAmount - $totalPaidAmount));
        //_divPaymentControlParent.find('#txtControlUserPayable').val(patientPayableAmount);
        var selectedPayments = _divPaymentControlParent.find('#divPaymentDetails table tbody tr:last-child');
        var val = selectedPayments.find('#tdPaymentModeID').html();
        var panelPaidAmountrow = 0;
        _divPaymentControlParent.find('#divPaymentDetails #tdPaymentModeID').each(function () {
            if (Number($(this).text()) == 8)
                panelPaidAmountrow += Number($(this).closest('tr').find('#tdBaseCurrencyAmount').text());
        });
        var $totalPaidAmountpatient = precise_round($totalPaidAmount - panelPaidAmountrow,_paymentControlRoundPlace);
        if (val != 8) {
            if ($totalPaidAmountpatient > patientPayableAmount) {
                $('input:checkbox[value="' + val + '"]').attr('checked', false);
                _divPaymentControlParent.find('#divPaymentDetails table tbody tr:last-child').remove().html('');
              //  modelAlert('Can Not Collect More Than The Patient Payable Amount.', function () { });
             //   return;
            }
        }
        if ($roundOffTotalPaidAmount > $netAmount) {
            if (event != null) {
                var row = $(event.target).closest('tr');
                var targetBaseCurrencyAmountTd = row.find('#tdBaseCurrencyAmount');
                //roundOffNetAmount = precise_round($netAmount, 0);
                //_divPaymentControlParent.find('#txtControlRoundOff').val(precise_round(roundOffNetAmount - $netAmount, _paymentControlRoundPlace));
                var tragetBaseCurrencyAmount = $.trim(targetBaseCurrencyAmountTd.text());
                _divPaymentControlParent.find('#txtControlPaymentAmount').val(precise_round($totalPaidAmount - tragetBaseCurrencyAmount, _paymentControlRoundPlace));
                _divPaymentControlParent.find('#txtControlBlanceAmount').val(precise_round(($netAmount - ($totalPaidAmount - tragetBaseCurrencyAmount)+parseFloat(_divPaymentControlParent.find('#txtControlRoundOff').val())), _paymentControlRoundPlace));
                targetBaseCurrencyAmountTd.text(0);
                row.find('#txtPaidAmount').val(0);
            }
        }
        else {

            //roundOffNetAmount = precise_round($netAmount, 0);
            //_divPaymentControlParent.find('#txtControlRoundOff').val(precise_round(roundOffNetAmount - $netAmount, _paymentControlRoundPlace));

            _divPaymentControlParent.find('#txtControlPaymentAmount').val(precise_round($totalPaidAmount, _paymentControlRoundPlace));
            _divPaymentControlParent.find('#txtControlBlanceAmount').val(precise_round(parseFloat(_divPaymentControlParent.find('#txtControlNetAmount').val()) - parseFloat(_divPaymentControlParent.find('#txtControlPaymentAmount').val()), _paymentControlRoundPlace));
        }
        var totalDiscountPercent = Number(_divPaymentControlParent.find('#txtControlDiscountPerCent').val());
        if ($.isFunction(window['onPaymentControlAmountChanged']))
            onPaymentControlAmountChanged({ totalPaidAmount: $totalPaidAmount, totalDiscountPercent: totalDiscountPercent });
    };





    var $clearPaymentControl = function (callback) {
        var i = _divPaymentControlParent.find('#txtControlRemarks');
        _divPaymentControlParent.find('input[type=checkbox][name=paymentMode]:checked').click();
        _divPaymentControlParent.find('#tdPaymentModes,#divPaymentDetails table tbody,#spnPanelID').html('');
        _divPaymentControlParent.find('input[type=text]').not(i).val(0.00);
        _divPaymentControlParent.find('#txtControlRemarks').val('');
        _divPaymentControlParent.find('#ddlControlDiscountReason,#ddlControlApprovedBY').prop('selectedIndex', 0).toggleClass('customRequired', false);
        _divPaymentControlParent.find('#spnControlPatientAdvanceAmount,#spnControlPanelAdvanceAmount').text(0);
        //_divPaymentControlParent.find('#spnBaseCurrency,#spnBaseCountryID,#spnBaseNotation,#spnCFactor').text('');
        _divPaymentControlParent.find('#txtControlUserPayable').attr('TotalUserPayableAmount', 0);
        _divPaymentControlParent.find('#txtControlPanelPayable').attr('TotalPanelPayableAmount', 0);
        _divPaymentControlParent.find('.isReciptsBool').hide();
        callback(true);
    }


    var $getPaymentDetails = function (callback) {

        //var $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
        var selectedPayments = _divPaymentControlParent.find('#divPaymentDetails table tbody tr');
        $unSelectedBankCount = selectedPayments.find('td .bnk').filter(function () { if (this.value == '0') { return this } }).length;
        var panelPaidAmount = 0;
        _divPaymentControlParent.find('#divPaymentDetails #tdPaymentModeID').each(function () {
            if (Number($(this).text()) == 8)
                panelPaidAmount += Number($(this).closest('tr').find('#tdBaseCurrencyAmount').text());
        });
        $payment = {};
        $payment.billAmount = Number(_divPaymentControlParent.find('#txtControlBillAmount').val());
        $payment.discountAmount = Number(_divPaymentControlParent.find('#txtControlDiscountAmount').val());
        $payment.discountPercent = Number(_divPaymentControlParent.find('#txtControlDiscountPerCent').val());
        $payment.netAmount = Number(_divPaymentControlParent.find('#txtControlNetAmount').val());
        $payment.adjustment = Number(_divPaymentControlParent.find('#txtControlPaymentAmount').val());
        $payment.panelPayableAmount = precise_round(Number(_divPaymentControlParent.find('#txtControlPanelPayable').val()), 4);
        $payment.patientPayableAmount = precise_round(Number(_divPaymentControlParent.find('#txtControlUserPayable').val()), 4);
        $payment.panelPaidAmount = precise_round(panelPaidAmount, 4);
        $payment.patientPaidAmount = precise_round($payment.adjustment - $payment.panelPaidAmount, 4);

        $payment.roundOff = Number(_divPaymentControlParent.find('#txtControlRoundOff').val());
        $payment.currencyRoundOff = Number(_divPaymentControlParent.find('#txtControlCurrencyRoundOff').val());
        $payment.discountReason = _divPaymentControlParent.find('#ddlControlDiscountReason').val() == '0' ? '' : _divPaymentControlParent.find('#ddlControlDiscountReason').val();
        $payment.approvedBY = _divPaymentControlParent.find('#ddlControlApprovedBY').val() == '0' ? '' : _divPaymentControlParent.find('#ddlControlApprovedBY').val();
        $payment.paymentRemarks = _divPaymentControlParent.find('#txtControlRemarks').val();
        $payment.coPaymentPercent = Number(_divPaymentControlParent.find('#txtCopaymentPercent').val());
        $payment.coPaymentAmount = Number(_divPaymentControlParent.find('#txtCopaymentAmount').val());
        $payment.isCoPaymentOnBill = Number(_divPaymentControlParent.find('#txtCopaymentPercent').attr('copayonbill'));

        if ($unSelectedBankCount > 0) {
            modelAlert('Please Select Payment Bank.');
            return false;
        }

        var isRefund = Number(_divPaymentControlParent.find('#lblPaymentType').attr('isRefund'));
        isRefund = isNaN(isRefund) ? 0 : isRefund;

        if (($payment.discountAmount > 0) && (isRefund == 0)) {
            if (String.isNullOrEmpty($payment.discountReason.trim())) {
                modelAlert('Please Select Discount Reason');
                return false;
            }
            if ((String.isNullOrEmpty($payment.approvedBY.trim())) && (isRefund == 0)) {
                modelAlert('Please Select Approved By');
                return false;
            }
        }

        //if (userMinPayableAmount > 0 && ($payment.adjustment < userMinPayableAmount)) {
        //	modelAlert('Payment amount is equal to Panel Non-Payable Amount');
        //	return false;
        //}



        $payment.paymentDetails = [];
        _divPaymentControlParent.find('#divPaymentDetails table tbody tr').each(function (index, elem) {
            var $row = $(elem);
            var paymentModeID = Number($($row).find('#tdPaymentModeID').text());
            $payment.paymentDetails.push({
                Amount: Number((paymentModeID == 4) ? $payment.netAmount : $($row).find('#tdBaseCurrencyAmount').text().trim()),
                BaceCurrency: $($row).find('#tdBaceCurrency').text(),
                BankName: String.isNullOrEmpty($($row).find('#tdBankName select').val()) ? '' : $($row).find('#tdBankName select').val(),
                C_Factor: $($row).find('#tdC_Factor').text(),
                PaymentMode: $($row).find('#tdPaymentMode').text().trim(),
                PaymentModeID: paymentModeID,
                RefNo: String.isNullOrEmpty($($row).find('#tdRefNo input').val()) ? '' : $($row).find('#tdRefNo input').val(),
                S_Amount: Number((paymentModeID == 4) ? $payment.netAmount : $.trim($($row).find('#txtPaidAmount').val())),
                S_CountryID: Number($($row).find('#tdS_CountryID').text()),
                S_Currency: $($row).find('#tdS_Currency').text().trim(),
                S_Notation: $($row).find('#tdS_Notation').text().trim(),
                swipeMachine: String.isNullOrEmpty($($row).find('#tdSwipeMachineID select').val()) ? '' : $($row).find('#tdSwipeMachineID select').val(),
            });
        });
        if ($payment.discountPercent < 100) {
            var zeroAmountPaymentModes = $payment.paymentDetails.filter(function (p) { if (p.Amount <= 0 && p.PaymentModeID != 4) { return p; } });
           if (zeroAmountPaymentModes.length > 0) {
               modelAlert('Invalid ' + zeroAmountPaymentModes[0].PaymentMode + ' Amount', function () {});
               return;
           }
        }

        //required PaymentMode Reference validation
        var requiredReferencePaymentModeID = [2, 3, 6];

        var blankReferencePaymentDetails = $payment.paymentDetails.filter(function (p) {
            if (requiredReferencePaymentModeID.indexOf(p.PaymentModeID) > -1) {
                if (String.isNullOrEmpty(p.RefNo))
                    return p;
            }
        });


        if (blankReferencePaymentDetails.length > 0) {
            modelAlert('Please Enter Payment Ref No.');
            return false;
        }

        //required PaymentMode Reference validation
        

        callback($payment);
    }

    var $restrictPaymentMode = function (callback) {
        _divPaymentControlParent.find('#paymentControlTable').find('#lblPaymentModeLabel,#divPaymentDetails,#tdPaymentModes').hide();
        callback(true);
    }



    
    $onPaymentModeChange = function (elem, ddlCurrency, callback) {
        debugger;
        if (elem.checked == false) {
            _divPaymentControlParent.find('#divPaymentDetails').find('#' + ddlCurrency.val() + elem.value).remove();
            if (elem.value == 4 || elem.value == 7 || elem.value == 8)
                _divPaymentControlParent.find(ddlCurrency).prop('disabled', false);
            $calculateTotalPaymentAmount(function () { });
            if (elem.value == 9) {
                $("#IsMpesaMode").text(0);
                BtnHideShowPayment(0);
            }
            return;
        }

        if (elem.value == 9) {
            $("#IsMpesaMode").text(1);
        }
        $validatePaymentModes(elem, Number($('#txtControlNetAmount').val()), $('#ddlCurrency'), function (response) {
            $bindPaymentDetails(response, function (response) {
                $bindPaymentModeDetails(response, function (data) {
                    $bindBankMaster(data.bankControl, function () {
                        $calculateTotalPaymentAmount(function () {
                        });
                    });
                });
            });
        });

        if (elem.value == 9) {
            BtnHideShowPayment(1);
        } else {
            BtnHideShowPayment(0);
        }
    }


    var $bindBankMaster = function (bankControls, callback) {
        $getBankMaster(function (response) {
            $(bankControls).bindDropDown({
                data: response,
                valueField: 'BankName',
                textField: 'BankName',
                defaultValue: '',
                selectedValue: ''
            });
            callback(true);
        });
    }

    var $convertToBaseCurrency = function (countryID, amount, callback) {
        var baseCurrencyCountryID = Number(_divPaymentControlParent.find('#spnBaseCountryID').text());
        amount = Number(amount);
        amount = isNaN(amount) ? 0 : amount;
        if (baseCurrencyCountryID == countryID || amount == 0) {
            callback(amount);
            return false;
        }
        try {
            serverCall('../Common/CommonService.asmx/ConvertCurrency', { countryID: countryID, Amount: amount }, function (response) {
                callback(Number(response));
            });
        } catch (e) {
            callback(0);
        }

    }


    var $getConversionFactor = function (countryID, callback) {
        serverCall('../Common/CommonService.asmx/GetConversionFactor', { countryID: countryID }, function (response) {
            callback(response);
        });
    }

    var $convertCurrency = function (countryID, amount, callback) {
        serverCall('../Common/CommonService.asmx/getConvertCurrecncy', { countryID: countryID, Amount: amount }, function (response) {
            callback(response);
        });
    }

    var $bankMaster = [];
    var $getBankMaster = function (callback) {
        if ($bankMaster.length < 1) {
            serverCall('../Common/CommonService.asmx/GetBankMaster', {}, function (response) {
                $bankMaster = JSON.parse(response);
                callback($bankMaster);
            });
        }
        else
            callback($bankMaster);
    }

    var bindApprovedMaster = function (callback) {
        serverCall('../EDP/Services/EDP.asmx/bindDisAppoval', { ApprovalType: '', Type: '1' }, function (response) {
            if (String.isNullOrEmpty(response))
                response = '[]';

            var discountApprovalMaster = JSON.parse(response);
            var ddlControlApprovedBY = _divPaymentControlParent.find('#ddlControlApprovedBY');
            ddlControlApprovedBY.bindDropDown({
                data: discountApprovalMaster,
                valueField: 'ApprovalType',
                textField: 'ApprovalType',
                defaultValue: '',
                selectedValue: ''
            });
            callback(ddlControlApprovedBY.val());

        });
    }

    var $getCurrencyDetails = function (callback) {
        var ddlCurrency = _divPaymentControlParent.find('#ddlCurrency');
        serverCall('../Common/CommonService.asmx/LoadCurrencyDetail', {}, function (response) {
            var responseData = JSON.parse(response);
            _divPaymentControlParent.find('#spnBaseCurrency').text(responseData.baseCurrency);
            _divPaymentControlParent.find('#spnBaseCountryID').text(responseData.baseCountryID);
            _divPaymentControlParent.find('#spnBaseNotation').text(responseData.baseNotation);
            $(ddlCurrency).bindDropDown({
                data: responseData.currancyDetails,
                valueField: 'CountryID',
                textField: 'Currency',
                selectedValue: responseData.baseCountryID
            });
            callback(ddlCurrency.val());
        });
    }

    var paymentModePanelWiseCache = [];
    var $bindPaymentModePanelWise = function (panelId, callback) {
        var IsCache = paymentModePanelWiseCache.filter(function (i) { if (i.PanelID == panelId) { return i } });
        if (IsCache.length > 0)
            callback(paymentModePanelWiseCache);
        else {
            serverCall('../Common/CommonService.asmx/BindPaymentModePanelWise', { PanelID: panelId }, function (response) {
                paymentModePanelWiseCache = JSON.parse(response);
                callback(paymentModePanelWiseCache);
            });
        }
    }
    var bindDiscReason = function (callback) {
        serverCall('../Common/CommonService.asmx/GetDiscReason', { Type: 'OPD' }, function (response) {
            var $ddlControlDiscountReason = _divPaymentControlParent.find('#ddlControlDiscountReason');
            $ddlControlDiscountReason.bindDropDown({
                defaultValue: '', selectedValue: '', data: JSON.parse(response), valueField: 'DiscountReason', textField: 'DiscountReason', isSearchAble: false
            });
            callback($ddlControlDiscountReason.find('option:selected').text());
        });
    }


    var openDiscountReasonModel = function () {
        _divPaymentControlParent.find('#txtDiscReason').val('');
        $('#divModelDiscountReason').showModel();
    }

    var closeDiscountReasonModel = function () {
        $('#divModelDiscountReason').closeModel();
    }

    var saveDiscountReason = function (discountReasonDetails) {
        if (String.isNullOrEmpty(discountReasonDetails.discountReason)) {
            modelAlert('Please Enter Discount Reason ');
            return false;
        }
        serverCall('../Common/CommonService.asmx/SaveNewDiscountReason', { discountReason: discountReasonDetails.discountReason, type: 'OPD' }, function (response) {
            $ID = parseInt(response);
            if ($ID == 0)
                modelAlert('Discount Reason Already Exist');
            else if ($ID > 0) {
                bindDiscReason(function () {
                    closeDiscountReasonModel();
                });
                modelAlert('Discount Reason Saved Successfully');
            }
        });
    }


    var onCoPayPercentChange = function (e) {

        var netGrossBillAmount = Number(_divPaymentControlParent.find('#txtControlBillAmount').val());
        var copayPercent = Number(e.target.value);
        if (copayPercent <= 0)
            copayPercent = 0;

        var userMinPayableAmount = precise_round((netGrossBillAmount * copayPercent) / 100, _paymentControlRoundPlace);
        var panelMinPayableAmount = precise_round((netGrossBillAmount - userMinPayableAmount), _paymentControlRoundPlace);
        _divPaymentControlParent.find('#txtControlUserPayable').val(userMinPayableAmount).attr('TotalUserPayableAmount', userMinPayableAmount);
        _divPaymentControlParent.find('#txtControlPanelPayable').val(panelMinPayableAmount).attr('TotalPanelPayableAmount', panelMinPayableAmount);
        _divPaymentControlParent.find('#txtControlDiscountPerCent').keyup();
    }


    var onCoPayAmountChange = function (e) {

        var netGrossBillAmount = Number(_divPaymentControlParent.find('#txtControlBillAmount').val());
        var copayPercent = precise_round((100 * Number(e.target.value)) / netGrossBillAmount, _paymentControlRoundPlace);
        if (copayPercent <= 0)
            copayPercent = 0;


        var userMinPayableAmount = precise_round((netGrossBillAmount * Number(copayPercent)) / 100, 0);
        var panelMinPayableAmount = precise_round((netGrossBillAmount - userMinPayableAmount), _paymentControlRoundPlace);
        _divPaymentControlParent.find('#txtCopaymentPercent').val(copayPercent);
        _divPaymentControlParent.find('#txtControlUserPayable').val(userMinPayableAmount).attr('TotalUserPayableAmount', userMinPayableAmount);
        _divPaymentControlParent.find('#txtControlPanelPayable').val(panelMinPayableAmount).attr('TotalPanelPayableAmount', panelMinPayableAmount);
        _divPaymentControlParent.find('#txtControlDiscountPerCent').keyup();
    }



</script>
<div id="divPaymentControlParent" class="POuter_Box_Inventory">
	<span id="spnControlPatientAdvanceAmount" style="display:none">0</span>
	<span id="spnControlPanelAdvanceAmount" style="display:none">0</span>
    <span id="spnControlMaxEligibleDiscountPercent" runat="server" ClientIDMode="static" style="display:none">0</span>
	<span id="spnBaseCurrency" style="display:none"></span>
	<span id="spnBaseCountryID" style="display:none"></span>
	<span id="spnBaseNotation" style="display:none"></span>
	<span id="spnCFactor" style="display:none"></span>
    <span id="spnAutoPaymentMode" style="display:none"></span>
	<div style="margin-top: 0px;" class="row">
		<div class="col-md-15 ">
			<div style="display:none"  class="row isReciptsBool">
				<div style="padding-right: 0px;" class="col-md-4">
								<label class="pull-left">Currency</label>
								<b class="pull-right">:</b>
				</div>
				<div style="padding-left: 15px;" class="col-md-3">
					<select onchange="$onChangeCurrency(this,function(){});" id="ddlCurrency">
					</select>
				</div>
				<div id="spnBlanceAmount" style="color:red;font-weight:bold;text-align: left;padding-top: 3px;" class="col-md-4">
				  
				</div>
				<div style="padding-top: 3px;" class="col-md-2">
								<label class="pull-left">Factor</label>
								<b class="pull-right">:</b>
				</div>
				<div id="spnConvertionRate" style="color:red;font-weight:bold;text-align: left;padding-top: 3px;" class="col-md-9">
				  
				</div>
				<%--<div  class="col-md-4">
					<label style="padding-top: 3px;" class="pull-left divPanelAdvance">Panel Advance</label>
								<b style="padding-top: 3px;" class="pull-right divPanelAdvance">:</b>
				</div>--%>
				<div class="col-md-2">
						<%--<b style="padding-top: 3px;" id="spnControlPanelAdvanceAmount" class="pull-left divPanelAdvance patientInfo">0</b>--%>
				</div>

			</div>
			<div style="display:none" class="row isReciptsBool">
				<div style="padding-right: 0px;" class="col-md-4">
					 <label class="pull-left">PaymentMode</label>
					 <b class="pull-right">:</b>
				</div>
				<div style="padding-left: 15px;" id="tdPaymentModes"  class="col-md-19"></div>
			</div>
			<div style="display:none"  class="row isReciptsBool">
				<div id="divPaymentDetails" class="col-md-24">
				<table  class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%;border-collapse:collapse;">
				 <thead>
				 <tr id="headTr">
				 <th class="GridViewHeaderStyle" style="width: 125px;" scope="col" >Payment Mode</th>
				 <th class="GridViewHeaderStyle" style="width: 105px;" scope="col" >Paid Amount</th>
				 <th class="GridViewHeaderStyle" style="width: 75px;" scope="col" >Currency</th>
				 <th class="GridViewHeaderStyle" style="width: 150px;"  scope="col" >Bank Name</th>
				 <th class="GridViewHeaderStyle" style="width: 80px;"  scope="col" >Ref No.</th>
				 <th class="GridViewHeaderStyle" style="width: 150px;" scope="col" >Machine</th>
				 <th class="GridViewHeaderStyle" style="width: 150px;" scope="col" >Base</th>
				 </tr>
				 </thead>
				 <tbody></tbody>
				</table>
			</div>
			</div>
            <div style="display:none" class="row isReciptsBool">
				<div style="padding-right: 0px;" class="col-md-4">
                    <label id="IsMpesaMode" style="display:none">0</label>
					  <input type="button" id="bntMpesaRequest" value="Make Payment" style="display:none" onclick="showPages()" />
				</div> 
			</div>

		</div>
		<div class="col-md-9">

            <div class="row">
				<div class="col-md-7">
				   <label class="pull-left">Co-Pay Percent</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
				   <input  id="txtCopaymentPercent" disabled="disabled" class="ItDoseTextinputNum"  value="0.00" autocomplete="off" data--title="Payable By Patient"  type="text" onlynumber="5" decimalplace="4" max-value="100" onkeyup="onCoPayPercentChange(event);" copayonbill="0"  tabindex="100" />
				</div>
				<div class="col-md-7">
				   <label class="pull-left">Co-Pay Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
						<input  id="txtCopaymentAmount" disabled="disabled" class="ItDoseTextinputNum"  value="0.00"  type="text" data--title="Payable By Patient"  onlynumber="10" decimalplace="4" max-value="10000"  autocomplete="off" onkeyup="onCoPayAmountChange(event)"  tabindex="101" />
				</div>
			</div>


			<div class="row">
				<div class="col-md-7">
				   <label class="pull-left">Gross Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
				   <input disabled="disabled" id="txtControlBillAmount" class="ItDoseTextinputNum"  value="0.00" autocomplete="off"  type="text"  />
				</div>
				<div class="col-md-7">
				   <label class="pull-left">Net Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
						<input disabled="disabled" class="ItDoseTextinputNum"  value="0.00" id="txtControlNetAmount"  type="text" autocomplete="off"  />
				</div>
			</div>
			<div class="row">
				<div class="col-md-7">
				   <label class="pull-left">Patient Payable</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
				   <input disabled="disabled" id="txtControlUserPayable" class="ItDoseTextinputNum"  value="0.00" autocomplete="off"  type="text"  />
				</div>
				<div class="col-md-7">
				   <label class="pull-left">Panel Payable</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
						<input disabled="disabled" class="ItDoseTextinputNum"  value="0.00" id="txtControlPanelPayable"  type="text" autocomplete="off"  />
				</div>
			</div>

			<div class="row">
				<div class="col-md-7">
				   <label class="pull-left">Discount Amt</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
				  <input  type="text" class="ItDoseTextinputNum" value="0.00" DiscountAmount onlynumber="10"  decimalPlace="4"  max-value="0" autocomplete="off"  disabled="disabled" id="txtControlDiscountAmount" onkeyUp="$onDiscountAmountChanged(event,$('#txtControlBillAmount').val(),$('#txtControlRoundOff').val())"  />
				</div>
				<div class="col-md-7">
				   <label id="lblPaymentType" class="pull-left">Paid Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					   <input disabled="disabled" class="ItDoseTextinputNum" value="0.00" id="txtControlPaymentAmount" type="text"  autocomplete="off" />
				</div>
			</div>
			<div class="row">
				<div class="col-md-7">
				   <label class="pull-left">Discount in %</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
				   <input  type="text" class="ItDoseTextinputNum"  value="0.00" onlynumber="5"  decimalPlace="4" max-value="100" disabled="disabled"  autocomplete="off" id="txtControlDiscountPerCent" onkeyUp="$onDiscountPercentChanged(event,$('#txtControlBillAmount').val(),$('#txtControlRoundOff').val())"  />
				</div>
				<div class="col-md-7">
				   <label class="pull-left">Round Off</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					  <input class="ItDoseTextinputNum"  value="0.00"  type="text" id="txtControlRoundOff" autocomplete="off" disabled="disabled"  />
				</div>
			</div>
			<div class="row">
				<div class="col-md-7">
				   <label class="pull-left"> Currency Round </label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					 <input  type="text" class="ItDoseTextinputNum"  value="0.00" id="txtControlCurrencyRoundOff" autocomplete="off" disabled="disabled" />
				</div>
				<div class="col-md-7">
				   <label class="pull-left">Balance Amount</label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					<input  type="text" class="ItDoseTextinputNum"  value="0.00"  id="txtControlBlanceAmount" autocomplete="off" disabled="disabled"  />
				</div>
			</div>
			<div class="row">
				 <div class="col-md-7">
                    <label class="pull-left">Change</label> <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
					 <input  type="text" class="ItDoseTextinputNum"  value="00" id="txtControlExchange" onlynumber="10" autocomplete="off"  onkeyUp="$onExchangeAmountChanged(this.value,$('#txtControlUserPayable').val());"   />
				</div>
				<div class="col-md-7">
				   <label class="pull-left" style="color:red">Return Amt</label>
								<b class="pull-right" style="color:red">:</b>
				</div>
				<div class="col-md-5">
					<strong><label id="lblControlReturnAmt" style="color:red"></label></strong>
				</div>
            </div>
		</div>
	</div>
    <div style="margin-top: 0px;" class="row">
         <div class="col-md-15">
              <div class="row">
				 <div class="col-md-4">
				   <label class="pull-left">Disc. Resason </label>
								<b class="pull-right">:</b>
				</div>
				<div style="margin-right:-4px" class="<%=Resources.Resource.allowNewDiscountReasonFromPaymentControl=="1"?"col-md-6":"col-md-8" %>"   ">
					<select  disabled="disabled" id="ddlControlDiscountReason"></select>
				</div>
				<div style="padding:0px;display:<%=Resources.Resource.allowNewDiscountReasonFromPaymentControl=="1"?"":"None"%>" class="col-md-2">
					<input style="float:left;box-shadow: none;"  type="button" value="New" onclick="openDiscountReasonModel()" />
				</div>
				 <div class="col-md-4">
				   <label class="pull-left">Approved By </label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-8">
					<select disabled="disabled" id="ddlControlApprovedBY">
						<option value=""></option>
					</select>
				</div>
                  </div>
             </div>
        <div class="col-md-9">
            <div class="row">
				 <div class="col-md-7">
				   <label class="pull-left">Mobile/Remarks </label>
								<b class="pull-right">:</b>
				</div>
				<div class="col-md-17">
					<input  type="text"  id="txtControlRemarks" autocomplete="off"  />
				</div>
			</div>
		</div>
	</div>





	<div id="divModelDiscountReason"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divModelDiscountReason" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add Discount Reason</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left"> Discount Reason </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="50"  id="txtDiscReason" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="saveDiscountReason({discountReason:$.trim(_divPaymentControlParent.find('#txtDiscReason').val())})">Save</button>
						 <button type="button"  data-dismiss="divModelDiscountReason" >Close</button>
				</div>
			</div>
		</div>
</div>



    <div  id="modalMpesaSettlement" class="modal fade">    
    <div class="modal-dialog"  tabindex="-1" >
            <div class="modal-content" style="width:700px;height:410px;">
                <div class="modal-header">
                  
                    <b class="modal-title">M-PESA PAYMENT</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <iframe  style="width:100%;height:300px;" id="iframe1" ></iframe>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer"> 
                       <button type="button" onclick="CloseMpesaSettleModel()">Close</button>
                </div>
            </div>
        </div>
        </div>




</div>



<script id="templatePaymentModes" type="text/html">  
		<#
		var dataLength=paymentModes.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var patientInfoClassPaymentModeID=[7,8];
		for(var j=0;j<dataLength;j++)
		{
		objRow = paymentModes[j];
		  #>
					<div class="ellipsis" style="float:left">
					<input type="checkbox"   name="paymentMode" onchange="$onPaymentModeChange(this,$('#ddlCurrency'),function(){});" value='<#=objRow.PaymentModeID#>'  />
					<b  <#=(patientInfoClassPaymentModeID.indexOf(objRow.PaymentModeID)>-1?"class='patientInfo'":'' ) #> > <#= objRow.PaymentMode  #> </b>
					</div>
			<#}#>       
</script>


<script type="text/javascript">
    _divPaymentControlParent = $('#divPaymentControlParent');
</script>


<script type="text/javascript">

    function BtnHideShowPayment(Typ) {

        var IsMpesaMode = $("#IsMpesaMode").text();

        if (Typ == 1) {
            if (IsMpesaMode == "1") {
                $("#bntMpesaRequest").show();
            } else {
                $("#bntMpesaRequest").hide();
            }

        }
        else {

            if (IsMpesaMode == "1") {
                $("#bntMpesaRequest").show();
            } else {
                $("#bntMpesaRequest").hide();
            }

        }

    }


    function GetAccessToken() {

        serverCall('../OPD/Services/MPesaIntegration.asmx/GetAccessToken', {}, function (response) {
            var responseData = JSON.parse(response);
            if (responseData.status) {
                modelAlert(responseData.response)
            }

        });
    }


    var OpenMpesaSettleModel = function (e) {
        e.preventDefault();
        var divSearchbyDate = $('#modalMpesaSettlement');
        divSearchbyDate.showModel();
    }
    function CloseMpesaSettleModel() {
        debugger
        var MobileNo = $("#iframe1").contents().find("#lblPhoneNumber").text();
        var MpesaReceipt = $("#iframe1").contents().find("#lblMpesaReceiptNumber").text();
        var CanGenrateBill = $("#iframe1").contents().find("#lblCanGenrateBill").text();
        $("#txtControlRemarks").val(MobileNo).attr("disabled", "disabled");;
         

        $("#Table1 tbody tr").each(function () {
            var PaymentModeID = $(this).closest('tr').find('#tdPaymentModeID').text(); 
            if (PaymentModeID == "9") {
                $(this).closest('tr').find('#txtRefNo').attr("disabled", "disabled");
                $(this).closest('tr').find('#txtRefNo').val(MpesaReceipt);
            } 
        });
         
        if (CanGenrateBill == "1") { 
            jQuery('#btnSavePayment').trigger('click');
        } else if (CanGenrateBill == "2") {
            modelAlert("Can not generate Receipt,You Close Before Processing .");
        }
        else {
            modelAlert("Can not generate Receipt,Mpesa payment Failed");
        }
       
        $('#modalMpesaSettlement').closeModel();
    

    }
    function showPages() {
        var status = navigator.onLine;
        if (!status) {
            modelAlert("Please Connect to Internet");
            return false;
        }

        var PatientID = "";
        var BillNo = "";

        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

        if (pageName == 'receiptbill.aspx') { 
            PatientID = $("#lblPatientID").text();
            BillNo = $("#lblTransactionNo").text();

        } else if (pageName == 'mortuaryreceiptbill.aspx') {

            PatientID = $("#lblCorpseNo").text();
            BillNo = $("#lblTransaction_ID").text();

        }
        else {

            PatientID = $("#lblMrNo").text();
            BillNo = $("#Label2").text();
        }


        $("#Table1 tbody tr").each(function () {
            var PaymentModeID = $(this).closest('tr').find('#tdPaymentModeID').text();
            if (PaymentModeID == "9") {
                $(this).closest('tr').find('#txtPaidAmount').attr("disabled", "disabled");
                Amount = $(this).closest('tr').find('#txtPaidAmount').val();

                $('#iframe1').attr('src', "../OPD/MPesaRequestPage.aspx?PatientID=" + PatientID + "&BillNo=" + BillNo + "&Amount=" + Amount + "");
                $("#modalMpesaSettlement").show();
            }

        });


       
    }
    function RemoveAllSpace(rowid) {
        var ref = $(rowid).closest('tr').find('#txtRefNo').val();        
        var finalVal = ref.replace(/\s/g, '');
        $(rowid).closest('tr').find('#txtRefNo').val(finalVal);

    }
     

    function checkValidReffNo(rowid) {
        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

       var  Depositor = "";
        if (pageName == 'opdfinalsettlementnew.aspx') {
            Depositor = $("#lblMrNo").text();
        }

        var ref = $(rowid).closest('tr').find('#txtRefNo').val();
        var finalVal = ref.replace(/\s/g, '');
        if (finalVal.length==10) {
            serverCall('../common/CommonService.asmx/MatchReffNo', { RefNo: finalVal, Depositor: Depositor }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        $(rowid).closest('tr').find('#txtRefNo').val("");
                    })
                }

            });
        }
        

    }
</script>