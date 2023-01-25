<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SurgerySafetyCheckList.aspx.cs" Inherits="SurgerySafetyCheckList" %>

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

</head>
<script type="text/javascript">
    $(document).ready(function () {
        $('input[type="checkbox"]').click(function () {
            var name = $(this).attr("name");
            $("input[name='" + name + "']:checkbox").not(this).prop('checked', false);
        });

        GetSurgerySafety();
        $bindDoctor();
        $BindAnesthetist();
        BindCirculatingNurse();
    });


    


    var BindCirculatingNurse = function (callback) {
        serverCall('SurgerySafetyCheckList.aspx/BindCirculatingNurse', {}, function (response) {
            var ddlTOCIRCULATINGNURSE = $('#ddlTOCIRCULATINGNURSE');
            var ddlSO0CIRCULATINGNURSE = $('#ddlSO0CIRCULATINGNURSE');
            ddlTOCIRCULATINGNURSE.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'DoctorID', textField: 'NAME' });
            ddlSO0CIRCULATINGNURSE.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'DoctorID', textField: 'NAME' });
        });
    }
    
    var $BindAnesthetist = function (callback) {
        serverCall('SurgerySafetyCheckList.aspx/BindAnesthetist', {}, function (response) {
            var ddlanesthetist = $('#ddlanesthetist');
            var Addlanesthetist = $('#Addlanesthetist');
            ddlanesthetist.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'DoctorID', textField: 'NAME' });
            Addlanesthetist.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'DoctorID', textField: 'NAME' });
        });
    }

    var $bindDoctor = function () {
        var $ddlDoctor = $('#ddlsurgeon');
        serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: 'ALL' }, function (response) {

            var option = {
                defaultValue: 'Select',
                data: JSON.parse(response),
                valueField: 'DoctorID',
                textField: 'Name',
                isSearchAble: true
            };
            $ddlDoctor.bindDropDown(option);
        });
    }


    function Fcheckpreothers() {
        if ($("#checkanythingunique").is(':checked')) {
            $('#txtanythingunique').val('').prop("disabled", true);
        }
        else {
            $('#txtanythingunique').removeAttr("disabled");
        }
    }
    function Fcheckanyspecial() {
        if ($("#Checkanyspecial").is(':checked')) {
            $('#txtanyspecial').val('').prop("disabled", true);
        }
        else {
            $('#txtanyspecial').removeAttr("disabled");
        }
    }
    function ISInstrumentChecked() {
        if ($('#checkinstrument').is(':checked')) {
            $("input[name='INSTRUMENTVAL']:checkbox").prop('disabled', false);
        }
        else {
            $("input[name='INSTRUMENTVAL']:checkbox").prop("disabled", true).removeAttr("checked");
        }
    }
    function IsActualproeChecked() {
        if ($('#checkactualproce').is(':checked')) {
            $('#txtactualproce').prop('disabled', false);
        }
        else {
            $('#txtactualproce').val('').prop('disabled', true);
        }
    }

    //----------------------Get Details----------------------------//

    var $GetSurgerySafety_Details = function (callback) {
        var PREOPAREABEFORE = "";
        var ISPATIENTIDEN = "";
        var ANYANESTHESIA = "";
        var ANESTHESIASAFETY = "";
        var RISKBLOOD = "";
        var TWOIV = "";
        var BLOODPRODUCTS = "";
        var INCASEOF = "";
        var DOSEEVERYONE = "";
        var WHATISPATIENT = "";
        var ISCORRECT = "";
        var ROUTINE = "";
        var IMPLANTOR = "";
        var ISESSENTIAL = "";
        var ANTIBIOTIC = "";
        var HASSTERILITY = "";
        var INSTRUMENTVAL = "";
        var COMPLICATION = "";
        $('.PREOP').each(function () {
            if ($(this).is(':checked')) {
                PREOPAREABEFORE += $(this).val() + ','
            }
        });
        $("input[name='ISPATIENT").each(function () {
            if ($(this).is(':checked')) {
                ISPATIENTIDEN = $(this).val();
            }
        });
        $("input[name='ANYANESTHESIA").each(function () {
            if ($(this).is(':checked')) {
                ANYANESTHESIA = $(this).val();
            }
        });

        $("input[name='ANESTHESIASAFETY").each(function () {
            if ($(this).is(':checked')) {
                ANESTHESIASAFETY = $(this).val();
            }
        });

        $("input[name='RISKBLOOD").each(function () {
            if ($(this).is(':checked')) {
                RISKBLOOD = $(this).val();
            }
        });

        $("input[name='TWOIV").each(function () {
            if ($(this).is(':checked')) {
                TWOIV = $(this).val();
            }
        });
        $("input[name='BLOODPRODUCTS").each(function () {
            if ($(this).is(':checked')) {
                BLOODPRODUCTS = $(this).val();
            }
        });
        $("input[name='INCASEOF").each(function () {
            if ($(this).is(':checked')) {
                INCASEOF = $(this).val();
            }
        });


        $("input[name='DOSEEVERYONE").each(function () {
            if ($(this).is(':checked')) {
                DOSEEVERYONE = $(this).val();
            }
        });
        $("input[name='WHATISPATIENT").each(function () {
            if ($(this).is(':checked')) {
                WHATISPATIENT = $(this).val();
            }
        });
        $("input[name='ISCORRECT").each(function () {
            if ($(this).is(':checked')) {
                ISCORRECT = $(this).val();
            }
        });
        $("input[name='ROUTINE").each(function () {
            if ($(this).is(':checked')) {
                ROUTINE = $(this).val();
            }
        });
        $("input[name='IMPLANTOR").each(function () {
            if ($(this).is(':checked')) {
                IMPLANTOR = $(this).val();
            }
        });
        $("input[name='ISESSENTIAL").each(function () {
            if ($(this).is(':checked')) {
                ISESSENTIAL = $(this).val();
            }
        });
        $("input[name='ANTIBIOTIC").each(function () {
            if ($(this).is(':checked')) {
                ANTIBIOTIC = $(this).val();
            }
        });
        $("input[name='HASSTERILITY").each(function () {
            if ($(this).is(':checked')) {
                HASSTERILITY = $(this).val();
            }
        });
        $("input[name='INSTRUMENTVAL").each(function () {
            if ($(this).is(':checked')) {
                INSTRUMENTVAL = $(this).val();
            }
        });

        $("input[name='COMPLICATION").each(function () {
            if ($(this).is(':checked')) {
                COMPLICATION = $(this).val();
            }
        });

        var surgerysafetydetails = {
            TransactionID: $('#TransactionID').text().trim(),
            PatientID: $('#PatientId').text().trim(),
            //  Appointment_ID: $('#Appointment_ID').text(),
            // OT_ID: $('#OT_ID').text(),
            PREOP_AREA_BEFORE: PREOPAREABEFORE.slice(0, -1),
            IS_PatientIDEN: ISPATIENTIDEN,
            ANY_ANESTHESIA: ANYANESTHESIA,
            ANESTHESIA_SAFETY: ANESTHESIASAFETY,
            RISK_BLOOD: RISKBLOOD,
            TWO_IV: TWOIV,
            BLOOD_PRODUCTS: BLOODPRODUCTS,
            IN_CASE_OF: INCASEOF,
            TIME_PATIENT_WHEELED: $('#txttimepatient').val().trim(),
            ANESTHETIST: $('#Addlanesthetist').val().trim(),    //$('#txtanesthetist').val(),

            DOSE_EVERYONE: DOSEEVERYONE,
            WHAT_IS_PATIENT: WHATISPATIENT,
            PROCEDURE_NAME: $('#txtprocedurename').val().trim(),
            IS_THE_CORRECT: ISCORRECT,
            EXPECTED_DURATION: $('#txtexpectedduration').val().trim(),
            DISCUSS_IF: ROUTINE,
            IMPLANTS_OR: IMPLANTOR,
            IS_ESSENTIAL: ISESSENTIAL,
            ANTIBIOTIC: ANTIBIOTIC,
            ANTIBIOTIC_DRUG: $('#txtantibioticdrug').val().trim(),
            ADMINISTRATION_TIME: $('#txttimeadminstation').val().trim(),
            IS_ANYTHING_UNIQUE: $("input[name='ANYTHINGUNIQUE").is(':checked') == true ? 1 : 0,
            ANYTHING_VALUE: $("input[name='ANYTHINGUNIQUE").is(':checked') == false ? $('#txtanythingunique').val().trim() : '',
            HAS_STERILITY: HASSTERILITY,
            INCISION_TIME: $('#txtincisiontime').val(),
            TO_CIRCULATING_NURSE: $('#ddlTOCIRCULATINGNURSE').val(), //$('#TOCIRCULATINGNURSE').val(),
            TO_CIRCULATING_NURSE_VALUE: $('#txtTOCIRCULATINGNURSE_VALUE').val(), //$('#TOCIRCULATINGNURSE').val(),

            IS_INSTRUMENT: $("input[name='INSTRUMENT").is(':checked') == true ? 1 : 0,
            INSTRUMENT_VAL: $("input[name='INSTRUMENT").is(':checked') == true ? INSTRUMENTVAL : '',
            IS_ACTUALPROCE: $("input[name='ACTUALPROCE").is(':checked') == true ? 1 : 0,
            ACTUALPROCE_VAL: $("input[name='ACTUALPROCE").is(':checked') == true ? $('#txtactualproce').val().trim() : '',
            IS_SPECIMEN: $("input[name='SPECIMEN").is(':checked') == true ? 1 : 0,
            BLOOD_LOSS: $('#txtbloodloss').val().trim() == "" ? 0 : $('#txtbloodloss').val().trim(),
            COMPLICATION: COMPLICATION,
            COMPLICATION_VAl: $('#txtcomplication').val().trim(),
            IS_ANYSPECIAL: $("input[name='ANYSPECIAL").is(':checked') == true ? 1 : 0,
            ANYSPECIAL_val: $("input[name='ANYSPECIAL").is(':checked') == false ? $('#txtanyspecial').val().trim() : '',
            TIME_WHEELED_OUT: $('#txtpatientwheeled').val().trim(),
            SO_CIRCULATING_NURSE: $('#ddlSO0CIRCULATINGNURSE').val().trim(), //$('#txtSO0CIRCULATINGNURSE').val()
            SO_CIRCULATING_NURSE_VALUE: $('#txtSO0CIRCULATINGNURSE_VALUE').val().trim(), //$('#txtSO0CIRCULATINGNURSE').val()
            DoctorID: $('#ddlsurgeon').val().trim(),
            Anesthetist_In_Charge: $('#ddlanesthetist').val().trim(),
            OTBOOKING_ID: $('#OTBookingID').text().trim() == "" ? 0 : $('#OTBookingID').text().trim(),
            Appointment_ID: $('#App_ID').text().trim() == "" ? 0 : $('#App_ID').text().trim(),
            HGB: $('#txtHgb').val().trim(),
            PLT: $('#txtPLT').val().trim(),
            Na: $('#txtNa').val().trim(),
            K: $('#txtK').val().trim(),
            Cr: $('#txtCr').val().trim(),
            TOther: $('#txtOther').val().trim(),
        }

        callback({ SurgerySafetyDetails: surgerysafetydetails, SSCID: sscid });
    }


    var sscid = "";
    var $EditSurgerySafety = function (el) {
        sscid = $(el).closest('tr').find('#tdsscid').text().trim();
        serverCall('SurgerySafetyCheckList.aspx/EditSurgerySafety', { SSCID: sscid }, function (response) {
            var responseData = JSON.parse(response);
            $('#txtactualproce').val('').attr('disabled', 'disabled');
            $('.pull-left').removeAttr("checked");
            $('#txttimepatient').val('');
            //$('#txtanesthetist').val('');
            $('#txtprocedurename').val('');
            $('#txtexpectedduration').val('');
            $('#txtantibioticdrug').val('');
            $('#txttimeadminstation').val();
            $('#txtanythingunique').val('').removeAttr('disabled');
            $('#txtincisiontime').val('');
          //  $('#TOCIRCULATINGNURSE').val('');
            $("input[name='INSTRUMENTVAL']:checkbox").prop("disabled", true).removeAttr("checked");
            $('#txtactualproce').val('');
            $('#txtbloodloss').val('');
            $('#txtcomplication').val('');
            $('#txtanyspecial').val('').removeAttr('disabled');
            $('#txtpatientwheeled').val();
           // $('#txtSO0CIRCULATINGNURSE').val('');

            $('.PREOP').each(function () {
                if (responseData[0]["PREOP_AREA_BEFORE"].includes($(this).val())) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='ISPATIENT").each(function () {
                if ($(this).val() == responseData[0]["IS_PatientIDEN"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='ANYANESTHESIA").each(function () {
                if ($(this).val() == responseData[0]["ANY_ANESTHESIA"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='ANESTHESIASAFETY").each(function () {
                if ($(this).val() == responseData[0]["ANESTHESIA_SAFETY"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='RISKBLOOD").each(function () {
                if ($(this).val() == responseData[0]["RISK_BLOOD"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='TWOIV").each(function () {
                if ($(this).val() == responseData[0]["TWO_IV"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='BLOODPRODUCTS").each(function () {
                if ($(this).val() == responseData[0]["BLOOD_PRODUCTS"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='INCASEOF").each(function () {
                if ($(this).val() == responseData[0]["IN_CASE_OF"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $('#txttimepatient').val(responseData[0]["TIME_PATIENT_WHEELED"]);

            $('#Addlanesthetist').val(responseData[0]["ANESTHETIST"]);
            //$('#txtanesthetist').val(responseData[0]["ANESTHETIST"])

            $("input[name='DOSEEVERYONE").each(function () {
                if ($(this).val() == responseData[0]["DOSE_EVERYONE"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='WHATISPATIENT").each(function () {
                if ($(this).val() == responseData[0]["WHAT_IS_PATIENT"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $('#txtprocedurename').val(responseData[0]["PROCEDURE_NAME"]);
            $("input[name='ISCORRECT").each(function () {
                if ($(this).val() == responseData[0]["IS_THE_CORRECT"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $('#txtexpectedduration').val(responseData[0]["EXPECTED_DURATION"])

            $("input[name='ROUTINE").each(function () {
                if ($(this).val() == responseData[0]["DISCUSS_IF"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='IMPLANTOR").each(function () {
                if ($(this).val() == responseData[0]["IMPLANTS_OR"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $("input[name='ISESSENTIAL").each(function () {
                if ($(this).val() == responseData[0]["IS_ESSENTIAL"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='ANTIBIOTIC").each(function () {
                if ($(this).val() == responseData[0]["ANTIBIOTIC"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $('#txtantibioticdrug').val(responseData[0]["ANTIBIOTIC_DRUG"]);
            $('#txttimeadminstation').val(responseData[0]["ADMINISTRATION_TIME"]);
            $('#txtanythingunique').val(responseData[0]["ANYTHING_VALUE"]);
            $("input[name='ANYTHINGUNIQUE").each(function () {
                if ($(this).val() == responseData[0]["IS_ANYTHING_UNIQUE"]) {
                    $(this).attr("checked", "checked");
                    $('#txtanythingunique').val('').attr('disabled', 'disabled');
                }
            });

            $("input[name='HASSTERILITY").each(function () {
                if ($(this).val() == responseData[0]["HAS_STERILITY"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $('#txtincisiontime').val(responseData[0]["INCISION_TIME"]);


          //  $('#TOCIRCULATINGNURSE').val(responseData[0]["TO_CIRCULATING_NURSE"]);
            //$('#ddlTOCIRCULATINGNURSE').val(responseData[0]["TO_CIRCULATING_NURSE"]);
            $('#txtTOCIRCULATINGNURSE_VALUE').val(responseData[0]["TO_CIRCULATING_NURSE_VALUE"]);

            $("input[name='INSTRUMENT").each(function () {
                if ($(this).val() == responseData[0]["IS_INSTRUMENT"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $("input[name='INSTRUMENTVAL").each(function () {
                if ($(this).val() == responseData[0]["INSTRUMENT_VAL"]) {
                    $(this).attr("checked", "checked");
                    $(this).removeAttr("disabled");
                }
            });
            $("input[name='ACTUALPROCE").each(function () {
                if ($(this).val() == responseData[0]["IS_ACTUALPROCE"]) {
                    $(this).attr("checked", "checked");
                    $('#txtactualproce').removeAttr('disabled');
                }
            });

            $('#txtactualproce').val(responseData[0]["ACTUALPROCE_VAL"]);

            $("input[name='SPECIMEN").each(function () {
                if ($(this).val() == responseData[0]["IS_SPECIMEN"]) {
                    $(this).attr("checked", "checked");
                }
            });
            $('#txtbloodloss').val(responseData[0]["BLOOD_LOSS"]);
            $("input[name='COMPLICATION").each(function () {
                if ($(this).val() == responseData[0]["COMPLICATION"]) {
                    $(this).attr("checked", "checked");
                }
            });

            $('#txtcomplication').val(responseData[0]["COMPLICATION_VAl"]);
            $('#txtanyspecial').val(responseData[0]["ANYSPECIAL_val"]);
            $("input[name='ANYSPECIAL").each(function () {
                if ($(this).val() == responseData[0]["IS_ANYSPECIAL"]) {
                    $(this).attr("checked", "checked");
                    $('#txtanyspecial').val('').attr('disabled', 'disabled');
                }
            });
            $('#txtpatientwheeled').val(responseData[0]["TIME_WHEELED_OUT"]);

            // $('#txtSO0CIRCULATINGNURSE').val(responseData[0]["SO_CIRCULATING_NURSE"]);
            //$('#ddlSO0CIRCULATINGNURSE').val(responseData[0]["SO_CIRCULATING_NURSE"]);
            $('#txtSO0CIRCULATINGNURSE_VALUE').val(responseData[0]["SO_CIRCULATING_NURSE_VALUE"]);
            $('#ddlanesthetist').val(responseData[0]["Anesthetist_In_Charge"]);
            $('#ddlsurgeon').val(responseData[0]["DoctorID"]).chosen('destroy').chosen();
            
             $('#txtHgb').val(responseData[0]["HGB"]);
             $('#txtPLT').val(responseData[0]["PLT"]);
             $('#txtNa').val(responseData[0]["Na"]);
             $('#txtK').val(responseData[0]["K"]);
             $('#txtCr').val(responseData[0]["Cr"]);
             $('#txtOther').val(responseData[0]["TOther"]);

            $('#btnUpdate').show();
            $('#btnsavesurgery').hide();
        });

    }

    var GetSurgerySafety = function () {
        var row = "";
        var TransactionID = $('#TransactionID').text().trim();
        var PatientID = $('#PatientId').text().trim();
        serverCall('SurgerySafetyCheckList.aspx/getSurgerySafety', { TransactionID: TransactionID, PatientId: PatientID }, function (response) {
            var responseData = JSON.parse(response);
            for (var i = 0; i < responseData.length; i++) {
                row += '<tr>';
                row += '<td class="GridViewLabItemStyle" id="tdsno" > ' + (i + 1) + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdsscid" style="display:none" >' + responseData[i].sscid + '</td>';
                row += '<td class="GridViewLabItemStyle"  >' + responseData[i].patientname + '</td>';
                row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_date + '</td>';
                row += '<td class="GridViewLabItemStyle"  >' + responseData[i].Entry_by + '</td>';
                row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/edit.png" onclick="$EditSurgerySafety(this)"></center></td>';
                row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/print.gif" onclick="PrintSurgerySafety(this)"></center></td>';
                row += '<td class="GridViewLabItemStyle"  ><center><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removessc(this)"></center></td>';
                row += '</tr>';
            }
            $('#tbl_Surgery_Safety').append(row);
            if (responseData.length > 0) {
                $('#tbl_Surgery_Safety').show();
            }
        });
    }

    var removessc = function (el) {
        var count = 0;
        $(el).closest('tr').remove();
        $('#tbl_Surgery_Safety tbody tr').each(function () {
            count = count + 1;
            $(this).closest('tr').find('#tdsno').text(count);
        });
        if (count == 0) {
            $('#tbl_Surgery_Safety').hide();
        }
        var sscid = $(el).closest('tr').find('#tdsscid').text().trim();
        serverCall('SurgerySafetyCheckList.aspx/remove', { SSCID: sscid }, function (response) {
            var responseData = JSON.parse(response);
            modelAlert(responseData.response, function () {
                if (responseData.status) {
                    window.location.reload();
                }

            });
        });
    }

    var $SaveSurgerySafety = function (btnsave) {
        $GetSurgerySafety_Details(function (data) {
            $(btnsave).attr('disabled', true).val('Submitting...');
            serverCall('SurgerySafetyCheckList.aspx/SaveSurgerySafety', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        window.location.reload();
                });
            });
        });
    }

    var $UpdateSurgerySafety = function (btnUpdate) {
        $GetSurgerySafety_Details(function (data) {
            $(btnUpdate).attr('disabled', true).val('Updating...');
            serverCall('SurgerySafetyCheckList.aspx/UpdateSurgerySafety', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        window.location.reload();
                });
            });
        });
    }

    var PrintSurgerySafety = function (el) {
        var sscid = $(el).closest('tr').find('#tdsscid').text();
        serverCall('SurgerySafetyCheckList.aspx/PrintSurgerySafety', { SSCID: sscid }, function (response) {
            var responseData = JSON.parse(response);
            if (responseData.status)
                window.open(responseData.responseURL);
            else
                modelAlert(responseData.response);
        });
    }
</script>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        <asp:Label ID="TransactionID" runat="server" Style="display: none" />
        <asp:Label ID="PatientId" runat="server" Style="display: none" />
        <asp:Label ID="App_ID" runat="server" Style="display: none" />
        <asp:Label ID="OTBookingID" runat="server" Style="display: none" />
         <asp:Label ID="OTNumber" runat="server" Style="display: none" />


        <div class="POuter_Box_Inventory">
            <asp:Label ID="Label3" runat="server" CssClass="ItDoseLblError" />
            <div class="Purchaseheader" onclick="togglehideshow(4)">
                Surgery Safety Check List 
            </div>
            <div id="divSurgerySafety">
                <div class="POuter_Box_Inventory Purchaseheader">
                    Sign IN
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">A.  IN PREOP AREABEFORE SHIFTING PATIENT TO OPERATING ROOM(O.R)</label>
                    </div>
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">B.  IN PREOP AREA/IN OPERATING ROOM BEFORE INDUCTION OF ANAESTHESIA</label>
                    </div>
                </div>

                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold"><u>A.  IN PREOP AREA BEFORE SHIFTING PATIENT TO OPERATING ROOM O.R,REVIEW WITH PATIENT & CHECK CASE FILE</u> </label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">1.</label>
                        <input type="checkbox" name="PREOPAREABEFOR" class="pull-left PREOP " value="Patient" />
                        <label class="pull-left ">Patient Identification(Name,Age,IPID,ID Band)</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">2.</label>
                        <input type="checkbox" name="PREOPAREABEFO" class="pull-left PREOP" value="Surgical" />
                        <label class="pull-left ">Surgical Procedure to be performed</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">3.</label>
                        <input type="checkbox" name="PREOPAREABEF" class="pull-left PREOP" value="Site_Side" />
                        <label class="pull-left ">Site/Side of surgical procedure with marking</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">4.</label>
                        <input type="checkbox" name="PREOPAREABE" class="pull-left PREOP" value="Consent" />
                        <label class="pull-left ">Consent Forms(Surgery,Anesthesia) Complete & Signed</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">5.</label>
                        <input type="checkbox" name="PREOPAREAB" class="pull-left PREOP" value="Known" />
                        <label class="pull-left ">Known allergies</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">6.</label>
                        <label class="pull-left "> Lab Test</label>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left ">HGB</label>
                            <input type="text" id="txtHgb" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left ">PLT</label>
                            <input type="text" id="txtPLT" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left ">Na+</label>
                            <input type="text" id="txtNa" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left ">K+</label>
                            <input type="text" id="txtK" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left ">Cr</label>
                            <input type="text" id="txtCr" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left ">Others</label>
                            <input type="text" id="txtOther" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="pull-left ">7.</label>
                        <input type="checkbox" name="PREOPAREA" class="pull-left PREOP" value="Airway" />
                        <label class="pull-left ">Airway assessed for difficulty</label>
                    </div>
                    <div class="POuter_Box_Inventory">
                        <div class="row">
                            <label class="pull-left ">_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ </label>
                            <br />
                            <label class="pull-left ">Nurse / Anesthetist / Surgon(in case of LA)Sign</label><br />
                            <label class="pull-left " style="font-style: italic">OT Technician to transfer the patient to O.R only after part A is completed and signed by Anaesthetist.</label>
                        </div>
                    </div>
                </div>

                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left "><u><b>B. IN PREOP AREA/IN O.R.BEFORE INDUCTION </b></u></label>
                    </div>
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold"><u>ANESTHESIA REVIEW :</u></label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">1. Is Patient Identification Reconfirmed ?</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="ISPATIENT" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="ISPATIENT" class="pull-left" value="No" />
                        <label class="pull-left ">No</label>
                    </div>

                    <div class="row">
                        <label class="pull-left ">2. Any Anesthesia Equipment Issues or concerms </label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="ANYANESTHESIA" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="ANYANESTHESIA" class="pull-left" value="No" />
                        <label class="pull-left ">No</label>
                    </div>

                    <div class="row">
                        <label class="pull-left ">3. Anesthesia safety check has been completed </label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="ANESTHESIASAFETY" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="ANESTHESIASAFETY" class="pull-left" value="No" />
                        <label class="pull-left ">No</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">4. Risk of blood loss > 500ml/7ml/kg in children</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="RISKBLOOD" class="pull-left" value="Yes" />
                        <label class="pull-left ">No</label>
                        <input type="checkbox" name="RISKBLOOD" class="pull-left" value="No" />
                        <label class="pull-left ">Yes</label>
                    </div>

                    <div class="row">
                        <label class="pull-left ">5. Two IVs/Central access and fluids planned</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="TWOIV" class="pull-left" value="NA" />
                        <label class="pull-left ">NA</label>
                        <input type="checkbox" name="TWOIV" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                    </div>

                    <div class="row">
                        <label class="pull-left ">6. Blood Products arranged</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="BLOODPRODUCTS" class="pull-left" value="NA" />
                        <label class="pull-left ">NA</label>
                        <input type="checkbox" name="BLOODPRODUCTS" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">7. In case of difficult airway(see A6 above),whether Equipment/Assistance available</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="INCASEOF" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="INCASEOF" class="pull-left" value="No" />
                        <label class="pull-left ">No</label>
                        <input type="checkbox" name="INCASEOF" class="pull-left" value="NA" />
                        <label class="pull-left ">NA</label>
                    </div>
                    <div class="row" style="display:none;">
                        <label class="pull-left " style="font-weight: bold">Time Patient Wheeled in O.R.</label>
                        <div class="col-md-4">
                            <asp:TextBox ID="txttimepatient" runat="server" MaxLength="8" ToolTip="Enter Time" Width="106px" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txttimepatient" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txttimepatient"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                    </div>
                    <div class="row" style="display:none;">
                        <label class="pull-left " style="font-weight: bold">Anesthetist</label>
                        <div class="col-md-6">
                            <input type="text" id="txtanesthetist" style="display:none" />
                            <select id="Addlanesthetist"></select>
                        </div>
                    </div>
                </div>

                <div class="POuter_Box_Inventory Purchaseheader">
                    TIME OUT(Operating Room)
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">C. BEFORE SKIN INCISION (SAFETY PAUSE)</label>
                    </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left ">1. Dose Everyone Know Each Other ?</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="DOSEEVERYONE" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="DOSEEVERYONE" class="pull-left" value="No" />
                        <label class="pull-left ">No (If No,introduce-name,role)</label>
                    </div>
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold"><u>SURGEON REVIEWS WITH THW TEAM:</u></label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">2. What is the patient's name ?</label>

                    </div>
                    <div class="row">
                        <input type="checkbox" name="WHATISPATIENT" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="WHATISPATIENT" class="pull-left" value="NO" />
                        <label class="pull-left ">No</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">3. Name of the procedure planed</label><br />
                        <div class="col-md-6">
                            <input type="text" id="txtprocedurename" />
                        </div>
                    </div>
                    <div class="row">
                        <label class="pull-left ">4. Is the correct site prepared and draped ?</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="ISCORRECT" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="ISCORRECT" class="pull-left" value="No" />
                        <label class="pull-left ">No</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">5. Expected Duration of Surgery</label>
                        <div class="col-md-6">
                            <input type="text" id="txtexpectedduration" />
                        </div>
                    </div>

                    <div class="row">
                        <label class="pull-left ">6. Discuss if there is anything unique or non routine about this surgery ?</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="ROUTINE" class="pull-left" value="Routine" />
                        <label class="pull-left ">Routine</label>
                        <input type="checkbox" name="ROUTINE" class="pull-left" value="Non_routinge" />
                        <label class="pull-left ">Non routinge/Any issues</label>
                    </div>


                    <div class="row">
                        <label class="pull-left ">7. Implants or Special Equiment required</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="IMPLANTOR" class="pull-left" value="NA" />
                        <label class="pull-left ">NA</label>
                        <input type="checkbox" name="IMPLANTOR" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                    </div>

                    <div class="row">
                        <label class="pull-left ">8. Is Essential  Imaging Displayed ?</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="ISESSENTIAL" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="ISESSENTIAL" class="pull-left" value="Not" />
                        <label class="pull-left ">Not applicable</label>
                    </div>

                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">ANAESTHETIST REVIEWS WITH THE TEAM:</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">9. Antibiotic Prophylaxis Given Within Last 15-60 Minutes(90-120 for Vanco, Metro, etc)?</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="ANTIBIOTIC" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="ANTIBIOTIC" class="pull-left" value="No" />
                        <label class="pull-left ">No</label>
                        <input type="checkbox" name="ANTIBIOTIC" class="pull-left" value="Not" />
                        <label class="pull-left ">Not applicable</label>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <label class="pull-left ">Drug Name</label><br />
                            <input type="text" id="txtantibioticdrug" />
                        </div>
                        <div class="col-md-6">
                            <label class="pull-left ">Time of administration</label><br />
                            <asp:TextBox ID="txttimeadminstation" runat="server" MaxLength="8" ToolTip="Enter Time" Width="90px" />
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txttimeadminstation" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txttimeadminstation"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                    </div>
                    <div class="row">
                        <label class="pull-left ">10. Is There Anything Unique Or Non-Routine About Anesthesia Administration ?</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" id="checkanythingunique" onchange="Fcheckpreothers()" name="ANYTHINGUNIQUE" class="pull-left" value="1" />
                        <label class="pull-left ">No</label>
                        <label class="pull-left ">&nbsp If Yes</label>
                        <span class="col-md-6">
                            <input type="text" id="txtanythingunique" /></span>
                    </div>
                    <div class="row">
                        <label class="pull-left" style="font-weight: bold">NURSING TEAM REVIEWS</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">11. Has sterility been confirmed</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="HASSTERILITY" class="pull-left" value="Yes" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="HASSTERILITY" class="pull-left" value="No" />
                        <label class="pull-left ">No</label>
                    </div>
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">Incision Time &nbsp&nbsp&nbsp&nbsp&nbsp</label>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtincisiontime" runat="server" MaxLength="8" ToolTip="Enter Time" Width="90px" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender2" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtincisiontime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlToValidate="txtincisiontime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                    </div>
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">Circulating Nurse Comments</label>
                        <div class="col-md-12">
                            <input type="text" id="TOCIRCULATINGNURSE"  style="display:none;"/>
                            <input type="text" id="txtTOCIRCULATINGNURSE_VALUE" />
                            <select id="ddlTOCIRCULATINGNURSE"  style="display:none;"></select>
                        </div>
                    </div>
                </div>

                <div class="POuter_Box_Inventory Purchaseheader">
                    SIGN OUT(Operating Room)
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">D. BEFORE PATIENT LEAVES OPERATING ROOM </label>
                    </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">NURSE REVIEWS WITH TEAM:</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">1.</label>
                        <input type="checkbox" name="INSTRUMENT" id="checkinstrument" onchange="ISInstrumentChecked()" class="pull-left" value="1" />
                        <label class="pull-left ">Instrument, sponge, swab and needle counts are correct</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="INSTRUMENTVAL" class="pull-left" value="Yes" disabled="disabled" />
                        <label class="pull-left ">Yes</label>
                        <input type="checkbox" name="INSTRUMENTVAL" class="pull-left" value="No" disabled="disabled" />
                        <label class="pull-left ">No</label>
                        <input type="checkbox" name="INSTRUMENTVAL" class="pull-left" value="Not" disabled="disabled" />
                        <label class="pull-left ">Not applicable</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">2.</label>
                        <input type="checkbox" name="ACTUALPROCE" id="checkactualproce" onchange="IsActualproeChecked()" class="pull-left" value="1" />
                        <label class="pull-left ">Name of the actual procedure performed</label><br />
                        <span class="col-sm-6">
                            <input type="text" id="txtactualproce" disabled="disabled" /></span>
                    </div>
                    <div class="row">
                        <label class="pull-left ">3.</label>
                        <input type="checkbox" name="SPECIMEN" class="pull-left" value="1" />
                        <label class="pull-left ">Specimen labeling Read back specimen ladeling including patient's name & UHID/IPD</label>
                    </div>
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">SURGICAL TEAM DISCUSSES:</label>
                    </div>
                    <div class="row">
                         <label class="pull-left ">4. ESTIMATED</label>
                        <label class="pull-left ">BLOOD LOSS:</label>
                        <span class="col-md-3">
                            <input type="text" id="txtbloodloss" onlynumber="6" decimalplace="4" /></span>
                        <label class="pull-left ">ML</label>
                    </div>
                    <div class="row">
                        <label class="pull-left ">5. COMPLICATION:</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" name="COMPLICATION" class="pull-left" value="Yes" /><label class="pull-left ">Yes</label>
                        <input type="checkbox" name="COMPLICATION" class="pull-left" value="No" /><label class="pull-left ">No</label>
                    </div>
                    <div class="row">
                        <span class="col-md-6">
                            <input type="text" id="txtcomplication" />
                        </span>
                    </div>
                    <div class="row">
                        <label class="pull-left ">6. Any Special precaution to be taken inPost-Operative Patient management</label>
                    </div>
                    <div class="row">
                        <input type="checkbox" id="Checkanyspecial" onchange="Fcheckanyspecial()" name="ANYSPECIAL" class="pull-left" value="1" />
                        <label class="pull-left ">No</label>
                        <label class="pull-left ">&nbsp If Yes</label>
                        <span class="col-md-6">
                            <input type="text" id="txtanyspecial" /></span>
                    </div>
                    <div class="row" style="display:none">
                        <label class="pull-left " style="font-weight: bold;">Time patient Wheeled Out&nbsp&nbsp&nbsp&nbsp&nbsp</label>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtpatientwheeled" runat="server" MaxLength="8" ToolTip="Enter Time" Width="104px" />
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtpatientwheeled" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlToValidate="txtpatientwheeled"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required" ForeColor="Red"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                        </div>
                    </div>
                    <div class="row">
                        <label class="pull-left " style="font-weight: bold">Circulating Nurse Comments</label>
                        <div class="col-md-12">
                            <input type="text" id="txtSO0CIRCULATINGNURSE" style="display:none" />
                            <input type="text" id="txtSO0CIRCULATINGNURSE_VALUE"  />
                            <select id="ddlSO0CIRCULATINGNURSE" style="display:none;"></select>
                        </div>
                    </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="row">
                        <label class="pull-left " style="font-style: italic">(Surgeon)</label>
                        <span class="col-md-4">
                            <select id="ddlsurgeon"></select></span>
                        <span class="col-md-4 pull-right">
                            <select id="ddlanesthetist"></select></span>
                        <label class="pull-right " style="font-style: italic">(Anesthetist In-Charge)</label>

                    </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <center>
                        <input type="button" id="btnsavesurgery" onclick="$SaveSurgerySafety(this)" value="Save" />
                        <input type="button" id="btnUpdate" value="update" onclick="$UpdateSurgerySafety(this)" style="display: none" />
                    </center>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Surgery Safety Check List  Result
                    </div>
                    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbl_Surgery_Safety" style="width: 100%; border-collapse: collapse;">
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
    </form>
</body>
</html>

