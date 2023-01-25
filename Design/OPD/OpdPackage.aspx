<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDPackage.aspx.cs" Inherits="Design_OPD_OPDPackage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="OldPatientSearchControl" TagPrefix="UC1" %>
<%@ Register Src="~/Design/Controls/UCPayment.ascx" TagName="PaymentControl" TagPrefix="UC2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     




    <script type="text/javascript">
        $(document).ready(function () {
           // $.blockUI({ message: '<h3><img src="../../Images/progress_bar.gif" /><br/>Just a moment...</h3>' });
            $getHashCode(function () {
                $bindMandatory(function () {
                    $patientControlInit(function () {
                        $panelControlInit(function () {
                            $paymentControlInit(function () {
                                $bindOPDPackages(function () {
                                    initConsuableSearch();
                                    if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1')
                                        $bindRegistrationCharges(function () { });
                                  //  $.unblockUI();
                                });
                            });
                        });
                    });
                });
            });
        });


        var $bindMandatory = function (callback) {
            var manadatory = [
            { control: '#ddlTitle', isRequired: true, erroMessage: 'Please Select Title', tabIndex: 1, isSearchAble: false },
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPLastName', isRequired: true, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
				{ control: '#txtDOB', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                //{ control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                //{ control: '#ddlMarried', erroMessage: 'Select Marital Status', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 4, isSearchAble: false },
              //  { control: '#txtIDProofNo', isRequired: true, erroMessage: 'Enter NIC No.', tabIndex: 4, isSearchAble: false },
                 { control: '#txtAddress', isRequired: true, erroMessage: 'Enter Address', tabIndex: 5, isSearchAble: false },
                //{ control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },
                { control: '#ddlCountry', isRequired: true, erroMessage: 'Please Select Country', tabIndex: 6, isSearchAble: true },
                { control: '#ddlDistrict', isRequired: true, erroMessage: 'Please Select DIstrict', tabIndex: 7, isSearchAble: true },
                { control: '#ddlCity', isRequired: true, erroMessage: 'Please Select City', tabIndex: 8, isSearchAble: true },
                { control: '#ddlDoctor', isRequired: true, erroMessage: 'Please Select Doctor', tabIndex: 9, isSearchAble: true }
            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass('requiredField');
                if (item.isSearchAble)
                    $(item.control + '_chosen a').attr('tabindex', item.tabIndex);
                $(manadatory[0].control).focus();
            });
            callback(true);
        }


        var $getHashCode = function (callback) {
            serverCall('../Common/CommonService.asmx/bindHashCode', {}, function (response) {
                $('#spnHashCode').text(response);
                callback(true);
            });
        }

        $bindOPDPackages = function (callback) {
            serverCall('../Common/CommonService.asmx/bindPackage', {}, function (response) {
                $ddlOPDPackages = $('#ddlOPDPackages');//
                $ddlOPDPackages.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'PackageID', textField: 'Name', isSearchAble: true });
                callback($ddlOPDPackages.val());
            });
        }

        $checkPackageExpiry = function (packageID, callback) {
            serverCall('../Common/CommonService.asmx/PackageExpirayDate', { PackageID: packageID }, function (response) {
                if (response == '1')
                    callback(true);
                else
                    callback(false);
            });
        }
        checkMemberShipCardPackageValidity = function (itemID,cardNo,patientID,callback) {
            serverCall('../Common/CommonService.asmx/checkMemberShipCardPackageValidity', { itemID: itemID, cardNo: cardNo, patientID: patientID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    $('#spnIsFreePackageMembership').text('1');
                    callback(true);
                }
                else {
                    modelAlert(responseData.response, function () {
                        $('#spnIsFreePackageMembership').text('0');
                    callback(true);
            });
        }
            });
        }

        $bindPackageDetails = function (packageID, panelID, callback) {
            serverCall('../Common/CommonService.asmx/bindPackageDetail', { PackageID: packageID, PanelID: panelID }, function (response) {
                packageDetailsData = JSON.parse(response);
                if (packageDetailsData != null) {
                    var output = $('#templatePackageDetails').parseTemplate(packageDetailsData);
                    $('#divPackageDetails').html(output);
                    callback(true);
                }
                else {
                    $('#divPackageDetails').html('');
                    callback(false);
                }
            });
        }


        $bindPackageConsultationDetails = function (packageID, callback) {
            serverCall('../Common/CommonService.asmx/bindPackageDocDetail', { PackageID: packageID }, function (response) {

                if (!String.isNullOrEmpty(response)) {
                    packageConsultationDetailsData = JSON.parse(response);
                    var output = $('#templatePackageConsultationDetails').parseTemplate(packageConsultationDetailsData);
                    $('#divPackageConsultationDetails').html(output);
                    callback(true);
                }
                else {
                    $('#divPackageConsultationDetails').html('');
                    callback(false);
                }
            });
        }


        $bindPackageConsultationDoctor = function (callback) {
            $('#tblPackageConsultationDetails tr').each(function (index, row) {
                var doctorID = $(this).find('#tdDoctorID').text();
                if (String.isNullOrEmpty(doctorID)) {
                    var doctorDepartmentID = $(this).find('#tdDepartment').text();// $(this).find('#tdDocDepartmentID').text();
                    var dropDown = $(this).find('#ddlPackageDoctor');
                    $bindPackageConsultationDoctorDepartmentWise(dropDown, doctorDepartmentID);
                }
            });
            callback(true);
        }

        var $bindPackageConsultationDoctorDepartmentWise = function (dropdown, department) {
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                dropdown.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
            });
        }

        var getPatientVaccinationAndConsumables = function (el) {
            var _ddlOPDPackages = $('#ddlOPDPackages').val();

            var packageID = _ddlOPDPackages.split('#')[0];
            var itemID = _ddlOPDPackages.split('#')[1];

            getPatientBasicDetails(function (patientDetails) {
                serverCall('OPDPackage.aspx/GetPatientVaccinationAndConsumables', { visitID: patientDetails.visitID, patientID: patientDetails.patientID }, function (response) {
                    var responseData = JSON.parse(response);
                    var consumablesAmount = 0;
                    $(responseData).each(function () {
                        addVaccinationAndConsuablesRow(this);
                        consumablesAmount = Number(this.PerUnitSellingPrice * this.SoldUnits);
                    });
                    $(el).attr('disabled', true);
                    $bindPackageRate(packageID, patientDetails, itemID, patientDetails.panelCurrencyFactor, patientDetails.memberShipCardNo, consumablesAmount, function () {


                    });
                });
            });
        }


        var addVaccinationAndConsuablesRow = function (d, callback) {
            var _tableInvestigation = $('#tableInvestigation tbody');
            var r = '<tr style="background-color: aquamarine;" id="tr_' + d.stockID + '">';
            r += '<td class="GridViewLabItemStyle" id="tdInvestigationName" style="width:260px; text-align:left">' + d.TypeName + '</td>  ';
            r += '<td class="GridViewLabItemStyle" id="tdQuantity" style="width:20px;">' + d.SoldUnits + '</td>  ';
            r += '<td class="GridViewLabItemStyle" id="tdRemove" style="width:20px;text-align:center;"><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removeMedicine(this)"></td>  ';
            r += '<td class="GridViewLabItemStyle" id="tdSubCategoryIDInv" style="width:20px; display:none">' + d.SubCategoryID + '</td>  ';
            r += '<td class="GridViewLabItemStyle" id="tdRate" style="width:20px; display:none">' + d.PerUnitSellingPrice + '</td> ';
            r += '<td class="GridViewHeaderStyle" id="tdInvestigation_Id" style="width:20px; display:none"></td> ';
            r += '<td class="GridViewHeaderStyle" id="tdIsConsuables" style="width:20px; display:none">1</td> ';
            r += '<td class="GridViewHeaderStyle" id="tdStockID" style="width:20px; display:none">' + d.stockID + '</td> ';


            r += '<td class="GridViewHeaderStyle" id="tdSampleType" style="width:20px; display:none">' + d.SampleType + '</td>  ';
            r += '<td class="GridViewHeaderStyle" id="tdItemID" style="width:20px; display:none">' + d.ItemID + '</td> ';
            r += '<td class="GridViewHeaderStyle" id="tdOutSource" style="width:20px; display:none">' + d.OutSource + '</td>';

            
            r += '</tr>'
            _tableInvestigation.append(r);
            callback();
        }




        $onPackageChange = function (value) {
            if (value != '0') {
                //$('#btnAddConsumables');
                var packageID = value.split('#')[0];
                var itemID = value.split('#')[1];
                var isVaccinationAllow = Number(value.split('#')[3]);
                var isConsumablesAllow = Number(value.split('#')[4]);

                if (isVaccinationAllow || isConsumablesAllow)
                    $('.divVaccinationAndConsuables').removeClass('hidden');
                else
                    $('.divVaccinationAndConsuables').addClass('hidden');

                getPatientBasicDetails(function (patientDetails) {
                    $checkPackageExpiry(packageID, function (expiryStatus) {
                        if (expiryStatus) {
                            checkMemberShipCardPackageValidity(itemID, patientDetails.memberShipCardNo, patientDetails.patientID, function (status) {
                            $bindPackageDetails(packageID, patientDetails.panelID, function () {
                                $bindPackageConsultationDetails(packageID, function () {
                                    $bindPackageConsultationDoctor(function () {
                                        $bindPackageRate(packageID, patientDetails, itemID, patientDetails.panelCurrencyFactor, patientDetails.memberShipCardNo, 0, function () {
                                            $preventPatientPanelChange(function () {
                                                //if (isVaccinationAllow || isConsumablesAllow)
                                                //    $('.divVaccinationAndConsuables').removeClass('hidden');
                                                //else
                                                //    $('.divVaccinationAndConsuables').addClass('hidden');
                                                });
                                            });
                                        });
                                    });
                                });
                            });
                        }
                        else {
                            modelAlert('Package has been Expired!', function () {
                                $clearPackageDetails(function () { });
                            });
                        }
                    });
                });
            }
            else
                $clearPackageDetails(function () { });
            $('#spnMobilePrescriptionID').text('');
        }



        var onPriscribedPackageSelect = function (value) {
            $('#ddlOPDPackages').val(value).change().chosen("destroy").chosen();
            $('#spnMobilePrescriptionID').text('');
        }

        $clearPackageDetails = function (callback) {
            $('#divPackageConsultationDetails,#divPackageDetails').html('');
            $('#lblPacakgeRate').text(0);
            $clearPaymentControl(function () { });
            $allowPatientPanelChange(function () { });
            callback(true);
        }



        $bindPackageRate = function (packageID, patientDetails, itemID, panelCurrencyFactor, memberShipCardNo, consuablesAmount, callback) {
            serverCall('../Common/CommonService.asmx/bindPackageRate', { PackageID: packageID, PanelID: patientDetails.panelID, panelCurrencyFactor: panelCurrencyFactor }, function (packageRate) {
                if (!String.isNullOrEmpty(packageRate)) {
                    $getDiscountWithCoPay({ itemID: itemID, panelID: patientDetails.panelID, patientTypeID: patientDetails.patientTypeID, memberShipCardNo: memberShipCardNo }, function (discountCoPayment) {
                        var packageRateDetails = JSON.parse(packageRate);
                        if (packageRateDetails.length == 0) {
                            modelAlert('Package Rate Not Define', function () {
                                $clearPackageDetails(function () { });
                            });
                            return;
                        }

                        $('#lblPacakgeRate').html(packageRateDetails[0].Rate);
                        packageRateDetails[0].Rate = (Number(packageRateDetails[0].Rate) + consuablesAmount);
                        var memberShipDiscountPercent = 0;
                        var memberShipDiscountAmount = 0;
                        var paneldiscountPercent = discountCoPayment.OPDPanelDiscPercent;
                        var panelDiscountAmount = 0;
                        var IsPanelWiseDiscount = discountCoPayment.OPDPanelDiscPercent > 0 ? 1 : 0;


                        //Co-PAY on Non-Ispayable Item
                        var panelNonPayableAmount = 0;
                        if (discountCoPayment.IsPayble == 0) {
                            $coPaymentPercent = Number(discountCoPayment.OPDCoPayPercent);
                            //$coPaymentPercent = isNaN($coPaymentPercent) ? 0 : $coPaymentPercent;

                            if ($coPaymentPercent > 0)
                                panelNonPayableAmount = panelNonPayableAmount + ((packageRateDetails[0].Rate * $coPaymentPercent) / 100);
                        }
                        else if ($isPayable == 1)
                            panelNonPayableAmount = panelNonPayableAmount + packageRateDetails[0].Rate;



                        if (paneldiscountPercent > 0)
                            panelDiscountAmount = ((packageRateDetails[0].Rate * paneldiscountPercent) / 100);


                        $loadMemberShipDisc(packageID, function (memberShipDiscount) {
                            if (!String.isNullOrEmpty(memberShipDiscount)) {
                                var isPercent = parseInt(memberShipDiscount.split('#')[1]);
                                var memberShipDiscount = parseFloat(memberShipDiscount.split('#')[0]);
                                if (isPercent == 1) {
                                    memberShipDiscountAmount = parseFloat(packageRateDetails[0].Rate) * parseFloat(memberShipDiscount) * 0.01;
                                    memberShipDiscountPercent = memberShipDiscount;
                                }
                                else {
                                    memberShipDiscountAmount = memberShipDiscount;
                                    memberShipDiscountPercent = ((memberShipDiscount * 100) / packageRateDetails[0].Rate);
                                }
                            }


                            var finalDiscountAmount = 0;
                            var finalDiscountPercent = 0;
                            if (memberShipDiscountAmount > 0) {
                                finalDiscountAmount = memberShipDiscountAmount;
                                finalDiscountPercent = memberShipDiscountPercent;
                                IsPanelWiseDiscount = 0;
                            }
                            else {
                                finalDiscountAmount = panelNonPayableAmount;
                                finalDiscountPercent = paneldiscountPercent;
                                IsPanelWiseDiscount = 1;
                            }


                            $('#spnIsPanelWiseDiscount').text(IsPanelWiseDiscount);
                            $('#spnDiscountPercent').text(finalDiscountPercent);
                            $('#spnDiscountAmount').text(finalDiscountAmount);
                            $('#spnIsPayable').text(discountCoPayment.IsPayble);
                            $('#spnCoPaymentPercent').text(discountCoPayment.OPDCoPayPercent);

                            var IsDiscountAuthorization = '<%=Util.GetInt(ViewState["IsDiscount"])%>';

                            $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                            $autoPaymentMode = '<%=Resources.Resource.IsReceipt%>' == '1' ? false : true;

                            $getRegistrationCharges(function (registrationDetails) {
                                var registrationCharge = registrationDetails.registrationCharge;
                                var billAmount = (packageRateDetails[0].Rate + registrationCharge);

                            $addBillAmount({
                                panelId: patientDetails.panelID,
                                    billAmount: billAmount,
                                disCountAmount: finalDiscountAmount,
                                isReceipt: $isReceipt,
                                    autoPaymentMode : $autoPaymentMode,
                                patientAdvanceAmount: patientDetails.patientAdvanceAmount,
                                minimumPayableAmount: panelNonPayableAmount,
                                disableDiscount: IsDiscountAuthorization == '0' ? true : false,
                                refund: { status: false }
                            }, function () { });
                            });
                        });
                        $('#spnScheduleChargeID').html(packageRateDetails[0].ScheduleChargeID);
                        $('#spnRateListID').html(packageRateDetails[0].ID);
                        callback(true);
                    });
                }
                else {
                    modelAlert('Package Rate Not Set,Please Contact Administrator');
                }
            });
        }


        $getDiscountWithCoPay = function (data, callback) {
            serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', data, function (response) {
                callback(JSON.parse(response)[0]);
            });
        }

        $loadMemberShipDisc = function (itemID, callback) {
            var memberShipCardNo = $('#txtMembershipCardNo').val();
            if (!String.isNullOrEmpty(memberShipCardNo)) {
                serverCall('../Common/CommonService.asmx/LoadMembershipDisc', { TnxType: 'OPDPackage', MembershipCardNo: memberShipCardNo, SubCategoryID: '<%=Resources.Resource.OPDPackageSubcategoryId%>', Type: 'OPD', ItemID: itemID }, function (response) {
                if (!String.isNullOrEmpty(response))
                    callback(response);
                else
                    callback('0#0');
            });
        }
        else
            callback('0#0');
        }

    $onConsultationDoctorChange = function (elem) {
        $row = $(elem).closest('tr');
        $row.find('#tdDoctorID').text(elem.value);
    }

    $getOPDPackageDetails = function (callback) {
        $getPanelDetails(function (panelDetails) {
            var data = {};
            var _ddlOPDPackages = $('#ddlOPDPackages');
            data.hashCode = $('#spnHashCode').text();
            data.packageName = _ddlOPDPackages.find('option:selected').text();
            data.packageID = $.trim(_ddlOPDPackages.val().split('#')[0]);
            data.packageItemID = $.trim(_ddlOPDPackages.val().split('#')[1]);
            data.packageSubCategoryID = $.trim(_ddlOPDPackages.val().split('#')[2]);
            data.isVaccinationAllow = Number(_ddlOPDPackages.val().split('#')[3]);
            data.isConsumablesAllow = Number(_ddlOPDPackages.val().split('#')[4]);
            data.packageRate = parseFloat($('#lblPacakgeRate').text());
            data.packageQuantity = 1;
            data.packageRateListID = $('#spnRateListID').text();
            data.packageScheduleChargeID = $('#spnScheduleChargeID').text();
            data.discountAmount = $.trim($('#spnDiscountAmount').text()),
            data.discountPercent = $.trim($('#spnDiscountPercent').text()),
            data.IsPayable = $.trim($('#spnIsPayable').text()),
            data.CoPayPercent = $.trim($('#spnCoPaymentPercent').text()),
            data.IsPanelWiseDiscount = $.trim($('#spnIsPanelWiseDiscount').text()),

            data.investigationDetails = [];
            data.consultationDetails = [];
            $('#tableInvestigation tr').not(':first').each(function (index, row) {
                data.investigationDetails.push({
                    investigationName: $.trim($(row).find('#tdInvestigationName').text()),
                    quantity: $.trim($(row).find('#tdQuantity').text()),
                    subcategory: $.trim($(row).find('#tdSubCategoryIDInv').text()),
                    rate: $.trim($(row).find('#tdRate').text()),
                    investigationID: $.trim($(row).find('#tdInvestigation_Id').text()),
                    sampleType: $.trim($(row).find('#tdSampleType').text()),
                    itemID: $.trim($(row).find('#tdItemID').text()),
                    outSource: $.trim($(row).find('#tdOutSource').text()),
                    StockID: $.trim($(row).find('#tdStockID').text()),
                });

            });
            $('#tblPackageConsultationDetails tr').not(':first').each(function (index, row) {
                data.consultationDetails.push({
                    visitType: $.trim($(row).find('#tdVisitType').text()),
                    department: $.trim($(row).find('#tdDepartment').text()),
                    doctorName: $.trim($(row).find('#tdDoctorName').find('select option:selected').text()) == '' ? $.trim($(row).find('#tdDoctorName').text()) : $.trim($(row).find('#tdDoctorName').find('select option:selected').text()),
                    doctorID: $.trim($(row).find('#tdDoctorID').text()),
                    subCategoryID: $.trim($(row).find('#tdSubCategoryID').text()),
                    docDepartmentID: $.trim($(row).find('#tdSubCategoryID').text())
                });
            });
            //$(data.consultationDetails).each(function () {
            //    $getDoctorRate({ type_id: this.doctorID, subcategoryid: this.subCategoryID, PanelID: panelDetails.panel.panelID }, function (response) {
            //        this.rate = response.Rate;
            //        this.ItemID = response.ItemID;
            //        this.RateListID = response.ID;
            //    });
            //});
            var unselectedDoctor = data.consultationDetails.filter(function (doctor) { return (String.isNullOrEmpty(doctor.doctorID) == true || doctor.doctorID == '0') });
            if (unselectedDoctor.length > 0) {
                modelAlert('Please Select Doctor', function () { });
                return false;
            }
            else
                callback(data);


        });
    }

    $getDoctorRate = function (data, callback) {
        serverCall('../Common/CommonService.asmx/GetRate', data, function (response) {
            if (!String.isNullOrEmpty(response)) {
                callback(JSON.parse(response));
            }
            else
                modelAlert('Doctor Rate Not Set');
        });
    }


    var onPanelCurrencyFactorChange = function (callback) {
        $clearPackageDetails(function () { callback(); });
    }



    $getPackagePaymentDetails = function (callback) {
        $getOPDPackageDetails(function (packageDetails) {
            $getPatientDetails(function (patientDetails) {
                $getPaymentDetails(function (paymentDetails) {
                    $isReceipt = '<%=Resources.Resource.IsReceipt%>' == '1' ? true : false;
                    $PM = patientDetails.defaultPatientMaster;
                    $PMH = {
                        patient_type: patientDetails.PatientType.text,
                        PanelID: patientDetails.PanelID,
                        DoctorID: patientDetails.Doctor.value,
                        ReferedBy: patientDetails.ReferedBy,
                        ProId: patientDetails.PROID,
                        Type: 'OPD',
                        Purpose: '',
                        ParentID: patientDetails.ParentID,
                        HashCode: packageDetails.hashCode,
                        ScheduleChargeID: packageDetails.packageScheduleChargeID,
                        patient_type: patientDetails.PatientType.text,
                        PolicyNo: patientDetails.panelDetails.policyNo,
                        PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                        ExpiryDate: patientDetails.panelDetails.expireDate,
                        EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                        CardNo: patientDetails.panelDetails.cardNo,
                        //DependentRelation: patientDetails.panelDetails.cardHolderRelation,
                        CardHolderName: patientDetails.panelDetails.nameOnCard,
                        RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                        KinRelation: patientDetails.Relation.text,
                        KinName: patientDetails.RelationName,
                        KinPhone: patientDetails.RelationPhoneNo,
                        patientTypeID: patientDetails.PatientType.value,
                        PatientPaybleAmt: paymentDetails.patientPayableAmount,
                        PanelPaybleAmt: paymentDetails.panelPayableAmount,
                        PatientPaidAmt: paymentDetails.patientPaidAmount,
                        PanelPaidAmt: paymentDetails.panelPaidAmount,
                        TypeOfReference: patientDetails.typeOfReference.text,
                        IsVisitClose: 1,
                        CorporatePanelID: patientDetails.CorporatePanelID  //
                    }
                    $LT = {
                        TypeOfTnx: 'OPD-Package',
                        PanelID: patientDetails.PanelID,
                        UniqueHash: packageDetails.hashCode,
                        NetAmount: paymentDetails.netAmount,
                        GrossAmount: paymentDetails.billAmount,
                        DiscountReason: paymentDetails.discountReason,
                        DiscountApproveBy: paymentDetails.approvedBY,
                        DiscountOnTotal: paymentDetails.discountAmount,
                        RoundOff: paymentDetails.roundOff,
                        GovTaxPer: 0,
                        GovTaxAmount: 0,
                        Adjustment: $isReceipt ? paymentDetails.adjustment : '0',
                    }
                    $LTD = [];

                    var itemDetails = {
                        PackageType: '0',
                        ItemID: packageDetails.packageItemID,
                        Rate: packageDetails.packageRate,
                        Quantity: '1',
                        // Amount: paymentDetails.netAmount,
                        Amount: packageDetails.packageRate - paymentDetails.discountAmount,

                        SubCategoryID: packageDetails.packageSubCategoryID,
                        ItemName: packageDetails.packageName,
                        DiscountReason: paymentDetails.discountReason,
                        DoctorID: patientDetails.Doctor.value,
                        TnxTypeID: '14',
                        IsPackage: 0,
                        PackageID: '',
                        RateListID: packageDetails.packageRateListID,
                        DiscAmt: paymentDetails.discountAmount,
                        DiscountPercentage: paymentDetails.discountPercent,
                        CoPayPercent: packageDetails.CoPayPercent,
                        IsPayable: packageDetails.IsPayable,
                        isPanelWiseDisc: packageDetails.IsPanelWiseDiscount,
                        panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                        panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                        StockID: ''

                    };

                    if (paymentDetails.isCoPaymentOnBill == 1)
                        itemDetails.CoPayPercent = paymentDetails.coPaymentPercent;

                    $LTD.push(itemDetails);

                    $(packageDetails.investigationDetails).each(function () {
                        
                        $LTD.push({
                            PackageType: '1',
                            IsPackage: '1',
                            PackageID: packageDetails.packageID,
                            ItemName: this.investigationName,
                            Quantity: this.quantity,
                            Amount: this.rate * this.quantity,
                            SubCategoryID: this.subcategory,
                            ItemID: this.itemID,
                            Rate: this.rate,
                            DiscAmt: 0,
                            DiscountPercentage: 0,
                            Investigation_ID: this.investigationID,
                            IsSampleCollected: this.sampleType,
                            IsOutSource: this.outSource,
                            panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                            panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                            StockID: this.StockID
                        })
                    })

                    $(packageDetails.consultationDetails).each(function () {
                        $LTD.push({
                            PackageType: '2',
                            IsPackage: '1',
                            PackageID: packageDetails.packageID,
                            SubCategoryID: this.subCategoryID,
                            Quantity: 1,
                            DiscAmt: 0,
                            DiscountPercentage: 0,
                            ItemName: this.doctorName,
                            DoctorID: this.doctorID,
                            // Rate: this.rate,
                            // ItemID: this.ItemID,
                            // RateListID: this.RateListID
                            panelCurrencyCountryID: patientDetails.panelDetails.panelCurrencyCountryID,
                            panelCurrencyFactor: patientDetails.panelDetails.panelCurrencyFactor,
                            StockID: ''
                        })
                    })
                    $paymentDetails = [];
                    $(paymentDetails.paymentDetails).each(function () {
                        $paymentDetails.push({
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
                        })
                    })
                    var directDiscountOnBill = packageDetails.discountPercent > 0 ? false : true;
                    var mobilePrescriptionID = Number($('#spnMobilePrescriptionID').text());


                    if (packageDetails.isConsumablesAllow || packageDetails.isVaccinationAllow) {
                        var isConsumablesAvilable = $LTD.filter(function (s) { return s.salesID != '' });
                        if (isConsumablesAvilable.length == 0) {
                            modelAlert('Please Add Consumables');
                            return false;
                        }
                    }



                    if ($paymentDetails.length < 1) {
                        modelAlert('Please Select Payment Details.', function () {

                        });
                        return false;
                    }

                    var panelPaidAmountrow = 0;
                    _divPaymentControlParent.find('#divPaymentDetails #tdPaymentModeID').each(function () {
                        if (Number($(this).text()) == 8)
                            panelPaidAmountrow += Number($(this).closest('tr').find('#tdBaseCurrencyAmount').text());
                    });
                    var $totalPaidAmountpatient = $LT.Adjustment - panelPaidAmountrow;
                    if ($paymentDetails[0].PaymentModeID != 4) {
                        // if (nonAppointmentItems.length > 0) {
                        if ($PMH.PatientPaybleAmt > 0) {
                            if ($PMH.PatientPaybleAmt > $PMH.PatientPaidAmt) {
                                modelAlert('Partial Payment Not Allow.', function () { });
                                return false;
                            }
                        }
                        else if ($totalPaidAmountpatient < $LT.NetAmount) {
                            modelAlert('Partial Payment Not Allow.', function () { });
                            return false;
                        }
                        // }
                    }
                    if ($PMH.PatientPaybleAmt > 0) {
                        //if ($totalPaidAmountpatient < $PMH.PatientPaybleAmt) {
                        //    modelAlert('Partial Payment Not Allow.', function () { });
                        //    return false;
                        //}
                        if ($totalPaidAmountpatient > $PMH.PatientPaybleAmt) {
                            modelAlert('Can Not Collect More Than The Patient Payable Amount.', function () { });
                            return false;
                        }
                    }


                    callback({ PM: [$PM], PMH: [$PMH], LT: [$LT], LTD: $LTD, PaymentDetail: $paymentDetails, directDiscountOnBill: directDiscountOnBill, MobilePrescriptionID: mobilePrescriptionID });
                });
            });
        });
    }


        $savePackagePaymentDetails = function (btnSave, callback) {
            $getPackagePaymentDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/OPDPackage.asmx/SaveOPDPackage', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            if ('<%=Resources.Resource.ReceiptPrintFormat%>' == "0")
                                window.open('../common/OPDPackageReceipt.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '&IsBill=' + responseData.isBill + '&Duplicate=0');
                            else
                                window.open('../common/CommonReceipt_pdf.aspx?LedgerTransactionNo=' + responseData.ledgerTransactionNo + '&IsBill=' + responseData.isBill + '&Duplicate=0&Type=OPD');
                            window.location.reload();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }



	</script>

    <script type="text/javascript">
        $(function () {
            shortcut.add('Alt+S', function () {
                var btnSave = $('#btnSave');
                if (btnSave.length > 0) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        $savePackagePaymentDetails(btnSave[0]);
                    }
                }
            }, addShortCutOptions);
        });
    </script>



	   <div id="Pbody_box_inventory">
		<cc1:ToolkitScriptManager runat="server" ID="scrptManager"></cc1:ToolkitScriptManager>
		<div class="POuter_Box_Inventory" style="text-align: center">
			<b>OPD Package</b>
			<span style="display:none" id="spnHashCode"></span>
			<span style="display:none" id="spnScheduleChargeID"></span>
			<span style="display:none" id="spnRateListID"></span>
			<span style="display:none" id="spnDiscountPercent">0</span>
			<span style="display:none" id="spnDiscountAmount">0</span>
			<span style="display:none" id="spnIsPayable">0</span>
			<span style="display:none" id="spnCoPaymentPercent">0</span>
			<span style="display:none" id="spnIsPanelWiseDiscount">0</span>
            <asp:Label runat="server" ID="lblDeptLedgerNo" ClientIDMode="Static" Style="display: none"></asp:Label>
            <span style="display:none" id="spnIsFreePackageMembership">0</span>
		</div>
		<UC1:OldPatientSearchControl ID="PatientInfo" runat="server" />
		<div class="POuter_Box_Inventory">
			<div class="row">
				<div class="col-md-12">
					<div class="row">
						<div style="padding-right: 0px;" class="col-md-5">
							<label class="pull-left">Package Name</label>
							<b class="pull-right">:</b>
						</div>
						<div style="padding-left: 15px;" class="col-md-11">
								<select id="ddlOPDPackages"   onchange="$onPackageChange(this.value)"></select>
						</div>
						<div  class="col-md-3">
							<button id="btnCpoeInvestigation" style="width: 100%;"   onclick="$openPackagePrescriptionModel()" type="button">CPOE</button>
						</div>
                        <div class="col-md-5">
								<button id="btnMobileApp" style="width: 100%;" onclick="$openMobileAppBookingModel()" type="button">Online Booking's</button>
						</div>
					</div>
                    <div class="row divVaccinationAndConsuables">
                          <div  style="padding-right:0px" class="col-md-5">
                              <label class="pull-left">Consumables</label>
							   <b class="pull-right">:</b>
                          </div>

                        <div style="padding-left: 15px;" class="col-md-19">
                               <input type="text" id="txtConsuables" />
                        </div>

                    </div>

                  

					<div class="row">
						   <div id="divPackageDetails" class="col-md-24">

						   </div>
					   </div>
				</div>
				<div class="col-md-12">
					   <div class="row">
                        <div id="divVaccinationAndConsuables" class="col-md-7 hidden">
                            <%--<button onclick="getPatientVaccinationAndConsumables(this)" id="btnAddConsumables" type="button">Add Vaccination & Consumables</button>--%>
                        </div>
						<div style="padding-right: 0px;" class="col-md-5">
							<label class="pull-left">Package Rate  </label>
							<b class="pull-right">:</b>
						</div>
						<div style="padding-left: 15px;" class="col-md-5">
							   <label  style="font-weight:bold;color:blue"   id="lblPacakgeRate">0</label>
						</div>
                        <div  class="col-md-6">
                             <%--<button type="button" style="width: 25px; height: 25px; float: left; margin-left: 5px; background-color: aqua" class="circle"></button>
                             <b style="float: left; margin-top: 5px; margin-left: 5px">Consumables</b>--%>
                        </div>


					   </div>
                      <div class="row divVaccinationAndConsuables">
                          <div style="padding-right: 0px;" class="col-md-5">
							<label class="pull-left">Quantity  </label>
							<b class="pull-right">:</b>
						   </div>

                          <div class="col-md-4">
                                <input type="text" class="ItDoseTextinputNum"  id="txtQuantity" />
                          </div>

                          <div class="col-md-2">
                              <input type="button" value="Add Item"   onclick="addItem(event)" />
                          </div>


                      </div>
					   <div class="row">
						   <div id="divPackageConsultationDetails" class="col-md-24">

						   </div>
					   </div>
				</div>
			</div>
		</div>
		<div id="paymentControlDiv"  style="text-align: center;">
			<uc2:PaymentControl ID="paymentControlNew" runat="server" />
		</div>

		<div class="POuter_Box_Inventory" style="text-align: center">
			<input type="button" style="width:100px;margin-top:7px" id="btnSave" class="ItDoseButton" value="Save" onclick="$savePackagePaymentDetails(this);" />
       <span id="spnMobilePrescriptionID" style="display:none;"></span>
		</div>


	</div>





 
 <script id="templatePackageDetails" type="text/html">
	<table  id="tableInvestigation" cellspacing="0" rules="all" border="1" 
	style="width:100%;border-collapse:collapse; ">
		<thead>
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:260px;text-align:left">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;text-align:left">Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;text-align:left"></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">SubCategoryID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">Rate</th>
			 <th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">InvestigationID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">sampleType</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">ItemID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">IsOutSource</th>
		</tr>
			</thead>
		<tbody>
			<#        
		for(var j=0;j<packageDetailsData.length;j++)
		{       
	   var objRow = packageDetailsData[j];
		#>
			<tr id="<#=j+1#>">                                                                                                         
		   <td class="GridViewLabItemStyle" id="tdInvestigationName" style="width:260px; text-align:left"><#=objRow.Item#></td>
		   <td class="GridViewLabItemStyle" id="tdQuantity" style="width:20px;"><#=objRow.Quantity#></td>
           <td class="GridViewLabItemStyle" id="td5" style="width:20px;"></td>
		   <td class="GridViewLabItemStyle" id="tdSubCategoryIDInv" style="width:20px; display:none"><#=objRow.SubCategoryID#></td>
		   <td class="GridViewLabItemStyle" id="tdRate" style="width:20px; display:none"><#=objRow.Rate#></td>
		   <td class="GridViewHeaderStyle" id="tdInvestigation_Id" style="width:20px; display:none"><#=objRow.Investigation_Id#></td>
           <td class="GridViewHeaderStyle" id="tdIsConsuables" style="width:20px; display:none">0</td>
           <td class="GridViewHeaderStyle" id="tdStockID" style="width:20px; display:none"></td>
                     

		   <td class="GridViewHeaderStyle" id="tdSampleType" style="width:20px; display:none"><#=objRow.Sample#></td>
		   <td class="GridViewHeaderStyle" id="tdItemID" style="width:20px; display:none"><#=objRow.ItemID#></td>
				<td class="GridViewHeaderStyle" id="tdOutSource" style="width:20px; display:none"><#=objRow.IsOutSource#></td>
			</tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
	
	</script>


 <script id="templatePackageConsultationDetails" type="text/html">
	<table  id="tblPackageConsultationDetails"  cellspacing="0" rules="all" border="1" 
	style="width:100%;border-collapse:collapse; ">
		<thead>
		<tr id="DocHeader">
			 <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none">SNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;text-align:left">Visit Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;text-align:left">Department</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;text-align:left">Doctor</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">SubCategoryID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">DocDepartmentID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px; display:none">DoctorID</th>
		</tr>
			</thead>
		<tbody>
			<#                
		for(var j=0;j<packageConsultationDetailsData.length;j++)
		{       
	   var objRow = packageConsultationDetailsData[j];
		#>
						<tr id="Tr2">    
						<td id="tdDocSno" style="display:none" class="GridViewLabItemStyle"><#=j+1#></td>                                                                                                       
						<td  class="GridViewLabItemStyle" id="tdVisitType"  style="width:120px;text-align:left"><#=objRow.VisitType#></td>
						<td class="GridViewLabItemStyle" id="tdDepartment" style="width:140px;text-align:left"><#=objRow.Department#></td>
						<td class="GridViewLabItemStyle" id="tdDoctorName" style="width:120px;text-align:left">
						  <#if(objRow.DoctorID==""){#>                         
					             <select id="ddlPackageDoctor" class="packageDoctor requiredField"    onchange="$onConsultationDoctorChange(this)"  style="width:160px; "></select>
							  <#}
							else{#>
							 <#=objRow.DName#><#}
							 #>
						   </td>      
						   <td  class="GridViewLabItemStyle" id="tdSubCategoryID"  style="width:120px; display:none"><#=objRow.SubCategoryID#></td>                
						   <td  class="GridViewLabItemStyle" id="tdDocDepartmentID"  style="width:120px; display:none"><#=objRow.DocDepartmentID#></td>                
						   <td  class="GridViewLabItemStyle" id="tdDoctorID"  style="width:120px; display:none"><#=objRow.DoctorID#></td>                

							  </tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
	
	</script>

 <script id="templatePatientPackagePrescriptionDetails" type="text/html">
	<table  id="table1" cellspacing="0" rules="all" border="1" 
	style="width:100%;border-collapse:collapse; ">
		<thead>
			<#if(packageDetailsData.length>0){ #>
		<tr id="Tr3">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;text-align:center">Select</th>
			<th class="GridViewHeaderStyle" scope="col" style="text-align:left">Package Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Doctor</th>
			<th class="GridViewHeaderStyle" scope="col" >Prescribed On</th>
		</tr>
			<#}#>
			</thead>
		<tbody>
			<#        
		for(var j=0;j<packageDetailsData.length;j++)
		{       
	   var objRow = packageDetailsData[j];
		#>
		<tr id="Tr4">                                                                                                         
		   <td class="GridViewLabItemStyle" id="td1" style="text-align:center">
			   <a class="btn" onclick="onPriscribedPackageSelect('<#=objRow.ID#>');$('#packagePrescriptionModel').closeModel();" style="cursor:pointer;padding:0px;font-weight:bold;width:60px ">Select</a>
		   </td>
		   <td class="GridViewLabItemStyle" id="td2"><#=objRow.Name#></td>
		   <td class="GridViewLabItemStyle" id="td3" ><#=objRow.Doctor#></td>
		   <td class="GridViewLabItemStyle" id="td4" ><#=objRow.Date#></td>
		</tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
	
	</script>

 
  


  <div id="packagePrescriptionModel" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 760px">
			<div class="modal-header">
				<button type="button" class="close"  data-dismiss="packagePrescriptionModel"  aria-hidden="true">&times;</button>
				<h4 class="modal-title">Prescription Search</h4>
			</div>
			<div class="modal-body">
			   
				 <div class="row">
					 <div  class="col-md-4">
						  <label class="pull-left">  From Date    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-6">
						   <asp:TextBox ID="txtPrescripptionModelFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
						   <cc1:CalendarExtender ID="calExdtxtPrescripptionModelFromDate" TargetControlID="txtPrescripptionModelFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
					 </div>
					 <div  class="col-md-4">
						   <label class="pull-left"> To Date    </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-6">
						  <asp:TextBox ID="txtPrescripptionModelToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select DOB" ></asp:TextBox>
						  <cc1:CalendarExtender ID="calExdtxtPrescripptionModelToDate" TargetControlID="txtPrescripptionModelToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
					 </div>
					 <div class="col-md-4">
							<button type="button"  onclick="searchPackagePrescription()">Search</button>
					 </div>
				 </div>
				</div>
			<div class="modal-body">
				<div style="height:200px"  class="row">
					<div id="divPackagePrescriptionDetails" class="col-md-24">
					   
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button"  data-dismiss="packagePrescriptionModel">Close</button>
			</div>
		</div>
	</div>
</div>


    <div id="dvonlinePackageBooking" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 860px">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="dvonlinePackageBooking"  aria-hidden="true">&times;</button>
				<h4 class="modal-title">Today Online Booking</h4>
			</div>
			<div class="modal-body">
			   
				 <div class="row">
					 <div  class="col-md-3">
						  <label class="pull-left">  From Date    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">

						   <asp:TextBox ID="txtOnlineFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static" onchange="$serachOnlinePackageModel()" ToolTip="Select From Date" ></asp:TextBox>
						   <cc1:CalendarExtender ID="cdOnlineFromDate" TargetControlID="txtOnlineFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
					 </div>
					 <div  class="col-md-3">
						   <label class="pull-left"> To Date    </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-5">
						  <asp:TextBox ID="txtOnlineToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"  onchange="$serachOnlinePackageModel()" ToolTip="Select To Date" ></asp:TextBox>
						   <cc1:CalendarExtender ID="cdOnlineToDate" TargetControlID="txtOnlineToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
					 </div>
					 <div class="col-md-3">
						 <label class="pull-left"> Mobile No.   </label>
						   <b class="pull-right">:</b>
					 </div>
                      <div  class="col-md-5">
						  <asp:TextBox ID="txtOnlineMobile" runat="server" onlynumber="10" ClientIDMode="Static"  onkeyup="$serachOnlinePackageModel()" ToolTip="Please Enter Mobile No." ></asp:TextBox>
					 
                      </div>
				 </div>
				</div>
			<div class="modal-body">
				<div style="height:200px"  class="row">
					<div id="divOnline" style="max-height:190px;overflow:auto" class="col-md-24">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				 <button type="button"  data-dismiss="dvonlinePackageBooking">Close</button>
			</div>
		</div>
	</div>
</div>
  <script type="text/javascript">
      $openPackagePrescriptionModel = function () {
          getPatientBasicDetails(function (patientDetails) {
              if (String.isNullOrEmpty(patientDetails.patientID)) {
                  modelAlert('Please Select Patient First');
                  return;
              }
              $('#packagePrescriptionModel').showModel();
          });
      }


      var searchPackagePrescription = function () {
          getPatientBasicDetails(function (patientDetails) {
              var data = {
                  patientID: patientDetails.patientID,
                  fromDate: $('#txtPrescripptionModelFromDate').val(),
                  toDate: $('#txtPrescripptionModelToDate').val(),
              }
              serverCall('OPDPackage.aspx/SearchPackagePrescription', data, function (response) {

                  packageDetailsData = JSON.parse(response);
                  var $template = $('#templatePatientPackagePrescriptionDetails').parseTemplate(packageDetailsData);
                  $('#divPackagePrescriptionDetails').html($template);

              });
          });
      }


      $openMobileAppBookingModel = function () {
          getPatientBasicDetails(function (patientDetails) {
              $('#dvonlinePackageBooking').showModel();
              $serachOnlinePackageModel();
          });
      }

      $serachOnlinePackageModel = function () {
          var data = {
              FromDate: $('#txtOnlineFromDate').val(),
              ToDate: $('#txtOnlineToDate').val(),
              Mobile: $('#txtOnlineMobile').val()
          }
          serverCall('../Common/CommonService.asmx/BindOnlineBookingPackage', data, function (response) {
              if (response != '') {
                  OnlineData = JSON.parse(response);
                  var $template = $('#template_searchOnlinePackage').parseTemplate(OnlineData);
                  $('#divOnline').html($template);
                  MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
              }
          });
      }

      var mobileApplicationBookingModelClose = function () {
          $('#dvonlinePackageBooking').closeModel();
      }
      var addOnlinePackage = function (elem) {

          $('#tbSelected tbody').find('tr').remove();
          var PatientData = JSON.parse($(elem).closest('tr').attr('data-app'));
          if (PatientData.IsRegistred == 1) {
              $searchPatient({ PatientID: PatientData.patientID, PatientRegStatus: 1 }, '', PatientData.Gender, function (response) {
                  mobileApplicationBookingModelClose();
                  $bindPatientDetails($.extend(response, PatientData), function () {
                      if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1') {
                          $bindRegistrationCharges(function () {
                              $bindOnlineBookingDetails(PatientData.ItemID, PatientData.IbID, function () { });
                          });
                      }
                      else {
                          $bindOnlineBookingDetails(PatientData.ItemID, PatientData.IbID, function () {
                          });
                      }
                  });
              });
          }
          else {
              getBindPatientDefaultValue(PatientData, function (response) {
                  mobileApplicationBookingModelClose();
                  $bindPatientDetails(response, function () {
                      if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1') {
                          $bindRegistrationCharges(function () {
                              $bindOnlineBookingDetails(PatientData.ItemID, PatientData.IbID, function () {
                              });
                          });
                      }
                      else {
                          $bindOnlineBookingDetails(PatientData.ItemID, PatientData.IbID, function () {
                          });
                      }
                  });
              });
          }
      }
      var $bindOnlineBookingDetails = function (col, Ids) {
          $('#ddlOPDPackages').val(col).change().chosen("destroy").chosen();
          $('#spnMobilePrescriptionID').text(Ids);
      }

  </script>
         <%-- Online Package Booking template--%>

 <script id="template_searchOnlinePackage" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOnlinePackage" style="width:100%;border-collapse:collapse;">
		<#if(OnlineData.length>0){#>

		<thead>
						   <tr  id='trOnlineHeader'>
								<th class='GridViewHeaderStyle'>S.No.</th>
                                <th class='GridViewHeaderStyle' >Booking No.</th>
								<th class='GridViewHeaderStyle'>Title</th>
								<th class='GridViewHeaderStyle'>Patient Name</th>
								<th class='GridViewHeaderStyle'>Mobile</th>
								<th class='GridViewHeaderStyle'>Gender</th>
                                <th class='GridViewHeaderStyle'>Age</th>
                                <th class='GridViewHeaderStyle'>BookingDate</th>
                                <th class='GridViewHeaderStyle'>Registered</th>
                                <th class='GridViewHeaderStyle'>Package Name</th>
                                <th class='GridViewHeaderStyle'>Select</th>
                                <th class='GridViewHeaderStyle' style="display:none;">OnlinePID</th>
                                <th class='GridViewHeaderStyle' style="display:none;">PanelID</th>
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=OnlineData.length;
            window.status="Total Records Found :"+ dataLength;
            var objRowOnline;   
            for(var k=0;k<dataLength;k++)
            {

                objRowOnline = OnlineData[k];
		
              #>
                            <tr  onmouseover="this.style.color='#00F'"    data-app='<#= JSON.stringify(objRowOnline)  #>'  onMouseOut="this.style.color=''" id="<#=k+1#>" ondblclick="addOnlinePackage(this);" style='cursor:pointer;'>
                            <td id="tdOnlineIndex" class="GridViewLabItemStyle" style="text-align:center"><#=k+1#></td>
                            <td id="tdOnlineEntryNo" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.EntryNo#></td>
                            <td id="tdOnlineTitle" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.Title#></td>
                            <td id="tdOnlinePatientName" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.PatientName#></td>
                            <td id="tdOnlineMobile" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.Mobile#></td>
                            <td id="tdOnlineGender" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.Gender#></td>
                            <td id="tdOnlineAge" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.Age#></td>
                            <td id="tdOnlineBookingDate" class="GridViewLabItemStyle" style="text-align:center;"><#=objRowOnline.BookingDate#></td> 
                            <td id="tdIsRegist" class="GridViewLabItemStyle" style="text-align:center"><#=objRowOnline.IsRegistred==0?'No':'Yes'#></td>  
                            <td id="tdOnlinePackageName" class="GridViewLabItemStyle" style="text-align:center;" ><#=objRowOnline.PackageName#></td>
                            <td id="tdSelectOnlineInvest" class="GridViewLabItemStyle" style="text-align:center;"><button type="button"  onclick="addOnlinePackage(this)" >Select</button></td>
                            <td id="tdOnlineOnlinePID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRowOnline.OnlinePID#></td>      
                            <td id="tdOnlinePanelID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRowOnline.PanelID#></td> 
                         	</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>





    <script type="text/javascript">

        var initConsuableSearch = function () {
            try {
                getComboGridOption(function (response) {
                    $('#txtConsuables').combogrid(response);
                    callback(true);
                });
            } catch (e) {

            }
        }

        var getComboGridOption = function (callback) {
            var setting = {
                panelWidth: 750,
                idField: 'ItemID',
                textField: 'ItemName',
                mode: 'remote',
                url: '../Store/Pharmacy.asmx/medicineItemSearch?cmd=item',
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
                    type: 1,
                    deptLedgerNo: $.trim($('#lblDeptLedgerNo').text().trim()),
                    sort: 'ItemName',
                    order: 'asc',
                    isWithAlternate: false,
                    isBarCodeScan: false
                },
                onHidePanel: function (i) { },
                columns: [[
                    { field: 'ItemName', title: 'ItemName', align: 'left', sortable: true },
                    { field: 'BatchNumber', title: 'Batch No.', align: 'center', sortable: true },
                    { field: 'AvlQty', title: 'Avl. Qty.', align: 'right', sortable: true },
                    { field: 'Expiry', title: 'Expiry', align: 'center', sortable: true },
                    { field: 'MRP', title: 'MRP', align: 'right', sortable: true },
                    { field: 'Rack', title: 'Rack', align: 'center' },
                    { field: 'Shelf', title: 'Shelf', align: 'center' },
                    { field: 'Generic', title: 'Generic', align: 'center', sortable: true }
                ]],
                fitColumns: true,
                rowStyler: function (index, row) {
                    if (row.alterNate > 0) {
                        return 'background-color:antiquewhite;';
                    }
                }
            }
            callback(setting);
        }



        var addItem = function (e) {
            var txtConsuables = $('#txtConsuables');
            var txtQuantity = $('#txtQuantity');
            var quantity = isNaN(parseFloat(txtQuantity.val())) ? 0 : parseFloat(txtQuantity.val());
            var grid = txtConsuables.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            var code = (e.keyCode ? e.keyCode : e.which);
            if (String.isNullOrEmpty(selectedRow)) {
                modelAlert('Please Select Item First', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtConsuables.combogrid('reset');
                });
                return;
            }

            var stockID = $.trim(selectedRow.stockid);




            var alreadySelectBool = $('#tr_' + stockID).length > 0 ? true : false;
            if (alreadySelectBool) {
                modelAlert('Item Already Added', function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtConsuables.combogrid('reset');
                });
                return;
            }
            if (quantity == 0)
                return;
            var itemID = selectedRow.ItemID.split('#')[0];
            var avilableQuantity = selectedRow.AvlQty;
            var deptLedgerNo = $.trim($('#lblDeptLedgerNo').text().trim());
            if (quantity > parseFloat(selectedRow.AvlQty)) {
                modelAlert('Stock Not Avilable', function () {
                    txtQuantity.val('').focus();
                });
                return;
            }
            if (code == 13 && e.target.type == 'text') {
                quantity = e.target.value;
                bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtConsuables.combogrid('reset');
                });
            }
            else if (e.target.type == 'button') {
                bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtConsuables.combogrid('reset');
                });
            }

            if (code == 9 && e.target.type == 'text') {
                $(this).parent().find('input[type=button]').focus();
            }
        }



        var bindItem = function (itemID, quantity, stockID, avilableQuantity, deptLedgerNo, callback) {
            getItemDetails(itemID, quantity, stockID, avilableQuantity, 0, deptLedgerNo, function (response) {
                response[0].patientMedicine = '0';
                response[0].indentNo = '';
                var data = {
                    TypeName: response[0].ItemName,
                    SoldUnits: quantity,
                    SubCategoryID: response[0].SubCategoryID,
                    PerUnitSellingPrice: response[0].MRP,
                    stockID: response[0].stockid,
                    SampleType: 'N',
                    ItemID: response[0].ItemID,
                    OutSource: 0
                };
                addVaccinationAndConsuablesRow(data, function () {
                    callback();
                });
            });
        }


        var getItemDetails = function (itemID, tranferQty, stockID, availableQty, isSet, deptLedgerNo, callback) {
            serverCall('../Store/Services/WebService.asmx/addItem', { ItemID: itemID, tranferQty: tranferQty, StockID: stockID, patientMedicine: '0', DeptLedgerNo: deptLedgerNo }, function (response) {
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


        var removeMedicine = function (el) {
            $(el).closest('tr').remove();
        }



    </script>


       <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
        <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>

</asp:Content>