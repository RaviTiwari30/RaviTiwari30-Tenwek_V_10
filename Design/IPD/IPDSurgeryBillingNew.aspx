<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPDSurgeryBillingNew.aspx.cs" Inherits="Design_IPD_IPDSurgeryBillingNew" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />

    <form id="form1" runat="server">

        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>IPD Surgery Prescription</b>
                <br />
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" Style="display: none"></asp:TextBox>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" style="display: none"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display: none"></span>
                <span id="spnRoom_ID" style="display: none"></span>
                <span id="spnIPD_CaseTypeID" style="display: none"></span>
                <span id="spnReferenceCodeIPD" style="display: none"></span>
                <span id="spnPatientType" style="display: none"></span>
                <span id="spnScheduleChargeID" style="display: none"></span>
                <span id="spnGender" style="display: none"></span>
                <span id="spnPatientTypeID" style="display: none"></span>
                <span id="spnMembershipNo" style="display: none"></span>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Class</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-10">
                                <select id="ddlSurgeryClass" onchange="bindSurgeryItem(function(){})" tabindex="1"></select>
                            </div>
                            <div class="col-md-2">
                                <input type="button" value="Reset" onclick="onReset()" class="pull-left" />
                            </div>
                            <div class="col-md-9"></div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Surgery</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-10">
                                <input id="txtSurgery" tabindex="2" class="easyui-combogrid" style="width: 250px; height: 20px" data-options="
			                        panelWidth: 700,
			                        idField: 'ItemId',
			                        textField: 'TypeName',
                                    mode:'remote',                                       
			                        url: 'IPDSurgeryBillingNew.aspx?cmd=item',
                                    loadMsg: 'Serching... ',
			                        method: 'get',
                                    pagination:true,
                                    rownumbers:true,
                                    pageSize: 10,                                                  
                                    fit:true,
                                    border:false,   
                                    cache:false,  
                                    nowrap:true,                                                   
                                    emptyrecords: 'No records to display.',
                                    mode:'remote',
                                    onHidePanel: function(){ },
                                    onBeforeLoad: function (param) {
                                           var groupId= $('#ddlSurgeryClass').val();
                                           var ReferenceCode = $('#spnReferenceCodeIPD').text();
                                           param.ReferenceCode = ReferenceCode;
                                           param.groupId = groupId;    
                                    },
			                        columns: [[
                                        {field:'GroupName',title:'Class',width:100,align:'center'},
                     <%--                   {field:'Department',title:'Department',width:250,align:'center'},--%>
                                        {field:'SurgeryCode',title:'CPT Code',width:100,align:'center'},
				                        {field:'TypeName',title:'Surgery Name',width:400,align:'left'},
        		                        {field:'SurgeryRate',title:'Rate',width:100,align:'center'}
			                        ]],
                                     onSelect: function (index, row) {
                                       onSurgeryChange();
                                    },
			                        fitColumns: true
		                        " />
                            </div>
                            <div class="col-md-2">
                                <input type="button" value="Select" style="display: none;" onclick="onSurgeryChange()" class="pull-left" />
                            </div>
                            <div class="col-md-9">
                            </div>
                        </div>
                        <div class="row rowSurgeryDetail" style="display: none;">
                            <div class="col-md-3 ItDoseLblError">
                                <label class="pull-left">Surgery Name </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-12 patientInfo">
                                <span id="spnSurgeryName"></span>
                                <span id="spnSurgeryID" style="display: none;"></span>
                                <span id="spnGroupID" style="display: none;"></span>
                            </div>
                            <div class="col-md-2 ItDoseLblError">
                                <label class="pull-left">Class </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-2 patientInfo">
                                <span id="spnSurgeryClass"></span>
                            </div>
                            <div class="col-md-2 ItDoseLblError">
                                <label class="pull-left">Rate </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 patientInfo">
                                <span id="spnSurgeryRate"></span>
                            </div>
                        </div>
                        <div class="row rowSurgeryDetail" style="display: none;">
                            <div class="col-md-3">
                                <label class="pull-left">Item Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-10">
                                <select id="ddlSurgeryItem" onchange="onItemChange(function(){})" tabindex="3"></select>
                            </div>
                            <div class="col-md-12"></div>
                        </div>
                        <div class="row rowSurgeryDetail" style="display: none;">
                            <div class="col-md-3">
                                <label class="pull-left">Rate</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <input id='txtRate' tabindex="4" onkeyup="calculateItemNet()" onlynumber='14' decimalplace='4' max-value='10000000' autocomplete='off' type='text' class='requiredField' />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Additional(%)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <input id='txtAdditionalPer' tabindex="5" onkeyup="calculateItemNet()" onlynumber='10' decimalplace='4' max-value='100' autocomplete='off' type='text' value="0" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Disc.(%)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <input id='txtDiscountPer' tabindex="6" onkeyup="calculateItemNet()" onlynumber='100' decimalplace='4' max-value='100' autocomplete='off' type='text' value="0" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Net.Amt.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <span id="spnNetAmount" class="ItDoseLblError">0</span>
                            </div>
                        </div>
                        <div class="row rowSurgeryDetail" style="display: none;">
                            <div class="col-md-3">
                                <label class="pull-left">Co-Pay(%)</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <span id="spnCoPay" class="patientInfo"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Panel Non-Pay</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <span id="spnPayable" class="patientInfo"></span>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Is Panel Disc.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <span id="spnIsPanelDisc" class="patientInfo"></span>
                            </div>
                            <div class="col-md-6">
                            </div>
                        </div>
                        <div class="row rowSurgeryDoctor" style="display: none;">
                            <div class="col-md-3">
                                <label class="pull-left">Doctor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-10">
                                <select id="ddlDoctor" tabindex="7" class="requiredFiled"></select>
                            </div>
                            <div class="col-md-12"></div>
                        </div>
                        <div class="row divDiscountReason" style="display: none">
                            <div class="col-md-3">
                                <label class="pull-left">Dis.Reason</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-10">
                                <select id="ddlDiscountReason" tabindex="8" class="required"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Approve By</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <select id="ddlDiscountApproveBy" tabindex="9" class="required"></select>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory rowSurgeryDoctor" style="display: none;">
                <div class="Purchaseheader">
                    Doctor Notes
                </div>
                <div class="row">
                    <div class="col-md-3 patientInfo">
                        <label class="pull-left">
                            Type 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlType" onchange="bindTemplateContent(this);"></select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <CKEditor:CKEditorControl ID="txtTemplateContent" BasePath="~/ckeditor" TabIndex="10" ClientIDMode="Static" runat="server" EnterMode="BR"></CKEditor:CKEditorControl>
                    </div>
                </div>

            </div>
            <div class="POuter_Box_Inventory rowSurgeryDetail" style="display: none; text-align: center">
                <input type="button" value="Add" tabindex="11" onclick="addSelectedItem()" style="width: 100px; margin-top: 7px" class="pull-center" />
            </div>
            <div class="POuter_Box_Inventory divBilling" style="display: none">
                <div class="row">
                    <div class="col-md-24">
                        <div class="grdItemDetails">
                            <table id="tbSelectedItems" rules="all" border="1" style="border-collapse: collapse; display: none" class="GridViewStyle">
                                <thead style="width: 100%">
                                    <tr id="Header">
                                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">Item Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="text-align: left; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">Doctor Name</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="">Rate</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="">Add.(%)</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none;">Add.Amt</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none;">Disc.(%)</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="">Disc.Amt.</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none;">Scale Of Cost</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="">Disc.App.By</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="">Disc.Reason</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="">Co-Pay(%)</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="">Panel No-Payable</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none;">Is Panel Disc.</th>
                                        <th class="GridViewHeaderStyle" scope="col">Amount</th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                        <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                        <th class="GridViewHeaderStyle" scope="col" style=""></th>
                                    </tr>
                                </thead>
                                <tbody style="width: 100%" class="ItemBodyClass">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory divBilling" style="display: none">
                <div class="row">
                    <div class="col-md-4">
                        <label class="pull-left">
                            <span id="spnTotalAmountText" style="font-size: small; color: red; font-weight: bold;">Gross Amount</span>
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            <span id="spnGrossAmount" style="font-size: small; color: red; font-weight: bold;"></span>
                        </label>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            <span id="spntotaldiscount" style="font-size: small; color: red; font-weight: bold;">Discount Amount</span></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-2">
                        <label class="pull-left">
                            <span id="spnTotalDiscountAmount" style="font-size: small; color: red; font-weight: bold;"></span>
                        </label>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            <span id="Span1" style="font-size: small; color: red; font-weight: bold;">Net Amount</span></label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <label class="pull-left">
                            <span id="spnTotalNetAmount" style="font-size: small; color: red; font-weight: bold;"></span>
                        </label>
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory divBilling" style="display: none; text-align: center;">
                <input type="button" style="width: 100px; margin-top: 7px" id="btnSave" class="ItDoseButton" value="Save" tabindex="11" onclick="saveSurgery(this);" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Prescribed Surgery List
                </div>
                <div class="grdSurgeryDetails" style="max-height: 200px; width: 100%; overflow: auto">
                    <table id="tableSurgeryPrescribed" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col">Sr No.</th>
                                <th class="GridViewHeaderStyle" scope="col">Sugery Name</th>
                                <th class="GridViewHeaderStyle" scope="col">Issue Date</th>
                                <th class="GridViewHeaderStyle" scope="col">Amount</th>
                                <th class="GridViewHeaderStyle" scope="col">Package</th>
                                <th class="GridViewHeaderStyle" scope="col">User</th>
                                <th class="GridViewHeaderStyle" scope="col">Clearance Remarks</th>
                                <th class="GridViewHeaderStyle" scope="col">Clearance To OT</th>
                                <th class="GridViewHeaderStyle" scope="col">View</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>

                </div>
            </div>

            <div id="divSurgeryItemDetails" role="dialog" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 900px">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="divSurgeryItemDetails" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Surgery Name &nbsp;  &nbsp;: <span id="spnSeletedSurgeryName" class="patientInfo"></span>
                                <br />
                                Surgery Amount : <span id="spnSelectedSurAmount" class="patientInfo"></span></h4>
                        </div>
                        <div class="modal-body">
                            <div class="grdSurgeryItemDetails" style="max-height: 200px; width: 100%; overflow: auto">
                                <table id="tableSurgeryItemDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle" scope="col">Sr No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">Item Name</th>
                                            <th class="GridViewHeaderStyle" scope="col">Amount</th>
                                            <th class="GridViewHeaderStyle" scope="col">Is Package</th>
                                            <th class="GridViewHeaderStyle" scope="col">Doctor Name</th>
                                            <th class="GridViewHeaderStyle" scope="col">User</th>
                                            <th class="GridViewHeaderStyle" scope="col">Issue Date</th>
                                            <th class="GridViewHeaderStyle" scope="col">Doctor Notes</th>
                                            <th class="GridViewHeaderStyle" scope="col">Remove</th>
                                            <th class="GridViewHeaderStyle" scope="col" style="display: none;"></th>
                                        </tr>
                                    </thead>
                                    <tbody class="billedItemBodyCls">
                                    </tbody>
                                </table>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" data-dismiss="divSurgeryItemDetails">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="divPatientConsentDetails" role="dialog" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 900px">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="divPatientConsentDetails" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Patient Consent Details</h4>
                        </div>
                        <div class="modal-body">
                            <div class="grdPatientConsentDetails" style="max-height: 200px; width: 100%; overflow: auto">
                                <table id="tablePatientConsentDetails" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle" scope="col">S/No.</th>
                                            <th class="GridViewHeaderStyle" scope="col">UHID</th>
                                            <th class="GridViewHeaderStyle" scope="col">Patient Name</th>
                                            <th class="GridViewHeaderStyle" scope="col">Date</th>
                                            <th class="GridViewHeaderStyle" scope="col">Type</th>
                                            <th class="GridViewHeaderStyle" scope="col">Print</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    </tbody>
                                </table>

                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" data-dismiss="divPatientConsentDetails">Close</button>
                        </div>
                    </div>
                </div>
            </div>

            <div id="divConsentData" role="dialog" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 900px">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="divConsentData" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Doctor Notes</h4>
                        </div>
                        <div class="modal-body">
                            <div class="divDoctorNotesData" style="max-height: 500px; width: 100%; overflow: auto; text-align: center;">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" data-dismiss="divConsentData">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $(function () {
                shortcut.add('ALT+S', function () {
                    onSurgeryChange();
                }, addShortCutOptions);
                shortcut.add('ALT+A', function () {
                    addSelectedItem();
                }, addShortCutOptions);
                bindHashCode();
                bindSurgeryClass(function () {
                    bindDoctor(function () {
                        bindPatientDetail(function () {
                            bindDiscReason(function () {
                                bindApprovedMaster(function () {
                                    bindType(function () {
                                        bindPrescribedSurgery(function () {
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });


            var bindType = function (callback) {
                var $ddlType = $("#ddlType");
                serverCall('Services/IPDSurgeryNew.asmx/BindType', {}, function (response) {
                    $ddlType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });
                    callback($ddlType.val());

                });
            }

            var bindTemplateContent = function (e) {
               // debugger;
                var content = $(e).val();
                if (content == "0")
                    content = "";
                //   CKEDITOR.instances['txtTemplateContent'].setData('');
                CKEDITOR.instances['txtTemplateContent'].setData(content);
            }
            function bindHashCode() {
                jQuery('#txtHash').val('');
                jQuery.ajax({
                    url: "../Common/CommonService.asmx/bindHashCode",
                    data: '{}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        jQuery('#txtHash').val(result.d);
                    },
                    error: function (xhr, status) {
                    }
                });
            }
            var bindSurgeryClass = function (callback) {
                var $ddlSurgeryClass = $('#ddlSurgeryClass');
                serverCall('Services/IPDSurgeryNew.asmx/BindSurgeryClass', {}, function (response) {
                    $ddlSurgeryClass.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'GroupID', textField: 'GroupName', isSearchAble: false });
                    callback($ddlSurgeryClass.val());
                });
            }
            var bindSurgeryItem = function (callback) {
                var $ddlSurgeryItem = $('#ddlSurgeryItem');
                serverCall('Services/IPDSurgeryNew.asmx/BindSurgeryItem', { classId: Number($("#ddlSurgeryClass").val()) }, function (response) {
                    $ddlSurgeryItem.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemID', textField: 'TypeName', isSearchAble: false });
                    callback($ddlSurgeryItem.val());
                });
            }
            var bindDoctor = function (callback) {
                var $ddlDoctor = $('#ddlDoctor');
                serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: "ALL" }, function (response) {
                    $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                    callback($ddlDoctor.val());
                });
            }
            var bindDiscReason = function (callback) {
                var $ddlDiscountReason = $('#ddlDiscountReason');
                serverCall('../Common/CommonService.asmx/GetDiscReason', { Type: 'IPD' }, function (response) {
                    $ddlDiscountReason.bindDropDown({ defaultValue: '', selectedValue: '', data: JSON.parse(response), valueField: 'DiscountReason', textField: 'DiscountReason', isSearchAble: false });
                    callback($ddlDiscountReason.find('option:selected').text());
                });
            }
            var bindApprovedMaster = function (callback) {
                var $ddlDiscountApproveBy = $('#ddlDiscountApproveBy');
                serverCall('../EDP/Services/EDP.asmx/bindDisAppoval', { ApprovalType: '', Type: '1' }, function (response) {
                    if (String.isNullOrEmpty(response))
                        response = '[]';
                    $ddlDiscountApproveBy.bindDropDown({ data: JSON.parse(response), valueField: 'ApprovalType', textField: 'ApprovalType', defaultValue: '', selectedValue: '' });
                    callback($ddlDiscountApproveBy.val());

                });
            }
            var bindPatientDetail = function (callback) {
                $('#spnPanelID,#spnIPD_CaseTypeID,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnReferenceCodeIPD,#spnScheduleChargeID,#spnPatientType,#spnGender,#spnPatientTypeID,#spnMembershipNo').text('');
                data = {
                    TID: $('#spnTransactionID').text(),
                    PID: $('#spnPatientID').text()
                }
                serverCall('Services/IPDSurgeryNew.asmx/BindPatientDetails', data, function (response) {
                    var data = JSON.parse(response);
                    if (data != "") {
                        $('#spnPanelID').text(data[0].PanelID);
                        $('#spnPatientID').text(data[0].PatientID);
                        //   $('#ddlDoctor').val(data[0].DoctorID).chosen('destroy').chosen();
                        $('#spnIPD_CaseTypeID').text(data[0].IPDCaseType_ID);
                        $('#spnReferenceCodeIPD').text(data[0].ReferenceCode);
                        $('#spnScheduleChargeID').text(data[0].ScheduleChargeID);
                        $('#spnPatientType').text(data[0].PatientType);
                        $('#spnGender').text(data[0].Gender);
                        $('#spnPatientTypeID').text(data[0].PatientTypeID);
                        $('#spnMembershipNo').text(data[0].MemberShipCardNo);
                        $('#spnRoom_ID').text(data[0].Room_ID);
                        callback(true);
                    }
                });
            }
            var onSurgeryChange = function () {
                $("#spnSurgeryID,#spnSurgeryName,#spnSurgeryClass,#spnSurgeryRate").text('');
                var selectedItem = $("#txtSurgery").combogrid('grid').datagrid('getSelected');
                if (String.isNullOrEmpty(selectedItem)) {
                    modelAlert('Please Select Surgery First', function () {
                        $('.textbox-text.validatebox-text').focus();
                        $(".rowSurgeryDetail").hide();
                        $("#txtSurgery").combogrid('reset');
                    });
                    return;
                }

                $("#spnSurgeryID").text(selectedItem.ItemId);
                $("#spnSurgeryName").text(selectedItem.TypeName);
                $("#spnSurgeryClass").text(selectedItem.GroupName);
                $("#spnSurgeryRate").text(selectedItem.SurgeryRate);
                $("#spnGroupID").text(selectedItem.GroupID);
                $("#txtSurgery").combogrid('reset');
                $(".rowSurgeryDetail").show();
            }
            var onItemChange = function () {
                var isDoctorCompulsory = 0;
                var rate = 0;
                var itemId = "0";
                var surgeryItem = $('#ddlSurgeryItem').val();
                if (surgeryItem != "0") {
                    if (Number(surgeryItem.split('#')[1]) == 1)
                        isDoctorCompulsory = 1;
                    rate = Number(surgeryItem.split('#')[2]);
                    itemId = surgeryItem.split('#')[0];
                }



                if (isDoctorCompulsory == 1)
                    $('.rowSurgeryDoctor').show();
                else
                    $('.rowSurgeryDoctor').hide();

                $("#txtRate").val(rate);
                $("#spnNetAmount").text(rate);
                getDiscountWithCoPay(itemId);
            }
            var getDiscountWithCoPay = function (itemId) {
                data = {
                    itemID: itemId,
                    panelID: Number($("#spnPanelID").text()),
                    patientTypeID: Number($("#spnPatientTypeID").text()),
                    memberShipCardNo: $.trim($("#spnMembershipNo").text())
                };
                serverCall('../common/CommonService.asmx/GetDiscountWithCoPay', data, function (response) {
                    var discountCoPayment = JSON.parse(response)[0];
                    $("#txtDiscountPer").val(discountCoPayment.IPDPanelDiscPercent);
                    $("#spnIsPanelDisc").text(discountCoPayment.IPDPanelDiscPercent > 0 ? "Yes" : "No");
                    $("#spnCoPay").text(discountCoPayment.IPDCoPayPercent);
                    $("#spnPayable").text(discountCoPayment.IsPayble > 0 ? "Yes" : "No");
                    if (discountCoPayment.IPDPanelDiscPercent > 0)
                        $("#txtDiscountPer").attr("disabled", true);
                    else
                        $("#txtDiscountPer").attr("disabled", false);


                    if (discountCoPayment.IPDPanelDiscPercent > 0 || discountCoPayment.IPDCoPayPercent == 1 || discountCoPayment.IsPayble == 1) {

                    }
                    else {
                    }

                    calculateItemNet();
                });
            }
            var addSelectedItem = function () {
                $("#spnErrorMsg").text("");
                var itemId = $("#ddlSurgeryItem").val();
                var itemName = $("#ddlSurgeryItem option:selected").text();
                var rate = Number($("#txtRate").val());
                var additionalPer = Number($("#txtAdditionalPer").val());
                var discPer = Number($("#txtDiscountPer").val());
                var additionalAmt = rate * additionalPer * 0.01;
                var discAmt = (rate + additionalAmt) * discPer * 0.01;
                var netAmt = precise_round((rate + additionalAmt - discAmt), 4);
                var isPanelDisc = $("#spnIsPanelDisc").text();
                var CoPayPer = $("#spnCoPay").text();
                var panelNonPayble = $("#spnPayable").text();
                var doctorId = $("#ddlDoctor").val();
                var doctorName = $("#ddlDoctor option:selected").text();
                if (itemId == "0") {
                    $("#ddlSurgeryItem").focus();
                    $("#spnErrorMsg").text("Please Select Item");
                    return;
                }

                if (($('#tbSelectedItems tbody tr #tdItemId').filter(function () { return ($(this).text().trim() == itemId.split('#')[0]) }).length > 0 && $('#tbSelectedItems tbody tr #tdDoctorId').filter(function () { return ($(this).text().trim() == doctorId) }).length > 0)) {
                    modelAlert('Selected Item Already Added with Same Doctor Under the Selected Surgery!');
                    return;
                }


                if (rate <= 0) {
                    $("#txtRate").focus();
                    $("#spnErrorMsg").text("Please Enter Valid Rate");
                    return;
                }
                if (Number(itemId.split('#')[1]) == 1 && doctorId == "0") {
                    $("#ddlDoctor").focus();
                    $("#spnErrorMsg").text("Please Select Doctor");
                    return;
                }

                if (discAmt > 0) {

                    if (String.isNullOrEmpty($('#ddlDiscountReason option:selected').text())) {
                        $("#spnErrorMsg").text("Please Select Discount Reason.");
                        $('#ddlDiscountReason').focus();
                        return false;
                    }

                    if (String.isNullOrEmpty($('#ddlDiscountApproveBy option:selected').text())) {
                        $("#spnErrorMsg").text("Please Select Approve By.");
                        $('#ddlDiscountApproveBy').focus();
                        return false;
                    }
                }

                var DoctorNotes = CKEDITOR.instances['txtTemplateContent'].getData();

                if (Number(itemId.split('#')[1]) == 1 && String.isNullOrEmpty(DoctorNotes)) {
                    $("#spnErrorMsg").text("Please Enter Doctor Notes.");
                    CKEDITOR.instances['txtTemplateContent'].focus();
                    return false;
                }

               // debugger;
              //  DoctorNotes = DoctorNotes.replace("<tbody>", "<tbdy_>");
                
                dataAlreadyPrescrived = {
                    transactionID: $.trim($('#spnTransactionID').text()),
                    itemID: itemId.split('#')[0],
                    surgeryID: $.trim($("#spnSurgeryID").text()),
                    doctorID: Number(itemId.split('#')[1]) == 1 ? doctorId : '0'
                }

                serverCall('Services/IPDSurgeryNew.asmx/validateAlreadyPrescrivedItemSelection', dataAlreadyPrescrived, function (response) {
                    var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                        modelAlert($responseData.response);
                        return;
                    }
                    else {
                        $itemTr = "<tr class='trItemCls' id=" + itemId.split('#')[0] + " >";
                        $itemTr += "<td id='tdItemName' class='GridViewLabItemStyle' style='text-align:left;' >" + itemName + "</td>";
                        $itemTr += "<td id='tdDoctorName' style='text-align:left;' class='GridViewLabItemStyle' >" + (Number(itemId.split('#')[1]) == 1 ? doctorName : '') + "</td>";
                        $itemTr += "<td id='tdRate' class='GridViewLabItemStyle' style='text-align:center;' >" + rate + "</td>";
                        $itemTr += "<td id='tdAdditionalPer' class='GridViewLabItemStyle' style='text-align:center;'>" + additionalPer + "</td>";
                        $itemTr += "<td id='tdAdditionalAmt' class='GridViewLabItemStyle' style='text-align:center;display:none;'>" + additionalAmt + "</td>";
                        $itemTr += "<td id='tdDiscPer' class='GridViewLabItemStyle' style='text-align:center;'>" + discPer + "</td>";
                        $itemTr += "<td id='tdDiscAmt' class='GridViewLabItemStyle' style='text-align:center;display:none;'>" + discAmt + "</td>";
                        $itemTr += "<td id='tdScaleOfCost' class='GridViewLabItemStyle' style='text-align:center;display:none;'>" + Number(itemId.split('#')[3]) + "</td>";
                        $itemTr += "<td id='tdDiscApprovedBy' class='GridViewLabItemStyle' style='text-align:center;'>" + $('#ddlDiscountApproveBy option:selected').text() + "</td>";
                        $itemTr += "<td id='tdDiscReason' class='GridViewLabItemStyle' style='text-align:center;'>" + $('#ddlDiscountReason option:selected').text() + "</td>";
                        $itemTr += "<td id='tdCoPayPer' class='GridViewLabItemStyle' style='text-align:center;'>" + CoPayPer + "</td>";
                        $itemTr += "<td id='tdPanelNonPayble' class='GridViewLabItemStyle' style='text-align:center;'>" + panelNonPayble + "</td>";
                        $itemTr += "<td id='tdIsPanelDisc' class='GridViewLabItemStyle' style='text-align:center;display:none;'>" + isPanelDisc + "</td>";
                        $itemTr += "<td id='tdNetAmt' class='GridViewLabItemStyle' style='text-align:center;'>" + netAmt + "</td>";
                        $itemTr += "<td id='tdItemId' class='GridViewLabItemStyle' style='display:none;'>" + itemId.split('#')[0] + "</td>";
                        $itemTr += "<td id='tdDoctorId' class='GridViewLabItemStyle' style='display:none;'>" + (Number(itemId.split('#')[1]) == 1 ? doctorId : '0') + "</td>";
                        $itemTr += "<td id='tdDoctorNotes' class='GridViewLabItemStyle' style='display:none;'>" + DoctorNotes + "</td>";
                        $itemTr += '<td class="GridViewLabItemStyle" style="padding-left:0px;"><img style="cursor:pointer" class="" alt=""' + 'src="../../Images/Delete.gif" onclick="removeSelectedItem(this)"  /></td></tr>';
                        $('#tbSelectedItems').find('.ItemBodyClass').append($itemTr);
                        itemtableShowHide();
                    }
                });

            }
            var removeSelectedItem = function (e) {
                $(e).closest('tr').remove();
                itemtableShowHide();
            }
            var itemtableShowHide = function () {
                if ($('#tbSelectedItems').find('.trItemCls').length > 0)
                    $('#tbSelectedItems,.divBilling').show();
                else
                    $('#tbSelectedItems,.divBilling').hide();

                calculateFinalNet();
                reset();
            }
            var calculateItemNet = function () {
                var rate = Number($("#txtRate").val());
                var additionalPer = Number($("#txtAdditionalPer").val());
                var discPer = Number($("#txtDiscountPer").val());
                var additionalAmt = rate * additionalPer * 0.01;
                var discAmt = (rate + additionalAmt) * discPer * 0.01;
                var netAmt = precise_round((rate + additionalAmt - discAmt), 4);

                $("#spnNetAmount").text(netAmt);
                if (discAmt > 0)
                    $(".divDiscountReason").show();
                else
                    $(".divDiscountReason").hide();
            }
            var reset = function () {
                $("#txtDiscountPer,#txtAdditionalPer,#txtRate").val('0');
                $("#spnNetAmount").text('0');
                $("#txtSurgery").focus();
                $("#ddlSurgeryItem").val('0');

            }
            var onReset = function () {
                window.location.reload();
            }
            var calculateFinalNet = function () {
                var totalNetAmount = 0;
                var totalDiscAmount = 0;
                $('#tbSelectedItems').find('.trItemCls').each(function () {
                    totalNetAmount = totalNetAmount + Number($(this).find('#tdNetAmt').text());
                    totalDiscAmount = totalDiscAmount + Number($(this).find('#tdDiscAmt').text());
                });

                var totalBillAmount = precise_round((totalNetAmount + totalDiscAmount), 4);
                $("#spnGrossAmount").text(totalBillAmount);
                $("#spnTotalDiscountAmount").text(precise_round(totalDiscAmount, 4));
                $("#spnTotalNetAmount").text(precise_round(totalNetAmount, 4));
            }
            var getBillData = function (callback) {
                $LTD = [];
                var discountApprovedBy = "";
                var discountReason = "";
                var totalNoOfRows = $('#tbSelectedItems').find('.trItemCls').length;
                if (totalNoOfRows == 0) {
                    modelAlert('Please Add Atleast One Item for Prescription..');
                    return;
                }
                $('#tbSelectedItems').find('.trItemCls').each(function () {
                    if (!String.isNullOrEmpty($.trim($(this).find('#tdDiscApprovedBy').text())) && !String.isNullOrEmpty(discountApprovedBy)) {
                        discountApprovedBy = $.trim($(this).find('#tdDiscApprovedBy').text());
                        discountReason = $.trim($(this).find('#tdDiscReason').text());
                    }

                  //  var doctorNote = $.trim($(this).find("#tdDoctorNotes").html()).replace("tbdy_", "tbody");
                  //  alert(doctorNote);
                    var itemDetails = {
                        ItemID: $.trim($(this).find('#tdItemId').text()),
                        Rate: Number($(this).find("#tdRate").text()),
                        Quantity: 1,
                        Amount: Number($(this).find("#tdNetAmt").text()),
                        DiscountPercentage: $.trim($(this).find("#tdDiscPer").text()),
                        DiscAmt: $.trim($(this).find("#tdDiscAmt").text()),
                        IsVerified: 1,
                        SubCategoryID: "",
                        ItemName: $.trim($(this).find("#tdItemName").text()),
                        scaleOfCost: Number($(this).find("#tdScaleOfCost").text()),
                        TransactionID: $('#spnTransactionID').text(),
                        DoctorID: $(this).find('#tdDoctorId').text(),
                        ConfigID: 22,
                        IsPayable: Number($(this).find("#tdPanelNonPayble").text() == "Yes" ? 1 : 0),
                        TotalDiscAmt: $.trim($(this).find("#tdDiscAmt").text()),
                        NetItemAmt: Number($(this).find("#tdNetAmt").text()),
                        IPDCaseType_ID: $('#spnIPD_CaseTypeID').text(),
                        RateListID: 0,
                        Room_ID: $.trim($('#spnRoom_ID').text()),
                        CoPayPercent: Number($(this).find("#tdCoPayPer").text()),
                        typeOfTnx: "IPD-Billing",
                        HSNCode: "",
                        IGSTPercent: 0,
                        CGSTPercent: 0,
                        SGSTPercent: 0,
                        GSTType: "",
                        isPanelWiseDisc: Number($(this).find("#tdIsPanelDisc").text() == "Yes" ? 1 : 0),
                        DiscountReason: $.trim($(this).find("#tdDiscReason").text()),
                        Surgery_ID: $("#spnSurgeryID").text(),
                        SurgeryName: $("#spnSurgeryName").text(),
                        DoctorNotes: $.trim($(this).find("#tdDoctorNotes").html()),

                    }
                    $LTD.push(itemDetails);
                });
                $LT = {
                    TypeOfTnx: "IPD-Billing",
                    GrossAmount: $('#spnGrossAmount').text(),
                    DiscountOnTotal: $('#spnTotalDiscountAmount').text(),
                    NetAmount: $('#spnTotalNetAmount').text(),
                    PatientID: $('#spnPatientID').text(),
                    RoundOff: 0,
                    TransactionID: $('#spnTransactionID').text(),
                    PanelID: $('#spnPanelID').text(),
                    UniqueHash: $('#txtHash').val(),
                    PatientType: $('#spnPatientType').text(),
                    DiscountApproveBy: discountApprovedBy,
                    DiscountReason: discountReason,
                }
                callback({ LT: [$LT], LTD: $LTD, PatientTypeID: Number($("#spnPatientTypeID").text()), MembershipNo: $.trim($("#spnMembershipNo").text()) });
            }
            var saveSurgery = function (btnSave) {
                // debugger;
                getBillData(function (billingDetails) {
                   // debugger;
                    $(btnSave).attr('disabled', true).val('Submitting...');
                    serverCall('Services/IPDSurgeryNew.asmx/SaveSurgeryBilling', billingDetails, function (response) {
                        var $responseData = JSON.parse(response);
                        modelAlert($responseData.response, function () {
                            if ($responseData.status) {
                                window.location.reload();
                            }
                            else
                                $(btnSave).removeAttr('disabled').val('Save');

                        });
                    });
                });
            }
            var bindPrescribedSurgery = function () {
                serverCall('Services/IPDSurgeryNew.asmx/BindPrescribedSurgery', { transactionID: $.trim($('#spnTransactionID').text()) }, function (response) {
                    //  debugger;
                    $('#tableSurgeryPrescribed tbody tr').remove();
                    responseData = JSON.parse(response);
                    if (responseData.length > 0) {
                        for (j = 0; j < responseData.length; j++) {
                            addNewRow(responseData[j].ItemName, responseData[j].IssueDate, responseData[j].Amount, responseData[j].Package, responseData[j].Name, responseData[j].IsOTClearance, responseData[j].LedgerTransactionNo, function () { });
                        }
                    }
                });
            }
            var addNewRow = function (ItemName, IssueDate, Amount, Package, Name, IsOTClearance, LedgerTransactionNo, callback) {
                var table = $('#tableSurgeryPrescribed tbody');
                var newRow = $('<tr onmouseover="this.style.color=#00F" onMouseOut="this.style.color="" id="<#=j+1#>" style="cursor:pointer;">');
                newRow.html(
                                  '</td><td class="GridViewLabItemStyle" id="tdSrNo" style="text-align:center;width:50px;">' + (table.find('tr').length + 1) +
                                  '</td><td class="GridViewLabItemStyle" id="tdItemName" style="text-align:center;" >' + ItemName +
                                  '</td><td class="GridViewLabItemStyle" id="tdIssueDate" style="text-align:center;" >' + IssueDate +
                                  '</td><td class="GridViewLabItemStyle" id="tdAmount" style="text-align:center;" >' + Amount +
                                  '</td><td class="GridViewLabItemStyle" id="tdPackage" style="text-align:center;" >' + Package +
                                  '</td><td class="GridViewLabItemStyle" id="tdName" style="text-align:center;" >' + Name +
                                  '</td><td class="GridViewLabItemStyle" id="tdRemarks" style="text-align:center;" ><input id="txtRemarks"   autocomplete="off" class="requiredField" type="text"/>' +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgRemove"><a href="JavaScript:void(0)"  onclick="onOTClearance(this,' + IsOTClearance + ',' + LedgerTransactionNo + ')" ><b>' + (IsOTClearance == 1 ? "Revert" : "Yes") + '</b></a>' +
                                  '</td><td class="GridViewLabItemStyle" id="tdView" style="text-align:center;" ><a href="JavaScript:void(0)"  onclick="bindSurgeryItems(' + LedgerTransactionNo + ')" ><b>View</b></a></td>'
                                  );
                table.append(newRow);
                callback(true);
            }
            var bindSurgeryItems = function (LedgerTransactionNo) {
                serverCall('Services/IPDSurgeryNew.asmx/bindSurgeryItems', { ledgerTnxNo: LedgerTransactionNo }, function (response) {
                    $('#tableSurgeryItemDetails tbody tr').remove();
                    responseDataItem = JSON.parse(response);
                    if (responseDataItem.length > 0) {
                        $("#spnSeletedSurgeryName").text(responseDataItem[0].SurgeryName);
                        $("#spnSelectedSurAmount").text(responseDataItem[0].NetAmount);

                        for (j = 0; j < responseDataItem.length; j++) {
                            addSurgeryItemRow(responseDataItem[j].ItemName, responseDataItem[j].EntryDate, responseDataItem[j].NetItemAmt, responseDataItem[j].IsPackage, responseDataItem[j].UserName, responseDataItem[j].DoctorName, responseDataItem[j].ID, responseDataItem[j].LedgerTransactionNo, responseDataItem[j].DoctorNotes, responseDataItem[j].IsRemove, function () { });
                        }
                        $('#divSurgeryItemDetails').showModel();
                    }
                    else {
                        bindPrescribedSurgery();
                        $('#divSurgeryItemDetails').hideModel();
                    }
                });
            }
            var addSurgeryItemRow = function (ItemName, EntryDate, NetItemAmt, IsPackage, UserName, DoctorName, ID, LedgerTransactionNo, DoctorNotes,IsRemove, callback) {
                var table = $('#tableSurgeryItemDetails').find('.billedItemBodyCls');
                var newRow = $('<tr class="billedItemCls" onmouseover="this.style.color=#00F" onMouseOut="this.style.color="" id="<#=j+1#>" style="cursor:pointer;">');
                newRow.html(
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;width:50px;">' + (table.find('tr').length + 1) +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" >' + ItemName +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" >' + NetItemAmt +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" >' + IsPackage +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" >' + DoctorName +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" >' + UserName +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" >' + EntryDate +
                                   '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgViewDoctorNotes"><a href="JavaScript:void(0)"  onclick="ViewDoctorNotes(this)" ><b>View</b></a>' +
                                  '</td><td class="GridViewLabItemStyle" style="text-align:center;" id="imgRemoveItem"><a href="JavaScript:void(0)" style="' + (IsRemove == 0 ? "display:none" : "display:block") + '"  onclick="onRemoveSurgeryItem(this,' + ID + ',' + LedgerTransactionNo + ')" ><b>Remove</b></a>' +
                                  '</td><td class="GridViewLabItemStyle" id="tdNotes" style="text-align:center; display:none;" >' + DoctorNotes + '</td>'

                                  );
                table.append(newRow);
                callback(true);
            }

            var ViewDoctorNotes = function (e) {
                var content = $(e).closest('tr').find('#tdNotes').html();
                if (!String.isNullOrEmpty(content))
                {
                    $(".divDoctorNotesData").html(content);
                    $("#divConsentData").showModel();
                }
                else
                    modelAlert('Doctor Notes not Available !!!');
               
            }
            var onRemoveSurgeryItem = function (ctrlId, ID, LedgerTnxNo) {
                modelConfirmation('Are You Sure ?', 'To Remove the Selected Entry', 'Yes', 'No', function (res) {
                    if (res) {
                        serverCall('Services/IPDSurgeryNew.asmx/onRemoveSurgeryItem', { id: ID, LedgerTransactionNo: LedgerTnxNo }, function (response) {
                            var $responseData = JSON.parse(response);
                            modelAlert($responseData.response, function () {
                                if ($responseData.status) {
                                    bindSurgeryItems(LedgerTnxNo);
                                }

                            });
                        });
                    }
                });
            }
            var onOTClearance = function (ctrlId, IsOTClearance, LedgerTransactionNo) {
               // debugger;

                if (String.isNullOrEmpty($(ctrlId).closest('tr').find('#txtRemarks').val())) {
                    $(ctrlId).closest('tr').find('#txtRemarks').focus();
                    return;
                }
                data = {
                    isOTClearence: IsOTClearance,
                    ledgerTnxNo: LedgerTransactionNo,
                    remarks: $(ctrlId).closest('tr').find('#txtRemarks').val(),
                    transactionId: $.trim($('#spnTransactionID').text())
                }

                $(ctrlId).attr('disabled', true).val('Reverting...');
                serverCall('Services/IPDSurgeryNew.asmx/OTClearence', data, function (response) {
                    var $responseData = JSON.parse(response);
                    modelAlert($responseData.response, function () {
                        if ($responseData.status) {
                            bindPrescribedSurgery(function () { });
                        }
                        else
                            $(ctrlId).removeAttr('disabled').val('Save');

                    });
                });
            }
        </script>
    </form>
</body>
</html>
