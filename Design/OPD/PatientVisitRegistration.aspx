<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientVisitRegistration.aspx.cs" Inherits="Design_OPD_PatientVisitRegistration" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="wuc_OldPatientSearch" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script id="script1" type="text/javascript">
        $(document).ready(function () {
            $getHashCode(function () {
                $bindMandatory(function () {
                    $patientControlInit(function () {
                        $panelControlInit(function () {



                        });
                    });
                });
            });
        });


        var $bindMandatory = function (callback) {
            var manadatory = [
                { control: '#txtPFirstName', isRequired: true, erroMessage: 'Enter First Name', tabIndex: 1, isSearchAble: false },
                { control: '#txtPLastName', isRequired: false, erroMessage: 'Enter Second Name', tabIndex: 2, isSearchAble: false },
                { control: '#txtAge', isRequired: true, erroMessage: 'Select Date Of Birth', tabIndex: 3, isSearchAble: false },
                { control: '#txtMobile', isRequired: true, erroMessage: 'Enter Mobile Number', tabIndex: 4, isSearchAble: false },
                { control: '#txtRelationName', isRequired: true, erroMessage: 'Please Enter Relation Name', tabIndex: 5, isSearchAble: false },

            ];

            $(manadatory).each(function (index, item) {
                $(item.control).attr('tabindex', item.tabIndex).attr('errorMessage', item.erroMessage).addClass(item.isRequired ? 'requiredField' : '');
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


        var validateOpenVisit = function (patientID, callback) {
            var c = callback;
            serverCall('Services/PatientVisitRegistration.asmx/ValidateOpenVisit', { patientID: patientID }, function (isOpenVisitExits) {
                if (isOpenVisitExits)
                    modelConfirmation('Already Visit Open ?', 'Are you sure ?', 'Close Previous Visit.', 'Cancel', function (r) {
                        if (r)
                            closeOpenPatientVisit(patientID, function () { c(); });

                    });
                else
                    callback();
            });
        }


        var closeOpenPatientVisit = function (patientID, callback) {
            serverCall('Services/PatientVisitRegistration.asmx/ClosePatientOpenVisit', { patientID: patientID }, function (res) {
                var responseData = JSON.parse(res);
                if (responseData.status) {
                    callback();
                }
                else
                    modelAlert(responseData.response);
            });
        }


        var getPatientVisitDetails = function (callback) {
            $getPatientDetails(function (patientDetails) {
                var patientMaster = patientDetails.defaultPatientMaster;
                var patientMedicalHistory = patientDetails.defaultPatientMedicalHistory;

                patientMedicalHistory.HashCode = $.trim($('#spnHashCode').text());
                patientMedicalHistory.ScheduleChargeID = '0';
                patientMedicalHistory.Type = 'OPD';
                patientMedicalHistory.PatientPaybleAmt = 0;
                patientMedicalHistory.PanelPaybleAmt = 0;
                patientMedicalHistory.PatientPaidAmt = 0;
                patientMedicalHistory.PanelPaidAmt = 0;
                patientMedicalHistory.IsVisitClose = 0;

                callback({ patientMaster: [patientMaster], patientMedicalhistory: [patientMedicalHistory] });
            });
        }



        var save = function (btnSave) {
            getPatientVisitDetails(function (data) {
                validateOpenVisit(data.patientMaster[0].PatientID, function () {
                    $(btnSave).attr('disabled', true).val('Submitting...');
                    serverCall('Services/PatientVisitRegistration.asmx/CreateVisit', data, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) {
                                modelAlert('Visit ID: <span class="patientInfo"> ' + responseData.transactionID + '</span>', function () {
                                    window.location.reload();
                                });
                            }
                            else
                                $(btnSave).removeAttr('disabled').val('Save');
                        });
                    });
                });
            });
        }



        $(function () {
            shortcut.add('Alt+S', function () {
                var btnSave = $('#btnSave');
                if (btnSave.length > 0) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        save(btnSave[0]);
                    }
                }
            }, addShortCutOptions);
        });


    </script>







    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
            <b>Patient Visit Registration</b>
            <span style="display: none" id="lblScheduleChargeID"></span>
            <span style="display: none" id="spnHashCode"></span>
        </div>
        <uc1:wuc_OldPatientSearch ID="PatientInfo" runat="server" />

        <div class="POuter_Box_Inventory textCenter">
            <input type="button" class="save margin-top-on-btn" id="btnSave" onclick="save()" value="Save" />
        </div>


    </div>

</asp:Content>

