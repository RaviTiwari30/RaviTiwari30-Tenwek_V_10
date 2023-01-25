<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OT.aspx.cs" Inherits="Design_IPD_IPD_FinalDiagnosis" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            $('.check').on('change', function () {
                $('.check').not(this).prop('checked', false);
            });
            $('.check1').on('change', function () {
                $('.check1').not(this).prop('checked', false);
            });
            $('.check2').on('change', function () {
                $('.check2').not(this).prop('checked', false);
            });
            $('.check3').on('change', function () {
                $('.check3').not(this).prop('checked', false);
            });
            $('.check4').on('change', function () {
                $('.check4').not(this).prop('checked', false);
            });

            

            Fchecknpofrom();
            FcheckNEBULISATION();
            Fcheckstoporal();
            Fcheckpreothers();
            $('#divtabmedicinetable').attr("display", "none");

            $('#checkpaccarioothers').click(function () {
                if ($(this).is(':checked')) {
                    $('#divcheckpaccarioothers').show();
                }
                else {
                    $('#divcheckpaccarioothers').hide();
                    $('#txtcheckpaccarioothers').val('');
                }
            });
            $('#checkHEPATOothers').click(function () {
                if ($(this).is(':checked')) {
                    $('#divcheckHEPATOothers').show();
                }
                else {
                    $('#divcheckHEPATOothers').hide();
                    $('#txtcheckHEPATOothers').val('');
                }
            });
            $('#checkNEUROothers').click(function () {
                if ($(this).is(':checked')) {
                    $('#divcheckNEUROothers').show();
                }
                else {
                    $('#divcheckNEUROothers').hide();
                    $('#txtcheckNEUROothers').val('');
                }
            });

            $('#checkPRESENTothers').click(function () {
                if ($(this).is(':checked')) {
                    $('#divcheckPRESENTothers').show();
                }
                else {
                    $('#divcheckPRESENTothers').hide();
                    $('#txtcheckPRESENTothers').val('');
                }
            });



            $('#checktab').click(function () {
                if ($(this).is(':checked')) {
                    $("#txttabsearch").removeAttr("disabled");
                    $('#txttabmedvalue').removeAttr('disabled');
                    $('#txttabTime').removeAttr('disabled');
                    $('#txttabdate').removeAttr('disabled');
                    $('#btntabadd').removeAttr('disabled');
                }
                else {
                    $("#txttabsearch").val('').attr("disabled", "disabled");
                    $("#txttabmedvalue").val('').attr("disabled", "disabled");
                    $("#txttabTime").val('').attr("disabled", "disabled");
                    $("#txttabdate").val('').attr("disabled", "disabled");
                    $("#btntabadd").attr("disabled", "disabled");
                }
            });



            $('#checkRESPIRATORYsmoker').click(function () {
                if ($(this).is(':checked')) {
                    $('#txtRESPIRATORYsmoker').removeAttr('disabled')
                }
                else {
                    $('#txtRESPIRATORYsmoker').val('').attr("disabled", "disabled");
                }
            });

            $onInit();
            getpreopresult();
            getpacresult();
            getAnesthesiaresult();
        });

        var togglehideshow = function (el) {

            if (el == 1) {
                $('#divpreop').toggle();
            }
            if (el == 2) {
                $('#divpac').toggle();
            }
            if (el == 3) {
                $('#divplanofanesthesia').toggle();
            }
            if (el == 4) {
                $('#divSurgerySafety').toggle();
            }
        }

        var getdatils = function () {
            $("input[name='MS").each(function () {
                if ($(this).is(':checked')) { alert($(this).val()); }
            });

        }

        var $getAnesthesiaPlandetails = function (callback) {
            var Anaesthesiaplanallcheck = "";
            var ANAESPRESENT = "";
            $("input[name='ANAES").each(function () {
                if ($(this).is(':checked')) {
                    Anaesthesiaplanallcheck += $(this).val() + ','
                }
            });
            $("input[name='ANAESPRESENT").each(function () {
                if ($(this).is(':checked')) {
                    ANAESPRESENT = $(this).val();
                }
            });

            var getAnesthesiadetails = {
                Anaesthesiaplan: $("input[name='ANAESplan").is(':checked') == true ? '1' : '0',
                Anaesthesiaplanallchecked: Anaesthesiaplanallcheck.slice(0, -1),
                ANAESPRESENT: ANAESPRESENT,
                ANAESPATIENTAGREED: $("input[name='ANAESPATIENTAGREED").is(':checked') == true ? '1' : '0',
                TransactionID: $('#TransactionID').text().trim(),
                PatientID: $('#PatientId').text().trim(),
                OTBookingID: $('#OTBookingID').text().trim() == "" ? 0 : $('#OTBookingID').text().trim(),
                Appointment_ID: $('#App_ID').text().trim() == "" ? 0 : $('#App_ID').text().trim(),
            }
            callback({ PlanofAnesthesia: getAnesthesiadetails, AnID: _Ancid });
        }

        var $saveAnesthesia = function (btnsave) {
            debugger;
            $getAnesthesiaPlandetails(function (data) {
                $(btnsave).attr('disabled', true).val('Submitting...');
                serverCall('Services/OT.asmx/SaveAnesthesia', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                    });
                });
            });
        }



        function Fcheckstoporal() {
            if ($("#checkstoporal").is(':checked')) {
                $("#txtstoporalfrom").removeAttr("disabled");
                $('#txtstoporalTime').removeAttr('disabled');
                $('#txtstoporalon').removeAttr('disabled');
            }
            else {
                $("#txtstoporalfrom").val('').attr("disabled", "disabled");
                $("#txtstoporalTime").val('').attr("disabled", "disabled");
                $("#txtstoporalon").val('').attr("disabled", "disabled");
            }
        }


        function FcheckNEBULISATION() {
            if ($("#checkNEBULISATION").is(':checked')) {
                $("#txtNEBULISATION").removeAttr("disabled");
                $('#txtNEBULISATIONdate').removeAttr('disabled');
                $('#txtNEBULISATIONTime').removeAttr('disabled');
            }
            else {
                $("#txtNEBULISATION").val('').attr("disabled", "disabled");
                $("#txtNEBULISATIONdate").val('').attr("disabled", "disabled");
                $("#txtNEBULISATIONTime").val('').attr("disabled", "disabled");
            }
        }

        //
        function Fchecknpofrom() {
            if ($("#checknpofrom").is(':checked')) {
                $("#txtnpoTime").removeAttr("disabled");
                $('#txtnopdate').removeAttr('disabled');
            }
            else {
                $("#txtnpoTime").val('').attr("disabled", "disabled");
                $("#txtnopdate").val('').attr("disabled", "disabled");
            }
        }

        function Fcheckpreothers() {
            if ($("#checkpreothers").is(':checked')) {
                $('#divpreothertxtbox').show();
            }
            else {
                $('#divpreothertxtbox').hide();
                $('#divpreothertxtboxvalue').val('');
            }
        }



        var $getpacdetails = function (callback) {
            debugger;
            var ANTIICIPATEDAIRWAY = "";
            var RESPIRATORY = "";
            var CARDIOVASCULAR = "";
            var RENAL_ENDOCRINE = "";
            var HEPATO_GASTROINTESTINAL = "";
            var NEURO_MUSCULOSKELETAL = "";
            var OTHERS = "";
            var PRESENT_MEDICATIONS = "";
            $("input[name='AAP").each(function () {
                if ($(this).is(':checked')) {
                    ANTIICIPATEDAIRWAY += $(this).val() + ','
                }
            });
            $("input[name='RES").each(function () {
                if ($(this).is(':checked')) {

                    if ($(this).val() == 'SMOKER') {
                        RESPIRATORY += $(this).val() + '#' + $('#txtRESPIRATORYsmoker').val().trim() + ','
                    }
                    else {
                        RESPIRATORY += $(this).val() + ','
                    }
                }
            });
            $("input[name='CAR").each(function () {
                if ($(this).is(':checked')) {

                    if ($(this).val() == 'OTHERS') {
                        CARDIOVASCULAR += $(this).val() + '#' + $('#txtcheckpaccarioothers').val().trim() + ','
                    }
                    else {
                        CARDIOVASCULAR += $(this).val() + ','
                    }
                }
            });
            $("input[name='REEN").each(function () {
                if ($(this).is(':checked')) {
                    RENAL_ENDOCRINE += $(this).val() + ','
                }
            });
            $("input[name='HEGA").each(function () {
                if ($(this).is(':checked')) {

                    if ($(this).val() == 'OTHERS') {
                        HEPATO_GASTROINTESTINAL += $(this).val() + '#' + $('#txtcheckHEPATOothers').val().trim() + ','
                    }
                    else {
                        HEPATO_GASTROINTESTINAL += $(this).val() + ','
                    }
                }
            });
            $("input[name='NEMU").each(function () {
                if ($(this).is(':checked')) {

                    if ($(this).val() == 'OTHERS') {
                        NEURO_MUSCULOSKELETAL += $(this).val() + '#' + $('#txtcheckNEUROothers').val().trim() + ','
                    }
                    else {
                        NEURO_MUSCULOSKELETAL += $(this).val() + ','
                    }
                }
            });
            $("input[name='OTHERS").each(function () {
                if ($(this).is(':checked')) {
                    OTHERS += $(this).val() + ','
                }
            });
            $("input[name='PRME").each(function () {
                if ($(this).is(':checked')) {

                    if ($(this).val() == 'OTHERS') {
                        PRESENT_MEDICATIONS += $(this).val() + '#' + $('#txtcheckPRESENTothers').val().trim() + ','
                    }
                    else {
                        PRESENT_MEDICATIONS += $(this).val() + ','
                    }
                }
            });

            var getpac = {
                SURGICAL_ANESTHETIC: $('#txtpacSURGICAL_ANESTHETIC').val().trim(),
                ANTIICIPATED_AIRWAY: ANTIICIPATEDAIRWAY.slice(0, -1),
                RESPIRATORY: RESPIRATORY.slice(0, -1),
                CARDIOVASCULAR: CARDIOVASCULAR.slice(0, -1),
                RENAL_ENDOCRINE: RENAL_ENDOCRINE.slice(0, -1),
                HEPATO_GASTROINTESTINAL: HEPATO_GASTROINTESTINAL.slice(0, -1),
                NEURO_MUSCULOSKELETAL: NEURO_MUSCULOSKELETAL.slice(0, -1),
                OTHERS: OTHERS.slice(0, -1),
                PRESENT_MEDICATIONS: PRESENT_MEDICATIONS.slice(0, -1),
                TransactionID: $('#TransactionID').text().trim(),
                PatientID: $('#PatientId').text().trim(),
                OTBookingID: $('#OTBookingID').text().trim() == "" ? 0 : $('#OTBookingID').text().trim(),
                Appointment_ID: $('#App_ID').text().trim() == "" ? 0 : $('#App_ID').text().trim(),

            }

            callback({ Pac: getpac, pacID: _pacid });
        }


        var $savePAC = function (btnsave) {
            debugger;
            $getpacdetails(function (data) {
                $(btnsave).attr('disabled', true).val('Submitting...');
                serverCall('Services/OT.asmx/SavePAC', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                    });
                });
            });
        }

        //mayank
        var $UpdatePAC = function (btnUpdate) {
            debugger;
            $getpacdetails(function (data) {
                $(btnUpdate).attr('disabled', true).val('Updating...');
                serverCall('Services/OT.asmx/UpdatePAC', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                    });
                });
            });
        }

        var $UpdateANE = function (btnUpdate) {
            debugger;
            $getAnesthesiaPlandetails(function (data) {
                $(btnUpdate).attr('disabled', true).val('Updating...');
                serverCall('Services/OT.asmx/UPdateANE', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                    });
                });
            });
        }


        $onInit = function () {
            $('#txttabsearch').autocomplete({
                source: function (request, response) {
                    $bindItems({ PreFix: request.term }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    $('#selectedInvestigations').text(JSON.stringify(i));
                    var SelectedInv = JSON.parse($('#selectedInvestigations').text());
                },
                close: function (el) {

                },
                minLength: 2
            });
        };
        $bindItems = function (data, callback) {
            serverCall('Services/OT.asmx/LoadAllItem', data, function (response) {
                if (response == "No Item Found") {
                    alert(response);
                    $('#txttabsearch').val('');
                    return false;
                }
                else {
                    var responseData = $.map(JSON.parse(response), function (item) {
                        return {
                            label: item.ItemName,
                            val: item.ItemID,
                            Typename: item.Typename,
                            Index: item.selectindex
                        }
                    });
                }
                callback(responseData);
            });
        };


        var GETPREOPInstructionsdetails = function (callback) {
            var MALAMPATTI_SCORE = "";
            var MOUTH_OPENING_ADEQATE = "";
            var TEETH = "";
            var DENTURES = "";
            var T_M_DISTANCE = "";
            var NCEK_MOVEMENTS = "";
            var ASA_CLASS = "";
            var IS_NPO_FROM = "";

            $("input[name='MS").each(function () {
                if ($(this).is(':checked')) {
                    MALAMPATTI_SCORE = $(this).val();
                }
            });

            $("input[name='MOA").each(function () {
                if ($(this).is(':checked')) {
                    MOUTH_OPENING_ADEQATE = $(this).val();
                }
            });
            $("input[name='TEETH").each(function () {
                if ($(this).is(':checked')) {
                    TEETH += $(this).val() + ','
                }
            });

            $("input[name='DEN").each(function () {
                if ($(this).is(':checked')) {
                    DENTURES += $(this).val() + ','
                }
            });
            $("input[name='TMD").each(function () {
                if ($(this).is(':checked')) {
                    T_M_DISTANCE += $(this).val() + ','
                }
            });

            $("input[name='NM").each(function () {
                if ($(this).is(':checked')) {
                    NCEK_MOVEMENTS += $(this).val() + ','
                }
            });

            $("input[name='ASA").each(function () {
                if ($(this).is(':checked')) {
                    ASA_CLASS += $(this).val() + ','
                }
            });




            var PREOPInstructionsdetails = {
                MALAMPATTI_SCORE: MALAMPATTI_SCORE,
                MOUTH_OPENING_ADEQATE: MOUTH_OPENING_ADEQATE,
                TEETH: TEETH.slice(0, -1),
                DENTURES: DENTURES.slice(0, -1),
                T_M_DISTANCE: T_M_DISTANCE.slice(0, -1),
                NCEK_MOVEMENTS: NCEK_MOVEMENTS.slice(0, -1),
                ASA_CLASS: ASA_CLASS.slice(0, -1),
                IS_NPO_FROM: $("input[name='NPOFROM").is(':checked') == true ? '1' : '0',
                NPO_time: $("input[name='NPOFROM").is(':checked') == true ? $('#txtnpoTime').val().trim() : '',
                NPO_date: $("input[name='NPOFROM").is(':checked') == true ? $('#txtnopdate').val().trim() : '',
                IS_APPLY_EMLA: $("input[name='APPLY_EMLA").is(':checked') == true ? '1' : '0',
                IS_REMOVE_ALL: $("input[name='REMOVE_ALL").is(':checked') == true ? '1' : '0',
                IS_SHIFT_OT: $("input[name='SHIFT_OT").is(':checked') == true ? '1' : '0',
                IS_NEBULISATION: $("input[name='NEBULISATION").is(':checked') == true ? '1' : '0',
                NEBULISATION: $("input[name='NEBULISATION").is(':checked') == true ? $('#txtNEBULISATION').val().trim() : '',
                NEBULISATION_time: $("input[name='NEBULISATION").is(':checked') == true ? $('#txtNEBULISATIONTime').val().trim() : '',
                NEBULISATION_date: $("input[name='NEBULISATION").is(':checked') == true ? $('#txtNEBULISATIONdate').val().trim() : '',
                IS_patient_can: $("input[name='patient_can").is(':checked') == true ? '1' : '0',
                IS_STOP_ORAL: $("input[name='STOP_ORAL").is(':checked') == true ? '1' : '0',
                STOP_ORAL_from_date: $("input[name='STOP_ORAL").is(':checked') == true ? $('#txtstoporalfrom').val().trim() : '',
                STOP_ORAL_time: $("input[name='STOP_ORAL").is(':checked') == true ? $('#txtstoporalTime').val().trim() : '',
                STOP_ORAL_from_on: $("input[name='STOP_ORAL").is(':checked') == true ? $('#txtstoporalon').val().trim() : '',
                Other: $("input[name='preother").is(':checked') == true ? $('#divpreothertxtboxvalue').val().trim() : '',
                TransactionID: $('#TransactionID').text().trim(),
                PatientID: $('#PatientId').text().trim(),
                OTBookingID: $('#OTBookingID').text().trim() == "" ? 0 : $('#OTBookingID').text().trim(),
                Appointment_ID: $('#App_ID').text().trim() == "" ? 0 : $('#App_ID').text().trim(),
                ALLERGIES: $('#txtALLERGIES').val().trim()
            }

            labItems = [];
            $gettabItemsDetails(function (labPrescriptionDetails) {

                $(labPrescriptionDetails.labItemsDetails).each(function () {
                    labItems.push({
                        itemID: this.itemID,
                        tabname: this.tabname,
                        tabdose: this.tabdose,
                        time: this.time,
                        date: this.date
                    });
                });
            });


            callback({ PREOPInstructionsdetails: PREOPInstructionsdetails, labItems: labItems, preid: _preid });
        }

        var $Savepreopinstruction = function (btnsave) {
            GETPREOPInstructionsdetails(function (data) {

                $(btnsave).attr('disabled', true).val('Submitting...');
                serverCall('Services/OT.asmx/Savepreopinstruction', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                    });
                });
            });
        }

        //Update

        var $Updatepreopinstruction = function (btnUpdate) {
            GETPREOPInstructionsdetails(function (data) {

                $(btnUpdate).attr('disabled', true).val('Updating...');
                serverCall('Services/OT.asmx/Updatepreopinstruction', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            window.location.reload();
                        }

                    });
                });
            });
        }

        var addtabmedicine = function () {
            debugger;
            var tabname = $('#txttabsearch').val().trim();
            var tabdose = $('#txttabmedvalue').val().trim();
            var time = $('#txttabTime').val().trim();
            var date = $('#txttabdate').val().trim();
            var selectedInvestigation = JSON.parse($('#selectedInvestigations').text().trim());
            var ItemID = selectedInvestigation.item.val;
            var row = "";
            var dublicate = 0;
            var count = 0;
            $('#tabmedicinetable tbody tr').not(":first").each(function () {
                var itemid = $(this).closest('tr').find('#tdItemID').text().trim();
                if (itemid == ItemID) {
                    dublicate = 1;
                }
            });
            if (dublicate == 0 && tabname != "") {
                row = '<tr>';
                row += '<td class="GridViewLabItemStyle" id="tdsno" ></td>';
                row += '<td class="GridViewLabItemStyle" id="tdItemID" style="display:none" >' + ItemID + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdtabname" >' + tabname + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdtabdose" >' + tabdose + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdtime" >' + time + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tddate" >' + date + '</td>';
                row += '<td class="GridViewLabItemStyle" id="td1" ><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removerow(this)"></td>';
                row += '</tr>';
                $('#tabmedicinetable').append(row);
                $('#tabmedicinetable').show();
                $('#divtabmedicinetable').show();
                $('#txttabsearch').val('');
                $('#txttabmedvalue').val('');
                $('#txttabTime').val('');
                $('#txttabdate').val('');
                $("#divtabmedicinetable").removeAttr("style");
                $('#tabmedicinetable tbody tr').not(":first").each(function () {
                    count = count + 1;
                    $(this).closest('tr').find('#tdsno').text(count);

                });
                count = 0;
            }
        }

        var removerow = function (el) {
            var count = 0;
            $(el).closest('tr').remove();
            $('#tabmedicinetable tbody tr').not(":first").each(function () {
                count = count + 1;
                $(this).closest('tr').find('#tdsno').text(count);

            });
            if (count == 0) {
                $('#tabmedicinetable').hide();
            }
        }

        getpremedicinedetails = function (callback) {
            labItems = [];
            $gettabItemsDetails(function (labPrescriptionDetails) {

                $(labPrescriptionDetails.labItemsDetails).each(function () {
                    labItems.push({
                        itemID: this.itemID,
                        tabname: this.tabname,
                        tabdose: this.tabdose,
                        time: this.time,
                        date: this.date
                    });
                });
            });
            callback(labItems);
        }


        $gettabItemsDetails = function (callback) {
            var response = {};
            response.labItemsDetails = [];
            $tbSelectedTrs = $('#tabmedicinetable tbody tr').clone();
            var labitems = $($tbSelectedTrs);
            $(labitems).not(":first").each(function (index, row) {
                response.labItemsDetails.push({
                    itemID: $(row).find('#tdItemID').text().trim(),
                    tabname: $(row).find('#tdtabname').text().trim(),
                    tabdose: $(row).find('#tdtabdose').text().trim(),
                    time: $(row).find('#tdtime').text().trim(),
                    date: $(row).find('#tddate').text().trim(),
                });
            });
            console.log(response);
            callback(response);

        }
        var getpacresult = function () {
            var row = "";
            var TransactionID = $('#TransactionID').text().trim();
            var PatientID = $('#PatientId').text().trim();
            serverCall('Services/OT.asmx/getpacresultdetails', { TransactionID: TransactionID, PatientId: PatientID }, function (response) {
                var responseData = JSON.parse(response);
                for (var i = 0; i < responseData.length; i++) {
                    row += '<tr>';
                    row += '<td class="GridViewLabItemStyle" id="tdsno" > ' + (i + 1) + '</td>';
                    row += '<td class="GridViewLabItemStyle" id="tdpacid" style="display:none" >' + responseData[i].pacid + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].patientname + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_date + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_by + '</td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/edit.png" onclick="editpacresult(this)"><center></td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/print.gif" onclick="printprepac(this)"></center></td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removepac(this)"><center></td>';
                    row += '</tr>';
                }
                $('#tblpacresult').append(row);
                if (responseData.length > 0) {
                    $('#tblpacresult').show();
                }
            });
        }

        var getAnesthesiaresult = function () {
            var row = "";
            var TransactionID = $('#TransactionID').text().trim();
            var PatientID = $('#PatientId').text().trim();
            serverCall('Services/OT.asmx/getAnesthesiadetails', { TransactionID: TransactionID, PatientId: PatientID }, function (response) {
                var responseData = JSON.parse(response);
                for (var i = 0; i < responseData.length; i++) {
                    row += '<tr>';
                    row += '<td class="GridViewLabItemStyle" id="tdsno" > ' + (i + 1) + '</td>';
                    row += '<td class="GridViewLabItemStyle" id="tdAnid" style="display:none" >' + responseData[i].ANEID + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].patientname + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_date + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_by + '</td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/edit.png" onclick="editAnresult(this)"></center></td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/print.gif" onclick="printPlanofAnesthesia(this)"></center></td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removeAn(this)"></center></td>';
                    row += '</tr>';
                }
                $('#tblAnesthesia').append(row);
                if (responseData.length > 0) {
                    $('#tblAnesthesia').show();
                }
            });
        }


        var _pacid = "";
        var editpacresult = function (el) {
            _pacid = $(el).closest('tr').find('#tdpacid').text().trim();
            serverCall('Services/OT.asmx/editpacresultdetails', { PACID: _pacid }, function (response) {

                var responseData = JSON.parse(response);
                $("#txtRESPIRATORYsmoker").val('').attr('disabled', 'disabled');
                $("#txtcheckpaccarioothers").val('');
                $("#divcheckpaccarioothers").attr("style", "display:none");

                $("#txtcheckpaccarioothers").val('');
                $("#divcheckpaccarioothers").attr("style", "display:none")

                $("#txtcheckHEPATOothers").val('');
                $("#divcheckHEPATOothers").attr("style", "display:none")

                $("#txtcheckNEUROothers").val('');
                $("#divcheckNEUROothers").attr("style", "display:none")

                $("#txtcheckPRESENTothers").val('');
                $("#divcheckPRESENTothers").attr("style", "display:none")

                $("#txtpacSURGICAL_ANESTHETIC").val(responseData[0]["SURGICAL_ANESTHETIC"]);
                $("input[name='AAP").removeAttr("checked");
                $("input[name='AAP").each(function () {
                    if (responseData[0]["ANTIICIPATED_AIRWAY"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });

                var count = 0;
                $("input[name='RES").removeAttr("checked");
                $("input[name='RES").each(function () {
                    if (responseData[0]["RESPIRATORY"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                        if ($(this).val() == "SMOKER") {
                            count++;
                        }


                    }
                });
                if (count > 0) {
                    $("#txtRESPIRATORYsmoker").val(responseData[0]["RESPIRATORY"].split('#')[1].split(',')[0]).removeAttr('disabled');
                    count = 0;
                }
                $("input[name='CAR").removeAttr("checked");
                $("input[name='CAR").each(function () {
                    if (responseData[0]["CARDIOVASCULAR"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                        if ($(this).val() == "OTHERS") {
                            count++;
                        }

                    }
                });
                if (count > 0) {
                    $("#txtcheckpaccarioothers").val(responseData[0]["CARDIOVASCULAR"].split('#')[1]);
                    $("#divcheckpaccarioothers").removeAttr("style");
                    count = 0;
                }


                $("input[name='REEN").removeAttr("checked");
                $("input[name='REEN").each(function () {
                    if (responseData[0]["RENAL_ENDOCRINE"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });

                $("input[name='HEGA").removeAttr("checked");
                $("input[name='HEGA").each(function () {
                    if (responseData[0]["HEPATO_GASTROINTESTINAL"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                        if ($(this).val() == "OTHERS") {
                            count++;
                        }


                    }
                });
                if (count > 0) {

                    $("#txtcheckHEPATOothers").val(responseData[0]["HEPATO_GASTROINTESTINAL"].split('#')[1]);
                    $("#divcheckHEPATOothers").removeAttr("style");
                    count = 0;
                }

                $("input[name='NEMU").removeAttr("checked");
                $("input[name='NEMU").each(function () {
                    if (responseData[0]["NEURO_MUSCULOSKELETAL"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                        if ($(this).val() == "OTHERS") {
                            count++;
                        }

                    }
                });
                if (count > 0) {
                    $("#txtcheckNEUROothers").val(responseData[0]["NEURO_MUSCULOSKELETAL"].split('#')[1]);
                    count = 0;
                    $("#divcheckNEUROothers").removeAttr("style");
                }

                $("input[name='OTHERS").removeAttr("checked");
                $("input[name='OTHERS").each(function () {
                    if (responseData[0]["OTHERS"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });

                $("input[name='PRME").removeAttr("checked");
                $("input[name='PRME").each(function () {
                    if (responseData[0]["PRESENT_MEDICATIONS"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                        if ($(this).val() == "OTHERS") {
                            count++;
                        }

                    }
                });
                if (count > 0) {

                    $("#txtcheckPRESENTothers").val(responseData[0]["PRESENT_MEDICATIONS"].split('#')[1]);
                    $("#divcheckPRESENTothers").removeAttr("style");
                    count = 0;
                }
                $("#btnsavepac").attr("style", "display:none");
                $("#btnUpdatepac").removeAttr("style");
            });
        }

        var removepac = function (el) {
            var count = 0;
            $(el).closest('tr').remove();
            $('#tblpacresult tbody tr').each(function () {
                count = count + 1;
                $(this).closest('tr').find('#tdsno').text(count);
            });
            if (count == 0) {
                $('#tblpacresult').hide();
            }
            var pacid = $(el).closest('tr').find('#tdpacid').text();
            serverCall('Services/OT.asmx/removepac', { PACID: pacid }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        window.location.reload();
                    }

                });
            });
        }


        var _Ancid = "";
        var editAnresult = function (el) {
            _Ancid = $(el).closest('tr').find('#tdAnid').text().trim();
            serverCall('Services/OT.asmx/editAnesultdetails', { AnID: _Ancid }, function (response) {

                var responseData = JSON.parse(response);
                $("input[name='ANAESplan']").removeAttr("checked");
                if (responseData[0]["Anaesthesiaplan"] == "1") {
                    $("input[name='ANAESplan']").attr("checked", "checked");
                }
                $("input[name='ANAES']").removeAttr("checked");
                $("input[name='ANAES']").each(function () {
                    if (responseData[0]["Anaesthesiaplanallchecked"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });

                $("input[name='ANAESPRESENT']").removeAttr("checked");
                $("input[name='ANAESPRESENT']").each(function () {
                    if ($(this).val() == responseData[0]["ANAESPRESENT"]) {
                        $(this).attr("checked", "checked");
                    }
                });


                $("input[name='ANAESPATIENTAGREED']").removeAttr("checked");
                if (responseData[0]["ANAESPATIENTAGREED"] == "1") {
                    $("input[name='ANAESPATIENTAGREED']").attr("checked", "checked");
                }

            });
            $('#btnupdateane').show();
            $('#btnsaveAnesthesia').hide();

        }

        var removeAn = function (el) {
            var count = 0;
            $(el).closest('tr').remove();
            $('#tblAnesthesia tbody tr').each(function () {
                count = count + 1;
                $(this).closest('tr').find('#tdsno').text(count);
            });
            if (count == 0) {
                $('#tblAnesthesia').hide();
            }
            var aneid = $(el).closest('tr').find('#tdAnid').text();
            serverCall('Services/OT.asmx/removeane', { ANEID: aneid }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        window.location.reload();
                    }

                });
            });
        }




        var getpreopresult = function () {
            var row = "";
            var TransactionID = $('#TransactionID').text().trim();
            var PatientID = $('#PatientId').text();
            serverCall('Services/OT.asmx/getpreopresultdetails', { TransactionID: TransactionID, PatientId: PatientID }, function (response) {
                var responseData = JSON.parse(response);
                for (var i = 0; i < responseData.length; i++) {
                    row += '<tr>';
                    row += '<td class="GridViewLabItemStyle" id="tdsno" > ' + (i + 1) + '</td>';
                    row += '<td class="GridViewLabItemStyle" id="tdpreid" style="display:none" >' + responseData[i].preid + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].patientname + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_date + '</td>';
                    row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_by + '</td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/edit.png" onclick="editpreopresult(this)"></center></td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/print.gif" onclick="printpreopINSTRUCTIONS(this)"></center></td>';
                    row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removerow1(this)"></center></td>';
                    row += '</tr>';
                }
                $('#tblpreopresult').append(row);
                if (responseData.length > 0) {
                    $('#tblpreopresult').show();
                }
            });
        }


        var removerow1 = function (el) {
            var count = 0;
            $(el).closest('tr').remove();
            $('#tblpreopresult tbody tr').not(":first").each(function () {
                count = count + 1;
                $(this).closest('tr').find('#tdsno').text(count);
            });
            if (count == 0) {
                $('#tblpreopresult').hide();
            }
            preid = $(el).closest('tr').find('#tdpreid').text().trim();
            serverCall('Services/OT.asmx/removegetpreop', { PREID: preid }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        window.location.reload();
                    }

                });
            });
        }


        var _preid = "";
        var editpreopresult = function (el) {
            _preid = $(el).closest('tr').find('#tdpreid').text().trim();
            serverCall('Services/OT.asmx/editpreopresultdetails', { PREID: _preid }, function (response) {
                var responseData = JSON.parse(response);

                $("input[name='MS").removeAttr("checked");
                $("input[name='MS").each(function () {
                    if ($(this).val() == responseData[0]["MALAMPATTI_SCORE"]) {
                        $(this).attr("checked", "checked");
                    }
                });
                $("input[name='MOA").removeAttr("checked");
                $("input[name='MOA").each(function () {
                    if ($(this).val() == responseData[0]["MOUTH_OPENING_ADEQATE"]) {
                        $(this).attr("checked", "checked");
                    }
                });

                $("input[name='TEETH").removeAttr("checked");
                $("input[name='TEETH").each(function () {
                    if (responseData[0]["TEETH"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });

                $("input[name='DEN").removeAttr("checked");
                $("input[name='DEN").each(function () {
                    if (responseData[0]["DENTURES"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });
                $("input[name='TMD").removeAttr("checked");
                $("input[name='TMD").each(function () {
                    if (responseData[0]["T_M_DISTANCE"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });
                $("input[name='NM").removeAttr("checked");
                $("input[name='NM").each(function () {
                    if (responseData[0]["NCEK_MOVEMENTS"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });
                $("input[name='ASA").removeAttr("checked");
                $("input[name='ASA").each(function () {
                    if (responseData[0]["ASA_CLASS"].includes($(this).val())) {
                        $(this).attr("checked", "checked");
                    }
                });


                $("#checknpofrom").removeAttr("checked");
                $("#txtnpoTime").val("");
                $("#txtnopdate").val("");
                Fchecknpofrom();
                if (responseData[0].IS_NPO_FROM == "1") {
                    $("#checknpofrom").attr("checked", "checked");
                    Fchecknpofrom();
                    $("#txtnpoTime").val(responseData[0].NPO_time);
                    $("#txtnopdate").val(responseData[0].NPO_date);
                }
                //IS_APPLY_EMLA  IS_REMOVE_ALL  IS_SHIFT_OT

                $("input[name='APPLY_EMLA").removeAttr("checked");
                $("input[name='REMOVE_ALL").removeAttr("checked");
                $("input[name='SHIFT_OT").removeAttr("checked");
                if (responseData[0].IS_APPLY_EMLA == "1") {
                    $("input[name='APPLY_EMLA").attr("checked", "checked");
                }
                if (responseData[0].IS_REMOVE_ALL == "1") {
                    $("input[name='REMOVE_ALL").attr("checked", "checked");
                }
                if (responseData[0].IS_SHIFT_OT == "1") {
                    $("input[name='SHIFT_OT").attr("checked", "checked");
                }

                $("#checkNEBULISATION").removeAttr("checked");
                $("#txtNEBULISATION").removeAttr("checked");
                $("#txtNEBULISATIONdate").removeAttr("checked");
                $("#txtNEBULISATIONTime").removeAttr("checked");
                FcheckNEBULISATION();
                if (responseData[0].IS_NEBULISATION == "1") {
                    $("#checkNEBULISATION").attr("checked", "checked");
                    FcheckNEBULISATION();
                    $("#txtNEBULISATION").val(responseData[0].NEBULISATION);
                    $("#txtNEBULISATIONdate").val(responseData[0].NEBULISATION_date);
                    $('#txtNEBULISATIONTime').val(responseData[0].NEBULISATION_time);
                }
                $("input[name='patient_can").removeAttr("checked");
                if (responseData[0].IS_patient_can == "1") {
                    $("input[name='patient_can").attr("checked", "checked");
                }
                $("#txtstoporalfrom").removeAttr("checked");
                $("#txtstoporalTime").removeAttr("checked");
                $('#txtstoporalon').removeAttr("checked");
                $('#checkstoporal').removeAttr("checked");
                Fcheckstoporal();
                if (responseData[0].IS_STOP_ORAL == "1") {
                    $("#checkstoporal").attr("checked", "checked");
                    Fcheckstoporal();
                    $("#txtstoporalfrom").val(responseData[0].STOP_ORAL_from_date);
                    $("#txtstoporalTime").val(responseData[0].STOP_ORAL_time);
                    $('#txtstoporalon').val(responseData[0].STOP_ORAL_from_on);
                }
                $("#checkpreothers").removeAttr("checked");
                Fcheckpreothers();
                if (responseData[0].Other != "") {
                    $("#checkpreothers").attr("checked", "checked");
                    Fcheckpreothers();
                    $('#divpreothertxtboxvalue').val(responseData[0].Other);
                }
                $('#txtALLERGIES').val(responseData[0].ALLERGIES)
                $("#divtabmedicinetable").attr("style", "display:none");
                $("#tabmedicinetable").find("tr:gt(0)").remove();
                var row = '';
                for (var i = 0; i < responseData.length; i++) {
                    if (responseData[i]["medicine_id"] != "") {
                        row += '<tr>';
                        row += '<td class="GridViewLabItemStyle" id="tdsno" >' + (i + 1) + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdItemID" style="display:none" >' + responseData[i]["medicine_id"] + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdtabname" >' + responseData[i]["medicine_name"] + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdtabdose" >' + responseData[i]["medicine_dose"] + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tdtime" >' + responseData[i]["medicine_time"] + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="tddate" >' + responseData[i]["medicine_date"] + '</td>';
                        row += '<td class="GridViewLabItemStyle" id="td1" ><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removerow(this)"></td>';
                        row += '</tr>';
                        $("#divtabmedicinetable").removeAttr("style");
                    }
                }
                $('#tabmedicinetable').append(row);
                $('#tabmedicinetable').show();

                $("#btnpreupdate").removeAttr("Style");
                $("#btnpresave").attr("style", "display:none");
            });
        }


        var printpreopINSTRUCTIONS = function (el) {
            preid = $(el).closest('tr').find('#tdpreid').text().trim();
            var TransactionID = $('#TransactionID').text().trim();
            serverCall('OT.aspx/printpreop', { PREID: preid, TransactionID: TransactionID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response);
            });
        }

        var printprepac = function (el) {
            pacid = $(el).closest('tr').find('#tdpacid').text().trim();

            serverCall('OT.aspx/printPAC', { PACID: pacid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response);
            });
        }
        var printPlanofAnesthesia = function (el) {
            aneid = $(el).closest('tr').find('#tdAnid').text().trim();
            serverCall('OT.aspx/printplananesthesia', { ANEID: aneid }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response);
            });
        }

    </script>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">

        <div id="Pbody_box_inventory" style="text-align: center">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server">
            </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                <asp:Label ID="TransactionID" runat="server" Style="display: none" />
             <asp:Label ID="OTBookingID" runat="server" Style="display: none" />
             <asp:Label ID="App_ID" runat="server" Style="display: none" />
                <asp:Label ID="PatientId" runat="server" Style="display: none" />
                <div class="Purchaseheader" onclick="togglehideshow(1)">
                    <b>PRE OP INSTRUCTIONS</b>
                </div>
                <div id="divpreop"  style="display:none">
                    <div class="POuter_Box_Inventory">
                        <div class="row">
                            <div class="col-md-24">
                                <div class="row">
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            MALAMPATTI SCORE
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6 pull-left">
                                        <input type="checkbox" name="MS" class="check pull-left MSC" value="I" /><label class="pull-left">I</label>
                                        <input type="checkbox" name="MS" class="check pull-left MSC" value="II" /><label class="pull-left">II</label>
                                        <input type="checkbox" name="MS" class="check pull-left MSC" value="III" /><label class="pull-left">III</label>
                                        <input type="checkbox" name="MS" class="check pull-left MSC" value="IV" /><label class="pull-left">IV</label>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            MOUTH OPENING ADEQATE
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <input type="checkbox" name="MOA" class="check1 pull-left" value="YES" /><label class="pull-left">YES</label>
                                        <input type="checkbox" name="MOA" class="check1 pull-left" value="NO" /><label class="pull-left">NO</label>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            TEETH
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <input type="checkbox" name="TEETH" class="pull-left" value="N" /><label class="pull-left">N</label>
                                        <input type="checkbox" name="TEETH" class="pull-left" value="LOOSE" /><label class="pull-left">LOOSE</label>
                                        <input type="checkbox" name="TEETH" class="pull-left" value="MISSING" /><label class="pull-left">MISSING</label>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            DENTURES
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <input type="checkbox" name="DEN" class="pull-left" value="FIXED" /><label class="pull-left">FIXED</label>
                                        <input type="checkbox" name="DEN" class="pull-left" value="REMOVABLE" /><label class="pull-left">REMOVABLE</label>

                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            T.M DISTANCE
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <input type="checkbox" name="TMD" class="pull-left" value="ADEQUATE" /><label class="pull-left">ADEQUATE</label>
                                        <input type="checkbox" name="TMD" class="pull-left" value="INADDEQUATE" /><label class="pull-left">INADDEQUATE</label>

                                    </div>
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            NCEK MOVEMENTS
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <input type="checkbox" name="NM" class="pull-left" value="ADEQUATE" /><label class="pull-left">ADEQUATE</label>
                                        <input type="checkbox" name="NM" class="pull-left" value="INADDEQUATE" /><label class="pull-left">INADDEQUATE</label>

                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            ASA CLASS
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-6">
                                        <input type="checkbox" name="ASA" class="pull-left" value="1" /><label class="pull-left">1</label>
                                        <input type="checkbox" name="ASA" class="pull-left" value="2" /><label class="pull-left">2</label>
                                        <input type="checkbox" name="ASA" class="pull-left" value="3" /><label class="pull-left">3</label>
                                        <input type="checkbox" name="ASA" class="pull-left" value="4" /><label class="pull-left">4</label>
                                        <input type="checkbox" name="ASA" class="pull-left" value="5" /><label class="pull-left">5</label>
                                        <input type="checkbox" name="ASA" class="pull-left" value="6" /><label class="pull-left">6</label>
                                        <input type="checkbox" name="ASA" class="pull-left" value="E" /><label class="pull-left">E</label>
                                    </div>
                                    <div class="col-md-5">
                                        <label class="pull-left">
                                            ALLERGIES
                                        </label>
                                        <b class="pull-right">:</b>
                                    </div>
                                    <div class="col-md-5">
                                        <input type="text" id="txtALLERGIES" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="POuter_Box_Inventory">
                        <div>
                            <b>PRE OP INSTRUCTIONS</b>

                        </div>

                        <div class="row">
                            <div class="row">
                                <div class="col-md-3">
                                    <input type="checkbox" id="checknpofrom" name="NPOFROM" class="pull-left" onchange="Fchecknpofrom()" value="NPO_FROM" /><label class="pull-left">NPO FROM</label>
                                </div>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtnpoTime" runat="server" MaxLength="8" ToolTip="Enter Time" Enabled="false" />
                                    <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txtnpoTime" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtnpoTime"
                                        ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                </div>
                                <label class="pull-left">HRS.ON</label>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txtnopdate" runat="server" ToolTip="Click To Select From Date" Enabled="false" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="ucFromDate_CalendarExtender" runat="server" TargetControlID="txtnopdate"
                                        Format="dd-MMM-yyyy" ClearTime="true">
                                    </cc1:CalendarExtender>
                                </div>
                                <label class="pull-left">(6 HRS FOR SOUNDS & 3 HRS FOR LIQUIDS BEFORE PLANNED OPERATION TIME)</label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="row">
                                <div class="col-md-24">
                                    <input type="checkbox" name="APPLY_EMLA" class="pull-left" value="1" />
                                    <label class="pull-left">APPLY EMLA/PRILOX CREAM ON BOTH DORSUM OF 90 MIN BEFORE SHIFTING TO OT.</label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="row">
                                <div class="col-md-24">
                                    <input type="checkbox" name="REMOVE_ALL" class="pull-left" value="1" />
                                    <label class="pull-left">REMOVE ALL PIERCINGS,DENTURES REMOVABLE,NAIL POLISH,CONTACT LENSES.ETC.</label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="row">
                                <div class="col-md-24">
                                    <input type="checkbox" name="SHIFT_OT" class="pull-left" value="1" />
                                    <label class="pull-left">SHIFT TO OT.30 MINS BEFORE PLANNED OPRATION TIME.</label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <input type="checkbox" id="checktab" name="POI" class="pull-left" value="1" />
                                    TAB.
                                </div>
                                <div class="col-md-6">
                                    <input type="text" id="txttabsearch" disabled="disabled" />
                                    <label id="selectedInvestigations" style="display: none"></label>
                                </div>
                                <div class="col-md-2">
                                    <input type="text" id="txttabmedvalue" disabled="disabled" />
                                </div>
                                <label class="pull-left">
                                    mg AT
                                </label>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txttabTime" runat="server" MaxLength="8" ToolTip="Enter Time" Enabled="false" />
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender3" Mask="99:99" runat="server" MaskType="Time"
                                        TargetControlID="txttabTime" AcceptAMPM="true">
                                    </cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlToValidate="txttabTime"
                                        ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                        InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                                </div>
                                <label class="pull-left">
                                    HRS. ON DATE
                                </label>
                                <div class="col-md-3">
                                    <asp:TextBox ID="txttabdate" runat="server" Enabled="false" ToolTip="Click To Select From Date" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txttabdate"
                                        Format="dd-MMM-yyyy" ClearTime="true">
                                    </cc1:CalendarExtender>
                                </div>
                                <div class="col-md-2">
                                    <input type="button" id="btntabadd" value="Add" onclick="addtabmedicine()" disabled="disabled" />
                                </div>
                            </div>
                            <div class="row">

                                <div class="row col-md-24">
                                    <div id="divtabmedicinetable">
                                        <table class="FixedTables " cellspacing="0" rules="all" border="1" id="tabmedicinetable" style="width: 100%; display: none; border-collapse: collapse;">
                                            <tr>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Tab Name</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Tab Dose</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Time</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Date</th>
                                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Remove</th>
                                            </tr>
                                        </table>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5">
                                <input type="checkbox" name="NEBULISATION" onchange="FcheckNEBULISATION()" id="checkNEBULISATION" class="pull-left" value="1" />
                                <label class="pull-left">
                                    NEBULISATION WITH
                                </label>
                            </div>
                            <div class="col-md-3">

                                <input type="text" id="txtNEBULISATION" disabled="disabled" />
                            </div>
                            <label class="pull-left">
                                ON
                            </label>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtNEBULISATIONdate" runat="server" Enabled="false" ToolTip="Click To Select From Date" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtNEBULISATIONdate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>

                            </div>
                            <label class="pull-left">
                                AT
                            </label>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtNEBULISATIONTime" runat="server" MaxLength="8" ToolTip="Enter Time" Enabled="false" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtNEBULISATIONTime" AcceptAMPM="true">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtNEBULISATIONTime"
                                    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                    InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            </div>
                            <label class="pull-left">
                                HRS.
                            </label>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <input type="checkbox" name="patient_can" class="pull-left" value="1" />
                                <label class="pull-left">
                                    PATIENT CAN TAKE USUAL PREOP MEDICATIONS EXCEPT -
                                </label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-8">
                                <input type="checkbox" name="STOP_ORAL" onchange="Fcheckstoporal()" id="checkstoporal" class="pull-left" value="1" />
                                <label class="pull-left">
                                    STOP ORAL HYPOGLYCEMIC AGENTS FROM 
                                </label>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtstoporalfrom" runat="server" Enabled="false" ToolTip="Click To Select From Date" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtstoporalfrom"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>

                            </div>
                            <label class="pull-left">
                                .GRBS AT 
                            </label>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtstoporalTime" runat="server" Enabled="false" MaxLength="8" ToolTip="Enter Time" />
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" Mask="99:99" runat="server" MaskType="Time"
                                    TargetControlID="txtstoporalTime" AcceptAMPM="true">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlToValidate="txtstoporalTime"
                                    ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                    InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                            </div>
                            <label class="pull-left">
                                .HRS ON 
                            </label>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtstoporalon" runat="server" Enabled="false" ToolTip="Click To Select From Date" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txtstoporalon"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                            </div>
                            <label class="pull-left">
                                AND INFORMATION 
                            </label>
                        </div>
                        <div class="row">
                            <div class="col-md-24">

                                <label class="pull-left">
                                    CONCERNED ANESTHESIOLOGIST.TREAT ACCORDINGLY
                                </label>

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <input type="checkbox" id="checkpreothers" onchange="Fcheckpreothers()" name="preother" class="pull-left" value="1" />
                                <label class="pull-left">
                                    OTHERS
                                </label>
                            </div>
                            <div class="col-md-4" id="divpreothertxtbox" style="display: none">
                                <input type="text" id="divpreothertxtboxvalue" />
                            </div>
                        </div>

                        <div class="POuter_Box_Inventory">

                            <input type="button" id="btnpresave" onclick="$Savepreopinstruction(this)" value="Save" />

                            <input type="button" id="btnpreupdate" onclick="$Updatepreopinstruction(this)" value="Update" style="display: none" />


                        </div>
                        <div class="POuter_Box_Inventory">
                            <div class="Purchaseheader">
                                PRE OP Instructions Result
                            </div>
                            <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tblpreopresult" style="width: 100%; display: none; border-collapse: collapse;">
                                <tr>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Patient Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Entry Date</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Entry BY</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Edit</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Print</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Remove</th>
                                </tr>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        
        <div class="POuter_Box_Inventory">
            <asp:Label ID="Label1" runat="server" CssClass="ItDoseLblError" />
            <div class="Purchaseheader" onclick="togglehideshow(2)">
                PREANESTHETIC EVALUATION (DEPT OF ANAESTHESIOLOGY & ICU)
            </div>
            <div id="divpac" style="display:none">
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            SURGICAL/ANESTHETIC HISTORY
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="text" id="txtpacSURGICAL_ANESTHETIC" />
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            ANTIICIPATED AIRWAY PROBLEMS
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-17">
                        <input type="checkbox" name="AAP" class="pull-left" value="NIL_DIFFICULT" /><label class="pull-left">NIL DIFFICULT</label>
                        <input type="checkbox" name="AAP" class="pull-left" value="VENTILATION_DIFFICULT" /><label class="pull-left">VENTILATION DIFFICULT</label>
                        <input type="checkbox" name="AAP" class="pull-left" value="INTUBATION" /><label class="pull-left">INTUBATION</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            RESPIRATORY
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-17">
                        <input type="checkbox" name="RES" class="pull-left" value="WNL" /><label class="pull-left">WNL</label>
                        <input type="checkbox" name="RES" id="checkRESPIRATORYsmoker" class="pull-left" value="SMOKER" /><label class="pull-left">SMOKER</label>
                        <div class="col-md-2">
                            <input type="text" id="txtRESPIRATORYsmoker" onlynumber="3" decimalplace="1" disabled="disabled" />
                        </div>
                        <label class="pull-left">
                            yrs
                        </label>
                        <input type="checkbox" name="RES" class="pull-left" value="ASTHMA" /><label class="pull-left">ASTHMA</label>
                        <input type="checkbox" name="RES" class="pull-left" value="COPD" /><label class="pull-left">COPD</label>
                        <input type="checkbox" name="RES" class="pull-left" value="RECENT_URI" /><label class="pull-left">RECENT URI</label>
                        <input type="checkbox" name="RES" class="pull-left" value="SLEEP_APNEA" /><label class="pull-left">SLEEP APNEA</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            CARDIOVASCULAR
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <input type="checkbox" name="CAR" class="pull-left" value="WNL" /><label class="pull-left">WNL</label>
                        <input type="checkbox" name="CAR" class="pull-left" value="IHD_CAD" /><label class="pull-left">IHD,CAD</label>
                        <input type="checkbox" name="CAR" class="pull-left" value="HTN" /><label class="pull-left">HTN</label>
                        <input type="checkbox" name="CAR" id="checkpaccarioothers" class="pull-left" value="OTHERS" /><label class="pull-left">OTHERS</label>

                    </div>
                    <div class="col-md-3" id="divcheckpaccarioothers" style="display: none">
                        <input type="text" id="txtcheckpaccarioothers" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            RENAL/ENDOCRINE
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-17">
                        <input type="checkbox" name="REEN" class="pull-left" value="WNL" /><label class="pull-left">WNL</label>
                        <input type="checkbox" name="REEN" class="pull-left" value="DIABETES_NIDDM_IDDM" /><label class="pull-left">DIABETES:NIDDM/IDDM</label>
                        <input type="checkbox" name="REEN" class="pull-left" value="RENAL_FAILURE_DIALYSIS" /><label class="pull-left">RENAL FAILURE/DIALYSIS</label>
                        <input type="checkbox" name="REEN" class="pull-left" value="RECENT_STEROIDS" /><label class="pull-left">RECENT STEROIDS</label>
                        <input type="checkbox" name="REEN" class="pull-left" value="THYROID_DISEASE" /><label class="pull-left">THYROID DISEASE</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            HEPATO/GASTROINTESTINAL
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="checkbox" name="HEGA" class="pull-left" value="WNL" /><label class="pull-left">WNL</label>

                        <input type="checkbox" name="HEGA" class="pull-left" value="PONV" /><label class="pull-left">PONV</label>
                        <input type="checkbox" name="HEGA" id="checkHEPATOothers" class="pull-left" value="OTHERS" /><label class="pull-left">OTHERS</label>

                    </div>
                    <div class="col-md-3" id="divcheckHEPATOothers" style="display: none">
                        <input type="text" id="txtcheckHEPATOothers" />
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            NEURO/MUSCULOSKELETAL
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-13">
                        <input type="checkbox" name="NEMU" class="pull-left" value="WNL" /><label class="pull-left">WNL</label>
                        <input type="checkbox" name="NEMU" class="pull-left" value="SERIZURES" /><label class="pull-left">SERIZURES</label>

                        <input type="checkbox" name="NEMU" class="pull-left" value="PARALYSIS" /><label class="pull-left">PARALYSIS</label>
                        <input type="checkbox" name="NEMU" class="pull-left" value="NEUROMUSCULAR_DISEASE" /><label class="pull-left">NEUROMUSCULAR DISEASE</label>
                        <input type="checkbox" name="NEMU" id="checkNEUROothers" class="pull-left" value="OTHERS" /><label class="pull-left">OTHERS</label>
                    </div>
                    <div class="col-md-3" id="divcheckNEUROothers" style="display: none">
                        <input type="text" id="txtcheckNEUROothers" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            OTHERS
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-17">
                        <input type="checkbox" name="OTHERS" class="pull-left" value="COAGULOPATHY" /><label class="pull-left">COAGULOPATHY</label>
                        <input type="checkbox" name="OTHERS" class="pull-left" value="OBESITY" /><label class="pull-left">OBESITY</label>
                        <input type="checkbox" name="OTHERS" class="pull-left" value="PREGNANCY" /><label class="pull-left">PREGNANCY</label>
                        <input type="checkbox" name="OTHERS" class="pull-left" value="SUBSTANCE_ABUSE" /><label class="pull-left">SUBSTANCE ABUSE</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            PRESENT MEDICATIONS
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <input type="checkbox" name="PRME" class="pull-left" value="ANTIHTN" /><label class="pull-left">ANTIHTN</label>
                        <input type="checkbox" name="PRME" class="pull-left" value="ANTIPLATELETS" /><label class="pull-left">ANTIPLATELETS</label>
                        <input type="checkbox" name="PRME" class="pull-left" value="ANTIDIABETIC" /><label class="pull-left">ANTIDIABETIC</label>
                        <input type="checkbox" name="PRME" class="pull-left" id="checkPRESENTothers" value="OTHERS" /><label class="pull-left">OTHERS</label>
                    </div>
                    <div class="col-md-3" id="divcheckPRESENTothers" style="display: none">
                        <input type="text" id="txtcheckPRESENTothers" />
                    </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <center>
                        <input type="button" id="btnsavepac" onclick="$savePAC(this)" value="Save" />
                        <input type="button" id="btnUpdatepac" value="update" onclick="$UpdatePAC(this)" style="display: none" />
                    </center>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        PREANESTHETIC EVALUATION (DEPT OF ANAESTHESIOLOGY & ICU) Result
                    </div>
                    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tblpacresult" style="width: 100%; display: none; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Patient Name</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Entry Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Entry BY</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Edit</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Print</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Remove</th>
                            </tr>
                        </thead>
                        <tbody id="pcatbody">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <asp:Label ID="Label2" runat="server" CssClass="ItDoseLblError" />
            <div class="Purchaseheader" onclick="togglehideshow(3)">
                PLAN OF ANESTHESIA:
            </div>
            <div id="divplanofanesthesia" style="display:none">
                <div class="row">
                    <input type="checkbox" name="ANAESplan" class="pull-left" value="1" />
                    <label class="pull-left">ANESTHESIA PLAN,ALTERNATIVES,RISKS,BENEFITS DISCUSSED WITH THE PATIENT,ALL QUESTION ANSWERED</label>
                </div>
                <div class="row">
                    <input type="checkbox" name="ANAES" class="pull-left" value="GA" /><label class="pull-left">GA</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="ETT" /><label class="pull-left">ETT</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="LMA" /><label class="pull-left">LMA</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="MASK" /><label class="pull-left">MASK</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="PRONEPOSITION" /><label class="pull-left">PRONE POSITION</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="MAC" /><label class="pull-left">MAC</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="WITHSEDATION" /><label class="pull-left">WITH SEDATION</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="WITHOUTSEDATION" /><label class="pull-left">WITHOUT SEDATION</label>

                    <input type="checkbox" name="ANAES" class="pull-left" value="SPECIALVASCULARACCESS" /><label class="pull-left">SPECIAL VASCULAR ACCESS</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="REG_A" /><label class="pull-left">REG.A</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="SA" /><label class="pull-left">SA</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="EPIDURAL" /><label class="pull-left">EPIDURAL</label>
                </div>
                <div class="row">
                    <input type="checkbox" name="ANAES" class="pull-left" value="NERVEBLOCK" /><label class="pull-left">NERVE BLOCK</label>
                    <input type="checkbox" name="ANAES" class="pull-left" value="IVRA" /><label class="pull-left">IVRA</label>
                </div>
                <div class="row">
                    <div class="col-md-7">
                        <label class="pull-left">
                            POST OP VENTILATION PLAN
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-10">
                        <input type="checkbox" name="ANAESPRESENT" class="pull-left check4" value="YES" /><label class="pull-left">YES</label>
                        <input type="checkbox" name="ANAESPRESENT" class="pull-left check4" value="NO" /><label class="pull-left">NO</label>
                    </div>
                </div>
                <div class="row">
                    <input type="checkbox" name="ANAESPATIENTAGREED" class="pull-left" value="1" />
                    <label class="pull-left">PATIENT AGREED AND INFORMED CONSENT OBTAINED</label>
                </div>
                <div class="POuter_Box_Inventory">
                    <center>
                        <input type="button" value="Save" id="btnsaveAnesthesia" onclick="$saveAnesthesia(this)" />
                        <input type="button" id="btnupdateane" onclick="$UpdateANE(this)" value="update" style="display: none" />
                    </center>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Plan of Anesthesia Result
                    </div>
                    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tblAnesthesia" style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">S.No.</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Patient Name</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Entry Date</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Entry BY</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Edit</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Print</th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Remove</th>
                            </tr>
                        </thead>
                        <tbody id="Tbody1">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
            </div>
    </form>
</body>
</html>

