<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OldPatientSearch.ascx.cs" Inherits="Design_Controls_OldPatientSearch" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCPanel.ascx" TagName="PanelDetailsControl" TagPrefix="UC1" %>
<script type="text/javascript" src="../../Scripts/webcamjs/webcam.js"></script>


<style type="text/css">
    .customTextArea {
        height: 22px;
        max-height: 22px;
        text-transform: uppercase;
        max-width: 214px;
        max-height: 70px;
    }
</style>


<script type="text/javascript">
    //*****Global Variables*******
    var CentreWiseCache = [];

    var $patientControlInit = function (callback) {
        //configurePageWise(function () {
        //    configureQueryStringWise(function () {
        //        $bindTitle(function () {
        //            $bindDepartment(function (selectedDepartment) {
        //                $bindDoctor(selectedDepartment, function () {
        //                    $bindReferDotor(function () {
        //                        $bindPRO(function (selectedPROID) {
        //                            $bindRelation(function () {
        //                                $bindModelRelation(function () {
        //                                    $bindCountry(function (selectedCountryID) {
        //                                        $bindState(selectedCountryID, function (selectedStateID) {
        //                                            $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
        //                                                $bindCity(selectedStateID, selectedDistrictID, function () {
        //                                                    $bindTuluka(selectedDistrictID, function () {
        //                                                        $bindDocumentMasters(function () {
        //                                                            $bindPatientType(function () {
        //                                                                $bindPatientIDProof(function () {
        //                                                                    $bindReligion(function () {
        //                                                                        bindEthenicGroup(function () {
        //                                                                            bindLanguage(function () {
        //                                                                                bindFacialMaster(function () {
        //                                                                                    bindRace(function () {
        //                                                                                        bindEmployment(function () {
        //                                                                                            bindTypeOfReference(function () {
        //                                                                                                _bindPatientDetailsQueryStringWise(function () {
        //                                                                                                    callback(true);
        //                                                                                                });
        //                                                                                            });
        //                                                                                        });
        //                                                                                    });
        //                                                                                });
        //                                                                            });
        //                                                                        });
        //                                                                    });
        //                                                                });
        //                                                            });
        //                                                        });
        //                                                    });
        //                                                });
        //                                            });
        //                                        });
        //                                    });
        //                                });
        //                            });
        //                        });
        //                    });
        //                });
        //            });
        //        });
        //    });
        //});


        configurePageWise(function () {
            configureQueryStringWise(function () {
                configurePatientControlChache(function () {
                    $bindTitle(function () { });
                    $bindDepartment(function (selectedDepartment) {
                        $bindDoctor(selectedDepartment, function () {
                            var URL = window.location.href.split('?')[0];
                            var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

                            if (pageName == 'emergencyadmission.aspx') {
                                $('#ddlDoctor').chosen('destroy').val('<%=Resources.Resource.EmergencyDoctorID_Self%>').chosen();
                                $('#ddlDepartment').chosen('destroy').val('<%=Resources.Resource.CasultyDepartmentID%>').chosen();

                            }
                            else if (pageName == 'ipdadmissionnew.aspx') {
                                $('#ddlDoctor').chosen('destroy').val('<%=Resources.Resource.EmergencyDoctorID_Self%>').chosen();
                                //$('#ddlDepartment').chosen('destroy').val('<%=Resources.Resource.CasultyDepartmentID%>').chosen();
                                $('#ddlDepartment').removeClass('requiredField');

                                 }
                            else {
                                $('#ddlDoctor').chosen('destroy').val('<%=Resources.Resource.DoctorID_Self%>').chosen();
                               $('#ddlDepartment').chosen('destroy').val('<%=Resources.Resource.DepartmentIDSelf%>').chosen();
                            }
                        });
                    });
                    $bindReferDotor(function () { });
                    $bindReferalType(function () { });//
                    $('#ddlReferDoctor').attr("disabled", true).chosen('destroy').chosen();//
                    $bindPRO(function (selectedPROID) { });
                    $bindRelation(function () { });
                    $bindModelRelation(function () { });
                    $bindCountry(function (selectedCountryID) {
                        $bindState(selectedCountryID, function (selectedStateID) {
                            $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
                                $bindCity(selectedStateID, selectedDistrictID, function () {

                                });
                            });
                        });
                    });
                    $bindTuluka(0, function () { });
                    $bindPrequestDepartment(function () { });

                    $bindDocumentMasters(function () { });
                    $bindPatientType(function () { });
                    $bindPatientIDProof(function () { });
                    $bindReligion(function () { });
                    bindEthenicGroup(function () { });
                    bindLanguage(function () { });
                    bindFacialMaster(function () { });
                    bindRace(function () { });
                    bindEmployment(function () { });
                    bindTypeOfReference(function () { });
					$bindPurposeVisit(function () { });
                    _bindPatientDetailsQueryStringWise(function () {
                        callback(true);
                    });

                    lbldocotrtext();
                });
            });
        });
    }

    function lbldocotrtext() {
        var URL = window.location.href.split('?')[0];
        var pageName = URL.split('/')[URL.split('/').length - 1];
 
        if (pageName == "IPDAdmissionNew.aspx") {
            $("#lblDoctortext").text("Doctor / Team")
        } else {
            $("#lblDoctortext").text("Doctor")
        }
         
    }

    var _bindPatientDetailsQueryStringWise = function (callback) {
        var mobileNumber = '<%=Util.GetString(Request.QueryString["mobileNumber"])%>';
        $('#txtMobile').val(mobileNumber).trigger(($.Event('keyup', { keyCode: 13 })));
        callback();
    }


    var configureQueryStringWise = function (callback) {
        var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
        if (isHelpDeskBooking == 1) {
            var doctorID = '<%=Util.GetString(Request.QueryString["doctorId"])%>';
             var centreID = '<%=Util.GetString(Request.QueryString["centreId"])%>';
             $bindDoctorCenterWise(centreID, function () {
                 $('#ddlDoctor').val(doctorID).attr('disabled', true).chosen("destroy").chosen();
                 $('#ddlDepartment').attr('disabled', true).chosen("destroy").chosen();
             });
         }
        callback();
    }

     var configureIDProof = function (required) {
         if (required)
             $('#txtIDProofNo').removeAttr('disabled').addClass('requiredField');
         else
             $('#txtIDProofNo').attr('disabled', true).removeClass('requiredField');
     }

     var $bindDoctorCenterWise = function (centreID, callback) {
         var $ddlDoctor = $('#ddlDoctor');
         serverCall('../common/CommonService.asmx/bindDoctorCentrewise', { CentreID: centreID }, function (response) {
             $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
             callback($ddlDoctor.val());
         });
     }

     var configurePageWise = function (callback) {
         var URL = window.location.href.split('?')[0];
         var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();
            //if (pageName == 'bookdirectappointment.aspx')
            //    $('#ddlIsInterNationPatient').val(2).change();


            //if (pageName == 'lab_prescriptionopd.aspx' || pageName == 'directpatientreg.aspx' || pageName == 'bookdirectappointment.aspx' || pageName == 'opdpackage.aspx') {
            //    var divDemographicDetails = $('#divDemographicDetails');
            //    togglePatientDetailSection(divDemographicDetails, true);
            //    var divEmergencyDetails = $('#divEmergencyDetails');
            //    togglePatientDetailSection(divEmergencyDetails, true);
            //    var divOtherDetails = $('#divOtherDetails');
            //    togglePatientDetailSection(divOtherDetails, true);
            //}

            //if (pageName == 'patientvisitregistration.aspx') {

            //}
            //else
         if (['opdadvance.aspx'].indexOf(pageName) > -1) {
             var useSeparateVisitAndBilling = Number('<%=Resources.Resource.UseSeparateVisitAndBilling%>') == 1 ? true : false;
             var divDemographicDetails = $('#divDemographicDetails');
             togglePatientDetailSection(divDemographicDetails, true);
             var divEmergencyDetails = $('#divEmergencyDetails');
             togglePatientDetailSection(divEmergencyDetails, true);
             var divOtherDetails = $('#divOtherDetails');
             togglePatientDetailSection(divOtherDetails, true);

             if (useSeparateVisitAndBilling) {
                 var _disableControls = $('.divPatientBasicDetails').find('.row:eq(1),.row:eq(2),.row:eq(3),.row:eq(4),.row:eq(5),.row:eq(6),.row:eq(7)');
                 _disableControls.find('input [type=text]').val('');
                 _disableControls.find('input').attr('disabled', true);
                 _disableControls.find('select').attr('disabled', true);
                 $('#txtMobile,#ddlIDProof,#txtIDProofNo,#txtEmailAddress').attr('disabled', false);
             }
         }
        callback();
    }

    var configurePatientControlChache = function (callback) {
        serverCall('../common/CommonService.asmx/CentreWiseCache', {}, function (response) {
            var responseData = JSON.parse(response);
            CentreWiseCache = responseData; //assign to global variables
            callback();
        });
    }

    var $bindDepartment = function (callback) {
        var $ddlDepartment = $('#ddlDepartment');
        // serverCall('../common/CommonService.asmx/bindDepartment', {}, function (response) {
        //$ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
        var DepartmentData = CentreWiseCache.filter(function (i) { return i.TypeID == '2' });
        //$ddlDepartment.bindDropDown({ defaultValue: 'All', data: DepartmentData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: 'All' });
        $ddlDepartment.bindDropDown({ defaultValue: 'Select', data: DepartmentData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: 'Select' });
        callback($ddlDepartment.find('option:selected').text());
        //});
    }


    var $bindDoctor = function (department, callback) {
        var $ddlDoctor = $('#ddlDoctor');
        var ddlSlotDoctors = $('#ddlSlotDoctors');
        // serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
        //var option = {
        //    defaultValue: 'Select',
        //    data: JSON.parse(response),
        //    valueField: 'DoctorID',
        //    textField: 'Name',
        //    isSearchAble: true
        //};
        var DoctorData = [];
        var defaultDoctorName =[];
        if (department.toUpperCase() == "SELECT")
            DoctorData = CentreWiseCache.filter(function (i) { return i.TypeID == '3' });
        else {
            DoctorData = CentreWiseCache.filter(function (i) { return i.TypeID == '3' && i.Department == department });
            defaultDoctorName = CentreWiseCache.filter(function (i) { return i.TypeID == '3' && i.Department == department && i.defaultDoctor==1 });
        }
       

        var option = {
            //defaultValue: $('#ddlDoctor').chosen('destroy').val(defaultDoctorName.ValueField).chosen(),
            data: DoctorData,
            valueField: 'ValueField',
            textField: 'TextField',
            isSearchAble: true
        };

        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

        

        if (pageName == 'bookdirectappointment.aspx')
            ddlSlotDoctors.bindDropDown(option);

        if (defaultDoctorName.length > 0) {

            option.selectedValue = defaultDoctorName[0].ValueField; // $('#ddlDoctor').chosen('destroy').val(defaultDoctorName[0].ValueField).chosen()
        }
        $ddlDoctor.bindDropDown(option);
      

      

        //if (department.toUpperCase() != "ALL") {
          //  $("#ddlDoctor").append($("<option></option>").val(<%=Resources.Resource.DoctorID_Self %>).html("Dr. Self")).val(<%=Resources.Resource.DoctorID_Self %>).chosen("destroy").chosen();
        //}
        callback($ddlDoctor.val());
        // });
    }

    var $bindCountry = function (callback) {
        $('#ddlState,#ddlDistrict,#ddlCity').empty();
        var $ddlCountry = $('#ddlCountry');
        // serverCall('../Common/CommonService.asmx/getCountry', {}, function (response) {
        // $ddlCountry.bindDropDown({ data: JSON.parse(response), valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>', customAttr: ['STD_CODE'] });
         var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '7' });
         $ddlCountry.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>', customAttr: ['STD_CODE'] });

    $ddlInternationalCountry = $('#ddlInternationalCountry');
    // $ddlInternationalCountry.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CountryID', textField: 'Name', isSearchAble: true, customAttr: ['STD_CODE'] });
    $ddlInternationalCountry.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>', customAttr: ['STD_CODE'] });

    var txtLandLineStdCode = $('#txtLandLineStdCode');
    var selectedStdCode = $ddlCountry.find('option:selected').attr('STD_CODE');
    txtLandLineStdCode.val(selectedStdCode);
    $('#txtResidentialStdCode').val(selectedStdCode);
    callback($ddlCountry.val());
    // });
}

        var $bindState = function (countryID, callback) {
            $('#ddlDistrict,#ddlCity').empty();
            var $ddlState = $('#ddlState');
            //  serverCall('../Common/CommonService.asmx/getState', { countryID: countryID }, function (response) {
            // $ddlState.bindDropDown({ data: JSON.parse(response), valueField: 'StateID', textField: 'StateName', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultStateID") %>' });

        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '8' && i.CountryID == countryID });
        $ddlState.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultStateID") %>' });

        callback($ddlState.val());
        //  });
    }

var $bindDistrict = function (countryID, stateID, callback) {
    $('#ddlCity').empty();
    var $ddlDistrict = $('#ddlDistrict');
    // serverCall('../Common/CommonService.asmx/getDistrict', { countryID: countryID, stateID: stateID }, function (response) {
    //   $ddlDistrict.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DistrictID', textField: 'District', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultDistrictID") %>' });

    var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '9' && i.CountryID == countryID && i.StateID == stateID });
    $ddlDistrict.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultDistrictID") %>' });

        callback($ddlDistrict.val());
    // });
}
    var $bindPurposeVisit = function (callback) {

        var $ddlPurposeOfVisit = $('#ddlPurposeOfVisit');
        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '22' });
        $ddlPurposeOfVisit.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true });
        callback($ddlPurposeOfVisit.val());
        // });
    }


            var $bindCity = function (StateID, districtID, callback) {
                var $ddlCity = $('#ddlCity');
                // serverCall('../Common/CommonService.asmx/getCity', { StateID: StateID, districtID: districtID }, function (response) {
                //    $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultCityID") %>' });

        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '10' && i.DistrictID == districtID && i.StateID == StateID });
        $ddlCity.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultCityID") %>' });

                callback($ddlCity.val());
        //  });
    }

            var $bindTuluka = function (districtID, callback) {
                serverCall('../Common/CommonService.asmx/getTaluka', { DistrictID: 0 }, function (response) {
                    var $ddlTaluka = $('#ddlTaluka');
                    $ddlTaluka.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'TalukaID', textField: 'Taluka', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultTaulkaID") %>' });

                    // var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '11' && i.DistrictID == districtID });
                    // $ddlTuluka.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultTaulkaID") %>' });

                    callback(true);
                });
            }
            var $bindPrequestDepartment = function (callback) {
                serverCall('../Common/CommonService.asmx/BindPrequestDeparmtnet', {}, function (response) {
                    var $ddlPRequestDept = $('#ddlPRequestDept');
                    $ddlPRequestDept.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'id', textField: 'NAME', isSearchAble: true });
                     callback(true);
                    });
                }


    var $bindTitle = function (callback) {
        // serverCall('../Common/CommonService.asmx/bindTitleWithGender', {}, function (response) {
        // $ddlTitle.bindDropDown({ data: JSON.parse(response), valueField: 'gender', textField: 'title' });
        var $ddlTitle = $('#ddlTitle');
        var TitleData = CentreWiseCache.filter(function (i) { return i.TypeID == '1' });
        $ddlTitle.bindDropDown({ data: TitleData, valueField: 'ValueField', textField: 'TextField' });
        //callback($($('#ddlTitle').find('option').filter(function () { return this.text == 'Mr.' })[0]).prop('selected', true));
        callback($ddlTitle.val());

        $onTitleChange($ddlTitle);

        // });
    }

    var $bindRelation = function (callback) {
        //$("#txtRelationName").removeClass("requiredField");
        //$('#txtRelationName,#txtRelationPhoneNo').val('').prop('disabled', true);
        // serverCall('../Common/CommonService.asmx/bindRelation', {}, function (response) {
        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '6' });

        var $ddlRelation = $('#ddlRelation');
        var $ddlEmergencyRelation = $('#ddlEmergencyRelation');
        // $ddlRelation.bindDropDown({ data: JSON.parse(response) });
        $ddlRelation.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', selectedValue: 'Self' });
        //  $ddlEmergencyRelation.bindDropDown({ data: JSON.parse(response) });
        $ddlEmergencyRelation.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', selectedValue: 'Self' });
        var $ddlModelRelation = $('#ddlModelrelation');
        // $ddlModelRelation.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response) });
        $ddlModelRelation.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField' });
        callback($ddlEmergencyRelation.val());
        // });
    }

    var $bindModelRelation = function (callback) {
        //serverCall('../Common/CommonService.asmx/bindRelation', {}, function (response) {
        //  var $ddlModelRelation = $('#ddlModelrelation');
        //  $ddlModelRelation.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response) });
        //  callback($ddlModelRelation.val());
        // });
        callback();
    }


    var $bindReferDotor = function (callback) {
        // serverCall('../Common/CommonService.asmx/bindReferDoctor', {}, function (response) {
        $ddlReferDoctor = $('#ddlReferDoctor');
        //  $ddlReferDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '4' });
        $ddlReferDoctor.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true });
        callback($ddlReferDoctor.val());
        
        // });
    }

    var $bindReferalType = function (callback) {
        $ddlReferalType = $('#ddlReferalType');
        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '21' });
        $ddlReferalType.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '1#0#1' });
        callback($ddlReferalType.val());
    }

    function BindDoctorOrReferalDoc() {
        var value = $('#ddlReferalType option:selected').val();
        var text = $('#ddlReferalType option:selected').text();
        var v = value.split("#");

        if (v[2] == 1) {
            $("#ddlReferDoctor").prop("selectedIndex", 0).attr('disabled', true).chosen("destroy").chosen();
        }
        else {
            $("#ddlReferDoctor").attr('disabled', false).chosen('destroy').chosen();
        }

        if (text == "Out" || text == "Walk-In") {
            $("#btnRefferBy").show();
        }
        else { $("#btnRefferBy").hide(); }

        if (text == "IN" || text == "Out") {
            if (v[1] == 1) {
                $BindMainDoctor(function () { });//
            }
            else {
                $bindReferDotor(function () { });
            }
        }
        else if (text == "Self") {
            if (v[1] == 1) {
                $BindMainDoctor(function () {
                    $("#ddlReferDoctor").val($("#ddlDoctor option:selected").val()).attr('disabled', true).chosen('destroy').chosen();
                });//
            }
            else {
                $bindReferDotor(function () { });
            }
        }
    }

    var $BindMainDoctor = function (callback) {
        var department = $("#ddlDepartment option:selected").text();
        var $ddlDoctor = $('#ddlReferDoctor');
        var DoctorData = [];
        if (department.toUpperCase() == "ALL")
            DoctorData = CentreWiseCache.filter(function (i) { return i.TypeID == '3' });
        else
            DoctorData = CentreWiseCache.filter(function (i) { return i.TypeID == '3' && i.Department == department });

        var option = {
            defaultValue: 'Select',
            data: DoctorData,
            valueField: 'ValueField',
            textField: 'TextField',
            isSearchAble: true
        };

        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

        if (pageName == 'emergencyadmission.aspx')
            option.selectedValue = '<%=Resources.Resource.DoctorID_Self %>'

        $ddlDoctor.bindDropDown(option);
        callback($ddlDoctor.val());
    }


    var getPRODetails = function (referDoctorID, callback) {
        // serverCall('../Common/CommonService.asmx/bindPRO', { referDoctorID: referDoctorID }, function (response) {
        //      callback(JSON.parse(response));
        // });
        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '5' });
        callback(responseData);
    }


    var $bindPRO = function (callback) {
        getPRODetails(0, function (response) {
            $ddlPROName = $('#ddlPROName');
            // $ddlPROName.bindDropDown({ defaultValue: 'Select', data: (response), valueField: 'Pro_ID', textField: 'ProName', isSearchAble: true });
            $ddlPROName.bindDropDown({ defaultValue: 'Select', data: (response), valueField: 'ValueField', textField: 'TextField', isSearchAble: true });
            callback($ddlPROName.val());
        });
    }


    var bindReferDoctorPRO = function (callback) {
        getPRODetails('', function (response) {
            $ddlReferDoctorPro = $('#ddlReferDoctorPro');
            $ddlReferDoctorPro.bindDropDown({ defaultValue: 'Select', data: (response), valueField: 'ValueField', textField: 'TextField', isSearchAble: true });
            callback($ddlReferDoctorPro.val());
        });
    }

    var bindPROAccordingToReferDoctorID = function (selectedReferDoctor) {
        getPRODetails(selectedReferDoctor, function (response) {
            $ddlPROName = $('#ddlPROName');
            var option = { defaultValue: 'Select', data: (response), valueField: 'ValueField', textField: 'TextField', isSearchAble: true };
            // if (response.length < 1)
            //     option.defaultValue = 'Select';

            $ddlPROName.bindDropDown(option);

        })

    }


    var $bindPatientType = function (callback) {
        //  serverCall('../Common/CommonService.asmx/GetPatientType', {}, function (response) {
        $ddlPatientType = $('#ddlPatientType');
        //   $ddlPatientType.bindDropDown({ data: JSON.parse(response), valueField: 'id', textField: 'PatientType', isSearchAble: false });
        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '12' });
        $ddlPatientType.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '1' });

        callback($ddlPatientType.val());
        //  });
    }


    var $bindRegistrationCharges = function (callback) {
        getPatientBasicDetails(function (patientDetails) {
            var data = {
                PanelID: $('#ddlPanelCompany').val().split('#')[0],
                ItemID: '<%=Resources.Resource.RegistrationItemID%>',
                                TID: '',
                                IPDCaseTypeID: '',
                                panelCurrencyFactor: patientDetails.panelCurrencyFactor
                            }
                            serverCall('../Common/CommonService.asmx/bindLabInvestigationRate', data, function (response) {
                                if (!String.isNullOrEmpty(response)) {
                                    var responseData = JSON.parse(response);
                                    $('#spanRegistrationCharges').attr('ScheduleChargeID', responseData[0].ScheduleChargeID).text(parseFloat(responseData[0].Rate));
                                    callback();
                                }
                                else {
                                    $('#spanRegistrationCharges').text('0');
                                    // modelAlert('Error In Registration Charges', function (response) {
                                    callback();
                                    // });
                                }
                            });
                        });
                    }

                    var $bindPatientIDProof = function (callback) {
                        // serverCall('../Common/CommonService.asmx/BindPatientIDProof', {}, function (response) {
                        var $ddlIDProof = $('#ddlIDProof');
                        //   $ddlIDProof.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'IDProofName' });

                        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '13' });
                        $ddlIDProof.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField' });

                      //  $ddlIDProof.attr('disabled', 'disabled');
                        callback(true);
                        // });
                    }

                    var $bindReligion = function (callback) {
                        // serverCall('../Common/CommonService.asmx/BindReligion', {}, function (response) {
                        var $ddlReligion = $('#ddlReligion');
                        //   $ddlReligion.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'religionId', textField: 'ReligionName' });
                        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '14' });
                        $ddlReligion.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField' });

                        callback(true);
                        //});
                    }



                    var bindEthenicGroup = function (callback) {
                        // serverCall('../Common/CommonService.asmx/GetEthenicGroup', {}, function (response) {
                        var _ddlEthenicGroup = $('#ddlEthenicGroup');
                        //  _ddlEthenicGroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'EthenicGroup' });
                        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '15' });
                        _ddlEthenicGroup.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField' });

                        callback(_ddlEthenicGroup.val());
                        // });
                    }


                    var bindLanguage = function (callback) {
                        // serverCall('../Common/CommonService.asmx/GetLanguage', {}, function (response) {
                        var _ddlLanguage = $('#ddlLanguage');
                        //    _ddlLanguage.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Language' });
                        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '16' });
                        _ddlLanguage.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '1' });
                        callback(_ddlLanguage.val());
                        // });
                    }

                    var bindFacialMaster = function (callback) {
                        //  serverCall('../Common/CommonService.asmx/GetFacialStatus', {}, function (response) {
                        var _ddlFacialStatus = $('#ddlFacialStatus');
                        //   _ddlFacialStatus.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'FacialStatus' });

                        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '17' });
                        _ddlFacialStatus.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField' });

                        callback(_ddlFacialStatus.val());
                        // });
                    }



                    var bindRace = function (callback) {
                        // serverCall('../Common/CommonService.asmx/GetRace', {}, function (response) {
                        var _ddlRace = $('#ddlRace');
                        //    _ddlRace.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Race' });
                        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '18' });
                        _ddlRace.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField' });
                        callback(_ddlRace.val());
                        // });
                    }


                    var bindEmployment = function (callback) {
                        // serverCall('../Common/CommonService.asmx/GetEmployment', {}, function (response) {
                        var _ddlEmployment = $('#ddlEmployment');
                        //  _ddlEmployment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Employment' });
                        var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '19' });
                        _ddlEmployment.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ValueField', textField: 'TextField' });
                        callback(_ddlEmployment.val());
                        //});
                    }



                    $getRegistrationCharges = function (callback) {
                        var registrationDetails = {
                            registrationCharge: Number($('#spanRegistrationCharges').text()),
                            ScheduleChargeID: $('#spanRegistrationCharges').attr('ScheduleChargeID')
                        }
                        callback(registrationDetails)
                    }

                    var $onRelationChange = function (relation) {

                        if (relation == 'Self') {
                           // $("#txtRelationName").removeClass("requiredField");
                            $('#txtRelationName,#txtRelationPhoneNo').val('').prop('disabled', true);
                        }
                        else {
                           // $("#txtRelationName").addClass("requiredField");
                            $('#txtRelationName,#txtRelationPhoneNo').val('').prop('disabled', false);
                        }
                    }


                    var $onModelRelationChange = function (relation) {
                        if (relation == '0')
                            $('#txtModelRelationName').val('').prop('disabled', true);
                        else
                            $('#txtModelRelationName').val('').prop('disabled', false);
                    }

                  var $onCountryChange = function (selectedCountryID) {
                      var txtLandLineStdCode = $('#txtLandLineStdCode');
                      var selectedStdCode = $('#ddlCountry').find('option:selected').attr('STD_CODE');
                      txtLandLineStdCode.val(selectedStdCode);
                      $bindState(selectedCountryID, function (selectedStateID) {
                          $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
                              $bindCity(selectedStateID, selectedDistrictID, function () { });
                              //$bindTuluka(selectedDistrictID, function () { });
                          });
                      });
                  }


                  var $onInternationalCountryChange = function (el) {
                      var txtLandLineStdCode = $('#txtResidentialStdCode');
                      var selectedStdCode = $(el).find('option:selected').attr('STD_CODE');
                      txtLandLineStdCode.val(selectedStdCode);
                  }


                  var $onStateChange = function (selectedCountryID, selectedStateID) {
                      $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
                          $bindCity(selectedStateID, selectedDistrictID, function () { });
                          // $bindTuluka(selectedDistrictID, function () { });
                      });
                  }

                  var $onDistrictChange = function (selectedStateID, selectedDistrictID) {
                      $bindCity(selectedStateID, selectedDistrictID, function () { });
                      // $bindTuluka(selectedDistrictID, function () { });
                  }


                    var onDoctorChange = function (el, event) {
                        if ($.isFunction(window['_onUserControlDoctorChange']))
                            _onUserControlDoctorChange(el, event, function () { });

                        var rftypeValue = $("#ddlReferalType option:selected").val();//
                        var rftypeText = $("#ddlReferalType option:selected").text();

                        if (rftypeText == "Self") {
                            var v = rftypeValue.split("#");
                            if (v[1] == 1) {
                                $("#ddlReferDoctor").val($('#ddlDoctor option:selected').val()).chosen('destroy').chosen();//
                            }
                        }
                    }





                    $addNewStateModel = function () {
                        $countryID = $('#ddlCountry').val();
                        if ($countryID == '0' || $countryID == '') {
                            modelAlert('Select Country First');
                            return;
                        }
                        $('#divAddState').showModel();
                    }

                  $addNewDistrictModel = function () {
                      $countryID = $('#ddlCountry').val();
                      if ($countryID == '0' || $countryID == '') {
                          modelAlert('Select Country First');
                          return;
                      }
                      $ddlState = $('#ddlState').val();
                      if ($ddlState == '0' || $ddlState == '') {
                          modelAlert('Select State First');
                          return;
                      }
                      $('#divAddDistrict').showModel();
                  }

                  $addNewPerposeOfVisit = function () {
                      $('#divAddPurposeOfVisit').showModel();
                  }




                  $addNewCityModel = function () {
                      $countryID = $('#ddlCountry').val();
                      if ($countryID == '0' || $countryID == '') {
                          modelAlert('Select Country First');
                          return;
                      }
                      $ddlState = $('#ddlState').val();
                      if ($ddlState == '0' || $ddlState == '') {
                          modelAlert('Select County First');
                          return;
                      }
                      $ddlDistrict = $('#ddlDistrict').val();
                      if ($ddlDistrict == '0' || $ddlDistrict == '') {
                          modelAlert('Select District First');
                          return;
                      }
                      $('#divAddCity').showModel();
                  }

                    $addNewDoctorReferModel = function () {
                        //if($('#ddlPROName').val()!="0")
                        //{
                        //    $('#divAddReferDoctor input[type=text],#divAddReferDoctor textarea').val('')
                        //    $('#divAddReferDoctor').showModel();
                        //}
                        //else{
                        //    modelAlert('Select PRO Name First');
                        //    return false;
                        //}
                        //if($('#ddlPROName').val()!="0")
                        //{
                        //    $('#divAddReferDoctor input[type=text],#divAddReferDoctor textarea').val('')
                        //    $('#divAddReferDoctor').showModel();
                        //}
                        //else{
                        //    modelAlert('Select PRO Name First');
                        //    return false;
                        //}
                        bindReferDoctorPRO(function () {
                            $('#divAddReferDoctor input[type=text],#divAddReferDoctor textarea').val('')
                            $('#divAddReferDoctor').showModel();
                        });


                    }
                    $addNewPROModel = function () {
                        $('#divAddPRO input[type=text]').val('')
                        $('#divAddPRO').showModel();
                    }
                    $saveNewState = function (stateDetails) {
                        if (stateDetails.StateName.trim() != '') {
                            serverCall('../Common/CommonService.asmx/StateInsert', { CountryID: stateDetails.CountryID, StateName: stateDetails.StateName }, function (response) {
                                var $stateId = parseInt(response);
                                if ($stateId == 0)
                                    modelAlert('State Already Exist');
                                else if ($stateId > 0) {
                                    $('#divAddState').closeModel();
                                    modelAlert('State Saved Successfully');
                                    configurePatientControlChache(function () {
                                        $bindState($("#ddlCountry option:selected").val(), function () {
                                            $("#ddlState").append($("<option></option>").val($stateId).html(stateDetails.StateName)).val($stateId).chosen("destroy").chosen();
                                        });
                                    });
                                    
                                }
                            });
                        }
                        else
                            modelAlert('Enter State Name');
                    }






                  $saveNewDistrict = function (districtDetails) {
                      if (districtDetails.District.trim() != '') {
                          serverCall('../Common/CommonService.asmx/DistrictInsert', { District: districtDetails.District, countryID: districtDetails.countryID, stateID: districtDetails.stateID }, function (response) {
                              var $districtId = parseInt(response);
                              if ($districtId == 0)
                                  modelAlert('District Already Exist');
                              else if ($districtId > 0) {
                                  $('#divAddDistrict').closeModel();
                                  modelAlert('District Saved Successfully');
                                  configurePatientControlChache(function () {
                                      $bindDistrict($("#ddlCountry option:selected").val(), $("#ddlState option:selected").val(), function () {
                                          $("#ddlDistrict").append($("<option></option>").val($districtId).html(districtDetails.District)).val($districtId).chosen("destroy").chosen();
                                      });
                                  });

                              }
                          });
                      }
                      else
                          modelAlert('Enter District Name');
                  }

                  $saveNewPurposeOfVisit = function (VisitDetails) {
                      if (VisitDetails.PurposeName.trim() != '') {
                          serverCall('../Common/CommonService.asmx/PurposeOfVisitInsert', { VisitName: VisitDetails.PurposeName }, function (response) {
                              var $VisitId = parseInt(response);
                              if ($VisitId == 0)
                                  modelAlert('Visit Already Exist');
                              else if ($VisitId > 0) {
                                  $('#divAddPurposeOfVisit').closeModel();
                                  modelAlert('Visit Saved Successfully');
                                  configurePatientControlChache(function () {
                                      $bindPurposeVisit(function () {
                                          $("#ddlPurposeOfVisit").append($("<option></option>").val($VisitId).html(VisitDetails.PurposeName)).val($VisitId).chosen("destroy").chosen();
                                      });
                                  });

                              }
                          });
                      }
                      else
                          modelAlert('Enter District Name');
                  }


                    $saveNewCity = function (cityDetails) {
                        if (cityDetails.City.trim() != '') {
                            serverCall('../Common/CommonService.asmx/CityInsert', { City: cityDetails.City, Country: cityDetails.Country, StateID: cityDetails.StateID, DistrictID: cityDetails.DistrictID }, function (response) {
                                $cityId = parseInt(response);
                                if ($cityId == 0)
                                    modelAlert('City Already Exist');
                                else if ($cityId > 0) {
                                    $('#divAddCity').closeModel();
                                    modelAlert('City Saved Successfully');
                                    configurePatientControlChache(function () {
                                        $bindCity($("#ddlState option:selected").val(), $("#ddlDistrict option:selected").val(), function () {
                                            $("#ddlCity").append($("<option></option>").val($cityId).html(cityDetails.City)).val($cityId).chosen("destroy").chosen();
                                        });
                                    });
                                    
                                }
                            });
                        }
                        else
                            modelAlert('Enter City Name');
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
                                 configurePatientControlChache(function () {
                                        $bindReferDotor(function () { });
                                    });
                                });
                            }
                            else
                                modelAlert('Error occurred, Please contact administrator');
                        });


                    }

                    $savePRO = function (PRODetails) {
                        if (PRODetails.Name.trim() == '') {
                            modelAlert('Enter PRO Name');
                            return false;
                        }
                        serverCall('../EDP/Services/EDP.asmx/SavePro', { ProName: PRODetails.Name }, function (response) {
                            $responseData = parseInt(response);
                            if ($responseData == 'E')
                                modelAlert('PRO Already Exist');
                            else if ($responseData != '0') {
                                $('#divAddPRO').closeModel();
                                modelAlert('PRO Saved Successfully', function (response) {
                                    configurePatientControlChache(function () {
                                        $bindPRO(function (response) { });
                                    });
                                });
                            }
                            else
                                modelAlert('Error occurred, Please contact administrator');
                        });
                    }


                    var bindTypeOfReference = function (callback) {
                        serverCall('../Common/CommonService.asmx/GetTypeOfReference', {}, function (response) {
                            var responseData = JSON.parse(response);
                            var ddlReferenceType = $('#ddlReferenceType');
                            ddlReferenceType.bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ID', textField: 'TypeOfReference', isSearchAble: true });
                            callback(ddlReferenceType.val());
                        });
                    }

                    var onCreateNewtypeOfReferenceModelOpen = function () {
                        var divNewTypeOfReference = $('#divNewTypeOfReference');
                        divNewTypeOfReference.find('#txtNewTypeOfReference').val('');
                        divNewTypeOfReference.showModel();
                    }


                    var onCreateNewtypeOfReferenceModelClose = function () {
                        bindTypeOfReference(function () {
                            var divNewTypeOfReference = $('#divNewTypeOfReference');
                            divNewTypeOfReference.closeModel();
                        });
                    }

                    var createTypeOfReference = function () {
                        var txtNewTypeOfReference = $('#txtNewTypeOfReference');
                        var typeOfReference = $.trim(txtNewTypeOfReference.val());

                        if (String.isNullOrEmpty(typeOfReference)) {
                            modelAlert('Please Enter Reference Type', function () {
                                txtNewTypeOfReference.focus();
                            });
                        }


                        serverCall('../Common/CommonService.asmx/CreateTypeOfReference', { typeOfReference: typeOfReference }, function (response) {
                            var responseData = JSON.parse(response);
                            if (responseData.status) {
                                onCreateNewtypeOfReferenceModelClose();
                            }
                            else {
                                modelAlert(responseData.message);
                            }
                        });
                    }


                    var $getDoctorDetails = function (callback) {
                        var $ddlDepartment = $('#ddlDepartment');
                        var $ddlDoctor = $('#ddlDoctor');
                        if ($.trim($ddlDoctor.val()) == '')
                            modelAlert('Please Select Doctor Name');
                        else
                            callback({ doctorID: $ddlDoctor.val(), doctorName: $ddlDoctor.find('option:selected').text() });
                    }

                    var $getPatientDetails = function (callback) {
                        var validateStatus = true;
                        $('#PatientDetails .requiredField').each(function (index, elem) {
                            if ($.trim($(elem).val()) == '' || $.trim($(elem).val()) == '0') {
                                if ($.trim($(elem).val()) == 0 && $('#ddlAge').val() != 'DAYS(S)') {
                                    validateStatus = false;
                                    modelAlert(this.attributes['errorMessage'].value, function () { });
                                    return false;
                                }
                            }
                        });

                        $gender = $('input[type=radio][name=sex]:checked').val();
                        if (String.isNullOrEmpty($gender)) {
                            modelAlert('Please Select Gender');
                            return false;
                        }

                        if (parseInt($('#txtDOB').val().length) > 1 && parseInt($('#txtDOB').val().length) < 10) {
                            modelAlert('Invalid DOB', function () {
                                $(sender).val('').focus();
                            });

                                return false;
                            }
                        //by indra prakash
                          var page = $("#txtPage").val();
                          if (page != "EmergencyAdmission") {

                        var _txtMobile = $('#txtMobile');
                        var mobileNO = $.trim(_txtMobile.val());
                        if (mobileNO.length < 10) {
                            modelAlert('Please Enter Complete Mobile No.', function () {
                                $(_txtMobile).focus();
                            });
                            return false;
                        }
                        }

                        $email = $('#txtEmailAddress').val();
                        //$emailexp = /^[a-zA-Z\-0-9](([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\-\].,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z0-9](?:[a-zA-Z0-9]|-(?!-))*\.)+[a-zA-Z]{2,}))$/gm;
                        $emailexp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                        if (($emailexp.test($email) == false) && ($email != '')) {
                            modelAlert('Please Enter Valid Email Address');
                            return false;
                        }

                        if ($('#txtIDProofNo').hasClass('requiredField')) {
                            var $txtIDProofNo = $('#txtIDProofNo');
                            var $ddlIDProofID = $("#ddlIDProof");
                            if ($txtIDProofNo.val().length > 0) {
                                if ($txtIDProofNo.val().length < $ddlIDProofID.val().split('#')[1]) {
                                    modelAlert('Please Enter Valid ' + $ddlIDProofID.find(':selected').text() + ' Number', function () {
                                        $txtIDProofNo.focus();
                                    });
                                    return false;
                                }
                                else if ($txtIDProofNo.val().length = $ddlIDProofID.val().split('#')[1]) {
                                    $appendPatientIDProof(false, [{ IDProofID: $ddlIDProofID.val().split('#')[0].trim(), IDProofName: $ddlIDProofID.find(':selected').text().trim(), IDProofNumber: $txtIDProofNo.val().trim() }], function () { });
                                }
                            }
                            if ($('#divIDProof>ul>li').length == 0) {
                                modelAlert('Please Add Valid ' + $ddlIDProofID.find(':selected').text() + ' Number', function () {
                                    $txtIDProofNo.focus();
                                });
                                return false;
                            }
                        }
                        $DOB = '0001-01-01';
                        $MODELDOB = '0001-01-01';
                        if ($('#txtDOB').val() != '')
                            $DOB = $.datepicker.formatDate('dd-M-yy', new Date($('#txtDOB').val().split('-')[2] + '-' + $('#txtDOB').val().split('-')[1] + '-' + $('#txtDOB').val().split('-')[0]));
                        if ($('#txtModelDOB').val() != '')
                            $MODELDOB = $.datepicker.formatDate('dd-M-yy', new Date($('#txtModelDOB').val().split('-')[2] + '-' + $('#txtModelDOB').val().split('-')[1] + '-' + $('#txtModelDOB').val().split('-')[0]));

                      var referdoc;
                      var reftype = $("#ddlReferalType option:selected").text();

                      if (reftype == "IN" || reftype == "Self") {
                          referdoc = $('#ddlReferDoctor option:selected').val();
                      }
                      else {
                          referdoc = $('#ddlReferDoctor option:selected').text();
                      }

                      var reftypeValue = $("#ddlReferalType option:selected").val();
                      var refval = reftypeValue.split("#");
                      var refvalue = refval[0];

                      if (callback != undefined && validateStatus) {
                          validateDuplicatePatientEntry(function (res) {
                              $getPanelDetails(function (panelDetails) {
                                  $getPatientIDProofs(function (patientIDProofs) {
                                      getUpdatedPatientDocuments(function (patientDocuments) {
                                          var patientID = $.trim($('#txtPID').val());
                                          var patientDetails = {
                                              PatientID: $.trim($('#txtPID').val()),
                                              OldPatientID: '',
                                              IsNewPatient: String.isNullOrEmpty(patientID) ? 1 : 0,
                                              Title: { value: $('#ddlTitle option:selected').text(), text: $('#ddlTitle option:selected').text() },
                                              PFirstName: $('#txtPFirstName').val(),
                                              PLastName: $('#txtPLastName').val(),
                                              PName: $('#txtPFirstName').val() + ' ' + $('#txtPMiddleName').val() + ' ' + $('#txtPLastName').val(),
                                              Gender: $gender,
                                              DOB: $DOB,
                                              Age: $('#txtAge').val() + ' ' + $('#ddlAge').val(),
                                              Mobile: $('#txtMobile').val(),
                                              EmergencyPhoneNo: '',
                                              Email: $email,
                                              House_No: $('#txtAddress').val(),
                                              Address: $('#txtAddress').val(),
                                              Country: { value: $('#ddlCountry').val(), text: $('#ddlCountry option:selected').text() },

                                              // According to Ankur Sir
                                              // State: { value: $('#ddlState').val(), text: $('#ddlState option:selected').text() },
                                              State: { value: '0', text: '' },
                                              City: { value: $('#ddlCity').val(), text: $('#ddlCity option:selected').text() },
                                              District: { value: $('#ddlDistrict').val(), text: $('#ddlDistrict option:selected').text() },
                                              // Taluka: { value: $('#ddlTaluka').val(), text: $('#ddlTaluka option:selected').text() },
                                              HospPatientType: { value: $('#ddlPatientType').val(), text: $('#ddlPatientType option:selected').text() },
                                              PatientType: { value: $('#ddlPatientType').val(), text: $('#ddlPatientType option:selected').text() },
                                              Doctor: { value: $('#ddlDoctor').val(), text: $('#ddlDoctor option:selected').text() },
                                              ReferedBy: referdoc != 'Select' ? referdoc : '',   //$('#ddlReferDoctor').val() != '0' ? $('#ddlReferDoctor option:selected').text() : '',
                                              PROID: $('#ddlPROName option:selected').val(),
                                              ParentID: panelDetails.parentPanel.panelID,
                                              PanelID: panelDetails.panel.panelID,
                                              LandMark: '',
                                              PinCode: '',
                                              Locality: $('#txtPlace').val(),
                                              Place: $('#txtPlace').val(),
                                              MaritalStatus: { value: $('#ddlMarried').val(), text: $('#ddlMarried option:selected').text() },
                                              Relation: { value: $('#ddlRelation').val(), text: $('#ddlRelation option:selected').val() },
                                              RelationName: $('#txtRelationName').val(),
                                              RelationPhoneNo: $('#txtRelationPhoneNo').val(),
                                              base64PatientProfilePic: $('#imgPatient').prop('src'),
                                              isCapTure: $('#spnIsCapTure').text(),
                                              DateEnrolled: $('#spnDateEnrolled').text(),
                                              patientDocuments: patientDocuments,
                                              PatientIDProofs: patientIDProofs,
                                              panelDetails: panelDetails,
                                              FeesPaid: $('#spanRegistrationCharges').text() == 0 ? 0 : 1,
                                              Religion: $("#ddlReligion option:selected").text(),
                                              languageSpoken: { value: $('#ddlLanguage').val(), text: $('#ddlLanguage option:selected').text() },
                                              occupation: $('#txtOccupation').val(),
                                              identificationMark: $('#txtIdentityMark').val(),

                                                placeOfBirth: $('#txtPlaceOfBirth').val(),
                                                isInternational: { value: $('#ddlIsInterNationPatient').val(), text: $('#ddlIsInterNationPatient option:selected').text() },
                                                overSeaNumber: $('#txtOverSeaNumber').val(),
                                                ethenicGroup: { value: $('#ddlEthenicGroup').val(), text: $('#ddlEthenicGroup option:selected').text() },
                                                isTranslatorRequired: { value: $('#ddlTranslatorRequired').val(), text: $('#ddlTranslatorRequired option:selected').text() },
                                                facialStatus: { value: $('#ddlFacialStatus').val(), text: $('#ddlFacialStatus option:selected').text() },
                                                race: { value: $('#ddlRace').val(), text: $('#ddlRace option:selected').text() },
                                                employement: { value: $('#ddlEmployment').val(), text: $('#ddlEmployment option:selected').text() },
                                                monthlyIncome: Number($('#txtMonthlyIncome').val()),
                                                parmanentAddress: $('#txtParmanentAddress').val(),
                                                identificationMarkSecond: $('#txtIdentityMarkSecond').val(),
                                                emergencyPhoneNo: $('#txtEmergencyNumber').val(),
                                                visitID: $.trim($('#txtVisitId').attr('visitID')),
                                                languageSpoken: { value: $('#ddlLanguage').val(), text: $('#ddlLanguage option:selected').text() },
                                                emergencyRelationOf: { value: $('#ddlEmergencyRelation').val(), text: $('#ddlEmergencyRelation option:selected').text() },

                                              Remark: $.trim($('#txtremarks').val()),

                                              phoneSTDCODE: $.trim($('#txtLandLineStdCode').val()),
                                              phone: $.trim($('#txtLandLineNo').val()),
                                              residentialNumber: $.trim($('#txtResidentialNumber').val()),
                                              residentialNumberSTDCODE: $.trim($('#txtResidentialStdCode').val()),
                                              emergencyFirstName: $.trim($('#txtEmergencyFirstName').val()),
                                              emergencySecondName: $.trim($('#txtEmergencySecondName').val()),
                                              emergencyAddress: $.trim($('#txtEmergencyAddress').val()),
                                              internationalCountry: { value: $.trim($('#ddlInternationalCountry').val()), text: $.trim($('#ddlInternationalCountry option:selected').text()) },
                                              internationalNumber: $.trim($('#txtInternationalNumber').val()),
                                              typeOfReference: { value: $.trim($('#ddlReferenceType').val()), text: $.trim($('#ddlReferenceType option:selected').text()) },
                                              panelDocuments: panelDetails.panelDocuments,
                                              CorporatePanelID: panelDetails.Corporatepanel.CorporatepanelID,   //
                                              StaffDependantID: $('#txtTypeRefernce').val(), //
                                              StateID: $('#ddlState').val(),  //
                                              State: $('#ddlState option:selected').text(),  //
                                              ReferralTypeID: refvalue,
                                              PMiddleName: $('#txtPMiddleName').val(),
                                              EmergencyPhone: $('#txtRelationPhoneNo').val(),//
                                              Taluka: { value: $('#ddlTaluka').val(), text: $('#ddlTaluka option:selected').val() == 1 ? $('#txtOtherVillage').val() : $('#ddlTaluka option:selected').text() },
                                              PurposeOfVisit: { value: $('#ddlPurposeOfVisit').val(), text: $.trim($('#ddlPurposeOfVisit option:selected').text()) },
                                              PRequestDept: $('#ddlPRequestDept').val(),
                                              SecondMobileNo: $('#txtSecondMobile').val(),
                                              FamilyNumber: $('#txtFamilyNumber').val()
                                              

                                          }

                                            patientDetails.emergencyRelationName = patientDetails.emergencyFirstName + ' ' + patientDetails.emergencySecondName;

                                            Object.keys(patientDetails).forEach(function (k, e) {
                                                if (typeof (patientDetails[k]) === 'object') {
                                                    if (patientDetails[k]['value'] == '0')
                                                        patientDetails[k]['text'] = '';
                                                }
                                            });

                                            createDefaultPatientMaster(patientDetails, function (d) {
                                                patientDetails.defaultPatientMaster = d.defaultPatientMaster;
                                                patientDetails.defaultPatientMedicalHistory = d.defaultMedicalHistory;
                                                callback(patientDetails);
                                            });
                                        });
                                    });
                                });
                            });
                        }
                    }



                  var createDefaultPatientMaster = function (patientDetails, callback) {
                      var patientMaster = {
                          PatientID: patientDetails.PatientID,
                          IsNewPatient: patientDetails.IsNewPatient,
                          OldPatientID: patientDetails.OldPatientID,
                          Title: patientDetails.Title.value,
                          PFirstName: patientDetails.PFirstName,
                          PLastName: patientDetails.PLastName,
                          PName: patientDetails.PName,
                          Age: patientDetails.Age,
                          DOB: patientDetails.DOB,
                          Gender: patientDetails.Gender,
                          PanelID: patientDetails.PanelID,
                          MaritalStatus: patientDetails.MaritalStatus.text,
                          Mobile: patientDetails.Mobile,
                          Email: patientDetails.Email,
                          Relation: patientDetails.Relation.text,
                          RelationName: patientDetails.RelationName,
                          House_No: patientDetails.House_No,
                          Country: patientDetails.Country.text,
                          StateID: 0,
                          District: patientDetails.District.text,
                          City: patientDetails.City.text,
                          Taluka: patientDetails.Taluka.text,
                          CountryID: patientDetails.Country.value,
                          DistrictID: patientDetails.District.value,
                          CityID: patientDetails.City.value,
                          TalukaID: patientDetails.Taluka.value,
                          Place: patientDetails.Place,
                          LandMark: patientDetails.LandMark,
                          Occupation: patientDetails.occupation,
                          AdharCardNo: patientDetails.AdharCardNo,
                          HospPatientType: patientDetails.HospPatientType.text,
                          PatientType: patientDetails.PatientType.text,
                          isCapTure: patientDetails.isCapTure,
                          base64PatientProfilePic: patientDetails.base64PatientProfilePic,
                          PatientIDProofs: patientDetails.PatientIDProofs,
                          FeesPaid: patientDetails.FeesPaid,
                          Religion: patientDetails.Religion,
                          CategoryID: patientDetails.CategoryID,
                          EmergencyPhoneNo: patientDetails.emergencyPhoneNo,
                          PlaceOfBirth: patientDetails.placeOfBirth,
                          IdentificationMark: patientDetails.identificationMark,
                          IsInternational: patientDetails.isInternational.value,
                          OverSeaNumber: patientDetails.overSeaNumber,
                          EthenicGroup: patientDetails.ethenicGroup.text,
                          IsTranslatorRequired: patientDetails.isTranslatorRequired.value,
                          FacialStatus: patientDetails.facialStatus.text,
                          Race: patientDetails.race.text,
                          Employement: patientDetails.employement.text,
                          MonthlyIncome: patientDetails.monthlyIncome,
                          ParmanentAddress: patientDetails.parmanentAddress,
                          IdentificationMarkSecond: patientDetails.identificationMarkSecond,
                          visitID: patientDetails.visitID,
                          EmergencyRelationOf: patientDetails.emergencyRelationOf.value,
                          EmergencyRelationName: patientDetails.emergencyRelationName,
                          LanguageSpoken: patientDetails.languageSpoken.text,
                          Locality: patientDetails.Locality,
                          PhoneSTDCODE: patientDetails.phoneSTDCODE,
                          ResidentialNumber: patientDetails.residentialNumber,
                          ResidentialNumberSTDCODE: patientDetails.residentialNumberSTDCODE,
                          EmergencyFirstName: patientDetails.emergencyFirstName,
                          EmergencySecondName: patientDetails.emergencySecondName,
                          InternationalCountryID: patientDetails.internationalCountry.value,
                          InternationalCountry: patientDetails.internationalCountry.text,
                          InternationalNumber: patientDetails.internationalNumber,
                          Phone: patientDetails.phone,
                          EmergencyAddress: patientDetails.emergencyAddress,
                          Remark: patientDetails.Remark,
                          StaffDependantID: patientDetails.StaffDependantID,
                          StateID: patientDetails.StateID,
                          State: patientDetails.State,
                          PMiddleName: patientDetails.PMiddleName,
                          EmergencyPhone: patientDetails.EmergencyPhone,
                          PurposeOfVisit: patientDetails.PurposeOfVisit.text,
                          PurposeOfVisitID: patientDetails.PurposeOfVisit.value,
                          PRequestDept: patientDetails.PRequestDept,
                          SecondMobileNo: patientDetails.SecondMobileNo,
                          LastFamilyUHIDNumber: patientDetails.FamilyNumber
                          

                        };

                        patientMedicalHistory = {
                            DoctorID: patientDetails.Doctor.value,
                            PanelID: patientDetails.PanelID,
                            ParentID: patientDetails.ParentID,
                            Purpose: '',
                            ReferedBy: patientDetails.ReferedBy,
                            ProId: patientDetails.PROID,
                            patient_type: patientDetails.PatientType.text,
                            PolicyNo: patientDetails.panelDetails.policyNo,
                            PanelIgnoreReason: patientDetails.panelDetails.ignorePolicyReason,
                            ExpiryDate: patientDetails.panelDetails.expireDate,
                            EmployeeDependentName: patientDetails.panelDetails.nameOnCard,
                            CardNo: patientDetails.panelDetails.cardNo,
                            CardHolderName: patientDetails.panelDetails.nameOnCard,
                            RelationWith_holder: patientDetails.panelDetails.cardHolderRelation,
                            KinRelation: patientDetails.Relation.text,
                            KinName: patientDetails.RelationName,
                            KinPhone: patientDetails.RelationPhoneNo,
                            patientTypeID: patientDetails.PatientType.value,
                            TypeOfReference: patientDetails.typeOfReference.text
                        }
                        callback({ defaultPatientMaster: patientMaster, defaultMedicalHistory: patientMedicalHistory });
                    }

                  $showOldPatientSearchModel = function () {
                      $('#oldPatientModel .modal-body').find('input[type=text]').not('#txtSearchModelFromDate,#txtSerachModelToDate').val('');
                      $('#oldPatientModel').showModel();
                      $('#spnPatientType').text('Old Patient Search');
                      $('#spnPatientTypeID').text('2')
                  }

                  $closeOldPatientSearchModel = function () {
                      $('#oldPatientModel').hideModel();
                  }
                  $showTransferPatientSearchModel = function () {
                      $('#spnPatientType').text('Patient Transfer From Triage Room');
                      $('#spnPatientTypeID').text('1')
                      $('#oldPatientModel .modal-body').find('input[type=text]').not('#txtSearchModelFromDate,#txtSerachModelToDate').val('');
                      $('#oldPatientModel').showModel();
                  }
                  $onDateOfBirthChange = function (birthDate) {
                      if (!String.isNullOrEmpty(birthDate)) {
                          var txtAge = $('#txtAge').prop('disabled', true);
                          var ddlAge = $('#ddlAge').prop('disabled', true);

                            getAge(birthDate, function (response) {
                                if ($.isNumeric(response.years) && response.years > 0) {
                                    txtAge.val(response.years + '.' + response.months);
                                    ddlAge.val('YRS');
                                }
                                else if ($.isNumeric(response.months) && response.months > 0) {
                                    txtAge.val(response.months);
                                    ddlAge.val('MONTH(S)');
                                }
                                else if ($.isNumeric(response.days) && response.days > 0) {
                                    txtAge.val(response.days);
                                    ddlAge.val('DAYS(S)');
                                }
                                else {
                                    txtAge.val('');
                                    ddlAge.val('YRS');
                                }

                            });
                        }
                        else {
                            $('#txtAge').prop('disabled', false);
                            $('#ddlAge').prop('disabled', false);
                        }
                    }


                  $searchOldPatientDetail = function () {
                      var DOBChk = 0;
                      if ($('#ChkModelDOB').is(':checked'))
                          DOBChk = 1;

                        var RelationIndex = $('#ddlModelrelation option:selected').index();
                        if (RelationIndex > 0) {
                            var _txtModelRelationName = $('#txtModelRelationName');
                            if (String.isNullOrEmpty(_txtModelRelationName.val())) {
                                modelAlert('Please Enter Relation Name', function () {
                                    _txtModelRelationName.focus();
                                });
                                return;
                            }
                        }
                        var relation_type = '';
                        if ($('#ddlModelrelation option:selected').val() == "Select")
                            relation_type = '';
                        else
                            relation_type = $('#ddlModelrelation option:selected').val();


                        $DOB = '0001-01-01';
                        if ($('#txtModelDOB').val() != '')
                            $DOB = $.datepicker.formatDate('dd-M-yy', new Date($('#txtModelDOB').val().split('-')[2] + '-' + $('#txtModelDOB').val().split('-')[1] + '-' + $('#txtModelDOB').val().split('-')[0]));

                      var data = {
                          PatientID: $('#txtSearchModelMrNO').val(),
                          PName: $('#txtSearchModelFirstName').val(),
                          LName: $('#txtSearchModelLastName').val(),
                          ContactNo: $('#txtSerachModelContactNo').val(),
                          Address: $('#txtSearchModelAddress').val(),
                          FromDate: $('#txtSearchModelFromDate').val(),
                          ToDate: $('#txtSerachModelToDate').val(),
                          DOB: $DOB,
                          IsDOBChecked: DOBChk,
                          PatientRegStatus: 1,
                          Relation: relation_type,
                          RelationName: $('#txtModelRelationName').val(),
                          isCheck: '0',
                          IDProof: $('#txtIDProofNo').val(),
                          MembershipCardNo: '',
                          IPDNO: $('#txtIPDNo').val(),
                          panelID: '',
                          cardNo: '',
                          visitID: '',
                          emailID: '',
                          patientType: $('#spnPatientTypeID').text(),
                          FamilyNo: $("#txtFamilyNo").val()
                      }
                      getOldPatientDetails(data, function (response) {
                          bindOldPatientDetails(response);
                      });
                  }

                    var _PageSize = 9;
                    var _PageNo = 0;
                    var bindOldPatientDetails = function (data) {
                        if (!String.isNullOrEmpty(data)) {
                            OldPatient = JSON.parse(data);

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
                    }



                    var getOldPatientDetails = function (data, callback) {
                        serverCall('../Common/CommonService.asmx/oldPatientSearch', data, function (response) {
                            callback(response);
                        });
                    }

                    $searchPatient = function (data, IPDDetails, gender, callback) {
                        var patientIPDDetails = {
                            IPDTransactionID: IPDDetails.split('#')[0],
                            IPDAdmissionRoomType: IPDDetails.split('#')[1],
                            gender: gender,
                            PID: data.PatientID
                        }
                        validatePatientSelection(patientIPDDetails, function () {
                            $patientSearchByPatientId(data, function (response) {
                                callback(response);
                            });
                        });
                    }



                    var validatePatientSelection = function (patientDetails, callback) {
                        var URL = window.location.href.split('?')[0];
                        var pageName = URL.split('/')[URL.split('/').length - 1];
                        if (!String.isNullOrEmpty(patientDetails.IPDTransactionID) && patientDetails.gender.toLowerCase() == 'female' && pageName.toLowerCase() == 'ipdadmissionnew.aspx') {
                            modelConfirmation('Do You Want To Admit her Child ?', 'Patient is Already Admited </br><span style="color: black;"> With IPD NO. :<span> &nbsp;<span style="color: blue;"> ' + patientDetails.IPDTransactionID.replace('ISHHI', '') + '</span></br><span style="color: black;">IN Room Type :</span>&nbsp; <span style="color: blue;">' + patientDetails.IPDAdmissionRoomType + '</span>', 'Admit Child', 'Close', function (response) {
                                if (response) {
                                    $('#spnIPDNo').text(patientDetails.IPDTransactionID.replace('ISHHI', '')).parent().show();
                                    callback(response);
                                }
                            });
                        }
                        else {
                            if (!String.isNullOrEmpty(patientDetails.IPDTransactionID)) {
                                modelConfirmation('<span style="color: red;">Patient is Already Admited !</span>', '<span style="color: black;"> With IPD NO. :<span> &nbsp;<span style="color: blue;"> ' + patientDetails.IPDTransactionID.replace('ISHHI', '') + '</span></br><span style="color: black;">IN Room Type :</span>&nbsp; <span style="color: blue;">' + patientDetails.IPDAdmissionRoomType + '</span>', '', 'Close', function (response) {
                                    if (pageName == 'Lab_PrescriptionOPD.aspx' || pageName == 'DirectPatientReg.aspx')
                                        callback(true);

                                });
                            }
                            else {

                                serverCall('../Common/CommonService.asmx/validateEmergencyPatient', { PID: patientDetails.PID }, function (EMGNo) {
                                    if (EMGNo != "" && (pageName.toLowerCase() == 'emergencyadmission.aspx' || pageName.toLowerCase() == 'ipdadmissionnew.aspx')) {
                                        modelConfirmation('Already Admitted in Emergency  !!!', 'Emergency No. :' + EMGNo, '', 'Close', function () {

                                        });
                                    }
                                    else {
                                        $('#spnIPDNo').text('').parent().hide();
                                        callback(true);
                                    }
                                });
                            }
                        }
                    }





                    var $patientSearchByPatientId = function (data, callback) {
                        getPatientOutStanding(data.PatientID, function () {
                            serverCall('../Common/CommonService.asmx/PatientSearchByBarCode', data, function (response) {
                                $responseData = JSON.parse(response)
                                var useSeparateVisitAndBilling = Number('<%=Resources.Resource.UseSeparateVisitAndBilling%>');

                                if ($responseData.length > 0) {
                                    if (useSeparateVisitAndBilling == 0)
                                        callback($responseData[0]);
                                    else {

                                        var URL = window.location.href.split('?')[0];
                                        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();
                                        var allowPages = [
                                            'patientvisitregistration.aspx',
                                            'bookdirectappointment.aspx',
                                            'lab_prescriptionopd.aspx',
                                            'opdadvance.aspx',
                                            'ipdadmissionnew.aspx',
                                            'opdpackage.aspx',
                                            'directpatientreg.aspx',
                                            'emergencyadmission.aspx'
                                        ];
                                        var allowBindPatientDetails = false;

                                        if (allowPages.indexOf(pageName) > -1)
                                            allowBindPatientDetails = true;

                                        if (Number($responseData[0].AvilableOpenVisit) == 1)
                                            allowBindPatientDetails = true;


                                        if (allowBindPatientDetails)
                                            callback($responseData[0]);
                                        else {
                                            modelAlert('Please Create Visit First.');
                                        }
                                    }

                                }
                            });
                        });
                    }




                    function CountPatientTest(patientid) {
                        serverCall('../Common/CommonService.asmx/CountPatientTestByPatientID', { patientID: patientid }, function (r) {
                            var data = JSON.parse(r);
                            $("#spnCountTest").text("");
                            $("#spnCountTest").css("display", "");
                            $("#spnCountTest").text(data);
                        });
                    }

    function checkblacklist(patientid, molbileno, callback) {
        serverCall('../Common/CommonService.asmx/checkblacklist', { patientID: patientid, molbileno: molbileno }, function (r) {
            var result = r;
            callback(r);
        });
    }
    var patientSearchOnEnter = function (e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) {
            var data = { PatientID: '',FamilyNo:'', PName: '', LName: '', ContactNo: '', Address: '', FromDate: '', ToDate: '', PatientRegStatus: 1, isCheck: '0', IDProof: '', MembershipCardNo: '', DOB: '', IsDOBChecked: '0', Relation: '', RelationName: '', IPDNO: '', panelID: '', cardNo: '', visitID: '', emailID: '', patientType: $('#spnPatientTypeID').text() };//2 For OLD Patient 
            if (e.target.id == 'txtBarcode')
                data.PatientID = e.target.value;
            if (e.target.id == 'txtMobile') {
                if (e.target.value.length < 8) {
                    modelAlert('Incomplete Mobile No');
                    return;
                }
                data.ContactNo = e.target.value;
            }
            if (e.target.id == 'txtMembershipCardNo') {
                data.MembershipCardNo = e.target.value;
            }
            //if (e.target.id == 'txtAdharCardNo') {
            //    if (e.target.value.length < 12) {
            //        modelAlert('Incomplete Aadhar No');
            //        return;
            //    }
            //    data.AadharCardNo = e.target.value;
            //}




                            if (e.target.id == 'txtCardNo') {
                                if (e.target.value.length < 1) {
                                    modelAlert('Incomplete Card No');
                                    return;
                                }

                                $getPanelDetails(function (panelDetails) {
                                    data.cardNo = e.target.value;
                                    data.panelID = panelDetails.panel.panelID
                                });
                            }


                            if (e.target.id == 'txtVisitId') {
                                if (e.target.value.length < 1) {
                                    modelAlert('Incomplete Visit ID.', function () {
                                        $(e.target).focus();
                                    });
                                    return;
                                }
                                data.visitID = e.target.value;

                            }

                            if (e.target.id == 'txtEmailAddress') {

                                if (e.target.value.length < 1) {
                                    modelAlert('Incomplete Email Address.', function () {
                                        $(e.target).focus();
                                    });
                                    return;
                                }
                                //else {
                              
                                //    $emailexp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                                //    alert($emailexp.test(e.target.value));
                                //    if ($emailexp.test(e.target.value) == false) {
                                //        modelAlert('Invalid Email Address.', function () {
                                //            $(e.target).focus();
                                //        });
                                //        return;
                                //    }
                                //}
                                data.emailID = e.target.value;
                            }


                            if (e.target.id == 'txtIDProofNo') {
                                if (e.target.value.length < 1) {
                                    modelAlert('Incomplete ID Proof No.', function () {
                                        $(e.target).focus();
                                    });
                                    return;
                                }
                                data.IDProof = e.target.value;

                            }
                            checkblacklist(data.PatientID.trim(), data.ContactNo, function (response) {
                                if (response == '1') {
                                    modelAlert('This patient has been blacklisted.', function () { });
                                    return false;
                                }
                                else {
                                    getOldPatientDetails(data, function (response) {
                                        if (!String.isNullOrEmpty(response)) {
                                            var resultData = JSON.parse(response);
                                            CountPatientTest(resultData[0].MRNo);
                                            if (resultData.length > 0) {
                                                $('#spnIsRegistrationApply').html(resultData[0]["IsRegistrationApply"]);
                                            }
                                            if (resultData.length > 1) {
                                                bindOldPatientDetails(response);
                                                $showOldPatientSearchModel()
                                            }
                                            else {
                                                var patientIPDDetails = {
                                                    IPDTransactionID: resultData[0].IPDDetails.split('#')[0],
                                                    IPDAdmissionRoomType: resultData[0].IPDDetails.split('#')[1],
                                                    gender: resultData[0].Gender,
                                                    PID: resultData[0].MRNo
                                                }
                                                validatePatientSelection(patientIPDDetails, function () {
                                                    $patientSearchByPatientId({ PatientID: resultData[0].MRNo, PatientRegStatus: 1 }, function (response) {
                                                        $bindPatientDetails(response, function () { });
                                                    });
                                                });
                                            }
                                        }
                                        else {
                                            if (e.target.id == 'txtIDProofNo')
                                                $addIDProofNumber(e.target, e);
                                            else
                                                modelAlert('No Record Found');
                                        }
                                    });
                                }
                            });
                        }
                    }







                    function showPage(_strPage) {
                        _StartIndex = (_strPage * _PageSize);
                        _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
                        var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
                        $('#divSearchModelPatientSearchResults').html(outputPatient);
                    }

                    var $bindPatientDetails = function (data, callback) {

                        var URL = window.location.href.split('?')[0];
                        var pageName = URL.split('/')[URL.split('/').length - 1].toLowerCase();
                        var isRegistredPatient = String.isNullOrEmpty(data.PatientID) ? false : true;
                        var isIPDAdmissionPage = false;
                        var isEmergencyAdmissionPage = false;

                        var isIPDAdmissionEdit = false;

                        var transactionID = '<%=Util.GetString(Request.QueryString["TID"]) %>';

                        if (!String.isNullOrEmpty(transactionID))
                            isIPDAdmissionEdit = true;

                        var isEdit = true;
                        if (pageName == 'lab_prescriptionopd.aspx')
                            isEdit = false;
                        if (pageName == 'directpatientreg.aspx')
                            isEdit = false;



                        if (pageName == 'ipdadmissionnew.aspx') {
                            isEdit = false;
                            isIPDAdmissionPage = true;
                        }

                        if (pageName == 'emergencyadmission.aspx')
                            isEmergencyAdmissionPage = true;


                        //*******for baby of IPD Patient*******//
                        var selectedPatientIPDNo = $('#spnIPDNo');
                        var title = String.isNullOrEmpty(selectedPatientIPDNo[0].innerText) ? data.Title : 'B/O.';



                        var txtVisitId = $('#txtVisitId').attr('visitID', data.TransactionID).val(data.TransactionID);
                        var txtPID = $('#txtPID').attr('patientAdvanceAmount', data.OPDAdvanceAmount)
                            .val(String.isNullOrEmpty(selectedPatientIPDNo[0].innerText) ? data.PatientID : '');

                        if ($.isFunction(window['_onPatientChangeOrBind']))
                            _onPatientChangeOrBind(function () { });

                        if (isRegistredPatient)
                            $(txtPID).change();
                        else
                            isEdit = false;

                        if ($.isFunction(window['_onDoctorChange']))
                            _onDoctorChange(function () { });



                        var _ddlTitle = $('#ddlTitle');
                        $($(_ddlTitle).find('option').filter(function () { return this.text == title })[0]).prop('selected', true).prop('disabled', !String.isNullOrEmpty(selectedPatientIPDNo[0].innerText));

                        //if(!String.isNullOrEmpty(selectedPatientIPDNo[0].innerText))
                        $onTitleChange(_ddlTitle);

                        _ddlTitle.attr('disabled', isEdit);
                        $('#txtPFirstName').val(data.PFirstName).attr('disabled', isEdit);
                        $('#txtPLastName').val(data.PLastName).attr('disabled', isEdit);
                        $('input[type=radio][value=' + data.Gender + ']').prop('checked', true);
                        $('input[type=radio]').attr('disabled', isEdit);
                        $('#txtDOB').val(data.DOB == '01-Jan-0001' ? '' : data.DOB).attr('disabled', isEdit);
                        $('#txtAge').val(data.Age.split(' ')[0]).attr('disabled', isEdit);
                        $('#txtPlaceOfBirth').val(data.PlaceOfBirth).attr('disabled', isEdit);
                        $('#ddlAge').val(data.Age.split(' ')[1]).attr('disabled', isEdit);
                        $('#txtMobile').val(data.Mobile).attr('disabled', isEdit);
                        $('#txtEmailAddress').val(data.Email).attr('disabled', isEdit);
                        $('#txtAddress').val(data.House_No).attr('disabled', isEdit);
                        $('#ddlCountry').val(data.countryID).attr('disabled', isEdit).chosen('destroy').chosen();
                        $('#ddlPatientType').val(data.patientType).attr('disabled', isEdit);
                        $('#txtMembershipCardNo').val(data.MemberShipCardNo).attr('disabled', isEdit);
                        $('#ddlMarried option:contains("' + (String.isNullOrEmpty(data.MaritalStatus) ? 'Select' : data.MaritalStatus) + '")').prop('selected', true);
                        $('#ddlReligion option:contains("' + data.Religion + '")').prop('selected', true);
                        $('#txtPlace').val(data.Place).attr('disabled', isEdit);
                        $('#spnDocumentCounts').text(data.PatientDocumentsCount);
                        $('#spnDateEnrolled').text(data.DateEnrolled);
                        $('#txtIDProofNo,#ddlMarried,#ddlReligion,#ddlEmergencyRelation,#ddlEthenicGroup,#ddlLanguage,#ddlTranslatorRequired,#ddlRace,#ddlEmployment').attr('disabled', isEdit);
                        $('#ddlReferalType').val(data.ReferralTypeID).chosen('destroy').chosen();//

                        if (isIPDAdmissionEdit)
                            data.DoctorID = data.DoctorID;
                        else if (isEmergencyAdmissionPage)
                            data.DoctorID = '<%=Resources.Resource.DoctorID_Self%>';
                        else if (isIPDAdmissionPage) {

                            data.DoctorID = 0;
                        }
                        else {
                            $('#ddlDoctor').val(String.isNullOrEmpty(data.DoctorID) ? '0' : data.DoctorID).change().chosen("destroy").chosen();

                        }
                        




        //if (!isIPDAdmissionEdit) {
        //    data.Relation = 'Self';
        //    data.RelationName = '';
        //    data.RelationPhoneNo = '';
        //}




                        $('#ddlRelation').val(data.Relation);//
                        $onRelationChange(data.Relation);
                        $('#txtRelationName').val(data.RelationName);//
                        $('#txtRelationPhoneNo').val(data.RelationPhoneNo);//

                        $('#txtPlaceOfBirth').val(data.placeofBirth).attr('disabled', isEdit);


                        $('#ddlEthenicGroup option:contains("' + (String.isNullOrEmpty(data.EthenicGroup) ? 'Select' : data.EthenicGroup) + '")').prop('selected', true);
                        $('#ddlLanguage option:contains("' + (String.isNullOrEmpty(data.LanguageSpoken) ? 'Select' : data.LanguageSpoken) + '")').prop('selected', true);
                        $('#ddlTranslatorRequired').val(data.IsTranslatorRequired).attr('disabled', isEdit);
                        $('#ddlFacialStatus option:contains("' + (String.isNullOrEmpty(data.FacialStatus) ? 'Select' : data.FacialStatus) + '")').prop('selected', true);
                        $('#ddlRace option:contains("' + (String.isNullOrEmpty(data.Race) ? 'Select' : data.Race) + '")').prop('selected', true);
                        $('#ddlEmployment option:contains("' + (String.isNullOrEmpty(data.Employement) ? 'Select' : data.Employement) + '")').prop('selected', true);
                        $('#txtOccupation').val(data.Occupation).attr('disabled', isEdit);
                        $('#txtMonthlyIncome').val(data.MonthlyIncome).attr('disabled', isEdit);
                        $('#txtEmergencyNumber').val(data.EmergencyPhoneNo).attr('disabled', isEdit);

                        $('#txtIdentityMark').val(data.IdentificationMark).attr('disabled', isEdit);
                        $('#txtIdentityMarkSecond').val(data.IdentificationMarkSecond).attr('disabled', isEdit);
                        $('#ddlEmergencyRelation option:contains("' + (String.isNullOrEmpty(data.EmergencyRelationOf) ? 'Select' : data.EmergencyRelationOf) + '")').prop('selected', true);
                        $('#txtEmergencyRelationName').val(data.EmergencyRelationShip).attr('disabled', isEdit);
                        $('#txtremarks').val(data.Remark).attr('disabled', isEdit);



                        $('#txtLandLineStdCode').val(data.Phone_STDCODE).attr('disabled', isEdit);
                        $('#txtResidentialNumber').val(data.ResidentialNumber).attr('disabled', isEdit);
                        $('#txtResidentialStdCode').val(data.ResidentialNumber_STDCODE).attr('disabled', isEdit);
                        $('#txtEmergencyFirstName').val(data.EmergencyFirstName).attr('disabled', isEdit);
                        $('#txtEmergencySecondName').val(data.EmergencySecondName).attr('disabled', isEdit);

                        $('#txtLandLineNo').val(data.Phone).attr('disabled', isEdit);

                        $('#txtEmergencyRelationName').val(data.EmergencyRelationShip).attr('disabled', isEdit);
                        $('#txtEmergencyAddress').val(data.EmergencyAddress).attr('disabled', isEdit);


        $('#ddlIsInterNationPatient').val(data.IsInternational).change();
        $('#ddlIsInterNationPatient').attr('disabled', isEdit);
        $('#ddlInternationalCountry').val(data.InternationalCountryID).trigger("chosen:updated");
        $('#txtParmanentAddress').val(data.parmanentAddress);
        $('#txtOverSeaNumber').val(data.OverSeanumber);
        $('#txtInternationalNumber').val(data.InternationalNumber);
        $('#txtPMiddleName').val(data.PMiddleName);

        $('#ddlTaluka').val(data.talukaID).attr('disabled', isEdit).chosen('destroy').chosen();
        if ($('#ddlTaluka').val() == 1) {
            $('#txtOtherVillage').val(data.Taluka);
            $('#txtOtherVillage').show();
        }

        $('#ddlPurposeOfVisit').val(data.PurposeOfVisitID).attr('disabled', isEdit).chosen('destroy').chosen();

        if ($('#spnIPDNo').text() != '') {
            $('#txtDOB').val('');
            $('#txtAge').val('');

        }

        $('#ddlPRequestDept').val(data.PRequestDept).attr('disabled', isEdit).chosen('destroy').chosen();
        $('#txtSecondMobile').val(data.SecondMobileNo);
        $('#txtTypeRefernce').val(data.StaffDependantID);
        



        $bindPanelDetails(data, function () { });


        if (data.PatientID != "") {
            serverCall('../Common/CommonService.asmx/BindPatientMultiPanelDetails', { PatientID: data.PatientID }, function (response) {

    		var responseData = JSON.parse(response);
                if(responseData.length>0)
                $getMultiPanelDetails(responseData, function () { });
            });


        }


        data.PatientPhotoPath = (!String.isNullOrEmpty(data.PatientPhotoPath) ? data.PatientPhotoPath : '../../images/no-avatar.gif');
        $('#imgPatient').attr('src', data.PatientPhotoPath);
        if (!String.isNullOrEmpty(data.PatientID))
            if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1') {
                                validateRegistrationCharges(data.PatientID, function (response) {
                                    $('#spnRegistrationchargeFeePaid').text(response);
                                    if (response == 1) {
                                        $('#spanRegistrationCharges').text('0');
                                    }
                                    else {
                                        var URL = window.location.href.split('?')[0];
                                        var pageName = URL.split('/')[URL.split('/').length - 1];
                                        var registrationChargesPages = [
                                             'bookdirectappointment.aspx',
                                             'opdpackage.aspx',
                                             'lab_prescriptionopd.aspx', 'directPatientReg.aspx'];

                                        if ('<%=Resources.Resource.IsReceipt%>' == '1') {
                                            if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1' && (pageName.toLowerCase() == 'bookdirectappointment.aspx' || pageName.toLowerCase() == 'lab_prescriptionopd.aspx' || pageName.toLowerCase() == 'opdpackage.aspx'))
                                                $bindRegistrationCharges(function () { });
                                            else {
                                                $('.reg').hide();
                                            }
                                        }
                                        else {
                                            if ('<%=Resources.Resource.RegistrationChargesApplicable %>' == '1' && registrationChargesPages.indexOf(pageName.toLowerCase()) > -1)
                                                $bindRegistrationCharges(function () { });
                                            else {
                                                $('.reg').hide();
                                            }
                                        }
                                    }
                                });
                            }
        $bindState(data.countryID, function (selectedStateID) {
            $('#ddlState').val(data.StateID).attr('disabled', isEdit).chosen('destroy').chosen();
            $bindDistrict(data.countryID, data.StateID, function (selectedDistrictID) {
                $('#ddlDistrict').val(data.districtID).attr('disabled', isEdit).chosen('destroy').chosen();
                $bindCity(data.StateID, data.districtID, function () {
                    $('#ddlCity').val(data.cityID).attr('disabled', isEdit).chosen('destroy').chosen();
                });
                // $bindTuluka(data.districtID, function () {
                //   $('#ddlTaluka').val(data.talukaID).attr('disabled', isEdit).chosen('destroy').chosen();
                //}) ;

                                $bindDocumentMasters(function () { });

                                if (!String.isNullOrEmpty(data.patientIDProofs)) {
                                    $('#divIDProof').find('ul li').remove();
                                    $appendPatientIDProof(isEdit, JSON.parse(data.patientIDProofs), function () { });
                                }
                                bindFamilyNumber();
                                $closeOldPatientSearchModel();
                                callback(true);
                            });
                        });

                    }



                    $preventPatientPanelChange = function (callback) {
                        // $('#ddlPanelCompany,#ddlParentPanel').prop('disabled', true).chosen("destroy").chosen();
                        var isHelpDeskBooking = Number('<%=Util.GetString(Request.QueryString["helpDeskBooking"])%>');
                        if (isHelpDeskBooking == 0) {
                            $('#OldPatient,#txtBarcode').prop('disabled', true);
                        }
                        callback(true);
                    }
                    $allowPatientPanelChange = function (callback) {
                        $('#ddlPanelCompany,#ddlParentPanel').prop('disabled', false).chosen("destroy").chosen();
                        $('#OldPatient,#txtBarcode').prop('disabled', false);
                        callback(true);
                    }

                    var onPatientSelect = function (elem) {
                        checkblacklist($.trim($(elem).closest('tr').find('#tdPatientID').text()), '', function (response) {
                            if (response == '1') {
                                modelAlert('This patient has been blacklisted.', function () { });
                                return false;
                            }
                            else {
                                $searchPatient({ PatientID: $.trim($(elem).closest('tr').find('#tdPatientID').text()), PatientRegStatus: 1 },
                                $(elem).find('#spnIPDDetails').text(),
                                $.trim($(elem).closest('tr').find('#tdGender').text()),
                                function (response) {
                                    CountPatientTest($.trim($(elem).closest('tr').find('#tdPatientID').text()));
                                    $bindPatientDetails(response, function () { });
                                });
                            }
                        });
                    }


                    var $onTitleChange = function (ddlTitle) {

                        var gender = $.trim($(ddlTitle).val());
                        var title = $.trim($(ddlTitle).find('option:selected').text());
                       
                       

                        if (String.isNullOrEmpty(gender) || gender == 'UnKnown')
                            $('input[type=radio][name="sex"]').prop('checked', false).prop('disabled', false);
                        else {
                            $('input[type=radio][name="sex"]').not('#rdoTGender').prop('disabled', true);
                            $('input[type=radio][name="sex"][value="' + gender + '"]').prop('checked', true);
                        }

                        //if (title == 'B/O.')
                        //    $('#txtPlaceOfBirth').addClass('requiredField').prop('disabled', false);
                        //else
                        //    $('#txtPlaceOfBirth').removeClass('requiredField').prop('disabled', false);


                    }


                    var clearDateOfBirth = function (e) {
                        var inputValue = (e.which) ? e.which : e.keyCode;
                        if (inputValue == 46 || inputValue == 8) {
                            $(e.target).val('');
                            $('#txtAge').val('').prop('disabled', false);
                            $('#ddlAge').val('').prop('disabled', false);
                        }
                    }

                    var getPatientOutStanding = function (patientID, callback) {
                        serverCall('../Common/CommonService.asmx/PatientOutstanding', { PatientID: patientID }, function (response) {
                            if (!String.isNullOrEmpty(response)) {
                                var blanceAmount = response.replace(' ', ':').split(':');
                                var message = '<div class="row"><div class="col-md-17"><label class="pull-left">Balance Amount (OPD)</label><b class="pull-right">:</b></div><div class="col-md-7 pull-left"><label class="pull-right">' + parseFloat(blanceAmount[1]).toFixed(4) + '</label></div></div>';
                                message += '<div class="row"><div class="col-md-17"><label class="pull-left">Balance Amount (IPD)</label><b class="pull-right">:</b></div><div class="col-md-7 pull-left"><label class="pull-right">' + parseFloat(blanceAmount[3]).toFixed(4) + '</label></div></div>';

                                var btnContinueText = 'Continue';
                                var modelSubject = 'Balance Amount Confirmation ?';

                                var URL = window.location.href.split('?')[0];
                                var pageName = URL.split('/')[URL.split('/').length - 1].toLowerCase();
                                var blockPageOnOutStanding = [''];


                                if (Number(blanceAmount[1]) > 0) {
                                    if (blockPageOnOutStanding.indexOf(pageName) > -1) {
                                        btnContinueText = '';
                                        modelSubject = 'Clear OPD OutStanding First !!'
                                    }
                                }

                                if (pageName == 'ipdadmissionnew.aspx') {
                                    callback();
                                }
                                modelConfirmation(modelSubject, message, btnContinueText, 'Cancel', function (response) {
                                    if (response) {
                                        callback();
                                    }
                                });
                            }
                            else
                                callback();
                        });
                    }


                    var getPatientBasicDetails = function (callback) {
                        $getPanelDetails(function (panelDetails) {
                            var r = $("#ddlReferalType option:selected").val();
                            var rv = r.split("#");
                            var refid = rv[0];

                            var referdby;
                            var reftype = $("#ddlReferalType option:selected").text();
                        
                            if (reftype == "IN" || reftype == "Self") {
                                referdby = $('#ddlReferDoctor option:selected').val();
                            }
                            else {
                                referdby = $('#ddlReferDoctor option:selected').text();
                            }
							var doctorID="";
							 if (!String.isNullOrEmpty($('#ddlDoctor').val()))
							 {
							 doctorID=$('#ddlDoctor').val().trim();
							 }
								
                            callback({
                                patientID: $('#txtPID').val().trim(),
                                visitID: $.trim($('#txtVisitId').attr('visitID')),
                                memberShipCardNo: $('#txtMembershipCardNo').val(),
                                doctorID:doctorID ,
                                patientTypeID: $('#ddlPatientType').val(),
                                panelID: panelDetails.panel.panelID,
                                panelAdvanceAmount: panelDetails.advanceAmount,
                                patientAdvanceAmount: Number($('#txtPID').attr('patientadvanceamount')),
                                panelCurrencyFactor: panelDetails.panelCurrencyFactor,
                                Relation: { value: $('#ddlRelation').val(), text: $('#ddlRelation option:selected').val() },
                                RelationName: $('#txtRelationName').val(),
                                RelationPhoneNo: $('#txtRelationPhoneNo').val(),
                                ReferralTypeID: refid,  //
                                ReferedBy: referdby != 'Select' ? referdby : ''//

                            });
                        }, { validate: false });
                    }

                    var $addIDProofNumber = function (sender, e) {
                        var inputValue = (e.which) ? e.which : e.keyCode;

                        var $txtIDProofNo = $('#txtIDProofNo');
                        var $ddlIDProofID = $("#ddlIDProof");

                        var selectedDocumentID = $ddlIDProofID.val();

                        if (selectedDocumentID == '0') {
                            modelAlert('Please Select Document.', function () { });
                            return false;
                        }




                        if (inputValue == 13 && $txtIDProofNo.val().trim() != '') {

                            if ($txtIDProofNo.val().length > 0 && $txtIDProofNo.val().length < $ddlIDProofID.val().split('#')[1]) {
                                modelAlert('Incomplete ' + $ddlIDProofID.find(':selected').text() + ' Number', function () {
                                    $txtIDProofNo.focus();
                                });
                                return false;
                            }

                            $appendPatientIDProof(false, [{ IDProofID: $ddlIDProofID.val().split('#')[0].trim(), IDProofName: $ddlIDProofID.find(':selected').text().trim(), IDProofNumber: $txtIDProofNo.val().trim() }], function () { });
                            //$('#txtIDProofNo').val("");
                        }
                    }

                    $appendPatientIDProof = function (isEdit, data, callback) {
                        $.each(data, function (key, value) {
                            var idProofList = $('#divIDProof');
                            $isAlreadyExits = idProofList.find('#' + value.IDProofID);
                            $("#ddlIDProof").prop("selectedIndex", 0);
                            if ($isAlreadyExits.length > 0) {
                                $($isAlreadyExits).remove();
                            }
                            var dis = "display:block";
                            if (isEdit)
                                dis = "display:none";
                            idProofList.find('ul').append('<li id=' + value.IDProofID + ' class="search-choice"><span><b>' + value.IDProofName + ' :</b> ' + value.IDProofNumber + '</span><a  onclick="$(this).parent().remove();if($(\'#divIDProof>ul>li\').length==0){$(\'#divPatientIDProof\').hide();}" style="cursor:pointer;' + dis + '" class="search-choice-close" data-option-array-index="4">' + value.IDProofID + '</a></li>');
                            if (idProofList.find('ul').find("li").length > 0) {
                                $("#divPatientIDProof").show();
                                $("#ddlIDProof").prop("selectedIndex", 0);
                            }
                            else {
                                $('#divPatientIDProof').hide();
                                $("#ddlIDProof").prop("selectedIndex", 0);
                            }
                        });
                        callback(true);
                    }

                    var $getPatientIDProofs = function (callback) {
                        var patientIDProof = [];
                        $('#divPatientIDProof ul li').each(function () {
                            patientIDProof.push({
                                IDProofID: this.id,
                                IDProofName: $(this).find('span').text().split(":")[0],
                                IDProofNumber: $(this).find('span').text().split(":")[1]
                            });
                        });

                       
                        //var IDProofNumber = $.trim($('#txtIDProofNo').val());
                        //var IDProofID = $.trim($('#ddlIDProof').val().split('#')[0]);
                        //var IDProofName = $.trim($('#ddlIDProof option:selected').text());
                        //if (!String.isNullOrEmpty(IDProofNumber)) {
                        //    var index = patientIDProof.filter(function (e, i) { if (e.IDProofID == IDProofID) { return i; } });
                        //    if (index.length > 0)
                        //        patientIDProof[index[0]].IDProofNumber = IDProofID;
                        //    else {
                        //        patientIDProof.push({
                        //            IDProofID: IDProofID,
                        //            IDProofName: IDProofName,
                        //            IDProofNumber: IDProofNumber
                        //        });
                        //    }
                        //}
                        callback(patientIDProof);
                    }






                    var getBindPatientDefaultValue = function (obj, callback) {
                        var defaultValue = {
                            IsMemberShipExpire: '',
                            MemberShipCardNo: '',
                            Title: 'Mr.',
                            PFirstName: '',
                            PLastName: '',
                            PName: '',
                            DOB: '',
                            DateEnrolled: '',
                            Age: '',
                            Relation: '',
                            RelationName: '',
                            RelationPhoneNo: '',
                            Gender: '',
                            House_No: '',
                            Taluka: '',
                            Occupation: '',
                            District: '0',
                            LandMark: '',
                            PinCode: '',
                            Place: '',
                            EmergencyNotify: '',
                            EmergencyRelationShip: '',
                            EmergencyAddress: '',
                            EmergencyPhoneNo: '',
                            MaritalStatus: '',
                            Country: '',
                            State: '',
                            Mobile: '',
                            Email: '',
                            City: '',
                            PanelID: '1',
                            ParentID: '1',
                            ReferenceCodeOPD: '',
                            HideRate: '',
                            ShowPrintOut: '',
                            DoctorID: '',
                            FeesPaid: '',
                            patientType: '1',
                            AdharCardNo: '',
                            HospPatientType: '',
                            countryID: '0',
                            districtID: '0',
                            cityID: '0',
                            talukaID: '0',
                            StateID: '65',
                            OPDAdvanceAmount: 0,
                            PatientID: '',
                            oldPatientID: '',
                            patientIDProofs: '',
                            PatientPhotoPath: '',
                            PatientDocumentsCount: '0'
                        }
                        callback($.extend(defaultValue, obj));
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
                    var validateDuplicatePatientEntry = function (callback) {
                        $getPatientIDProofs(function (IDProof) {
                            var patientID = $.trim($('#txtPID').val());
                            var data = {
                                firstName: $.trim($('#txtPFirstName').val()),
                                lastName: $.trim($('#txtPLastName').val()),
                                mobileNumber: $.trim($('#txtMobile').val()),
                                patientID: patientID,
                                IDProof: IDProof
                            }
                            serverCall('../Common/CommonService.asmx/ValidateDuplicatePatientEntry', data, function (response) {
                                var responseData = JSON.parse(response);
                                if (responseData.status)
                                    callback();
                                else {
                                    if (responseData.patientID == 0 && responseData.IsIDProof == "1") {
                                        modelAlert(responseData.response, function () {
                                            return false;
                                        });
                                    }
                                    else {
                                        if (responseData.IsIDProof == "0") {
                                            modelConfirmation('Duplicate Entry Confirmation ?', responseData.response + '</br><span class="patientInfo"> With :' + responseData.patientID + '</span>', 'Cancel', 'Yes Continue', function (status) {
                                                if (!status)
                                                    callback();
                                                else
                                                    return false;
                                            });
                                        }
                                    }

                                }
                            });
                        });
                    }
                    function validateDOB(sender, e) {
                        formatBox = document.getElementById(sender.id);
                        strLen = sender.value.length;
                        strVal = sender.value;
                        hasDec = false;
                        e = (e) ? e : (window.event) ? event : null;

                        if (e) {
                            if (strVal.charAt(0) == '-')
                                $(sender).val('01-');
                            else if (strVal.charAt(1) == '-')
                                $(sender).val('0' + strVal.charAt(0) + '-');
                            else if (parseInt(strLen) == 2) {
                                $(sender).val(strVal + '-');
                                if (parseInt($(sender).val().split('-')[0]) > 31 || parseInt($(sender).val().split('-')[0]) < 1) {
                                    $(sender).val('');
                                    modelAlert('Invalid Day.', function () {
                                        $(sender).focus();
                                    });

                                }
                            }
                            else if (strVal.charAt(3) == '-') {
                                $(sender).val($(sender).val().split('-')[0] + '-01-');
                            }
                            else if (strVal.charAt(4) == '-') {
                                $(sender).val($(sender).val().split('-')[0] + '-0' + strVal.charAt(3) + '-');
                            }
                            else if (parseInt(strLen) == 5) {
                                $(sender).val(strVal + '-');
                                if (parseInt($(sender).val().split('-')[1]) > 12 || parseInt($(sender).val().split('-')[1]) < 1) {
                                    $(sender).val('');
                                    modelAlert('Invalid Month.', function () {
                                        $(sender).focus();
                                    });

                                }
                            }
                            else if (parseInt(strLen) == 10) {

                                if (parseFloat(strVal.split('-')[2]) > parseFloat($.datepicker.formatDate('yy', new Date()))) {
                                    $(sender).val('');
                                    modelAlert('DOB cannot be Greater than Current Date.', function () {
                                        $(sender).focus();
                                    });

                                }
                                else if ((parseFloat(strVal.split('-')[2]) == parseFloat($.datepicker.formatDate('yy', new Date()))) && (parseFloat(strVal.split('-')[1]) > parseFloat($.datepicker.formatDate('mm', new Date(new Date().getTime()))))) {
                                    $(sender).val('');
                                    modelAlert('DOB cannot be Greater than Current Date.', function () {
                                        $(sender).focus();
                                    });
                                }
                                else if ((parseFloat(strVal.split('-')[2]) == parseFloat($.datepicker.formatDate('yy', new Date()))) && (parseFloat(strVal.split('-')[1]) == parseFloat($.datepicker.formatDate('mm', new Date(new Date().getTime())))) && (parseFloat(strVal.split('-')[0]) > parseFloat($.datepicker.formatDate('dd', new Date(new Date().getTime()))))) {
                                    $(sender).val('');
                                    modelAlert('DOB cannot be Greater than Current Date.', function () {
                                        $(sender).focus();
                                    });;

                                }
                                else if (parseInt(strVal.split('-')[1]) == 2 && parseInt(parseInt(strVal.split('-')[2]) % 4) > 0 && parseInt(strVal.split('-')[0]) > 28) {
                                    $(sender).val('');
                                    modelAlert('Invalid DOB.', function () {
                                        $(sender).focus();
                                    });

                                }
                                else if (parseInt(strVal.split('-')[1]) == 2 && parseInt(parseInt(strVal.split('-')[2]) % 4) == 0 && parseInt(strVal.split('-')[0]) > 29) {
                                    $(sender).val('');
                                    modelAlert('Invalid DOB.', function () {
                                        $(sender).focus();
                                    });

                                }
                                else if ((parseInt(strVal.split('-')[1]) == 4 || parseInt(strVal.split('-')[1]) == 6 || parseInt(strVal.split('-')[1]) == 9 || parseInt(strVal.split('-')[1]) == 11) && parseInt(strVal.split('-')[0]) > 30) {
                                    $(sender).val('');
                                    modelAlert('Invalid DOB.', function () {
                                        $(sender).focus();
                                    });
                                }
                                else if (parseFloat(strVal.split('-')[2]) < parseFloat($.datepicker.formatDate('yy', new Date())) - 150) {
                                    $(sender).val('');
                                    modelAlert('Invalid DOB.', function () {
                                        $(sender).focus();
                                    });
                                }

                            }

                        }
                    }
                    var validateRegistrationCharges = function (patientId, callback) {
                        serverCall('../Common/CommonService.asmx/validateRegistrationCharges', { PID: patientId }, function (response) {
                            callback(response);
                        });
                    }


                    var togglePatientDetailSection = function (el, isForceHide) {
                        var _divPatientBasicDetails = $(el).parent().find('.row:first');
                        if (isForceHide)
                            _divPatientBasicDetails.addClass('hidden');
                        else
                            _divPatientBasicDetails.hasClass('hidden') ? _divPatientBasicDetails.removeClass('hidden') : _divPatientBasicDetails.addClass('hidden');
                    }





                    var onIsInterNationPatientChange = function (el) {
                        var isInterNationalPatient = Number(el.value);
                        var divInternationalDetails = $('.divInternationalDetails');
                        if (isInterNationalPatient == 1) {
                            //divInternationalDetails.find('#txtOverSeaNumber').addClass('requiredField');
                            divInternationalDetails.find('input').val('').attr('disabled', false);
                            divInternationalDetails.find('textarea').val('').attr('disabled', false);
                            divInternationalDetails.find('select').val(0).attr('disabled', false).trigger('chosen:updated');
                        }
                        else {
                           // divInternationalDetails.find('#txtOverSeaNumber').removeClass('requiredField');
                            divInternationalDetails.find('input').val('').attr('disabled', true);
                            divInternationalDetails.find('textarea').val('').attr('disabled', true);
                            divInternationalDetails.find('select').val(0).attr('disabled', true).trigger('chosen:updated');
                        }
                    }

                    var checkEmpid = function (e) {
                        var code = (e.keyCode ? e.keyCode : e.which);
                        if (code == 13) {
                            if (e.target.value == '') {
                                modelAlert('Please Enter employeeid');
                                return;
                            }
                            var employeeid = e.target.value;
                            serverCall('../Common/CommonService.asmx/EmpIdsearch', { employeeID: employeeid }, function (response) {
                                var $responseData = JSON.parse(response)
                                if ($responseData.status) { modelAlert($responseData.message); }
                                else
                                {
                                    modelAlert($responseData.response, function () {
                                        $('#txtTypeRefernce').focus();
                                        $('#txtTypeRefernce').val('');
                                    });
                                }
                            });
                        }
                    }

                    var OtherVillage = function (id) {
                        if (id == 1) {

                            $('#txtOtherVillage').show();


                        }
                        else {
                            $('#txtOtherVillage').hide();

                        }

                    }
</script>






<div id="PatientDetails">
	 <div class="POuter_Box_Inventory">
		<div style="cursor:pointer" onclick="togglePatientDetailSection(this)"  class="Purchaseheader">
			  Personal Details
			<span style="display:none" id="spnDateEnrolled"></span>
			<span style="display:none" id="spnOldPatientControlPatientAdvanceAmount"></span>
            <span style="display:none" id="spnRegistrationchargeFeePaid">0</span>
		</div>
		<div class="row divPatientBasicDetails">
		 <div class="col-md-21">
	          <div class="row">
		          <div class="col-md-3">
			           <label class="pull-left"><b>Barcode/UHID </b>   </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			           <input type="text"  autocomplete="off" onkeyup="patientSearchOnEnter(event)"  data-title="Enter UHID and Scan Barcode (Press Enter To Search)"id="txtBarcode" maxlength="20"    />
			 
		           </div>
		           <div class="col-md-3">
			           <label class="pull-left">   Visit ID  </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
				        <input type="text" autocomplete="off" onkeyup="patientSearchOnEnter(event)" data-title="Enter Visit ID (Press Enter To Search)"  visitID=""  id="txtVisitId" maxlength="20"   />
		           </div>
		           <div class="col-md-3">
			           <label class="pull-left">    UHID  </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			           <input type="text" autocomplete="off"  isMobileAppointment="0"  patientAdvanceAmount="0"  id="txtPID" disabled="true" />
			           <input type="text" autocomplete="off"  id="txtOldPID" readonly="readonly" style="display:none" />
		           </div>
	          </div>
	          <div class="row">
		          <div class="col-md-3">
			           <label class="pull-left">  First Name  </label>
			          <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-2">
						        <select id="ddlTitle"    onchange="$onTitleChange(this)"></select>
		           </div>
		          <div  class="col-md-3 ">
			          <input type="text" id="txtPFirstName"  autocomplete="off" onkeypress="this.value=this.value.replace(/\d+/g, '');if(event.keyCode == 39) {return false;}"  style="text-transform:uppercase"  onlyText="50" maxlength="50"  data-title="Enter First Name" />
		           </div>
                  <div class="col-md-3">
			           <label class="pull-left">Middle Name  </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
						        <input type="text" id="txtPMiddleName"  style="text-transform:uppercase" onkeypress="this.value=this.value.replace(/\d+/g, '');if(event.keyCode == 39) {return false;}"  autocomplete="off" onlyText="50"  maxlength="50" data-title="Enter Middle Name"  />
		           </div>
		           <div class="col-md-3">
			           <label class="pull-left">Last Name  </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
						        <input type="text" id="txtPLastName"  style="text-transform:uppercase" onkeypress="this.value=this.value.replace(/\d+/g, '');if(event.keyCode == 39) {return false;}"  autocomplete="off" onlyText="50"  maxlength="50" data-title="Enter Last Name"  />
		           </div>
		         
		 
	          </div>
             <div class="row">
                   <div class="col-md-3"><label class="pull-left">Gender</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
								 
				        <input id="rdoMale" type="radio" name="sex"  checked="checked" disabled="disabled"  value="Male" class="pull-left"  />
				        <span class="pull-left">Male</span>
				        <input id="rdoFemale" type="radio" name="sex" value="Female" disabled="disabled"  class="pull-left" />
				        <span class="pull-left">Female</span>
				        <input id="rdoTGender" type="radio" name="sex" value="TransGender"  class="pull-left" />
				        <span class="pull-left">Others</span>

		           </div>
                   <div class="col-md-3">
			           <label class="pull-left">DOB</label>
			          <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
               
						        <asp:TextBox ID="txtDOB" runat="server" ReadOnly="false" autocomplete="off" data-title="Enter DOB (DD-MM-YYYY)" placeholder="DD-MM-YYYY" ClientIDMode="Static" onblur="$onDateOfBirthChange(this.value)"  onkeyup="clearDateOfBirth(event);validateDOB(this,event);" ToolTip="Select DOB (DD-MM-YYYY)" maxlength="10"></asp:TextBox>
						        <cc1:CalendarExtender ID="CalendarExteDOB" TargetControlID="txtDOB" Format="dd-MM-yyyy" runat="server" ></cc1:CalendarExtender>
                                <cc1:FilteredTextBoxExtender  ID="filterDob" runat="server" FilterType="Numbers,Custom" ValidChars="-" TargetControlID="txtDOB"></cc1:FilteredTextBoxExtender>

		           </div>

		           <div class="col-md-3">
			           <label class="pull-left">   Age  </label>
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
               
                   
             </div>
             
	          <div class="row">
                   <div class="col-md-3">
			           <label class="pull-left">  Mobile No. </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			           <input id="txtMobile" type="text"   allowcharscode="45"  allowFirstZero onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)});"   data-title="Enter Contact No. (Press Enter To Search)" onlynumber="10"    autocomplete="off"  />              
                      
		           </div>
                  <div class="col-md-3">
			           <label class="pull-left">  Sec. Mobile No. </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			           <input id="txtSecondMobile" type="text"  allowFirstZero    data-title="Enter Second Contact No. (Press Enter To Search)" onlynumber="10"    autocomplete="off"  />              
		           </div>
		          <div class="col-md-3">
			           <label class="pull-left">Marital Status</label>
			           <b class="pull-right">:</b>
		           </div>


                  <div class="col-md-5">
                       
                       <select id="ddlMarried" class="chosen-select " data-title="Enter Marital Status" >
                                        <option value="0">Select</option>
						                <option value ="1">Unmarried</option>
						               <option value="2">Married</option>
							           <option value="4">Divorced</option>
							           <option value="5">Widow</option>
					 </select>
                  </div>
                  
		          
		          
	          </div>
	          

             <div class="row">
			  <div class="col-md-3">
			           <label class="pull-left">Physcial Address</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                         <textarea id="txtParmanentAddress"  class="customTextArea"  data-title="Enter Physcial Address"></textarea>
                   </div>
			         <div class="col-md-3">
			           <label class="pull-left"> Postal Address </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			           <textarea id="txtAddress"  class="customTextArea"  data-title="Enter Postal Address"></textarea>

		           </div>
                 
		          <div class="col-md-3">
			           <label class="pull-left">  Country </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
								         <select id="ddlCountry"  data-title="Select Country" onchange="$onCountryChange(this.value)"></select>
		           </div>
              
	          </div>
           <div class="row">
                <div class="col-md-3">
			   <label class="pull-left">    County   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-5">
			<select id="ddlState"   data-title="Select State" onchange="$onStateChange($('#ddlCountry').val(),this.value)"></select>
		   </div>
		 <div style="padding-left: 0px;display:none;"  >
			 <input type="button" class="" value="New" id="Button2" data-title="Click to Create New State"  onclick="$addNewStateModel()" />
		 </div>
		            <div class="col-md-3">
			           <label class="pull-left">    Sub County   </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
				         <select id="ddlDistrict"  data-title="Select District" onchange="$onDistrictChange($('#ddlState').val(),this.value)"></select>
		           </div>
		           <div style="padding-left: 0px;display:none;" >
				          <input type="button" class="ItDoseButton" value="New" id="btnNewDistrict" data-title="Click to Create New District"  onclick="$addNewDistrictModel()" />
						
		           </div>
	
                      <div class="col-md-3">
			           <label class="pull-left">  Ward </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-4">
				        <select id="ddlCity"  data-title="Select City" ></select>
		           </div>
		          <div style="padding-left: 0px;" class="col-md-1">
			           <input type="button" class="ItDoseButton" value="New" id="btnNewCity" data-title="Click to Create New City"  onclick="$addNewCityModel()" />
		          </div>

              


                  
                </div>
             <div class="row">
		         
                   <div class="col-md-3">
                     <label class="pull-left">Village</label>
                     <b class="pull-right">:</b>
                 </div>

                 <div class="col-md-5">
                     <select id="ddlTaluka" onchange="OtherVillage(this.value);"></select>
                     <input type="text" id="txtOtherVillage" style="display:none"/>
                 </div>
                 		       <div class="col-md-3">
                     <label class="pull-left">Pupose Of Visit</label>
                     <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-4">
                     <select id="ddlPurposeOfVisit" title="Please Select Purpose Of Visit"></select>
                 </div>
                 <div class="col-md-1" style="padding-left:0px;">
                 
                     <input type="button" class="ItDoseButton" value="New" id="btnPurposeOfVisit" data-title="Click to Create New Perpose Of Visit"  onclick="$addNewPerposeOfVisit()" />
                 </div>     
		         
                  <div class="col-md-3">
                 <label class="pull-left">Patient Req.Dept</label>
                 <b class="pull-right">:</b>
                     </div>
                 <div class="col-md-5">
                     <select id="ddlPRequestDept" title="Please Select Patient Request Department"></select>
                 </div>                
	          </div> 
	          
             <div class="row">
                 <div class="col-md-3">
                       <label class="pull-left">   Email Address </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
					        <input type="text"  autocomplete="off"  id="txtEmailAddress" onkeyup="patientSearchOnEnter(event)"   maxlength="100"  data-title="Enter Email Address (Press Enter To Search)" />
		           </div>
                 <div class="col-md-3">
			           <label class="pull-left"> ID Proof No. </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
				        <div class="row" style="margin:0px;">
					        <div class="col-md-12" style="padding-left:0px;padding-right:5px;">
						        <select id="ddlIDProof" class="chosen-select"></select>   
					        </div>
					        <div class="col-md-12" style="padding-left:0px;padding-right:0px;">
						        <input type="text" id="txtIDProofNo" onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)});"  autocomplete="off"  data-title="Enter Id Card No." onlytextnumber="25"   maxlength="14"/>
					        </div>
			           </div> 
			        </div>                 
	          </div> 

	          <div class="row" id="divPatientIDProof" style="display:none;">
			        <div class="col-md-3">
				        <label class="pull-left">Patient ID Proof</label>
				        <b class="pull-right">:</b>
			        </div>
			        <div class="col-md-21">
				        <div id="divIDProof" class="chosen-container-multi">
					        <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
					        </ul>
				        </div>
			        </div>
	          </div>
              <div class="row" >
                      <div class="col-md-3">
			               <label class="pull-left">   Family  Number </label>
			                <b class="pull-right">:</b>
		              </div>
		              <div class="col-md-5">
			             <input type="text" id="txtFamilyNumber" familynumber="" disabled="disabled" autocomplete="off"  data-title="Enter Family No." maxlength="50" />                

		             </div>
                    <div class="col-md-3">
			                 <label class="pull-left" style="margin-left: -10px;"> Merge Family No. </label>
			                <b class="pull-right">:</b>
		                   </div>
		            <div class="col-md-5">
			                      <input type="button" onclick="onGetFamilyNumberModelOpen()" value="Click To Merge Family Number" />
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
              <div class="row">

				   <div class="col-md-24">
                             <button id="btnTransferPatient"  type="button" onclick="$showTransferPatientSearchModel()" style="width:114px;font-size:11px;display:none" >Transfer From Triage</button>
				   </div>
			 </div>
			 <div class="row">
				   <div class="col-md-24">
                             <button id="OldPatient"  type="button" onclick="$showOldPatientSearchModel()" style="width:114px;display:<%=GetGlobalResourceObject("Resource", "OldPatientLink") %>" >Old Patient Search</button>
				   </div>
			 </div>
			 <div class="row">
				 <div class="col-md-24">
					   <img id="imgPatient" onclick="ShowCaptureImageModel()" alt="Patient Image" src="../../Images/no-avatar.gif" style="border-style: double;cursor:pointer;width:114px;height:104px;display:<%if (Resources.Resource.ShowPatientPhoto == "1")
                                                                                                                                                                                                  { %> block" <% }
                                                                                                                                                                                                  { %> none" <% } %> />
                       <span style="display:none" id="spnIsCapTure">0</span>
				 </div>
			 </div>
			 <div class="row hidden">
				   <div class="col-md-24 ">
					   <button type="button"  onclick="ShowCaptureImageModel()"   style="width:100%;margin-top:2px;display: <%if (Resources.Resource.ShowPatientPhoto == "1")
                                                                                                               { %> block" <% }
                                                                                                               else
                                                                                                               { %> none" <% } %> >
						   Capture
				       </button>
				 </div>
			 </div>

               <div class="row">
				 <div class="col-md-24">
					 <button onclick="showDocumentMaster()" id="btnDocumentMaster" type="button" style="width:114px" ><span id="spnDocumentCounts"  class="badge badge-grey">0</span><b>Document's</b> </button>
				 </div>
			    </div>

		 </div>
	 </div>

     </div>
      
     <div class="POuter_Box_Inventory" style="display:none;" >
          <div class="Purchaseheader" id="divDemographicDetails"  onclick="togglePatientDetailSection(this)" style="cursor:pointer">
              Demographic Details
          </div>

       
          

	 </div>

     <div class="POuter_Box_Inventory" style="display:none;">
        <div   id="divEmergencyDetails"  class="Purchaseheader"  onclick="togglePatientDetailSection(this)" style="cursor:pointer">
			  Emergency Contact Details
		</div>



    </div>

     <div class="POuter_Box_Inventory">
        <div  id="divOtherDetails"   onclick="togglePatientDetailSection(this)"  class="Purchaseheader"  style="cursor:pointer">
            Others
        </div>
         <div class="row hidden">
            <div class="col-md-21">
	            <div class="row">
                  <div class="col-md-3">
			           <label class="pull-left">LandLine No.</label>
			           <b class="pull-right">:</b>
		           </div>
                  <div class="col-md-2">
                      <input type="text" class="ItDoseTextinputNum" id="txtLandLineStdCode" data-title="Enter STD Code"/>
                  </div>

		           <div class="col-md-3">
				        <input type="text" id="txtLandLineNo" data-title="Enter Landline No." onlynumber="10"/>
		           </div>

                    <div class="col-md-3">
			           <label class="pull-left">Birth Place</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <input id="txtPlaceOfBirth"  errormessage="Enter Place Of Birth." type="text" onlyText="50"  data-title="Enter Birth Place"/>
                   </div>

                  <div class="col-md-3">
			           <label class="pull-left">Religion</label>
			           <b class="pull-right">:</b>
		           </div>

                   <div class="col-md-5">
                         <select id="ddlReligion" class="chosen-select" data-title="Select Religion"></select>
                  </div>

                 
                  </div>
              <div class="row divRelationDetails"  >
		          <div class="col-md-3">
			           <label class="pull-left">  Relation Of  </label>
			           <b class="pull-right">:</b>
		           </div>
		          <div class="col-md-5">
			           <select id="ddlRelation" onchange="$onRelationChange(this.value)" data-title="Select Relation Of"></select>             

		           </div>
		          <div class="col-md-3">
			           <label class="pull-left">    Relation Name  </label>
			           <b class="pull-right">:</b>
		           </div>
		          <div class="col-md-5">
				        <input type="text"  autocomplete="off"  id="txtRelationName" errorMessage="Please Enter Relation Name."  style="text-transform:uppercase"  onlyText="100" maxlength="100"    data-title="Enter Relation Name" />

		           </div>
		          <div class="col-md-3">
			           <label class="pull-left">    Relation Phone    </label>
			           <b class="pull-right">:</b>
		           </div>
		          <div class="col-md-5">
				          <input type="text"  autocomplete="off"  id="txtRelationPhoneNo"   data-title="Enter Relation Phone No"
					           onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)});"  onlynumber="10"    />
		           </div>
		           
	          </div>
                
                 <div class="row">
                     <div class="col-md-3">
			           <label class="pull-left" title="Emergency First Name">EMG.First Name</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <input id="txtEmergencyFirstName" type="text"  placeholder="" onlyText="50" data-title="Enter Emergency First Name"/>
                   </div>

                  <div class="col-md-3">
			           <label class="pull-left" title="Emergency Last Name">EMG.Last Name</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <input id="txtEmergencySecondName" type="text"  placeholder="" onlyText="50" data-title="Enter Emergency Last Name"/>
                   </div>





                   <div class="col-md-3">
			           <label class="pull-left" title="Emergency Relation Of">EMG.Relation</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                        <select id="ddlEmergencyRelation" data-title="Select Emergency Relation"></select>  
                   </div>
                   
                  
                 
                  </div>
                 <div class="row">
                    <div class="col-md-3">
			           <label class="pull-left">EMG.Mobile No.</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <input id="txtEmergencyNumber" type="text" onlynumber="10" data-title="Enter Emergency Mobile No."/>
                   </div>

                     <div class="col-md-3">
			           <label class="pull-left">EMG.Resident.No</label>
			           <b class="pull-right">:</b>
		           </div>
                    <div class="col-md-2">
                        <input type="text" id="txtResidentialStdCode" class="ItDoseTextinputNum" data-title="Enter Emergency Residential Code"/> 
                    </div>

		           <div class="col-md-3">
                          <input id="txtResidentialNumber" type="text" onlynumber="10" data-title="Enter Emergency Residential No."/>
                   </div>

                      <div class="col-md-3">
			           <label class="pull-left">EMG.Address</label>
			           <b class="pull-right">:</b>
		           </div>

                     <div class="col-md-5">
                         <textarea id="txtEmergencyAddress" class="customTextArea" data-title="Enter Emergency Adrress"></textarea>
                     </div>
                 </div>
           <div class="row">
                     <div class="col-md-3">
                      <label data-title="Is International Patient." class="pull-left"> Is International   </label>
				      <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                      <select   onchange="onIsInterNationPatientChange(this)" id="ddlIsInterNationPatient" tabindex="12"  errorMessage="Please Select Is International Field." data-title="Select Yes If Patient Is International" >
                          <option value="0">Select</option>
                          <option value="2" selected="selected">No</option>
                          <option value="1">Yes</option>
                      </select>
		           </div>
                <div class="col-md-3">
                    <label  class="pull-left"> Country </label>
				    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-5 divInternationalDetails">
                     <select disabled id="ddlInternationalCountry" onchange="$onInternationalCountryChange(this)" data-title="Select Country" ></select>
                 </div>
                <div class="col-md-3">
			           <label class="pull-left">    Locality   </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
				         <input type="text" id="txtPlace" autocomplete="off"  data-title="Enter Locality" onlytextnumber="30" maxlength="30"  />
		           </div> 
                
                </div>
                <div class="row">
                 <div class="col-md-3">
			           <label class="pull-left">Passport Number</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5 divInternationalDetails">
                          <input id="txtOverSeaNumber" disabled allowfirstzero onlytextnumber="25" errormessage="Enter Passport Number." type="text" data-title="Enter Passport No." />
                   </div>
                    <div class="col-md-3">
			           <label class="pull-left">International No.</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5 divInternationalDetails">
                          <input id="txtInternationalNumber" disabled  allowfirstzero onlynumber="14" errormessage="Enter International Number." type="text" data-title="Enter Internamtional Mobile No." />
                   </div>
                </div>
                 <div class="row">
		          <div class="col-md-3">
			           <label class="pull-left">   Membership  No. </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			         <input type="text" id="txtMembershipCardNo"   onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)})" autocomplete="off"   data-title="Enter Membership Card No. (Press Enter To Search)" onlytextnumber="30" maxlength="30" style="display:<%=GetGlobalResourceObject("Resource", "IsmembershipCardLink") %>" />                

		           </div>
		           <div class="col-md-3">
			           <label class="pull-left">  Patient Type      </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			  
			          <select id="ddlPatientType" data-title="Select Patient Type."></select>    
		           </div>
		           <div class="col-md-3">
				        <label class="pull-left"><%--Patient Type Ref.--%> Emp.refID   </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			          <input type="text" autocomplete="off"  id="txtTypeRefernce" onkeyup="checkEmpid(event)" onlytextnumber="30" data-title="Enter Patient Type Ref. No."/>
		           </div>
		
	          </div>
	      
           
         <div class="row">
            <div class="col-md-3">
			           <label class="pull-left">Identity Mark</label>
			           <b class="pull-right">:</b>
		           </div>
		    <div class="col-md-5">
			           <textarea id="txtIdentityMark" class="customTextArea" data-title="Enter Identity Mark."></textarea>
		           </div>
            <div class="col-md-3">
			           <label class="pull-left">Identity Mark 2</label>
			           <b class="pull-right">:</b>
		           </div>
		    <div class="col-md-5">
			           <textarea id="txtIdentityMarkSecond" class="customTextArea"   data-title="Enter Second Identity Mark." ></textarea>
		           </div> 
            <div class="col-md-3">
                             <label class="pull-left">  Referral Type </label>
				             <b class="pull-right">:</b>
                         </div>      
            <div class="col-md-4">
                             <select id="ddlReferenceType" data-title="Select Reference Type."></select>
                         </div>   
             <div class="col-md-1" style="padding-left: 0px;">
                 <input type="button" onclick="onCreateNewtypeOfReferenceModelOpen()" value="New" />
             </div>
         </div>
        <div class="row">
            <div class="col-md-3">
                       <label class="pull-left"> MLC NO.     </label>
				        <b class="pull-right">:</b>
                   </div>
		         <div class="col-md-2">
                        <input type="text" autocomplete="off" id="txtMLCNO" onlytextnumber="30" data-title="Enter MLC No.">
                    </div>
                 <div class="col-md-3">
                        <select id="ddlMLCType" title="Select MLC Type" data-title="Select MLC Type">
                            <option value="0">Select</option>
                            <option value="RTA">RTA</option>
                            <option value="Poisoining">Poisoining</option>
                            <option value="Burns">Burns</option>
                            <option value="Hanging">Hanging</option>
                            <option value="Assaults">Assaults</option>
                        </select>
                    </div>
            
             
                <div class="col-md-3">
			           <label class="pull-left">Remarks</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <input id="txtremarks" type="text" data-title="Enter Remarks" />
                   </div>
                     <div class="col-md-3">
			           <label class="pull-left">Language</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <select id="ddlLanguage"> </select>
                   </div>
               
            
            </div>
	       </div>
           <div class="col-md-3"></div>
        </div>
    </div>







	 <div class="POuter_Box_Inventory hidden">
		<div style="cursor:pointer"    class="Purchaseheader">
			Additional Details
		</div>
		  
         <div      class="row  divPatientAdditionalDetails">
             <div class="col-md-21">
                 


                  <div class="row">
                   <div class="col-md-3">
			           <label class="pull-left">Ethenic Group</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <select id="ddlEthenicGroup"> </select>
                   </div>
                   
              
                 
                    <div class="col-md-3">
			           <label class="pull-left">Translator Req.</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <select id="ddlTranslatorRequired">
                              <option value="0">No</option>
                              <option value="1">Yes</option>
                          </select>
                   </div>




                  </div>
                  
                 <div class="row">
                   <div class="col-md-3">
			           <label class="pull-left">Financial Status</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <select id="ddlFacialStatus"> </select>
                   </div>
                   
                  <div class="col-md-3">
			           <label class="pull-left">Race</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <select id="ddlRace"> </select>
                   </div>
                 
                    <div class="col-md-3">
			           <label class="pull-left">Employment </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <select id="ddlEmployment"> </select>
                   </div>




                  </div>
                  

                 <div class="row">
                   <div class="col-md-3">
			           <label class="pull-left">Occupation</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <input id="txtOccupation" type="text" />
                   </div>
                   
                  <div class="col-md-3">
			           <label class="pull-left">Monthly Income</label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
                          <input id="txtMonthlyIncome" type="text" onlynumber="10" />
                   </div>
                 
                  </div>
                  <div class="row">

                <%--       <div class="col-md-3 ">
			           <label class="pull-left">    State   </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-4 ">
			        <select id="ddlState"   data-title="Select State" onchange="$onStateChange($('#ddlCountry').val(),this.value)"></select></div>
		            <div style="padding-left: 0px;"  class="col-md-1 ">
			         <input type="button" class="" value="New" id="btnNewState" data-title="Click to Create New State"  onclick="$addNewStateModel()" />

		         </div>--%>
                 
              

                  </div>

             </div>
         </div>

	 </div>
</div>

     <div class="POuter_Box_Inventory">
        <div  class="Purchaseheader billingDetails" onclick="togglePatientDetailSection(this)" style="cursor:pointer">
                  Billing Details
        </div>
        <div class="row">
        <div class="col-md-21">
           <UC1:PanelDetailsControl ID="PanelDetailsControl1" runat="server" />
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Referral  Type     </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlReferalType" title="Select Referral  Type" onchange="BindDoctorOrReferalDoc();" class="searchable"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Refer Doctor      </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <select id="ddlReferDoctor" title="Select Refer Doctor" onchange="bindPROAccordingToReferDoctorID(this.value)" class="searchable"></select>
                </div>
                <div style="padding-left: 0px;" class="col-md-1">
                    <input type="button" value="New" id="btnRefferBy" title="Click To Add New Refer Doctor" onclick="$addNewDoctorReferModel()" />
                </div>
                <div class="col-md-3" style="display:none">
                    <label class="pull-left">PRO Name      </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-4" style="display:none">
                    <select id="ddlPROName" title="Select PRO Name" class="searchable"></select>
                </div>
                <div style="padding-left: 0px; display:none" class="col-md-1">
                    <input type="button" class="ItDoseButton" value="New" id="btnAddNewPRO" title="Click To Add New PRO" onclick="$addNewPROModel()" />
                </div>
            </div>
            <div class="row doctorDetailsRow">
                <div class="col-md-3">
                    <label class="pull-left">Clinic/Dept.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlDepartment" data-title="Select Doctor" onchange="$bindDoctor($(this).find('option:selected').text(),function(){})" class="searchable"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left" id="lblDoctortext">Doctor       </label>
                    <b class="pull-right">: </b>
                </div>
                <div class="col-md-5">
                    <select id="ddlDoctor" title="Select Doctor" onchange="onDoctorChange(this,event)"></select>
                </div>
                <div class="col-md-3" id="divConDr" style="display:none">
                    <label class="pull-left">Consultants     </label>
                    <b class="pull-right">: </b>
                </div>
                <div class="col-md-5" id="divConDrs" style="display:none">
                    <select id="ddlConsultent" title="Select Doctor" onchange="appendTeamMember()" ></select>
                </div>
            </div>
        </div>
       <div class="col-md-3">
                 <div class="row" >
				 <div class="col-md-24">
					  <button style="width:100%;font-weight:bold;display:none" class="label label-success" type="button">Mother IPD : <span id="spnIPDNo"></span></button>
				 </div>
			 </div>
			   <div class="row" >
				 <div class="col-md-24">
					  <button  style="width:100%;font-weight:bold;" class="label label-important reg" type="button">Reg. Charge :&nbsp;<span id="spanRegistrationCharges"  >0</span></button>
				 </div>
			 </div>
            </div>
       </div>

    </div>

<div id="divAddState"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:320px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddState" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add State</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">    State Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="30" id="txtStateName" class="form-control ItDoseTextinputText" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveNewState({CountryID:$('#ddlCountry').val(),StateName:$('#txtStateName').val()})">Save</button>
						 <button type="button"  data-dismiss="divAddState" >Close</button>
				</div>
			</div>
		</div>
	</div>

<div id="divAddDistrict"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:320px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddDistrict" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add District</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">    District Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="30" id="txtNewDistrict" class="form-control ItDoseTextinputText" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveNewDistrict({District:$('#txtNewDistrict').val(),countryID:$('#ddlCountry').val(),stateID:$('#ddlState').val()})">Save</button>
						 <button type="button"  data-dismiss="divAddDistrict" >Close</button>
				</div>
			</div>
		</div>
	</div>

<div id="divAddCity"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:320px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddCity" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add City</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">    City Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="30" id="txtCityName" class="form-control ItDoseTextinputText" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveNewCity({City:$('#txtCityName').val(),Country:$('#ddlCountry').val(),StateID:$('#ddlState').val(),DistrictID:$('#ddlDistrict').val()})">Save</button>
						 <button type="button"  data-dismiss="divAddCity" >Close</button>
				</div>
			</div>
		</div>
	</div>

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
<span id="spnIsRegistrationApply" style="display:none;">0</span>
<div id="divAddPRO"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:550px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddPRO" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add New PRO</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-6">
							   <label class="pull-left">Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div class="col-md-18">
							   <input type="text" autocomplete="off" style="border-bottom-color:red;border-bottom-width:2px" onlyText="50" maxlength="50" allowCharsCode="40,41"   id="txtPROName" style="text-transform:uppercase"   maxlength="50"  title="Enter Refer Doctor Name" />
						  </div>
					</div>

				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$savePRO({Name:$('#txtPROName').val()})">Save</button>
						 <button type="button"  data-dismiss="divAddPRO" >Close</button>
				</div>
			</div>
		</div>
    </div>
<div id="divGetFamilyNumber" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;min-width: 900px;max-width:80%">
                <div class="modal-header">
                    <button type="button" class="close" onclick="onGetFamilyNumberModelClose()" aria-hidden="true">×</button>
                    <h4 class="modal-title">Merge Family Number ( <span class="patientInfo" id="spnSelectedPanel" style="display:none"></span> )</h4>
                </div>
                <div class="modal-body">
                     <div class="row">
					 <div  class="col-md-4">
						  <label class="pull-left">  UHID    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">

						  <input type="text" id="txtFFolderNumber" maxlength="20" />
					 </div>
					 <div  class="col-md-4">
						   <label class="pull-left"> Family Number   </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						 <input type="text" maxlength="50" autocomplete="off"  id="txtFFamilyNumber" />
					 </div>
				 </div>
				  <div class="row">
					 <div  class="col-md-4">
						  <label class="pull-left">  First Name    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						   <input type="text" onlytext="50" id="txtFFirstName" />
					 </div>
					 <div  class="col-md-4">
						   <label class="pull-left"> Last Name   </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						   <input type="text" onlytext="50" id="txtFLastName" />
					 </div>
				 </div>

				  <div class="row">
					 <div  class="col-md-4">
						  <label class="pull-left">  Contact No.   </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						 <input type="text" onlynumber="10" id="txtFMobileNumber" />
					 </div>
					 <div  class="col-md-4" style="display:none">
						   <label class="pull-left"> Staff ID    </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8" style="display:none">
						 <input type="text"  id="txtFAddress" />
					 </div>
				 </div>

                 <div style="text-align:center" class="row">
                      <button type="button" onclick="searchFamilyNumber();">Search</button>
				</div>
				<div style="height:200px"  class="row">
					<div id="divSearchModelFamilyNumberResults" class="col-md-24">
					</div>
				</div>

                </div>
                  <div class="modal-footer">
                         <button type="button" class="save" onclick="onGetFamilyNumberModelClose()">Close</button>
                </div>
            </div>
        </div>
    </div>
<div id="divAddPurposeOfVisit"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:320px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddPurposeOfVisit" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add Perpose Of Visit</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">    Visit Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="30" id="txtPurposeOfVisit" class="form-control ItDoseTextinputText" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveNewPurposeOfVisit({PurposeName:$('#txtPurposeOfVisit').val()})">Save</button>
						 <button type="button"  data-dismiss="divAddPurposeOfVisit" >Close</button>
				</div>
			</div>
		</div>
	</div>

<script id="tb_OldPatient" type="text/html">
	<table  id="tablePatient" cellspacing="0" rules="all" border="1" style="width:876px;border-collapse :collapse;">
		<thead>  
			 <tr id="Header"> 
					<th class="GridViewHeaderStyle" scope="col">Select</th>
					<th class="GridViewHeaderStyle" scope="col">Title</th> 
					<th class="GridViewHeaderStyle" scope="col">First Name</th> 
					<th class="GridViewHeaderStyle" scope="col">L.Name</th> 
					<th class="GridViewHeaderStyle" scope="col">UHID</th>
					<th class="GridViewHeaderStyle" scope="col">Age</th> 
					<th class="GridViewHeaderStyle" scope="col">Sex</th> 
					<th class="GridViewHeaderStyle" scope="col">Date</th> 
					<th class="GridViewHeaderStyle" scope="col">Address</th> 
					<th class="GridViewHeaderStyle" scope="col">Contact&nbsp;No.</th> 
					<th class="GridViewHeaderStyle" scope="col" style="display:none;">Card No.</th>   
					<th class="GridViewHeaderStyle" scope="col" style="display:none;">Valid To</th>
					<th class="GridViewHeaderStyle" scope="col">Rel.</th> 
					<th class="GridViewHeaderStyle" scope="col">Relation Name</th> 
                 <th class="GridViewHeaderStyle" scope="col">Transfer Reason</th>  
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
						<tr onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=j+1#>" ondblclick="onPatientSelect(this);" style='cursor:pointer;<#=objRow.IPDDetails!=''?'background-color:orange':'' #>'>                            
						<td class="GridViewLabItemStyle">
					   <a  class="btn" onclick="onPatientSelect(this);" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
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
						<td class="GridViewLabItemStyle" id="tdCardNo"  style="display:none;"><#=objRow.MemberShipCardNo#></td>   
						<td class="GridViewLabItemStyle" id="tdValidTo"  style="display:none;"><#=objRow.MemberShipValidTo#></td>                      
						<td class="GridViewLabItemStyle" id="tdRelation" ><#=objRow.Relation#></td>  
						<td class="GridViewLabItemStyle" id="tdRelationName" ><#=objRow.RelationName#></td> 
                        <td class="GridViewLabItemStyle" id="td1" ><#=objRow.TransferReason#></td>  
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
  


<script type="text/javascript">

    var $bindDocumentMasters = function (callback) {
        serverCall('../../design/common/ScanDocumentServices.asmx/GetMasterDocuments', { patientID: $('#txtPID').val() }, function (response) {
            $responseData = JSON.parse(response);
            documentMaster = $responseData.patientDocumentMasters;
            var $template = $('#template_DocumentMaster').parseTemplate(documentMaster);
            $('#documentMasterDiv').html($template);
            callback(true);
        });
    }



    var previewImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';

    function ShowCaptureImageModel() {
        $('#camViewer').showModel();
        Webcam.set({
            width: 320,
            height: 240,
            image_format: 'jpeg',
            jpeg_quality: 90,
            //force_flash: true
        });
        Webcam.setSWFLocation("../../Scripts/webcamjs/webcam.swf");
        Webcam.attach('#webcam');
    }


    function closeCamViewer(callback) {
        $('#camViewer').closeModel();
        document.getElementById('imgPreview').src = previewImage;
        Webcam.reset();
        callback();
    }


    function selectImage(base64image) {
        base64image = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
        closeCamViewer(function () {
            document.getElementById('imgPatient').src = base64image;
            $('#spnIsCapTure').text('1');
        });
    }

    function showDocumentMaster() {
        $('#divDocumentMaters').show();
    }


    function documentNameClick(elem, row) {
        $(row.parentNode).find('tr button[type=button]').attr('style', 'width: 100%; text-align: center; max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;')
        $('#tblDocumentMaster tr #tdBase64Document').each(function (index, elem) {
            if (!String.isNullOrEmpty($(this).text()))
                $(this).parent().find('button[type=button]').css({ 'backgroundColor': 'LIGHTGREEN', 'background-image': 'none' });
        });
        $(elem).css({ 'backgroundColor': 'antiquewhite', 'background-image': 'none' });
        elem.style.color = 'black';
        var $seletedDocumentID = $(row).find('#tdDocumentID').text();
        $('#spnSelectedDocumentID').text($seletedDocumentID);
        var $scanDocument = $(row).find('#tdBase64Document')[0].innerHTML;
        if ($scanDocument != '')
            document.getElementById('imgDocumentPreview').src = $scanDocument;
        else {
            var patientId = document.getElementById('txtPID').value;
            if (patientId != '') {
                serverCall('../../design/common/ScanDocumentServices.asmx/GetDocument', { patientId: patientId, documentName: elem.value }, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status)
                        document.getElementById('imgDocumentPreview').src = $responseData.data;
                    else
                        document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+XCanHAAAC1BJREFUeNrs3flT01wbxnGhFUT2vcoiZR9AdMQZ///f1QFEZZO9QIvUQilQ1uea3vMeM+lC1b4Pwef7+YEp6clJGnLl3ElLU5VIJB4B+BtVswkA4g2AeAMg3gCINwDiDYB4A8QbAPEGQLwBEG8AxBsA8QaINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbIN4AiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3QLwBEG8AxBsA8QZAvAEQb4B4AyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AAizMJnig9vf3V1dXSzR4/Pjx27dvQ6EQ24rRGw/M6elp6QaXOWwo4g2A4hz35/b2NpFIJJPJbDarxxcXF3fO8uXLl6qqqoosXf2o2m9paYlEIhT8D0WV9hi2QvBdXV0tLCycnJzc+5rU19dPT0+TcIpzVMz6+noQsi2ZTGZra4u/CPFGxRweHgZnZQ4ODviLEG9Usjj3/hoOh5ubm3UyfC8rU85pP4KAS2sPT3t7+9jYWHV19e3t7erqajwe/7U/eTjc1NSkU2g7OlxfX5+enh4dHRFa4o37Nzw8rGw/yl3NHhoaUql8c3NTzowNDQ29vb06OhS8nH58fByLxQJ1FgDi/d9ib1D9PLmqrg6FQnfGW22i0WgkEinRpiknlUqtrKxks1k2Nefe+LepIP/+/bv7VUX1nR9N0+Hg5cuXvmxbTZ7JZHyzt7S0vH79WuM8m5rRG/dgeXlZyVQC9XN7e/vOcXtqakpn2m5KIpHY399Pp9M6UtiUp0+fdnV1PXv2zN7N1uFgcnJyfn7+7OyMrU288a9SKV7+O8+Dg4Mu2yq5v379au+f6+ig6artLy4uVAJsbGzs7u6OjY01NzdbwsfHx2dnZ90hAMQbwdLY2Njd3e2yrQFZPzs7O1+8ePHkyRNvwa8hXQlfWFjQUG8JV/g1nivzbEbijSDq7e31lvTKdjQa7enpubq62tvb0zCuM3DlvK2tTUcBnXV/+vRpcXFxZmYmHA7b7GrGAE68ETg6kVZu7XEymVQFHolElG0NyJubmwq2a7mzs6Nsj46O6pT748eP+nVgYEDTa2pqmpqaNCMb84HiyvlfS8l072+r9tZptkK7vr6+trbmzbZJpVJzc3Nqr4Lc+5lTK9RBvBEs3rPr4+Pj1tZWZTgWixVrr9J9aWmpo6Mjm2MT6+rq2JLEG8E77wr/PPO6vLxUUDc2NkrPkk6n7c0w92a4fTwOxBvB4q3AFfVMJnN+fn7nXPaZGXdo4Loa8UYQeT9YWl9f/+PHj3LmUgGvbNfW1uZ3AuKNoFCl7R7rjLrMuTRct7W1uWtyOmlnSxJvBM7FxYVLeFdXl/dKWwkKdl9fnyvvNZizJYk3gsh95qy6unpkZKScr1WMRqPuank8Hs9/Cw3EG4FwcHDgquvm5uaJiQnv5fT8cXtgYOD58+f26+XlJd+pRrwRaMvLy+6LnFpbW9+8edPd3Z3/dpeeevXqle9DrL5vgMKDw4dS/3Ln5+efP3+enJy0cbumpkZV+uDgoEb1bDZ7c3OjKflf27ayslLmlXYQb9yndDo9Nzc3Pj7u/jM0FAppuC7YWDW5xm2yTbzxYJydnc3Ozuq8uqenR8N1wTbX19fxeFzn29TkxBsPzO3tbSwW293dbcnJ/6bUZDLJdXLijYcd8h85bIr/Aq6cPwyBuqcX/2dCvFFJ7osZgoB/AifeqKT+/v6ADOBaDfsuFwQfNwB+ME5PTzc2NlKpVJn3JKm4cDisIkIHmjI/vg7iDYDiHADxBkC8AeINgHgDIN4AiDcA4g2AeP9Vstns0dFRAL+K3Lti5axksTZXV1eanslk+FsT7/+Lra2tLzluJ0skEvo1CJ/2Ozw8XFhY0M+gbTTvipWzksXaaJtr+ubmJvvh7+H/ve9wcnJi/x2tkWR6etoeaEpLS8u9r1t7e3t9fX0APwEe2BUj3igsnU5rJO/v7/dN1zCeSqWUee3N2q3z/1lSNafGpXA4HAqF9EAtu7u71fLR/76HvKurK5lM2gObaDcPUIc9PT21tbXWTLPYvYHcXOfn51ZT2HQ9jsfjdiOxjo4ONbBF61f7emMrdBU8raTvqfyXo8cNDQ0WVLVUe5vR2qiBHutFaYk6Aj7K/cOJ2ltvvhVztALqytZQr0492HZwpbi9dnWlF+6+Gc4rf+OwZ1Kc/6nOzk793N7e9t3LXoF3Xyq6t7dXsMLU3ry+vq5msVjMRv7FxUXrZz1nfn5ez9q9+1T2a8pVjjqcnZ3VA+vBelZs9Hh/f9/uCqjHFiR1qMZ2a24didShkqC9X+usNnZaqypXjxVIa6/HlkwvrYZN1EI1r16RVuD6+trN6FZbK2BtbKIWrYl26PGumK/YtjW0V+e2g1FXdmRRG1uub/aCG4edk9H7T2m8tWR++/bN3a9LU7RHai+fmZnRT+2p2imVYe+I5LS2tk5MTNj4Y1l143xvb69yqB40UYvQoWR0dFTT19bWtBNrqFSHeqDgaWy0kEciEV//doI6NTWlQU9hfv/+vdZN7dWb5tW6abpir6UoPIODg5bh/FOMoaEhrYxemqKoF3t2dqYHbW1tbkZ1pWf1ctRM9ci7d+/sQKOu9LqUT1854CvaXR2hg4U61IxuO0SjUXtWMdZ2UEXjHZyLbZwSiwPxLpf2qg8fPmh3d+OVjU6NjY32FeK2m3pv3FeQ1Zzee/FaTW47vQ2DNsQ56rmurk49K7c2yOcfQWy5GtC8ta7NqxgozLbEvr4+hVALsnjnfwmMntrZ2bG7fP/cS8JhO0wocjajO8YpZr61LUGrtLS0dOcm0pFCSVZjb7ytAMnfOCDeldhS4fDw8LDqSe8UlyL3oMRdfry7aYlmCpKKBferXaDScK1YqjRQ8NQg/5xTHWoFxsfHfT3bgcDOVzXk6lBitYMypn58jbVuqup1KFEVoOOCjaKuH8Vb/WiK5rJDks5NFDaNunpWhw8VL6Vfu7Kt9ddKqnMNvFqTgs1K3Ie84MYB594VoJ3YTsLdOGyDquptDXoax9xZesGByy4s2T5d8MK7RVH5sbpAsxzmuKcUsGLz2nJV8dpRxkpr99RZjma0cdgGwIaGhmK5skV7Y2YVhGbUU+41WgO7OuC7KlGQFQU6k9fq5d971DrRxrSX6atQSmwcMHpXhk4+rW60X8fGxjQiuVFIw2P+pXW3Z7vBTRWyK8i9NCZrZLMLYG7iyMiIPaXOvSOnjy1XwXDjrbvRp1JtebaE+H71nQXYUlSk6KTD96xVEHYlwl2S0NFtO6fYcc1L47xdZdSryO9fgbdg61m11Ev2Hl9KbBwUw5cxVYDGE3tjrOD7NHbJTbEZGhrS/lqsWX6Hj379O0ntkphVrb/9ppH1UPB9qWJLVOM7z0pc/a+NUOx12bOle/vtjcPojd9RZhJqcyrYYcELBH++0//S0n91iaU3Qjmb6Lc3DvFG5WkgValZ5uAGUJwDuBtXzgHiDYB4AyDeAIg3AOINgHgDxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbAPEGiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AiDcA4g2AeAMg3gCIN0C8ARBvAMQbAPEGQLwBFPSPAAMA10pqClMkh7QAAAAASUVORK5CYII=';
                });
            }
            else
                document.getElementById('imgDocumentPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
        }
    }



    function showScanModel() {
        if ($('#spnSelectedDocumentID').text() != '') {
            serverCall('../../design/common/ScanDocumentServices.asmx/GetShareScanners', {}, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    $('#ddlSccaner').bindDropDown({
                        data: $responseData.data,
                        defaultValue: null,
                        valueField: 'DeviecId',
                        textField: 'Name'
                    });
                }
                else
                    modelAlert('Error While Access Scanner');
            });
            document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+XCanHAAAC1BJREFUeNrs3flT01wbxnGhFUT2vcoiZR9AdMQZ///f1QFEZZO9QIvUQilQ1uea3vMeM+lC1b4Pwef7+YEp6clJGnLl3ElLU5VIJB4B+BtVswkA4g2AeAMg3gCINwDiDYB4A8QbAPEGQLwBEG8AxBsA8QaINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbIN4AiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3QLwBEG8AxBsA8QZAvAEQb4B4AyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AAizMJnig9vf3V1dXSzR4/Pjx27dvQ6EQ24rRGw/M6elp6QaXOWwo4g2A4hz35/b2NpFIJJPJbDarxxcXF3fO8uXLl6qqqoosXf2o2m9paYlEIhT8D0WV9hi2QvBdXV0tLCycnJzc+5rU19dPT0+TcIpzVMz6+noQsi2ZTGZra4u/CPFGxRweHgZnZQ4ODviLEG9Usjj3/hoOh5ubm3UyfC8rU85pP4KAS2sPT3t7+9jYWHV19e3t7erqajwe/7U/eTjc1NSkU2g7OlxfX5+enh4dHRFa4o37Nzw8rGw/yl3NHhoaUql8c3NTzowNDQ29vb06OhS8nH58fByLxQJ1FgDi/d9ib1D9PLmqrg6FQnfGW22i0WgkEinRpiknlUqtrKxks1k2Nefe+LepIP/+/bv7VUX1nR9N0+Hg5cuXvmxbTZ7JZHyzt7S0vH79WuM8m5rRG/dgeXlZyVQC9XN7e/vOcXtqakpn2m5KIpHY399Pp9M6UtiUp0+fdnV1PXv2zN7N1uFgcnJyfn7+7OyMrU288a9SKV7+O8+Dg4Mu2yq5v379au+f6+ig6artLy4uVAJsbGzs7u6OjY01NzdbwsfHx2dnZ90hAMQbwdLY2Njd3e2yrQFZPzs7O1+8ePHkyRNvwa8hXQlfWFjQUG8JV/g1nivzbEbijSDq7e31lvTKdjQa7enpubq62tvb0zCuM3DlvK2tTUcBnXV/+vRpcXFxZmYmHA7b7GrGAE68ETg6kVZu7XEymVQFHolElG0NyJubmwq2a7mzs6Nsj46O6pT748eP+nVgYEDTa2pqmpqaNCMb84HiyvlfS8l072+r9tZptkK7vr6+trbmzbZJpVJzc3Nqr4Lc+5lTK9RBvBEs3rPr4+Pj1tZWZTgWixVrr9J9aWmpo6Mjm2MT6+rq2JLEG8E77wr/PPO6vLxUUDc2NkrPkk6n7c0w92a4fTwOxBvB4q3AFfVMJnN+fn7nXPaZGXdo4Loa8UYQeT9YWl9f/+PHj3LmUgGvbNfW1uZ3AuKNoFCl7R7rjLrMuTRct7W1uWtyOmlnSxJvBM7FxYVLeFdXl/dKWwkKdl9fnyvvNZizJYk3gsh95qy6unpkZKScr1WMRqPuank8Hs9/Cw3EG4FwcHDgquvm5uaJiQnv5fT8cXtgYOD58+f26+XlJd+pRrwRaMvLy+6LnFpbW9+8edPd3Z3/dpeeevXqle9DrL5vgMKDw4dS/3Ln5+efP3+enJy0cbumpkZV+uDgoEb1bDZ7c3OjKflf27ayslLmlXYQb9yndDo9Nzc3Pj7u/jM0FAppuC7YWDW5xm2yTbzxYJydnc3Ozuq8uqenR8N1wTbX19fxeFzn29TkxBsPzO3tbSwW293dbcnJ/6bUZDLJdXLijYcd8h85bIr/Aq6cPwyBuqcX/2dCvFFJ7osZgoB/AifeqKT+/v6ADOBaDfsuFwQfNwB+ME5PTzc2NlKpVJn3JKm4cDisIkIHmjI/vg7iDYDiHADxBkC8AeINgHgDIN4AiDcA4g2AeP9Vstns0dFRAL+K3Lti5axksTZXV1eanslk+FsT7/+Lra2tLzluJ0skEvo1CJ/2Ozw8XFhY0M+gbTTvipWzksXaaJtr+ubmJvvh7+H/ve9wcnJi/x2tkWR6etoeaEpLS8u9r1t7e3t9fX0APwEe2BUj3igsnU5rJO/v7/dN1zCeSqWUee3N2q3z/1lSNafGpXA4HAqF9EAtu7u71fLR/76HvKurK5lM2gObaDcPUIc9PT21tbXWTLPYvYHcXOfn51ZT2HQ9jsfjdiOxjo4ONbBF61f7emMrdBU8raTvqfyXo8cNDQ0WVLVUe5vR2qiBHutFaYk6Aj7K/cOJ2ltvvhVztALqytZQr0492HZwpbi9dnWlF+6+Gc4rf+OwZ1Kc/6nOzk793N7e9t3LXoF3Xyq6t7dXsMLU3ry+vq5msVjMRv7FxUXrZz1nfn5ez9q9+1T2a8pVjjqcnZ3VA+vBelZs9Hh/f9/uCqjHFiR1qMZ2a24didShkqC9X+usNnZaqypXjxVIa6/HlkwvrYZN1EI1r16RVuD6+trN6FZbK2BtbKIWrYl26PGumK/YtjW0V+e2g1FXdmRRG1uub/aCG4edk9H7T2m8tWR++/bN3a9LU7RHai+fmZnRT+2p2imVYe+I5LS2tk5MTNj4Y1l143xvb69yqB40UYvQoWR0dFTT19bWtBNrqFSHeqDgaWy0kEciEV//doI6NTWlQU9hfv/+vdZN7dWb5tW6abpir6UoPIODg5bh/FOMoaEhrYxemqKoF3t2dqYHbW1tbkZ1pWf1ctRM9ci7d+/sQKOu9LqUT1854CvaXR2hg4U61IxuO0SjUXtWMdZ2UEXjHZyLbZwSiwPxLpf2qg8fPmh3d+OVjU6NjY32FeK2m3pv3FeQ1Zzee/FaTW47vQ2DNsQ56rmurk49K7c2yOcfQWy5GtC8ta7NqxgozLbEvr4+hVALsnjnfwmMntrZ2bG7fP/cS8JhO0wocjajO8YpZr61LUGrtLS0dOcm0pFCSVZjb7ytAMnfOCDeldhS4fDw8LDqSe8UlyL3oMRdfry7aYlmCpKKBferXaDScK1YqjRQ8NQg/5xTHWoFxsfHfT3bgcDOVzXk6lBitYMypn58jbVuqup1KFEVoOOCjaKuH8Vb/WiK5rJDks5NFDaNunpWhw8VL6Vfu7Kt9ddKqnMNvFqTgs1K3Ie84MYB594VoJ3YTsLdOGyDquptDXoax9xZesGByy4s2T5d8MK7RVH5sbpAsxzmuKcUsGLz2nJV8dpRxkpr99RZjma0cdgGwIaGhmK5skV7Y2YVhGbUU+41WgO7OuC7KlGQFQU6k9fq5d971DrRxrSX6atQSmwcMHpXhk4+rW60X8fGxjQiuVFIw2P+pXW3Z7vBTRWyK8i9NCZrZLMLYG7iyMiIPaXOvSOnjy1XwXDjrbvRp1JtebaE+H71nQXYUlSk6KTD96xVEHYlwl2S0NFtO6fYcc1L47xdZdSryO9fgbdg61m11Ev2Hl9KbBwUw5cxVYDGE3tjrOD7NHbJTbEZGhrS/lqsWX6Hj379O0ntkphVrb/9ppH1UPB9qWJLVOM7z0pc/a+NUOx12bOle/vtjcPojd9RZhJqcyrYYcELBH++0//S0n91iaU3Qjmb6Lc3DvFG5WkgValZ5uAGUJwDuBtXzgHiDYB4AyDeAIg3AOINgHgDxBsA8QZAvAEQbwDEGwDxBog3AOINgHgDIN4AiDcA4g0QbwDEGwDxBkC8ARBvAMQbAPEGiDcA4g2AeAMg3gCINwDiDRBvAMQbAPEGQLwBEG8AxBsg3gCINwDiDYB4AyDeAIg3AOINEG8AxBsA8QZAvAEQbwDEGyDeAIg3AOINgHgDIN4AiDdAvAEQbwDEGwDxBkC8ARBvgHgDIN4AiDcA4g2AeAMg3gCIN0C8ARBvAMQbAPEGQLwBFPSPAAMA10pqClMkh7QAAAAASUVORK5CYII=';
            $('#scanViewer').showModel();
        }
        else
            modelAlert('Please Select Document First !!');
    }


    function scanDocument(deviceId) {
        serverCall('../../design/common/ScanDocumentServices.asmx/Scan', { deviceID: deviceId }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status)
                $('#imgScanPreview').attr('src', 'data:image/jpeg;base64,' + $responseData.data);
            else
                modelAlert('Error While Scan');
        });
    }


    function selectScanDocument(base64Document) {
        var $selectedDocumentID = $('#spnSelectedDocumentID').text().trim();
        $('#tblDocumentMaster tr td#tdDocumentID').each(function () {
            if (this.innerHTML.trim() == $selectedDocumentID) {
                $(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                $('#imgDocumentPreview').attr('src', base64Document);
                $('#scanViewer').closeModel();
            }
        });
    }



    function showCaptureModel() {
        if ($('#spnSelectedDocumentID').text() != '') {
            document.getElementById('imgScanPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
            $('#documentCamViwer').showModel();
            Webcam.set({
                width: 320,
                height: 240,
                image_format: 'jpeg',
                jpeg_quality: 90,
                //force_flash: true
            });
            Webcam.setSWFLocation("../../Scripts/webcamjs/webcam.swf");
            Webcam.attach('#documentWebCam');


        }
        else
            modelAlert('Please Select Document First !!');

    }


    function takeProfilePictureSnapShot() {
        Webcam.snap(function (data_uri) {
            $('#imgPreview').attr('src', data_uri);
            $('#btnSelectImage').show();
        });
    }
    function selectPatientProfilePic(base64Image) {
        closeCamViewer(function () {
            document.getElementById('imgPatient').src = base64Image
            $('#spnIsCapTure').text('1');
        });
    }



    function takeDocumentSnapShot() {
        Webcam.snap(function (data_uri) {
            $('#imgDocumentSnapPreview').attr('src', data_uri);
            $('#btnSelectDocumentCapture').show();
        });
    }


    function selectDocumentCapture(base64Document) {
        var $selectedDocumentID = $('#spnSelectedDocumentID').text().trim();
        $('#tblDocumentMaster tr td#tdDocumentID').each(function () {
            if (this.innerHTML.trim() == $selectedDocumentID) {
                $(this.parentNode).find('#tdBase64Document')[0].innerHTML = base64Document;
                $('#imgDocumentPreview').attr('src', base64Document);
                $('#documentCamViwer').closeModel();
            }
        });
        Webcam.reset();
    }

    function closeDocumentCamViwer() {

        $('#documentCamViwer').closeModel();
        document.getElementById('imgDocumentSnapPreview').src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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';
        Webcam.reset();
    }

    function divDocumentMatersCloseModel() {
        getUpdatedPatientDocuments(function (responseData) {
            $('#btnDocumentMaster').val(responseData.length + "  Document's");
            $('#divDocumentMaters').closeModel();
        });
    }



    function getUpdatedPatientDocuments(callback) {
        var patientDocuments = [];
        $('#tblDocumentMaster tr td#tdDocumentID').each(function () {
            if ($(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim() != '') {
                var $document = {
                    documentId: this.innerHTML.trim(),
                    name: $(this.parentNode).find('#btnDocumentName').val(),
                    data: $(this.parentNode).find('#tdBase64Document')[0].innerHTML.trim()
                }
                patientDocuments.push($document);
            }
        });
        callback(patientDocuments);
    }



</script>


<div id="oldPatientModel" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 900px;max-width:80%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeOldPatientSearchModel()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title"><span id="spnPatientType"></span><span id="spnPatientTypeID" style="display:none"></span></h4>
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
						   <label class="pull-left"> IPD No.   </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						 <input type="text" maxlength="10" autocomplete="off"  id="txtIPDNo" />
					 </div>
				 </div>
				  <div class="row">
					 <div  class="col-md-4">
						  <label class="pull-left">  First Name    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						   <input type="text" onlytext="50" id="txtSearchModelFirstName" />
					 </div>
					 <div  class="col-md-4">
						   <label class="pull-left"> Last Name   </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						   <input type="text" onlytext="50" id="txtSearchModelLastName" />
					 </div>
				 </div>

				  <div class="row">
					 <div  class="col-md-4">
						  <label class="pull-left">  Contact No.   </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						 <input type="text" onlynumber="10" id="txtSerachModelContactNo" />
					 </div>
					 <div  class="col-md-4">
						   <label class="pull-left"> Address    </label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						 <input type="text"  id="txtSearchModelAddress" />
					 </div>
				 </div>

				   <div class="row" style="display:none">
					 <div  class="col-md-4">
						  <label class="pull-left"> Relation Name </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-3">
							<select id="ddlModelrelation" onchange="$onModelRelationChange(this.value)"></select>   	
							
					 </div>
						<div  class="col-md-5">
							<input type="text"  autocomplete="off"  id="txtModelRelationName"  style="text-transform:uppercase;" disabled="disabled" onlyText="100" maxlength="100" data-title="Enter Relation Name" /> 
							</div>
					 <div  class="col-md-4">
						   <label class="pull-left"> DOB </label><input id="ChkModelDOB" type="checkbox" value="true" class="pull-left" />
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						<asp:TextBox ID="txtModelDOB" runat="server" ReadOnly="false"  ClientIDMode="Static" data-title="Enter DOB (DD-MM-YYYY)" placeholder="DD-MM-YYYY" onblur="$onDateOfBirthChange(this.value)"  onkeyup="clearDateOfBirth(event);validateDOB(this,event);" ToolTip="Select DOB (DD-MM-YYYY)" maxlength="10" ></asp:TextBox>
						   <cc1:CalendarExtender ID="CalExtTxtModelDOB" TargetControlID="txtModelDOB" Format="dd-MM-yyyy" runat="server" ></cc1:CalendarExtender> 
                       <cc1:FilteredTextBoxExtender  ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers,Custom" ValidChars="-" TargetControlID="txtModelDOB"></cc1:FilteredTextBoxExtender>
					 </div>
				 </div>

				 <div class="row">
					 <div  class="col-md-4">
						  <label class="pull-left">From Date</label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						   <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Date of Registration" ></asp:TextBox>
						   <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
					 </div>
					 <div  class="col-md-4">
						   <label class="pull-left">To Date</label>
						   <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-8">
						  <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true"  ClientIDMode="Static"   ToolTip="Select Date of Registration" ></asp:TextBox>
						  <cc1:CalendarExtender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
					 </div>
				 </div>
                 <div class="row">					
                      <div  class="col-md-4">
						  <label class="pull-left"> Family No.   </label>
						  <b class="pull-right">:</b>
					  </div>
					  <div  class="col-md-8">
						 <input type="text" id="txtFamilyNo" />
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


<div id="camViewer" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 900px">
			<div class="modal-header">
			   
				<button type="button" class="close" onclick="closeCamViewer(function(){})" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Capture Patient Image</h4>
			</div>
			<div class="modal-body">
				<div id="Div7">
					<table width="100%">
						<tr>
							<td style="width: 40%">
								<table width="100%">
									<tr>
										<td style="text-align: center">
											<b>Live Camera</b>
										</td>
									</tr>
									<tr>
										<td>
											<div id="webcam" style="width: 100%; height: 300px;"></div>
										</td>
									</tr>
									<tr>
										<td style="text-align: center">
											<input type="button" style="font-weight: bold" onclick="takeProfilePictureSnapShot()"  value="Capture" />
										</td>
									</tr>
								</table>
							</td>
							<td style="width: 60%">
								<div style="width: 100%">
									<div style="width: 100%; overflow: auto">
										<img style="width: 100%; height: 100%;" id="imgPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Preview" />
									</div>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" id="btnSelectImage" style="display:none"  onclick="selectPatientProfilePic(document.getElementById('imgPreview').getAttribute('src'))">Select Image</button>
				<button type="button"  onclick="closeCamViewer(function(){})">Close</button>

			</div>
		</div>
	</div>
</div>

<div id="divDocumentMaters" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width: 900px; height: 600px">
			<div class="modal-header">
				<button type="button" class="close" onclick="divDocumentMatersCloseModel()" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Patient Documents Master</h4>
			</div>
			<div class="modal-body">
				<table style="width: 100%;">
					<tr>
						<td style="width:300px">
							<div id="documentMasterDiv" style="height:470px;overflow:auto">
							  
							</div>
						</td>
						<td style="width:60%;overflow:auto"">
							<img style="width: 100%; height: 470px; cursor:pointer"   src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" id="imgDocumentPreview"  alt="Preview" />
						</td>
					</tr>
				</table>
			</div>
			<div class="modal-footer">
				 <span id="spnSelectedDocumentID" style="display:none"></span>
				 <button type="button" id="btnScan" style="font-weight:bold"  onclick="showScanModel()" >Scan</button>
				 <button type="button" style="font-weight:bold"  onclick="showCaptureModel()" >Capture</button>
				 <input id="file" name="url[]"  style="display:none" type="file" accept="image/x-png,image/gif,image/jpeg,image/jpg"  onchange="handleFileSelect(event)" />
				<%-- <button type="button" id="btnBrowser" onclick="document.getElementById('file').click()" style="font-weight:bold"  >Browse...</button> --%>
				 <button type="button" style="font-weight:bold"  onclick="divDocumentMatersCloseModel()">Close</button>
			</div>
		</div>
	</div>
</div>



<div id="scanViewer"    class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content"  style="width:900px;height:600px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="scanViewer" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Scan Document</h4>
				</div>
				<div class="modal-body">
				   <div  id="Div8">
					  <table width="100%">
						  <tr>
							  <td style="width:20%">
							  <table width="100%">
								  <tr>
									  <td>
										  <b>Select Scanner:</b>
									  </td>
								  </tr>
								  <tr>
										<td>
										 <select class="form-control" style="width:100%;height: 22px;padding: 0px;" id="ddlSccaner"></select>
									  </td>
								  </tr>
								  <tr>
										<td style="text-align:center">
										<input type="button" onclick="scanDocument($('#ddlSccaner').val())"   value="Scan" />
									  </td>
								  </tr>
							  </table>
							  </td>
							  <td style="width:80%">
								  <div style="width:100%" >
									 <div style="width: 100%;height:475px;overflow:auto">
									 <img style="width:100%" id="imgScanPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Red dot" />
									 </div>
								  </div>
							  </td>
						  </tr>
					  </table>
				   </div>
				</div>
				<div class="modal-footer">
					<button type="button"  onclick="selectScanDocument(document.getElementById('imgScanPreview').src)" >Select</button>
					<button type="button"  data-dismiss="scanViewer">Close</button>
				</div>
			</div>
		</div>
   </div>


<div id="documentCamViwer"    class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content"  style="width:900px;height:600px">
				<div class="modal-header">
					<button type="button" class="close" onclick="closeDocumentCamViwer()" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Capture Document</h4>
				</div>
				<div class="modal-body">
				   <div  id="Div9">
					  <table width="100%">
						  <tr>
							  <td style="width:40%">
							  <table width="100%">
								  <tr>
									  <td style="text-align:center">
										  <b >Live Camera</b>
									  </td>
								  </tr>
								  <tr>
										<td>
										 <div id="documentWebCam" style="width:100%;height:300px;">
										 </div>
									  </td>
								  </tr>
								 <tr> 
										<td style="text-align:center">
										<input type="button" style="font-weight:bold" onclick="takeDocumentSnapShot()"   value="Capture" />
									  </td>
								  </tr>
							  </table>
							  </td>
							  <td style="width:60%">
								  <div style="width:100%" >
									 <div style="width: 100%;height:475px;overflow:auto">
									 <img style="width:100%;height: 100%;" id="imgDocumentSnapPreview" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAUoAAADVCAIAAAC+DC5wAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoxMzM0ODJCRkNFMjA2ODExODk2RTkyQTZDOUM2QThFNiIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyN0Y2QzE4QzgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyN0Y2QzE4QjgyMjExMUUzQTA4NEU2Qzc4Qzc3QURDNCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IE1hY2ludG9zaCI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjZGOEVDMzM0MjcyMDY4MTFCOEFFRTA4RkI1QzRCRUMyIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjEzMzQ4MkJGQ0UyMDY4MTE4OTZFOTJBNkM5QzZBOEU2Ii8+IDwvcmRmOkRlc2NyaXB0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" alt="Red dot" />
									 </div>
								  </div>
							  </td>
						  </tr>
					  </table>
				   </div>
				</div>
				<div class="modal-footer">  
					<button type="button" id="btnSelectDocumentCapture"  onclick="selectDocumentCapture(document.getElementById('imgDocumentSnapPreview').src)">Select</button>
					<button type="button"  onclick="closeDocumentCamViwer()">Close</button>
				</div>
			</div>
		</div>
   </div>

<script type="text/javascript">

    $(document).ready(function () {
        $("#txtIDProofNo").keydown(function (e) {
            var txt = $("#ddlIDProof option:selected").text();

            if (txt == "AADHAAR") {
                // Allow: backspace, delete, tab, escape, enter and .
                if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
                    // Allow: Ctrl+A, Command+A
                    (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
                    // Allow: home, end, left, right, down, up
                    (e.keyCode >= 35 && e.keyCode <= 40)) {
                    // let it happen, don't do anything
                    return;
                }
                // Ensure that it is a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            }
        });
        var RegistrationChargesApplicable = '<%=Resources.Resource.RegistrationChargesApplicable %>';
        if (RegistrationChargesApplicable == '1')
            $('.reg').show();
        else
            $('.reg').hide();

    });

    $("#txtIDProofNo").blur(function () {
        var value = $(this).val();
        var len = value.length;
        var count = $("#ddlIDProof").val().split('#')[1];
        var txt = $("#ddlIDProof option:selected").text();

        if (txt == "AADHAAR") {
            if (count != len) {
                if (len > 0) {
                    modelAlert("Adhaar no. should be 12 digits", function () {
                        $("#txtIDProofNo").focus();
                    });
                }
            }
        }
    });

    $("#ddlIDProof").change(function () {
        var txt = $("#ddlIDProof option:selected").text();

        if (txt == "AADHAAR") {
            $("#txtIDProofNo").attr("maxlength", "12");
            $("#txtIDProofNo").val("");
        }
        else {
            $("#txtIDProofNo").removeAttr("maxlength");
            $("#txtIDProofNo").val("");
        }
    });
    var onGetFamilyNumberModelOpen = function () {

        $('#spnSelectedPanel').text('Selected Panel : ' + $('#ddlPanelCompany option:selected').text());
        $('#divGetFamilyNumber').showModel();
    }
    var onGetFamilyNumberModelClose = function () {
        $('#divGetFamilyNumber').closeModel();
    }

    var searchFamilyNumber = function () {
        $('#divSearchModelFamilyNumberResults').html('');
        if (String.isNullOrEmpty($('#txtFFolderNumber').val()) && String.isNullOrEmpty($('#txtFFirstName').val()) && String.isNullOrEmpty($('#txtFLastName').val()) && String.isNullOrEmpty($('#txtFMobileNumber').val()) && String.isNullOrEmpty($('#txtFAddress').val()) && String.isNullOrEmpty($('#txtFFamilyNumber').val())) {

            modelAlert('Please Enter Atleast One Searching Criteria`s');
            return false;
        }
        var data = {
            PatientID: $('#txtFFolderNumber').val(),
            FName: $('#txtFFirstName').val(),
            LName: $('#txtFLastName').val(),
            ContactNo: $('#txtFMobileNumber').val(),
            // This adress filed is using for StaffID.
            Address: $('#txtFAddress').val(),
            FamilyNumber: $('#txtFFamilyNumber').val(),
            PanelID: $('#ddlPanelCompany').val().split('#')[0]
        }


        getFamilyNumberDetails(data, function (response) {
            bindFamilyNumberDetails(response);
        });
    }

    var getFamilyNumberDetails = function (data, callback) {
        serverCall('../Common/CommonService.asmx/FamilyNumberSearch', data, function (response) {
            callback(response);
        });
    }

    var _FPageSize = 9;
    var _FPageNo = 0;
    var bindFamilyNumberDetails = function (data) {
        if (!String.isNullOrEmpty(data)) {
            FamilyNumber = JSON.parse(data);

            if (FamilyNumber != null) {
                _FPageCount = FamilyNumber.length / _FPageSize;
                showFPage(0);
            }
            else {
                $('#divSearchModelFamilyNumberResults').html('');
            }
        }
        else
            $('#divSearchModelFamilyNumberResults').html('');
    }
    function showFPage(_strFPage) {
        _FStartIndex = (_strFPage * _FPageSize);
        _FEndIndex = eval(eval(_strFPage) + 1) * _FPageSize;
        var outputFamilyNumber = $('#tb_FamilyNumberDetails').parseTemplate(FamilyNumber);
        $('#divSearchModelFamilyNumberResults').html(outputFamilyNumber);
    }

    var onFPatientSelect = function (selectedFamilyNumber) {
        $('#txtFamilyNumber').val(selectedFamilyNumber);
        $('#txtFamilyNumber').attr('familynumber', selectedFamilyNumber);
        $('#divGetFamilyNumber').closeModel();
    }

    var bindFamilyNumber = function () {
        if (!String.isNullOrEmpty($('#txtPID').val().trim())) {
            var data = {
                PatientID: $('#txtPID').val().trim(),
                FName: '',
                LName: '',
                ContactNo: '',
                Address: '',
                FamilyNumber: '',
                PanelID: $('#ddlPanelCompany').val().split('#')[0]
            }
            getFamilyNumberDetails(data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    $('#txtFamilyNumber').val(responseData[0].LastFamilyUHIDNumber);
                    $('#txtFamilyNumber').attr('familynumber', responseData[0].LastFamilyUHIDNumber);
                }
                else {
                    $('#txtFamilyNumber').val('');
                    $('#txtFamilyNumber').attr('familynumber', '');
                }
            });
        }
        else {
            $('#txtFamilyNumber').val('');
            $('#txtFamilyNumber').attr('familynumber', '');
        }
    }
</script>


<script id="tb_FamilyNumberDetails" type="text/html">
	<table  id="tableFamilyNumberDetails" cellspacing="0" rules="all" border="1" style="width:876px;border-collapse :collapse;">
		<thead>  
			 <tr> 
					<th class="GridViewHeaderStyle" scope="col">Select</th>
					<th class="GridViewHeaderStyle" scope="col">Title</th> 
					<th class="GridViewHeaderStyle" scope="col">First Name</th> 
                    <th class="GridViewHeaderStyle" scope="col">M. Name</th> 
					<th class="GridViewHeaderStyle" scope="col">L.Name</th> 
					<th class="GridViewHeaderStyle" scope="col">UHID</th>
                    <th class="GridViewHeaderStyle" scope="col">Family Number</th>
					<th class="GridViewHeaderStyle" scope="col">Address</th> 
					<th class="GridViewHeaderStyle" scope="col">Contact&nbsp;No.</th>  
                 <th class="GridViewHeaderStyle" scope="col">Panel Name</th>  
			 </tr>
		</thead>
		<tbody>
		<#     
			 
			  var dataLength=FamilyNumber.length;
		if(_FEndIndex>dataLength)
			{           
			   _FEndIndex=dataLength;
			}
		for(var k=_FStartIndex;k<_FEndIndex;k++)
			{           
	   var objRow = FamilyNumber[k];
		#>              
						<tr onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=k+1#>" ondblclick="onFPatientSelect('<#=objRow.LastFamilyUHIDNumber#>');" style='cursor:pointer;'>                            
						<td class="GridViewLabItemStyle">
					   <a  class="btn" onclick="onFPatientSelect('<#=objRow.LastFamilyUHIDNumber#>');" style="cursor:pointer;padding:0px;font-weight:bold;width:60px " >
						  Select
					   </a>    </td>                                                    
						<td  class="GridViewLabItemStyle" id="tdFTtile"  ><#=objRow.Title#></td>
						<td class="GridViewLabItemStyle" id="tdFFirstName" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PFirstName#></td>
                        <td class="GridViewLabItemStyle" id="tdFMiddleName" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PMiddleName#></td>
						<td class="GridViewLabItemStyle" id="tdFLastName" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PLastName#></td>
						<td class="GridViewLabItemStyle" id="tdFMRNo" style="text-align:center" ><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle" id="tdFFamilyNumber"  ><#=objRow.LastFamilyUHIDNumber#></td>
						<td class="GridViewLabItemStyle" id="tdFAddress" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"  ><#=objRow.Address#></td>
						<td class="GridViewLabItemStyle" id="tdFContactNo" style="text-align:center" ><#=objRow.ContactNo#></td>    
                          <td class="GridViewLabItemStyle" id="tdFPanel" style="text-align:left; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.PanelName#></td>                  
						</tr>            
		<#}        
		#>
			</tbody>      
	 </table>  
	 <table id="tableFPatientCount" style="border-collapse:collapse;margin-top:6px">
	   <tr>
   <# if(_FPageCount>1) {
	 for(var k=0;k<_FPageCount;k++){ #>
	 <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showFPage('<#=k#>');" ><#=k+1#></a></td>
	 <#}         
   }
#>
	 </tr>     
	 </table>  
	</script>

 <script id="template_DocumentMaster" type="text/html">
		<table cellspacing="0" cellpadding="4" rules="all" border="1"    id="tblDocumentMaster" border="1" style="background-color:White;border-color:Transparent;border-width:1px;border-style:None;width:100%;border-collapse:collapse;">       
				<tr>
					<td style="border:solid 1px transparent"><input type="button"    value="Document Name"  id="Button1" title="" class="btn" style="font-size: 20px;color:white;background-color:#2C5A8B; width:100%;text-align:center; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;"></td>
					
				</tr>
				   
			<#
			 var dataLength=documentMaster.length;        
			 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = documentMaster[j];
				#>          
				<tr id="tr_<#=(j+1)#>">
					<td style="border:solid 1px transparent"><button type="button" value="<#=objRow.FormName#>"  id="btnDocumentName" title="<#=objRow.FormName#>" class="btnDocumentName" style="width:100%;text-align:center; max-width: 300px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" onclick="documentNameClick(this, this.parentNode.parentNode)">
					   <span style="float: right;font-size: 10px;"  class="badge badge-avilable"><#=objRow.ExitsCount#></span>  <#=objRow.FormName#>
						</button>
						</td>
					<td id="tdDocumentID" class="<#=objRow.FormID#>" style="display:none"><#=objRow.FormID#>

					</td>
					<td id="tdBase64Document" class="<#=objRow.FormID#>" style="display:none"></td>
				</tr>
			<#}#>            
		 </table>    
	</script>



 <div id="divNewTypeOfReference" class="modal fade " >
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white;width:400px;">
                <div class="modal-header">
                    <button type="button" class="close" onclick="onCreateNewtypeOfReferenceModelClose()" aria-hidden="true">×</button>
                    <h4 class="modal-title">Add Reference Type</h4>
                </div>
                <div class="modal-body">
                     <div class="row">
                         <div class="col-md-10">
                               <label class="pull-left">    Reference Type   </label>
                               <b class="pull-right">:</b>
                          </div>
                         <div class="col-md-14">
                             <input type="text" onlytext="20" id="txtNewTypeOfReference" >
                         </div>
                      </div>
                </div>
                  <div class="modal-footer">
                         <button type="button" class="save" onclick="createTypeOfReference();">Save</button>
                         <button type="button" class="save" onclick="onCreateNewtypeOfReferenceModelClose()">Close</button>
                </div>
            </div>
        </div>
    </div>


