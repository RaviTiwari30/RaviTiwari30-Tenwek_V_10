<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDPharmacyIssue.aspx.cs" Inherits="Design_Store_OPDPharmacyIssue" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>
<%@ Register Src="~/Design/Controls/UCPanel.ascx" TagName="PanelControl" TagPrefix="UC3" %>
<%@ Register Src="~/Design/Controls/PrintPharmacyLabel.ascx" TagName="wuc_PrintPharmacyLabel" TagPrefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css">
  <style type="text/css">
      .Orange {
      background-color:orange;
      }
  </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $paymentControlInit(function () {
                initMedicineSearch(function () {
                    $commonJsInit(function () {
                        $('.textbox-text.validatebox-text').attr('tabindex', 6);
                        init(function () { });
                    });
                });
            });
        });


        var initMedicineSearch = function (callback) {
            try {
                getComboGridOption(function (response) {
                    $('#divMedicineSelect').removeAttr('style');
                    $('#txtMedicineSearch').combogrid(response);
                    $('#divMedicineSelect').hide();
                    callback(true);
                });
            } catch (e) {

            }
        }


        var init = function (callback) {
            $getHashCode(function () {
                bindDoctor('All', function () {
                    bindRefferDoctor(function () {
                        bindPanel(function () {
                            $('#tblSelectedMedicine tbody').bind('DOMSubtreeModified', function () {
                                var rowlength = $(this).find('tr').length;
                                if (rowlength > 0) {
                                    $('#divSelectedMedicine,#paymentControlDiv,#divAction').show();
                                    $('input[type=radio][name=rdoPatientType]').prop('disabled', true);
                                    //$('#ddlPanelCompany').prop('disabled', true).chosen('destroy').chosen({ width: '100%' });
                                    $('#lblTotalSelectedItemsCount').text('Items : ' + rowlength);
                                }
                                else {
                                    $('#divSelectedMedicine,#paymentControlDiv,#divAction').hide();
                                    $('input[type=radio][name=rdoPatientType]').prop('disabled', false);
                                    $('#ddlPanelCompany').prop('disabled', false).chosen('destroy').chosen({ width: '100%' });
                                    $('#lblTotalSelectedItemsCount').text('Items : 0');
                                    $clearPaymentControl(function () { });
                                }
                            });
                            attchBarcodeScanEvent();
                        });
                    });
                });
                bindRole();
            });
        }


        var attchBarcodeScanEvent = function () {
            $('#txtMedicineSearch').closest('.panel-noscroll').find('.validatebox-text').keyup(function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    var options = $('#txtMedicineSearch').combogrid('options');
                    options.queryParams.isBarCodeScan = true;
                }
            }).keypress(function () {
                var options = $('#txtMedicineSearch').combogrid('options');
                options.queryParams.isBarCodeScan = false;
            });;
        }

        var calculateTotal = function (callback) {
            var totalAmount = 0;
            var totalDiscountAmount = 0;

            var panelNonPayableAmount = 0;

            var isPaymentcontrolInit = 0;



            $('#tblSelectedMedicine tbody tr').each(function () {
                totalAmount += Number($(this).find('#tdGrossAmount').text());
                totalDiscountAmount += Number($(this).find('#txtItemDiscountAmount').val());
                $isPayable = Number($(this).find('#spnIsPayable').text());

                var GrossAmtItemWise = Number($(this).find('#tdGrossAmount').text());

                if ($isPayable == 0) {
                    $coPaymentPercent = Number($(this).find('#spnCoPaymentPercent').text());

                    if ($coPaymentPercent > 0)
                        panelNonPayableAmount = panelNonPayableAmount + (((GrossAmtItemWise) * $coPaymentPercent) / 100);
                }
                else if ($isPayable == 1)
                    panelNonPayableAmount = panelNonPayableAmount + (GrossAmtItemWise);

            });
            if (totalAmount > 0) {
                //dev
                $getPanelDetails(function (panelDetails) {
                    var patientType = $.trim($('input[type=radio][name=rdoPatientType]:checked').val());
                    var panelId = (patientType == '1' || patientType == '3') ? panelDetails.panel.panelID : '<%=Resources.Resource.DefaultPanelID%>';
                    $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                   // $isReceipt = false;
                    var IsDiscountAuthorization = '<%=Util.GetInt(ViewState["IsDiscount"])%>';
                    $addBillAmount({
                        panelId: panelId,
                        billAmount: totalAmount,
                        disCountAmount: totalDiscountAmount,
                        isReceipt: $isReceipt,
                        patientAdvanceAmount: 0,
                        autoPaymentMode: true,
                        minimumPayableAmount: panelNonPayableAmount,
                        //disableCredit: (patientType == '2' ? true : false),
                        disableDiscount: IsDiscountAuthorization == '0' ? true : false,
                        refund: { status: false },
                        autoPaymentMode: true
                    }, function () { });
                    callback();
                });
            }
            else {
                $clearPaymentControl(function () {
                    callback();
                });
            }
        }

        var onQuantityChange = function (elem, callback) {
            var row = $(elem).closest('tr');
            var quantity = isNaN(parseFloat(elem.value)) ? 0 : elem.value;
            var mrp = parseFloat(row.find('#tdMRP').text());
            var grossAmount = precise_round((parseFloat(quantity) * parseFloat(mrp)), 4);
            row.find('#tdGrossAmount').text(grossAmount);
            $discountPrecent = Number(row.find('#txtItemDiscountPercent').val());
            var dicountAmount = Number((grossAmount * $discountPrecent) / 100)//Number(row.find('#txtItemDiscountAmount').val());
            //if(dicountAmount == 0)
            //{
            //    $row.find('#txtItemDiscountPercent').val('0');
            //}
            row.find('#txtItemDiscountAmount').val(dicountAmount);
          //  var dicountAmount = Number(row.find('#txtItemDiscountAmount').val());
            var netAmount = precise_round((grossAmount - dicountAmount), 4);
            row.find('#tdAmount').text(netAmount);
            $('#txtItemDiscountAmount').attr('max-value', netAmount);

            row.find('#tdActualIssueQty').text(quantity);
            calculateTotal(function (total) {
                callback();
            });
        }


        var onItemDiscountChange = function (e, callback) {
            var inputValueCode = (e.which) ? e.which : e.keyCode;
            if ([37, 38, 39, 40].indexOf(inputValueCode) < 0) {
                $row = $(e.target).parent().parent();
                $qty = Number($row.find('#txtIssueQty').val());
                $rate = Number($row.find('#tdMRP').text());
                $vatPercent = Number($row.find('#tdVAT').text());
                $amount = $qty * $rate;
                $discountPrecent = Number($row.find('#txtItemDiscountPercent').val());
                if (e.target.id == 'txtItemDiscountAmount') {
                    var discountAmount = Number(e.target.value);
                    $discountPrecent = ((discountAmount * 100) / $amount);
                    $row.find('#txtItemDiscountPercent').val(precise_round($discountPrecent, 4));
                }
                $discountAmount = 0;
                if ($discountPrecent > 0)
                    $discountAmount = precise_round((($amount * $discountPrecent) / 100), 4);

                if (e.target.id != 'txtItemDiscountAmount')
                    $($row).find('#txtItemDiscountAmount').val($discountAmount);

                var netAmount = precise_round(($amount - $discountAmount), 4);
                $($row).find('#tdAmount').text(netAmount);


                var taxAmount = calculateVatTaxAmount($qty, $rate, $vatPercent, $discountPrecent);
                $($row).find('#tdTaxAmount').text(taxAmount);

                calculateTotal(function (total) {
                    callback();
                });
            }
        }

        var getComboGridOption = function (callback) {
            var setting = {
                panelWidth: 950,
                idField: 'ItemID',
                textField: 'ItemName',
                mode: 'remote',
                url: 'Pharmacy.asmx/medicineItemSearch?cmd=item',
                loadMsg: 'Searching... ',
                method: 'get',
                pagination: true,
                pageSize: 20,
                rownumbers: true,
                fit: true,
                border: false,
                cache: false,
                nowrap: true,
                emptyrecords: 'No records to display.',
                queryParams: {
                    type: $('input[type=radio][name:rdoSearchBy]:checked').val(),
                    deptLedgerNo: $('#lblDeptLedgerNo').text().trim(),
                    sort: 'ItemName',
                    order: 'asc',
                    isWithAlternate: false,
                    isBarCodeScan: false,
                },
                onHidePanel: function () { },
                columns: [[
                    { field: 'ItemName', title: 'ItemName', align: 'left', sortable: true },
                    { field: 'BatchNumber', title: 'Batch No.', align: 'center', sortable: true },
                    { field: 'AvlQty', title: 'Avl. Qty.', align: 'right', sortable: true },
                    { field: 'Expiry', title: 'Expiry', align: 'center', sortable: true },
                    { field: 'ItemCode', title: 'ATC Code', align: 'center', sortable: true },
                    { field: 'NAME', title: 'Dosage', align: 'center', sortable: true },
                    { field: 'MRP', title: 'MRP', align: 'right', sortable: true },
                    { field: 'UnitPrice', title: 'UnitPrice', align: 'right', sortable: true },
                   // { field: 'Rack', title: 'Rack', align: 'center' },
                   // { field: 'Shelf', title: 'Shelf', align: 'center' },
                    { field: 'ManufactureName', title: 'Manufacture Name', align: 'center', sortable: true },
                    { field: 'Generic', title: 'Generic', align: 'center', sortable: true }
                ]],
                fitColumns: true,
                rowStyler: function (index, row) {
                    if (row.alterNate > 0) {
                        return 'background-color:antiquewhite;';
                    }
                    if (row.AvlQty == 0) {
                        return 'background-color:lightcoral;display:none;';
                    }
                }
            }
            callback(setting);
        }



        var onSearchTypeChange = function (elem) {
            try {
                var options = $('#txtMedicineSearch').combogrid('options');
                options.queryParams.type = elem.value;
                $('.withGeneric').css({ 'display': (options.queryParams.type == '1') ? '' : 'none' });
            } catch (e) {

            }
        }

        var onIsWithAlternateChange = function () {
            var options = $('#txtMedicineSearch').combogrid('options');
            options.queryParams.isWithAlternate = $('input[type=radio][name=rdoWithAlt][value=1]').is(':checked');
        }
        var onIsManualChange = function (elem) {
            //   alert(elem.value);
            var options = $('#txtMedicineSearch').combogrid('options');
            if (Number(elem.value) == 1)
                options.queryParams.isBarCodeScan = false;
            else
                options.queryParams.isBarCodeScan = true;
        }

        






        var bindDoctor = function (department, callback) {
            // var $ddlDoctor = $('#ddlDoctor');
            var $ddlOldPatientDoctor = $('#ddlOldPatientDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                // $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                $ddlOldPatientDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlOldPatientDoctor.val());
            });
        }
        var bindRefferDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindReferDoctor', {}, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }


        var bindPanel = function (callback) {
            // serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
            //    var $ddlPanelCompany = $('#ddlPanelCompany');
            //     $ddlPanelCompany.bindDropDown({ data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultPanelID") %>' + '#' + '0' + '#' + '1' });
            callback();
            //  });
        }


        var $getHashCode = function (callback) {
            serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                $('#spnHashCode').text(response);
                callback(true);
            });
        }
        var changePatientType = function (patientType) {
            $('#tblSelectedMedicine tbody').html('');
            if (patientType == '2') {
                clearGeneralPatientDetails(function () {
                    clearHospitalPatientDetails(function () {
                        $panelControlInit(function () {
                            $('#divSearchCreteria').hide();
                            $('#divGeneralPatientEntry,#divMedicineSelect').show();
                            $('#divHospitalPatientEntry,#btnPatientMedicineSearch').hide();
                       });
                    });
                });
            }
            else {
                clearHospitalPatientDetails(function () {
                    clearGeneralPatientDetails(function () {
                        $('#divSearchCreteria').show();
                        $('#btnPatientMedicineSearch').show();
                        $('#divGeneralPatientEntry,#divHospitalPatientEntry,#divMedicineSelect').hide();
                    });
                });
            }
        }

        var searchPatientByID = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13 && e.target.type == 'text') {
                $getPatientDetails(null, function (response) {
                    $bindPatientDetails(response, function () {
                        searchDefaultIndentPrescriptions(response, function () {
                            getPatientIndents(function () { }, 0);
                        });
                    });
                });
            }
            else if (e.target.type == 'button') {
                $getPatientDetails(null, function (response) {
                    $bindPatientDetails(response, function () {
                        searchDefaultIndentPrescriptions(response, function () {
                            getPatientIndents(function () { }, 0);
                        });
                    });
                });
            }
        }


        var searchDefaultIndentPrescriptions = function (patientDetails, callback) {
            getPatientIndents(function (details) {
                var indentcount = details.patientIndentDetails.filter(function (i) { return i.VIEW == "true" });
                if (details.patientIndentDetails.length > 0 && indentcount.length > 0) {
                    var detailsCount = $('#btnPatientMedicineSearch').find('span').text(indentcount.length);
                    detailsCount.addClass('blink');
                }
                else {
                    var detailsCount = $('#btnPatientMedicineSearch').find('span').text('0');
                    detailsCount.removeClass('blink');
                }
                $('#btnPatientMedicineSearch').find('b').text(($.trim(patientDetails.Status) == 'IN') ? 'Indents' : 'Prescriptions');
                callback();
            }, 0);
        }




        var getPharmacyPatientDetails = function (callback) {
            $getPanelDetails(function (panelDetails) {
                var patientType = $.trim($('input[type=radio][name=rdoPatientType]:checked').val());
                var generalPatientDetails = {
                    address: $.trim($('#txtAddress').val()),
                    ageValue: Number($('#txtAge').val()),
                    ageIn: $('#ddlAge').val(),
                    age: $.trim($('#txtAge').val()) + ' ' + $('#ddlAge').val(),
                    contactNo: $('#txtPhoneNo').val(),
                    gender: $('input[type=radio][name=sex]:checked').val(),
                    name: $('#txtName').val(),
                    title: $('#ddlTitle').val(),
                    doctor: { value: $('#ddlDoctor').val(), text: $('#ddlDoctor option:selected').text() },
                };
                var hospitalPatientDetails = {
                    name: $('#lblPatientName').text(),
                    patientID: $('#lblMrNo').text(),
                    IPDNO: $.trim($('#lblIPDNo').text()),
                    doctor: { value: $('#ddlOldPatientDoctor').val(), text: $('#ddlOldPatientDoctor option:selected').text() },
                    panel: { value: panelDetails.panel.panelID, text: panelDetails.panel.panelName },
                    age: String.isNullOrEmpty($(this).find('#lblAgeSex').text()) ? '0' : $('#lblAgeSex').text().split('/')[0],
                    gender: String.isNullOrEmpty($(this).find('#lblAgeSex').text()) ? '' : $('#lblAgeSex').text().split('/')[1],
                    contactNo: $('#lblContact').text(),
                };
                var medicines = [];
                $('#tblSelectedMedicine tbody tr').each(function () {
                    medicines.push({
                        itemName: $(this).find('#tdItemName').text(),
                        batchNumber: $(this).find('#tdBatchNumber').text(),
                        isExpirable: $(this).find('#tdisExpirable').text(),
                        medExpiryDate: $(this).find('#tdMedExpiryDate').text(),
                        unitType: $(this).find('#tdUnitType').text(),
                        actualIssueQty: Number($(this).find('#tdActualIssueQty').text()),
                        totalAvlQty: Number($(this).find('#tdTotalAvlQty').text()),
                        issueQty: Number($(this).find('#tdIssueQty #txtIssueQty').val()),
                        MRP: Number($(this).find('#tdMRP').text()),
                        discountAmt: Number($(this).find('#txtItemDiscountAmount').val()),
                        amount: Number($(this).find('#tdAmount').text()),
                        grossAmount: Number($(this).find('#tdGrossAmount').text()),
                        isItemWiseDisc: Number($(this).find('#tdisItemWiseDisc').text()),
                        discountPer: Number($(this).find('#txtItemDiscountPercent').val()),
                        stockID: $(this).find('#tdStockID').text(),
                        itemID: $(this).find('#tdItemID').text(),
                        subCategoryID: $(this).find('#tdSubCategoryID').text(),
                        unitPrice: Number($(this).find('#tdUnitPrice').text()),
                        toBeBilled: $(this).find('#tdToBeBilled').text(),
                        isUsable: $(this).find('#tdIsUsable').text(),
                        type_ID: $(this).find('#tdType_ID').text(),
                        patientMedicine: String.isNullOrEmpty($(this).find('#tdPatientMedicine').text()) ? '0' : $(this).find('#tdPatientMedicine').text(),
                        purTaxPer: Number($(this).find('#tdPurTaxPer').text()),
                        PurTaxAmt: Number($(this).find('#tdPurTaxAmt').text()),//
                        hSNCode: $(this).find('#tdHSNCode').text(),
                        IGSTPercent: Number($(this).find('#tdIGSTPercent').text()),
                        SGSTPercent: Number($(this).find('#tdSGSTPercent').text()),
                        CGSTPercent: Number($(this).find('#tdCGSTPercent').text()),
                        GSTType: $(this).find('#tdGSTType').text(),
                        indentNo: $.trim($(this).find('#tdIndentNo').text()),
                        patientMedicine: $.trim($(this).find('#tdPatientMedicine').text()),
                        taxPercent: Number($(this).find('#tdVAT').text()),
                        taxAmt: Number($(this).find('#tdTaxAmount').text()),
                        draftDetailID: String.isNullOrEmpty($(this).find('#tdItemdraftDetailID').text()) ? '0' : $(this).find('#tdItemdraftDetailID').text(),
                        isClinical: $(this).find('#chkClinical').is(':checked') ? '1' : '0',
                        CriticalRemarks: $(this).find('#txtCriticalRemarks').val(),
                        IsPayable: $(this).find('#spnIsPayable').text(),
                        CoPayPercent: $(this).find('#spnCoPaymentPercent').text(),


                    });
                });


                var zeroQuantityItems = medicines.filter(function (s) {
                    return s.issueQty <= 0;
                });

                if (zeroQuantityItems.length > 0) {
                    modelAlert('Some Item have Invalid Quantity.');
                    return false;
                }

                callback({ patientType: patientType, generalPatientDetails: generalPatientDetails, hospitalPatientDetails: hospitalPatientDetails, medicines: medicines });
            });
        }



        var getPharmacyIssueDetails = function (callback) {
            getPharmacyPatientDetails(function (patientPharmacyDetails) {
                $getPaymentDetails(function (paymentDetails) {
                    var hashCode = $('#spnHashCode').text();
                    var generalPatient = {
                        Title: patientPharmacyDetails.generalPatientDetails.title,
                        Name: patientPharmacyDetails.generalPatientDetails.name,
                        Age: patientPharmacyDetails.generalPatientDetails.age,
                        Address: patientPharmacyDetails.generalPatientDetails.address,
                        Gender: patientPharmacyDetails.generalPatientDetails.gender,
                        ContactNo: patientPharmacyDetails.generalPatientDetails.contactNo
                    }
                    var PMH = {}
                    if (patientPharmacyDetails.patientType == '1' || patientPharmacyDetails.patientType == '3') {
                        PMH.PatientID = patientPharmacyDetails.hospitalPatientDetails.patientID,
                        PMH.Age = patientPharmacyDetails.hospitalPatientDetails.age,
                        PMH.DoctorID = patientPharmacyDetails.hospitalPatientDetails.doctor.value,
                        PMH.PanelID = patientPharmacyDetails.hospitalPatientDetails.panel.value,
                        PMH.ReferedBy = ''
                        PMH.PatientPaybleAmt = paymentDetails.patientPayableAmount;
                        PMH.PanelPaybleAmt = paymentDetails.panelPayableAmount;
                        PMH.PatientPaidAmt = paymentDetails.patientPaidAmount;
                        PMH.PanelPaidAmt = paymentDetails.panelPaidAmount;
                    }
                    else {
                        PMH.PatientID = 'CASH002',
                        PMH.DoctorID = '<%=Resources.Resource.DoctorID_Self%>',// patientPharmacyDetails.generalPatientDetails.doctor.value,
                        PMH.ReferedBy = patientPharmacyDetails.generalPatientDetails.doctor.text,
                        PMH.PanelID = '<%=Resources.Resource.DefaultPanelID%>',
                        // PMH.ReferedBy = ''
                        PMH.PatientPaybleAmt = paymentDetails.patientPayableAmount;
                        PMH.PanelPaybleAmt = paymentDetails.panelPayableAmount;
                        PMH.PatientPaidAmt = paymentDetails.patientPaidAmount;
                        PMH.PanelPaidAmt = paymentDetails.panelPaidAmount;
                    }

                    PMH.HashCode = hashCode,
                    PMH.patient_type = ''// to be verify
                    var LT = {
                        NetAmount: paymentDetails.netAmount,
                        GrossAmount: paymentDetails.billAmount,
                        DiscountReason: paymentDetails.discountReason,
                        DiscountApproveBy: paymentDetails.approvedBY,
                        DiscountOnTotal: paymentDetails.discountAmount,
                        RoundOff: paymentDetails.roundOff,
                        GovTaxPer: '0',
                        GovTaxAmount: '0',
                        Adjustment: paymentDetails.adjustment,
                        IPNo: patientPharmacyDetails.hospitalPatientDetails.IPDNO,
                        CurrentAge: (patientPharmacyDetails.patientType == '1' || patientPharmacyDetails.patientType == '3') ? patientPharmacyDetails.hospitalPatientDetails.age : patientPharmacyDetails.generalPatientDetails.age,
                        Remarks: paymentDetails.paymentRemarks
                    }
                    var LTD = [];
                    var salesDetails = [];
                    var patientMedicine = [];
                    var draftMedicine = [];
                    var clinicalTrial = [];
                    var itemWiseDiscountTotal = 0;
                    patientPharmacyDetails.medicines.filter(function (i) { itemWiseDiscountTotal = itemWiseDiscountTotal + i.discountAmt });
                    $(patientPharmacyDetails.medicines).each(function () {
                        LTD.push({
                            ItemID: this.itemID,
                            StockID: this.stockID,
                            SubCategoryID: this.subCategoryID,
                            Rate: this.MRP,
                            Quantity: this.issueQty,
                            ItemName: this.itemName + '(Batch :' + this.batchNumber + ')',
                            medExpiryDate: this.medExpiryDate,
                            ToBeBilled: this.toBeBilled,
                            IsReusable: this.isUsable,
                            DiscountReason: paymentDetails.discountReason,
                            DiscountPercentage: itemWiseDiscountTotal > 0 ? this.discountPer : paymentDetails.discountPercent,
                            DiscAmt: itemWiseDiscountTotal > 0 ? this.discountAmt : (this.amount * paymentDetails.discountPercent / 100),
                            Amount: itemWiseDiscountTotal > 0 ? this.amount : (this.amount - (this.amount * paymentDetails.discountPercent / 100)),
                            BatchNumber: this.batchNumber,
                            PurTaxPer: this.purTaxPer,
                            PurTaxAmt:this.PurTaxAmt,
                            unitPrice: this.unitPrice,
                            Type_ID: this.type_ID,
                            HSNCode: this.hSNCode,
                            IGSTPercent: this.IGSTPercent,
                            SGSTPercent: this.SGSTPercent,
                            CGSTPercent: this.CGSTPercent,
                            IsPayable: this.IsPayable,
                            CoPayPercent: this.CoPayPercent,
                        });
                        salesDetails.push({
                            ItemID: this.itemID,
                            StockID: this.stockID,
                            Type_ID: this.type_ID,
                            SoldUnits: this.issueQty,
                            PerUnitBuyPrice: this.unitPrice,
                            PerUnitSellingPrice: this.MRP,
                            ToBeBilled: this.toBeBilled,
                            IsReusable: this.isUsable,
                            GSTType: this.GSTType,
                            IndentNo: this.indentNo,
                            TaxPercent: this.taxPercent,
                            TaxAmt: this.taxAmt,
                            draftDetailID: Number(this.draftDetailID)

                        });
                        patientMedicine.push({
                            PatientMedicine_ID: this.patientMedicine
                        });

                        draftMedicine.push({
                            draftDetailID: Number(this.draftDetailID),
                            ReceiveQty: Number(this.issueQty)
                        });

                        if (this.isClinical == "1") {
                            clinicalTrial.push({
                                ItemID: this.itemID,
                                Remarks: this.CriticalRemarks
                            });
                        }
                    });
                    var paymentDetail = [];
                    $(paymentDetails.paymentDetails).each(function () {
                        paymentDetail.push({
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



                    var zeroMRPItems = salesDetails.filter(function (i) { return i.PerUnitSellingPrice <= 0 });



                    if (zeroMRPItems.length > 0) {
                        modelAlert("Some Item's have 0 MRP !!", function () {
                            $("#promptConfirmOkButtonText").removeAttr('disabled').val('Submit');
                            $("#btnSave").removeAttr('disabled').val('Save');
                            onCancelValidateUserModel();
                        });
                        return false;
                    }


                    if (paymentDetail.length < 1) {
                        modelAlert('Please Select Payment Details', function () {
                            $("#promptConfirmOkButtonText").removeAttr('disabled').val('Submit');
                            $("#btnSave").removeAttr('disabled').val('Save');
                            onCancelValidateUserModel();
                        });

                        return false;
                    }

                    if (patientPharmacyDetails.patientType == '2') {

                        if (String.isNullOrEmpty(patientPharmacyDetails.generalPatientDetails.name)) {
                            modelAlert('Please Enter Name.', function () {
                                $("#promptConfirmOkButtonText").removeAttr('disabled').val('Submit');
                                $("#btnSave").removeAttr('disabled').val('Save');
                                onCancelValidateUserModel();
                            });
                            return false;
                        }

                       // if ((patientPharmacyDetails.generalPatientDetails.ageValue) <= 0) {
                            //modelAlert('Please Enter Age.', function () {
                            //    $("#promptConfirmOkButtonText").removeAttr('disabled').val('Submit');
                            //    $("#btnSave").removeAttr('disabled').val('Save');
                            //    onCancelValidateUserModel();
                          //  });
                           // return false;
                       // }

                       // if (String.isNullOrEmpty(patientPharmacyDetails.generalPatientDetails.address)) {
                        //    modelAlert('Please Enter Address.', function () {
                        //        $("#promptConfirmOkButtonText").removeAttr('disabled').val('Submit');
                        //        $("#btnSave").removeAttr('disabled').val('Save');
                        //        onCancelValidateUserModel();
                        //    });
                        //    return false;
                        //}
                        if (PMH.ReferedBy == "Select") {
                            modelAlert('Please Select Doctor.', function () {
                                $("#promptConfirmOkButtonText").removeAttr('disabled').val('Submit');
                                $("#btnSave").removeAttr('disabled').val('Save');
                                onCancelValidateUserModel();
                            });
                            return false;
                        }

                    }
                    else {
                        if (PMH.DoctorID == "0") {
                            modelAlert('Please Select Doctor.', function () {
                                $("#promptConfirmOkButtonText").removeAttr('disabled').val('Submit');
                                $("#btnSave").removeAttr('disabled').val('Save');
                                onCancelValidateUserModel();
                            });
                            return false;
                        }
                    }
                    callback({
                        PMH: [PMH],
                        LT: [LT],
                        LTD: LTD,
                        SalesDetails: salesDetails,
                        generalPatient: [generalPatient],
                        PaymentDetail: paymentDetail,
                        patientType: patientPharmacyDetails.patientType,
                        PatientMedicineData: patientMedicine,
                        DeptLedgerNo: $('#lblDeptLedgerNo').text().trim(),
                        contactNo: (patientPharmacyDetails.patientType == '1' || patientPharmacyDetails.patientType == '3') ? patientPharmacyDetails.hospitalPatientDetails.contactNo : patientPharmacyDetails.generalPatientDetails.contactNo,
                        PName: (patientPharmacyDetails.patientType == '1' || patientPharmacyDetails.patientType == '3') ? patientPharmacyDetails.hospitalPatientDetails.name : patientPharmacyDetails.generalPatientDetails.title + ' ' + patientPharmacyDetails.generalPatientDetails.name,
                        isOtPatient: 0,
                        isIPDInCash: false,
                        draftMedicineData: draftMedicine,
                        ClinicalTrial: clinicalTrial
                    });
                });
            });
        }



        var savePharmacyIssue = function (verifiedUserID, btnSave, btnAction) {
            getPharmacyIssueDetails(function (data) {
                data.IsDischargeMedicine = 0;
                data.VerifiedUserID = verifiedUserID;
                isEmergencyPatient = 0;
                if (!String.isNullOrEmpty($('#lblEMGNo').text()))
                    isEmergencyPatient = 1;

                var isInCredit = data.PaymentDetail.filter(function (i) { return i.PaymentModeID == 4 });

                if (!String.isNullOrEmpty(data.LT[0].IPNo) && isEmergencyPatient == 0 && isInCredit.length > 0) {
                    //modelConfirmation('IPD  Billing Confirmation ?', 'Are You Sure To Add This Bill In Patient IPD  Billing', 'Yes Proceed With IPD Billing', 'Cancel', function (status) {
                    //    if (status) {
                    //        data.isIPDInCash = false;
                    //        modelConfirmation('IPD  Billing Confirmation ?', 'Are You Sure Want To Discharge Medicine ?', 'YES', 'NO', function (status) {
                    //            if (status) {
                    //                data.IsDischargeMedicine = 1;
                    //                save(data, btnSave, btnAction);
                    //            }
                    //            else {
                    //                data.IsDischargeMedicine = 0;
                    //                save(data, btnSave, btnAction);
                    //            }
                    //        });
                    //    }
                    //    else {
                    //        $(btnAction).removeAttr('disabled').val('Submit');
                    //        $(btnSave).removeAttr('disabled').val('Save');
                    //    }
                    //});
                            data.isIPDInCash = false;
                            if ($('#chkImplant').is(':checked'))
                                    data.IsDischargeMedicine = 1;
                                    save(data, btnSave, btnAction);
                                }
                                else {
                    var isInCash = data.PaymentDetail.filter(function (i) { return i.PaymentModeID != 4 });
                    if(isInCash.length>0)
                        data.isIPDInCash = true;

                //    if (!data.isIPDInCash && $('#lblDischargeStatus').text().trim() == 'OUT' && $('#lblPatientType').text()=='IPD') {
                //        modelAlert('Patient has been Discharged..!!! Can not Prescribe in Credit..', function () {
                //            $(btnAction).removeAttr('disabled').val('Submit');
                //            $(btnSave).removeAttr('disabled').val('Save');
                //    });
                //        return false;
                //}
                //    else



                    save(data, btnSave, btnAction);
                }
            });
        }


        var printLabels = function (ledTxnID) {
            $("#IsPharmacyIssue").text("1");
            $('#divUserInteractionPrompt').hideModel();
            BindOPDPopUp(ledTxnID);
            showLabelPrintPopup(function () { });
        }

        var windowsreload = function () {
            window.location.reload();
        }
        var save = function (data, btnSave, btnAction) {
            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('Services/WebService.asmx/SaveOPDPharmacy', data, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status) {
                       // printLabels($responseData.ledTxnID);

                      //  if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                        //        window.open('../common/GSTPharmacyReceipt.aspx?LedTnxNo=' + $responseData.ledTxnID + '&OutID=' + $responseData.customerID + '&DeptLedgerNo=' + $responseData.DeptLedgerNo + '&IsBill=' + $responseData.IsBill + '&Duplicate=0&ReceiptNo=' + $responseData.ReceiptNo + '');
                          //  else
                            //    window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + $responseData.ledTxnID + '&IsBill=' + $responseData.IsBill + '&Duplicate=0&Type=PHY');
                       // $(btnAction).removeAttr('disabled').val('Submit');
                            window.location.reload();
                        }
                        else{
                            
                            $(btnAction).removeAttr('disabled').val('Submit');
                            $(btnSave).removeAttr('disabled').val('Save');
                        }
                });
            });
        }






            var saveBill = function (btnSave) {

                var _divUserInteractionPrompt = $('#divUserInteractionPrompt');
                _divUserInteractionPrompt.find('input[type=text],input[type=password]').val('');
                _divUserInteractionPrompt.find('input[type=text]').focus();
                _divUserInteractionPrompt.showModel();
                //_divUserInteractionPrompt.find('input[type=text]').focus();

                _divUserInteractionPrompt.find('#txtPromtText').val('').focus();

                //  $(btnSave).removeAttr('disabled').val('Submit');
                //  var prompt = userInteractionPrompt('Validate User !!!', '', '', 'Submit', 'Cancel', function (res) {

                // $(btnSave).attr('disabled', true).val('Submitting...');
                //    if (String.isNullOrEmpty(res.promptText)) {
                //        modelAlert('Please Enter User Name', function () {
                //            prompt.input.focus();
                //            $(btnSave).removeAttr('disabled').val('Submit');
                //        });
                //        return false;
                //    }
                //    if (String.isNullOrEmpty(res.promptValue)) {
                //        modelAlert('Please Enter Password', function () {
                //            prompt.input.focus();
                //            $(btnSave).removeAttr('disabled').val('Submit');
                //        });
                //        return false;
                //    }

                //    if (res.status) {
                //        validateUser({ userName: res.promptText, password: res.promptValue }, function (validateStatus) {
                //            if (validateStatus.status) {
                //                prompt.close();
                //                data.VerifiedUserID = validateStatus.UserID;
                //                save(data, btnSave);
                //            }
                //            else {
                //                modelAlert(validateStatus.message);
                //                $(btnSave).removeAttr('disabled').val('Submit');
                //            }
                //        });
                //    }
                //});
            }


            var onSavePharmacyBill = function (btnAction,btnSave) {

                //$(btnAction).attr('disabled', true).val('Submitting...');

                //var _divUserInteractionPrompt = $('#divUserInteractionPrompt');

                //var userName = _divUserInteractionPrompt.find('#txtPromtText').val();
                //var password = _divUserInteractionPrompt.find('#txtPromtvalue').val();

                //if (String.isNullOrEmpty(userName)) {
                //    modelAlert('Please Enter User Name.', function () {
                //        _divUserInteractionPrompt.find('#txtPromtText').focus();
                //        $(btnAction).removeAttr('disabled').val('Submit');
                //        $(btnSave).removeAttr('disabled').val('Save');
                //    });

                //    return false;
                //}


                //if (String.isNullOrEmpty(password)) {
                //    modelAlert('Please Enter Password.', function () {
                //        _divUserInteractionPrompt.find('#txtPromtvalue').focus();
                //        $(btnAction).removeAttr('disabled').val('Submit');
                //        $(btnSave).removeAttr('disabled').val('Save');
                //    });

                //    return false;
                //}



                //validateUser({ userName: userName, password: password }, function (validateStatus) {
                //    if (validateStatus.status) {
                //        savePharmacyIssue(validateStatus.UserID,btnSave,btnAction);

                //        //prompt.close();
                //        //data.VerifiedUserID = validateStatus.UserID;
                //        //save(data, btnSave);
                //    }
                //    else {
                //        modelAlert(validateStatus.message);
                //        $(btnAction).removeAttr('disabled').val('Submit');
                //        $(btnSave).removeAttr('disabled').val('Save');
                //    }
                //});
               var UserID = '<%=Session["ID"] %>';
                savePharmacyIssue(UserID, btnSave, btnAction);
            }


            var validateUser = function (data, callback) {
                serverCall('OPDPharmacyIssue.aspx/ValidateUser', data, function (res) {
                    var responseData = JSON.parse(res);
                    callback(responseData);
                });
            }


         
           var onCancelValidateUserModel=function(){
                 
                var _divUserInteractionPrompt = $('#divUserInteractionPrompt');
                _divUserInteractionPrompt.hideModel();
           }







    </script>
    <style type="text/css">
        .combo-panel {
            overflow: hidden;
        }
    </style>


    <div id="Pbody_box_inventory">
          <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <span style="display:none" id="spnHashCode"></span>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Label  ID="lblDeptLedgerNo" runat="server" style="display:none" ClientIDMode="Static" ></asp:Label>
            <b>Pharmacy Issue</b><br />
            <input type="radio" id="rdoHospitalPatient" value="1" name="rdoPatientType" style="display:none" onclick="changePatientType(this.value)" checked="checked" />
            <%--Registred Patient--%>
            <label id="lblRdoWalkIn" runat="server">
            <input type="radio" id="rdoGeneral" value="2" name="rdoPatientType"  style="display:none" onclick="changePatientType(this.value)"    />
            <span  id="spnWalkin" style="display:none">Walk-in</span>
                </label>
           <%-- <input type="radio" id="rdoIPD" value="3" name="rdoPatientType" onclick="changePatientType(this.value)" />
            IPD--%>

            <input id="lblIsPharmacyItemAdded" type="text" value="0"  style="display:none" readonly="readonly"/>
              
        </div>
        <div id="divSearchCreteria" class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left"><b>BCD/UHID</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <input id="txtPatientId" type="text" class="requiredField" maxlength="20" title="Enter UHID" onkeyup="searchPatientByID(event)" autocomplete="off" />
                            <input id="txtBarCodeSearch" type="text" style="display:none"  maxlength="10" title="Enter BarCode No." autocomplete="off" />
                        </div>
                        <div class="col-md-2">
                            <label id="lblPatientIdType" class="pull-left">IPD No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input id="txtIPDNO" type="text" class="requiredField" maxlength="20" title="Enter IPD No." onkeyup="searchPatientByID(event)" autocomplete="off" />
                        </div>
                          <div class="col-md-2">
                            <label id="Label1" class="pull-left">EMG No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <input id="txtEMGNo" type="text" class="requiredField" maxlength="20" title="Enter EMGNo" onkeyup="searchPatientByID(event)" autocomplete="off" />
                        </div>
                        <div class="col-md-1">
                            <input type="button" id="btnSearch" onclick="searchPatientByID(event)" class="pull-left" value="Search" />
                        </div>
                        <div class="col-md-3">
                            <input id="btnOldPatient" type="button" onclick="$showOldPatientSearchModel()" value="Old Patient Search" />
                        </div>
                         <div class="col-md-3"  style="display:none;" >
                            <input class="label label-important" type="button" onclick="getDrafts(this)" value="Pending Demand Draft`s" />
                        </div>
                        <div class="col-md-3">
                            <input class="label label-important"  type="button" onclick="getPendingIndentDetails(this)" value="Pending Indent`s" />
                        </div>
                         <div class="col-md-3">
                            <input class="label label-important"  type="button" onclick="MedicineSearchPatient(this)" value="OPD Patient" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"></div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divGeneralPatientEntry" style="display: none" class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <select id="ddlTitle" style="width: 47px; padding: 0px"  title="Select Title">
                                <option value="Mr" >Mr</option>
                                <option value="Mrs">Mrs</option>
				<option value="Ms">Ms</option>
                            </select>
                        </div>
                        <div class="col-md-4 ">
                            <input type="text" id="txtName" style="text-transform:uppercase" class="requiredField" autocomplete="off" maxlength="50" title="Enter First Name" tabindex="1" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Age</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtAge" class="" autocomplete="off" maxlength="4" title="Enter Age" />
                        </div>
                        <div class="col-md-3">
                            <select id="ddlAge" onchange="validateAge();">
                                <option value="YRS">YRS</option>
                                <option value="MONTH(S)">MONTH(S)</option>
                                <option value="DAYS(S)">DAYS(S)</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Gender</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input id="rdoMale" type="radio" name="sex" checked="checked" value="Male" class="pull-left" />
                            <span class="pull-left">Male</span>
                            <input id="rdoFemale" type="radio" name="sex" value="Female" class="pull-left" />
                            <span class="pull-left">Female</span>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtAddress" class="" autocomplete="off"  title="Enter Address" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Contact No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPhoneNo"    onkeyup="previewCountDigit(event,function(e){});"  onlynumber="10" data-title="Enter Mobile Address" autocomplete="off" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Doctor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select  class="requiredField" style="width:100%"  id="ddlDoctor" tabindex="2"></select>
                        </div>
                        <div class="col-md-1">
                             <input type="button"  value="New" id="btnRefferBy"  title="Click To Add New Refer Doctor"  onclick="$addNewDoctorReferModel()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div id="divHospitalPatientEntry" style="display:none"  class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblPatientName" class="patientInfo"></label>
                        </div>
                        <div class="col-md-3">
                            <label id="lblPatientId" class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblMrNo" class="patientInfo"></label>
                            <label id="lblIPDNo"  class="patientInfo" style="display:none" ></label>
                             <label id="lblEMGNo"  class="patientInfo" style="display:none" ></label>
                            <label id="lblDischargeStatus"  class="patientInfo" style="display:none" ></label>
                            <label id="lblPatientType"  class="patientInfo" style="display:none" ></label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Age / Sex</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblAgeSex" class="patientInfo"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13 pull-left">
                            <label id="lblAddresss" class="patientInfo"></label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Contact No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5 pull-left">
                            <label id="lblContact" class="patientInfo"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Doctor </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select class="requiredField" id="ddlOldPatientDoctor"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left"> </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5 pull-left">
                               <button id="btnAllergiesAndDiagnosis" type="button" onclick="$popupAllergiesAndDiagnosis()" style="height: 21px; width: 175px; background-color:yellow; display: none;"><strong class="panel-title" style="font-weight: bold; font-family: Verdana, Arial, sans-serif;" title="Allergies & Diagnosis">Allergies & Diagnosis</strong></button>
                        </div>
                    </div>
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Height </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <b> <label id="lblHeight"></label></b>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Weight </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5 pull-left">
                              <b> <label id="lblWeight"></label></b>
                        </div>
                    </div>

                    <UC3:PanelControl runat="server" ID="divPanelControl" /> 
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div id="divMedicineSelect" style="display: none" class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Search By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6 pull-left">
                            <input type="radio" id="rdoTypeItem" class="radioBtnClass pull-left" name="rdoSearchBy" onclick="onSearchTypeChange(this)" checked="checked" value="1" /><span class="pull-left">Item</span>
                            <input type="radio" id="rdoTypeGeneric" class="radioBtnClass pull-left" name="rdoSearchBy" onclick="onSearchTypeChange(this)" value="2" /><span class="pull-left"> Generic</span>
                            <input type="radio" id="rdoTypeGroup" style="display: none" class="radioBtnClass pull-left" onclick="onSearchTypeChange(this)" name="rdoSearchBy" value="3" /><%--Group--%>
                         <input type="radio" id="rdoTypeATCCode" class="radioBtnClass pull-left" onclick="onSearchTypeChange(this)" name="rdoSearchBy" value="3" /><span class="pull-left">ATC Code</span>
                         <input type="radio" id="rdoTypeDose" class="radioBtnClass pull-left" onclick="onSearchTypeChange(this)" name="rdoSearchBy" value="4" /><span class="pull-left">Dosage</span>
                        </div>
                        <div class="col-md-1" >
                            <label class="pull-left"  style="display: none"  >Type</label>
                            <b class="pull-right withGeneric"  style="display: none" >:</b>
                        </div>
                         <div class="col-md-4 pull-left"   style="display: none" >
                             <input type="radio"  style="display: none"  class="pull-left" value="1" id="rdoManualSearch" checked="checked"  name="rdoIsManualSearch" onclick="onIsManualChange(this)" /><span   style="display: none"  class="pull-left">Manual</span> 
                             <input type="radio" style="display: none"  class="pull-left" value="0"  id="rdoBarcodeSearch" name="rdoIsManualSearch" onclick="onIsManualChange(this)" /> <span   style="display: none"  class="pull-left">Barcode</span> 
                         </div>
                        <div class="col-md-3">
                            <label class="pull-left"   style="display: none" >Disch. Medicine : </label>
                             <input   style="display: none"  type="checkbox" id="chkDischargeMedicine" />
                        </div>
                        <div class="col-md-2"  style="display: none" >
                            <label  style="display: none"  class="pull-right withGeneric">W. Generic :</label>
                        </div>
                         <div class="col-md-2 pull-left"  style="display: none" >
                             <input type="radio"  style="display: none" class="withGeneric pull-left" value="1" onclick="onIsWithAlternateChange()" name="rdoWithAlt" /><span class="pull-left withGeneric"  style="display: none" >Yes</span> 
                             <input type="radio"  style="display: none"  class="withGeneric pull-left" value="0" onclick="onIsWithAlternateChange()" checked="checked"   name="rdoWithAlt" /> <span class="pull-left withGeneric"  style="display: none" >No</span> 
                         </div>
                        <div class="col-md-2">
                            <button id="btnPatientMedicineSearch" onclick="showPrescribedMedicineModel(0)"  type="button" style="box-shadow:none;"><span id="spnCounts" class="badge badge-important ">0</span><b style="margin-left: 4px;font-size: 12px"></b> </button>
                        </div>
                           <div class="col-md-2">
                            <button id="btnShortQty" onclick="ShowShortQtyModel(this);"  type="button">Short Qty</button>
                        </div>
                         <div class="col-md-2">
                          <button style="width: 100%; padding: 0px;" class="label label-important" type="button">
                              <span id="lblTotalSelectedItemsCount" style="font-size: 14px; font-weight: bold;">Items : 0</span>
                          </button>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">By Any Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8 pull-left">
                            <input type="text" id="txtMedicineSearch" tabindex="6" class="easyui-combogrid" />
                        </div>
                         <div class="col-md-3"   style="display: none" >
                            <label class="pull-left">Add To Implant : </label>
                           
                             <input type="checkbox" id="chkImplant" />

                        </div>
                        
                         <div class="col-md-2"   style="display: none" >
                            <label class="pull-left">Sell On</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3 pull-left"   style="display: none" >
                             <input type="radio" class="rdoprice pull-left" value="0"  checked="checked"   name="rdoprice" /> <span class="pull-left">MRP</span> 
                             <input type="radio" class="rdoprice pull-left" value="1" name="rdoprice" /><span class="pull-left">Rate</span> 
                   
                         </div>
                        <div class="col-md-2">
                            <label class="pull-left">Quantity</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtQuantity" autocomplete="off" onlynumber="10" " max-value="1000" decimalplace="4"  onkeyup="addItem(event)" tabindex="7" />
                        </div>
                        <div class="col-md-1">
                            <input type="button" value="Add" onclick="addItem(event)" class="pull-left" />
                        </div>

                       
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div style="display: none" id="divSelectedMedicine" class="POuter_Box_Inventory">
            <table id="tblSelectedMedicine" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr id="IssueItemHeader">
                        <th class="GridViewHeaderStyle" scope="col">S.No.</th>
                        <th class="GridViewHeaderStyle" scope="col">Item Name</th>
                        <th class="GridViewHeaderStyle" scope="col">Batch No.</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none" >IsExpirable</th>
                        <th class="GridViewHeaderStyle" scope="col">Expiry</th>
                        <th class="GridViewHeaderStyle" scope="col">Unit</th>
                        <th class="GridViewHeaderStyle" scope="col">Stock Qty.</th>
                        <th class="GridViewHeaderStyle" scope="col">Unit Cost</th>
                        <%if (Resources.Resource.IsGSTApplicable == "0")
                          { %>
                        <th class="GridViewHeaderStyle" scope="col">VAT</th>
                        <th class="GridViewHeaderStyle" scope="col">Tax Amt.</th>
                        <% }
                          else
                          {%>
                        <th class="GridViewHeaderStyle" scope="col">IGST</th>
                        <th class="GridViewHeaderStyle" scope="col">SGST/UTGST</th>
                        <th class="GridViewHeaderStyle" scope="col">CGST</th>
                        <%} %>
                        
                        <th class="GridViewHeaderStyle" scope="col">Qty.</th>
                        <th class="GridViewHeaderStyle" style="width:70px" scope="col">Dis.(%)</th>
                        <th class="GridViewHeaderStyle" style="width:70px" scope="col">Dis. Amt.</th>
                        <th class="GridViewHeaderStyle" scope="col">Total Cost</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">GrossAmt</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">isItemWiseDisc</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">DisPer</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">StockID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">ItemID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">SubCategoryID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">ToBeBilled</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">Type_ID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">IsUsable</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">ServiceItemID</th>
                        <th class="GridViewHeaderStyle" scope="col" style="display: none">PatientMedicine_ID</th>
                        <th class="GridViewHeaderStyle" scope="col">Remarks</th>
                        <th class="GridViewHeaderStyle" scope="col">Remove</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>

        </div>
        <div style="width: 100%; display: none" id="paymentControlDiv">
            <UC2:PaymentControl ID="paymentControl" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" id="divAction" style="text-align: center; display: none">
              <input type="button" id="btnSave" style="margin-top:7px" class="ItDoseButton save btnAction" onclick="onSavePharmacyBill($('.btnAction'), $('#btnSave'))" value="Save" tabindex="35" />
          <%--  <input type="button" id="btnSave" style="margin-top:7px" class="ItDoseButton save btnAction" onclick="saveBill(this);" value="Save" tabindex="35" />--%>
        </div>

         <uc4:wuc_PrintPharmacyLabel ID="PrintLabel" runat="server" />
    </div>
    <script type="text/javascript">



        var addPrescribedItem = function () {
            var deptLedgerNo = $('#lblDeptLedgerNo').text().trim();
            var totalPatientPrescribedTxt = $('#divPrescribedSearchDetails table tr td #txtMedIssueQty');
            var alreadySelect = {};
            alreadySelect.status = false;
            for (var i = 0; i < totalPatientPrescribedTxt.length; i++) {
                var row = $(totalPatientPrescribedTxt[i]).closest('tr');
                var stockID = row.find('#tdPhStockID').text().trim();
                alreadySelect.status = $('#tr_' + stockID).length > 0 ? true : false;
                alreadySelect.itemName = row.find('#tdPhItemName').text().trim();
                if (alreadySelect.status)
                    break;
            }

            if (alreadySelect.status) {
                modelAlert('<b style="color:black">' + alreadySelect.itemName + '</b> <br/> Already Added', function () { });
                return;
            }

            totalPatientPrescribedTxt.each(function () {
                if (!String.isNullOrEmpty(this.value)) {
                    if (parseFloat(this.value) > 0) {
                        var row = $(this).closest('tr');
                        var itemID = row.find('#tdPhItemID').text().trim();
                        var quantity = this.value;
                        var stockID = row.find('#tdPhStockID').text().trim();
                        var avilableQuantity = row.find('#tdMedAvlQty').text().trim();

                        bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, function () {

                        });
                    }
                }
            });
            $('#divModelPrescribedMedicine').hideModel();
        }




        var addItem = function (e) {
            var txtMedicineSearch = $('#txtMedicineSearch');
            var txtQuantity = $('#txtQuantity');
            var quantity = isNaN(parseFloat(txtQuantity.val())) ? 0 : parseFloat(txtQuantity.val());
            var grid = txtMedicineSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            var code = (e.keyCode ? e.keyCode : e.which);
            if (String.isNullOrEmpty(selectedRow)) {
                modelAlert('Please Select Item First', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
                return;
            }

            var stockID = $.trim(selectedRow.stockid);




            var alreadySelectBool = $('#tr_' + stockID).length > 0 ? true : false;
            if (alreadySelectBool) {
                modelAlert('Item Already Added', function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
                return;
            }
            if (quantity == 0)
                return;
            var itemID = selectedRow.ItemID.split('#')[0];
            var avilableQuantity = selectedRow.AvlQty;
            var deptLedgerNo = $('#lblDeptLedgerNo').text().trim();
            if (quantity > parseFloat(selectedRow.AvlQty)) {
                getItemDetailsByItemID(itemID, quantity, deptLedgerNo, function (responseData) {
                    if (responseData.length > 0) {
                        if (Number(responseData[0].TotalQty) < Number(quantity)) {
                            modelAlert('Stock Not Avilable', function () {
                                $('#txtQuantity').val('').focus();
                            });
                            return;
                        } else {
                            $.each(responseData, function (i) {
                                if (Number(quantity) != 0) {
                                    responseData[i].patientMedicine = '0';
                                    responseData[i].indentNo = '';
                                    responseData[i].draftDetailID = '0';
                                    var itemID = responseData[i].ItemID;
                                    var stockID = responseData[i].stockid;
                                    var avilableQuantity = responseData[i].AvlQty;
                                    if (avilableQuantity >= quantity) {
                                        bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, function () { });
                                        quantity = 0;
                                    }
                                    else {
                                        bindItem(itemID, avilableQuantity, stockID, avilableQuantity, deptLedgerNo, function () { });
                                        quantity = Number(quantity) - Number(avilableQuantity);
                                    }
                                }
                            });
                        }
                        txtQuantity.val('');
                        $('.textbox-text.validatebox-text').focus();
                        txtMedicineSearch.combogrid('reset');
                    }
                });
                //modelAlert('Stock Not Avilable', function () {
                //    txtQuantity.val('').focus();
                //});
                //return;
            }
            if (code == 13 && e.target.type == 'text') {
                quantity = e.target.value;
                bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
            }
            else if (e.target.type == 'button') {
                bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
            }

            if (code == 9 && e.target.type == 'text') {
                $(this).parent().find('input[type=button]').focus();
            }
        }

        var getItemDetailsByItemID = function (itemID, Qty, deptLedgerNo, callback) {
            serverCall('Services/WebService.asmx/addItemByItemID', { ItemID: itemID, Qty: Qty, DeptLedgerNo: deptLedgerNo }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0)
                        callback(responseData);
                    else {
                        modelAlert('Stock Not Avilable', function () {
                            $('#txtQuantity').val('').focus();
                        });
                        return;
                    }
                }
                else {
                    modelAlert('Stock Not Avilable', function () {
                        $('#txtQuantity').val('').focus();
                    });
                    return;
                }
            });

        }
        var bindItem = function (itemID, quantity, stockID, avilableQuantity, deptLedgerNo, callback) {

            if ($("#lblIsPharmacyItemAdded").val() == 0) {
                PharmacyCharges(deptLedgerNo, function (callback) {

                });
            }

            getItemDetails(itemID, quantity, stockID, avilableQuantity, 0, deptLedgerNo, function (response) {
                response[0].patientMedicine = '0';
                response[0].indentNo = '';
                response[0].draftDetailID = '0';
                addNewRow(response[0], quantity, 0, 0, 0, function () {
                    calculateTotal(function (total) {
                        callback();
                    });
                });
            });
        }

        //Ajeet
        var getItemDetails = function (itemID, tranferQty, stockID, availableQty, isSet, deptLedgerNo, callback) {           
            serverCall('Services/WebService.asmx/addItem', { ItemID: itemID, tranferQty: tranferQty, StockID: stockID, patientMedicine: "0", DeptLedgerNo: deptLedgerNo }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0)
                        callback(responseData);
                    else {

                    }
                }
                else {

                }
            });
        }


        var calculateVatTaxAmount = function (quantity, mrp, vatPercent, discountPercent) {
            var discount = mrp * discountPercent / 100;
            var taxableAmt = ((mrp - discount) * 100 * quantity) / (100 + vatPercent);
            return precise_round(((taxableAmt * vatPercent) / 100) * quantity, 4);
        }



        $getDiscountWithCoPay = function (data, callback) {
            serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', data, function (response) {
                callback(JSON.parse(response)[0]);
            });
        }
         
        var addNewRow = function (itemDetails, quantity, discountAmount, discountPercent, isindent, callback) {

            var PatientType = $('input[type=radio][name=rdoPatientType]:checked').val();

            if (PatientType == "" || PatientType == null || PatientType == undefined) {
                PatientType = 0;
            }


            $getPanelDetails(function (panelDetails) {
                $getDiscountWithCoPay({ itemID: itemDetails.ItemID, panelID: panelDetails.panel.panelID, patientTypeID: PatientType, memberShipCardNo: "" }, function (disCoPayment) {
                     
                    // var issuedisabled = isindent == 1 ? 'disabled=disabled' : '';
                    var issuedisabled = isindent == 1 ? '' : '';

            var SellPrice = itemDetails.MRP;
            if (Number($('input[type=radio][name=rdoprice]:checked').val()) == 1)
                SellPrice = itemDetails.UnitPrice;

            var grossAmount = precise_round(parseFloat((parseFloat(quantity) * parseFloat(SellPrice))), 4);
                    
            var table = $('#tblSelectedMedicine tbody');
            var newRow = $('<tr />').attr('id', 'tr_' + itemDetails.stockid);
           
            var SubcategoryID = itemDetails.SubCategoryID;
            if ($('#chkImplant').is(':checked'))
                SubcategoryID = '214';
                    var discountPercent = disCoPayment.OPDPanelDiscPercent;
                    var IsPanelWiseDiscount = disCoPayment.OPDPanelDiscPercent > 0 ? 1 : 0;
                    var coPaymentPercent = disCoPayment.OPDCoPayPercent;
                    var IsPayable = disCoPayment.IsPayble;
                    var discountPercentAmt = (disCoPayment.OPDPanelDiscPercent > 0 ? (((grossAmount) * disCoPayment.OPDPanelDiscPercent) / 100) : 0)

                    var netAmmount = precise_round((grossAmount - discountPercentAmt), 4);

            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                newRow.html(
                              '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center">' + (table.find('tr').length + 1) +
                              '</td><td class="GridViewLabItemStyle" id="tdItemName">' + itemDetails.ItemName +
                              '</td><td class="GridViewLabItemStyle" id="tdBatchNumber" style="text-align:center">' + itemDetails.BatchNumber +
                              '</td><td class="GridViewLabItemStyle" id="tdisExpirable" style="display:none;">' + itemDetails.isexpirable +
                              '</td><td class="GridViewLabItemStyle" id="tdMedExpiryDate">' + itemDetails.MedExpiryDate +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdUnitType">' + itemDetails.UnitType +
                              '</td><td class="GridViewLabItemStyle" style="display:none" id="tdActualIssueQty">' + quantity +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdTotalAvlQty">' + itemDetails.AvlQty +

                              '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdMRP">' + SellPrice +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdVAT">' + itemDetails.VAT +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdTaxAmount">' + calculateVatTaxAmount(quantity, itemDetails.MRP, itemDetails.VAT, discountPercent) +

                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdGrossAmount">' + grossAmount +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdisItemWiseDisc">' + itemDetails.isItemWiseDisc +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdDiscountPer">' + discountPercent +//$.trim($("#txtDiscItem").val())
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdStockID">' + itemDetails.stockid +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdItemID">' + itemDetails.ItemID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdSubCategoryID">' + SubcategoryID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdUnitPrice">' + itemDetails.UnitPrice +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdToBeBilled">' + itemDetails.ToBeBilled +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdIsUsable">' + itemDetails.IsUsable +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdType_ID">' + itemDetails.Type_ID +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdPatientMedicine">' + itemDetails.patientMedicine +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdItemdraftDetailID">' + itemDetails.draftDetailID +


                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdIndentNo">' + itemDetails.indentNo +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdPurTaxPer">' + itemDetails.PurTaxPer +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdPurTaxAmt">' + calculateVatTaxAmount(quantity, itemDetails.MRP, itemDetails.VAT, discountPercent) +
                              // Add new on 29-06-2017 - For GST
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdHSNCode">' + itemDetails.HSNCode +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdIGSTPercent">' + itemDetails.IGSTPercent +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdSGSTPercent">' + itemDetails.SGSTPercent +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdCGSTPercent">' + itemDetails.CGSTPercent +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdGSTType">' + itemDetails.GSTType +
                                      // Add new on 09-03-2022 by Ajeet 
                                           '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnIsPayable">' + IsPayable +
                                          '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnCoPaymentPercent">' + coPaymentPercent +
                                          '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnIsPanelWiseDiscount">' + IsPanelWiseDiscount +
                                          '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnDiscountAmount">' + discountPercentAmt +
                                    // End on 09-03-2022 by Ajeet 
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;width:50px" id="tdIssueQty"><input type="text" max-value="' + itemDetails.AvlQty + '" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off" ' + issuedisabled + ' id="txtIssueQty" maxlength="4"  onkeyup="onQuantityChange(this,function(){});"   style="" value=' + quantity + ' />' +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdItemDiscountPercent"><input type="text" max-value="100" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off" id="txtItemDiscountPercent" maxlength="4"  onkeyup="onItemDiscountChange(event,function(){});"   style="" value=' + discountPercent + ' />' +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdDiscountAmt"><input type="text" max-value="' + grossAmount + '" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off" id="txtItemDiscountAmount" maxlength="4"  onkeyup="onItemDiscountChange(event,function(){});"   style="" value=' + discountAmount + ' />' +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdAmount"> ' + netAmmount +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;width:200px;"> <input type="checkbox" id="chkClinical" onchange="$OpenClinicalPopup(this);" /> <img id="imgClinicaltrial" src="../../Images/View.gif" onclick="viewClinicalMedicine(this)" style="cursor:pointer;" title="Click To View Clinical Trial"/></br><textarea id="txtCriticalRemarks" maxlength="200" style="max-width: 200px;min-width: 100px; width:200px; max-height:50px; display:none;" ></textarea> </td>' +
                              '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgPhRemove"><img id="imgRmv" class="btn" src="../../Images/Delete.gif" onclick="removeMedicine(this);"  class="pharmacyRemove"  style="cursor:pointer;" title="Click To Remove"/></td>'
                              );
            }
            else {
                newRow.html(
                                  '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center">' + (table.find('tr').length + 1) +
                                  '</td><td class="GridViewLabItemStyle" id="tdItemName">' + itemDetails.ItemName +
                                  '</td><td class="GridViewLabItemStyle" id="tdBatchNumber" style="text-align:center">' + itemDetails.BatchNumber +
                                  '</td><td class="GridViewLabItemStyle" id="tdisExpirable" style="display:none;">' + itemDetails.isexpirable +
                                  '</td><td class="GridViewLabItemStyle" id="tdMedExpiryDate">' + itemDetails.MedExpiryDate +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdUnitType">' + itemDetails.UnitType +
                                  '</td><td class="GridViewLabItemStyle" style="display:none" id="tdActualIssueQty">' + quantity +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdTotalAvlQty">' + itemDetails.AvlQty +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdMRP">' + SellPrice +

                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdVAT">' + itemDetails.VAT +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdTaxAmount">' + calculateVatTaxAmount(quantity, itemDetails.MRP, itemDetails.VAT, discountPercent) +

                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdGrossAmount">' + grossAmount +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdisItemWiseDisc">' + itemDetails.isItemWiseDisc +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdDiscountPer">' + discountPercent +//$.trim($("#txtDiscItem").val())
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdStockID">' + itemDetails.stockid +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdItemID">' + itemDetails.ItemID +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdSubCategoryID">' + SubcategoryID +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdUnitPrice">' + itemDetails.UnitPrice +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdToBeBilled">' + itemDetails.ToBeBilled +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdIsUsable">' + itemDetails.IsUsable +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdType_ID">' + itemDetails.Type_ID +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdPatientMedicine">' + itemDetails.patientMedicine +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdItemdraftDetailID">' + itemDetails.draftDetailID +


                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdIndentNo">' + itemDetails.indentNo +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdPurTaxPer">' + itemDetails.PurTaxPer +
                                  // Add new on 29-06-2017 - For GST
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdHSNCode">' + itemDetails.HSNCode +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdIGSTPercent">' + itemDetails.IGSTPercent +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdSGSTPercent">' + itemDetails.SGSTPercent +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdCGSTPercent">' + itemDetails.CGSTPercent +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="tdGSTType">' + itemDetails.GSTType +
                                          // Add new on 09-03-2022 by Ajeet 
                                          '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnIsPayable">' + IsPayable +
                                          '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnCoPaymentPercent">' + coPaymentPercent +
                                          '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnIsPanelWiseDiscount">' + IsPanelWiseDiscount +
                                          '</td><td class="GridViewLabItemStyle" style="text-align:center;display:none" id="spnDiscountAmount">' + discountPercentAmt +
                                           // End 09-03-2022 by Ajeet 
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;width:50px" id="tdIssueQty"><input type="text" max-value="' + itemDetails.AvlQty + '" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off" ' + issuedisabled + ' id="txtIssueQty" maxlength="4"  onkeyup="onQuantityChange(this,function(){});"   style="" value=' + quantity + ' />' +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdItemDiscountPercent"><input type="text" max-value="100" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off" id="txtItemDiscountPercent" maxlength="4"  onkeyup="onItemDiscountChange(event,function(){});"   style="" value=' + discountPercent + ' />' +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center" id="tdDiscountAmt"><input type="text" max-value="' + grossAmount + '" onkeypress="$commonJsNumberValidation(event)" decimalPlace="2" onkeydown="$commonJsPreventDotRemove(event)" class="classPharmacy ItDoseTextinputNum" autocomplete="off" id="txtItemDiscountAmount" maxlength="4"  onkeyup="onItemDiscountChange(event,function(){});"   style="" value=' + discountAmount + ' />' +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="tdAmount"> ' + netAmmount +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;width:200px;"> <input type="checkbox" id="chkClinical" onchange="$OpenClinicalPopup(this);" /> <img id="imgClinicaltrial" src="../../Images/View.gif" onclick="viewClinicalMedicine(this)" style="cursor:pointer;" title="Click To View Clinical Trial"/></br><textarea id="txtCriticalRemarks" maxlength="200" style="max-width: 200px;min-width: 100px; width:200px; max-height:50px; display:none;" ></textarea> </td>' +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgPhRemove"><img id="imgRmv" class="btn" src="../../Images/Delete.gif" onclick="removeMedicine(this);"  class="pharmacyRemove"  style="cursor:pointer;" title="Click To Remove"/></td>'
                                  );
            }
            table.append(newRow);

                    callback(true);
                });
            });
        }




        var removeMedicine = function (elem) {
            $(elem).parent().parent().remove();
            calculateTotal(function (total) { });
        }

        var clearSelectedMedicines = function (callback) {
            $('#divSelectedMedicine table tbody tr').remove();
            $("#lblIsPharmacyItemAdded").val(0)
            calculateTotal(function (total) {
                callback();
            });
        }


        //Allergies
            
        var $IsShowAllergiesAndDiagnosisButton = function (patientID) {
            $("#btnAllergiesAndDiagnosis").hide();
            serverCall('OPDPharmacyIssue.aspx/GetAllergiesAndDiagnosis', { patientID: patientID }, function (response) {
                AllergiesAndDiagnosis = JSON.parse(response);
                if (AllergiesAndDiagnosis.length > 0) {
                    $("#btnAllergiesAndDiagnosis").show();
                }
            });
        }
        var $popupAllergiesAndDiagnosis = function () {
            serverCall('OPDPharmacyIssue.aspx/GetAllergiesAndDiagnosis', { patientID:  $('#lblMrNo').text() }, function (response) {
            AllergiesAndDiagnosis = JSON.parse(response);
            if (AllergiesAndDiagnosis.length > 0) {
                var message = $('#tb_AllergiesAndDiagnosispopup').parseTemplate(AllergiesAndDiagnosis);
                $('#dvAllergiesAndDiagnosisData').html(message);
                $('#dvAllergiesAndDiagnosis').showModel();
            }

        });
    }
        var closeAllergiesAndDiagnosisModel = function () {
            $('#dvAllergiesAndDiagnosis').closeModel();
        }
    </script>
    <script id="tb_AllergiesAndDiagnosispopup" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdAllergiesAndDiagnosis" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Type</th>
                <th class="GridViewHeaderStyle" scope="col" >Value</th>
            </tr>
                </thead><tbody>
        <#       
        var dataLength=AllergiesAndDiagnosis.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = AllergiesAndDiagnosis[j];
        #>
               <tr id="TrBody" >        
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.EntryDate #></td>
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.DataType #></td>
                    <td class="GridViewLabItemStyle" style="text-align:left"><#=objRow.DataValues #></td>
               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>
      <div id="dvAllergiesAndDiagnosis" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 40%;">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="closeAllergiesAndDiagnosisModel()" aria-hidden="true">×</button>
                        <h4 class="modal-title">Patient Allergies & Diagnosis</h4>
                    </div>
                    <div style="max-height: 200px; overflow:auto;" class="modal-body">
                        <div id="dvAllergiesAndDiagnosisData"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" onclick="closeAllergiesAndDiagnosisModel()">Close</button>
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

                          <input type="text" id="txtSearchModelMrNO" />
                     </div>
                     <div  class="col-md-4">
                           <label class="pull-left"> Family No.  </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-8">
                          <input type="text" id="txtFamilyNo" />
                     </div>
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
                <button type="button" style="width:30px;height:30px;float:left;margin-left:5px;background-color:orange" class="circle"></button><b style="float:left;margin-top:5px;margin-left:5px">Admited Patients</b>   
                <button type="button"  onclick="$closeOldPatientSearchModel()">Close</button>
            </div>
        </div>
    </div>
</div>


    <script type="text/javascript">

        var showPrescribedMedicineModel = function (isIndentSearch) {
            getPatientIndents(function (details) {
                var divModelMedicineIndentIssue = $('#divModelMedicineIndentIssue');
                divModelMedicineIndentIssue.find('.searchCriteria').show();
                if (String.isNullOrEmpty(details.searchCreteria.IPDNO)) {
                    divModelMedicineIndentIssue.find('#lblIndentSearch').text('UHID');
                    divModelMedicineIndentIssue.find('.modal-title').text('Prescription`s');
                    divModelMedicineIndentIssue.find('#txtIndentID').val(details.searchCreteria.MRNO).prop('disabled', true);
                }
                else {
                    divModelMedicineIndentIssue.find('#lblIndentSearch').text('Indent No');
                    divModelMedicineIndentIssue.find('.modal-title').text('Indent`s');
                    if (isIndentSearch == 0) {
                        divModelMedicineIndentIssue.find('#txtIndentID').val('').prop('disabled', false);
                    }
                    else {
                        divModelMedicineIndentIssue.find('#txtIndentID').prop('disabled', false);
                        getIndentItemsDetails($('#tblPatientIndents tbody tr:first')[0], 0);
                        $('#divAllPendingIndentSearch').hideModel();
                    }
                }

                divModelMedicineIndentIssue.showModel();
            }, 0);

        }

        var searchPrescribedMedicine = function () {
            var data = {
                MRNo: $('#lblPatientID').text().trim(),
                fromDate: $('#txtPrescribedMedicineFromDate').val().trim(),
                toDate: $('#txtPrescribedMedicineToDate').val().trim(),
                type: $('input[type=radio][name=rdoPatientType]:checked').val(),
                DeptLedgerNo: $('#lblDeptLedgerNo').text().trim(),
                IPDNo: $('#lblIPDNo').text().trim(),
            }
            serverCall('OPDPharmacyIssue.aspx/medicineSearch', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var output = "";
                    responseData = JSON.parse(response);
                    if (data.type == '1') {
                        output = $('#templatePrescribedMedicine').parseTemplate(responseData);
                    }
                    if (data.type == '3') {
                        output = $('#templatePrescribedMedicineIPD').parseTemplate(responseData);
                    }
                    if (output != "") {
                        $('#divPrescribedSearchDetails').html(output).customFixedHeader();
                    }
                }
            });
        }

        var bindPrescribedMedicineStockDetails = function (elem, callback) {
            var row = $(elem).closest('tr');
            var patientType = $('input[type=radio][name=rdoPatientType]:checked').val();
            var data = {
                ItemID: row.find('.medicineID').text(),   // row.find('#tdMedicine_ID').text(),
                MedID: row.find('.medicineRefno').text(),//row.find('#tdPatientMedicineID').text(),
                DeptLedgerNo: $("#lblDeptLedgerNo").text(),
                AvlQty: 0// patientType == '3' ? row.find('#tdMedAvlQty').text() : 0
            }
            serverCall('OPDPharmacyIssue.aspx/addItem', data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    prescribedMedicineStockDetails = JSON.parse(response);
                    var output = $('#templatePrescribedMedicineStockDetails').parseTemplate(prescribedMedicineStockDetails).customFixedHeader();
                    row.next().show().find('.tdStockDetails').html(output)
                    callback();
                }
                else
                    modelAlert('Stock Not Avilable In This Department', function () { });
            });
        }

        var tooglePatientPrescribedDetails = function (elem) {
            if ($(elem).hasClass('imgPlus')) {
                bindPrescribedMedicineStockDetails(elem, function () {
                    $(elem).attr('src', '../../Images/minus.png').removeClass('imgPlus').addClass('imgMinus');
                });
            }
            else {
                $(elem).attr('src', '../../Images/plus_in.gif').removeClass('imgMinus').addClass('imgPlus');
                $(elem).closest('tr').next().hide();
            }
        }
    </script>

    <div id="divModelPrescribedMedicine"  class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width:90%" >
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divModelPrescribedMedicine"  aria-hidden="true">&times;</button>
                <h4 class="modal-title">Medicine Prescribed </h4>
            </div>
            <div class="modal-body">
                 <div class="row">
                      <div  class="col-md-3">
                          <label class="pull-left">  UHID    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-5">
                         <label style="color:blue;font-weight:bold" class="pull-left" id="lblPatientID"></label>
                     </div>


                     <div  class="col-md-3">
                          <label class="pull-left">  From Date    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-5">
                           <asp:TextBox ID="txtPrescribedMedicineFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                           <cc1:calendarextender ID="calExdtxtPrescribedMedicineFromDate" TargetControlID="txtPrescribedMedicineFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                     <div  class="col-md-3">
                           <label class="pull-left"> To Date</label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-5">
                          <asp:TextBox ID="txtPrescribedMedicineToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
                          <cc1:calendarextender ID="calExdtxtPrescribedMedicineToDate" TargetControlID="txtPrescribedMedicineToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                 </div>


                <div style="text-align:center" class="row">
                       <button type="button"  onclick="searchPrescribedMedicine()">Search</button>
                </div>
                <div style="max-height:400px;min-height:200px"  class="row">
                    <div id="divPrescribedSearchDetails" style="height:100%;overflow:auto" class="col-md-24">

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                 <button type="button" onclick="addPrescribedItem()">Add</button>
                <button type="button"  data-dismiss="divModelPrescribedMedicine">Close</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
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
            FamilyNo: $("#txtFamilyNo").val()
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

    var $getPatientDetails = function (selectPatientID, callback) {
        // var patientType = $('input[type=radio][name=rdoPatientType]:checked').val();
        var data = {
            patientID: $.trim($('#txtPatientId').val()),
            IPDNo: $.trim($('#txtIPDNO').val()),
            EMGNo: $.trim($('#txtEMGNo').val()),
        }

        if (!String.isNullOrEmpty(selectPatientID))
            data.patientID = selectPatientID

        serverCall('OPDPharmacyIssue.aspx/bindData', data, function (response) {
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
        $panelControlInit(function () {
         //   $('#ddlPanelGroup,#ddlParentPanel,#ddlPanelCompany').prop('disabled', true).chosen('destroy').chosen({ width: '100%' });
            $('#lblPatientName').text(data.PName);
            $('#lblMrNo').text(data.PatientID);
            $('#lblIPDNo').text($.trim(data.Status) == 'IN' ? data.TransactionID : '');
            $('#lblEMGNo').text($.trim(data.Status) == 'IN' ? data.EmergencyNo : '');
            $('#lblAgeSex').text(data.Age + '/' + data.Gender);
            $('#lblAddresss').text(data.Address);
            $('#lblContact').text(data.ContactNo);
            $('#lblPDNo').text(data.TransactionID);
            $('#ddlOldPatientDoctor').val(data.DoctorID).chosen('destroy').chosen({ width: '100%' });
            $('#ddlPanelCompany option').filter(function () { return this.value.split('#')[0] == data.PanelID; }).attr('selected', true).trigger('chosen:updated').trigger('change');
            $('#divMedicineSelect,#divHospitalPatientEntry').show();
            $('#lblDischargeStatus').text($.trim(data.Status));
            $('#lblPatientType').text($.trim(data.PatientType));
            $('#lblHeight').text($.trim(data.Vitial.split('#')[0]));
            $('#lblWeight').text($.trim(data.Vitial.split('#')[1]));

            $closeOldPatientSearchModel();
            $IsShowAllergiesAndDiagnosisButton(data.PatientID);
            $popupAllergiesAndDiagnosis();

            if (data.PatientID != "") {
                serverCall('../Common/CommonService.asmx/BindPatientMultiPanelDetails', { PatientID: data.PatientID }, function (response) {
                    $getMultiPanelDetails(JSON.parse(response), function () { });
                });

            }
            callback(true);
        });
    }


    var $bindGeneralPatientDetails = function (data, callback) {
        $panelControlInit(function () {
            $('#ddlTitle').val(data.Title);
            $('#txtName').val(data.PFirstName);
            $('#lblMrNo').text('');
            $('#lblIPDNo').text('');
            $('#txtAge').val(data.Age.split(' ')[0]);
            $('#ddlAge').val(data.Age.split(' ')[1]).chosen('destroy').chosen({ width: '100%' });
            $('#txtAddress').val(data.Address);
            $('#txtPhoneNo').val(data.ContactNo);
            $('#lblPDNo').text('');
            $('#ddlDoctor').val(data.DoctorID).chosen('destroy').chosen({ width: '100%' });
            $('#ddlPanelCompany').val('<%=Resources.Resource.DefaultPanelID%>').chosen('destroy').chosen({ width: '100%' });
            $closeOldPatientSearchModel();
            callback(true);
        });

    }




    var clearHospitalPatientDetails = function (callback) {
        $('#divHospitalPatientEntry .patientInfo').text('');
        $('#ddlOldPatientDoctor').val('0').chosen('destroy').chosen({ width: '100%' });
        $('#ddlOldPatientDoctor').val('<%=Resources.Resource.DefaultPanelID %>').chosen('destroy').chosen({ width: '100%' });
        callback(true);
    }

    var clearGeneralPatientDetails = function (callback) {
        $('#divGeneralPatientEntry input[type=text]').val('');
        $('#divGeneralPatientEntry select').val('0').not('#ddlTitle').chosen('destroy').chosen({ width: '100%' });
        callback(true);
    }

    var $OpenClinicalPopup = function (rowId, callback) {
        if ($(rowId).is(':checked'))
            $(rowId).closest('tr').find('#txtCriticalRemarks').show();
        else
            $(rowId).closest('tr').find('#txtCriticalRemarks').hide();

        callback(true);
    }


    $(function () {
        shortcut.add("Alt+S", function () {
            var btnSave = $('#promptConfirmOkButtonText');
            if (!String.isNullOrEmpty(btnSave)) {
                if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                    savePharmacyIssue(btnSave);
                }
            }
        }, addShortCutOptions);
    });

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
                            style='cursor:pointer;<#=objRow.IPDDetails!=''?'background-color:orange':'' #>' 
                             <%--<#if(objRow.PatientRegStatus =="2"){#>
                        style="background-color:coral;cursor:pointer;"
                         
                        <#}
                         else {#>
                        style="cursor:pointer;"
                        <#}
                        #>--%>
                            >                            
                        <td class="GridViewLabItemStyle">
                       <a  class="btn" onclick="$searchPatient({PatientID:$.trim($(this).closest('tr').find('#tdPatientID').text()),PatientRegStatus:1},$(this).find('#spnIPDDetails').text(),function(response){$bindPatientDetails(response,function(){ searchDefaultIndentPrescriptions(response,function(){   getPatientIndents(function () { }, 0); }); })});" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
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
  

<script id="templatePatientIndents" type="text/html">
    <table class="FixedTables" id="tblPatientIndents" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Indent No</th>
            <th class="GridViewHeaderStyle" scope="col" >Requested</th>
            <th class="GridViewHeaderStyle" scope="col" >Rejected</th>		
            <th class="GridViewHeaderStyle" scope="col" >Indent Type</th>
            <th class="GridViewHeaderStyle" scope="col" >Indent From</th>
            <th class="GridViewHeaderStyle" scope="col" >Indent By</th>	
            <th class="GridViewHeaderStyle" scope="col" >Status</th>	
            <th class="GridViewHeaderStyle" scope="col" >Select</th>	
            <th class="GridViewHeaderStyle" scope="col" >Reject</th>		          	 
        </tr>
         </thead><tbody>
        <#       
        var dataLength=patientIndentDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = patientIndentDetails[j];
        #>
                    <tr  id="<#=objRow.indentno#>">
                        
                      
                    
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle" id="tdIndentNo" style="text-align:center"><#=objRow.indentno#></td>
                    <td class="GridViewLabItemStyle" id="td10" style="text-align:center"><#=objRow.ReqQty#></td>
                    <td class="GridViewLabItemStyle" id="td11" style="text-align:center"><#=objRow.RejectQty#></td>
                    <td class="GridViewLabItemStyle" id="td7"  style="text-align:center"><#=objRow.IndentType#></td>
                    <td class="GridViewLabItemStyle" id="td8"  style="text-align:center;"><#=objRow.DeptFrom#></td>    
                    <td class="GridViewLabItemStyle" id="td9"  style="text-align:center;"><#=objRow.UserName#></td>
                    <td class="GridViewLabItemStyle" id="td17" style="text-align:center;"><#=objRow.StatusNew#></td>
                    <td style="text-align:center" class="GridViewLabItemStyle">

                  <# if(objRow.StatusNew!='REJECT' && objRow.StatusNew!='CLOSE'){#>
                     <img alt="" src="../../Images/Post.gif" id="btnBindIndentItem" class="imgPlus"  style="cursor:pointer" onclick="getIndentItemsDetails(this,0)"  />
                        <#}#>
                    </td>
                    <td style="text-align:center" class="GridViewLabItemStyle">
                         <# if(objRow.StatusNew!='REJECT' && objRow.StatusNew!='CLOSE'){#>
                     <img alt="" src="../../Images/Delete.gif" class="imgPlus"  style="cursor:pointer" onclick="onIndentReject(this)"  />
                          <#}#>
                    </td>    
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>
<script id="templateAllPatientIndents" type="text/html">
    <table class="FixedTables" id="tblAllPatientIndents" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="aHeader">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Indent No</th>
             <th class="GridViewHeaderStyle" scope="col" >Date</th>
            <th class="GridViewHeaderStyle" scope="col">IPDNo.</th>
            <th class="GridViewHeaderStyle" scope="col">PName</th>
           <th class="GridViewHeaderStyle" scope="col">Panel</th>
            <th class="GridViewHeaderStyle" scope="col" >Requested</th>
            <th class="GridViewHeaderStyle" scope="col" >Rejected</th>		
            <th class="GridViewHeaderStyle" scope="col" >Indent Type</th>
            <th class="GridViewHeaderStyle" scope="col" >Indent From</th>
            <th class="GridViewHeaderStyle" scope="col" >Indent By</th>	
            <th class="GridViewHeaderStyle" scope="col" >Status</th>	
            <th class="GridViewHeaderStyle" scope="col" >Select</th>	
            <%--<th class="GridViewHeaderStyle" scope="col" >Reject</th>--%>	          	 
        </tr>
         </thead><tbody>
        <#       
        var dataLength=allPatientIndentDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = allPatientIndentDetails[j];
        #>
                    <tr id="<#=objRow.indentno#>">
                        
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle" id="tdAIndentNo" style="text-align:center"><#=objRow.indentno#></td>
                    <td class="GridViewLabItemStyle" id="td20" style="text-align:center"><#=objRow.dtEntry#></td>
                    <td class="GridViewLabItemStyle" id="td31" style="text-align:center"><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle" id="td30" style="text-align:center"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="td32" style="text-align:center"><#=objRow.PanelName#></td>
                    <td class="GridViewLabItemStyle" id="td24" style="text-align:center"><#=objRow.ReqQty#></td>
                    <td class="GridViewLabItemStyle" id="td25" style="text-align:center"><#=objRow.RejectQty#></td>
                    <td class="GridViewLabItemStyle" id="td26"  style="text-align:center"><#=objRow.IndentType#></td>
                    <td class="GridViewLabItemStyle" id="td27"  style="text-align:center;"><#=objRow.DeptFrom#></td>    
                    <td class="GridViewLabItemStyle" id="td28"  style="text-align:center;"><#=objRow.UserName#></td>
                    <td class="GridViewLabItemStyle" id="td29" style="text-align:center;"><#=objRow.StatusNew#></td>
                    <td style="text-align:center" class="GridViewLabItemStyle">

                  <# if(objRow.StatusNew!='REJECT' && objRow.StatusNew!='CLOSE'){#>
                     <img alt="" src="../../Images/Post.gif" class="imgPlus"  style="cursor:pointer" onclick="getIndentItemsDetailsWithPatient(this,'<#=objRow.indentno#>','<#=objRow.IPDNo#>','<#=objRow.EMGNo#>')"  />
                        <#}#>
                    </td>
                   <%-- <td style="text-align:center" class="GridViewLabItemStyle">
                         <# if(objRow.StatusNew!='REJECT' && objRow.StatusNew!='CLOSE'){#>
                     <img alt="" src="../../Images/Delete.gif" class="imgPlus"  style="cursor:pointer" onclick="onIndentReject(this)"  />
                          <#}#>
                    </td> --%> 
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>
<div id="divModelMedicineIndentIssue"  class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="min-width:90%;max-height:500px;min-height:500px;" >
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divModelMedicineIndentIssue"  aria-hidden="true">&times;</button>
                <h4 class="modal-title">Medicine Prescribed </h4>
            </div>
            <div class="modal-body">
                 <div class="row searchCriteria">
                      <div  class="col-md-3">
                          <label id="lblIndentSearch" class="pull-left">  Indent  No  </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-5">
                         <input type="text" id="txtIndentID" />
                     </div>
                     <div  class="col-md-3">
                          <label class="pull-left">  From Date    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-5">
                           <asp:TextBox ID="txtIndentFrom" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Indent From" ></asp:TextBox>
                           <cc1:calendarextender ID="Calendarextender1" TargetControlID="txtIndentFrom" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                     <div  class="col-md-3">
                           <label class="pull-left"> To Date    </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-5">
                          <asp:TextBox ID="txtIndentTo" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Indent To" ></asp:TextBox>
                          <cc1:calendarextender ID="Calendarextender2" TargetControlID="txtIndentTo" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender> 
                     </div>
                 </div>


                <div style="text-align:center" class="row searchCriteria">
                       <button type="button"  onclick="getPatientIndents(function(){},0)">Search</button>
                </div>

              <%--  <fieldset>
                    <legend>Indent Issue</legend>--%>
               

                <div  class="row">
                    <div id="divIndentDetails" style="max-height:330px;overflow:auto" class="col-md-24">
                     

                    </div>
                </div>
                <div style="display:none"  class="row divIndentItemsDetails">
                    <div style="padding-right:2px"  class="col-md-24">
                        <div class="col-md-3">
                            <label class="pull-left"><b></b></label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                           
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left"><b></b></label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                              <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color:orange; cursor: default;" class="circle" ></button>
                            
                              <b style="margin-top:5px;margin-left:5px;float:left">Issued</b>
                        
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left"><b>Barcode</b></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" class="ItDoseTextinputNum" id="txtScanMedicine" onkeyup="onScanBarcode(event)" />
                        </div>
                    </div>
                </div>


                <div  style="display:none"  class="row divIndentItemsDetails">
                    <div id="divIndentItemsDetails" style="max-height:250px; min-height:250px;overflow:auto" class="col-md-24">


                    </div>
                </div>
             <%--   </fieldset>--%>

            </div>
            <div style="display:none" class="modal-footer divIndentItemsDetails">
                 <button type="button" id="btnadd" onclick="addIndentItems()">Add</button>
                <button type="button"  data-dismiss="divModelMedicineIndentIssue">Close</button>
            </div>
        </div>
    </div>
</div>


<script id="templateIndentItemsStockDetails" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr3">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Medicine</th>
             <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Dose</th>
            <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Duration</th>		
            <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Interval</th>
            <th class="GridViewHeaderStyle"   scope="col" >Time</th>
            <th class="GridViewHeaderStyle"   scope="col" >Dr.Remarks</th>
             <th class="GridViewHeaderStyle" style="width:80px"   scope="col" >Refil</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Requested</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Issued</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Rejected</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Available</th>
            <th class="GridViewHeaderStyle" style="width:100px" scope="col" >BatchNumber</th>		
            <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Expire Date</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >MRP</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Issue</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Reject</th>        	 
        </tr>
         </thead><tbody>
        <#       
        var objRow; 
        var medicineSrNo=0;
        var stockIssue=0;
        var totalIssue=0;
        for(var j=0;j<indentItemsStockDetails.length;j++)
        {       
        objRow = indentItemsStockDetails[j];
        var isNewItem=objRow.ItemID!=((j==0)?'':indentItemsStockDetails[j-1].ItemID);
        var isLastItem=((objRow.ItemID!=((j+1==indentItemsStockDetails.length)?'':indentItemsStockDetails[j+1].ItemID)));
var SearchType=objRow.SearchType;
        #>
                    <tr  class="<#=objRow.ItemID#> <#=objRow.IndentNo#>   <#if(objRow.ReceiveQty>0 ){#>
                              Orange 
                           <#}#>" id="Tr7"
                        <#if(objRow.ReqQty==totalIssue && !isNewItem){#>
                              style="display:none" 
                           <#}#>
                        >
                        
                        <#
                           var pendingQty=(Number(objRow.ReqQty)-Number(totalIssue));
                           var isTotalIssued=false;
                           if(pendingQty>0){
                                stockIssue= ((objRow.AvlQty>pendingQty)?pendingQty:objRow.AvlQty);
                                isTotalIssued=((totalIssue+stockIssue)==objRow.ReqQty)?true:false;
                           }
                        #>


                        <#if(isNewItem){
                              medicineSrNo=medicineSrNo+1;
                              stockIssue= ((objRow.AvlQty>objRow.ReqQty)?objRow.ReqQty:objRow.AvlQty);
                              totalIssue=stockIssue;#>
                         
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=medicineSrNo#></td>
                    <td class="GridViewLabItemStyle patientInfo" id="td12"  style="text-align:left;font-weight: bold;"><#=objRow.ItemName#></td>
                    
                    <td class="GridViewLabItemStyle" id="tdDose" style="text-align:center"><#=objRow.Dose#></td>
                    <td class="GridViewLabItemStyle" id="tdDurationName" style="text-align:left"><#=objRow.DurationName#></td>
                    <td class="GridViewLabItemStyle" id="tdIntervalName" style="text-align:center"><#=objRow.IntervalName#></td>
                    <td class="GridViewLabItemStyle" id="tdTimetoGive" style="width: 200px;text-align:end;"><#=objRow.TimetoGive#></td>
                    <td class="GridViewLabItemStyle" id="td35" style="text-align:center;"><#=objRow.DrRemarks#></td>
                        <td class="GridViewLabItemStyle" id="tdRefealVal" style="text-align:center;"><#=objRow.RefealVal#></td>

                        
                        
                    <td class="GridViewLabItemStyle" id="tdReqQty" style="text-align:center"><#=objRow.TotalReqQty#></td>
                    <td class="GridViewLabItemStyle" id="td2" style="text-align:center"><#=objRow.ReceiveQty#></td>
                    <td class="GridViewLabItemStyle" id="td1" style="text-align:center"><#=objRow.RejectQty#></td>
                    <#} else{#>
                           <td colspan="10" class="GridViewLabItemStyle" style="border-top-color: transparent;
                                <#if(isLastItem ||isTotalIssued){#>    ""
                                       <#}else{#>
                                        border-bottom-color: transparent";
                                       <#}#>
                               
                               ></td>
                            


                        <#
                           var pendingQty=(Number(objRow.ReqQty)-Number(totalIssue));
                           if(pendingQty>0){
                                stockIssue= ((objRow.AvlQty>pendingQty)?pendingQty:objRow.AvlQty);
                                totalIssue=totalIssue+stockIssue;
                           }
                           else
                            stockIssue="";
                        
                        }#>

                    <td class="GridViewLabItemStyle" id="tdStockId" style="display:none" ><#=objRow.stockid#></td> 
                    <td class="GridViewLabItemStyle" id="tdItemID" style="display:none" ><#=objRow.ItemID#></td> 
                    <td class="GridViewLabItemStyle" id="tdIndentNo" style="display:none" ><#=objRow.IndentNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientMedicine" style="display:none" ><#=objRow.patientMedicine#></td>
                    <td class="GridViewLabItemStyle" id="tddraftDetailID" style="display:none" ><#=objRow.draftDetailID#></td>  
                    <td class="GridViewLabItemStyle" id="tdItemName" style="display:none" ><#=objRow.ItemName#></td>

                    <td class="GridViewLabItemStyle" id="tdAvlQty" style="text-align:center"><#=objRow.AvlQty#></td>
                    <td class="GridViewLabItemStyle" id="tdBatchNumber" style="text-align:left"><#=objRow.BatchNumber#></td>
                    <td class="GridViewLabItemStyle" id="tdMedExpiryDate" style="text-align:center"><#=objRow.MedExpiryDate#></td>
                    <td class="GridViewLabItemStyle" id="tdMRP" style="text-align:center;"><#=objRow.MRP#></td>
                    <td class="GridViewLabItemStyle" id="tdCanRefil" style="text-align:center;display:none"><#=objRow.CanRefil#></td>

                    

                    <td class="GridViewLabItemStyle" id="td6"  style="text-align:center">
                        <input type="text" id="txtIssueQuantity" onlynumber="10" decimalplace="4"  max-value="<#=Number(objRow.AvlQty)#>" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"  value="<#=stockIssue#>" />
                    </td>

                    <td style="text-align:center" class="GridViewLabItemStyle">
                         <#if(isNewItem){#>
                       <#if(SearchType=="OPD")
                        {#>
                        <input type="button" value="Close Indent" style="cursor:pointer" onclick="onOpdMedReject(this)" />
                        <#}else
                        {#>
                        <img alt="" src="../../Images/Delete.gif" class="imgPlus"  style="cursor:pointer" onclick="onIndentReject(this)"  />
                       

                        <#}#>


                      <#}#>
                    </td>   

               </tr>     
             
        <#}#>   
       </tbody>   
     </table>    
</script>


<script id="templatePatientPrescription" type="text/html">
    <table class="FixedTables" id="Table1" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr2">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Prescription On</th>
            <th class="GridViewHeaderStyle" scope="col" >Prescription By</th>
             <th class="GridViewHeaderStyle" scope="col" >To Department</th>
            <th class="GridViewHeaderStyle" scope="col" >No of Medicine</th>
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
        </tr>
         </thead><tbody>
        <#       
        var dataLength=patientIndentDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = patientIndentDetails[j];
        #>
                    <tr  id="Tr4">
                        
                      
                    
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle" id="tdPrescriptionDate" style="text-align:center"><#=objRow.Date#></td>
                    <td class="GridViewLabItemStyle" id="td4" style="text-align:center"><#=objRow.DName#></td>
                    <td class="GridViewLabItemStyle" id="tdPrescriptionDoctor" style="display:none"><#=objRow.DoctorID#></td>
                    <td class="GridViewLabItemStyle" id="td34" ><#=objRow.ToDepartment#></td>
                     <td class="GridViewLabItemStyle" id="tdPrescriptionPatientID" style="display:none"><#=objRow.patientID#></td>       
                    <td class="GridViewLabItemStyle" id="td5" style="text-align:center"><#=objRow.NoOfMedicine#></td>
                    <td style="text-align:center" class="GridViewLabItemStyle">
                     <img alt="" src="../../Images/Post.gif" class="imgPlus" id="tbl1AutoClick"  style="cursor:pointer" onclick="getIndentItemsDetails(this,1)"  />
                    </td>
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>


<script id="templateDemandDrafts" type="text/html">
    <table class="FixedTables" id="Table3" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr8">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Create On</th>
            <th class="GridViewHeaderStyle" scope="col" >Create By</th>
            <th class="GridViewHeaderStyle" scope="col" >No of Medicine</th>
            <th class="GridViewHeaderStyle" scope="col" >Select</th>
        </tr>
         </thead><tbody>
        <#       
        var dataLength=patientIndentDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = patientIndentDetails[j];
        #>
                    <tr  id="Tr9">
                        
                      
                    
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle" id="td14" style="text-align:center"><#=objRow.CreatedOn#></td>
                    <td class="GridViewLabItemStyle" id="td19" style="text-align:center"><#=objRow.EmployeeName#></td>
                    <td class="GridViewLabItemStyle" id="td22" style="text-align:center"><#=objRow.MedicineCount#></td>
                    <td class="GridViewLabItemStyle hidden" id="tdDemandDraftID" ><#=objRow.ID#></td>
                    <td style="text-align:center" class="GridViewLabItemStyle">
                     <img alt="" src="../../Images/Post.gif" class="imgPlus"  style="cursor:pointer" onclick="getIndentItemsDetails(this,2)"  />
                    </td>
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>




<script type="text/javascript">

    var getPatientIndents = function (callback, demandDraftID) {
        var data = {
            deptLedgerNo: $.trim($('#lblDeptLedgerNo').text()),
            IPDNO: $.trim($('#lblIPDNo').text()),
            MRNO: $.trim($('#lblMrNo').text()),
            fromDate: $.trim($('#txtIndentFrom').val()),
            toDate: $.trim($('#txtIndentTo').val()),
            indentID: $.trim($('#txtIndentID').val()),
            searchType: '',
            demandDraftID: demandDraftID
        }
        if (!String.isNullOrEmpty(data.IPDNO))
            data.searchType = 'Indend';

        serverCall('Pharmacy.asmx/GetPatientIndent', data, function (response) {
            patientIndentDetails = JSON.parse(response);
            var parseHTML = ''
            var length = patientIndentDetails.length;
             
        
            if (data.demandDraftID > 0)
                parseHTML = $('#templateDemandDrafts').parseTemplate(patientIndentDetails);
            else {
                if (!String.isNullOrEmpty(data.IPDNO))
                    parseHTML = $('#templatePatientIndents').parseTemplate(patientIndentDetails);
                else
                    parseHTML = $('#templatePatientPrescription').parseTemplate(patientIndentDetails);
            }
            $('#divModelMedicineIndentIssue').find('#divIndentDetails').html(parseHTML);
            $('.divIndentItemsDetails').hide();
            $("#spnCounts").text(length);

            callback({ patientIndentDetails: patientIndentDetails, searchCreteria: data });
        });
    }










    var getIndentItemsDetails = function (elem, searchType) {
        var row = $(elem).closest('tr');
        var data = {}
        var URl = 'Pharmacy.asmx/GetIndentItemsStockDetails';
        data.deptLedgerNo = $.trim($('#lblDeptLedgerNo').text());
        if (searchType == 0)
            data.indentNo = $.trim(row.find('#tdIndentNo').text());
        else {
            data.date = $.trim(row.find('#tdPrescriptionDate').text());
            data.patientID = $.trim(row.find('#tdPrescriptionPatientID').text());
            data.doctorID = $.trim(row.find('#tdPrescriptionDoctor').text());
            URl = 'Pharmacy.asmx/GetPrescribedItemStockDetails';
        }


        if (searchType == 2) {
            data.demandDraftID = Number(row.find('#tdDemandDraftID').text());
            URl = 'Pharmacy.asmx/GetDemandItemDetails';
        }
        //$('#divIndentItemsDetails').html('');
        serverCall(URl, data, function (response) {
            indentItemsStockDetails = JSON.parse(response);
            if (indentItemsStockDetails.length>0) {
                var template = $('#templateIndentItemsStockDetails').parseTemplate(indentItemsStockDetails);
                $('#divIndentItemsDetails').html(template).customFixedHeader();
                $(row).css({ 'background-color': 'aquamarine' }).closest('tbody').find('tr').not(row).hide();
                $('.divIndentItemsDetails').show();
            }
            else {
                $('#divIndentItemsDetails').html('').customFixedHeader();
                $(row).css({ 'background-color': 'aquamarine' }).closest('tbody').find('tr').not(row).hide();
                $('#divIndentItemsDetails').html('').hide;
            }
            
        });
    }


    var rejectIndentItem = function () {
        var divRejectReason = $('#divRejectReason');
        var data = {
            indentID: $.trim(divRejectReason.find('#lblRejectItemID').attr('indentNo')),
            itemID: $.trim(divRejectReason.find('#lblRejectItemID').text()),
            rejectReason: $.trim(divRejectReason.find('textarea').val()),
        }
        if (String.isNullOrEmpty(data.rejectReason)) {
            modelAlert('Please Enter Reject Reason', function () {
                divRejectReason.find('textarea').focus();
            });
            return false;
        }

        serverCall('Pharmacy.asmx/RejectIndentItem', data, function (response) {
            var responseData = JSON.parse(response);
            if (responseData.status) {
                divRejectReason.hideModel();
                if (!String.isNullOrEmpty(data.itemID))
                    $('#divIndentItemsDetails').find('.' + $.trim(data.itemID)).remove();
                else
                    getPatientIndents(function () { }, 0);

            }
        });
    }


    var onIndentReject = function (elem) {
        var row = $(elem).closest('tr');
        var data = {
            itemID: $.trim(row.find('#tdItemID').text()),
            indentNo: $.trim(row.find('#tdIndentNo').text()),
            itemName: $.trim(row.find('#tdItemName').text()),
        }
        var divRejectReason = $('#divRejectReason');
        divRejectReason.find('#lblRejectItemID').text(data.itemID);
        divRejectReason.find('#lblRejectItemID').attr('indentNo', data.indentNo);
        divRejectReason.find('textarea').val('');
        if (String.isNullOrEmpty(data.itemID))
            divRejectReason.find('.patientInfo').html('<b style="color:black">Indent ID:</b> ' + data.indentNo);
        else
            divRejectReason.find('.patientInfo').html('<b style="color:black">Item:</b> ' + data.itemName);
        divRejectReason.showModel();
    }


    var onScanBarcode = function (e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) {
            var data = {
                deptLedgerNo: $.trim($('#lblDeptLedgerNo').text()),
                barcodeNumber: $.trim(e.target.value)
            }
            if (data.batchNumber == '')
                return false;
            getItemByBarCode(data, function (data) {
                e.target.value = '';
                addStockDetails(data, e);
            });
        }
    }

    var getItemByBarCode = function (data, callback) {
        serverCall('Pharmacy.asmx/GetItemByBarCode', data, function (response) {
            var responseData = JSON.parse(response);
            if (responseData.length > 0)
                callback(responseData[0]);
        });
    }

    var addStockDetails = function (stock, e) {
        var item = $.trim(stock.ItemID);
        var divIndentItemsDetails = $('#divIndentItemsDetails');
        var stocks = $(divIndentItemsDetails.find('.' + item));
        var isManualAdded = $(divIndentItemsDetails.find('.manualStock.' + item));
        var isAlreadyStockAdded = isManualAdded.find('#tdBatchNumber').filter(function () { return $.trim(this.textContent) == stock.BatchNumber });
        if (isAlreadyStockAdded.length > 0) {
            modelAlert('Stock Already Added', function () {
                $(e.target).focus();
            });
            return false;
        }

        var requestedQuantity = Number(stocks.find('#tdReqQty').text());
        var issueQuantity = 0;
        var totalIssuedQuantity = 0;
        isManualAdded.find('#txtIssueQuantity').filter(function () { totalIssuedQuantity = (Number(this.value) + totalIssuedQuantity) });
        issueQuantity = (stock.AvlQty > (requestedQuantity - totalIssuedQuantity)) ? (requestedQuantity - totalIssuedQuantity) : stock.AvlQty;
        if (stocks.length > 0) {
            $(stocks).not(':first').not('.manualStock').remove();

            var firstStock = $(stocks[0]);
            if (isManualAdded.length > 0)
                firstStock = firstStock.clone();

            //var requestedQuantity = Number(firstStock.find('#tdReqQty').text());
            firstStock.find('#tdStockId').text(stock.stockid);
            firstStock.find('#tdAvlQty').text(stock.AvlQty);
            firstStock.find('#tdBatchNumber').text(stock.BatchNumber);
            firstStock.find('#tdMedExpiryDate').text(stock.MedExpiryDate);
            firstStock.find('#tdMRP').text(stock.MRP);
            firstStock.find('#txtIssueQuantity').val(issueQuantity);
            if (isManualAdded.length > 0) {
                $(firstStock[0]).find('td:eq(1)').remove();
                $(firstStock[0]).find('td:last img').remove();
                $(firstStock[0]).find('#tdReqQty').css({ 'display': 'none' });
                $(firstStock[0]).find('td:eq(0)').replaceWith('<td colspan="3" class="GridViewLabItemStyle" style="border-top-color:transparent;border-bottom-color: transparent"></td>');
                var _temp = $(firstStock[0].outerHTML).insertAfter($(stocks[stocks.length - 1]));
                _temp.find('#txtIssueQuantity').val(issueQuantity);
            }


            firstStock.addClass('manualStock');
            $(stocks).not(':first').find('td:first').css({ 'border-top-color': 'transparent', 'border-bottom-color': 'transparent' });
            divIndentItemsDetails.find('table tbody tr:last td:first').removeAttr('style');
        }
    }

    var validateIndentIssueItems = function (callback) {
        var indentItemsDetails = $('#divIndentItemsDetails tbody tr');
        var indentItemsSummary = [];
        for (var i = 0; i < indentItemsDetails.length; i++) {

            var _temp = {
                itemID: $.trim($(indentItemsDetails[i]).find('#tdItemID').text()),
                quantity: Number($(indentItemsDetails[i]).find('#txtIssueQuantity').val()),
            };

            var isAlreadyExit = indentItemsSummary.filter(function (m, t) { return m.itemID == _temp.itemID });
            if (isAlreadyExit.length > 0) {
                isAlreadyExit[0].quantity = (isAlreadyExit[0].quantity + _temp.quantity);
            }
            else {
                _temp.reqQty = Number($(indentItemsDetails[i]).find('#tdReqQty').text());
                _temp.issued = Number($(indentItemsDetails[i]).find('#td2').text());
                _temp.reqQty = (_temp.reqQty - _temp.issued);
                _temp.itemName = $.trim($(indentItemsDetails[i]).find('#tdItemName').text());
                _temp.CanRefil = $.trim($(indentItemsDetails[i]).find('#tdCanRefil').text());

                indentItemsSummary.push(_temp);
            }
        }


        var _d = indentItemsSummary.filter(function (p) {
            return p.quantity > p.reqQty && p.CanRefil==0;
        });

        callback();

        //if (_d.length > 0) {
        //    modelAlert('Issue Quantity Exceeds.<br/><span class="patientInfo">' + _d[0].itemName + '</span>', function () { });
        //}
        //else
        //    callback();

    }

    var addIndentItems = function () {
        validateIndentIssueItems(function () {
            clearSelectedMedicines(function () {
                var selectedStocks = $('#divIndentItemsDetails tbody tr #txtIssueQuantity').filter(function () { return Number(this.value) > 0 }).closest('tr');
                var stocks = [];
                var stockDetails = [];
                var patientType = $('input[type=radio][name=rdoPatientType]:checked').val();
                var panelId = (patientType == '1' || patientType == '3') ? $('#ddlPanelCompany').val() : '<%=Resources.Resource.DefaultPanelID%>';

                if ($("#lblIsPharmacyItemAdded").val() == 0) {
                    PharmacyCharges($.trim($('#lblDeptLedgerNo').text().trim()), function (callback) {

                    });
                }


                $(selectedStocks).each(function () {
                    var data = {
                        ItemID: $.trim($(this).find('#tdItemID').text()),
                        tranferQty: $.trim($(this).find('#txtIssueQuantity').val()),
                        StockID: $.trim($(this).find('#tdStockId').text()),
                        indentNo: $.trim($(this).find('#tdIndentNo').text()),
                        DeptLedgerNo: $.trim($('#lblDeptLedgerNo').text().trim()),
                        patientMedicine: Number($.trim($(this).find('#tdPatientMedicine').text())),
                        draftDetailID: Number($.trim($(this).find('#tddraftDetailID').text())),
                    }

                    var avilableQuantity = $.trim($('#tdAvlQty').text().trim());
                   
                    $(btnadd).attr('disabled', 'disabled').val('Submitting...');
                    stocks.push(serverCall('Services/WebService.asmx/addItem', data, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.length > 0)
                            stockDetails.push({ stockDetails: responseData[0], data: data, quantity: data.tranferQty });
                    }, { isReturn: true }));
                });

                $.when.apply(null, stocks).progress(function () {
                    $modelBlockUI();
                }).done(function (d) {
                    $(stockDetails).each(function () {
                        this.stockDetails.indentNo = this.data.indentNo;
                        this.stockDetails.patientMedicine = this.data.patientMedicine;
                        this.stockDetails.draftDetailID = this.data.draftDetailID;
                        addNewRow(this.stockDetails, this.quantity, 0, 0, 1, function () { calculateTotal(function (total) { }); });
                    });
                    calculateTotal(function (total) {
                        $('#divModelMedicineIndentIssue').hideModel();
                    });
                    $modelUnBlockUI();
                });
            });
        });
    }

</script>
<div id="divRejectReason" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divRejectReason" aria-hidden="true">×</button>
                    <h4 class="modal-title">Reject Reason</h4>
                    <label indentNo="" style="display:none" id="lblRejectItemID"></label>
                </div>
                <div class="modal-body">
                    <div class="row">
                       <div class="col-md-24 patientInfo"></div>
                    </div>
                     <div class="row">
                         <div class="col-md-24">
                              <textarea cols="" rows="" style="height:82px;min-width:285px" ></textarea>
                          </div>
                      </div>
                </div>
                  <div class="modal-footer">
                         <button type="button" onclick="rejectIndentItem()">Reject</button>
                         <button type="button" data-dismiss="divRejectReason">Close</button>
                </div>
            </div>
        </div>
    </div>



    <div id="divDraftsSearch" class="modal fade" >
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divDraftsSearch" aria-hidden="true">×</button>
                <h4 class="modal-title">Drafts</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-24">
                        <div style="height:200px;overflow:auto" id="divdrafts">
                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" data-dismiss="divDraftsSearch" onclick="">Close</button>
            </div>
        </div>
    </div>
</div>
    <div id="divAllPendingIndentSearch" class="modal fade" >
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1000px; ">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divAllPendingIndentSearch" aria-hidden="true">×</button>
                <h4 class="modal-title">Pending Indent`s</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                      <div class="col-md-24">
                    <div class="col-md-4">

                        <label class="pull-left"><select id="ddlsearchby">
                            <option value="id.TransactionID">IPD No.</option>
                            <option value="id.PatientID">UHID</option>
                            <option value="emg.EmergencyNo">Emergency No.</option>
                            <option value="id.IndentNo">Indent No. Wise</option>
                            <option value="id.IndentNo">Indent No. Wise</option>
                            <option value="id.ItemName">Item Wise</option>
                               </select></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="text" id="txtsearchtype" placeholder="Enter No." onkeyup="if(event.keyCode==13){getPendingIndentDetails(this);};" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Status</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-3">
                        <select id="ddlstatus" onchange="getPendingIndentDetails(this);">
                            <option value="'OPEN'">OPEN</option>
                            <option value="'PARTIAL'">PARTIAL</option>
                            <option value="'OPEN','PARTIAL'">OPEN & Partial</option>
                            <option value="'CLOSE'">CLOSE</option>
                            <option value="'REJECT'">REJECT</option>
                            <option value="ALL">ALL</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Department</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                      <asp:ListBox ID="lstdepartment" runat="server" ClientIDMode="Static" CssClass="multiselect" onchange="OnItemchange()"></asp:ListBox>
                    </div>
                </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">From Date</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtPenIndentFrom" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Indent From" onchange="getPendingIndentDetails(this);"></asp:TextBox>
                           <cc1:calendarextender ID="Calendarextender3" TargetControlID="txtPenIndentFrom" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPenIndentTo" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Indent To" onchange="getPendingIndentDetails(this);" ></asp:TextBox>
                           <cc1:calendarextender ID="Calendarextender4" TargetControlID="txtPenIndentTo" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender>
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-3"></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div style="height:400px;overflow:auto" id="divAllPendingIndent">
                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" data-dismiss="divAllPendingIndentSearch" onclick="">Close</button>
            </div>
        </div>
    </div>
</div>

     <div id="divClinicalTrialRemarks" class="modal fade" >
    <div class="modal-dialog">
        <div class="modal-content" style="width: 700px">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divClinicalTrialRemarks" aria-hidden="true">×</button>
                <h4 class="modal-title">Clinical Trial Remarks(<span id="spnClinicalItemName" class="patientInfo" ></span>)</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-24">
                        <div style="height:200px;overflow:auto" id="divClinicalTrialListItemWise">
                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" data-dismiss="divClinicalTrialRemarks" onclick="">Close</button>
            </div>
        </div>
    </div>
</div>

    <script id="templateDrafts" type="text/html">
    <table class="FixedTables" id="Table2" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr5">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Mobile</th>
            
            <th class="GridViewHeaderStyle" scope="col" >Address</th>
            <th class="GridViewHeaderStyle" scope="col" >Total Items</th>
            <th class="GridViewHeaderStyle" scope="col" ></th>
            <th class="GridViewHeaderStyle" scope="col" ></th>
        </tr>
         </thead><tbody>
        <#       
        var dataLength=draftDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = draftDetails[j];
        #>
                    <tr  id="Tr6">
                       
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle" id="td3" style="text-align:center"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="td13" style="text-align:center"><#=objRow.ContactNo#></td>
            
                    <td class="GridViewLabItemStyle" id="td15" ><#=objRow.Address#></td>       
                    <td class="GridViewLabItemStyle" id="td16" style="text-align:center"><#=objRow.TotalItems#></td>
                    <td class="GridViewLabItemStyle" id="td18" style="display:none"><#=objRow.ID#></td>
                    <td style="text-align:center" class="GridViewLabItemStyle">
                     <img alt="" src="../../Images/Post.gif" class="imgPlus"  style="cursor:pointer" onclick="onSelectDraft(this)"  />
                    </td>
                        <td style="text-align:center" class="GridViewLabItemStyle">
                        <img  alt="" onclick="onCloseDraft(this)" src="../../Images/Delete.gif" style="cursor:pointer;" "/>
                    </td>
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>

    <script id="templateClinicalDetails" type="text/html">
    <table class="FixedTables" id="tablePatientClinicalDetails" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr10">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;" >Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Remarks</th>
        </tr>
         </thead><tbody>
        <#       
        var dataLength=ClinicalDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ClinicalDetails[j];
        #>
                    <tr  id="Tr11">
                       
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle" id="td21" style="text-align:center;width:150px;"><#=objRow.EntryDateTime#></td>
                    <td class="GridViewLabItemStyle" id="td23" ><#=objRow.Remarks#></td> 
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>
    <script type="text/javascript">

        var getDrafts = function () {
            serverCall('OPDPharmacyIssue.aspx/GetDrafts', {}, function (response) {
                draftDetails = JSON.parse(response);
                var _html = $('#templateDrafts').parseTemplate(draftDetails);
                $('#divdrafts').html(_html);
                $('#divDraftsSearch').showModel();
            });
        }

        //devendra
        var getPendingIndentDetails = function () {
            data = {
                deptLedgerNo: $.trim($('#lblDeptLedgerNo').text()),
                searchby: $('#ddlsearchby').val(),
                searchtype: $.trim($('#txtsearchtype').val()),
                status: $('#ddlstatus').val(),
                department: Getmultiselectvalue($('#lstdepartment')),
                FromDate: $('#txtPenIndentFrom').val(),
                ToDate: $('#txtPenIndentTo').val()
            }
            serverCall('OPDPharmacyIssue.aspx/GetAllPendingIndents', data, function (response) {
                allPatientIndentDetails = JSON.parse(response);
                var _html = $('#templateAllPatientIndents').parseTemplate(allPatientIndentDetails);
                $('#divAllPendingIndent').html(_html);
                $('#divAllPendingIndentSearch').showModel();
            });
        }

        var getIndentItemsDetailsWithPatient = function (rowId, indentNo, ipdNo, EMGNo) {
            $('#rdoHospitalPatient').prop('checked', true);
            changePatientType(1);
            $('#txtIPDNO').val(ipdNo);
            $('#txtEMGNo').val(EMGNo);
            $('#txtIndentID').val(indentNo);
            $getPatientDetails(null, function (response) {
                $bindPatientDetails(response, function () {
                    searchDefaultIndentPrescriptions(response, function () {
                        showPrescribedMedicineModel(1, function () {
                        });
                    });
                });
            });
        }

        var viewClinicalMedicine = function (el) {
            $("#spnClinicalItemName").text('Item Name : ' + $(el).closest('tr').find('#tdItemName').text());
            data = {
                ItemID: $(el).closest('tr').find('#tdItemID').text(),
                PatientId: $('#lblMrNo').text()
            }
            serverCall('OPDPharmacyIssue.aspx/ClinicalTrial', data, function (response) {
                ClinicalDetails = JSON.parse(response);
                var _html = $('#templateClinicalDetails').parseTemplate(ClinicalDetails);
                $('#divClinicalTrialListItemWise').html(_html);
                $('#divClinicalTrialRemarks').showModel();
            });
        }

        var onSelectDraft = function (el) {
            var row = $(el).closest('tr');
            var draftID = Number(row.find('#td18').text());
            $("#lblDraftID").text(draftID);
            serverCall('OPDPharmacyIssue.aspx/GetDraftDetails', { draftID: draftID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var _temp = responseData[0];
                    if (!String.isNullOrEmpty((_temp.PatientID))) {
                        $getPatientDetails(_temp.PatientID, function (response) {
                            changePatientType(1);
                            $('#rdoHospitalPatient').attr('checked', true);
                            $bindPatientDetails(response, function () {
                                searchDefaultIndentPrescriptions(response, function () {
                                    getPatientIndents(function (details) {
                                        var divModelMedicineIndentIssue = $('#divModelMedicineIndentIssue');
                                        divModelMedicineIndentIssue.find('.searchCriteria').hide();
                                        divModelMedicineIndentIssue.find('.modal-title').text('Demand Detail`s');
                                        divModelMedicineIndentIssue.showModel();
                                        var divDraftsSearch = $('#divDraftsSearch');
                                        divDraftsSearch.hideModel();
                                    }, draftID);
                                });
                            });
                        });
                    }
                    else {
                        changePatientType(2);
                        $('#rdoGeneral').attr('checked', true);
                        $bindGeneralPatientDetails(_temp, function () {
                            searchDefaultIndentPrescriptions(response, function () {
                                getPatientIndents(function (details) {
                                    var divModelMedicineIndentIssue = $('#divModelMedicineIndentIssue');
                                    divModelMedicineIndentIssue.find('.searchCriteria').hide();
                                    divModelMedicineIndentIssue.find('.modal-title').text('Demand Detail`s');
                                    divModelMedicineIndentIssue.showModel();
                                    var divDraftsSearch = $('#divDraftsSearch');
                                    divDraftsSearch.hideModel();
                                }, draftID);
                            });
                        });
                    }
                }
            });
        }






        //var userInteractionPrompt = function (title, message, defaultText, OkButtonText, CloseButtonText, callback) {
        //    var _divUserInteractionPrompt = $('#divUserInteractionPrompt');

        //    _divUserInteractionPrompt.find('.modal-title').html(title);
        //    // _divUserInteractionPrompt.find('.patientInfo b').html(message);
        //    _divUserInteractionPrompt.find('#promptConfirmOkButtonText').val(OkButtonText).click(function () {
        //        callback({
        //            status: true,
        //            promptValue: $.trim(_divUserInteractionPrompt.find('#txtPromtvalue').val()),
        //            promptText: $.trim(_divUserInteractionPrompt.find('#txtPromtText').val())
        //        });
        //    });
        //    _divUserInteractionPrompt.find('#promptConfirmCloseButtonText').val(CloseButtonText).click(function () {
        //        _divUserInteractionPrompt.closeModel();
        //    });
        //    _divUserInteractionPrompt.showModel();
        //    _divUserInteractionPrompt.find('#txtPromtText').val(defaultText).focus();
        //    var _txtPromt = _divUserInteractionPrompt.find('#txtPromtvalue').val('');
        //    return {
        //        prompt: _divUserInteractionPrompt, input: _txtPromt, close: function () {
        //            _divUserInteractionPrompt.hideModel();
        //        }
        //    };
        //}
















    </script>




     <div id="divUserInteractionPrompt" class="modal fade">
            <div class="modal-dialog">
                <div style="min-width:250px" class="modal-content">
                    <div class="modal-header"><h4 style="color:red" class="modal-title">Validate User !!!</h4></div>
                    <div style="text-align: center;margin-left: 20px;margin-right: 20px;" class="modal-body">
                        <p style="font-weight: bold;" id="promtMessage"></p><div class="row"> 
                            <div class="col-md-24 patientInfo"> <b></b> </div> </div>
                         <div class="row"> 
                             <div class="col-md-8 patientInfo"> 
                                  <label class="pull-left"><b>UserName </b> </label>
			                      <b class="pull-right">:</b>
                             </div>
                              <div class="col-md-16 patientInfo"> 
                                  <input id="txtPromtText" style="text-align: center;font-weight:bold" type="text"/> 
                              </div>
                         </div>

                        <div class="row"> 
                             <div class="col-md-8 patientInfo"> 
                                  <label class="pull-left"><b>Password </b>   </label>
			                      <b class="pull-right">:</b>
                             </div>
                              <div class="col-md-16 patientInfo"> 
                                  <input id="txtPromtvalue" style="text-align: center;font-weight:bold" type="password"/> 
                              </div>
                         </div>
                     </div>
                   <div style="text-align:center" class="modal-footer">
                       <input id="promptConfirmOkButtonText"  class="save btnAction" type="button" value="Sumit" onclick="onSavePharmacyBill($('.btnAction'), $('#btnSave'))" />
                       <input id="promptConfirmCloseButtonText" class="save"  type="button" value="Cancel" onclick="onCancelValidateUserModel()" />
                   </div>
                </div>
            </div>
        </div>
     <div id="ShortQtyModel" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 500px">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$('#ShortQtyModel').hideModel();"   aria-hidden="true">&times;</button>
                <span id="SpSIDMsg" style="font-size: 12px; color: red; font-weight: bold;"></span><br />
                <h4 class="modal-title">Create Purchase Request </h4>
            </div>
            <div class="modal-body">
                 <div class="row">
                     <div  class="col-md-6">
                          <label class="pull-left">  Item Name    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-18">
                           <label id="lblItemID" class="pull-left" style="display:none"></label>
                     <label id="lblItemName" class="pull-left"></label>
                     </div>             
                 </div>
                  <div class="row">
                     <div  class="col-md-6">
                          <label class="pull-left">  SubCategory    </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-18">
                         <asp:Label runat="server" ID="lblDate" ClientIDMode="Static"></asp:Label>
                            <label id="lblConversionFactor" class="pull-left" style="display:none">0</label>
                              <label id="SubCatID" class="pull-left" style="display:none"></label>
                                   <label id="SubCatName" class="pull-left"></label>
                     </div>
                       </div>
                          <div class="row">
                     <div  class="col-md-6">
                           <label class="pull-left"> Unit Type   </label>
                           <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-18">
                           <label id="lblUnitType" class="pull-left"></label>
                     </div>
                 </div>

                  <div class="row">
                     <div  class="col-md-6">
                          <label class="pull-left">Short Qty </label>
                          <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-18">
                          <input type="text" id="txtShortQty" style="width:30%" autocomplete="off" onlynumber="10"  max-value="1000" decimalplace="4"  value="1"/>
                     </div>                 
                 </div>                  
            </div>
            <div class="modal-footer">
                   <div style="text-align:center" class="row">
                       
                       <button type="button" id="btnSaveShortQ"  onclick="CreatePRByShortQty(this)">Save</button>&nbsp;&nbsp;
                        <button type="button"  onclick="$('#ShortQtyModel').hideModel();">Close</button>
                </div>               
            </div>
        </div>
    </div>
</div>

    <script type="text/javascript">
        $(function () {
            $('.multiselect').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false, width: 100
            });
            $(".multiselect").width('100%');
            $bindDepartment(function () { });
        });
        $bindDepartment = function (callBack) {
            var DeptID = $.trim($('#lblDeptLedgerNo').text());
            var CentreID = '<%=Session["CentreID"].ToString()%>';
            serverCall('Services/CommonService.asmx/BindDepartmentFrom', { DeptID: DeptID, CentreID: CentreID }, function (response) {
                if (response != "") {
                    var $lstdepartment = $('#lstdepartment');
                    $lstdepartment.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
                }
                else {
                    modelAlert('No Record Found');
                }
                callBack(true);
            });
        }
        function Getmultiselectvalue(controlvalue) {
            var DepartmentID = "";
            var input = "";
            var SelectedLaength = $(controlvalue).multipleSelect("getSelects").join().split(',').length;
            if (SelectedLaength > 1)
                DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
            else {
                if ($(controlvalue).val() != null) {
                    DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
                }
            }
            return DepartmentID;
        }
        $.fn.listbox = function (params) {
            try {
                var elem = this.empty();
                if (params.defaultValue != null || params.defaultValue != '')
                    $.each(params.data, function (index, data) {
                        var dataAttr = {};
                        var option = $(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data', JSON.stringify(dataAttr));
                        $(params.customAttr).each(function (i, d) { $(option).attr(d, data[d]); });
                        elem.append(option);

                    });
                if (params.selectedValue != null || params.selectedValue != '' || params.selectedValue != undefined)
                    $(elem).val(params.selectedValue);


                if (params.isSearchAble || params.isSearchable) {
                    $(elem).multipleSelect({
                        includeSelectAllOption: true,selectAll:true,
                        filter: true, keepOpen: false,
                    });
                }
            } catch (e) {
                console.error(e.stack);
            }
        };
        function OnItemchange() {
            getPendingIndentDetails();
         }
    </script>
    
<div id="divAddReferDoctor"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:550px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddReferDoctor" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add Refer Doctor</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-6">
							   <label class="pull-left">Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div class="col-md-6">
								   <select id="ddlTitleRefDoc" style="border-bottom-color:red;border-bottom-width:2px"  title="Select Title">
							<option value="Dr."  >Dr.</option>
							<option value="Prof.Dr."  >Prof Dr.</option>
							  </select>
						  </div>
						  <div class="col-md-12">
							   <input type="text" autocomplete="off" style="border-bottom-color:red;border-bottom-width:2px" onlyText="50" maxlength="50" allowCharsCode="40,41"   id="txtRefDocName" style="text-transform:uppercase"   maxlength="50"  title="Enter Refer Doctor Name" />
						  </div>
					</div>
					<div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Address   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							   <textarea id="txtRefDocAddress"   maxlength="100" title="Enter Refer Doctor Address"></textarea>
						  </div>
					</div>
					 <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Contact No   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-12" >
							  <input type="text" autocomplete="off"  id="txtRefDocPhoneNo" onkeyup="previewCountDigit(event,function(e){});" allow   maxlength="10" onlynumber="10"   data-title="Enter Refer Doctor Contact No" />    
						  </div>
					</div>
                     <div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Pro Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-12" >
							  <select class="required" id="ddlReferDoctorPro"></select>
						  </div>
					</div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveReferDoctor()">Save</button>
						 <button type="button"  data-dismiss="divAddReferDoctor" >Close</button>
				</div>
			</div>
		</div>
	</div>
    <script type="text/javascript">
        $addNewDoctorReferModel = function () {
            bindReferDoctorPRO(function () {
                $('#divAddReferDoctor input[type=text],#divAddReferDoctor textarea').val('')
                $('#divAddReferDoctor').showModel();
            });
        }
        var bindReferDoctorPRO = function (callback) {
            getPRODetails('', function (response) {
                $ddlReferDoctorPro = $('#ddlReferDoctorPro');
                $ddlReferDoctorPro.bindDropDown({ defaultValue: 'Select', data: (response), valueField: 'Pro_ID', textField: 'ProName', isSearchAble: true });
                callback($ddlReferDoctorPro.val());
            });
        }
        var getPRODetails = function (referDoctorID, callback) {
            serverCall('../Common/CommonService.asmx/bindPRO', { referDoctorID: referDoctorID }, function (response) {
                callback(JSON.parse(response));
            });
        }
        $saveReferDoctor = function (referDoctorDetails) {
            var referDoctorDetails = {
                Title: $.trim($('#ddlTitleRefDoc').val()),
                Name: $.trim($('#txtRefDocName').val()),
                HouseNo: $.trim($('#txtRefDocAddress').val()),
                Mobile: $.trim($('#txtRefDocPhoneNo').val()),
                proID: $.trim($('#ddlReferDoctorPro').val())
            };


            if (String.isNullOrEmpty(referDoctorDetails.Name)) {
                modelAlert('Enter Doctor Name.', function () {
                    $('#txtRefDocName').focus();
                });
                return false;
            }

            if (Number(referDoctorDetails.proID) == 0) {
                modelAlert('Select PRO Name.', function () {
                    $('#ddlReferDoctorPro').focus();
                });
                return false;
            }


            serverCall('../Common/CommonService.asmx/RefDoc', { Title: referDoctorDetails.Title, Name: referDoctorDetails.Name, HouseNo: referDoctorDetails.HouseNo, Mobile: referDoctorDetails.Mobile, proID: referDoctorDetails.proID }, function (response) {
                $responseData = parseInt(response);
                if ($responseData == '0')
                    modelAlert('Refer Doctor Already Exist');
                else if ($responseData == '1') {
                    $('#divAddReferDoctor').closeModel();
                    modelAlert('Refer Doctor Saved Successfully', function (response) {
                        bindRefferDoctor(function (response) { });
                    });
                }
                else
                    modelAlert('Error occurred, Please contact administrator');
            });


        }
        var ShowShortQtyModel = function (btnSave) {
            var txtMedicineSearch = $('#txtMedicineSearch');
            var grid = txtMedicineSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            if (String.isNullOrEmpty(selectedRow)) {
                modelAlert('Please Select Item First', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtMedicineSearch.combogrid('reset');
                });
                return;
            }
            //  var stockID = $.trim(selectedRow.stockid);
            // var avilableQuantity = selectedRow.AvlQty;
            $('#lblItemID').text(selectedRow.ItemID.split('#')[0]);
            $('#lblItemName').text($.trim(selectedRow.ItemName));
            $('#SubCatName').text($.trim(selectedRow.SubCategoryName));
            $('#SubCatID').text($.trim(selectedRow.SubCategoryID));
            $('#lblUnitType').text($.trim(selectedRow.UnitType));
            $('#lblConversionFactor').text(selectedRow.ConversionFactor);
            $('#ShortQtyModel').showModel();
            $('#btnSaveShortQ').attr('disabled', false).val('Save');
        }
        var CreatePRByShortQty = function (btnSave) {
            if ($('#txtShortQty').val().trim() == '' || $('#txtShortQty').val().trim() == '0') {
                modelAlert('Enter Valid Qty.');
                return false;
            }
            var ItemDetail = [];
            ItemDetail.push({
                ConversionFactor: $('#lblConversionFactor').text().trim(),
                CurrentStock: 0,
                ID: 0,
                IndentNumber: "",
                IndentQuantity: 0,
                ItemID: $('#lblItemID').text().trim(),
                ItemName: $('#lblItemName').text().trim(),
                Maxlevel: 0,
                Minlevel: 0,
                Narration: "Short Item Qty.",
                NetQuantity: $('#txtShortQty').val().trim(),
                PoStock: 0,
                PurchaseUnit: $('#lblUnitType').text().trim(),
                Quantity: $('#txtShortQty').val().trim(),
                SalesQuantity: 0,
                SubCategoryID: $('#SubCatID').text().trim(),
            });
            var data = { ItemDetails: ItemDetail };
            data.storeId = 'STO00001';
            data.narration = 'Short Item Qty.';
            data.requestType = 'Urgent';
            data.requisitionDate = $('#lblDate').text().trim();
            data.issueToDepartment = $('#lblDeptLedgerNo').text().trim();
            data.issueToCenterID = '1';
            data.purchaseRequestNo = '';

            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('Services/CreatePurchaseRequest.asmx/Save', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.message, function () {
                    if (responseData.status) {
                        modelConfirmation('Print Confirmation ?', 'Do you want to print', 'Yes Print', 'Close', function (response) {
                            if (response)
                                window.open('../Purchase/PRReport.aspx?PRNumber=' + responseData.PurchaseRequestNumber);
                        });
                        $('#txtShortQty').val('1')
                        $('#ShortQtyModel').hideModel();
                    }
                    else {
                        $(btnSave).attr('disabled', false).val(btnValue);
                    }
                });
            });
        }
      </script>

  
    
    
    <div id="divMedicineSearch" class="modal fade" >
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1000px">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divMedicineSearch" aria-hidden="true">×</button>
                <h4 class="modal-title">Patient Medicine</h4>
            </div>
            <div class="modal-body">
                <div class="row">
                      <div class="row">
                    <div class="col-md-3"> 
                        <label class="pull-left"> UHID</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtfolderno" placeholder="Enter UHID." onkeyup="if(event.keyCode==13){MedicineSearchPatient(this);};" />
                    </div>
                      
                
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtfdate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Indent From" onchange="MedicineSearchPatient(this);"></asp:TextBox>
                           <cc1:calendarextender ID="Calendarextender5" TargetControlID="txtfdate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txttdate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Indent To" onchange="MedicineSearchPatient(this);" ></asp:TextBox>
                           <cc1:calendarextender ID="Calendarextender6" TargetControlID="txttdate" Format="dd-MMM-yyyy" runat="server" ></cc1:calendarextender>
                        </div> 
                         
                         
                    </div>
                    <div class="row">
                        <div class="col-md-3"> 
                        <label class="pull-left">Status</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                         
                        <select id="ddlstatusmedicine" onchange="MedicineSearchPatient(this);">
                         <option value="ALL">ALL</option>
						 <option value="Pending" selected="selected">Pending</option>
                         <%--<option value="In-Complete">Partial</option>--%>
                         <option value="Complete">Issued</option>
                     </select>
                    </div>
                    <div class="col-md-3"> 
                        <label class="pull-left">Role</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlMRole" onchange="MedicineSearchPatient(this);" >
 
                        </select>
                    </div>
                        </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div style="height:300px;overflow:auto" id="divMedicineSearchbind">
                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" data-dismiss="divMedicineSearch" onclick="">Close</button>
            </div>
        </div>
    </div>
</div>
 
    
    
    
    <script id="templatemedicinesearch" type="text/html">
    <table class="FixedTables" id="tbltemplatemedicinesearch" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr12">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
             <th class="GridViewHeaderStyle" scope="col" >Prescription On</th>            
            <th class="GridViewHeaderStyle" scope="col" >Prescription By</th> 
               
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
            <th class="GridViewHeaderStyle" scope="col" >Patient Name</th>		
             <th class="GridViewHeaderStyle" scope="col" >Panel Name</th>		
                   	   	 
            <th class="GridViewHeaderStyle" scope="col" >Select</th>           	 
        </tr>
         </thead><tbody>
        <#       
        var dataLength=allPatientIndentDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = allPatientIndentDetails[j];
        #>
                    <tr id="Tr13">
                        
                    <td class="GridViewLabItemStyle" style="width:10px"> <#=j+1#></td> 
                    <td class="GridViewLabItemStyle" id="td33" style="text-align:center"><#=objRow.DATE#> </td>
                    <td class="GridViewLabItemStyle" id="tddoctor"  style="text-align:center"><#=objRow.NAME#></td>
                    <td class="GridViewLabItemStyle" id="tdfolderno" style="text-align:center"><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdpname" style="text-align:center"><#=objRow.PName#></td>
                  <td class="GridViewLabItemStyle" id="tdPanelName" style="text-align:center"><#=objRow.PanelName#></td>
                  
                    <td style="text-align:center" class="GridViewLabItemStyle">
                  <# if(objRow.STATUS!="Issued"){#>
                     <img alt="" src="../../Images/Post.gif" class="imgPlus"  style="cursor:pointer" onclick="showPrescribedMedicineModelDiv(0,'<#=objRow.PatientID#>','<#=objRow.App_ID#>','<#=objRow.IsIPDData#>','<#=objRow.TransactionID#>');" />
                        <#}#>
                    </td>
               </tr>     
             
        <#}        
        #>   
       </tbody>   
     </table>    
</script>

    
    
    
    
    
    
    
    
      <script type="text/javascript">

          var MedicineSearchPatient = function () {
               data = {
                   FolderNo: $('#txtfolderno').val(),
                   DoctorID: 0,
                   FromDate: $('#txtfdate').val(),
                   ToDate: $('#txttdate').val(),
                   Status: $('#ddlstatusmedicine').val(),
                   RoleId: $('#ddlMRole').val(),
               }
              $('#txtIndentFrom').val($('#txtfdate').val())
              $('#txtIndentTo').val($('#txttdate').val())
              serverCall('OPDPharmacyIssue.aspx/MedicineSearchPatient', data, function (response) {
                  allPatientIndentDetails = JSON.parse(response);
                  if (allPatientIndentDetails.length > 0) {
                      var _html = $('#templatemedicinesearch').parseTemplate(allPatientIndentDetails);
                      $('#divMedicineSearchbind').html(_html);
                  }
                  else
                      $('#divMedicineSearchbind').html('');

                $('#divMedicineSearch').showModel();
            });
        }


        var showPrescribedMedicineModelDiv = function (data, PatientID, App_ID, IsIPDData, Transaction_ID) {
            $('#lblTransaction_ID').text(Transaction_ID);
            $('#lblIsIPDData').text(IsIPDData);
            $('#lblApp_ID').text(App_ID);

            $('#txtIndentID').val(PatientID);
            $('#txtPatientId').val(PatientID);
            $('#divMedicineSearch').hide();
            $getPatientDetails(null, function (response) {
                $bindPatientDetails(response, function () {
                    searchDefaultIndentPrescriptions(response, function () {
                          getPatientIndents(function () {

                              if ($('#Table1 tbody tr').length == 1) {
                                  document.getElementById("tbl1AutoClick").click();
                                  
                              }
                          }, 0);

                    });
                });
            });
            showPrescribedMedicineModel(1);
            $('#txtIndentID').val(PatientID);
            $('#btnprintmedicine').show();
        }

        function PharmacyCharges(deptLedgerNo) {
            

            var pharmacy = '<%= Resources.Resource.PharmacyChargesNotAllowedTo %>';
            var not_allowed = pharmacy.split('#');

              if (not_allowed.indexOf('<%= Util.GetInt( Session["RoleID"].ToString()) %>') == -1) {

                var PharmacyChargesItemId = '<%= Resources.Resource.PharmacyCharges_ItemId %>';
                getItemDetails(PharmacyChargesItemId, 1, 0, 0, 0, deptLedgerNo, function (response) {
                    response[0].patientMedicine = '0';
                    response[0].indentNo = '';
                    response[0].draftDetailID = '0';

                    addNewRow(response[0], 1, 0, 0, 0, function () {
                        calculateTotal(function (total) {
                            $("#lblIsPharmacyItemAdded").val(1)
                        });
                    });
                    //addNewRow(response[0], 1, 0, 0, 0, function () { });
                    //calculateTotal(function (total) {

                    //});

            });


            }




        }


          function bindRole() {
              var $ddlRole = $('#ddlMRole');
              var RoleId = '<%=Session["RoleId"].ToString()%>';
               serverCall('OPDPharmacyIssue.aspx/BindRole', {}, function (response) {
                   $ddlRole.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'RoleId', textField: 'Name', isSearchAble: true, selectedValue: RoleId });
               });
              
             // $('#ddlMRole').val(RoleId).chosen('destroy').chosen({ width: '100%' });

        }

        var onOpdMedReject = function (elem) {
            var row = $(elem).closest('tr');
            var data = {
                itemID: $.trim(row.find('#tdItemID').text()),
                MedcineNo: $.trim(row.find('#tdIndentNo').text()),

            }
            modelConfirmation('Forcefully Issued Confirmation ?', 'Do you want to Issued', 'Yes', 'Close', function (response) {
                if (response) {
                     
                    serverCall('Pharmacy.asmx/IssuedMedicineForcefully', data, function (response) {
                        var responseData = JSON.parse(response);
                        if (responseData.status) {
                            if (!String.isNullOrEmpty(data.itemID))
                                $('#divIndentItemsDetails').find('.' + $.trim(data.itemID)).remove();
                            else
                                getPatientIndents(function () { }, 0);

                        }
                    });
                } else {
                    return false;
                }

            });
        }

    </script>
</asp:Content>

