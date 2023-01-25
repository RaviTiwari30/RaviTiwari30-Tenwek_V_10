<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Investigation.aspx.cs" Inherits="Design_CPOE_Investigation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var transactionId = $.trim($('#lblTransactionId').text());
            var doctorid = $.trim($('#lblAppointmentDoctorID').text());
            if (doctorid == "") {
                $('#btnSave').hide();
            }
            if ($('#lblisAccordian').text() == "0") {
                $('.hideAccordian').hide();
                $('#spnVisitHeader').text('Emergency Visits');
            }
            else {
                $('.hideAccordian').show();
                $('#spnVisitHeader').text('Current & Previous Visit');
            }
            $('#divAccordionPreviousVisit').accordion({ autoHeight: false, collapsible: false, heightStyle: 'content', active: true });
            getPreviousVisit(function () { });
            loadViewData(function (data) {
                $("#accordion").accordion({ autoHeight: false, collapsible: true, heightStyle: 'content', active: false });
                bindPatientVisitDetails(data);
                createPrescriptionView(function () {
                    loadPrescriptionViews(function () {
                        $('#accordion').accordion('refresh');
                        getVitalSigns(transactionId);
                        loadFavoriteTemplate(function () { });
                    });
                });
                init();
            });
            shortcut.add('TAB', function () {
                var $accordion = $('#accordion');
                var current = $accordion.accordion("option", "active"),
                maximum = $accordion.find("h3").length,
                next = current + 1 === maximum ? 0 : current + 1;
                if (next == 12)
                    $('#ui-id-3').click();
                else
                    $accordion.accordion("option", "active", next);
            }, addShortCutOptions);
        });
        var createPrescriptionView = function (callback) {
            serverCall('../Emergency/services/PrescribeServices.asmx/loadPrescriptionView', {}, function (response) {
                var responseData = JSON.parse(response);
                $.each(responseData, function (i, e) {
                    $('#accordion').append('<h5 class="Purchaseheader" ' + (this.IsActive == 0 ? "style='display:none'" : "") + ' >' + this.AccordianName + ' </h5><div view-href=' + this.ViewUrl + '></div>');
                })
                callback();
            });
        }
        var loadPrescriptionViews = function (callback) {
            $('#accordion div').each(function () {
                $(this).load($(this).attr('view-href') + '?t=' + $.now(), function (responseTxt, statusTxt, xhr) {
                    if (statusTxt == "success")
                        $('#accordion').accordion('refresh');
                });
            });
            callback();
        }

        var isCached = false;
        var cachedData = {};
        var loadViewData = function (callback) {
            if (!isCached) {
                var transactionID = $.trim($('#lblTransactionId').text());
                var appointmentID = $.trim($('#lblApp_ID').text());
          
                getPreviousVisitDetails(transactionID, appointmentID, 2, function (response) {
                    var responseData = response;
                    isCached = true;
                    cachedData = responseData;
                    callback(cachedData);
                });
            }
            else
                callback(cachedData);
        }


        var getVitalSigns = function (transactionID) {
            serverCall('../Emergency/services/PrescribeServices.asmx/GetVitalDetails', { transactionID: transactionID }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0) {
                        $('.classDivVitalPreview').show();
                        var divVitalPreview = $('#divVitalPreview');

                        if (!String.isNullOrEmpty(responseData[0].Temp) && responseData[0].Temp != '0')
                            divVitalPreview.find('#lblVitalPreviewTemp').html(' ' + responseData[0].Temp + ' &deg;C').closest('li').show();
                        if (!String.isNullOrEmpty(responseData[0].Pulse) && responseData[0].Pulse != '0')
                            divVitalPreview.find('#lblVitalPreviewPulse').text(responseData[0].Pulse + ' p-m').closest('li').show();
                        if (!String.isNullOrEmpty(responseData[0].BP) && responseData[0].BP != '0')
                            divVitalPreview.find('#lblVitalPreviewBp').text(responseData[0].BP + ' mm/Hg').closest('li').show();
                        if (!String.isNullOrEmpty(responseData[0].r) && responseData[0].r != '0')
                            divVitalPreview.find('#lblVitalPreviewResp').text(responseData[0].r + ' BPM').closest('li').show();
                        if (!String.isNullOrEmpty(responseData[0].SPO2) && responseData[0].SPO2 != '0')
                            divVitalPreview.find('#lblVitalPreviewSPO2').text(responseData[0].SPO2).closest('li').show();
                        if (!String.isNullOrEmpty(responseData[0].HT) && responseData[0].HT != '0')
                            divVitalPreview.find('#lblVitalPreviewHeight').text(responseData[0].HT + ' CM').closest('li').show();
                        if (!String.isNullOrEmpty(responseData[0].WT) && responseData[0].WT != '0')
                            divVitalPreview.find('#lblVitalPreviewWeight').text(responseData[0].WT + ' Kg').closest('li').show();
                        if (!String.isNullOrEmpty(responseData[0].RBS) && responseData[0].RBS != '0')
                            divVitalPreview.find('#lblRBS').text(responseData[0].RBS.replace('mmol','') + ' mmol/L').closest('li').show();
                            //lblRBS
                    }
                }
            });
        }
        function prinprescription() {
            var transactionID = $.trim($('#lblTransactionId').text());
            var patientID = $.trim($('#lblPatientID').text());
            window.open("../CPOE/OPDPrescriptionPrintOut.aspx?TID=" + transactionID + "&PID=" + patientID + "");
        }
    </script>


    <style type="text/css">
        .ui-accordion .ui-accordion-content {
            padding: 0px;
            overflow: hidden;
        }

        /*Increase Header Size*/
        .ui-accordion .ui-accordion-header {
            padding: 0px;
            padding-left: 27px;
            font-size: 12px;
        }

        .ui-all {
            display: inline-block;
        }

        .chkList-Control {
            width: 100%;
            height: 100px;
            overflow: auto;
            cursor: pointer;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
            -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        }

        .selectedPreItem {
            color: blue !important;
            cursor: pointer;
        }

        .prescribedItem:hover {
            color: blue !important;
            cursor: pointer;
        }

        .selectedMedicine {
            background: #fee188 !important;
        }

        .trimList {
            max-width: 99% !important;
            overflow: hidden !important;
            text-overflow: ellipsis !important;
            white-space: nowrap !important;
            cursor: pointer;
        }



        .ui-menu-item {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 12px;
        }


        .selectedVisit {
            background: aquamarine !important;
        }

        .prescriptionHeader {
            font-size: 12px;
        }
    </style>
</head>
<body style="margin-right: 2px;">
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory_folder" style="border: none">
            <div class="row">
                <div runat="server" id="divPrescriptionAccordionList" style="padding: 0px" class="col-md-7">
                    <div class="row">
                        <div style="padding: 0px" class="col-md-24">
                            <div id="accordion" class="hideAccordian">
                            </div>
                        </div>
                    </div>
                    <div class="row hideAccordian">
                        <div style="text-align: center" class="col-md-24">
                            <div class="row">
                                <input type="button" onclick="openTemplateCreateModel({ isNew: true, templateFor: 1 }, function (model) { });" value="New Template" />
                                <input type="button" id="btnbSave" runat="server" value="Save" onclick="savePrescription()" />
                                <input class="save" type="button" id="btnPrintPreview" value="Print" onclick="print()" />
                                <img style="cursor: pointer; height: 21px; margin-bottom: -6px; display: none" id="btnVoicePrescription" class="disablemic" src="../../Images/ico_micon.png" />
                            </div>
                            <div class="row">
                              <input class="save" type="button" id="Button1" value="Prescription" onclick="prinprescription()" />
                            </div>
                        </div>
                    </div>
                    <div class="row hideAccordian">
                        <div style="color: red" class="col-md-24">
                            <b>Notes:-</b>
                            <ul>
                                <li style="font-size: 12px; margin-left: 22px;">Double Click On Prescription Item To Remove.</li>
                                <li style="font-size: 12px; margin-left: 22px;">Single Click On Medicine Item To Select.</li>
                            </ul>
                        </div>
                    </div>
                    <div class="row">
                        <div style="padding: 0px" class="col-md-24">
                            <div id="divAccordionPreviousVisit">
                                <h5 class="Purchaseheader"><span id="spnVisitHeader"></span></h5>
                                <div>
                                    <div style="padding: 0px; margin: 0px" class="row">
                                        <div style="padding-bottom: 5px" class="col-md-24">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>
                <div id="divPrintPreview" runat="server" style="padding: 0px" class="col-md-17 subpage">
                    <div class="POuter_Box_Inventory_folder">
                        <div class="row prescriptionHeader">
                            <div class="col-md-5">
                                <label class="pull-left"><b>Patient Name</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label id="lblPreviewPatientName"></label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"><b>UHID</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblPreviewPatientID"></label>
                            </div>
                        </div>
                        <div class="row prescriptionHeader">
                            <div class="col-md-5">
                                <label class="pull-left"><b>DOB/Age/Sex</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label id="lblPreviewAgeSex"></label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"><b>Visit On</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblAppDate"></label>
                            </div>
                        </div>
                        <div class="row prescriptionHeader">

                            <div class="col-md-5">
                                <label class="pull-left"><b>Doctor</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label id="lblPreviewDoctorName"></label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"><b>Visit Type</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblVisitType"></label>

                            </div>


                        </div>
                        <div class="row prescriptionHeader">


                            <div class="col-md-5">
                                <label class="pull-left"><b>Panel</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label id="lblPreviewPanel"></label>

                            </div>


                            <div class="col-md-4">
                                <label class="pull-left"><b>Mobile No.</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblMobileNo"></label>
                            </div>



                        </div>

                    </div>
                    <div style="margin-top: -2px;" class="POuter_Box_Inventory_folder">
                        <div class="row">
                            <div style="margin-top: -5px; margin-bottom: -5px; border-right: solid 1px #303e54; min-height: 900px;" class="col-md-7">

                                <div class="row col-md-24">
                                    <label style="margin-left: -20px; display: none" class="pull-left classDivVitalPreview"><b>Vital Sign</b></label>
                                    <b style="display: none" class="pull-left classDivVitalPreview">:-</b>
                                </div>
                                <div style="display: none" id="divVitalPreview" class="row col-md-24 classDivVitalPreview">
                                    <ul>

                                        <li id="lilblVitalPreviewWeight" style="list-style: none; display: none; font-size: 9px; font-weight: bold;">
                                            <div class="col-md-10">Weight</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewWeight"></label>
                                            </div>
                                        </li>

                                        <li id="lilblVitalPreviewTemp" style="list-style: none; display: none; font-size: 9px; font-weight: bold;">
                                            <div class="col-md-10">Temperature</div>
                                            <div class="col-md-14">:<label id="lblVitalPreviewTemp"></label></div>
                                        </li>
                                        <li id="lilblVitalPreviewPulse" style="list-style: none; font-size: 9px; display: none; font-weight: bold;">
                                            <div class="col-md-10">Pulse</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewPulse"></label>
                                            </div>
                                        </li>
                                        <li id="lilblVitalPreviewBp" style="list-style: none; display: none; font-size: 9px; font-weight: bold;">
                                            <div class="col-md-10">B/P</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewBp"></label>
                                            </div>
                                        </li>
                                        <li id="lilblVitalPreviewResp" style="list-style: none; font-size: 9px; display: none; font-weight: bold;">
                                            <div class="col-md-10">Resp</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewResp"></label>
                                            </div>
                                        </li>
                                        <li id="lilblVitalPreviewSPO2" style="list-style: none; display: none; font-size: 9px; font-weight: bold;">
                                            <div class="col-md-10">SPO2</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewSPO2"></label>
                                            </div>
                                        </li>
                                        <li id="lilblVitalPreviewHeight" style="list-style: none; font-size: 9px; display: none; font-weight: bold;">
                                            <div class="col-md-10">Height</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewHeight"></label>
                                            </div>
                                        </li>
                                        <li id="liRBS" style="list-style: none; font-size: 9px; display: none; font-weight: bold;">
                                            <div class="col-md-10">RBS</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblRBS"></label>
                                            </div>
                                        </li>

                                    </ul>
                                </div>
                                <div style="margin-top: 10px" class="row col-md-24">
                                    <label style="margin-left: -20px; display: none" class="pull-left lblDivInvestigationPreview"><b>Investigation</b></label>
                                    <b style="display: none" class="pull-left lblDivInvestigationPreview">:-</b>
                                </div>
                                <div style="padding: 0px; margin: 0px;" id="divInvestigationPreview" class="row col-md-24">
                                    <ul>
                                    </ul>
                                </div>
                                <div class="row col-md-24">
                                    <label style="margin-left: -20px; display: none" class="pull-left lblDivProcedurePreview"><b>Procedure</b></label>
                                    <b style="display: none" class="pull-left lblDivProcedurePreview">:-</b>
                                </div>
                                <div style="padding: 0px; margin: 0px;" id="divProcedurePreview" class="row col-md-24">
                                    <ul>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-md-17">

                                <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div  class="prescribedItem" id="divChiefComplaintPrintPreview">
                                    </div>
                                </div>
                                <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divClinicalExaminationPrintPreview">
                                    </div>
                                </div>

                                <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divVaccinationStatusPrintPreview">
                                    </div>
                                </div>

                                <div class="row col-md-24">
                                    <label style="margin-left: -13px; display: none" class="pull-left lblDivPrescribeMedicinePreview"><b>R<sub>x</sub></b></label>
                                    <b class="pull-left"></b>
                                </div>
                                <div id="divPrescribeMedicinePreview" style="padding: 0px; margin: 0px; display: none" class="row col-md-24 lblDivPrescribeMedicinePreview">
                                    <table id="tblPrescribeMedicinePreview" style="font-size: 9px; border: 1px; table-layout: fixed; width: 100%;" rules="all">
                                        <thead>
                                            <tr>
                                                <th style="width: 18px">Sr</th>
                                                <th style="width: 190px;">Name</th>
                                                <th>Dose</th>
                                                <th>Times</th>
                                                <th>Dur.</th>
                                                <th>Meal</th>
                                                <th>Route</th>
                                                <th style="width: 25px;">Qty</th>
                                                <th>Remarks</th>
                                              <%--  <th>Drug Info</th>--%>
                                            </tr>
                                        </thead>
                                        <tbody style="text-align: center;">
                                        </tbody>
                                    </table>
                                </div>
                                <div style="padding: 0px; margin-top: 20px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divDoctorNotesPrintPreview">
                                    </div>
                                </div>
                                <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divAllergiesPreview">
                                    </div>
                                </div>
                                <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divMedicationPreview">
                                    </div>
                                </div>
                                <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divProgressionComplaint">
                                    </div>
                                </div>

                                <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divProvisionalDiagnosis">
                                    </div>
                                </div>
                                
                                 <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divDoctorAdvicePrintPreview">
                                    </div>
                                </div>

                                 <div style="padding: 0px; margin-bottom: 20px; margin-left: 0px" class="row col-md-24">
                                    <div class="prescribedItem"  id="divConfidentialDataPreview">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblApp_ID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblTransactionId" Style="display: none"></asp:Label>
         <asp:Label ClientIDMode="Static" runat="server" ID="lblTransactionIdPre" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblPatientID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblLedgerTransactionID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblAppointmentDoctorID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblisAccordian" Style="display: none"></asp:Label>
        <div id="divCreateNewTemplateModel" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="background-color: white; width: 65%;">
                    <div class="modal-header">
                        <button type="button" class="close" onclick="closeTemplateCreateModel()" aria-hidden="true">×</button>
                        <h4 class="modal-title">Create   Template</h4>
                    </div>
                    <div style="min-height: 200px;" class="modal-body">
                        <div id="divTemplateFor" class="row ">
                            <div class="col-md-8">
                                <label class="pull-left">Template For   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <select onchange="onTemplateForChange(this)" id="ddlTemplateFor">
                                    <option value="1">Chief Complaint</option>
                                    <option value="2">Doctor Notes</option>
                                    <option value="3">Sign & Symptoms</option>
                                    <option value="4">Vaccination Status</option>
                                    <option value="5">Doctor Advice</option>
                                    <%-- <option value="5">Follow-Up</option>--%>
                                    <%-- <option value="6">Laboratory & Radiology</option>--%>
                                    <option value="7">Medicine</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-8">
                                <label class="pull-left">Template Name   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <input type="text" template-id="" autocomplete="off" id="txtTemplateName" />
                            </div>
                        </div>
                        <div class="row divTextTemplate">
                            <div class="col-md-8">
                                <label class="pull-left">Template    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <textarea style="height: 100px" id="txtTemplateValue" onkeyup="onCreateTemplateModelValueChange(event)"></textarea>
                            </div>
                        </div>
                        <div style="display: none" class="row divMedicineTemplate">
                            <div class="col-md-8">
                                <label class="pull-left">Select Medicine    </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <input type="text" id="txtMedicineItemSetCreate" />
                            </div>
                        </div>
                        <div style="display: none;" class="row divMedicineTemplate">
                            <div class="col-md-24">
                                <table id="tblMedicineSetMaster" cellspacing="0" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle">Sr</th>
                                            <th class="GridViewHeaderStyle">Name</th>
                                            <th style="width: 55px" class="GridViewHeaderStyle">Dose</th>
                                            <th style="width: 90px;" class="GridViewHeaderStyle">Times</th>
                                            <th style="width: 90px;" class="GridViewHeaderStyle">Duration</th>
                                            <th style="width: 100px;" class="GridViewHeaderStyle">Meal</th>
                                            <th style="width: 150px;" class="GridViewHeaderStyle">Route</th>
                                            <th style="width: 55px; display: none" class="GridViewHeaderStyle">Qty</th>
                                            <th style="width: 55px" class="GridViewHeaderStyle">Remove</th>
                                        </tr>
                                    </thead>
                                    <tbody style="text-align: center;">
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" id="btnprescriptionDefaultValue" style="display: none" class="divMedicineTemplate" onclick="setMedicinePrescriptionDefaultValue(this)">Set Prescription Default Value </button>
                        <button type="button" id="btnAction" onclick="onSaveTextTemplate(this)">Save</button>
                        <button type="button" onclick="closeTemplateCreateModel()">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        var getPatientInvestigationDetails = function (callback) {
            var patientID = $.trim($('#lblPatientID').text());
            var transactionID = $.trim($('#lblTransactionId').text());
            var App_ID = $.trim($('#lblApp_ID').text());
            var ledgerTransactionID = $.trim($('#lblLedgerTransactionID').text());
            var data = [];
            $('#divInvestigationPreview ul li').each(function () {
                data.push({
                    Test_ID: this.id.replace('value=', ''),
                    name: $.trim($(this).attr('data-name')),
                    PatientID: patientID,
                    TransactionID: transactionID,
                    LedgerTransactionNo: ledgerTransactionID,
                    Remarks: $(this).find('div').text().split(':')[1] ? $(this).find('div').text().split(':')[1] : '',
                    Quantity: Number($(this).attr('data-quantity')),
                    Outsource: Number($(this).attr('data-isOutSource')),
                    IsPackage: Number($(this).attr('data-IsPackage'))
                })
            })
            callback(data);
        }

        var getPatientProcedureDetails = function (callback) {
            var patientID = $.trim($('#lblPatientID').text());
            var transactionID = $.trim($('#lblTransactionId').text());
            var ledgerTransactionID = $.trim($('#lblLedgerTransactionID').text());
            var data = [];
            $('#divProcedurePreview ul li').each(function () {
                data.push({
                    Test_ID: this.id.replace('value=', ''),
                    name: $.trim($(this).attr('data-name')),
                    PatientID: patientID,
                    TransactionID: transactionID,
                    LedgerTransactionNo: ledgerTransactionID,
                    Remarks: $(this).find('div').text().split(':')[1] ? $(this).find('div').text().split(':')[1] : '',
                    Quantity: Number($(this).attr('data-quantity'))
                })
            })
            callback(data);
        }

        var getPatientMedicineDetails = function (callback) {
            var patientID = $.trim($('#lblPatientID').text());
            var transactionID = $.trim($('#lblTransactionId').text());
            var ledgerTransactionID = $.trim($('#lblLedgerTransactionID').text());
            var data = [];
            $('#divPrescribeMedicinePreview table tbody tr').each(function () {
                data.push({
                    PatientID: patientID,
                    TransactionID: transactionID,
                    Medicine_ID: this.id,
                    MedicineName: $.trim($(this).find('#lblMedicineName').text()),
                    NoOfDays: $.trim($(this).find('#lblMedicineDuration').text()),
                    NoTimesDay: $.trim($(this).find('#lblMedicineTimes').text()),
                    Quantity: $.trim($(this).find('#lblMedicineQuantity').text()),
                    Dose: $.trim($(this).find('#lblMedicineDose').text()),
                    Meal: $.trim($(this).find('#lblMedicineMeal').text()),
                    route: $.trim($(this).find('#lblMedicineRoute').text()),
                    LedgerTransactionNo: ledgerTransactionID,
                    Remarks: $.trim($(this).find('#lblMedicineRemarks').text()),
                    isDischarge: $.trim($(this).find('#lblDischarge').text()),
                    Dept: $.trim($(this).find('#lblDept').text()),
                })
            })
            callback(data);
        }

        var getDoctorNotesDetails = function (callback) {
            var divDoctorNotesPrintPreview = $('#divDoctorNotesPrintPreview').find('span').html();
            var templateName = $.trim($('#txtDoctorNoteTemplateName').val());
            callback(divDoctorNotesPrintPreview);

        }

        var getVaccinationStatusDetails = function (callback) {
            var divVaccinationStatusPrintPreview = $('#divVaccinationStatusPrintPreview').find('span').html();
            var templateName = $.trim($('#txtVaccinationStatusTemplateName').val());
            callback(divVaccinationStatusPrintPreview);
        }


        var getClinicalExaminationDetails = function (callback) {
            var divClinicalExaminationPrintPreview = $('#divClinicalExaminationPrintPreview').find('span').html();
            var templateName = $.trim($('#txtClinicalExaminiationTemplateName').val());
            callback(divClinicalExaminationPrintPreview);
        }

        var getChiefComplaintDetails = function (callback) {
            var divChiefComplaintPrintPreview = $('#divChiefComplaintPrintPreview').find('span').html();
            var templateName = $.trim($('#txtCheifComplaintTemplateName').val());
            callback(divChiefComplaintPrintPreview);
        }

        var getAllergiesDetails = function (callback) {
            var divAllergiesPreviewText = $('#divAllergiesPreview').find('span').html();
            callback(divAllergiesPreviewText);
			        }

        var getAllProvisionDiagnosis = function (callback) {
            var divProvisionalDiagnosisText = $('#divProvisionalDiagnosis').find('span').html();
            callback(divProvisionalDiagnosisText);
        }

        var getMedicationDetails = function (callback) {
            var divMedicationPreviewText = $('#divMedicationPreview').find('span').html();
            callback(divMedicationPreviewText);
        }

        var getProgressionComplaintDetails = function (callback) {
            var divProgressionComplaintText = $('#divProgressionComplaint').find('span').html();
            callback(divProgressionComplaintText);
        }

       
        var getDoctorAdviceDetails = function (callback) {
            var divDoctorAdvicePrintPreview = $('#divDoctorAdvicePrintPreview').find('span').html();
            callback(divDoctorAdvicePrintPreview);

        }
        var getConfidentialData = function (callback) {
            var divConfidentialDataPreviewText = $('#divConfidentialDataPreview').find('span').html();
            callback(divConfidentialDataPreviewText);
        }

        var getMolecularAllergies = function (callback) {
            var molecularAllergies = [];
            $('#divMolecularList ul li').each(function () {
                molecularAllergies.push({
                    molecularID: this.id,
                    molecularName: $(this).find('span').text()
                });
            });
            callback(molecularAllergies);
        }



        var savePrescription = function () {
            var App_ID = $.trim($('#lblApp_ID').text());
            var transactionID = $.trim($('#lblTransactionId').text());
            var patientID = $.trim($('#lblPatientID').text());
            var doctorID = $.trim($('#lblAppointmentDoctorID').text());
            var ledgerTransactionNo = $.trim($('#lblLedgerTransactionID').text());
            getPatientInvestigationDetails(function (investigations) {
                getPatientProcedureDetails(function (procedures) {
                    getPatientMedicineDetails(function (medicines) {
                        getChiefComplaintDetails(function (ChiefComplaint) {
                            getDoctorNotesDetails(function (DoctorNotes) {
                                getVaccinationStatusDetails(function (VaccinationStatus) {
                                    getClinicalExaminationDetails(function (ClinicalExamination) {
                                        getAllergiesDetails(function (allergiesDetails) {
                                            getMedicationDetails(function (medicationDetails) {
                                                getProgressionComplaintDetails(function (progressionComplaintDetails) {
                                                    getMolecularAllergies(function (molecularAllergies) {
                                                        getAllProvisionDiagnosis(function (provisionalDiagnosis) {
                                                            getDoctorAdviceDetails(function (DoctorAdvice) {
                                                                getConfidentialData(function (ConfidentialData) {
                                                                    var data = {
                                                                        investigations: investigations,
                                                                        medicines: medicines,
                                                                        procedures: procedures,
                                                                        chiefComplaint: ChiefComplaint,
                                                                        doctorNotes: DoctorNotes,
                                                                        clinicalExamination: ClinicalExamination,
                                                                        transactionID: transactionID,
                                                                        App_ID: App_ID,
                                                                        patientID: patientID,
                                                                        appointmentDoctorID: doctorID,
                                                                        vaccinationStatus: VaccinationStatus,
                                                                        allergies: allergiesDetails,
                                                                        medications: medicationDetails,
                                                                        progressionComplaint: progressionComplaintDetails,
                                                                        molecularAllergies: molecularAllergies,
                                                                        ledgerTransactionNo: ledgerTransactionNo,
                                                                        provisionalDiagnosis: provisionalDiagnosis,
                                                                        doctorAdvice: DoctorAdvice,
                                                                        confidentialData: ConfidentialData,
                                                                    };
                                                                    serverCall('../Emergency/services/PrescribeServices.asmx/savePrescription', data, function (response) {
                                                                        var responseData = JSON.parse(response);
                                                                        if (responseData.status) {
                                                                            $('#lblApp_ID').text(responseData.appointmentID);
                                                                            loadFavoriteTemplate(function () { });
                                                                            disabledPrint(false);
                                                                            modelConfirmation('Print Confirmation ?', 'Do you want to print', 'Yes Print', 'Close', function (response) {
                                                                                if (response)
                                                                                    print();
                                                                            });
                                                                        }
                                                                        else
                                                                            modelAlert(responseData.response);
                                                                    });
                                                                });
                                                            });
                                                        });
                                                    });
                                                });
                                            });
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        }

        var disabledPrint = function (status) {
            $('#btnPrintPreview').prop('disabled', status);
        }

        var loadFavoriteTemplate = function () {
            try {
                var doctorID = $.trim($('#lblAppointmentDoctorID').text());
                serverCall('../Emergency/services/PrescribeServices.asmx/GetFavoriteTemplates', { doctorID: doctorID }, function (response) {
                    var responseData = JSON.parse(response);
                    addFavoriteChiefComplaintList(responseData.chiefComplaintTemplates, function () { });
                    addFavoriteClinicalExaminationList(responseData.clinicalExaminationTemplates, function () { });
                    addFavoriteDoctorsNoteList(responseData.doctorsNotesTemplates, function () { });
                    addFavoriteVaccinationStatusList(responseData.vaccinationStatusTemplates, function () { });
                    addFavoriteMedicineList(responseData.medicinesTemplates, function () { });
                    addFavoriteDoctorAdviceList(responseData.doctorAdviceTemplates, function () { });
                });
            } catch (e) {

            }
        }
        var init = function () {
            $('#divProcedurePreview ul').bind('DOMSubtreeModified', function () {
                if ($(this).find('li').length <= 0)
                    $('.lblDivProcedurePreview').hide();
                else
                    $('.lblDivProcedurePreview').show();

            });
            $('#divInvestigationPreview ul').bind('DOMSubtreeModified', function () {
                if ($(this).find('li').length <= 0)
                    $('.lblDivInvestigationPreview').hide();
                else
                    $('.lblDivInvestigationPreview').show();
            });
        }

        var print = function () {
            var h = screen.height;
            var w = screen.width;
            printWindow = window.open('../Emergency/PrescriptionView/Print.html', "PrintWindow", "width=" + w + ",height=" + h);
            printWindow.onload = function () {
                printWindow.document.getElementById('printPreview').innerHTML = $('#divPrintPreview').html();
            };
        }
    </script>
    <script id="scrTemplateCreate">
        var openTemplateCreateModel = function (option, callback) {
            var createNewTemplatemodel = $('#divCreateNewTemplateModel');
            var ddlTemplateFor = createNewTemplatemodel.find('#ddlTemplateFor').val(option.templateFor).change();
            var headerText = $(ddlTemplateFor).find('option:selected').text();
            var actionButtonText = 'Save Template';
            if (option.isNew) {
                ddlTemplateFor.prop('disabled', false);
                headerText = 'Create New  Template';
            }
            else {
                ddlTemplateFor.prop('disabled', true);
                actionButtonText = 'Update Template';
                headerText = 'Update Template';

            }
            createNewTemplatemodel.find('.modal-header .modal-title').text(headerText);
            createNewTemplatemodel.find('#btnAction').text(actionButtonText);
            createNewTemplatemodel.showModel();

            callback(createNewTemplatemodel);
        }

        var closeTemplateCreateModel = function () {
            var createNewTemplatemodel = $('#divCreateNewTemplateModel');
            createNewTemplatemodel.find('input[type=text],textarea').val('');
            createNewTemplatemodel.closeModel();
            clearTemplateModel(function () { });
        }

        var onCreateTemplateModelValueChange = function (e) {
            var txtTemplateName = $('#divCreateNewTemplateModel #txtTemplateName');
            txtTemplateName.val(e.target.value);
        }


        var onEditTemplate = function (elem) {
            selectedTemplateDetails(elem, function (data) {
                openTemplateCreateModel({ isNew: false, templateFor: data.templateFor }, function (model) {
                    model.find('#txtTemplateValue').val(data.valueField);
                    model.find('#txtTemplateName').val(data.templateName).attr('template-id', data.id);
                    if (data.templateFor == 7)
                        bindMedicineSetItems(elem);
                });
            });
        }

        var selectedTemplateDetails = function (elem, callback) {
            var template = $(elem).closest('li');
            var data = {
                templateName: $.trim(template.find('input[type=checkbox]').attr('templateName')),
                id: $.trim(template.find('input[type=checkbox]').attr('id')),
                valueField: $.trim(template.find('input[type=checkbox]').val()),
                templateFor: Number($.trim(template.find('input[type=checkbox]').attr('templateFor'))),
            }
            callback(data);
        }


        var bindMedicineSetItems = function (elem, callback) {
            var data = JSON.parse(decodeURIComponent($(elem).closest('li').find('input[type=checkbox]').val()));
            $(data).each(function () {
                this.Brand = this.name;
                this.val = this.itemID;
                addMedicineSetItem(this, true);
            });
        }



        var getTemplateDetails = function (callback) {
            var createNewTemplatemodel = $('#divCreateNewTemplateModel');
            var data = {
                id: $.trim(createNewTemplatemodel.find('#txtTemplateName').attr('template-id')),
                valueField: $.trim(decodeURIComponent(createNewTemplatemodel.find('#txtTemplateValue').val())),
                templateName: $.trim(createNewTemplatemodel.find('#txtTemplateName').val()),
                doctorID: $.trim($('#lblAppointmentDoctorID').text()),
                templateFor: Number(createNewTemplatemodel.find('#ddlTemplateFor').val())
            }
            callback({ data: data });
        }


        var getMedicineTemplateDetails = function (callback) {
            var medicines = [];
            $('#tblMedicineSetMaster tbody tr').each(function () {
                var data = {
                    ItemID: $.trim($(this).find('#lblMedicineItemID').text()),
                    Quantity: Number($.trim($(this).find('#txtQuantity').val())),
                    Dose: $.trim($(this).find('#txtDose').val()),
                    Route: $.trim($(this).find('#txtRoute').val()),
                    Meal: $.trim($(this).find('#ddlMeal').val()),
                    Time: $.trim($(this).find('#txtTimes').val()),
                    Duration: $.trim($(this).find('#txtDays').val()),
                }
                medicines.push(data);
            });
            if (medicines.length < 1) {
                modelAlert('Please Select Medicine');
                return false;
            }
            callback(medicines);
        }



        var saveTextTemplate = function (data, elem) {
            serverCall('../Emergency/services/PrescribeServices.asmx/SaveTemplate', { data: data.data }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function (status) {
                    if (responseData.status) {
                        loadFavoriteTemplate();
                        clearCreateTemplateModel();
                    }
                });
            });
        }


        var saveMedicineTemplate = function (data, elem) {
            if (String.isNullOrEmpty(data.data.templateName)) {
                modelAlert('Please Enter Template  Name')
                return false;
            }
            getMedicineTemplateDetails(function (medicines) {
                data.data.medicines = medicines;
                serverCall('../Emergency/services/PrescribeServices.asmx/SaveMedicineTemplate', { data: data.data }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function (status) {
                        if (responseData.status) {
                            loadFavoriteTemplate();
                            clearCreateTemplateModel();
                        }
                    });
                });
            });
        }

        var setMedicinePrescriptionDefaultValue = function () {
            getMedicineTemplateDetails(function (medicines) {
                serverCall('../Emergency/services/PrescribeServices.asmx/AddMedicinePrescriptionDefaultValue', { data: medicines }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function (status) {
                        if (responseData.status) {
                            clearCreateTemplateModel();
                        }
                    });
                });
            });
        }


        var updateTextTemplate = function (data, elem) {
            serverCall('../Emergency/services/PrescribeServices.asmx/UpdateTemplate', { data: data.data }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    loadFavoriteTemplate();
                    closeTemplateCreateModel();
                }
                else
                    modelAlert(responseData.response);
            });
        }


        var clearCreateTemplateModel = function () {
            $('#divCreateNewTemplateModel input[type=text],textarea').val('');
            $('#divCreateNewTemplateModel #tblMedicineSetMaster tbody tr').remove();
        }

        var onSaveTextTemplate = function (elem) {
            getTemplateDetails(function (data) {
                if (data.data.templateFor == 7)
                    saveMedicineTemplate(data, elem);
                else {
                    if (String.isNullOrEmpty(data.data.id))
                        saveTextTemplate(data, elem);
                    else
                        updateTextTemplate(data, elem);
                }
            });
        }

        var onDeleteTemplate = function (elem) {
            modelConfirmation('Delete Confirmation ?', 'Are You Sure To Delete', 'Yes Delete', 'Cancel', function (status) {
                if (!status)
                    return false;

                selectedTemplateDetails(elem, function (data) {
                    serverCall('../Emergency/services/PrescribeServices.asmx/DeleteTemplate', { templateID: data.id, templateFor: data.templateFor }, function (response) {
                        var responseData = JSON.parse(response);
                        if (!responseData.status)
                            modelAlert(responseData.response, function (status) { });
                        else
                            $(elem).closest('li').remove();
                    });
                });
            });
        }



        var onTemplateForChange = function (elem) {
            var value = elem.value;
            if (value == 7) {
                initMedicineSetMasterSearch(function () { });
                $('.divTextTemplate').hide();
                $('.divMedicineTemplate').show()
                $('#divCreateNewTemplateModel').find('#txtTemplateName').addClass('required');
            }
            else {
                $('.divMedicineTemplate').hide();
                $('.divTextTemplate').show();
            }

        }



        var initMedicineSetMasterSearch = function (callback) {
            var txtMedicineSearch = $('#txtMedicineItemSetCreate');
            $(txtMedicineSearch).autocomplete({
                source: function (request, response) {
                    getMedicines(request.term, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    addMedicineSetItem(i.item, false);
                    e.target.value = '';
                },
                close: function (el) {
                    el.target.value = '';
                },
                open: function () {
                    txtMedicineSearch.autocomplete('widget').css(
                        { 'overflow-y': 'auto', 'max-height': '250px', 'width': 'auto', 'overflow-x': 'hidden' });
                },
                minLength: 0
            });
        }

        var addMedicineSetItem = function (item, isEdit) {
            var table = $('#tblMedicineSetMaster tbody');
            var isExits = table.find('#' + $.trim(item.val));
            if (isExits.length > 0) {
                modelAlert('Item Already Exits !', function () {
                    $('#divCreateNewTemplateModel #txtMedicineItemSetCreate').val('').focus();
                });
                return false;
            }
            var times = '<input type="text" id="txtTimes" />';
            var duration = '<input type="text" id="txtDays" />';
            var meal = '<select id="ddlMeal"></select>';
            var route = '<input type="text" id="txtRoute" />';
            var quantity = '<input type="text" id="txtQuantity" value="' + (isEdit ? item.quantity : 1) + '"  onlynumber="2" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)">';
            var tr = '<tr id="' + $.trim(item.val) + '">';
            tr += '<td class="GridViewLabItemStyle">' + (table.find('tr').length + 1) + '</td>';
            tr += '<td class="GridViewLabItemStyle" style="word-wrap:break-word;text-align: left;"><span id="lblMedicineName">' + item.Brand + '</span><span style="display:none" id="lblMedicineItemID">' + item.val + '</span> </td>';
            tr += '<td class="GridViewLabItemStyle"><input autocomplete="off" type="text" value="' + (isEdit ? item.dose : '') + '" id="txtDose"></td>';
            tr += '<td class="GridViewLabItemStyle">' + times + '</td>';
            tr += '<td class="GridViewLabItemStyle">' + duration + '</td>';
            tr += '<td class="GridViewLabItemStyle">' + meal + '</td>';
            tr += '<td class="GridViewLabItemStyle" style="width:50px;word-wrap:break-word;">' + route + '</td>';
            tr += '<td style="display:none" class="GridViewLabItemStyle">' + quantity + '</td>';
            tr += "<td class='GridViewLabItemStyle'><img class='btn' style='cursor:pointer'  src='../../Images/Delete.gif' onclick='onMedicineSetItemRemove(this);'></td>";
            tr += '</tr>';
            table.append(tr);
            var lastTr = $(table.find('tr').last());
            getMedicineDoses(2, function (response) {
                var ddlTimesData = response;
                var txtTimes = lastTr.find('#txtTimes').autocomplete({
                    source: function (request, response) { filteredAutoComplete(ddlTimesData, request, function (filtered) { response(filtered); }); }, open: function (e) { $(this).autocomplete('widget').css({ 'width': 'auto' }); }
                });
                getMedicineDoses(3, function (response) {
                    var ddlDaysData = response;
                    var txtDays = lastTr.find('#txtDays').autocomplete({ source: function (request, response) { filteredAutoComplete(ddlDaysData, request, function (filtered) { response(filtered); }); } });
                    getMedicineDoses(4, function (response) {
                        var ddlRouteData = response;
                        var txtRoute = lastTr.find('#txtRoute').autocomplete({ source: function (request, response) { filteredAutoComplete(ddlRouteData, request, function (filtered) { response(filtered); }); } });
                        getMedicineDoses(1, function (response) {
                            var ddlDoseData = response;
                            var txtDose = lastTr.find('#txtDose').autocomplete({ source: function (request, response) { filteredAutoComplete(ddlDoseData, request, function (filtered) { response(filtered); }); } });
                            lastTr.find('#ddlMeal').bindDropDown({ data: ['', 'After Meal', 'Before Meal'] });
                            txtTimes.val(item.Times);
                            txtDays.find('#txtDays').val(item.Duration);
                            $(lastTr).find('#txtMeal').val(item.meal);
                            txtRoute.find('#txtRoute').val(item.route);
                        });
                    });
                });
            });
        }
        var onMedicineSetItemRemove = function (elem) {
            $(elem).closest('tr').remove();
        }

        var clearTemplateModel = function (callback) {
            var divCreateNewTemplateModel = $('#divCreateNewTemplateModel');
            divCreateNewTemplateModel.find('input[type=text],textarea').val('');
            $('#tblMedicineSetMaster tbody tr').remove();
            callback();
        }


        var getMedicines = function (prefix, callback) {
            serverCall('../Emergency/services/PrescribeServices.asmx/medicineItemSearch', { prefix: prefix }, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.Typename,
                        val: item.ItemID,
                        ItemCode: item.ItemCode,
                        Typename: item.Typename,
                        MedicineType: item.MedicineType,
                        Dose: item.Dose,
                        Generic: item.Generic,
                        Brand: item.Brand,
                        Dose: item.Dose,
                        Route: item.Route,
                        Duration: item.Duration,
                        Times: item.Times
                    }
                });

                callback(responseData);
            })
        }

        var getMedicineDoses = function (type, callback) {
            serverCall('../Emergency/services/PrescribeServices.asmx/GetMedicineDoses', { type: type }, function (response) {
                callback(JSON.parse(response))
            });
        };

        var filteredAutoComplete = function (data, request, callback) {
            debugger;
            var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
            var matching = $.grep(data, function (value) {
                return matcher.test(value.Text);
            });
            var filtered = [];
            $(matching).each(function () {
                filtered.push({ label: this.Text, val: this.Text })
            });
            callback(filtered.slice(0, 5));
        }

        var getPreviousVisit = function (callback) {
            var data = {
                transactionID: $.trim($('#lblTransactionId').text()),
                patientID: $.trim($('#lblPatientID').text()),
                appointmentID: $.trim($('#lblApp_ID').text()),
                IsIPDData: Number(2) //($.trim($('#lblIsIPDData').text()))
            }
            serverCall('../Emergency/services/PrescribeServices.asmx/GetPreviousVisit', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var divAccordionPreviousVisit = $('#divAccordionPreviousVisit .row .col-md-24');
                    var type = "";
                    $(responseData).each(function () {
                        if (this.Isipd == 1) {
                            type = '(IPD)';
                        }
                        else if (this.Isipd == 0) {
                            type = '(OPD)';
                        }
                        else if (this.Isipd == 2) {
                            type = '(EMG)';
                        }

                        var visitText = type + 'On ' + this.DateVisit + '/' + this.DName;
                        if (this.CurrentVisit)
                            visitText = "Current Visit"

                        var visit = '<div class="ui-accordion-header ui-state-default ui-accordion-icons ui-accordion-header-active ui-state-active ui-corner-top row ' + (this.CurrentVisit == 1 ? 'selectedVisit' : '') + '" style="font-size: 12px;padding-left: 5px;text-align: left;"><div onclick="loadPreviousVisitDetails(this,function(){});"  dateVisit="' + this.DateVisit + '"  doctorName="' + this.DName + '" appointmentID="' + this.App_ID + '"  doctorid="' + this.DoctorID + '" TransactionID="' + this.TransactionID + '"  IsIPDData="' + this.Isipd + '" CurrentVisit="' + this.CurrentVisit + '"  class="col-md-22" style="max-width: 98%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"  >'
                              + visitText + '</div><div class="col-md-2"> <a href="javascript:void(0);" onclick="printFromPreviousVisitLable(this)" class="icon icon-color icon-print pull-right"></a>  </div></div>';
                        divAccordionPreviousVisit.append(visit);
                    });
                    callback($('#divAccordionPreviousVisit').accordion('refresh'));
                }
            });
        }


        var clearPrescriptionPreview = function (callback) {
            $('.prescribedItem').text('');
            $('#tblPrescribeMedicinePreview tbody tr').remove();
            $('#divProcedurePreview ul li').remove();
            $('#divInvestigationPreview ul li').remove();
            callback();
        }

        var loadPreviousVisitDetails = function (elem, callback) {
            clearPrescriptionPreview(function () {
                $(elem).closest('#divAccordionPreviousVisit').find('.ui-accordion-header').removeClass('selectedVisit');
                $(elem).closest('.ui-accordion-header').addClass('selectedVisit');
                var transactionID = $(elem).closest('div').attr('TransactionID');
                var appointmentID = $(elem).closest('div').attr('appointmentID');
                var IsIPDData = $(elem).closest('div').attr('IsIPDData');
                getPreviousVisitDetails(transactionID, appointmentID, IsIPDData, function (responseData) {
                    if (IsIPDData == 2) {
                        bindPatientMedicineDetails(responseData);
                        bindPatientInvestigationDetails(responseData);
                        bindPatientProcedureDetails(responseData);
                        bindPatientChiefComplaint(responseData);
                        bindDoctorNotes(responseData);
                        bindClinicalExamination(responseData);
                        bindPatientAllergies(responseData);
                        bindPatientMedication(responseData);
                        bindPatientProgressionComplaint(responseData);
                        bindPatientVisitDetails(responseData);

                        bindVaccinationStatus(responseData);
                        bindProvisionalDiagnosis(responseData);
                        bindDoctorAdvice(responseData);
                        bindConfidentialData(responseData);
                       // BindReferralConsultation(responseData);
                        // bindPreviousAppointmentDetails(data);
                        //bindPatientHeaderDetails(responseData);
                        // checkHeaderForPrint();
                        //getVitalSigns(transactionID, AppID);

                    }
                    callback();
                });
                if (IsIPDData != 2) {
                    openWin(transactionID, appointmentID, $('#lblPatientID').text(), IsIPDData);
                }
            });
        }

        function openWin(transactionID, appointmentID, patientid, IsIPDData) {
            window.open("../../Design/CPOE/Investigation.aspx?TID=" + transactionID + "&TransactionID=" + transactionID + "&App_ID=" + appointmentID + "&PID=" + patientid + "&PatientId=" + patientid + "&IsIPDData=" + IsIPDData + "&AdmissionType=&isipdopdprint=1");
        }


        var bindPatientVisitDetails = function (data) {
            var patientDetails = data.patientDetails[0];
            $('#lblPreviewPatientName').text(patientDetails.PatientName);
            $('#lblPreviewPatientID').text(patientDetails.PatientID);
            $('#lblPreviewDoctorName').text(patientDetails.DoctorName);
            $('#lblPreviewAgeSex').text(patientDetails.Gender);
            $('#lblPreviewPanel').text(patientDetails.Company_Name);
            $('#lblAppDate').text(patientDetails.appointmentDate);
            $('#lblVisitType').text(patientDetails.VisitType);
            $('#lblMobileNo').text(patientDetails.Mobile);
            $('#lblValidTo').text(patientDetails.ValidTo);
            $('#lblBillPaidAmount').text(patientDetails.BillNo + '/Rs:' + patientDetails.Adjustment);
        }


        var getPreviousVisitDetails = function (transactionID, appointmentID, isipd, callback) {
            var patientID = $.trim($('#lblPatientID').text());
            serverCall('../Emergency/services/PrescribeServices.asmx/GetPrescription', { transactionID: $.trim(transactionID), appointmentID: appointmentID, IsIPDData: isipd, PatientID: patientID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });

        }



        var printFromPreviousVisitLable = function (elem) {
            var dataRow = $(elem).closest('div').prev();
            var data = {
                transactionID: dataRow.attr('TransactionID'),
                dateVisit: dataRow.attr('dateVisit'),
                doctorName: dataRow.attr('doctorName'),
                appointmentID: dataRow.attr('appointmentID'),
            }
            loadPreviousVisitDetails(dataRow, function () {
                printPrevious(data);
            });
        }

        var printPrevious = function (data) {
            var h = screen.height;
            var w = screen.width;
            var printWindow = window.open('../Emergency/PrescriptionView/Print.html', "PrintWindow", "width=" + w + ",height=" + h);
            printWindow.onload = function () {
                var printPreview = printWindow.document.getElementById('printPreview').innerHTML = $('#divPrintPreview').html();
               
            };
        }

    </script>



    <%--  CIMS --%>
    <div id="divshowDrugDetail" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divshowDrugDetail" onclick="$('#divshowDrugDetail').closeModel();" aria-hidden="true">X</button>
                    <b class="modal-title">Drug Detail</b>
                </div>
                <div class="modal-body">
                    <div id="divshowDrugD" style="width: 500px; height: auto">
                    </div>
                    <iframe frameborder="0" name="pagecontent" id="pagecontent" height="300" width="900" src="" scrolling="yes"></iframe>

                </div>
                <div class="modal-footer">
                    <button type="button" onclick="$('#divshowDrugDetail').closeModel();" data-dismiss="divshowDrugDetail">Close</button>

                </div>
            </div>
        </div>
    </div>


  <%--  <script src="https://sdk.prayagad.com/1.1.7/prayagadsdk-ehr-dev.js"></script>
    <script src="Script/speachPrescription.js"></script>--%>
</body>
</html>


