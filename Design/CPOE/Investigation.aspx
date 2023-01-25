<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Investigation.aspx.cs" Inherits="Design_CPOE_Investigation" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
   
<head runat="server">
    <title></title>
   
</head>
<body style="margin-right: 2px;">
      <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
      <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
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
      <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                $('#divAccordionPreviousVisit').accordion({ autoHeight: false, collapsible: false, heightStyle: 'content', active: true });

                CheckIsNoteFinder();
                getPreviousVisit(function () {
                if ($('#lblisAccordian').text() == "0") {
                    $('.hideAccordian').hide();
                }
                else {
                    $('.hideAccordian').show();
                }
              //  $('.hideAccordian').show();
                    loadViewData(function (data) {
                        $("#accordion").accordion({ autoHeight: false, collapsible: true, heightStyle: 'content', active: false });

                        bindPatientHeaderDetails(data);
                        loadPrescriptionView(function () {
                            loadView(function () {
                                $('#accordion').accordion('refresh');
                                var transactionId = $.trim($('#lblTransactionId').text());
                                var appID = $.trim($('#lblApp_ID').text());
                                getVitalSigns(transactionId, appID);
                                loadFavoriteTemplate(function () { });
                                checkHeaderForPrint();
                                if ($('#lblisAccordian').text() != "0") {
                                    $popupAllergiesAndDiagnosis(function () {
                                    });
                                }
                                setTimeout(printemr, 5000);
                            });
                        });
                        init();
                        // }
                    });
                });
                shortcut.add('RIGHT', function () {
                    var $accordion = $('#accordion');
                    var current = $accordion.accordion("option", "active"),
                    maximum = $accordion.find("h3").length,
                    next = current + 1 === maximum ? 0 : current + 1;
                    if (next == 14) {
                        $('#ui-id-3').click();
                    }
                    else {
                        $accordion.accordion("option", "active", next);
                    }
                    $(window).scrollTop($("#accordion").offset().top);
                    //$('input').next().focus();
                }, addShortCutOptions);

                shortcut.add('Alt+S', function () {
                    if ($('#divPrescriptionAccordionList').find('#btnbSave').attr('disabled') != 'disabled') {
                        savePrescription();
                    }
                }, addShortCutOptions);

                shortcut.add('Alt+P', function () {
                    print();
                }, addShortCutOptions);

            });


            function printemr() {
                if ($('#lblisipdopdprint').text() == 1) {
                    var data = {
                        appointmentID: Number($('#lblApp_ID').text()),
                        IsIPDData: $('#lblIsIPDData').text()
                    }
                    printPrevious(data);
                }
            }
            var loadPrescriptionView = function (callback) {
                var IsIPDData = Number($("#lblIsIPDData").text());
                serverCall('../CPOE/services/PrescribeServices.asmx/loadPrescriptionView', { isIPDData: IsIPDData }, function (response) {
                    var responseData = JSON.parse(response);
                    $.each(responseData, function (i, e) {
                        if (this.IsHide == 1)
                            $('#accordion').append('<h5 style="display:none;" class="Purchaseheader">' + this.AccordianName + ' </h5><div style="display:none;" view-href=' + this.ViewUrl + '></div>');
                        else
                            $('#accordion').append('<h5 class="Purchaseheader">' + this.AccordianName + ' </h5><div view-href=' + this.ViewUrl + '></div>');

                        $('#divprescriptionPreviewData').append(this.divHTML);

                    })
                    callback();
                });
            }




            var loadView = function (callback) {
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
                    var isIPDData = Number($("#lblIsIPDData").text());
                    if (transactionID == "") {
                        transactionID = $('#divAccordionPreviousVisit').closest('div').find('#loaddivpre1').attr('TransactionID');
                        $('#lblTransactionId').text(transactionID);
                        appointmentID = $('#divAccordionPreviousVisit').closest('div').find('#loaddivpre1').attr('appid');
                        $('#lblApp_ID').text(appointmentID);
                        isIPDData = $('#divAccordionPreviousVisit').closest('div').find('#loaddivpre1').attr('isipddata');
                        $("#lblIsIPDData").text(isIPDData);

                        //$('#divAccordionPreviousVisit').closest('div').closest('div').closest('.ui-accordion-header').find('.ui-accordion-header').addClass('selectedVisit');//.removeClass('selectedVisit');
                        $('#divAccordionPreviousVisit').closest('div').find('#loaddivpre1').addClass('selectedVisit');
                    }
                        serverCall('../CPOE/services/PrescribeServices.asmx/GetPrescription', { transactionID: transactionID, appointmentID: appointmentID, IsIPDData: isIPDData }, function (response) {
                            var responseData = JSON.parse(response);
                            isCached = true;
                            cachedData = responseData;
                            callback(cachedData);
                        });
                }
                else
                    callback(cachedData);
            }


            var getVitalSigns = function (transactionID, appID) {
                var divVitalPreview = $('#divVitalPreview');
                serverCall('../CPOE/services/PrescribeServices.asmx/GetVitalDetails', { transactionID: transactionID, appID: appID }, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        var responseData = JSON.parse(response);
                        divVitalPreview.find('#lblVitalPreviewTemp,#lblVitalPreviewPulse,#lblVitalPreviewBp,#lblVitalPreviewResp,#lblVitalPreviewSPO2,#lblVitalPreviewHeight,#lblVitalPreviewWeight,#lblVitalPreviewBMI,#lblVitalPreviewBSA,#lblVitalPreviewRemarks').text('');
                        if (responseData.length > 0) {
                            $('.classDivVitalPreview').show();
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
                            if (!String.isNullOrEmpty(responseData[0].BMI) && responseData[0].BMI != '0')
                                divVitalPreview.find('#lblVitalPreviewBMI').text(responseData[0].BMI).closest('li').show();
                            if (!String.isNullOrEmpty(responseData[0].BSA) && responseData[0].BSA != '0')
                                divVitalPreview.find('#lblVitalPreviewBSA').text(responseData[0].BSA).closest('li').show();
                            if (!String.isNullOrEmpty(responseData[0].Remarks) && responseData[0].Remarks != '')
                                divVitalPreview.find('#lblVitalPreviewRemarks').text(responseData[0].Remarks).closest('li').show();
                        }
                        else {
                            divVitalPreview.find('#lblVitalPreviewTemp,#lblVitalPreviewPulse,#lblVitalPreviewBp,#lblVitalPreviewResp,#lblVitalPreviewSPO2,#lblVitalPreviewHeight,#lblVitalPreviewWeight,#lblVitalPreviewBMI,#lblVitalPreviewBSA,#lblVitalPreviewRemarks').text('');

                        }
                    }
                    else
                        divVitalPreview.find('#lblVitalPreviewTemp,#lblVitalPreviewPulse,#lblVitalPreviewBp,#lblVitalPreviewResp,#lblVitalPreviewSPO2,#lblVitalPreviewHeight,#lblVitalPreviewWeight,#lblVitalPreviewBMI,#lblVitalPreviewBSA,#lblVitalPreviewRemarks').text('');
                });
            }

    </script>
    <form id="form1" runat="server">
           <cc1:ToolkitScriptManager ID="sp"  runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory_folder" style="border: none">
            <div class="row">
                <div runat="server" id="divPrescriptionAccordionList" style="padding: 0px" class="col-md-7">
                   <div class="row hideAccordian">
                        <div style="text-align: center" class="col-md-24">
                            <input type="button" onclick="openTemplateCreateModel({ isNew: true, templateFor: 1 }, function (model) { });" value="New Template" />
                            <input type="button" id="btnbSave" runat="server" value="Save" onclick="savePrescription()" />
                            <input type="button"  id="btnPrintPreview" value="Print" onclick="print()" />
                            <input type="button" id="btnPrintMed" value="Print Med." onclick="printMedicine()" />
                            <img style="cursor: pointer; display:none; height: 21px; margin-bottom: -6px;" id="btnVoicePrescription" class="disablemic" src="../../Images/ico_micon.png" />
                        </div>
                    </div>
                    
                     <div class="row">
                        <div style="padding: 0px" class="col-md-24">
                            <div id="accordion" class="hideAccordian">
                            </div>
                        </div>
                    </div>
                    <div class="row" style="display:none"><%--hideAccordian--%>
                        <div class="Purchaseheader" >Header For Print</div>
                        <div style="padding: 0px; max-height: 150px; overflow: auto" class="col-md-24">
                            <asp:CheckBoxList ID="chkHeaders" runat="server" ClientIDMode="Static" onclick="disabledPrint(true)" ></asp:CheckBoxList>
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
                                <h5 class="Purchaseheader">Current & Previous Visits</h5>
                                <div>
                                    <div style="padding: 0px; margin: 0px" class="row">
                                        <div style="padding-bottom: 5px" class="col-md-24">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row" style="border:solid thin;text-align: center;padding: 6px;display:none" id="divseenotefinder">
                        <label id="lblSeenotefinder" style="font-weight:bolder;font-size:13px;color:#001fff">See Note Finder</label>
                        </div>


                </div>
                <div id="divPrintPreview" runat="server" style="padding: 0px" class="col-md-17 subpage">
                      <div style="display:none" class="row" id="divheaderimage">
                  <img id="imghospitalheader" style="width:828px;height:118px;display:none" />
                        </div> 
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
                                <label class="pull-left"><b>Age/Sex</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label id="lblPreviewAgeSex"></label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"><b>App. On</b></label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblAppDate"></label>
                            </div>
                        </div>
                        
                        <div class="row prescriptionHeader">

                            <div class="col-md-5">
                                <label class="pull-left"><b>Mobile No.</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label id="lblMobileNo"></label>
                            </div>
                            <div class="col-md-4">
                                <%--<label class="pull-left"><b>Valid To.</b>  </label>--%>
                                <label class="pull-left"><b>Doc.Speciality</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <%--  <label id="lblValidTo"></label>--%>
                                <label id="lblDoctorSpeciality"></label>
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
                                <label class="pull-left"><b>Visit Type</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblVisitType"></label>

                            </div>


                           
                        </div>

                        <div class="row prescriptionHeader">

                            <div class="col-md-5">
                                <label class="pull-left"><b>Primary Doctor</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label id="lblPreviewDoctorName"></label>
                            </div>
                           <div class="col-md-4">
                                <label class="pull-left"><b>Last Modified By</b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblLastDoctorVisited"></label>
                            </div>
                            

                        </div>

                        <div class="row prescriptionHeader">
                             <div class="col-md-5">
                                 <label class="pull-left"><b>Primary Doc. Entry</b></label>
                                        <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-9">
                                <label style="font-size: 12px;" id="lblPrimaryDate"></label>
                            </div>
                            <div class="col-md-4">
                                <label class="pull-left"><b>Last Modified </b>  </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label id="lblLastUpdatedDate"></label>

                            </div>


                        </div>
                         <div class="row prescriptionHeader">


                            <div class="col-md-4">
                                <%--  <label class="pull-left"><b>Bill/Paid Amt.</b></label>
                                        <b class="pull-right">:</b>--%>
                            </div>
                            <div class="col-md-6">
                                <label style="font-size: 12px; display: none" id="lblBillPaidAmount"></label>
                            </div>
                             
                            <div class="col-md-5">
                                <label class="pull-left"><b></b>  </label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-9">
                                <label id="Label1"></label>

                            </div>
                        </div>

                    </div>
                    <div style="margin-top: -2px;" class="POuter_Box_Inventory_folder">
                        <div class="row">
                            <div style="margin-top: -5px; margin-bottom: -5px; border-right: solid 1px #303e54; min-height: 772px;" class="col-md-7">

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
                                        <li id="lilblVitalPreviewBMI" style="list-style: none; font-size: 9px; display: none; font-weight: bold;">
                                            <div class="col-md-10">BMI</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewBMI"></label>
                                            </div>
                                        </li>
                                        <li id="lilblVitalPreviewBSA" style="list-style: none; font-size: 9px; display: none; font-weight: bold;">
                                            <div class="col-md-10">BSA</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewBSA"></label>
                                            </div>
                                        </li>
                                          <li id="lilblVitalPreviewRemarks" style="list-style: none; font-size: 9px; display: none; font-weight: bold;">
                                            <div class="col-md-10">Remarks</div>
                                            <div class="col-md-14">
                                                :
                                                        <label id="lblVitalPreviewRemarks"></label>
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
                                <div id="divprescriptionPreviewData"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblApp_ID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblTransactionId" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblPatientID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblLedgerTransactionID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblAppointmentDoctorID" Style="display: none"></asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblIsIPDData" Style="display: none">0</asp:Label>
        <asp:Label ClientIDMode="Static" runat="server" ID="lblisipdopdprint" Style="display:none">0</asp:Label>
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
                                    <option value="3">History of Presenting Illness</option>
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
         <div id="dvAllergiesAndDiagnosis" class="modal fade" style="display:none">
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

        <%--Doctor Time Slot Availability Model--%>
    <div id="divSlotAvailability"   class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" >
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSlotAvailability" aria-hidden="true">&times;</button>
                    <b class="modal-title"> Doctor Slots :</b>
                     <span id="spnSelectedAppDate" style="display:none;"></span>  
                     <span id="spnReferralSelectedCentre" style="display:none;"></span>  
                         <asp:TextBox ID="txtAppointmentSlotDate" runat="server" style="width:172px;" ClientIDMode="Static" ToolTip="Select Date" ></asp:TextBox>
                         <cc1:CalendarExtender ID="calendarlotDate" TargetControlID="txtAppointmentSlotDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender>
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <div style="display:none;">
                    <b class="modal-title"> Appointment Slot Time :</b>    <select id="ddlSolotMin" style="width:150px">
                        <option value="5">5 Min</option>
                        <option value="10">10 Min</option>
                        <option value="15">15 Min</option>
                        <option value="20">20 Min</option>
                        <option value="25">25 Min</option>
                        <option value="30">30 Min</option>
                        <option value="35">35 Min</option>
                        <option value="40">40 Min</option>
                        <option value="45">45 Min</option>
                        <option value="50">50 Min</option>
                        <option value="55">55 Min</option>
                        <option value="60">60 Min</option>
                    </select></div>
                   </div>
                <div class="modal-body">
                   <div id="divSlotAvailabilityBody" style="padding-left: 30px;width:1020px;height:450px;overflow:auto">

                   </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-avilable"></button><b style="float:left;margin-top:5px;margin-left:5px">Avilable</b> 
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-yellow"></button><b style="float:left;margin-top:5px;margin-left:5px">Booked</b>  
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-purple"></button><b style="float:left;margin-top:5px;margin-left:5px">Confirmed</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-pink"></button><b style="float:left;margin-top:5px;margin-left:5px">Selected</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-grey"></button><b style="float:left;margin-top:5px;margin-left:5px">Expired</b>
                    <button type="button" style="width:30px;height:30px;float:left;margin-left:5px" class="circle badge-info"></button><b style="float:left;margin-top:5px;margin-left:5px">Mobile</b>

                    <button type="button"  data-dismiss="divSlotAvailability">Close</button>
                    
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
                    IsPackage: Number($(this).attr('data-IsPackage')),
                    PrescribeDate: $(this).attr('data-prescriptiondate')
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
                    Quantity: Number($(this).attr('data-quantity')),
                    PrescribeDate: $(this).attr('data-prescriptiondate')
                })
            })
            callback(data);
        }
        //Ajeet 
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
                    NoOfDays:"",
                    NoTimesDay: "" ,
                    Quantity: $.trim($(this).find('#lblMedicineQuantity').text()),
                    Dose: $.trim($(this).find('#lblMedicineDose').text()),
                    Meal: "",
                    route: $.trim($(this).find('#lblMedicineRoute').text()),
                    LedgerTransactionNo: ledgerTransactionID,
                    Remarks: $.trim($(this).find('#lblMedicineRemarks').text()),

                    Unit: $.trim($(this).find('#lblMedicineUnit').text()),
                    IntervalId: $.trim($(this).find('#lblIntervalId').text()),
                    IntervalName: $.trim($(this).find('#lblMedicineIntrvalName').text()),
                    DurationName: $.trim($(this).find('#lblMedicineDurationName').text()),
                    DurationVal: $.trim($(this).find('#lblDurationVal').text()),
                    TimetoGive: $.trim($(this).find('#lblMedTime').text()),
                    TimetoGive: $.trim($(this).find('#lblMedTime').text()),
                    RefealVal:$.trim($(this).find('#lblRefealVal').text()), 
                    
                })
            })
            callback(data);
        }



        var getPrescriptionHeaderShow = function (callback) {
            var data = [];
            $('#chkHeaders input:checked').each(function () {
                data.push({
                    Id: $(this).val()
                })
            });
            callback(data);
        }

        var checkHeaderForPrint = function () {
            $('[id *= chkHeaders]').find('input[type="checkbox"]').each(function () {
                $(this).prop("checked", false);
            });
            serverCall('../CPOE/services/PrescribeServices.asmx/GetShowPrescriptionData', { appointmentId: $("#lblApp_ID").text(), IsIPDData: Number($("#lblIsIPDData").text()) }, function (response) {
                responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    for (i = 0; i < responseData.length; i++) {
                        $('[id *= chkHeaders]').find('input[type="checkbox"]').each(function () {
                            if ($(this).val() == responseData[i].ID)
                                $(this).prop("checked", true);
                        });
                    }
                }
            });

        }

        var getDoctorNotesDetails = function (callback) {
            var divDoctorNotesPrintPreview = $('#divDoctorNotesPrintPreview').find('span').text();
            var templateName = $.trim($('#txtDoctorNoteTemplateName').val());
            callback(divDoctorNotesPrintPreview);

        }
        var getDoctorAdviceDetails = function (callback) {
            var divDoctorAdvicePrintPreview = $('#divDoctorAdvicePrintPreview').find('span').text();
            var templateName = $.trim($('#txtDoctorAdviceTemplateName').val());
            callback(divDoctorAdvicePrintPreview);

        }
        var getVaccinationStatusDetails = function (callback) {
            var divVaccinationStatusPrintPreview = $('#divVaccinationStatusPrintPreview').find('span').text();
            var templateName = $.trim($('#txtVaccinationStatusTemplateName').val());
            callback(divVaccinationStatusPrintPreview);
        }


        var getClinicalExaminationDetails = function (callback) {
            var divClinicalExaminationPrintPreview = $('#divClinicalExaminationPrintPreview').find('span').text();
            var templateName = $.trim($('#txtClinicalExaminiationTemplateName').val());
            callback(divClinicalExaminationPrintPreview);
        }

        var getChiefComplaintDetails = function (callback) {
            var divChiefComplaintPrintPreview = $('#divChiefComplaintPrintPreview').find('span').text();
            var templateName = $.trim($('#txtCheifComplaintTemplateName').val());
            callback(divChiefComplaintPrintPreview);
        }

        var getAllergiesDetails = function (callback) {
            var divAllergiesPreviewText = $('#divAllergiesPreview').find('span').text();
            callback(divAllergiesPreviewText);
        }
        var getConfidentialData = function (callback) {
            var divConfidentialDataPreviewText = $('#divConfidentialDataPreview').find('span').text();
            callback(divConfidentialDataPreviewText);
        }
        var getReferralConsultation = function (callback) {
            var divReferralForConsultationText = $('#divReferralForConsultation').find('span').html();
            callback(divReferralForConsultationText);
        }

        var getReferralRemark = function (callback) {
            var divReferralRemarkText = $('#divReferralRemark').find('span').html();
            callback(divReferralRemarkText);
        }

        var getAllProvisionDiagnosis = function (callback) {
            var divProvisionalDiagnosisText = $('#divProvisionalDiagnosis').find('span').text();
            callback(divProvisionalDiagnosisText);
        }

        var getMedicationDetails = function (callback) {
            var divMedicationPreviewText = $('#divMedicationPreview').find('span').text();
            callback(divMedicationPreviewText);
        }

        var getProgressionComplaintDetails = function (callback) {
            var divProgressionComplaintText = $('#divProgressionComplaint').find('span').text();
            callback(divProgressionComplaintText);
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
        var $popupAllergiesAndDiagnosis = function () {
            var patientID = $('#lblPatientID').text();
            serverCall('../CPOE/services/PrescribeServices.asmx/GetAllergiesAndDiagnosis', { patientID: patientID }, function (response) {
                AllergiesAndDiagnosis = JSON.parse(response);
                if (AllergiesAndDiagnosis.length > 0) {
                    var message = $('#tb_AllergiesAndDiagnosispopup').parseTemplate(AllergiesAndDiagnosis);
                    $('#dvAllergiesAndDiagnosisData').html(message);
                    //$('#dvAllergiesAndDiagnosis').showModel();
                    if ($('#lblisipdopdprint').text() == 1) {
                        $('#dvAllergiesAndDiagnosis').closeModel();
                    }
                }

            });
        }


        var savePrescription = function () {
            var App_ID = $.trim($('#lblApp_ID').text());
            var transactionID = $.trim($('#lblTransactionId').text());
            var patientID = $.trim($('#lblPatientID').text());
            var doctorID = $.trim($('#lblAppointmentDoctorID').text());
            var ledgerTransactionNo = $.trim($('#lblLedgerTransactionID').text());
            var refferdoctor = '';
            var referaltype = '';
            var consultationType = '';
            var referDept = '';
            var doctorType = '';
            var isIPDData = Number($("#lblIsIPDData").text());
            var isDoctorAppointment = Number($('input[name=rbtnAppointmentBook]:checked').val());

            var appointmentDate = $("#spnInDocAppDate").text();
            var appointmentTime = $("#spnInDocAppTime").text();

            var loginDoctorID = '<%=ViewState["currentDoctorID"].ToString()%>';
            if (loginDoctorID != "" && loginDoctorID != doctorID) {
              //  modelAlert('You can Edit only your Prescription');
               // return false;
            }

            if (isDoctorAppointment == 1 && (appointmentDate == "" || appointmentTime == "")) {
                modelAlert('Please Proper Select Doctor Appointment Slot.');
                return false;
            }


            if ($('#ddlReferDoctor option:selected').val() != 0 || $('#ddlReferOuterDoctor option:selected').val() != 0) {
                if ($('input[name=rbtnReferralType]:checked').val() == undefined) {
                    modelAlert('Please Select Referral Type.');
                    return false;
                }
                if ($('input[name=rbtnConsultType]:checked').val() == undefined) {
                    modelAlert('Please Select Consultation Type.');
                    return false;
                }
                if ($('#txtImpression').val() == '') {
                    modelAlert('Please Enter Refferal Impression/Diagnosis.');
                    return false;
                }
                if ($('#txtRemarks').val() == '') {
                    modelAlert('Please Enter Refferal Remarks.');
                    return false;
                }
                doctorType = $('input[name=rbtnDoctorType]:checked').val();
                referaltype = $('input[name=rbtnReferralType]:checked').val();
                consultationType = $('input[name=rbtnConsultType]:checked').val();

                if ($('#ddlDepartment').val() != 'ALL')
                    referDept = $('#ddlDepartment').val();
                if ($('#ddlReferDoctor option:selected').val() != 0 && doctorType == "In-House")
                    refferdoctor = $('#ddlReferDoctor option:selected').val();

                if ($('#ddlReferOuterDoctor option:selected').val() != 0 && doctorType != "In-House")
                    refferdoctor = $('#ddlReferOuterDoctor option:selected').val();

            }

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
                                                                    getReferralConsultation(function (referral) {
                                                                        getReferralRemark(function (referralRemarks) {
                                                                            getPrescriptionHeaderShow(function (PrescriptionHeader) {
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
                                                                                    referral: referral,
                                                                                    referralRemarks: referralRemarks,
                                                                                    referDept: referDept,
                                                                                    refferdoctor: refferdoctor,
                                                                                    referaltype: referaltype,
                                                                                    consultationType: consultationType,
                                                                                    prescriptionHeader: PrescriptionHeader,
                                                                                    doctorType: doctorType,
                                                                                    appointmentDate: appointmentDate,
                                                                                    appointmentTime: appointmentTime,
                                                                                    isDoctorAppointment: isDoctorAppointment,
                                                                                    IsIPDData: isIPDData
                                                                                };
                                                                                serverCall('../CPOE/services/PrescribeServices.asmx/savePrescription', data, function (response) {
                                                                                    var responseData = JSON.parse(response);
                                                                                    if (responseData.status) {
                                                                                        $('#lblApp_ID').text(responseData.App_ID);
                                                                                        loadFavoriteTemplate(function () { });
                                                                                        disabledPrint(false);
                                                                                       // modelConfirmation('Print Confirmation ?', 'Do you want to print', 'Yes Print', 'Close', function (response) {
                                                                                         //   if (response)
                                                                                        //     print();

                                                                                        // });
                                                                                        modelAlert(responseData.response);
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
                    });
                });
            });
        }

        var disabledPrint = function (status) {
            $('#btnPrintPreview').prop('disabled', status);//,#btnPrintMed
            
            $('#btnPrintMed').show();
            if(Number($("#lblIsIPDData").text())>0)
                $('#btnPrintMed').prop('disabled', true).hide();
        }

        var loadFavoriteTemplate = function () {
            try {
                var doctorID = $.trim($('#lblAppointmentDoctorID').text());
		//alert(doctorID);
                serverCall('../CPOE/services/PrescribeServices.asmx/GetFavoriteTemplates', { doctorID: doctorID }, function (response) {
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
            $('#divdoctorSign,#divheaderimage').show();
            var _temp = $('#divPrintPreview').clone();
            var appointmentID = $.trim($('#lblApp_ID').text());
            serverCall('../CPOE/services/PrescribeServices.asmx/GetHidePrescriptionData', { appointmentId: appointmentID, IsIPDData: Number($("#lblIsIPDData").text()) }, function (response) {
                // var responseData = JSON.parse(response);
                if (!String.isNullOrEmpty(response))
                    _temp.find(response).show()//hide();
                var h = screen.height;
                var w = screen.width;
                printWindow = window.open('../CPOE/PrescriptionView/Print.html', "PrintWindow", "width=" + w + ",height=" + h);
                printWindow.onload = function () {
                    var printPreview = printWindow.document.getElementById('printPreview').innerHTML = $(_temp).html();
                    // printWindow.document.getElementById('printPreview').innerHTML = $('#divPrintPreview').html();
                };
            });

            $('#divdoctorSign,#divheaderimage').show();
        }

        var printFromPreviousVisitMed = function (elem)
        {
            debugger;
            var dataRow = $(elem).closest('div').prev().prev();
            var transactionID = dataRow.attr('TransactionID');
            var appointmentID = dataRow.attr('AppID');
            var IsIPDData = dataRow.attr('isipddata');
            medicinePrintOut(IsIPDData, appointmentID, transactionID);
        }

        var printMedicine = function () {

            var appointmentID = $.trim($('#lblApp_ID').text());
            var IsIPDData= Number($("#lblIsIPDData").text())
            var transactionID = $.trim($('#lblTransactionId').text());
            medicinePrintOut(IsIPDData, appointmentID, transactionID);
        }

        //dev print
        var medicinePrintOut = function (IsIPDData, App_ID, TID)
        {
            window.open('CPOEMedicinePrintOut_pdf.aspx?IsIPDData=' + IsIPDData + '&App_ID=' + App_ID + '&TID=' + TID);
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
        var closeAllergiesAndDiagnosisModel = function () {
            $('#dvAllergiesAndDiagnosis').closeModel();
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
            serverCall('../CPOE/services/PrescribeServices.asmx/SaveTemplate', { data: data.data }, function (response) {
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
                serverCall('../CPOE/services/PrescribeServices.asmx/SaveMedicineTemplate', { data: data.data }, function (response) {
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
                serverCall('../CPOE/services/PrescribeServices.asmx/AddMedicinePrescriptionDefaultValue', { data: medicines }, function (response) {
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
            serverCall('../CPOE/services/PrescribeServices.asmx/UpdateTemplate', { data: data.data }, function (response) {
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
                    serverCall('../CPOE/services/PrescribeServices.asmx/DeleteTemplate', { templateID: data.id, templateFor: data.templateFor }, function (response) {
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
            serverCall('../CPOE/services/PrescribeServices.asmx/medicineItemSearch', { prefix: prefix }, function (response) {
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
            serverCall('../CPOE/services/PrescribeServices.asmx/GetMedicineDoses', { type: type }, function (response) {
                callback(JSON.parse(response))
            });
        };

        var filteredAutoComplete = function (data, request, callback) {
            // debugger;
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
                AppID: $.trim($('#lblApp_ID').text()),
                IsIPDData: Number($.trim($('#lblIsIPDData').text()))
            }
            serverCall('../CPOE/services/PrescribeServices.asmx/GetPreviousVisit', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var divAccordionPreviousVisit = $('#divAccordionPreviousVisit .row .col-md-24');
                    var type = "";
                    var i = 0;
                    $(responseData).each(function () {
                        i = Number(i + 1);
                        if (this.Isipd == 1) {
                            type = '(IPD)';
                        }
                        else if (this.Isipd == 0) {
                            type = '(OPD)';
                        }
                        else if (this.Isipd == 2) {
                            type = '(EMG)';
                        }

                        var visitText = type + ' On ' + this.DateVisit + '/' + this.DName;
                        if (Number(this.CurrentVisit) == 1)
                            visitText = "Current Visit"

                        var visit = '<div class="ui-accordion-header ui-state-default ui-accordion-icons ui-accordion-header-active ui-state-active ui-corner-top row ' + (this.CurrentVisit == 1 ? 'selectedVisit' : '') + '" style="font-size: 12px;padding-left: 5px;text-align: left;"><div id="loaddivpre' + i + '" onclick="loadPreviousVisitDetails(this,function(){});"  dateVisit="' + this.DateVisit + '"  doctorName="' + this.DName + '" panel="' + this.PanelName + '"  doctorid="' + this.DoctorID + '" TransactionID="' + this.TransactionID + '"  AppID="' + this.App_ID + '" LedgerTransactionNo="' + this.LedgerTransactionNo + '" IsIPDData="' + this.Isipd + '" CurrentVisit="' + this.CurrentVisit + '" HospitalHeaderImage="' + this.ReportFooterURL + '" class="col-md-20" style="max-width: 98%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"  >'
                              + visitText + '</div><div class="col-md-2"> <a href="javascript:void(0);" onclick="printFromPreviousVisitLable(this)" class="icon icon-color icon-print pull-right"></a>  </div><div class="col-md-2"> <a href="javascript:void(0);" onclick="printFromPreviousVisitMed(this)" class="icon icon-color icon-briefcase pull-right"  title="Print Medicine" ></a>  </div></div>';
                        divAccordionPreviousVisit.append(visit);
                    });
                    // $('#divAccordionPreviousVisit').accordion('refresh');
                }


                //if (responseData.DTIPD.length > 0) {
                //    var divAccordionPreviousVisit = $('#divAccordionPreviousVisit .row .col-md-24');

                //    $(responseData.DTIPD).each(function () {
                //        var visitText = '(IPD) On ' + this.DateVisit + '/' + this.DName;
                //        if (this.CurrentVisit)
                //           visitText = "Current Visit"

                //        var visit = '<div class="ui-accordion-header ui-state-default ui-accordion-icons ui-accordion-header-active ui-state-active ui-corner-top row ' + (this.CurrentVisit == 1 ? 'selectedVisit' : '') + '" style="font-size: 12px;padding-left: 5px;text-align: left;"><div onclick="loadPreviousVisitDetails(this,function(){});"  dateVisit="' + this.DateVisit + '"  doctorName="' + this.DName + '" panel="' + this.PanelName + '"  doctorid="' + this.DoctorID + '" TransactionID="' + this.TransactionID + '"  AppID="' + this.App_ID + '" LedgerTransactionNo="' + this.LedgerTransactionNo + '"  IsIPDData=1 class="col-md-22" style="max-width: 98%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"  >'
                //              + visitText + '</div><div class="col-md-2"> <a href="javascript:void(0);" onclick="printFromPreviousVisitLable(this)" class="icon icon-color icon-print pull-right"></a>  </div></div>';
                //        divAccordionPreviousVisit.append(visit);
                //    });

                //}
                if ($('#lblisipdopdprint').text() == 1) {
                    $('#divAccordionPreviousVisit').hide();
                }
                else {
                    $('#divAccordionPreviousVisit').show();
                }
                callback($('#divAccordionPreviousVisit').accordion('refresh'));
            });
        }


        var clearPrescriptionPreview = function (callback) {
            $('.prescribedItem').text('');
            $('#tblPrescribeMedicinePreview tbody tr').remove();
            $('#divProcedurePreview ul li').remove();
            $('#divInvestigationPreview ul li').remove();
            $("#imgDoctorSignNew").removeAttr('src');
            $('#divdoctorSign').hide();
            callback();
        }

        var loadPreviousVisitDetails = function (elem, callback) {
            clearPrescriptionPreview(function () {
                $(elem).closest('#divAccordionPreviousVisit').find('.ui-accordion-header').removeClass('selectedVisit');
                $(elem).closest('.ui-accordion-header').addClass('selectedVisit');
                $('#divAccordionPreviousVisit').closest('div').find('#loaddivpre1').removeClass('selectedVisit');
                var transactionID = $(elem).closest('div').attr('TransactionID');
                var AppID = $(elem).closest('div').attr('AppID');
                var LedgerTransactionNo = $(elem).closest('div').attr('LedgerTransactionNo');
                var doctorId = $(elem).closest('div').attr('doctorid');
                var IsIPDData = $(elem).closest('div').attr('IsIPDData');
                var currentvisit = $(elem).closest('div').attr('currentvisit');

                if (currentvisit == 0) {
                   // $('#btnbSave').attr('disabled', 'disabled');
                }

                else {
                   // $('#btnbSave').removeAttr('disabled');
                }
                var data = {
                    transactionID: transactionID,
                    appointmentID: Number(AppID),
                    LedgerTransactionNo: LedgerTransactionNo,
                    doctorId: doctorId,

                }
                dataPre = {
                    transactionID: transactionID,
                    appointmentID: Number(AppID),
                    IsIPDData: IsIPDData

                    //Number($("#lblIsIPDData").text())
                }

                getPreviousVisitDetails(dataPre, function (responseData) {
                    bindPatientChiefComplaint(responseData);
                    bindClinicalExamination(responseData);
                    bindPatientInvestigationDetails(responseData);
                    bindVaccinationStatus(responseData);
                    bindDoctorNotes(responseData);
                    bindPatientAllergies(responseData);
                    bindPatientMedication(responseData);
                    bindPatientProgressionComplaint(responseData);
                    bindPatientProcedureDetails(responseData);
                    bindPatientMedicineDetails(responseData);
                   // bindPatientMolecularAllergies(responseData);
                    bindProvisionalDiagnosis(responseData);
                    bindDoctorAdvice(responseData);
                    bindConfidentialData(responseData);
                    BindReferralConsultation(responseData);
                    bindPreviousAppointmentDetails(data);
                    bindPatientHeaderDetails(responseData);
                    checkHeaderForPrint();
                    getVitalSigns(transactionID, AppID);

                    callback();
                });
            });
        }

        var bindPatientHeaderDetails = function (data) {
            var patientDetails = data.patientDetails[0];
            //alert(patientDetails.ReportHeaderURL);
            //../../../Images/CD logo-002.png
            if (patientDetails != undefined) {
                
                $("#lblLastUpdatedDate").text('<%= ViewState["LastVisitDate"].ToString() %>');
                $("#lblLastDoctorVisited").text('<%= ViewState["LastDoctor"].ToString() %>');
                $("#lblPrimaryDate").text('<%= ViewState["FirstVisitDate"].ToString() %>');
            $('#imghospitalheader').attr('src', '../../../Images/' + patientDetails.ReportFooterURL);
            $('#lblPreviewPatientName').text(patientDetails.PatientName);
            $('#lblPreviewPatientID').text(patientDetails.PatientID);
                // $('#lblPreviewDoctorName').text(patientDetails.DoctorName);
            $('#lblPreviewDoctorName').text('<%= ViewState["PrimaryDoctor"].ToString() %>');
            $('#lblPreviewAgeSex').text(patientDetails.Gender);
            $('#lblPreviewPanel').text(patientDetails.Company_Name);
            $('#lblAppDate').text(patientDetails.appointmentDate);
            $('#lblVisitType').text(patientDetails.VisitType);
            $('#lblMobileNo').text(patientDetails.Mobile);
            $('#lblValidTo').text(patientDetails.ValidTo);
            $('#lblDoctorSpeciality').text(patientDetails.Specialization);
            $('#lblBillPaidAmount').text(patientDetails.BillNo + '/Rs:' + patientDetails.Adjustment);
//alert(patientDetails.DoctorID);
	    $('#divdoctorSign').hide();
            $("#imgDoctorSignNew").attr('src', '../../Doctor/DoctorSignature/' + patientDetails.DoctorID + '.jpg');
            $('#lblAppointmentDoctorID').text(patientDetails.DoctorID);

            var loginDoctorID = '<%=ViewState["currentDoctorID"].ToString()%>';
            var appointmentDoctorID = $('#lblAppointmentDoctorID').text();
            if (loginDoctorID != "" && loginDoctorID != appointmentDoctorID)
               // $("#btnbSave").hide();
                $("#btnbSave").show();
            else
                $("#btnbSave").show();

            }
        }
        var bindPreviousAppointmentDetails = function (data) {
            $('#lblApp_ID').text(data.appointmentID);
            $('#lblTransactionId').text(data.transactionID);
            $('#lblAppointmentDoctorID').text(data.doctorId);
            $('#lblLedgerTransactionID').text(data.LedgerTransactionNo);
        }
        var getPreviousVisitDetails = function (data, callback) {
            serverCall('../CPOE/services/PrescribeServices.asmx/GetPrescription', data, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });

        }



        var printFromPreviousVisitLable = function (elem) {
            var dataRow = $(elem).closest('div').prev();
            var transactionID = dataRow.attr('TransactionID');
            var AppID = dataRow.attr('AppID');
            var IsIPDData = dataRow.attr('isipddata');
            var data = {
                transactionID: dataRow.attr('TransactionID'),
                dateVisit: dataRow.attr('dateVisit'),
                panel: dataRow.attr('panel'),
                doctorName: dataRow.attr('doctorName'),
                appointmentID: Number(dataRow.attr('AppID')),
                LedgerTransactionNo: dataRow.attr('LedgerTransactionNo'),
                doctorId: dataRow.attr('doctorid'),
                IsIPDData: IsIPDData,
                HospitalHeaderImage: dataRow.attr('HospitalHeaderImage')
            }

            dataPre = {
                transactionID: dataRow.attr('TransactionID'),
                appointmentID: Number(dataRow.attr('AppID')),
                IsIPDData: IsIPDData //Number($("#lblIsIPDData").text())
            }

            getPreviousVisitDetails(dataPre, function (responseData) {
                bindPatientChiefComplaint(responseData);
                bindClinicalExamination(responseData);
                bindPatientInvestigationDetails(responseData);
                bindVaccinationStatus(responseData);
                bindDoctorNotes(responseData);
                bindPatientAllergies(responseData);
                bindPatientMedication(responseData);
                bindPatientProgressionComplaint(responseData);
                bindPatientProcedureDetails(responseData);
                bindPatientMedicineDetails(responseData);
             //   bindPatientMolecularAllergies(responseData);
                bindProvisionalDiagnosis(responseData);
                bindDoctorAdvice(responseData);
                bindConfidentialData(responseData);
                BindReferralConsultation(responseData);
                bindPreviousAppointmentDetails(data);
                bindPatientHeaderDetails(responseData);
                getVitalSigns(transactionID, AppID);
                checkHeaderForPrint();
                printPrevious(data);
            });
        }

        var printPrevious = function (data) {
            $('#divdoctorSign,#divheaderimage').show();
            var _temp = $('#divPrintPreview').clone();
            serverCall('../CPOE/services/PrescribeServices.asmx/GetHidePrescriptionData', { appointmentId: data.appointmentID, IsIPDData: data.IsIPDData }, function (response) {
                if (!String.isNullOrEmpty(response))
                    _temp.find(response).show();

                var h = screen.height;
                var w = screen.width;
                var printWindow = window.open('../CPOE/PrescriptionView/Print.html', "PrintWindow", "width=" + w + ",height=" + h);
                printWindow.onload = function () {
                    var printPreview = printWindow.document.getElementById('printPreview').innerHTML = $(_temp).html();
                    printWindow.document.getElementById('lblAppDate').innerHTML = data.dateVisit;
                    printWindow.document.getElementById('lblPreviewDoctorName').innerHTML = data.doctorName;
                    printWindow.document.getElementById('lblPreviewPanel').innerHTML = data.panel;
                    $('#divdoctorSign,#divheaderimage').hide();
                };
            });
            $('#divdoctorSign').hide();
        }






        function CheckIsNoteFinder() {

            var transactionId = $.trim($('#lblTransactionId').text());
            serverCall('../CPOE/services/PrescribeServices.asmx/CheckIsNoteFinder', { TransactionID: transactionId }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status==1) {
                    $("#divseenotefinder").show();
                } else {
                    $("#divseenotefinder").hide();
                }

            });

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

   <%-- <script src="Script/speachPrescription.js"></script>--%>
</body>
</html>


