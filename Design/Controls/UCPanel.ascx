<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UCPanel.ascx.cs" Inherits="Design_UCPanel" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<style type="text/css">
    .panelDocumentButton {
        width: 100% !important;
        margin-top: 5px;
    }

    .selectedDocument {
        background-color: lightcoral !important;
    }

    .uplodedDocument {
        background-color: lightgreen !important;
    }

    .panelDocumentModelBody {
        min-height: 300px;
        max-height: 450px;
        overflow: auto;
    }

    .tableImageFontSize {
        font-size: 30px;
    }

    .hidden {
        display: none;
    }
</style>

<script type="text/javascript">
    //*****Global Variables*******
    var CentreWisePanelCache = [];

    $panelControlInit = function (callback) {
        configurePanelControlChache(function () {
            $bindPanel(function (p) {
                $bindCardHolderRelation(function () {
                    $bindPanelMasterDetails(p.panelCompany, function () {
                        $panelControlConfigurePageWise(function () {
                            MarcTooltips.add('#lblPanelRateCurrency', 'Panel Rate Currency', {
                                position: 'up',
                                align: 'left'
                            });
                            callback(true);
                            $bindPanelGroup(function () { });//
                            $bindCorporatePanel(function () { });//
                        });
                    });
                });
            });
        });
    }

    var configurePanelControlChache = function (callback) {
        serverCall('../common/CommonService.asmx/CentreWisePanelControlCache', {}, function (response) {
            var responseData = JSON.parse(response);
            CentreWisePanelCache = responseData; //assign to global variables
            callback();
        });
    }

    $panelControlConfigurePageWise = function (callback) {
        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

        if (pageName == 'opdadvance.aspx') {
            var _divParentPanelUserControl = $('#divParentPanelUserControl');
            _divParentPanelUserControl.find('input[type=textbox],select,input[type=button]').prop('disabled', true);
            _divParentPanelUserControl.find('#ddlParentPanel,#ddlPanelCompany').trigger("chosen:updated");
        }
        callback();
    }

    $bindCorporatePanel = function (callback) {
        //  serverCall('../Common/CommonService.asmx/BindCorporatePanel', {}, function (response) {
        var $ddlPanelCorporate = $('#ddlPanelCorporate');
        //  $ddlPanelCorporate.bindDropDown({ data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true, defaultValue: 'Select' });
        var responseData = CentreWisePanelCache.filter(function (i) { return i.TypeID == '2' });
        $ddlPanelCorporate.bindDropDown({ data: responseData, valueField: 'PanelID', textField: 'TextField', isSearchAble: true, defaultValue: 'Select' });

        callback($ddlPanelCorporate.val());
        // });
    }

    $bindPanelGroup = function (callback) {
        //  serverCall('../Common/CommonService.asmx/BindPanelGroup', {}, function (response) {
        var $ddlPanelGroup = $('#ddlPanelGroup');
        //    $ddlPanelGroup.bindDropDown({ data: JSON.parse(response), valueField: 'PanelGroupID', textField: 'PanelGroup', isSearchAble: true });
        var responseData = CentreWisePanelCache.filter(function (i) { return i.TypeID == '4' });
        $ddlPanelGroup.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultPanelGroupID") %>' });
        if (pageName.toLocaleLowerCase() == 'ipdadmissionnew.aspx') {
            if ($ddlPanelGroup.val() != '1')
                $('#txtIDProofNo').addClass('requiredField');
            else
                $('#txtIDProofNo').removeClass('requiredField');


        }
        callback($ddlPanelGroup.val());
        //});
    }

    $onPanelGroupChange = function (elem) {
        var ID = elem.value;
        // serverCall('../Common/CommonService.asmx/bindPanelByGroupID', { GroupID: ID }, function (response) {
        var $ddlPanelCompany = $('#ddlPanelCompany');
        //(PanelID, '#', ReferenceCodeOPD, '#', HideRate, '#', ShowPrintOut)
        // $ddlPanelCompany.bindDropDown({ data: JSON.parse(response), valueField: 'PanelCompanyValue', textField: 'Company_Name', isSearchAble: true, defaultValue: 'Select' });
        var responseData = CentreWisePanelCache.filter(function (i) { return i.TypeID == '1' && i.PanelGroupID == ID });
        $ddlPanelCompany.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, defaultValue: 'Select' });

        //callback($ddlPanelCompany.val());
        // });
    }

    $bindPanel = function (callback) {
        // serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
        var $ddlParentPanel = $('#ddlParentPanel');
        var $ddlPanelCompany = $('#ddlPanelCompany');
        //(PanelID, '#', ReferenceCodeOPD, '#', HideRate, '#', ShowPrintOut)
        //  $ddlParentPanel.bindDropDown({ data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultPanelID") %>' });
        // $ddlPanelCompany.bindDropDown({ data: JSON.parse(response), valueField: 'PanelCompanyValue', textField: 'Company_Name', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultPanelID") %>' + '#' + '0' + '#' + '1' });

        var responseData = CentreWisePanelCache.filter(function (i) { return i.TypeID == '1' });
        $ddlParentPanel.bindDropDown({ data: responseData, valueField: 'PanelID', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultPanelID") %>' });

        $ddlPanelCompany.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultPanelID") %>' + '#' + '702' + '#' + '0' + '#' + '1' });

        if (pageName.toLocaleLowerCase() == 'ipdadmissionnew.aspx') {
            if ($ddlPanelCompany.val()!= '1')
                $('#txtIDProofNo').addClass('requiredField');
            else
                $('#txtIDProofNo').removeClass('requiredField');
        }

        callback({ panelCompany: $ddlPanelCompany.val(), parentPanel: $ddlParentPanel.val() });
        //});
    }

    $bindCardHolderRelation = function (callback) {
        $ddlRelationCardHolder = $('#ddlCardHolder');
        // serverCall('../IPD/Services/IPDAdmission.asmx/bindCarHolderRelation', {}, function (response) {
        //    $ddlRelationCardHolder.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response) });
        var responseData = CentreWisePanelCache.filter(function (i) { return i.TypeID == '3' });
        $ddlRelationCardHolder.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField', selectedValue: 'Self' });
        callback($ddlRelationCardHolder.find('option:selected').text());
        //  });
    }



    $onPanelChange = function (elem) {
        var paneldetailRows = $('.paneldetailRow');
        var panelID = Number(elem.value.split('#')[0]);
        $('#ddlParentPanel').val(panelID).trigger("chosen:updated");
        var textBoxes = paneldetailRows.find('input[type=text]');
        var selectElems = paneldetailRows.find('select');
        //var txtPolicyNo = $('#divParentPanelUserControl').find('#txtPolicyNO').removeClass('requiredField');
        var txtPolicyNo = $('#divParentPanelUserControl').find('#txtPolicyNO');
        var ddlIgnorepolicy = $('#divParentPanelUserControl').find('#ddlIgnorePolicy');//
        var txtPanelCardNo = $('#divParentPanelUserControl').find('#txtCardNo').removeClass('requiredField');
        if (panelID > 0) {
            $bindPanelMasterDetails(panelID, function () { });
        }
        var defaultPanelID = Number('<%=Resources.Resource.DefaultPanelID%>');



        if (panelID != defaultPanelID) {
            //txtPanelCardNo.addClass('requiredField').attr('errorMessage', 'Please Enter Card No.');
            txtPolicyNo.attr('disabled', false);
            ddlIgnorepolicy.attr('disabled', false);//
            paneldetailRows.show();
        }
        else {
            txtPolicyNo.attr('disabled', true);
            ddlIgnorepolicy.attr('disabled', true);//
            ddlIgnorepolicy.val(0);//
            $('#spnPanelControlPanelAdvanceAmount').text(0);
            paneldetailRows.hide();
            textBoxes.removeClass('requiredField');
            selectElems.val('0').removeClass('requiredField');
        }
        getPanelDocuments(function () { });

        if (pageName.toLocaleLowerCase() == 'ipdadmissionnew.aspx') {
            if (panelID != '1')
                $('#txtIDProofNo').addClass('requiredField');
            else
                $('#txtIDProofNo').removeClass('requiredField');
        }

        IsSmartCardCheck(panelID);
        if (typeof onPanelControlPanelChange == 'function') onPanelControlPanelChange(function () { });
    }

    $bindPanelMasterDetails = function (panelID, callback) {
        $getPanelMasterDetails(panelID, function (response) {
            var _divParentPanelUserControl = $('#divParentPanelUserControl');
            _divParentPanelUserControl.find('#spnPanelControlPanelAdvanceAmount').text(response.panelAdvanceAmount);
            _divParentPanelUserControl.find('#lblPanelRateCurrency').text(response.panelCurrency);
            _divParentPanelUserControl.find('#txtPanelRateCurrency').val(response.panelCurrencyFactor)
                .attr('panelCurrencyFactor', response.panelCurrencyFactor)
                .attr('panelCurrencyCountryID', response.RateCurrencyCountryID);
            callback(response);
        });
    }



    $getPanelMasterDetails = function (panelID, callback) {
        serverCall('../Common/CommonService.asmx/GetPanelDetails', { PanelID: panelID }, function (response) {
            var responseData = JSON.parse(response);
            callback(responseData);
        });
    }


    $getPanelDetails = function (callback, options) {
        getPanelUploadedDocuments(function (panelDocuments) {
            d = $.extend(true, { validate: true }, options);
            var panel = $('#ddlPanelCompany').val().split('#');
            var data = {
                parentPanel: { panelID: $('#ddlParentPanel').val(), panel: $('#ddlParentPanel option:selected').text() },
                panel: { panelName: $('#ddlPanelCompany option:selected').text(), panelID: Number(panel[0]) },
                ReferenceCodeOPD: panel[1],
                HideRate: panel[2],
                ShowPrintOut: panel[3],
                expireDate: $('#txtExpireDate').val(),
                policyNo: $('#txtPolicyNO').val(),
                cardNo: $('#txtCardNo').val(),
                nameOnCard: $('#txtCardHolderName').val(),
                cardHolderRelation: $('#ddlCardHolder').val(),
                ignorePolicy: $('#ddlIgnorePolicy').val() == '1' ? true : false,
                ignorePolicyReason: $('#txtIgnoreReason').val(),
                advanceAmount: Number($('#spnPanelControlPanelAdvanceAmount').text()),
                panelCurrencyFactor: Number($('#txtPanelRateCurrency').val()),
                panelCurrencyCountryID: Number($('#txtPanelRateCurrency').attr('panelCurrencyCountryID')),
                approvalAmount: Number($('#txtPanelApprovalAmount').val()),
                approvalRemark: $.trim($('#txtPanelApprovalRemark').val()),
                Corporatepanel: { CorporatepanelName: $('#ddlPanelCorporate option:selected').text(), CorporatepanelID: $('#ddlPanelCorporate option:selected').val() }//
            }

            data.panelDocuments = panelDocuments;
            if (data.ignorePolicy) {
                if (String.isNullOrEmpty(data.ignorePolicyReason)) {
                    modelAlert('Please Enter Policy Ignore Reason');
                    return false;
                }
            }

            // console.log(data);
            callback(data);
        });
    }



    var getPanelUploadedDocuments = function (callback) {
        var panelDocuments = [];
        $('#divPanelRequiredDocuments .panelDocumentButton').each(function () {
            var panelDocument = {};
            panelDocument.ID = Number($(this).find('#spnDocumentID').text());
            panelDocument.DocumentName = $(this).find('#spnDocumentName').text();
            panelDocument.DocumentBase64 = $(this).find('#spnDocumentBase64').text();
            panelDocument.isCurrentSelected = $(this).hasClass('selectedDocument');

            if (!String.isNullOrEmpty(panelDocument.DocumentBase64)) {
                panelDocuments.push(panelDocument);
                $(this).addClass('uplodedDocument');
            }
        });

        callback(panelDocuments);
    }

    $bindPanelDetails = function (data, callback) {
        $('#ddlParentPanel').val(data.ParentID).chosen('destroy').chosen();
        $('#ddlPanelCompany').val(data.PanelID + '#' + data.ReferenceCodeOPD + '#' + data.HideRate + '#' + data.ShowPrintOut).change().chosen("destroy").chosen();
        $('#txtPolicyNO').val(data.PolicyNo);
        $('#txtExpireDate').val(data.ExpiryDate == '01-Jan-0001' ? '' : data.ExpiryDate);
        $('#txtCardNo').val(data.CardNo);
        $('#txtCardHolderName').val(data.CardHolderName);

        var URL = window.location.href.split('?')[0];
        var pageName = URL.split('/')[URL.split('/').length - 1];

        if (pageName.toLocaleLowerCase() == 'ipdadmissionnew.aspx') {
            if (data.PanelID != '1')
                $('#txtIDProofNo').addClass('requiredField');
            else
                $('#txtIDProofNo').removeClass('requiredField');


        }
        IsSmartCardCheck(data.PanelID);
        callback();
    }


    var URL = window.location.href.split('?')[0];
    var pageName = URL.split('/')[URL.split('/').length - 1];
    $getMultiPanelDetails = function (data, callback) {

        if (!String.isNullOrEmpty(data)) {
            $('#tbMultiPanelSelected tbody').empty();
            if (pageName.toLocaleLowerCase() != 'patientpanelapproval.aspx') {
                bindPatientPanelDetails(data);
                $('#btnAddMutiPanel').show();
                $('#divMultiPPanel').show();
            }
            else {
                $('#btnAddMutiPanel').hide();
                $('#divMultiPPanel').hide();
            }
			var defaultpanel = '';
			var defaultParentPanel = '';
			for (var i = 0; i < data.length; i++) {
			    if (data[i].IsDefaultPanel == '1')
			    { defaultpanel = data[i].PPanelID; defaultParentPanel = data[i].PParentPanelId;}
			}

          

            if ($('#txtPID').val() != "") {
                
                if (pageName.toLocaleLowerCase() == 'lab_prescriptionopd.aspx' || pageName.toLocaleLowerCase() == 'ipdadmissionnew.aspx' || pageName.toLocaleLowerCase() == 'emergencyadmission.aspx' || pageName.toLocaleLowerCase() == 'opdpharmacyissue.aspx' || pageName.toLocaleLowerCase() == 'patientpanelapproval.aspx') {
                    $('#ddlPanelCompany').bindDropDown({ data: data, valueField: 'PPanelID', textField: 'PPanelName', isSearchAble: true,  selectedValue:defaultpanel});
                    $('#ddlPanelGroup').bindDropDown({ data: data, valueField: 'PPanelgroupID', textField: 'PPanelGroup', isSearchAble: true, selectefValue: defaultParentPanel });
                    $('#ddlPanelCorporate').bindDropDown({ data: data, valueField: 'PCorporateID', textField: 'PCorporateName', isSearchAble: true, defaultValue: 'Select' });
                    $('#ddlParentPanel').bindDropDown({ data: data, valueField: 'PParentPanelId', textField: 'PParentPanel', isSearchAble: true, });


                }
               

            }
           
           
            
            
        }

    }

   

    $ignorePolicyChange = function (value) {
        if (value == '1')
            $('#txtIgnoreReason').val('').prop('disabled', false).addClass('requiredField');
        else
            $('#txtIgnoreReason').val('').prop('disabled', true).removeClass('requiredField');
    }


    var searchByCardNo = function (e) {
        if ($.isFunction(window['patientSearchOnEnter']))
            patientSearchOnEnter(e);
    }

    var changePanelCurrencyFactor = function (e) {
        var panelCurrencyFactor = Number($(e.target).attr('panelCurrencyFactor'));
        if (panelCurrencyFactor != Number(e.target.value))
            if (typeof onPanelCurrencyFactorChange == 'function') onPanelCurrencyFactorChange(function () { });
    }

    function IsSmartCardCheck(panelID) {
        serverCall('../Common/CommonService.asmx/IsSmartCardCheck', { PanelID: panelID }, function (response) {
            var responseData = JSON.parse(response);

            if (responseData.status) {

                BtnIsSmartHideShow(responseData.IsSmartCard, responseData.IsSmartCard, responseData.IsManual);
            } else {
                BtnIsSmartHideShow(0, responseData.IsSmartCard, responseData.IsManual);
            }

           
        }); 
    }

    
    function BtnIsSmartHideShow(Typ,IsSmartCard,IsManual) {

        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();
        if (pageName.toLocaleLowerCase() == 'lab_prescriptionopd.aspx') {
             
        if (Typ==1) {
            $("#lblIsSmartCard").text(IsSmartCard);
            $("#lblIsManual").text(IsManual);            
            $("#btnFetchData").show();
            $("#lblIsSmartCardIpd").text(0);
            $("#lblIsManualIpd").text(0);
            $("#btnFetchDataIpd").hide();
        } else {
            $("#lblIsSmartCard").text(IsSmartCard);
            $("#lblIsManual").text(IsManual);
            $("#btnFetchData").hide();
            $("#lblIsSmartCardIpd").text(0);
            $("#lblIsManualIpd").text(0);
            $("#btnFetchDataIpd").hide();
        }
        } else if (pageName.toLocaleLowerCase() == 'patientpanelapproval.aspx') {


            if (Typ == 1) {
                $("#lblIsSmartCard").text(0);
                $("#lblIsManual").text(0);
                $("#btnFetchData").hide();
                $("#lblIsSmartCardIpd").text(IsSmartCard);
                $("#lblIsManualIpd").text(IsManual);
                $("#btnFetchDataIpd").show();
            } else {
                $("#lblIsSmartCard").text(0);
                $("#lblIsManual").text(0);
                $("#btnFetchData").hide();
                $("#lblIsSmartCardIpd").text(IsSmartCard);
                $("#lblIsManualIpd").text(IsManual);
                $("#btnFetchDataIpd").hide();
            }

        }


    }
     
    function GetMemberDetails(Typ) {

        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();

        if (pageName.toLocaleLowerCase() == 'lab_prescriptionopd.aspx' && Typ == 0) {
            serverCall('../Common/CommonService.asmx/IsSmartCardCheck', { PanelID: $("#ddlPanelCompany").val().split('#')[0] }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.IsSmartCard == 0) {
                    modelAlert("Change Panel,This Panel Is Not For Smart Card.");
                    return false;
                }
                else {
                    if ($('#txtPID').val() == '') { modelAlert(" Patient is not Register,Kindly Register The Patient First Or Select The Patient "); return; }

                    serverCall('../OPD/Services/CardIntigration.asmx/GetMemberDetails', { PatientID: $('#txtPID').val(), PanelId: $("#ddlPanelCompany").val().split('#')[0] }, function (response) {
                        var responseData = JSON.parse(response);

                        if (responseData.status && responseData.SaveStatus) {
                            SetIsFetched(1, responseData.response.content[0].benefits[0].amount, responseData.response.content[0].policy_id);
                            console.log(responseData.response);
                            ////var Message = 'Member Name: ' + responseData.response.content[0].member_name + '</br> Ploicy Id: ' + responseData.response.content[0].policy_id + '</br> Amount: ' + responseData.response.content[0].benefits[0].amount

                            openBeneFitModel(responseData.response.content[0].benefits)

                        } else if (responseData.status && !responseData.SaveStatus) {
                            SetIsFetched(0, 0, "");
                            modelAlert(responseData.response);

                        } else {
                            SetIsFetched(0, 0, "");
                            modelAlert(responseData.response.message);

                        }


                });

            }
        });
        }
        else if (pageName.toLocaleLowerCase() == 'patientpanelapproval.aspx' && Typ == 1) {
            serverCall('../Common/CommonService.asmx/IsSmartCardCheck', { PanelID: $("#ddlPanelCompany").val().split('#')[0] }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.IsSmartCard == 0) {
                    modelAlert("Change Panel,This Panel Is Not For Smart Card.");
                    return false;
                }
                else {
                    if ($.trim($('#lblPatientID').text()) == '') { modelAlert("Select The Patient "); return; }

                    serverCall('../OPD/Services/CardIntigration.asmx/GetMemberDetailsIpd', { PatientID: $.trim($('#lblPatientID').text()), PanelId: $("#ddlPanelCompany").val().split('#')[0] }, function (response) {
                        var responseData = JSON.parse(response);

                        if (responseData.status && responseData.SaveStatus) {

                            SetIsFetchedIpd(1, responseData.response.content[0].benefits[0].amount, responseData.response.content[0].policy_id, responseData.response.content[0].member_name);

                            openBeneFitModel(responseData.response.content[0].benefits)


                        } else if (responseData.status && !responseData.SaveStatus) {
                            SetIsFetchedIpd(0, 0, "", "");
                            modelAlert(responseData.response.message);

                        } else {
                            SetIsFetchedIpd(0, 0, "", "");
                            modelAlert(responseData.response);
                        }


                    });

                }
            });
        }
       
    } 
    function SetIsFetched(Typ,Amt,CardNumber) {

        if (Typ == 1) {
            $("#lblisDataFetch").text(1);
            $("#lblCardNumber").text(CardNumber);
            $("#txtPolicyNO").val(CardNumber);


        } else {
            $("#lblisDataFetch").text(0);
            $("#lblApprovedAmount").text(0);

            $("#lblPoolNr").text(0);
            $("#lblPoolName").text("");

            $("#lblCardNumber").text("");
            $("#lblCardNumber").hide();
            $(".cardfetch").hide();
        }

    }
    function SetIsFetchedIpd(Typ, Amt, CardNumber,CardHolderName) {

        if (Typ == 1) {
            $("#txtCardHolderName").val(CardHolderName);

            $("#txtPolicyNO").val(CardNumber);
            $("#lblisDataFetchIpd").text(1);
            $(".cardfetch").hide();


            if ($.trim(CardHolderName) != "") {
                $("#txtCardHolderName").attr("disabled", "disabled");
            } else {
                $("#txtCardHolderName").removeAttr("disabled", "disabled");
            }

            $("#txtPolicyNO").attr("disabled", "disabled");

        } else {
            $("#lblisDataFetchIpd").text(0);
            $("#txtCardHolderName").val("");
            $("#txtPanelApprovalAmount").val("");         
            $("#txtPolicyNO").val("");

            $(".cardfetch").hide();

            $("#txtCardHolderName").removeAttr("disabled", "disabled");
            $("#txtPanelApprovalAmount").removeAttr("disabled", "disabled");
            $("#txtPolicyNO").removeAttr("disabled", "disabled");
           

        }



    }
</script>
<div id="divParentPanelUserControl" class="divParentPanelUserControl">
    <div class="row">
        <span style="display: none" id="spnPanelControlPanelAdvanceAmount">0</span>
        <div class="col-md-3">
            <label class="pull-left">Panel Group</label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <select id="ddlPanelGroup" title="Select Panel Group" onchange="$onPanelGroupChange(this)"></select>
        </div>
        <div class="col-md-3">
            <label class="pull-left">Panel </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <select id="ddlPanelCompany" onchange="$onPanelChange(this)" title="Select Panel"  class="required"></select>
        </div>
          <div class="col-md-2" style="padding-left:0px;">
            <input type="button" id="btnAddMutiPanel" value="Add Panel" onclick="AddMultiPanel();" />
        </div>
        <div class="col-md-3" style="display:none">
            <label class="pull-left">Parent Panel     </label>
            <b class="pull-right">:</b>
        </div>
       <%-- <div class="col-md-5">
           
        </div>--%>
        
        <div class="col-md-5" style="display:none">
            <div class="row" style="margin: 0px;">
                <div class="col-md-24" style="padding-left: 0px; padding-right: 5px;">
                     <select id="ddlParentPanel" title="Select Parent Panel"></select>
                </div>
                
            </div>
        </div>

        <div class="col-md-3">
            <label id="lblIsSmartCard" style="display:none">0</label>
             <label id="lblIsManual" style="display:none">1</label>
            <label id="lblisDataFetch" style="display:none">0</label>          
             <input type="button" id="btnFetchData" value="Fetch Data" style="display:none" onclick="GetMemberDetails(0)"/>
             

             <label id="lblIsSmartCardIpd" style="display:none">0</label>
             <label id="lblIsManualIpd" style="display:none">0</label>
            <label id="lblisDataFetchIpd" style="display:none">0</label>          
             <input type="button" id="btnFetchDataIpd" value="Fetch Data" style="display:none" onclick="GetMemberDetails(1)"/>
             

        </div>
         

    </div>   

    
    <div class="row cardfetch" style="display:none">
        <div class="col-md-2">
            Pool No :
        </div>
        <div class="col-md-2">
            <label id="lblPoolNr" style="color: red">0</label>
        </div>
         <div class="col-md-3">
            Pool Name :
        </div>

        <div class="col-md-14">
            <label id="lblPoolName" style=" color: red"></label>
        </div>
           

        <div class="col-md-3 cardfetchAmt">
        Amount :  <label id="lblApprovedAmount" style="color: red">0</label>
            <label id="lblCardNumber" style="display: none; color: red">0</label>
        </div>


    </div>   
    <div style="display: none" class="row paneldetailRow">
        <div class="col-md-3">
            <label class="pull-left">Policy  No. </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5" style=" padding-right: 5px;">
            <input type="text" id="txtPolicyNO" disabled="disabled" allowcharscode="45" onlytextnumber="25" onkeyup="previewCountDigit(event,function(e){});" autocomplete="off" data-title="Enter Policy No.">
        </div>
        <div class="col-md-3">
            <label class="pull-left">Policy Card No. </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <input type="text" id="txtCardNo" allowcharscode="45" autocomplete="off" onlytextnumber="30" onkeyup="previewCountDigit(event,function(e){searchByCardNo(e);});" data-title="Enter Policy Card No.">
        </div>
        <div class="col-md-3">
            <label class="pull-left">Name On Card</label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <input type="text" id="txtCardHolderName" autocomplete="off" title="Enter Policy No.">
        </div>
    </div>
    <div style="display: none" class="row paneldetailRow">
        <div class="col-md-3">
            <label class="pull-left">Expire Date     </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <asp:TextBox ID="txtExpireDate" runat="server" ReadOnly="true" autocomplete="off" ClientIDMode="Static" ToolTip="Select Expire Date"></asp:TextBox>
            <cc1:CalendarExtender ID="CalendarExteDOB" TargetControlID="txtExpireDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
        </div>
        <div class="col-md-3">
            <label class="pull-left">Card Holder     </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <select id="ddlCardHolder" title="Select Card Holder">
                <option value="self">Self</option>
                <option value="self">Father</option>

            </select>
        </div>
        <div class="col-md-3">
            <label class="pull-left" id="lblApprovalAmount" >Approval Amount     </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <input id="txtPanelApprovalAmount" type="text" onlynumber="10" />
        </div>
    </div>

   <div class="row" style="display:none">
        <div class="col-md-3" >
            <label class="pull-left">Corporate</label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5" >
            <select id="ddlPanelCorporate" title="Select Corporate"></select>
        </div>
         <div class="col-md-3 Document">
            <label class="pull-left">Document's</label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5 Document">
            <button id="btnPanelDocument" onclick="openPanelDocumentModel(this);" type="button" style="box-shadow: none; width: 100%">
                <span id="spnPanelDocumentCounts" class="badge badge-grey">0</span>
                Panel Required Document's</button>
        </div>
    </div>

    <div style="display: none" class="row  paneldetailRow">
        
        <div class="col-md-3">
            <label class="pull-left" id="lblApprovalRemark" >Approval Remark </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-5">
            <input id="txtPanelApprovalRemark" type="text" />
        </div>

        <div class="col-md-3 Policy">
            <label for="IgnorePolicy" class="pull-left">Ignore  Policy     </label>
            <b class="pull-right">:</b>
        </div>
        <div class="col-md-2 Policy" style="">
            <select onchange="$ignorePolicyChange(this.value)" id="ddlIgnorePolicy" disabled="disabled">
                <option value="0">NO</option>
                <option value="1">Yes</option>
            </select>
        </div>
        <div class="col-md-8 Policy">
            <input type="text" id="txtIgnoreReason" disabled="disabled" errormessage="Please Enter Policy Ignore Reason" placeholder="Ignore Policy Reason" autocomplete="off" title="Enter Ignore Reason">
        </div>

        <div class="col-md-1 Policy" style="padding-left: 0px; padding-right: 0px; padding-top: 2px;">
            <label id="lblPanelRateCurrency" data-title="Panel Rate Currency" class="pull-left patientInfo"></label>
            <b class="">:</b>
        </div>

        <div class="col-md-2 Policy" style="padding-left: 0px; padding-right: 0px;">
            <input type="text" id="txtPanelRateCurrency" disabled="disabled" style="padding-left: 3px; color: blue;width:79px;" onlynumber="12" decimalplace="4" max-value="1000" onkeyup="changePanelCurrencyFactor(event);" class="patientInfo" />
        </div>

    </div>

    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-5"></div>
        <div class="col-md-3"></div>
        <div class="col-md-5"></div>
          <div class="col-md-3">
           
        </div>
        <div class="col-md-3">
            
        </div>
      

    </div>
    <div class="divParentPanelUserControl" id="divMultiPPanel">
          
                    <table id="tbMultiPanelSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%;" class="GridViewStyle" cellspacing="0">
                        <thead>
                        <tr>
                                       <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">DefaultPanel</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">PanelGroup</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">PanelName</th>
                  
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">PolicyNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Policy Card No</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Name Of Card</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">ExpiryDate</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Card Holder</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Approval Amount</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Approval Remark</th>
                            <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Remove</th>
                                      <th class="GridViewHeaderStyle" scope="col" style="text-align: center ;display:none">ParentPanel</th>
                            <th class="GridViewHeaderStyle" scope="col" style="text-align: center;display:none" >Corporate</th>
                        </tr>
                            </thead>
                        <tbody></tbody>

                    </table>
               

    </div>
</div>




<script type="text/javascript">

    var getPanelDocuments = function (callback) {
        var panel = $('#ddlPanelCompany').val().split('#');
        var _divPanelRequiredDocuments = $('#divPanelRequiredDocuments');
        _divPanelRequiredDocuments.html('');
        serverCall('../IPD/Services/AdvanceRoomBooking.asmx/GetPanelDocument', { panelID: panel[0] }, function (response) {
            var responseData = JSON.parse(response);
            $(responseData).each(function () {
                var temp = '<button onclick="onDocumentSelect(this)" id="' + this.DocumentID + '" class="panelDocumentButton" type="button">' + this.Document + '<span id="spnDocumentID" style="display:none" class="hidden">' + this.DocumentID + '</span><span id="spnDocumentBase64" style="display:none" class="hidden"></span><span id="spnDocumentName" style="display:none" class="hidden">' + this.Document + '</span></button>';
                _divPanelRequiredDocuments.append(temp);
            });
            callback(responseData);
        });
    }



    var closePanelDocumentModel = function () {
        $('#divPanelDocumentMaters').hideModel();
    }

    var onDocumentSelect = function (el) {
        var divPanelRequiredDocuments = $(el).closest('#divPanelRequiredDocuments');
        divPanelRequiredDocuments.find('button').removeClass('selectedDocument');
        $(el).addClass('selectedDocument');
        var documentID = Number($(el).find('#spnDocumentID').text());
        var showBtnDocumentIDs = [];
        showBtnDocumentIDs.push(Number(<%=Resources.Resource.Last2DaysOPDInvestigationDocumentID%>));
        showBtnDocumentIDs.push(Number(<%=Resources.Resource.Last2DaysOPDMedicineDocumentID%>));

        if (showBtnDocumentIDs.indexOf(documentID) > -1)
            $('#btnGetLastOPDTransactionImage').removeClass('hidden');
        else
            $('#btnGetLastOPDTransactionImage').addClass('hidden');

        createPanelDocumentPreview(function () { });
    }



    var onFileSelect = function (el) {
        var divPanelDocumentMaters = $('#divPanelDocumentMaters');
        var _flUpload = $('#divPanelDocumentMaters').find('#flUpload');
        var selectedDocument = divPanelDocumentMaters.find('.selectedDocument');
        if (selectedDocument.length < 1) {
            modelAlert('Please Select Document.', function () { });
            return false;
        }
        _flUpload.click();
    }



    var previewPanelDocument = function (fileInput) {
        var files = fileInput.files;
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            var img = document.getElementById("imgPanelDocumentPreview");
            img.file = file;
            var reader = new FileReader();
            reader.onload = (function (aImg) {
                return function (e) {
                    aImg.src = e.target.result;
                    $('.selectedDocument').find('#spnDocumentBase64').text(e.target.result);
                    createPanelDocumentPreview(function () { });
                    fileInput.value = null;
                };
            })(img);
            reader.readAsDataURL(file);
        }
    }

    var createPanelDocumentPreview = function () {
        getPanelUploadedDocuments(function (panelDocuments) {
            var previewImage = '';
            var isCurrent = panelDocuments.filter(function (d) {
                return (d.isCurrentSelected == true);
            });
            if (isCurrent.length > 0)
                previewImage = isCurrent[0].DocumentBase64;


            var img = document.getElementById("imgPanelDocumentPreview");
            img.src = previewImage;

            $('#spnPanelDocumentCounts').text(panelDocuments.length);

        });
    }

    var openPanelDocumentModel = function () {
        getPanelDocuments(function () {
            $('#divPanelDocumentMaters').showModel();
        });
    }

    var onPanelDocumentClear = function () {
        var selectedDocument = $('#divPanelRequiredDocuments').find('.selectedDocument');
        selectedDocument.removeClass('uplodedDocument');
        selectedDocument.find('#spnDocumentBase64').text('');
        createPanelDocumentPreview(function () { });
    }


    var getLastTwoDaysOPDTransaction = function () {
        serverCall('../Common/CommonService.asmx/GetLastTwoDaysOPDTransaction', {}, function (response) {
            var responseData = JSON.parse(response);
            lastTwoDaysOPDTransaction = responseData;
            var _temp = $('#template_OPDTransaction').parseTemplate(lastTwoDaysOPDTransaction);
            var divRenderOPDTransaction = $('#divRenderOPDTransaction');
            divRenderOPDTransaction.html(_temp);
            _createImage(function () { });
        });
    }


    var _createImage = function (callback) {
        var divRenderOPDTransaction = $('#divRenderOPDTransaction');
        html2canvas(divRenderOPDTransaction[0], {
            allowTaint: true,
            useCORS: true,
            taintTest: false,
            onrendered: function (canvas) {
                var _spnDocumentBase64 = $('.selectedDocument').find('#spnDocumentBase64');
                var isAlreadyExits = $.trim(_spnDocumentBase64.text());
                _spnDocumentBase64.text(canvas.toDataURL());
                createPanelDocumentPreview(function () { });
                callback();
            }
        });
    }

    var AddMultiPanel = function () {
        var PPanelID = $('#ddlPanelCompany').find("option:selected").val().split('#')[0];
        var IsDefaultPanel = 0;


        if ($('#ddlPanelCompany').val() == "0") {
            modelAlert('Kindly Select Panel');
            return;
        }
        if (checkDuplicatePanel(PPanelID)) {
            modelAlert('Selected Panel Already Added')
            return;
        }
        var PCorporateName = '', PCorporateID = '0';

        if ($('#ddlPanelCorporate').find("option:selected").text() != "Select") {
            varPCorporateName = $('#ddlPanelCorporate').find("option:selected").text();
            PCorporateID = $('#ddlPanelCorporate').find("option:selected").val();
        }


        data = [];
        data.push({
            IsDefaultPanel: IsDefaultPanel,
            PPanelID: PPanelID,
            PPanelGroup: $('#ddlPanelGroup').find("option:selected").text(),
            PPanelgroupID: $('#ddlPanelGroup').find("option:selected").val(),
            PPanelName: $('#ddlPanelCompany').find("option:selected").text(),
            PParentPanel: $('#ddlParentPanel').find("option:selected").text(),
            PParentPanelId: $('#ddlParentPanel').find("option:selected").val(),
            PCorporateName: PCorporateName,
            PCorporateID: PCorporateID,
            PPolicyNo: $('#txtPolicyNO').val(),
            PCardNo: $('#txtCardNo').val(),
            PCardHolderName: $('#txtCardHolderName').val(),
            PExpiryDate: $('#txtExpireDate').val(),
            PCardHolderRelation: $('#ddlCardHolder').find("option:selected").text(),
            PApprovalAmount: $('#txtPanelApprovalAmount').val(),
            PApprovalRemarks: $('#txtPanelApprovalRemark').val(),

        });

        bindPatientPanelDetails(data);

        $('#txtPolicyNO').val('');
        $('#txtCardNo').val('');
        $('#txtCardHolderName').val('');
        $('#txtExpireDate').val('');
        $('#txtPanelApprovalAmount').val('');
        $('#txtPanelApprovalRemark').val('');
        $('#ddlCardHolder').val('Self');

    }

    function RemoveRows(rowid) {
        var URL = window.location.href.split('?')[0];
        var pageName = URL.split('/')[URL.split('/').length - 1];
        
        if ($('#txtPID').val() != "") {
            if (pageName.toLocaleLowerCase() == 'lab_prescriptionopd.aspx' || pageName.toLocaleLowerCase() == 'ipdadmissionnew.aspx' || pageName.toLocaleLowerCase() == 'emergencyadmission.aspx' || pageName.toLocaleLowerCase() == 'opdpharmacyissue.aspx') {
                modelAlert("You can not remove or edit any panel on this page");
                return false;

            }
        }
        $(rowid).closest('tr').remove();
        if ($('#tbMultiPanelSelected tbody').length == 0) {
            $('#tbMultiPanelSelected').hide();

        }



    }
    function CheckMultiSelect(rowid) {
        //    $('#tbMultiPanelSelected tr').each(function () { $(this).find('input[type=checkbox]').attr('checked', false); });
        var row = $(rowid).closest('tr');
        if ($(row).find('input[type=checkbox]').is(':checked')) {
            $(row).find('input[type=checkbox]').attr('checked', 'checked');
        }
    }
    function chkDefaultPanel(rowid) {

        if ($(rowid).is(':checked')) {
            $('#tbMultiPanelSelected tbody').each(function () { $(this).find('input[type=checkbox]').not($(rowid)).prop('checked', false); });
        }
    }


    function checkDuplicatePanel(PanelID) {
        var count = 0;
        $('#tbMultiPanelSelected tbody tr').each(function () {
            var item = $(this).find('#spnPPanelID').text().trim();
            if ($(this).find('#spnPPanelID').text().trim() == PanelID) {
                count = count + 1;
            }
        });
        if (count == 0)
            return false;
        else
            return true;
    }

    var $getMultiPanelPatientDetail = function (callback) {

        $MultiPanel = {};

        $MultiPanel.ppatientDetails = [];
        $('#tbMultiPanelSelected tbody tr').each(function (index, elem) {
            var $row = $(elem);
            $MultiPanel.ppatientDetails.push({
                IsDefaultPanel: $($row).find('input[type=checkbox]').is(':checked') ? '1' : '0',
                PPanelID: $($row).find('#spnPPanelID').text(),
                PPanelGroupID: $($row).find('#spnPPanelGroupID').text(),
                PParentPanelID: $($row).find('#spnPParentPanelID').text(),
                PPanelCorporateID: $($row).find('#spnPCorporateID').text(),
                PPolicyNo: $($row).find('#spnPPolicy').text(),
                PCardNo: $($row).find('#spnPCardNo').text(),
                PCardHolderName: $($row).find('#spnPCardHolderName').text(),
                PExpiryDate: $($row).find('#spnPExpiryDate').text(),
                PCardHolderRelation: $($row).find('#spnPCardHolderRelation').text(),
                PApprovalAmount: $($row).find('#spnPApprovalAmount').text(),
                PApprovalRemarks: $($row).find('#spnPApprovalRemarks').text(),
            });
        });
        callback($MultiPanel);
    };

    var bindPatientPanelDetails = function (data) {

        //$('#tbMultiPanelSelected tbody').empty();
        for (var i = 0; i < data.length; i++) {

            var j = $('#tbMultiPanelSelected tbody tr').length + 1;
            var row = '<tr>';
            if (data[i].IsDefaultPanel == 1)
                row += '<td><input type="checkbox" name="chkdefaultPanel" onchange="chkDefaultPanel(this);"  checked="checked"/></td>';
            else
                row += '<td><input type="checkbox" name="chkdefaultPanel" onchange="chkDefaultPanel(this);" /></td>';
            row += '<td class="GridViewLabItemStyle"  ><span id="spnPPanelGroup">' + data[i].PPanelGroup +
            '</span><span id="spnPPanelGroupID" style="display:none">' + data[i].PPanelgroupID +
            '</span></td>';
            row += '<td class="GridViewLabItemStyle" style="width:120px"><span id="spnPPanelName">' + data[i].PPanelName +
            '</span><span id="spnPPanelID" style="display:none" > ' + data[i].PPanelID + ' </span></td>';
            row += '<td style="display:none"><span id="spnPParentPanel"style="display:none" >' + data[i].PParentPanel +
            '</span><span id="spnPParentPanelID" style="display:none">' + data[i].PParentPanelId + '</span> </td>'
            row += '<td style="display:none"><span id="spnPCorporate" style="display:none" >' + data[i].PCorporateName +
            '</span><span id="spnPCorporateID" style="display:none">' + data[i].PCorporateID + '</span> </td>';
            row += '<td><span id="spnPPolicy" >' + data[i].PPolicyNo + '</span></td>';
            row += '<td> <span id="spnPCardNo">' + data[i].PCardNo + '</span></td>';
            row += '<td><span id="spnPCardHolderName" >' + data[i].PCardHolderName + '</span></td>';
            row += '<td><span id="spnPExpiryDate">' + data[i].PExpiryDate + '</span></td>';
            row += '<td><span id="spnPCardHolderRelation" >' + data[i].PCardHolderRelation + '</span></td>';
            row += '<td><span id="spnPApprovalAmount">' + data[i].PApprovalAmount + '</span></td>';
            row += '<td><span id="spnPApprovalRemarks" >' + data[i].PApprovalRemarks + '</span></td>';
            row += '<td><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td>';
            row += '</tr>';
            $('#tbMultiPanelSelected tbody').append(row);
        }
    }
</script>



<div id="divPanelDocumentMaters" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px;">
            <div class="modal-header">
                <button type="button" class="close" onclick="closePanelDocumentModel()" aria-hidden="true">×</button>
                <h4 class="modal-title">Panel Required Document's</h4>
            </div>
            <div class="modal-body" style="min-height:300px;">
                <div class="row">
                    <div class="col-md-8 panelDocumentModelBody">
                        <button type="button" style="width: 100%; font-size: 17px; box-shadow: none; background-color: cadetblue;"><strong>Panel Required Document's</strong></button>
                        <div id="divPanelRequiredDocuments"></div>
                    </div>
                    <div class="col-md-1 panelDocumentModelBody" style="background-color: lightgray; padding-right: 0px; padding-left: 0px; width: 5px;"></div>
                    <div class="col-md-15 panelDocumentModelBody" id="divPanelDocumentPreview">
                        <img src="" id="imgPanelDocumentPreview" style="width: 100%; height: 100%" alt="" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <input type="file" id="flUpload" accept="image/x-png,image/gif,image/jpeg,image/jpg,application/pdf" style="display:none" class="hidden" onchange="previewPanelDocument(this)" />
                <button type="button" style="display:none" class="hidden" id="btnGetLastOPDTransactionImage" onclick="getLastTwoDaysOPDTransaction()">Get Last 2 Days Transaction </button>
                <button class="save" type="button" onclick="onPanelDocumentClear(this)">Clear</button>
                <button class="save" type="button" onclick="onFileSelect(this)">Browse</button>
                <button type="button" class="save" onclick="closePanelDocumentModel()">Close</button>
                <%--<button type="button" onclick="_createImage()">ABCD</button>--%>
            </div>
        </div>
    </div>
</div>

<div style="width:0px;height:0px;overflow:auto">
<div  style="width:1096px" id="divRenderOPDTransaction">

</div>
    </div>
  <script id="template_OPDTransaction" type="text/html">
        <table  id="tableOPDTransaction" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle tableImageFontSize" scope="col" >Item Name</th>
            <th class="GridViewHeaderStyle tableImageFontSize" scope="col" style="width: 93px;" >Type</th>
            <th class="GridViewHeaderStyle tableImageFontSize" scope="col" style="width:80px" >Quantity</th>                    
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=lastTwoDaysOPDTransaction.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = lastTwoDaysOPDTransaction[j];
                #>          
                

                    <tr  style="background-color: white;" id="<#=j+1#>" >                            
                                                                         
                        
                        <td class="GridViewLabItemStyle textCenter tableImageFontSize" id="td2" style="max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.ItemName#></td>
                        
                        <td class="GridViewLabItemStyle textCenter tableImageFontSize" id="td4" style=""><#=objRow.TransType#></td> 
                        <td class="GridViewLabItemStyle textCenter tableImageFontSize" id="td5" style=""><#=objRow.Quantity#></td> 
                        </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>





<div id="divBenefitOfSmartCard" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px;">
            <div class="modal-header">
                <button type="button" class="close" onclick="closeBenefitOfSmartCardModel()" aria-hidden="true">×</button>
                <h4 class="modal-title">Benefit Of Smart Card To This Patient</h4>
            </div>
            <div class="modal-body" style="min-height:300px;">
                
                        <div id="DivSmartCardDetails" style="max-height: 300px; overflow-y: auto; overflow-x: hidden;">

                            <table id="tblSmartcardDetails" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                                <thead>
                                    <tr>
                                        <td class="GridViewHeaderStyle">SNo.</td>
                                        <td class="GridViewHeaderStyle">Select</td>
                                        <td class="GridViewHeaderStyle">BenefitID</td>
                                        <td class="GridViewHeaderStyle">Pool Nr </td>
                                        <td class="GridViewHeaderStyle">Pool Desc </td>
                                        <td class="GridViewHeaderStyle">Amount </td>                                        
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>



                        </div>


            </div>
            <div class="modal-footer">
                 
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    function openBeneFitModel(data) {
        BindBeneFitsData(data);
        $("#divBenefitOfSmartCard").showModel();
    }

    var closeBenefitOfSmartCardModel = function () {
        $('#divBenefitOfSmartCard').hideModel();
    }

    function BindBeneFitsData(data) {

        $('#tblSmartcardDetails tbody').empty();
        $.each(data, function (i, item) {

            var rows = "";
            rows += '<tr>';
            rows += '<td class="GridViewLabItemStyle" >' + (++i) + '</td>';

            rows += '<td class="GridViewLabItemStyle"  id="tbpoolnr"><input type="button" id="btnSelect"  value="Select" onclick="SelectSmartCardServices(this)" /></td>';

            rows += '<td class="GridViewLabItemStyle"  id="tbId">' + item.id + '</td>';

            rows += '<td class="GridViewLabItemStyle"  id="tbpool_nr">' + item.pool_nr + '</td>';

            rows += '<td class="GridViewLabItemStyle"  id="tbpool_desc">' + item.pool_desc + '</td>';

            rows += '<td class="GridViewLabItemStyle"  id="tbamount">' + item.amount + '</td>';


            rows += '</tr>';


            $('#tblSmartcardDetails tbody').append(rows);
        });

        $('#tblSmartcardDetails').show();


    }


    function SelectSmartCardServices(RowId) {
        var Pool_Nr = $(RowId).closest('tr').find("#tbpool_nr").text();
        var Pool_Desc = $(RowId).closest('tr').find("#tbpool_desc").text();
        var Amount = $(RowId).closest('tr').find("#tbamount").text();

        var URL = window.location.href.split('?')[0];
        var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();


        if (pageName.toLocaleLowerCase() == 'patientpanelapproval.aspx') {
            $("#lblPoolNr").text(Pool_Nr);
            $("#lblPoolName").text(Pool_Desc);

            $("#txtPanelApprovalAmount").val(Amount);
            $("#txtPanelApprovalAmount").attr("disabled", "disabled");

            closeBenefitOfSmartCardModel();
            $(".cardfetch").show();
            $(".cardfetchAmt").hide();
        } else {

            $("#lblPoolNr").text(Pool_Nr);
            $("#lblPoolName").text(Pool_Desc);
            $("#lblApprovedAmount").text(Amount);
            closeBenefitOfSmartCardModel();
            $(".cardfetch").show();
        }


    }



</script>

