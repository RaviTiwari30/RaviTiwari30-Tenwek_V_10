<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EMG_Services.aspx.cs" Inherits="Design_Emergency_EMG_Services" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <style type="text/css">
        .ui-state-focus {
            /*background: none !important;*/
            background-color: #c6dff9 !important;
            border: none !important;
        }

        .ui-menu-item {
            width: 370px;
            max-width: 370px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .ui-widget-content {
            border-radius: 5px;
        }
    </style>




    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">
        var EmergencyPatientDetails = [];
        var UserRights = [];
        $(document).ready(function () {
            $bindDoctor(function () {
                $bindCategory(function () {
                    $bindUserRights(function () {
                        $EMGNo = "<%=Request.QueryString["EMGNo"].ToString()%>";
                        serverCall('../Emergency/Services/EmergencyBilling.asmx/getEmergencyPatientDetails', { EmergencyNo: $EMGNo }, function (response) {
                            if (jQuery.parseJSON(response) == null)
                                location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Shifted To IPD.'
                            else {
                                EmergencyPatientDetails = jQuery.parseJSON(response)[0];
                                if (UserRights.CanEditCloseEMGBilling == "0") {
                                    if (EmergencyPatientDetails.Status == 'OUT')
                                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released.'
                                    else if (EmergencyPatientDetails.BillNo != '')
                                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Bill Has Been Generated.'
                                    else if (EmergencyPatientDetails.Status == "RFI")
                                        location.href = '../IPD/PatientBillMsg.aspx?msg=Patient Has Been Released for IPD.'
                                    //else
                                    //    $('#ddlDoctor').chosen('destroy').val(EmergencyPatientDetails.DoctorID).chosen();
                                }
                            }
                        });
                        $onInit();
                    });
                });
            });
        });
        var $bindDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: 'All' }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
               // $ddlDoctor.bindDropDown({ defaultValue: localStorage.getItem("doctorid"), data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                $('#ddlDoctor').val(localStorage.getItem("doctorid")).trigger("chosen:updated");
                callback($ddlDoctor.val());
            });
        }

        $bindCategory = function (callback) {
            $labItem = '0';
            $ddlCategory = $('#ddlCategory');
            serverCall('../common/CommonService.asmx/BindCategory', { Type: $labItem }, function (response) {
                $ddlCategory.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'CategoryID', textField: 'Name', isSearchAble: true });
                $bindSubCategory($labItem, $ddlCategory.val(), function () {
                    callback($ddlCategory.val());
                });
            });
        }
        $bindSubCategory = function (labItem, categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            serverCall('../common/CommonService.asmx/BindSubCategory', { Type: labItem, CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });
                callback($subCategory.val());
            });
        }
        $onInit = function () {
            $('#txtSearch').autocomplete({
                source: function (request, response) {
                    $labItem = '0';
                    $categoryID = $('#ddlCategory').val();
                    $subCategoryID = $('#ddlSubCategory').val();
                    $searchType = $('#ddlSearchType').val();
                    $bindItems({ searchType: parseInt($searchType), prefix: request.term, Type: $labItem, CategoryID: $categoryID, SubCategoryID: $subCategoryID, itemID: '' }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    $validateInvestigation(i, 0, 0, 1, function () { });
                },
                focus: function (e, i) {
                    // console.log(i);
                },
                close: function (el) {
                    el.target.value = '';
                },
                minLength: 2
            });
        }
        $bindUserRights = function (callback) {

            serverCall('Services/EmergencyBilling.asmx/getEmergencyUserRights', {}, function (response) {
                UserRights = jQuery.parseJSON(response)[0];
                callback(true);
            });


        }
        $bindItems = function (data, callback) {
            serverCall('../common/CommonService.asmx/LoadOPD_All_ItemsLabAutoComplete', data, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.AutoCompleteItemName,
                        val: item.Item_ID,
                        isadvance: item.isadvance,
                        IsOutSource: item.IsOutSource,
                        ItemCode: item.ItemCode,
                        Type_ID: item.Type_ID,
                        LabType: item.LabType,
                        TnxTypeID: item.TnxType,
                        SubCategoryID: item.SubCategoryID,
                        sampleType: item.Sample,
                        TypeName: item.TypeName,
                        rateEditAble: item.RateEditable
                    }
                });
                callback(responseData);
            });

        }
        $validateInvestigation = function (investigation, IsUrgent, presceibedID, defaultQty, callback) {
            if ($('#tbSelected tbody tr td #spnItemID').filter(function () { return ($(this).text().trim() == investigation.item.val) }).length > 0) {
                modelAlert('Selected Item Already Added!', function () { $('#txtSearch').val('').focus(); });
                return;
            }
            $checkAlreadyPrescribe({ PatientID: EmergencyPatientDetails.PatientID, ItemID: investigation.item.val }, function (response) {
                if (response) {
                    investigation.item.IsUrgent = IsUrgent;
                    investigation.item.presceibedID = presceibedID;
                    investigation.item.defaultQty = defaultQty;
                    investigation.item.discountPercent = 0;
                    investigation.item.IsPanelWiseDiscount = 0;
                    investigation.item.coPaymentPercent = 0;
                    investigation.item.IsPayable = 0;
                    investigation.item.IsDiscountEnable = false,
                    $getItemRate(EmergencyPatientDetails.PanelID, investigation, function (investigationRateDetails) {
                        $addInvestigationRow(EmergencyPatientDetails.PanelID, investigation, investigationRateDetails, function () {
                            if (UserRights.CanViewRatesEMGBilling == 0)
                                $('.RateElement').hide();
                        });
                    });
                }
            });


        };
        $getItemRate = function (panelID, investigation, callback) {
            $PanelID = panelID;
            $ItemID = investigation.item.val;
            $TID = ''; ///add later
            $IPDCaseTypeID = '';///add later
            serverCall('../common/CommonService.asmx/bindLabInvestigationRate', { PanelID: $PanelID, ItemID: $ItemID, TID: $TID, IPDCaseTypeID: $IPDCaseTypeID, panelCurrencyFactor: 1 }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    callback(responseData[0]);
                }
                else
                    callback({ Rate: 0, ID: 0, ScheduleChargeID: 0, ItemCode: '', ItemDisplayName: '' });
            });
        }
        $addInvestigationRow = function (panelID, investigation, investigationRateDetails, callback) {
            $('#lblScheduleChargeID').text(investigationRateDetails.ScheduleChargeID);
            var ItemName = investigationRateDetails.ItemDisplayName;
            if (ItemName == "")
                ItemName = investigation.item.TypeName;
            var trStyle = '';
            if (investigation.item.IsOutSource == 1)
                trStyle = 'style = "background-color:aqua"';
            else
                if (investigationRateDetails.Rate < 1)
                    trStyle = 'style = "background-color:lightpink"';



            var defaultValue = 1;
            if (investigation.item.LabType.toLowerCase() != 'lab')
                defaultValue = 99;


            $investigationTr = "<tr id=" + investigation.item.val + " " + trStyle + ">";
            $investigationTr += "<td class='GridViewLabItemStyle'><span id='spnItemCode'>" + investigation.item.ItemCode + "</span></td>";
            $investigationTr += "<td style='' class='GridViewLabItemStyle' style='width:200px'><span id='spn_date'>" + $('#txtDate').val() + "</span></td>";
            $investigationTr += "<td  style='text-align:left; width:200px; max-width: 200px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;' class='GridViewLabItemStyle'>";
            $investigationTr += "<span data-title='" + investigation.item.TypeName + "'  id='spnItemName'>" + investigation.item.TypeName + "</span>";
            if (investigation.item.coPaymentPercent > 0)
                $investigationTr += "<br/> <div style='text-align: right;'  class='patientInfo'>Panel Co-Payment:" + investigation.item.coPaymentPercent + "%</div>"
            if (investigation.item.IsPayable == 1)
                $investigationTr += "<br/> <div style='text-align: right;' class='patientInfo'>Panel Non-Payable Item</div>"

            $investigationTr += "<span id='spnItemID' style='display:none'>" + investigation.item.val + "</span>";
            $investigationTr += "<span id='spnLabType' style='display:none'>" + investigation.item.LabType + "</span>";
            $investigationTr += "<span id='spnTnxTypeID' style='display:none'>" + investigation.item.TnxTypeID + "</span>";
            $investigationTr += "<span id='spnSubCategoryID' style='display:none'>" + investigation.item.SubCategoryID + "</span>";
            $investigationTr += "<span id='spnSampleType' style='display:none'>" + investigation.item.sampleType + "</span>";
            $investigationTr += "<span id='spnInvestigationID' style='display:none'>" + investigation.item.Type_ID + "</span>";
            $investigationTr += "<span id='spnPresceibed_ID' style='display:none'>" + investigation.item.presceibedID + "</span>";
            $investigationTr += "<span id='spnIsAdvance' style='display:none'>" + investigation.item.isadvance + "</span>";
            $investigationTr += "<span id='spnIsUrgent' style='display:none'>" + investigation.item.IsUrgent + "</span>";
            $investigationTr += "<span id='spnRateListID' style='display:none'>" + investigationRateDetails.ID + "</span>";
            $investigationTr += "<span id='spnIsOutSource' style='display:none'>" + investigation.item.IsOutSource + "</span>";
            $investigationTr += "<span id='spnIsPayable' style='display:none'>" + investigation.item.IsPayable + "</span>";
            $investigationTr += "<span id='spnCoPaymentPercent' style='display:none'>" + investigation.item.coPaymentPercent + "</span>";
            $investigationTr += "<span id='spnIsPanelWiseDiscount' style='display:none'>" + investigation.item.IsPanelWiseDiscount + "</span>";
            $investigationTr += "<span id='spnDiscountAmount' style='display:none'>" + (investigation.item.discountPercent > 0 ? (((investigation.item.defaultQty * investigationRateDetails.Rate) * investigation.item.discountPercent) / 100) : 0) + "</span>";
            $investigationTr += "<span id='spnRateItemCode' style='display:none'>" + investigationRateDetails.ItemCode + "</span><span id='spnItemDisplayName' style='display:none'>" + ItemName + "</span></td>";
            $investigationTr += "<td style='' class='GridViewLabItemStyle' style='width:200px'><input id='txtRemarks'   autocomplete='off'     type='text'/></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtRate'      onlynumber='10'   max-value='10000000'  autocomplete='off'       onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' onkeyup='$labItemRateQuantityDiscountChange(event)'    " + ((investigation.item.rateEditAble == 0 && investigationRateDetails.Rate > 0) ? 'disabled' : '') + "    type='text' style='padding:2px' value=" + investigationRateDetails.Rate + " class='ItDoseTextinputNum RateElement'/></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtQuantity'  onlynumber='10'   max-value='" + defaultValue + "' autocomplete='off'     onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' onkeyup='$labItemRateQuantityDiscountChange(event)'     type='text'  maxlength='4'   style='padding:2px'value=" + investigation.item.defaultQty + " class='ItDoseTextinputNum'/></td>";
            $investigationTr += "<td class='GridViewLabItemStyle' style='display:none'><input id='txtDiscount'  onlynumber='5'  decimalPlace='2' max-value='100'   autocomplete='off'      onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)' onkeyup='$labItemRateQuantityDiscountChange(event)' " + (investigation.item.discountPercent > 0 ? 'disabled' : '') + "    type='text'  class='ItDoseTextinputNum'  style='padding:2px' value=" + investigation.item.discountPercent + "  /></td>";
            $investigationTr += "<td class='GridViewLabItemStyle' style='display:none;'><input id='txtDiscountAmount'  autocomplete='off' type='text'  max-value='" + investigationRateDetails.Rate + "' onkeypress='$commonJsNumberValidation(event)' onkeyDown='$commonJsPreventDotRemove(event)'  onkeyup='$labItemRateQuantityDiscountChange(event)' " + (investigation.item.discountPercent > 0 ? 'disabled' : '') + "  class='ItDoseTextinputNum'  style='padding:2px' value='" + (investigation.item.discountPercent > 0 ? (((investigation.item.defaultQty * investigationRateDetails.Rate) * investigation.item.discountPercent) / 100) : 0) + "'  /></td>";
            $investigationTr += "<td class='GridViewLabItemStyle'><input id='txtAmount'  autocomplete='off'      disabled     type='text'  class='ItDoseTextinputNum RateElement'  style='padding:2px' value=" + investigationRateDetails.Rate + "  /></td>";
            $investigationTr += "<td style='text-align: center;' class='GridViewLabItemStyle'><input id='chkIsUrgent'  autocomplete='off' type='checkbox'  class='ItDoseTextinputNum'  style='padding:2px'  /></td>";
            $investigationTr += '<td class="GridViewLabItemStyle"><img ' + (investigation.item.val == '<%= Resources.Resource.CourierCharges_ItemId %>' ? 'style="display:none"' : '') + ' class="btn" alt=""' + 'src="../../Images/Delete.gif" onclick="$removeLabItems(this)"  /></td></tr>';
            $('#tbSelected tbody').append($investigationTr);
            $('#tbSelected tr td #txtDiscount').change();
            MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            $checkLength();
            callback(true);
        }
        $checkAlreadyPrescribe = function (data, callBack) {
            if (data.PatientID.trim() != '') {
                serverCall('../OPD/Services/LabPrescription.asmx/getAlreadyPrescribeItem', data, function (response) {
                    responseData = JSON.parse(response);
                    if (responseData != null && responseData != "") {
                        modelConfirmation('Do You Want To Prescribe Again  ?', 'This Investigation is Already Prescribed By ' + responseData[0].UserName + '</br> Date On ' + responseData[0].EntryDate, 'Prescribe Again', 'Cancel', function (response) {
                            if (response)
                                callBack(response);
                        });
                    }
                    else
                        callBack(true);
                });
            }
            else
                callBack(true);
        }
        $removeLabItems = function (elem) {
            $(elem).closest('tr').remove();
            $checkLength();
        };
        $checkLength = function () {
            if ($('#tbSelected tbody tr').length > 0)
                $('#divSelectedItem').show();
            else
                $('#divSelectedItem').hide();
        }
        $labItemRateQuantityDiscountChange = function (e) {
            var inputValueCode = (e.which) ? e.which : e.keyCode;
            if ([37, 38, 39, 40].indexOf(inputValueCode) < 0) {
                $row = $(e.target).parent().parent();
                $qty = Number($row.find('#txtQuantity').val());
                $rate = Number($row.find('#txtRate').val());
                $amount = $qty * $rate;
                $discountPrecent = Number($row.find('#txtDiscount').val());
                if (e.target.id == 'txtDiscountAmount') {
                    var discountAmount = Number(e.target.value);
                    $discountPrecent = ((discountAmount * 100) / $amount);
                    $row.find('#txtDiscount').val(precise_round($discountPrecent, 2));
                }
                $discountAmount = 0;
                if ($discountPrecent > 0)
                    $discountAmount = (($amount * $discountPrecent) / 100);

                if (e.target.id != 'txtDiscountAmount')
                    $($row).find('#txtDiscountAmount').val($discountAmount);

                $($row).find('#txtAmount').val(precise_round(($amount - $discountAmount), 2));
            }
        }

    </script>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Emergency Service Booking</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Search Criteria</div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Category
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlCategory" runat="server" ClientIDMode="Static"
                                    TabIndex="1" ToolTip="Select Category" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Subcategory
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSubCategory" runat="server" ClientIDMode="Static"
                                    TabIndex="2" ToolTip="Select Subcategory" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Doctor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="requiredField" ClientIDMode="Static"
                                    TabIndex="3" ToolTip="Select Doctor" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Search Item
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2" style="padding-right: 0px;">
                                <select id="ddlSearchType">
                                    <option value="1">Name</option>
                                    <option value="2">Code</option>
                                </select>
                            </div>
                            <div class="col-md-11">
                                <input type="text" id="txtSearch" title="Enter Search Text" />
                            </div>
                            <div class="col-md-3">
                             <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static"
                                  ReadOnly="true"></asp:TextBox>
                                 <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-5">
                                <input type="button" value="Add Prescription Services" class="pull-right" onclick="$openOldInvestigationModel(this)" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" id="divSelectedItem" style="display: none;">
                <div class="Purchaseheader">Selected Item</div>
                <div class="row">
                    <div class="col-md-24">
                        <div style="width: 100%; max-height: 200px; overflow-y: auto;">
                            <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse;" class="GridViewStyle">
                                <thead style="width: 100%">
                                    <tr id="LabHeader">
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Code</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Date</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">Item Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width:200px">Remarks</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Rate</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Qty.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none">Dis (%)</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none">Dis. Amt.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Amount</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">IsUrgent</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="width: 24px;"></th>
                                    </tr>
                                </thead>
                                <tbody style="width: 100%">
                                </tbody>
                            </table>
                        </div>

                    </div>

                </div>

            </div>


            <div class="POuter_Box_Inventory ">
                <div class="row">

                    <div class="col-md-8">
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: aqua" class="circle"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Out-Source</b>
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: lightpink" class="circle"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Zero-Rate</b>
                    </div>
                    <div class="col-md-8 textCenter">
                        <input type="button" id="btnSave" class="save" value="Save" onclick="$saveLabPrescription(this);" />
                    </div>
                    <div class="col-md-8"></div>

                </div>
            </div>

        </div>







        <div id="oldInvestigationModel" class="modal fade" >
            <div class="modal-dialog">
                <div class="modal-content" style="width: 760px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="oldInvestigationModel" aria-hidden="true">×</button>
                        <h4 class="modal-title">Prescription Services</h4>
                    </div>
                    <div class="modal-body">
                        <div style="height: 200px" class="row">
                            <div id="divInvetigationPrescription" style="max-height: 190px; overflow: auto" class="col-md-24">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: lightgreen" class="circle"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Done Investigations</b>
                        <button type="button" onclick="$addCPOEInvestigation($('#tblOldInvestigation'))">Add Services</button>
                        <button type="button" data-dismiss="oldInvestigationModel">Close</button>
                    </div>
                </div>
            </div>
        </div>




    </form>
</body>

<script type="text/javascript">


    $openOldInvestigationModel = function () {
        $serachOldInvestigationModel(function () {
            $('#oldInvestigationModel').showModel();
        });
    }



    $serachOldInvestigationModel = function (callback) {
        var data = {
            transactionID: '<%=  ViewState["transactionID"].ToString() %>'
        }
        serverCall('EMG_Services.aspx/BindInvestigation', data, function (response) {
            CPOEPrescripData = JSON.parse(response);
            var $template = $('#template_searchOldInvestigation').parseTemplate(CPOEPrescripData);
            $('#divInvetigationPrescription').html($template);
            callback(CPOEPrescripData);
        });
    }



    var $addCPOEInvestigation = function (tblOldInvestigation) {
        $checkedInvestigation = tblOldInvestigation.find('tbody input[type=checkbox]:checked');
        if ($checkedInvestigation.length > 0) {
            var investigations = [];
            $checkedInvestigation.parent().parent().each(function () {
                $data = JSON.parse($(this).find('#tdData').text());
                investigations.push({
                    IsOutSource: $data.IsOutSource,
                    ItemCode: $data.ItemCode,
                    LabType: $data.LabType,
                    SubCategoryID: $data.SubCategoryID,
                    TnxTypeID: $data.TnxType,
                    TypeName: $data.Typename,
                    Type_ID: $data.Type_id,
                    isadvance: $data.isadvance,
                    sampleType: $data.Sample,
                    val: $data.ItemID,
                    presceibedID: $data.PatientTest_ID,
                    IsUrgent: 0,
                    defaultQty: 1,
                    isMobileBooking: 0,
                    salesID: ''
                });
            });
            $addInvestigation(investigations);
        }
        else
            modelAlert('Please Select Investigation');

    }


    var getPatientBasicDetails = function (callback) {
        var data = {
            panelID: EmergencyPatientDetails.PanelID,
            patientTypeID: EmergencyPatientDetails.PatientTypeID,
            memberShipCardNo: EmergencyPatientDetails.MemberShipCardNo,
            patientID: EmergencyPatientDetails.PatientID,
            panelCurrencyFactor:1

        };

        callback(data);
    }


    var $addInvestigation = function (investigations) {
        var _temp = [];
        var prescribeInvestigationData = [];
        getPatientBasicDetails(function (patientDetails) {
            investigations.forEach(function (item) {
                _temp.push(serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', { itemID: item.val, panelID: patientDetails.panelID, patientTypeID: patientDetails.patientTypeID, memberShipCardNo: patientDetails.memberShipCardNo }, function (response) {
                    var discountCoPayment = JSON.parse(response)[0];
                    item.discountPercent = discountCoPayment.OPDPanelDiscPercent;
                    item.IsPanelWiseDiscount = discountCoPayment.OPDPanelDiscPercent > 0 ? 1 : 0;
                    item.coPaymentPercent = discountCoPayment.OPDCoPayPercent;
                    item.IsPayable = discountCoPayment.IsPayble;
                    prescribeInvestigationData.push({ investigation: { item: item }, discountCoPayment: discountCoPayment });
                }, { isReturn: true }));
            });
            $.when.apply(null, _temp).progress(function () {
                $modelBlockUI();
            }).done(function () {
                _temp = [];
                prescribeInvestigationData.forEach(function (item) {
                    _temp.push(serverCall('../OPD/Services/LabPrescription.asmx/getAlreadyPrescribeItem', { PatientID: patientDetails.patientID, ItemID: item.investigation.item.val }, function (response) {
                        var responseData = JSON.parse(response);
                        item.todayPrescribeDetails = responseData;
                    }, { isReturn: true }));
                });
                $.when.apply(null, _temp).done(function () {
                    _temp = [];
                    prescribeInvestigationData.forEach(function (item) {
                        _temp.push(serverCall('../common/CommonService.asmx/bindLabInvestigationRate', { PanelID: patientDetails.panelID, ItemID: item.investigation.item.val, TID: '', IPDCaseTypeID: '', panelCurrencyFactor: patientDetails.panelCurrencyFactor }, function (response) {
                            if (!String.isNullOrEmpty(response))
                                item.rateDetails = JSON.parse(response)[0];
                            else if (item.investigation.item.TnxTypeID == '16')
                                item.rateDetails = { Rate: item.investigation.item.Rate, ID: 0, ScheduleChargeID: 0, ItemCode: '', ItemDisplayName: '' };
                            else
                                item.rateDetails = { Rate: 0, ID: 0, ScheduleChargeID: 0, ItemCode: '', ItemDisplayName: '' };
                        }, { isReturn: true }));
                    });
                    $.when.apply(null, _temp).done(function () {
                        prescribeInvestigationData.forEach(function (i) {
                            var isAlreadyAdded = ($('#tbSelected tbody tr td #spnItemID').filter(function () { return ($(this).text().trim() == i.investigation.item.val) }).length == 0) ? true : false;
                            if (isAlreadyAdded) {
                                i.investigation.item.IsDiscountEnable = '<%=Util.GetInt(ViewState["IsDiscount"])%>' == '0' ? false : true,
                                $addInvestigationRow(patientDetails.panelID, i.investigation, i.rateDetails, function () { });
                            }
                                });
                                $modelUnBlockUI();
                                $('#oldInvestigationModel').hideModel();
                            });
                        });
                    });
                });
            }


</script>



 <script id="template_searchOldInvestigation" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOldInvestigation" style="width:100%;border-collapse:collapse;">
		<#if(CPOEPrescripData.length>0){#>

		<thead>
						   <tr  id='Header'>
								<th class='GridViewHeaderStyle'><input type='checkbox' id="chkAllOldInvestigation" onchange="$('#tblOldInvestigation tr td input[type=checkbox]').prop('checked',this.checked)" style="margin-left: 8px;" /></th>
								<th class='GridViewHeaderStyle'>S.No.</th>
								<th class='GridViewHeaderStyle'>Investigation</th>
								<th class='GridViewHeaderStyle'>Quantity</th>
								<th class='GridViewHeaderStyle'>Outsource</th>
								<th class='GridViewHeaderStyle'>Remarks</th>
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=CPOEPrescripData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{

		objRow = CPOEPrescripData[j];
		
		  #>
						<tr   
							<#if(objRow.IsIssue==1){#>
							   style="background-color: lightgreen;"
							<#}#>
							>
						<td id="td1" class="GridViewLabItemStyle" style="text-align:center"><input type="checkbox" onchange="$('#tblOldInvestigation tr td input[type=checkbox]:not(:checked)').length>0?$('#chkAllOldInvestigation').prop('checked',false):$('#chkAllOldInvestigation').prop('checked',true)" />  </td>
						<td id="tdIndex" class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
						<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=JSON.stringify(objRow)#></td>
						<td id="tdTypename" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Typename#></td>
						<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Quantity#></td>
						<td id="tdIsOutSource" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.IsOutSource==0?'No':'Yes'#></td>
						<td id="td2" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Remarks#></td>
						<td id="tdItemID" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRow.ItemID#></td>             
						</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>



<script>
    $saveLabPrescription = function (btn) {
        $getServiceItemDetails(function (response) {
            $(btn).attr('disabled', true).val('Submitting...');
            serverCall('Services/EmergencyBilling.asmx/SaveEmergencyServices', response, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status) {

                        window.location.reload();
                    }
                    else
                        $(btn).removeAttr('disabled').val('Save');

                });
            });
        });
    }
    $getServiceItemDetails = function (callback) {
        if ($('#ddlDoctor').val() == "0") {
            modelAlert('Please Select Doctor');
            return false;
        }
        $tbSelectedTrs = $('#tbSelected tbody tr').clone();
        var labitems = $($tbSelectedTrs);
        $LTD = [];
        $urgentTest = [];
        $(labitems).each(function (index, row) {
            $LTD.push({
                LedgerTransactionNo: EmergencyPatientDetails.LTnxNo,
                TransactionID: EmergencyPatientDetails.TID,
                IsAdvance: 0,
                ItemID: $(row).find('#spnItemID').text().trim(),
                Rate: Number($(row).find('#txtRate').val().trim()),
                Quantity: Number($(row).find('#txtQuantity').val().trim()),
                DiscAmt: 0,
                Amount: Number($(row).find('#txtAmount').val().trim()),
                DiscountPercentage: 0,
                SubCategoryID: $(row).find('#spnSubCategoryID').text().trim(),
                ItemName: $(row).find('#spnItemDisplayName').text().trim(),
                DoctorID: $('#ddlDoctor').val(),
                Type: $(row).find('#spnLabType').text().trim(),
                Type_ID: $(row).find('#spnInvestigationID').text().trim(),
                TnxTypeID: $(row).find('#spnTnxTypeID').text().trim(),
                sampleType: $(row).find('#spnSampleType').text().trim(),
                RateListID: $(row).find('#spnRateListID').text().trim(),
                IsOutSource: $(row).find('#spnIsOutSource').text().trim(),
                rateItemCode: $(row).find('#spnRateItemCode').text().trim(),
                CoPayPercent: $(row).find('#spnCoPaymentPercent').text().trim(),
                IPDCaseType_ID: EmergencyPatientDetails.IPDCaseType_ID,
                Room_ID: EmergencyPatientDetails.Room_Id,
                Remark: $(row).find('#txtRemarks').val().trim(),
                EntryDate: $(row).find('#spn_date').text().trim(),
            });
            $urgentTest.push({
                PatientTest_ID: $(row).find('#spnPresceibed_ID').text().trim(),
                isUrgent: ($(row).find('#chkIsUrgent').is(':checked')) ? 1 : 0,
            });
        });
        var zeroRateItems = $LTD.filter(function (i) {
            if (i.Rate == 0) {
                return i;
            }
        });
        var zeroQuantityItems = $LTD.filter(function (i) {
            if (i.Quantity == 0) {
                return i;
            }
        });
        if (zeroRateItems.length > 0) {
            modelAlert('Zero Rate Items Are Not Allow');
            return false;
        }

        if (zeroQuantityItems.length > 0) {
            modelAlert('Please Enter Valid Quantity');
            return false;
        }
        callback({ LTD: $LTD, PT: $urgentTest, CurrentAge: EmergencyPatientDetails.AgeSex.split('/')[0], PID: EmergencyPatientDetails.PatientID });
    }
</script>
</html>
