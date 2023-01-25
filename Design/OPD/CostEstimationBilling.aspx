<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CostEstimationBilling.aspx.cs" Inherits="Design_OPD_CostEstimationBilling" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/OldPatientSearch.ascx" TagName="wuc_OldPatientSearch"
    TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style  type="text/css">
        .selectedRow {
            background-color: aqua !important;
        }
    </style>


    <script type="text/javascript">
        $(document).ready(function () {
            $('input').keyup(function () {
                if(event.keyCode == 13)
                    if($(this).val() != "")
                        $patientSearchOnButtonClick();
            })
                $commonJsInit(function () {
                    $pageInit(function () {
                        $bindDoctor('ALL', function () {
                            $bindRoomType(function () {
                                $bindPanel(function () {
                                    $bindPackage(function () {
                                        $bindSurgery(function () {
                                            $BindEstimationByDefault(function () {
                                            });
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
        });

        $pageInit = function (callBack) {
            $('#txtICDCode').autocomplete({
                source: function (request, response) {
                    $bindICDCode(request.term, function (r) {
                        response(r);
                    });
                },
                select: function (e, i) {
                },
                focus: function (e, i) {
                    // console.log(i);
                },
                close: function (el) {
                  //  el.target.value = i.item.val;
                },
                minLength: 2
            });
            callBack(true);
        }

        $bindDoctor = function (department, callBack) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callBack(true);
            });
        }
        var $bindRoomType = function (callBack) {
            serverCall('CostEstimationBilling.aspx/BindRoomType', {}, function (response) {
                RoomType = $('#ddlRoomType');
                RoomType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'IPDCaseType_ID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                callBack(true);
            });
        }
        var $bindDefaultRoomType = function () {
            serverCall('CostEstimationBilling.aspx/BindRoomType', {}, function (response) {
                DRoomType = $('#ddlDRoomType');
                DRoomType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'IPDCaseType_ID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
            });
        }

        var $bindPanel = function (callBack) {
            serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
                Panel = $('#ddlPanel');
                Panel.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true, selectedValue: 'Select' });
                callBack(true);
            });
        }
        var $bindPackage = function (callBack) {
            serverCall('CostEstimationBilling.aspx/BindIPDPackage', {}, function (response) {
                if (response != "") {
                    Package = $('#ddlPackage');
                    Package.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemID', textField: 'PackageName', isSearchAble: true, selectedValue: 'Select' });
                    callBack(true);
                }
                else { callBack(true); }
            });
        }
        var $bindSurgery = function (callBack) {
            serverCall('CostEstimationBilling.aspx/BindSurgery', {}, function (response) {
                Surgery = $('#ddlSurgery');
                Surgery.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Surgery_ID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                callBack(true);
            });
        }
        var $bindICDCode = function (ICDCode, callBack) {
            serverCall('CostEstimationBilling.aspx/BindICDDetail', { icdCode: ICDCode }, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.ICDCodeName,
                        val: item.ICD10_Code
                    }
                });
                callBack(responseData);
            });
        }

        var $BindEstimationByDefault = function () {
            serverCall('CostEstimationBilling.aspx/BindEstimationByDefault', {}, function (response) {
                EstimationData = JSON.parse(response);
                var outputEstimation = $('#tb_EstimationByDefault').parseTemplate(EstimationData);
                $('#dvDefaultEstimation').html(outputEstimation).customFixedHeader();
                $bindDefaultRoomType();
            });
        }
        var $BindPredefinedEstimationBill = function () {
            data = {
                packageID: $("#ddlPackage").val(),
                surgeryID: $("#ddlSurgery").val(),
                panelID: Number($.trim($("#ddlPanel").val())),
                doctorID: $("#ddlDoctor").val(),
                iCDCode: $("#txtICDCode").val(),
                roomType: $("#ddlRoomType").val(),
                limit: Number($.trim($("#txtNoOfBill").val())),
                fromDate: $("#txtFromDate").val(),
                toDate: $("#txtToDate").val()

            }
            serverCall('CostEstimationBilling.aspx/BindPredefinedEstimation', data, function (r) {
                PreEstimationData = JSON.parse(r);
                var outputPreEstimation = $('#tb_PredefinedEstimation').parseTemplate(PreEstimationData);
                $('#dvPredefinedEstimationBill').html(outputPreEstimation).customFixedHeader();
            });
        }
        var $bindPreEstimateCost = function (tId, billNo, callBack, selectedRow) {
            //alert(tId);

            $('#tablePredefinedEstimation tbody tr').removeClass('selectedRow');
            $(selectedRow).addClass('selectedRow');

            $("#spnBillNo").text('Bill No. : ' + billNo);
            $("#spnTransactionID").text(tId);

            serverCall('CostEstimationBilling.aspx/bindPreEstimateCost', { tID: tId }, function (response) {
                EstimationDataCost = JSON.parse(response);
                var outputEstimationCost = $('#tb_EstimationCost').parseTemplate(EstimationDataCost);
                $('#dvPredefinedEstimation').html(outputEstimationCost).customFixedHeader();
                $bindTotalEstimate(2, function () { });
            });
        }
        $showOldPatientSearchModel = function () {
            $('#oldPatientModel .modal-body').find('input[type=text]').not('#txtSearchModelFromDate,#txtSerachModelToDate').val('');
            $('#oldPatientModel').showModel();
        }

        var onEstimateBillingAmountChange = function (el, callback) {
            var value = Number(el.value);
            if (value > 0) {
                $(el).closest('tr').find('input[type=checkbox]').prop('checked', true);
            }
            else
                $(el).closest('tr').find('input[type=checkbox]').prop('checked', false);

            callback();
        }

        var onDefaultEstimatedBillingDepartmentSelationChange = function (el, type) {
            $bindTotalEstimate(type);
        }

        $bindTotalEstimate = function (type) {
            var TotalDefaultValue = Number($("#spnDefaultEstimate").text()), TotalPreAmount = Number($("#spnPreEstimate").text());
            if (Number(type) == 1) {
                TotalDefaultValue = 0;
                $("#tableEstimationByDefault tr").not(':first').each(function (i, r) {

                    if ($(r).find('#chkDSelect').prop('checked'))
                        TotalDefaultValue = parseFloat(TotalDefaultValue) + parseFloat(Number($(r).find('#txtAmount').val()));
                });
            }
            if (Number(type) == 2) {
                TotalPreAmount = 0;
                $("#tableEstimationCost tbody tr").each(function (i, r) {

                    if ($(r).find('#chkCSelect').prop('checked'))
                        TotalPreAmount = parseFloat(TotalPreAmount) + parseFloat(Number($(r).find('#tdCNetAmt').text()));

                });
            }
            var TotalEstimate = parseFloat(TotalPreAmount) + parseFloat(TotalDefaultValue);
            $("#spnPreEstimate").text(TotalPreAmount);
            $("#spnDefaultEstimate").text(TotalDefaultValue);
            $("#spnTotalEstimate").text(TotalEstimate);
        }
        $searchOldPatientDetail = function () {
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
                IDProof: '',
                MembershipCardNo: '',
                DOB: '',
                IsDOBChecked: '0',
                Relation: '',
                RelationName: '',
                IPDNO: $('#txtIPDNo').val(),
                panelID: '',
                cardNo: '',
                visitID: '',
                emailID: '',
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

        function showPage(_strPage) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var outputPatient = $('#tb_OldPatient').parseTemplate(OldPatient);
            $('#divSearchModelPatientSearchResults').html(outputPatient);
        }

        $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }

       onPatientSelect = function (elem) {
            $searchPatient({ PatientID: $.trim($(elem).closest('tr').find('#tdPatientID').text()), PatientRegStatus: 1 }, function (response) {
                $bindPatientDetails(response, function () { });
            });
        }

        $searchPatient = function (data, callback) {
            $patientSearchByPatientId(data, function (response) {
                callback(response);
            });
        }
        var $patientSearchByPatientId = function (data, callback) {
            if (data.PatientID != "") {
                serverCall('../Common/CommonService.asmx/PatientSearchByBarCode', data, function (response) {
                    $responseData = JSON.parse(response)
                    if ($responseData.length > 0)
                        callback($responseData[0]);
                });
            }
        }
        
        var $AddDRoomType = function (CatId,RoomTypeName) {
       //     alert(RoomTypeName);
            var IsAdd = 1;
            $('#tableEstimationByDefault tr').not(':first').each(function (index, row) {
                if ($.trim($(row).find('#tdCategoryName').text()) == RoomTypeName)
                    IsAdd=0;
            });

            var IsTotalEstimation = "'1'";
            if (IsAdd == 1) {
                rowNo = Number($("#tableEstimationByDefault tr").not(':first').length) + 1;

                $("#tableEstimationByDefault").append(" <tr onmouseover='this.style.color='#00F'' onMouseOut='this.style.color='''  id='" + CatId + "' style='cursor:pointer;background-color:lightyellow;'  >  " +
                " <td  class='GridViewLabItemStyle' id='tdSRNo' style='text-align:center;width: 25px;' >" + rowNo + "</td>  " +
                " <td class='GridViewLabItemStyle' id='td2' style='text-align:center;' ><input type='checkbox' checked='checked' class='DSelect' id='chkDSelect' onchange='onDefaultEstimatedBillingDepartmentSelationChange(this,1)' />  </td> " +

                " <td class='GridViewLabItemStyle' id='tdCategoryName' style='text-align:left; '>" + RoomTypeName + "</td> " +
                " <td class='GridViewLabItemStyle' id='tdRemarks' style='text-align:left; '> <input type='text' id='txtRemarks' title='Enter Remarks'/></td> " +
                " <td class='GridViewLabItemStyle' id='tdAmount' style='width:100px;text-align:center; '> <input id='txtAmount' onlynumber='10' decimalplace='3' max-value='10000000' onkeypress='$commonJsNumberValidation(event)' onkeydown='$commonJsPreventDotRemove(event)' onkeyup='onEstimateBillingAmountChange(this,function(){ $bindTotalEstimate(1,function(){})});' class='ItDoseTextinputNum' type='text' title='Enter Amount' /> </td> " +
                " <td class='GridViewLabItemStyle' id='tdCategoryID' style='display:none;'>" + CatId + "</td> " +
                " </tr> ");
            }

        }

        var patientSearchOnEnter = function (e) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (code == 13) {
                var data = { PatientID: '', PName: '', LName: '', ContactNo: '', Address: '', FromDate: '', ToDate: '', PatientRegStatus: 1, isCheck: '0', IDProof: '', MembershipCardNo: '', DOB: '', IsDOBChecked: 0, Relation: '', RelationName: '', IPDNO: '', panelID: '', cardNo: '', visitID: '', emailID: '' };
                if (e.target.id == 'txtBarcode')
                    data.PatientID = e.target.value;

                getOldPatientDetails(data, function (response) {
                    if (!String.isNullOrEmpty(response)) {
                        var resultData = JSON.parse(response);
                        if (resultData.length > 1) {
                            bindOldPatientDetails(response);
                            $showOldPatientSearchModel()
                        }
                        else {
                            $patientSearchByPatientId({ PatientID: resultData[0].MRNo, PatientRegStatus: 1 }, function (response) {
                                $bindPatientDetails(response, function () { });
                            });
                        }
                    }
                    else
                        modelAlert('No Record Found');
                });
            }
        }

        $patientSearchOnButtonClick = function () {
            var data = {
                PatientID: '',
                PName: '',
                LName: '',
                ContactNo: '',
                Address: '',
                FromDate: '',
                ToDate: '',
                PatientRegStatus: 1,
                isCheck: '0',
                IDProof: '',
                MembershipCardNo: '',
                DOB: '',
                IsDOBChecked: 0,
                Relation: '',
                RelationName: '',
                IPDNO: '',
                panelID: '',
                cardNo: '',
                visitID: '',
                emailID: ''
            };
            var $patientID = $('#txtMRNo');
            var $barcode = $('#txtBarcode');
            if ($patientID.val().trim() != '')
                data.PatientID = $patientID.val().trim();
            else if ($barcode.val().trim() != '') {
                data.PatientID = $barcode.val().trim();
            }
            else {
                modelAlert('Please Enter UHID');
                return;
            }

            getOldPatientDetails(data, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var resultData = JSON.parse(response);
                    if (resultData.length > 1) {
                        bindOldPatientDetails(response);
                        $showOldPatientSearchModel()
                    }
                    else {
                        $patientSearchByPatientId({ PatientID: resultData[0].MRNo, PatientRegStatus: 1 }, function (response) {
                            $bindPatientDetails(response, function () { });
                        });
                    }
                }
                else
                    modelAlert('No Record Found');
            });
        }

        $showItemDetailPoupup = function (Department,Category) {
            $('#dvItemDetailPopup .modal-content').find('#spnCDepartment').text(Department);
            $showItemDetails(Category);
            $('#dvItemDetailPopup').showModel();
        }
        $closetemDetailPopup = function () {
            $('#dvItemDetailPopup').hideModel();
        }
    
        var $showItemDetails = function (Category) {
            data = {
                TransID: $.trim($("#spnTransactionID").text()),
                CategoryId: $.trim(Category.split('#')[0]),
                ConfigID: $.trim(Category.split('#')[1])
            };

            serverCall('CostEstimationBilling.aspx/ShowItemDetails',data, function (r) {
                ItemDetails = JSON.parse(r);
                var outputItemDetails = $('#tb_ItemDetails').parseTemplate(ItemDetails);
                $('#dvCItemDetail').html(outputItemDetails).customFixedHeader();
            });
        }
        $getEstimationDetails = function (callback) {

            $PD = {};
            $PD.PatientId = $("#spnPatientID").text();
            $PD.PreEstimateAmount = Number($.trim($("#spnPreEstimate").text()));
            $PD.PreEstimateBillNo = $.trim($("#spnBillNo").text().split(':')[1]);
            $PD.PreEstimateTransactionID = $.trim($("#spnTransactionID").text());
            $PD.AdditionalAmount = Number($.trim($("#spnDefaultEstimate").text()));
            $PD.TotalEstimate = Number($.trim($("#spnTotalEstimate").text()));
            $PD.PatientName = $("#spnPName").text();
            $PD.Age = $.trim($("#spnAge").text().split('/')[0]);
            $PD.Gender = $.trim($("#spnAge").text().split('/')[1]);
            $PD.ContactNo = $("#spnContactNo").text();
            $PD.Address = $('#spnAddress').text();
            $PD.DateProcedure = $("#txtDateProcedure").val();
            $PD.Diagnosis = $.trim($("#txtDiagnosis").val());
            $PD.LengthOfStay = Number($("#txtLengthOfStay").val());
            $PD.Remarks = $('#txtFinalRemarks').val();

            $EB = [];
            $('#tableEstimationByDefault tr').not(':first').each(function (index, row) {
                if ($(row).find('#chkDSelect').prop('checked')) {
                    $EB.push({
                        DepartmentName: $.trim($(row).find('#tdCategoryName').text()),
                        Quantity: 1,
                        Amount: Number($.trim($(row).find('#txtAmount').val())),
                        Remarks: $.trim($(row).find('#txtRemarks').val()),
                        IsPreDefined: 0,
                        CategoryId: $.trim($(row).find('#tdCategoryID').text()),
                    });
                }
            });
            $('#tableEstimationCost tr').not(':first').each(function (index, row) {
                if ($(row).find('#chkCSelect').prop('checked')) {
                    $EB.push({
                        DepartmentName: $.trim($(row).find('#tdCDisplayName').text()),
                        Quantity: Number($.trim($(row).find('#tdCQty').text())),
                        Amount: Number($.trim($(row).find('#tdCNetAmt').text())),
                        Remarks: '',
                        IsPreDefined: 1,
                        CategoryId: $.trim($(row).find('#tdCCategory').text().split('#')[0]),
                    });
                }
            });

            if ($EB.length <= 0) {
                modelAlert('Please Select Atleast One Record', function () { });
                return false;
            }
            else
                callback({ PatientDetails: [$PD], Estimation: $EB });


        }
        $saveCostEstimationDetails = function (btnSave, callBack) {
            $getEstimationDetails(function (EstimationDetail) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('CostEstimationBilling.aspx/SaveCostEstimation', EstimationDetail, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status) {
                            window.open('../common/CostEstimationBill.aspx?sendAlert=1&CostEstimateNo=' + responseData.EstimationNumber);
                            window.location.reload();
                        }
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }
        var $bindPatientDetails = function (data, callback) {
            $("#spnPName").text(data.Title + ' ' + data.PFirstName);
            $("#spnPatientID").text(data.PatientID);
            $("#spnAge").text(data.Age + " / " + data.Gender);
            $("#spnContactNo").text(data.Mobile);
            $("#spnAddress").text(data.House_No + " " + data.City + " " + data.District);
            $("#dvPatient,#dvPreDefined,#dvDefault,#dvCommand,#dvTotalEst,#divAddInfo").show();
            $closeOldPatientSearchModel();
            callback(true);
        }
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Cost Estimate Billing<br />
            </b>
            <asp:Label ID="lblUserID" runat="server" ClientIDMode="Static" Style="display: none;" />
        </div>
        <div class="POuter_Box_Inventory" id="dvSearchingCriteria">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><strong>Barcode</strong></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBarcode" maxlength="20" data-title="Enter UHID" autocomplete="off" onkeyup="patientSearchOnEnter(event)" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtMRNo"  maxlength="20" data-title="Enter UHID" autocomplete="off"/>
                        </div>
                        <div class="col-md-4">
                              <input type="button" id="btnSearch" class="pull-left ItDoseButton" onclick="$patientSearchOnButtonClick();" value="Search" title="Click To Search" />
                        </div>
                        <div class="col-md-4" style="text-align:right;">
                            <input type="button" id="btnOldPatient" class="pull-left ItDoseButton" value="Old Patient Search" title="Click To Search Old Patient" onclick="$showOldPatientSearchModel()" style="display: <%=GetGlobalResourceObject("Resource", "OldPatientLink") %>" />
                        </div>
           </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvPatient" style="display: none">
            <div class="Purchaseheader">
                Patient Details
            </div>
            <div class="row">

                <div class="col-md-21">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPatientID" class="pull-left ItDoseLabelBl"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnPName" class="pull-left ItDoseLabelBl"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Age / Sex</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnAge" class="pull-left ItDoseLabelBl"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Contact No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnContactNo" class="pull-left ItDoseLabelBl"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <span id="spnAddress" class="pull-left ItDoseLabelBl"></span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="display: none" id="dvPreDefined">
              <div class="Purchaseheader" >
               Searching Criteria for Estimation Billing
            </div>
            <div class="row">
                <div class="col-md-24">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Panel</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <select id="ddlPanel" title="Select Panel"></select>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Doctor</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <select id="ddlDoctor" title="Select Doctor"></select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Room Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlRoomType" title="Select Room Type"></select>
                </div>
          </div>
              <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Package</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <select id="ddlPackage" title="Select Package"></select>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Surgery</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <select id="ddlSurgery" title="Select Surgery"></select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">ICD Code</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <input type="text" id="txtICDCode" data-title="Enter ICD 10 Code Text" />
                </div>
          </div>
             <div class="row">
                <div class="col-md-3 ">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                     <asp:TextBox runat="server" ID="txtFromDate" ClientIDMode="Static"></asp:TextBox>
                     <cc1:CalendarExtender ID="CalendarExteFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                 </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <asp:TextBox runat="server" ID="txtToDate" ClientIDMode="Static"></asp:TextBox>
                   <cc1:CalendarExtender ID="CalendarExtenderToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>
                   <div class="col-md-3">
                    <label class="pull-left">No. Of Bill</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <input type="text" id="txtNoOfBill" onlynumber="4" value="10" autocomplete="off" data-title="Enter No. Of Bill" />
                </div>
          </div>
          <div class="row">
               <div class="col-md-24 textCenter">
                <input type="button" id="btnAlreadyPrescribe" value="Search" class="save margin-top-on-btn" title="Click To Save" onclick="$BindPredefinedEstimationBill();" />
               </div>
         </div>
          <div class="row">
              <div id="dvPredefinedEstimationBill" style="max-height:100px; overflow:auto;"></div>
          </div>
                </div>
                </div>
        </div>
        <div class="POuter_Box_Inventory textCenter" style="display: none" id="dvDefault">  
             <div class="row" >
                <div class="col-md-12">
                  <div class="Purchaseheader">
                     Additional Estimation Billing
                  </div>
                  <div id="dvDefaultEstimation" style="max-height:180px; overflow:auto;" ></div>
                </div>
                <div class="col-md-12">
                  <div class="Purchaseheader">
                     Pre Estimation Billing <span id="spnBillNo" style="text-align:right;margin-left:180px;"></span> <span id="spnTransactionID" style="display:none;"></span>
                  </div>
                  <div id="dvPredefinedEstimation" style="max-height:180px; overflow:auto;" ></div>
                 </div>
              </div>
            </div>
        <div class="POuter_Box_Inventory textCenter" id="dvTotalEst" style="display:none;">
          <div class="row patientInfo" style="font-weight:bold">
              <div class="col-md-2"></div>
               <div class="col-md-20">
                   <div class="row">
                        <div class="col-md-4 ">
                              <label class="pull-left">Additional Estimate</label>
                              <b class="pull-right">:</b>   
                        </div>
                        <div class="col-md-4" style="text-align:left;">
                              <span id="spnDefaultEstimate" >0</span>
                        </div>
                        <div class="col-md-4">
                                <label class="pull-left">Pre Estimate</label>
                                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4" style="text-align:left;">
                                 <span id="spnPreEstimate" >0</span>
                        </div>
                        <div class="col-md-4">
                                   <label class="pull-left">Total Estimate</label>
                                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4" style="text-align:left;">
                            <span id="spnTotalEstimate" >0</span>
                        </div>
                   </div>
               </div>
          <div class="col-md-2"></div>
        </div>
    </div>

    <div class="POuter_Box_Inventory textCenter" id="divAddInfo" style="display:none;">
          <div class="row" style="font-weight:bold">
               <div class="col-md-24">
                   <div class="row">
                        <div class="col-md-3 ">
                              <label class="pull-left">Date Procedure</label>
                              <b class="pull-right">:</b>   
                        </div>
                        <div class="col-md-5" style="text-align:left;">
                             <asp:TextBox runat="server" ID="txtDateProcedure" ClientIDMode="Static"></asp:TextBox>
                             <cc1:CalendarExtender ID="cdDateProcedure" TargetControlID="txtDateProcedure" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                                <label class="pull-left">Length Of Stay</label>
                                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="text-align:left;">
                               <input type="text" id="txtLengthOfStay" onlynumber="5" autocomplete="off" title="Enter Length Of Stay" />
                        </div>
                        <div class="col-md-3">
                                   <label class="pull-left">Diagnosis</label>
                                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="text-align:left;">
                            <textarea id="txtDiagnosis"  class="customTextArea"  data-title="Enter Diagnosis"></textarea>
                        </div>
                   </div>
                      <div class="row">
                        <div class="col-md-3 ">
                              <label class="pull-left">Remarks</label>
                              <b class="pull-right">:</b>   
                        </div>
                        <div class="col-md-21" style="text-align:left;">
                              <textarea id="txtFinalRemarks"  class="customTextArea"  data-title="Enter Remarks"></textarea>
                        </div>
                   </div>
               </div>
        </div>
    </div>
    <div class="POuter_Box_Inventory textCenter" style="display: none" id="dvCommand">
            <input type="button" id="btnSave" value="Save" class="save margin-top-on-btn" title="Click To Save" onclick="$saveCostEstimationDetails(this);" />
    </div>
       <div id="dvItemDetailPopup" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 600px;">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closetemDetailPopup()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Department :&nbsp;<span id="spnCDepartment" class="patientInfo" ></span></h4>
                </div>
                <div class="modal-body">
                    <div style="max-height: 200px; overflow:auto; min-height:150px;" class="row">
                        <div id="dvCItemDetail" class="col-md-24"></div>
                    </div>
                      </div>
                <div class="modal-footer">
                </div>
                </div>
            </div>
            </div>
        <div id="oldPatientModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 900px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="$closeOldPatientSearchModel()" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Old Patient Search</h4>
                </div>
                <div class="modal-body">
                     
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">UHID</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">

                            <input type="text" id="txtSearchModelMrNO" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">IPD No.</label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" onlynumber="10" autocomplete="off" id="txtIPDNo" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">First Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" onlytext="50" id="txtSearchModelFirstName" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Last Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" onlytext="50" id="txtSearchModelLastName" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Contact No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" onlynumber="10" id="txtSerachModelContactNo" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Address</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" id="txtSearchModelAddress" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtSearchModelFromDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtSearchModelFromDate" TargetControlID="txtSearchModelFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtSerachModelToDate" runat="server" ReadOnly="true" ClientIDMode="Static" ToolTip="Select DOB"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtSerachModelToDate" TargetControlID="txtSerachModelToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div style="text-align: center" class="row">
                        <button type="button" onclick="$searchOldPatientDetail()">Search</button>
                    </div>
                    <div style="height: 200px" class="row">
                        <div id="divSearchModelPatientSearchResults" class="col-md-24"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: orange" class="circle"></button>
                    <b style="float: left; margin-top: 5px; margin-left: 5px">Admited Patients</b>
                    <button type="button" onclick="$closeOldPatientSearchModel()">Close</button>
                </div>
            </div>
        </div>
    </div>
   </div>
      <script id="tb_PredefinedEstimation" type="text/html">
        <table  id="tablePredefinedEstimation" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="TrPHeader">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;width: 10px;"  >S/No.</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">IPDNo</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">Patient Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">Mobile</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">Age</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; display:none;">Gender</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">RoomType</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Doctor Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Panel Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">BillNo</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">BillDate</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Bill Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">TransactionID</th>
                </tr>
            </thead>
            <tbody>
            <#                       
                var dataLength=PreEstimationData.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = PreEstimationData[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" ondblclick="$bindPreEstimateCost('<#=objRow.TransactionID#>','<#=objRow.BillNo#>',function(){},this);" style='cursor:pointer;' id="<#=j+1#>" >                                                            
                    <td  class="GridViewLabItemStyle" id="tdPSRNo"style="text-align:center;width: 10px;" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdPIPDNo" style="text-align:center; display:none;" ><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPPatientName" style="text-align:left; display:none;" ><#=objRow.PatientName#></td>
                    <td class="GridViewLabItemStyle" id="tdPMobile" style="text-align:left; display:none;" ><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" id="tdPAge" style="text-align:left; display:none;" ><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" id="tdPGender" style="text-align:left; display:none;" ><#=objRow.Gender#></td>
                    <td class="GridViewLabItemStyle" id="tdPRoomType" style="text-align:left;" ><#=objRow.RoomType#></td>
                    <td class="GridViewLabItemStyle" id="tdPDoctorName" style="text-align:left;" ><#=objRow.DoctorName#></td>
                    <td class="GridViewLabItemStyle" id="tdPPanelName" style="text-align:left;" ><#=objRow.PanelName#></td>
                    <td class="GridViewLabItemStyle" id="tdPBillNo" style="text-align:center;" ><#=objRow.BillNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPBillDate" style="text-align:center;" ><#=objRow.BillDate#></td>
                    <td class="GridViewLabItemStyle" id="tdPBillAmount" style="text-align:center;" ><#=objRow.BillAmount#></td>
                    <td class="GridViewLabItemStyle" id="tdPTransactionID" style="width:80px;display:none"><#=objRow.TransactionID#></td>                         
                </tr>            
            <#}#>
            </tbody>      
        </table>
         </script>
      <script id="tb_EstimationByDefault" type="text/html">
        <table  id="tableEstimationByDefault" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="TrHeader">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;width: 10px;"  >S/No. </th>
                      <th class="GridViewHeaderStyle" scope="col" style="text-align:center;"> <input type="checkbox" id="chkDSelectAll" onchange="DSelectAll(this);" /></th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Department</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Remarks</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;; width:100px;">Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">CategoryID</th>
                </tr>
            </thead>
            <#           
                var dataLength=EstimationData.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = EstimationData[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''"  id="<#=objRow.CategoryID#>" 
                    <#if(objRow.ConfigID=="2"){#> style='cursor:pointer;background-color:pink;' <#} else {#> style='cursor:pointer;' <#} #> >                                                            
                    <td  class="GridViewLabItemStyle" id="tdSRNo"style="text-align:center;width: 25px;" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="td2" style="text-align:center;" >
                        <input type="checkbox" class="DSelect" id="chkDSelect" <#if(objRow.ConfigID=="2"){#>  style='display:none' <#} #> onchange="onDefaultEstimatedBillingDepartmentSelationChange(this,1)" />

                    </td>
                    <td class="GridViewLabItemStyle" id="tdCategoryName" style="text-align:left;" ><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="tdRemarks" style="text-align:left;" >
                         <input type="text" id="txtRemarks" title="Enter Remarks" <#if(objRow.ConfigID=="2"){#>  style='display:none' <#} #> />

                       <#if(objRow.ConfigID=="2"){#> <select id="ddlDRoomType" title="Select Room Type" onchange="$AddDRoomType('<#=objRow.CategoryID#>',$('#ddlDRoomType option:selected').text())" style="z-index:1000000000"></select> <#} #>

                    </td>
                    <td class="GridViewLabItemStyle" id="tdAmount" style="text-align:center; width:100px; " >
                        <input id="txtAmount" onlynumber="10" decimalplace="3" max-value="10000000" onkeypress="$commonJsNumberValidation(event)" 
                            onkeydown="$commonJsPreventDotRemove(event)" onkeyup="onEstimateBillingAmountChange(this,function(){ $bindTotalEstimate(1,function(){})});" class="ItDoseTextinputNum" type="text" title="Enter Amount" 
                           <#if(objRow.ConfigID=="2"){#>  style='display:none' <#} #> /> 
                     </td>     
                    <td class="GridViewLabItemStyle" id="tdCategoryID" style="width:80px;display:none"><#=objRow.CategoryID#></td>                         
                </tr>             
            <#}#>   
        </table>
         </script>

      <script id="tb_EstimationCost" type="text/html">
        <table  id="tableEstimationCost" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="TrCHeader">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;width: 25px;"  >S/No. </th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;width: 10px;">  <input type="checkbox" checked="checked" id="chkCSelectAll" onchange="CSelectAll(this);" /> </th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Department</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center; width:100px;">Amount</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">CategoryID</th>
                </tr>
            </thead>
            <tbody>
            <#           
                var dataLength=EstimationDataCost.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = EstimationDataCost[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color=''" style='cursor:pointer;' id="<#=j+1#>"  ondblclick="$showItemDetailPoupup('<#=objRow.DisplayName#>','<#=objRow.Category#>',function(){});"  >                                                            
                    <td  class="GridViewLabItemStyle" id="tdCSNo"style="text-align:center;width: 25px;" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="td1" style="text-align:center;width: 10px;" ><input type="checkbox" class="CSelect" checked="checked" id="chkCSelect" onchange="onDefaultEstimatedBillingDepartmentSelationChange(this,2)" /></td>
                    <td class="GridViewLabItemStyle" id="tdCDisplayName" style="text-align:left;" ><#=objRow.DisplayName#></td>
                    <td class="GridViewLabItemStyle" id="tdCQty" style="text-align:center;" ><#=objRow.Qty#></td>
                     <td class="GridViewLabItemStyle" id="tdCNetAmt" style="text-align:right;" ><#=objRow.NetAmt#>&nbsp;&nbsp;</td>   
                    <td class="GridViewLabItemStyle" id="tdCCategory" style="width:80px;display:none"><#=objRow.Category#></td>                         
                </tr>            
            <#}#>
            </tbody>      
        </table>
         </script>
   
      <script id="tb_OldPatient" type="text/html">
        <table  id="tablePatient" cellspacing="0" rules="all" border="1" style="width:876px;border-collapse :collapse;">
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
                if(_EndIndex>dataLength){           
                   _EndIndex=dataLength;
                }

                for(var j=_StartIndex;j<_EndIndex;j++)
                {           
                    var objRow = OldPatient[j];
            #>              
                <tr onmouseover="this.style.color='#00F'"  onMouseOut="this.style.color=''" id="<#=j+1#>" ondblclick="onPatientSelect(this);" style='cursor:pointer;<#=objRow.IPDDetails!=''?'background-color:orange':'' #>'>                            
                    <td class="GridViewLabItemStyle">
                        <a class="btn" onclick="onPatientSelect(this);" style="cursor:pointer;padding:0px;font-weight:bold;width:60px">
                            Select
                            <span style="display:none" id="spnIPDDetails"><#=objRow.IPDDetails#></span>
                            <span style="display:none" id="spnAdvRoomBookingDetails"><#=objRow.AdvRoomBookingDetails#></span>
                        </a>
                    </td>                                                    
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
            <#}#>
            </tbody>      
        </table>  
        <table id="tablePatientCount" style="border-collapse:collapse;margin-top:6px">
                <tr>
                <# if(_PageCount>1) {
                    for(var j=0;j<_PageCount;j++){ #>
                    <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
                <#  }         
                } #>
                </tr>     
        </table>  
    </script>

     <script id="tb_ItemDetails" type="text/html">
        <table  id="tableItemDetails" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
            <thead>
                <tr id="Tr1">
                    <th class="GridViewHeaderStyle" scope="col"style="text-align:center;width: 25px;"  >S/No. </th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:left;">Item Name</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:center;">Qty</th>
                    <th class="GridViewHeaderStyle" scope="col" style="text-align:right; width:100px;">Amount&nbsp;&nbsp;</th>
                </tr>
            </thead>
            <tbody>
            <#           
                var dataLength=ItemDetails.length;
                for(var j=0;j<dataLength;j++)
                {           
                    var objRow = ItemDetails[j];
            #>              
                <tr onmouseover="this.style.color='#00F'" onMouseOut="this.style.color='' " style='cursor:pointer;' id="Tr2" >                                                            
                    <td  class="GridViewLabItemStyle" id="td3"style="text-align:center;width: 25px;" ><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="td5" style="text-align:left;" ><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="td6" style="text-align:center;" ><#=objRow.Quantity#></td>
                    <td class="GridViewLabItemStyle" id="td7" style="text-align:right;" ><#=objRow.Amount#>&nbsp;&nbsp;</td>                           
                </tr>            
            <#}#>
          </tbody>      
        </table>
      </script>

      <script type="text/javascript">
          function DSelectAll(id) {
              if (id.checked)
                  $(".DSelect").attr("checked", true);
              else
                  $(".DSelect").attr("checked", false);


              $bindTotalEstimate(1);
          }
          function CSelectAll(id) {
              if (id.checked)
                  $(".CSelect").attr("checked", true);
              else
                  $(".CSelect").attr("checked", false);

              $bindTotalEstimate(2);
          }
    </script>
    </span>
</asp:Content>

