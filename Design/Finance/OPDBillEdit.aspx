<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDBillEdit.aspx.cs" Inherits="Design_Finance_OPDBillEdit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCPanel.ascx" TagName="PanelDetailsControl" TagPrefix="UC1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <style type="text/css">
         .selectedRow {
             background-color: aqua;
         }

         .newItem {
             background-color: bisque;
         }

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
         .hidden {
             display: none;
         }
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







    <script type="text/javascript">

        var doctorList = [];
        var panelList = [];
        $(document).ready(function () {
            $bindDoctor('All', function () {
                $bindPanel(function () {
                    bindDiscReason(function () {
                        bindApprovedMaster(function () {
                            // onBillSearch();
			$panelControlInit(function () { });
                            $onInit();
                        });
                    });
                });
            });
        });



        var bindApprovedMaster = function (callback) {
            serverCall('../EDP/Services/EDP.asmx/bindDisAppoval', { ApprovalType: '', Type: '1' }, function (response) {
                if (String.isNullOrEmpty(response))
                    response = '[]';

                var discountApprovalMaster = JSON.parse(response);
                var ddlApprovedBy = $('#ddlApprovedBy');
                ddlApprovedBy.bindDropDown({ data: discountApprovalMaster, valueField: 'ApprovalType', textField: 'ApprovalType', defaultValue: '', selectedValue: '' });
                callback(ddlApprovedBy.val());
            });
        }

        var bindDiscReason = function (callback) {
            serverCall('../Common/CommonService.asmx/GetDiscReason', { Type: 'OPD' }, function (response) {
                var ddlDiscountReason = $('#ddlDiscountReason');
                ddlDiscountReason.bindDropDown({
                    defaultValue: '', selectedValue: '', data: JSON.parse(response), valueField: 'DiscountReason', textField: 'DiscountReason', isSearchAble: false
                });
                callback(ddlDiscountReason.find('option:selected').text());
            });
        }

        $bindPanel = function (callback) {
            serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
                panelList = JSON.parse(response)
                callback(panelList);
            });
        }

        var $bindRelation = function (callback) {
            serverCall('../Common/CommonService.asmx/bindRelation', {}, function (response) {
                var $ddlRelation = $('#ddlRelation');
                $ddlRelation.bindDropDown({ data: JSON.parse(response) });
                callback(true);
            });
        }


        var onBillSearch = function (el) {

            var data = {
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                billNo: $('#txtBillNo').val()
            };
            serverCall('OPDBillEdit.asmx/SearchOPDBills', data, function (response) {
                responseData = JSON.parse(response);
                if (responseData.status)
                {
                    modelAlert('Patients Final Bill Already Posted To Finance...');
                }

                else {
                    var parseHTML = $('#template_Bills').parseTemplate(responseData);
                    $('#tblBills').html(parseHTML).customFixedHeader();
                    $('.divEditBill').addClass('hidden');
                }
            });
        }



        var onBillEdit = function (el) {

	        //if ($('#lblCanEditBill').text() == '0') {
	        //    modelAlert('You Are Not Authorised To Edit Bill...');
	        //    return false;
	        //}
            var row = $(el).closest('tr');
            $(row).closest('tbody').find('tr').removeClass('selectedRow');
            $(row).addClass('selectedRow');

            $('.divEditBill').removeClass('hidden');

            var tdData = JSON.parse(row.find('.tdData').text());

            $('#lblNetAmount').text(tdData.NetAmount);


            serverCall('OPDBillEdit.asmx/GetBillDetails', { ledgerTransactionNo: tdData.LedgertransactionNo, isPackage: tdData.IsPackage }, function (resposne) {
                var responseData = JSON.parse(resposne);
                console.log(responseData);
                if (responseData.status == false) {
                    modelAlert(responseData.message);
                }
                else {
                    bindBillDetails(responseData.message);
                }
            });
        }






        var bindBillDetails = function (data) {
            $('#tblBillDetails tbody tr').remove();
            for (var i = 0; i < data.length; i++) {
                addNewBillItem(false, function (lastRow) {
                    bindRowDetails(lastRow, data[i], function () { });
                });
            }

            calculateSummary();
        }



        var bindRowDetails = function (row, data, callback) {

            var tdBillData = JSON.parse($('.selectedRow').find('.tdData').text());

            var isPackageItem = (data.IsPackage == 1) ? true : false;

            var maxQuantity = 99;
            if (data.LabType == 'LAB')
                maxQuantity = 1;



            var itemName = data.ItemName;
            if (tdBillData.IsPackage == 1) {
                maxQuantity = 1;

                if (data.IsPackage == 0)
                    itemName = itemName + '<b class="patientInfo">(Package)</b>';
                else
                    itemName = itemName + '<b class="patientInfo">(Package Item)</b>';
            }

            row.find('.tdItem').html(itemName);


            


            row.find('.tdRate input[type=text]').val(data.Rate);
            row.find('.tdQty input[type=text]').val(data.Quantity).attr('disabled', isPackageItem).attr('max-value', maxQuantity);
            row.find('.tdDiscountPercent input[type=text]').val(data.DiscountPercentage).attr('disabled', isPackageItem);
            row.find('.tdDoctor select').val(data.DoctorID).trigger("chosen:updated");
            row.find('.tdGrossAmount input[type=text]').val(data.GrossAmount);
            row.find('.tdNetAmount input[type=text]').val(data.NetItemAmt);
            if (data.IsVerified == 2) {
                row.find('.tdIsActive input[type=checkbox]').prop('checked', false).attr('disabled', (data.IsSampleCollected == 'N' ? true : false));
                row.find('.tdIsDoctorCollected input[type=checkbox]').attr('disabled', (data.IsSampleCollected == 'N' ? true : false));
                

            }
            else {
                row.find('.tdIsActive input[type=checkbox]').prop('checked', true).attr('disabled', (data.IsSampleCollected == 'N' ? true : false));
                row.find('.tdIsDoctorCollected input[type=checkbox]').attr('disabled', (data.IsSampleCollected == 'N' ? true : false));
            }

            row.find('.tdData').text(JSON.stringify(data));

            callback();
        }



        var addNewBillItem = function (isSummaryRow, callback) {


            var rowCount = $('#tblBillDetails tbody tr').length + 1;
            var _tr = '<tr><td class="GridViewLabItemStyle">' + rowCount + '</td>'
            _tr += '<td class="GridViewLabItemStyle tdItem" style="text-align: left;"></td>'
            _tr += '<td class="GridViewLabItemStyle tdRate"><input type="text" class="ItDoseTextinputNum" onkeyup="onRowDataChange(this)" onlynumber="14" decimalplace="4" max-value="10000000" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>'
            _tr += '<td class="GridViewLabItemStyle tdQty"><input type="text" class="ItDoseTextinputNum" onkeyup="onRowDataChange(this)" onlynumber="4" decimalplace="2" max-value="0" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>'
            _tr += '<td class="GridViewLabItemStyle tdDiscountPercent"><input type="text" class="ItDoseTextinputNum" onkeyup="onRowDataChange(this)"  onlynumber="5" decimalplace="2" max-value="100" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"  /></td>'
            _tr += '<td class="GridViewLabItemStyle tdDoctor" style="width: 250px;"><select  onchange="$docCollection(this);"  ></select></td>'
            _tr += '<td class="GridViewLabItemStyle tdGrossAmount"><input type="text" class="ItDoseTextinputNum" disabled="disabled"/></td>'
            _tr += '<td class="GridViewLabItemStyle tdNetAmount"><input type="text" class="ItDoseTextinputNum" disabled="disabled"/></td>'
            _tr += '<td class="GridViewLabItemStyle tdData hidden"></td>'
            _tr += '<td class="GridViewLabItemStyle tdIsActive" style="cursor:pointer"><input type="checkbox"></td>'
            _tr += '<td class="GridViewLabItemStyle tdIsDoctorCollected" style="cursor:pointer"><input type="checkbox" id="chkIsDocChecked" data-title="Doctor Collection" onchange="$docCollection(this);" ></td>'
            _tr += '<td class="GridViewLabItemStyle tdIsDoctorCollectedAmt " style="cursor:pointer"><input type="text" id="txtdocCollection" class="ItDoseTextinputNum requiredField" onlynumber="14" decimalplace="4" max-value="10000000" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" style="display:none;"  /></td>'
            _tr += '<td class="GridViewLabItemStyle tdCashCollectedDoctor" style="cursor:pointer; width:200px;"></td>'
            
            _tr += '</tr>';

            var lastRow;
            if (isSummaryRow) {
                $('#tblBillDetails tfoot tr').remove();
                $('#tblBillDetails tfoot').append(_tr);
                lastRow = $('#tblBillDetails tfoot tr:last');
            }
            else {
                $('#tblBillDetails tbody').append(_tr);
                lastRow = $('#tblBillDetails tbody tr:last');
            }

            lastRow.find('select').bindDropDown({ defaultValue: 'Select', data: doctorList, valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
            callback(lastRow);

        }






        var $bindDoctor = function (department, callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                doctorList = JSON.parse(response);
                callback();
            });
        }


        var $docCollection = function (ctrlID) {
            debugger;

            if ($(ctrlID).closest('tr').find('#chkIsDocChecked').is(':checked')) {
                var CashCollectedDoctor = "";
                var tdData = JSON.parse( $(ctrlID).closest('tr').find('.tdData').text());

                if (tdData.LabType == "OPD")
                    CashCollectedDoctor = tdData.CashCollectedDoctor;
                else if ($(ctrlID).closest('tr').find('.tdDoctor').find('select').val() != "0")
                    CashCollectedDoctor = $(ctrlID).closest('tr').find('.tdDoctor').find('select option:selected').text();

                $(ctrlID).closest('tr').find("#txtdocCollection").show();
                $(ctrlID).closest('tr').attr("style", "background-color:#8ef3a9");
                $(ctrlID).closest('tr').find('.tdIsActive input[type=checkbox]').prop('checked', false).attr("disabled", true);
                $(ctrlID).closest('tr').find(".tdCashCollectedDoctor").html(CashCollectedDoctor);
                
            }
            else {
                $(ctrlID).closest('tr').find("#txtdocCollection").hide();
                $(ctrlID).closest('tr').removeAttr("style");
                $(ctrlID).closest('tr').find('.tdIsActive input[type=checkbox]').prop('checked', true).attr("disabled", false);
                $(ctrlID).closest('tr').find(".tdCashCollectedDoctor").html('');
            }

            calculateSummary();
        }
        var onRowDataChange = function (el) {

            var changedRow = $(el).closest('tr');
            var quantity = Number(changedRow.find('.tdQty input[type=text]').val());
            var rate = Number(changedRow.find('.tdRate input[type=text]').val())
            var discount = Number(changedRow.find('.tdDiscountPercent input[type=text]').val());


            var grossAmount = precise_round((rate * quantity), 4);
            var discountAmount = (grossAmount * discount / 100);
            var netItemAmount = (grossAmount - discountAmount);



            var row = $(el).closest('tr');


            var tdData = JSON.parse(row.find('.tdData').text());

            if (tdData.IsPackage)
                netItemAmount = 0;

            changedRow.find('.tdGrossAmount input[type=text]').val(precise_round(grossAmount, 4));
            changedRow.find('.tdNetAmount input[type=text]').val(precise_round(netItemAmount, 4));
            calculateSummary();
        }




        var calculateSummary = function () {
            var totalGrossAmount = 0;
            var totalNetAmount = 0;
            var totalDiscountPercent = 0;


            $('#tblBillDetails tbody tr').each(function () {

                if (!$(this).find('.tdIsDoctorCollected').find('input[type=checkbox]').is(':checked')) {
                    var netAmount = Number($(this).find('.tdNetAmount input[type=text]').val());
                    totalNetAmount += netAmount;

                    var grossAmount = Number($(this).find('.tdNetAmount input[type=text]').val());
                    totalGrossAmount += Number($(this).find('.tdGrossAmount input[type=text]').val());
                    totalDiscountPercent += Number($(this).find('.tdDiscountPercent input[type=text]').val());
                }
            });






            var divDiscountReasonDetails = $('.divDiscountReasonDetails');
            if (totalDiscountPercent > 0) {
                divDiscountReasonDetails.removeClass('hidden');
            }
            else {
                divDiscountReasonDetails.addClass('hidden');
                divDiscountReasonDetails.find('select').val();
            }





            addNewBillItem(true, function (summaryRow) {
                $(summaryRow).find('td:first').text('');
                $(summaryRow).find('.tdDoctor').css({ 'text-align': 'right' }).html('<b class="patientInfo">Total:&nbsp;</b>')
                $(summaryRow).find('input[type=text],input[type=checkbox],select,div').hide();
                $(summaryRow).find('.tdNetAmount input[type=text]').val(totalNetAmount).show();
                $(summaryRow).find('.tdGrossAmount input[type=text]')
                $(summaryRow).find('.tdGrossAmount input[type=text]').val(totalGrossAmount).show();
            });

        }





        var getBillChangeDetails = function (callback) {

            var LTD = [];

            var discountReason = $('#ddlDiscountReason option:selected').text();
            var approvedBy = $('#ddlApprovedBy option:selected').text();


            $('#tblBillDetails tbody tr').each(function () {

                var tdData = JSON.parse($(this).find('.tdData').text());

                var rate = Number($(this).find('.tdRate').find('input[type=text]').val());
                var quantity = Number($(this).find('.tdQty').find('input[type=text]').val());
                var discountPercent = Number($(this).find('.tdDiscountPercent').find('input[type=text]').val());
                var doctorID = $(this).find('.tdDoctor').find('select').val();
                var grossAmount = Number($(this).find('.tdGrossAmount').find('input[type=text]').val());
                var netAmount = Number($(this).find('.tdNetAmount').find('input[type=text]').val());
                var isVerified = $(this).find('.tdIsActive').find('input[type=checkbox]').is(':checked') ? 1 : 2;
                var IsDocCollect = $(this).find('.tdIsDoctorCollected').find('input[type=checkbox]').is(':checked') ? 1 : 0;
                var docCollectAmt = IsDocCollect == 1 ? Number($(this).find('#txtdocCollection').val()) : 0;


                var data = {
                    LedgerTransactionNo: tdData.LedgerTransactionNo,
                    LedgerTnxID: tdData.LedgerTnxID,
                    IsAdvance: 0,
                    ItemID: tdData.ItemID,
                    Rate: rate,
                    Quantity: quantity,
                    DiscountPercentage: discountPercent,
                    SubCategoryID: tdData.SubCategoryID,
                    ItemName: tdData.ItemName,
                    DiscountReason: tdData.discountReason,
                    DoctorID: doctorID,
                    Type: tdData.LabType,
                    Type_ID: tdData.Type_ID,
                    TnxTypeID: tdData.TnxTypeID,
                    sampleType: tdData.sampleType,
                    RateListID: tdData.RateListID,
                    IsOutSource: tdData.IsOutSource,
                    rateItemCode: tdData.rateItemCode,
                    CoPayPercent: tdData.CoPayPercent,
                    IsPayable: 0,
                    isPanelWiseDisc: 0,
                    isMobileBooking: 0,
                    CategoryID: tdData.CategoryID,
                    salesID: 0,
                    remark: '',
                    TransactionID: tdData.TransactionID,
                    IsVerified: isVerified,
                    IsPackage: tdData.IsPackage,
                    PackageID: tdData.PackageID,
                    isDocCollect: IsDocCollect,
                    docCollectAmt: docCollectAmt
                };
                LTD.push(data);
            });



            var zeroRateItems = LTD.filter(function (i) {
                return i.Rate <= 0
            });


            if (zeroRateItems.length > 0) {
                modelAlert('Some Item have 0 Rate.');
                return false;
            }


            var zeroQuantityItems = LTD.filter(function (i) {
                return i.Quantity <= 0
            });



            if (zeroQuantityItems.length > 0) {
                modelAlert('Some Item have 0 Quantity.');
                return false;
            }


            var docCollectAmtValidate = LTD.filter(function (i) {
                return i.isDocCollect == 1 && i.docCollectAmt==0
            });



            if (docCollectAmtValidate.length > 0) {
                modelAlert('Please Enter Collected Amt.');
                return false;
            }



            var discountItems = LTD.filter(function (i) {
                return i.DiscountPercentage > 0 && i.IsVerified == 1
            });


            if (discountItems.length > 0) {

                if (String.isNullOrEmpty(discountReason)) {
                    modelAlert('Please Select Discount Reason.');
                    return false;
                }


                if (String.isNullOrEmpty(approvedBy)) {
                    modelAlert('Please Select Approved By.');
                    return false;
                }
            }

            var unSelectedDoctorItems = LTD.filter(function (i) {
                return i.DoctorID == '0'
            });



            if (unSelectedDoctorItems.length > 0) {
                modelAlert('Some Item have Invalid Doctor.');
                return false;
            }


            callback({ LTD: LTD, DiscountReason: discountReason, ApprovedBy: approvedBy });

        }





        var onSaveOPDBillDetails = function (btnSave) {
            getBillChangeDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('OPDBillEdit.asmx/ChangeBillDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                        else {
                            modelAlert(responseData.message);
                            $(btnSave).removeAttr('disabled').val('Save');
                        }

                    });
                });
            });
        }



        $onInit = function () {
            $('#txtSearch').autocomplete({
                source: function (request, response) {
                    $bindItems({ searchType: 1, prefix: request.term, Type: 0, CategoryID: 0, SubCategoryID: 0, itemID: '' }, function (responseItems) {
                        response(responseItems);
                    });
                },
                select: function (e, i) {
                    addNewItemToBill(i);
                    //$validateInvestigation(i, 0, 0, 1, function () { });
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





        var addNewItemToBill = function (data) {
            var tdData = JSON.parse($('.selectedRow').find('.tdData').text());
            debugger;
            //PackageItemID
            var panelID = tdData.PanelID;
            var itemDetails = data;
            getItemRate(panelID, itemDetails, 1, function (r) {
                console.log(itemDetails);
                itemDetails.item.Rate = r.Rate;
                itemDetails.itemRateListID = r.ScheduleChargeID;
                itemDetails.item.rateItemCode = r.ItemCode;
                itemDetails.item.ItemDisplayName = r.ItemDisplayName;
                itemDetails.item.TransactionID = tdData.TransactionID;
                itemDetails.item.IsPackage = tdData.IsPackage;
                itemDetails.item.ItemName = itemDetails.item.TypeName;
                itemDetails.item.ItemID = itemDetails.item.val;
                itemDetails.item.LedgerTransactionNo = tdData.LedgertransactionNo;
                itemDetails.item.Quantity = 1;
                itemDetails.item.GrossAmount = itemDetails.item.Quantity * itemDetails.item.Rate;
                itemDetails.item.DiscountPercentage = 0;
                itemDetails.item.NetItemAmt = itemDetails.item.GrossAmount;
                itemDetails.item.IsVerified = 1;
                itemDetails.item.PanelID = panelID;
                itemDetails.item.IsPackage = tdData.IsPackage;
                itemDetails.item.PackageID = '';
                itemDetails.item.CashCollectedDoctor = itemDetails.item.LabType == 'OPD' ? 'DR. ' + itemDetails.item.TypeName : '';

                if (tdData.IsPackage)
                    itemDetails.item.NetItemAmt = 0;

                addNewBillItem(false, function (lastRow) {
                    $(lastRow).addClass('newItem');
                    bindRowDetails(lastRow, itemDetails.item, function () {
                        calculateSummary();
                    });
                });
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
                        rateEditAble: item.RateEditable,
                        isMobileBooking: 0,
                        CategoryID: item.categoryid,
                        SubCategory: item.SubCategory,
                        CashCollectedDoctor: "DR. " + item.TypeName
                    }
                });
                callback(responseData);
            });

        }




        var getItemRate = function (panelID, investigation, panelCurrencyFactor, callback) {
            $PanelID = panelID;
            $ItemID = investigation.item.val;
            $TID = ''; ///add later
            $IPDCaseTypeID = '';///add later
            serverCall('../common/CommonService.asmx/bindLabInvestigationRate', { PanelID: $PanelID, ItemID: $ItemID, TID: $TID, IPDCaseTypeID: $IPDCaseTypeID, panelCurrencyFactor: panelCurrencyFactor }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    callback(responseData[0]);
                }
                else
                    callback({ Rate: 0, ID: 0, ScheduleChargeID: 0, ItemCode: '', ItemDisplayName: '' });
            });
        }


	    var onChangeRelationDetails = function (el) {
	      
	        if ($('#lblCanChangeRelation').text() == '0') {
	            modelAlert('You Are Not Authorised To Change Relation Details...');
	            return false;
	        }
          
            var divRelationDetails = $('#divRelationDetails');
            divRelationDetails.showModel();
            $bindRelation(function(){
            var row = $(el).closest('tr');
            $(row).closest('tbody').find('tr').removeClass('selectedRow');
            $(row).addClass('selectedRow');
            var tdData = JSON.parse(row.find('.tdData').text());
            divRelationDetails.find('#lblBillNo1').text(tdData.BillNo).attr('LedgertransactionNo', tdData.LedgertransactionNo).attr('TransactionID', tdData.TransactionID);
            divRelationDetails.find('#ddlRelation').val(tdData.KinRelation);
            divRelationDetails.find('#txtRelationName').val(tdData.KinName);
            divRelationDetails.find('#txtRelationPhoneNo').val(tdData.KinPhone);
            });
        }

        //Dev
	    var onUploadPanelDocumentsnew = function (el) {
            if ($('#lblCanUploadPanelDocuments').text() == '0') {
                modelAlert('You Are Not Authorised To Upload Panel Documents...');
                return false;
            }
            getPanelDocumentsnew(el, function () {
                onPanelDocumentClearnew(function () { });
                $('#divPanelDocumentMatersnew').showModel();
            });
        }
	    var getPanelDocumentsnew = function (el, callback) {
            var row = $(el).closest('tr');
            $(row).closest('tbody').find('tr').removeClass('selectedRow');
            $(row).addClass('selectedRow');
            var tdData = JSON.parse(row.find('.tdData').text());
            var _divPanelRequiredDocuments = $('#divPanelRequiredDocumentsnew');
            _divPanelRequiredDocuments.html('');
            serverCall('OPDBillEdit.asmx/GetPanelDocument', { panelID: tdData.PanelID, transactionID: tdData.TransactionID }, function (response) {
                var responseData = JSON.parse(response);
                $(responseData).each(function () {
                    var temp = '<button onclick="onDocumentSelectnew(this)" id="' + this.DocumentID + '" class="panelDocumentButton" type="button">' + this.Document + '<span id="spnDocumentID" style="display:none" class="hidden">' + this.DocumentID + '</span><span id="spnDocumentBase64" style="display:none" class="hidden">' + this.FilePath + '</span><span id="spnDocumentName" style="display:none" class="hidden">' + this.Document + '</span></button>';
                    _divPanelRequiredDocuments.append(temp);
                });
                callback(responseData);
            });
        }
        var onDocumentSelectnew = function (el) {
            var divPanelRequiredDocuments = $(el).closest('#divPanelRequiredDocumentsnew');
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
               createPanelDocumentPreviewnew(function () { });
        }
        var createPanelDocumentPreviewnew = function () {
            getPanelUploadedDocumentsnew(function (panelDocuments) {
                var previewImage = '';
                var isCurrent = panelDocuments.filter(function (d) {
                    return (d.isCurrentSelected == true);
                });
                if (isCurrent.length > 0)
                    previewImage = isCurrent[0].DocumentBase64;
                var img = document.getElementById("imgPanelDocumentPreviewnew");
                img.src = previewImage;
                $('#spnPanelDocumentCountsnew').text(panelDocuments.length);
            });
        }
        var getPanelUploadedDocumentsnew = function (callback) {
            var panelDocuments = [];
            $('#divPanelRequiredDocumentsnew .panelDocumentButton').each(function () {
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
        var previewPanelDocumentnew = function (fileInput) {
            var files = fileInput.files;
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var img = document.getElementById("imgPanelDocumentPreviewnew");
                img.file = file;
                var reader = new FileReader();
                reader.onload = (function (aImg) {
                    return function (e) {
                        aImg.src = e.target.result;
                        $('.selectedDocument').find('#spnDocumentBase64').text(e.target.result);
                        createPanelDocumentPreviewnew(function () { });
                        fileInput.value = null;
                    };
                })(img);
                reader.readAsDataURL(file);
            }
        }
        $bindCardHolderRelation = function (callback) {
            $ddlRelationCardHolder = $('#ddlCardHolder');
            serverCall('../IPD/Services/IPDAdmission.asmx/bindCarHolderRelation', {}, function (response) {
                $ddlRelationCardHolder.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response) });
                callback($ddlRelationCardHolder.find('option:selected').text());
            });
        }
        var onFileSelectnew = function (el) {
            var divPanelDocumentMaters = $('#divPanelDocumentMatersnew');
            var _flUpload = $('#divPanelDocumentMatersnew').find('#flUploadnew');
            var selectedDocument = divPanelDocumentMaters.find('.selectedDocument');
            if (selectedDocument.length < 1) {
                modelAlert('Please Select Document.', function () { });
                return false;
            }
            _flUpload.click();
        }
        var onPanelDocumentClearnew = function () {
            var selectedDocument = $('#divPanelRequiredDocumentsnew').find('.selectedDocument');
            selectedDocument.removeClass('uplodedDocument');
            selectedDocument.find('#spnDocumentBase64').text('');
            createPanelDocumentPreviewnew(function () { });
        }
        var closePanelDocumentModelnew = function () {
            $('#divPanelDocumentMatersnew').hideModel();
        }
        var getPanelUploadedDocumentsnew = function (callback) {
            var panelDocuments = [];
            $('#divPanelRequiredDocumentsnew .panelDocumentButton').each(function () {
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
        var savePanelDocumentsnew = function (btnSave) {
            getPanelUploadedDocumentsnew(function (panelDocuments) {
              var tdData = JSON.parse($('#tableBills').find('.selectedRow').find('.tdData').text());
                data = {
                    TransactionId: tdData.TransactionID,
                    PatientID: tdData.PatientID,
                    PanelID: Number(tdData.PanelID),
                    panelDocuments: panelDocuments
                }
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('OPDBillEdit.asmx/savePanelDocuments', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            window.location.reload();
                        else
                            $(btnSave).removeAttr('disabled').val('Save Panel Documents');
                    });
                });
            });
        }
        var onChangePanel = function (el) {
            debugger;
            $('#divPanelChangeModel').find(':input').val('');
            if ($('#lblCanChangePanel').text() == '0') {
	            modelAlert('You Are Not Authorised To Change Panel...');
	            return false;
	        }
            $('.divEditBill').addClass('hidden');

            var row = $(el).closest('tr');
            $(row).closest('tbody').find('tr').removeClass('selectedRow');
            $(row).addClass('selectedRow');

            var tdData = JSON.parse(row.find('.tdData').text());
            var divParentPanelUserControl = $('#divParentPanelUserControl');
            var divPanelChangeModel = $('#divPanelChangeModel');
            divParentPanelUserControl.find('.Document').hide();
            divParentPanelUserControl.find('.Policy').hide();
            divPanelChangeModel.find('#lblBillNo').text(tdData.BillNo).attr('LedgertransactionNo', tdData.LedgertransactionNo);
            divPanelChangeModel.find('#lblCurrentPanel').text(tdData.PanelName);
            divPanelChangeModel.find('#txtCopayPercent').val(tdData.CoPayPercent).attr('max-value', (tdData.PanelID == Number('<%=Resources.Resource.DefaultPanelID %>') ? 0 : 100));




            var filteredPanelList = panelList.filter(function (p) { return p.PanelID != Number(tdData.PanelID) });
            divPanelChangeModel.find('#ddlChangePanel').bindDropDown({ data: filteredPanelList, defaultValue: 'Select', valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true });
            $bindPanelGroup(function () { 
                $bindCorporatePanel(function () {
                    $bindCardHolderRelation(function () {
                        $bindDepartment(function (selectedDepartment) {
                            $binddepartmentDoctor(selectedDepartment, function () {
                                $bindReferDotor(function () {
                                    //$bindPRO(function (selectedPROID) {
                                        divParentPanelUserControl.find('#ddlParentPanel').val(tdData.ParentID).chosen('destroy').chosen();
                                        divParentPanelUserControl.find('#txtPolicyNO').val(tdData.PolicyNo);
                                        divParentPanelUserControl.find('#ddlPanelCompany').val(tdData.PanelID + '#' + tdData.ReferenceCodeOPD + '#' + tdData.HideRate + '#' + tdData.ShowPrintOut).change().chosen("destroy").chosen();
                                        divParentPanelUserControl.find('#ddlParentPanel').val(tdData.ParentID).chosen('destroy').chosen();
                                        divParentPanelUserControl.find('#txtExpireDate').val(tdData.ExpiryDate == '01-Jan-0001' ? '' : tdData.ExpiryDate);
                                        divParentPanelUserControl.find('#txtCardNo').val(tdData.CardNo);
                                        divParentPanelUserControl.find('#txtCardHolderName').val(tdData.CardHolderName);
                                        divParentPanelUserControl.find('#ddlCardHolder').val(tdData.RelationWith_holder);
                                        divParentPanelUserControl.find('#ddlPanelCorporate').val(tdData.CorporatePanelID).chosen('destroy').chosen();
                                        divPanelChangeModel.find('#ddlDoctor').val(String.isNullOrEmpty(tdData.doctorid) ? '0' : tdData.doctorid).change().chosen("destroy").chosen();
                                        divPanelChangeModel.find('#ddlReferDoctor').val(tdData.ReferedBy).change().chosen('destroy').chosen();
                                        divPanelChangeModel.find('#txtPanelApprovalAmount').val(tdData.ApprovalAmount);
                                        divPanelChangeModel.find('#txtPanelApprovalRemark').val(tdData.ApprovalRemark);
                                        divPanelChangeModel.find('#ddlPROName').val(tdData.ProId).chosen('destroy').chosen();
                                  //  });
                                });
                            });
                        });
                    });
                });
            });
            divPanelChangeModel.showModel();
        }

        var onSaveRelationsave = function (btnupdate) {
            debugger;
            var divRelationDetails = $('#divRelationDetails');
            var tdData = JSON.parse($('.selectedRow').find('.tdData').text());
            var TransactionID = tdData.TransactionID;
            var KinRelation = $('#ddlRelation').val();
            var KinName = $('#txtRelationName').val();
            var KinPhone = $('#txtRelationPhoneNo').val();
            if (KinName == '') {
                modelAlert('Please Enter Relation Name');
                return false;
            }
            if (KinPhone == '') {
                modelAlert('Please Enter Relation Phone');
                return false;
            }
            var data = {
                TransactionID: TransactionID,
                KinRelation: KinRelation,
                KinName: KinName,
                KinPhone: KinPhone
            }
            $(btnupdate).attr('disabled', true).val('Submitting...');
            serverCall('OPDBillEdit.asmx/ChangeRelationChange', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        window.location.reload();
                    else
                        $(btnSave).removeAttr('disabled').val('Save');
                });
            });
        }

        var onsavepaneldetails = function (btnsave) {
            debugger;
            var divParentPanelUserControl = $('#divParentPanelUserControl');
            var divPanelChangeModel = $('#divPanelChangeModel');
            var tdData = JSON.parse($('.selectedRow').find('.tdData').text());
            var data = {
                PanelGroup: divParentPanelUserControl.find('#ddlPanelGroup').val(),
                ParentPanel: divParentPanelUserControl.find('#ddlParentPanel').val(),
                panelID: divParentPanelUserControl.find('#ddlPanelCompany').val().split('#')[0],
                PanelCorporate: divParentPanelUserControl.find('#ddlPanelCorporate').val(),
                PolicyNO: divParentPanelUserControl.find('#txtPolicyNO').val(),
                PolicyCardNO: divParentPanelUserControl.find('#txtCardNo').val(),
                CardHolderName: divParentPanelUserControl.find('#txtCardHolderName').val(),
                ExpireDate: divParentPanelUserControl.find('#txtExpireDate').val(),
                CardHolder: divParentPanelUserControl.find('#ddlCardHolder').val(),
                PanelApprovalAmount: divParentPanelUserControl.find('#txtPanelApprovalAmount').val(),
                PanelApprovalRemark: divParentPanelUserControl.find('#txtPanelApprovalRemark').val(),
               // Department: divPanelChangeModel.find('#ddlDepartment').val(),
                Doctor: divPanelChangeModel.find('#ddlDoctor').val(),
                ReferDoctor: divPanelChangeModel.find('#ddlReferDoctor').val(),
                PRONAme: divPanelChangeModel.find('#ddlPROName').val(),
                ledgerTransactionNo: tdData.LedgertransactionNo,
                transactionID: tdData.TransactionID,
                // coPayPercent: coPayPercent
            }
            $(btnsave).attr('disabled', true).val('Submitting...');
            serverCall('OPDBillEdit.asmx/ChangeBillPanelDetails', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        window.location.reload();
                    else
                        $(btnSave).removeAttr('disabled').val('Save');
                });
            });
        }

        var onSavePanelChange = function (btnSave) {

            var divPanelChangeModel = $('#divPanelChangeModel');
            var panelID = Number(divPanelChangeModel.find('#ddlChangePanel').val());
            if (panelID == 0) {
                modelAlert('Please Select Panel.');
                return false;
            }

            var coPayPercent = Number(divPanelChangeModel.find('#txtCopayPercent').val());

            var tdData = JSON.parse($('.selectedRow').find('.tdData').text());


            var data = {
                panelID: panelID,
                ledgerTransactionNo: tdData.LedgertransactionNo,
                transactionID: tdData.TransactionID,
                coPayPercent: coPayPercent
            }


            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('OPDBillEdit.asmx/ChangeBillPanel', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        window.location.reload();
                    else
                        $(btnSave).removeAttr('disabled').val('Save');
                });
            });
        }




        var onBillPanelChange = function (el) {
            var panelID = Number(el.value);
            var divPanelChangeModel = $('#divPanelChangeModel');
            divPanelChangeModel.find('#txtCopayPercent').val(0).attr('max-value', (panelID == Number('<%=Resources.Resource.DefaultPanelID %>') ? 0 : 100));

        }
        var $bindDepartment = function (callback) {
            var $ddlDepartment = $('#ddlDepartment');
            serverCall('../common/CommonService.asmx/bindDepartment', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlDepartment.find('option:selected').text());
            });
        }
        var $binddepartmentDoctor = function (department, callback) {
            var $ddlDoctor = $('#ddlDoctor');
            var ddlSlotDoctors = $('#ddlSlotDoctors');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                var option = {
                    defaultValue: 'Select',
                    data: JSON.parse(response),
                    valueField: 'DoctorID',
                    textField: 'Name',
                    isSearchAble: true
                };
                var URL = window.location.href.split('?')[0];
                var pageName = (URL.split('/')[URL.split('/').length - 1]).toLowerCase();
                if (pageName == 'emergencyadmission.aspx')
                    option.selectedValue = '<%=Resources.Resource.DoctorID_Self %>'
                if (pageName == 'bookdirectappointment.aspx')
                    ddlSlotDoctors.bindDropDown(option);
                $ddlDoctor.bindDropDown(option);
                callback($ddlDoctor.val());
            });
        }
        var $bindReferDotor = function (callback) {
            serverCall('../Common/CommonService.asmx/bindReferDoctor', {}, function (response) {
                $ddlReferDoctor = $('#ddlReferDoctor');
                $ddlReferDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlReferDoctor.val());
            });
        }
        var $bindPRO = function (callback) {
            getPRODetails(0, function (response) {
                $ddlPROName = $('#ddlPROName');
                $ddlPROName.bindDropDown({ defaultValue: 'Select', data: (response), valueField: 'Pro_ID', textField: 'ProName', isSearchAble: true });
                callback($ddlPROName.val());
            });
        }
        var getPRODetails = function (referDoctorID, callback) {
            serverCall('../Common/CommonService.asmx/bindPRO', { referDoctorID: referDoctorID }, function (response) {
                callback(JSON.parse(response));
            });
        }
        var bindPROAccordingToReferDoctorID = function (selectedReferDoctor) {
            getPRODetails(selectedReferDoctor, function (response) {
                $ddlPROName = $('#ddlPROName');
                var option = { data: (response), valueField: 'Pro_ID', textField: 'ProName', isSearchAble: true };
                if (response.length < 1)
                    option.defaultValue = 'Select';
                $ddlPROName.bindDropDown(option);
            })
        }
        var onDoctorChange = function (el, event) {
            if ($.isFunction(window['_onUserControlDoctorChange']))
                _onUserControlDoctorChange(el, event, function () { });
        }

    </script>







        <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <asp:Label id="lblCanChangePanel" ClientIDMode="Static" runat="server" style="display:none"></asp:Label>
            <asp:Label id="lblCanEditBill" ClientIDMode="Static" runat="server" style="display:none" ></asp:Label>
             <asp:Label id="lblCanChangeRelation" ClientIDMode="Static" runat="server" style="display:none"></asp:Label>
            <asp:Label id="lblCanUploadPanelDocuments" ClientIDMode="Static" runat="server" style="display:none"></asp:Label>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Bill No. </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBillNo" autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

         <div class="POuter_Box_Inventory textCenter" >
             <input type="button" value="Search" class="save margin-top-on-btn" onclick="onBillSearch(this)" />
         </div>



          <div class="POuter_Box_Inventory textCenter" id="tblBills" style="max-height:450px;overflow:auto">
            <%--<div class="row">
                <div class="col-md-24" id="tblBills" style="max-height: 250px;overflow: auto;"  >
                </div>
            </div>--%>
        </div>

           
         <div class="POuter_Box_Inventory textCenter divBillDetails divEditBill hidden">
             
             <div class="row">
                 <div class="col-md-3">
                      <label class="pull-left">Add Item</label>
                            <b class="pull-right">:</b>
                 </div>
                 <div class="col-md-8">
                     <input type="text" id="txtSearch" />
                 </div>


                   <div class="col-md-5 patientInfo lblPanel">
                      
                   </div>



                   <div class="col-md-3">
                       
                 </div>


                   <div class="col-md-3 patientInfo lblNetAmount">
                      
                   </div>


             </div>
         </div>



          <div class="POuter_Box_Inventory textCenter divBillDetails divEditBill hidden">

              <table cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;" id="tblBillDetails">    
                  <thead>
                      <tr>
                      <td class="GridViewHeaderStyle">#</td>
                      <td class="GridViewHeaderStyle" style="width: 532px;">Item Name</td>
                      <td class="GridViewHeaderStyle" style="width: 99px;">Rate</td>
                      <td class="GridViewHeaderStyle" style="width: 99px;">Qty</td>
                      <td class="GridViewHeaderStyle">Discount(%)</td>
                      <td class="GridViewHeaderStyle" style="width: 250px;">Doctor</td>
                      <td class="GridViewHeaderStyle"  style="width: 125px;">Gross Amount</td>
                      <td class="GridViewHeaderStyle" style="width: 115px;">Net Amount</td>
                      <td class="GridViewHeaderStyle" style="width:80px">Is Active</td>
                      <td class="GridViewHeaderStyle" style="width:130px">Is Doc.Collect</td>
                      <td class="GridViewHeaderStyle" style="width:150px">Collected Amt.</td>
                      <td class="GridViewHeaderStyle" style="width:150px">Collected By</td>
                    </tr>
                  </thead>

                  <tbody>


                  </tbody>
                  <tfoot></tfoot>
              </table>
          </div>



      
         <div class="POuter_Box_Inventory divDiscountReasonDetails  hidden">

              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"> Dis. Resason  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDiscountReason" class="required"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Approved By </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">                            
                            <select id="ddlApprovedBy" class="required"></select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

         </div>




         <div class="POuter_Box_Inventory textCenter divEditBill hidden">

             <input type="button" value="Save"  onclick="onSaveOPDBillDetails(this)" class="save margin-top-on-btn" />

         </div>


              




        </div>




    

    <script id="template_Bills" type="text/html">
        <table  id="tableBills" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >Sr No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill No</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill Amount</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Create By</th>
            <th class="GridViewHeaderStyle" scope="col" >Bill Type</th>
            <th class="GridViewHeaderStyle" scope="col">Select</th>  
                                 
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=responseData.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = responseData[j];
                #>          
                

                    <tr onmouseover="this.style.color='#00F'"       onMouseOut="this.style.color=''" id="<#=j+1#>" ondblclick="onMobileAppointmentSelect(this);" style='cursor:pointer;'>                            
       
                        <td  class="GridViewLabItemStyle" id="td6">  <#=j+1#>  </td>                                   
                        <td  class="GridViewLabItemStyle" id="td1"><#=objRow.BillNo#></td>
                        <td class="GridViewLabItemStyle" id="td2" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.NetAmount#></td>
                        <td class="GridViewLabItemStyle" id="td3" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.Date#></td>
                        <td class="GridViewLabItemStyle" id="td4" style=""><#=objRow.CreatedBy#></td> 
                        <td class="GridViewLabItemStyle" id="td5" style=""><#=objRow.TypeOfTnx#></td>   
                         <td class="GridViewLabItemStyle" id="tdTransactionID" style="display:none"><#=objRow.TransactionID#></td>  
                        
                         <td class="GridViewLabItemStyle tdData"  style="display:none"><#=JSON.stringify(objRow)#></td>  
                        <td class="GridViewLabItemStyle">  
                            <a href="JavaScript:void(0)" onclick="onChangePanel(this)">Change Panel</a>
                            &nbsp;
                            <#if(objRow.IsPharmacy==0){#>
                            <a href="JavaScript:void(0)"  onclick="onBillEdit(this)" style="display:none" >Edit Bill</a>
                            <#}#>
                            <%--<img src="../../Images/Post.gif" alt="" id="imgSelect" class="paymentSelect"   onclick="getReceiptDetails(this,function(){})" title="Click To Select"/>--%>
                             &nbsp;
                            <a href="JavaScript:void(0)" onclick="onChangeRelationDetails(this)">Change Relation Details</a>
                             &nbsp;
                            <a href="JavaScript:void(0)" onclick="onUploadPanelDocumentsnew(this)" style="display:none">Upload Panel Documents</a>
                        </td>                       
                        </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>






    <div id="divPanelChangeModel" class="modal fade"  >
		<div class="modal-dialog">
			<div class="modal-content" style="width:85%">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divPanelChangeModel" aria-hidden="true">×</button>
					<b class="modal-title">Change Panel   <span style="color:red">You can change only the panel, not rate, Rate will be no effect from this page</span></b>
				</div>
				<div class="modal-body">
					<div class="row">
                            <div class="col-md-24">

                            <div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Selected Bill No
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblBillNo" class="pull-left patientInfo" ledgerTransactionNo="0"></label>

								</div>
							</div>


							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Current Panel Name
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblCurrentPanel" class="pull-left patientInfo" panelid="0"></label>

								</div>
							</div>
                                </div>
                    </div>
							<div class="row">
        <div class="col-md-24">
           <UC1:PanelDetailsControl ID="PanelDetailsControl1" runat="server" />
	       <div class="row doctorDetailsRow">
		           <div class="col-md-3" style="display:none">
			           <label class="pull-left"> Department   </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5" style="display:none">
			 <select id="ddlDepartment" data-title="Select Doctor" onchange="$bindDoctor($(this).find('option:selected').text(),function(){})"   class="searchable"></select> 
		           </div>
		           <div class="col-md-3">
			           <label class="pull-left">  Doctor       </label>
			           <b class="pull-right">: </b>
		           </div>
		           <div class="col-md-5">
				         <select id="ddlDoctor" title="Select Doctor"  onchange="onDoctorChange(this,event)" ></select>
		           </div>
                     <div class="col-md-3">
				        <label class="pull-left"> Refer Doctor      </label>
				        <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
				         <select id="ddlReferDoctor" title="Select Refer Doctor"  onchange="bindPROAccordingToReferDoctorID(this.value)" class="searchable" ></select>    
		           </div>
	          </div>
	       <div class="row">
		           <div class="col-md-3">
			          <label class="pull-left"> PRO Name      </label>
				        <b class="pull-right">:</b>
		           </div>
                  <div class="col-md-5">
				         <select id="ddlPROName" title="Select PRO Name" ClientIDMode="Static"   class="searchable"></select>    
		           </div>
		          </div>
        </div>
       </div>
					<div class="row">
						<div class="col-md-1"></div>
						<div class="col-md-22">
                            <div class="row">
							</div>
							<div class="row" style="display:none">
								<div class="col-md-8">
									<label class="pull-left">
										Change to
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<select id="ddlChangePanel"  onchange="onBillPanelChange(this)"> </select>
								</div>
							</div>



                            <div class="row" style="display:none">
								<div class="col-md-8">
									<label class="pull-left">
									 	CoPayment  Percent
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16"> 
									<input type="text" id="txtCopayPercent" class="ItDoseTextinputNum" style="width:120px;" onlynumber="5" decimalplace="4" max-value="100" />
								</div>
							</div>
							
						</div>
						<div class="col-md-1"></div>
					</div>
				</div>
				<div class="modal-footer">

                    <button type="button" onclick="onsavepaneldetails(this)" class="save">Change Panel Details</button>
					<button type="button" onclick="onSavePanelChange(this)" class="save" style="display:none">Change Panel</button>
					<button type="button" data-dismiss="divPanelChangeModel">Close</button>
				</div>
			</div>
		</div>
	</div>


     <div id="divRelationDetails" class="modal fade"  >
		<div class="modal-dialog">
			<div class="modal-content" style="min-width: 650px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divRelationDetails" aria-hidden="true">×</button>
					<b class="modal-title">Change Relation Details</b>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-1"></div>
						<div class="col-md-22">
                            <div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Selected Bill No
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblBillNo1" class="pull-left patientInfo" ledgerTransactionNo="0"></label>
								</div>
							</div>
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Relation Of
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<select id="ddlRelation"  data-title="Select Relation Of"></select>  
								</div>
							</div>
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Relation Name
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
                                     <input type="text"  autocomplete="off"  id="txtRelationName" errorMessage="Please Enter Relation Name."  style="text-transform:uppercase"  onlyText="100" maxlength="100"    data-title="Enter Relation Name" />
									<%--<select id="Select1"  onchange="onBillPanelChange(this)"> </select>--%>
								</div>
							</div>
                            <div class="row">
								<div class="col-md-8">
									<label class="pull-left">
									 	Relation Phone
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16"> 
									 <input type="text"  autocomplete="off"  id="txtRelationPhoneNo"   data-title="Enter Relation Phone No"
					           onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)});"  onlynumber="10"    />
								</div>
							</div>
						</div>
						<div class="col-md-1"></div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" onclick="onSaveRelationsave(this)" class="save">Update</button>
					<button type="button" data-dismiss="divRelationDetails">Close</button>
				</div>
			</div>
		</div>
	</div>
    <div id="divPanelDocumentMatersnew" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px;">
            <div class="modal-header">
                <button type="button" class="close" onclick="closePanelDocumentModelnew()" aria-hidden="true">×</button>
                 <h4 class="modal-title"> Panel Required Document's &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;   Total Uploaded Documents <span id="spnPanelDocumentCountsnew" class="badge badge-grey">0</span> </h4>
            </div>
            <div class="modal-body" style="min-height:300px;">
                <div class="row">
                    <div class="col-md-8 panelDocumentModelBody">
                        <button type="button" style="width: 100%; font-size: 17px; box-shadow: none; background-color: cadetblue;"><strong>Panel Required Document's</strong></button>
                        <div id="divPanelRequiredDocumentsnew"></div>
                    </div>
                    <div class="col-md-1 panelDocumentModelBody" style="background-color: lightgray; padding-right: 0px; padding-left: 0px; width: 5px;"></div>
                    <div class="col-md-15 panelDocumentModelBody" id="divPanelDocumentPreview">
                        <img src="" id="imgPanelDocumentPreviewnew" style="width: 100%; height: 100%" alt="" />
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <input type="file" id="flUploadnew" accept="image/x-png,image/gif,image/jpeg,image/jpg,application/pdf" style="display:none" class="hidden" onchange="previewPanelDocumentnew(this)" />
                <button class="save" type="button" onclick="onPanelDocumentClearnew()">Clear</button>
                <button class="save" type="button" onclick="onFileSelectnew(this)">Browse</button>
                <button type="button"  class="save" onclick="savePanelDocumentsnew(this)">Save Panel Documents</button>
                 <button type="button" class="save" onclick="closePanelDocumentModelnew()">Close</button>
            </div>
        </div>
    </div>
</div>
</asp:Content>

