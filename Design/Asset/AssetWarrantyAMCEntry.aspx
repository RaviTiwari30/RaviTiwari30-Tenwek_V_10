<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="AssetWarrantyAMCEntry.aspx.cs" Inherits="Design_Asset_AssetWarrantyAMCEntry" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <style type="text/css">
        .divcentre
        {
            text-align: center;
        }

        .hidden
        {
            display: none;
        }

        .showbutton
        {
            /*background-color: #1e6f17 !important; 
            box-shadow: 4px 4px #999 !important;
            font-size: medium !important;
            border-radius: 12px !important;*/
            width: 138px !important;
            font-size: small !important;
        }
         .CurrentButton
        {
            background-color: #31c531 !important;
        }
    </style>
    <script type="text/javascript">
        selectedItem = [];

        $(document).ready(function () {
            loadSupplier(function () {
                loadInsuranceSupplier(function () {

                });
            });
        });

        var loadSupplier = function (callback) {
            ddlWSupplier = $('#ddlWSupplier');
            ddlASupplier = $('#ddlASupplier');
            ddlAMCSupplier = $('#ddlAMCSupplier');
            ddlServiceSupplier = $('#ddlServiceSupplier');
            serverCall('Services/WebService.asmx/loadSupplier', {}, function (response) {
                ddlWSupplier.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'LedgerName', isSearchAble: true });
                ddlASupplier.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'LedgerName', isSearchAble: true });
                ddlAMCSupplier.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'LedgerName', isSearchAble: true });
                ddlServiceSupplier.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'LedgerName', isSearchAble: true, customAttr: ['ContactPerson', 'Address', 'Mobile'] });
                callback(ddlWSupplier.val());
            });
        }
        var loadInsuranceSupplier = function (callback) {
            ddlInsSupplier = $('#ddlInsSupplier');
            serverCall('Services/WebService.asmx/loadInsuranceSupplier', {}, function (response) {
                ddlInsSupplier.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'LedgerName', isSearchAble: true });
                callback(ddlInsSupplier.val());
            });
        }

        var Search = function () {
            data = {
                DateSearchBy: $('#ddlFromDate').val(),
                FromDate: $('#txtFromDate').val().trim(),
                ToDate: $('#txtToDate').val().trim(),
                SearchID: $('#ddlSearchID').val(),
                SearchValue: $('#txtSearchValue').val().trim(),
                IsPending: $('#chkPending').is(':checked') ? '1' : '0',
                PendingID: $('#ddlPendigID').val(),
            }
            serverCall('Services/WarrantyAMC.asmx/SearchGRNDataforWarrantyAMC', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    HideandShow('Search');
                    bindGRNDetail(responseData);
                }
                else {
                    modelAlert('No Record Found');
                    $('.search').addClass('hidden');
                    $('.warranty').addClass('hidden').find('table tbody').empty();
                }
            });
        }

        var bindGRNDetail = function (data) {
            $('#tblAsset tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblAsset tbody tr').length + 1;
                var row = '<tr class="trData">';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdGRNNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].GRNNo + '</td>';
                row += '<td id="tdPurchaseDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PurchaseDate + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].InvoiceNo + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].InvoiceDate + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td id="tdBatchNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BatchNumber + '</td>';
                row += '<td id="tdModelNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ModelNo + '</td>';
                row += '<td id="tdSerialNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SerialNo + '</td>';
                row += '<td id="tdAssetNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetNo + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="checkbox" onchange="getSelectedItem(this);" data-title="Select to Enter Details"/></td>';

                if (data[i].IsWarrantyEntered == '1')
                    row += '<td id="warranty" class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/Ok.png" onclick="ShowDetailModal(this);" style="cursor: pointer;" data-title="Click to View Warranty Details" /></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/NotOk.png" style="cursor: pointer;" data-title="Warranty Not Added." /></td>';

                if (data[i].IsAmcEntered == '1')
                    row += '<td id="amc" class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/Ok.png" onclick="ShowDetailModal(this);" style="cursor: pointer;" data-title="Click to View AMC Details" /></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/NotOk.png" style="cursor: pointer;" data-title="AMC Not Added" /></td>';

                if (data[i].IsInsuranceEntered == '1')
                    row += '<td id="insurance" class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/Ok.png" onclick="ShowDetailModal(this);" style="cursor: pointer;" data-title="Click to View Insurance Details" /></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/NotOk.png" style="cursor: pointer;" data-title="Insurance Not Added" /></td>';

                if (data[i].IsServiceEntered == '1')
                    row += '<td id="service" class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/Ok.png" onclick="ShowDetailModal(this);" style="cursor: pointer;" data-title="Click to View Service Provider Details" /></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/NotOk.png" style="cursor: pointer;" data-title="Service Provider Not Added"/></td>';

                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img src="../../Images/uploaddocument.png" style="cursor: pointer;" data-title="Click to Upload Documents" onclick ="OpenDocumentModal(this);" /></td>';
                row += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].ItemID + '</td>';
                row += '<td id="tdAssetID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].AssetID + '</td>';
                row += '</tr>';
                $('#tblAsset tbody').append(row);
                MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
            }
        }

        var getSelectedItem = function (elem) {
                $('.selectedlist').removeClass('hidden');
                selectedItem.length = 0;
                $tbl = $('#tblAsset tbody tr').clone();
                var CurentGRN = $(elem).closest('tr').find('#tdGRNNo').text().trim();
                $tbl.each(function (i, e) {
                    if ($(e).find('input[type=checkbox]').is(':checked') && CurentGRN == $(e).find('#tdGRNNo').text()) {
                        ItemName = $(e).find('#tdItemName').text() + ' (Serial No.: ' + $(e).find('#tdSerialNo').text() + ')';
                        selectedItem.push({
                            ItemID: $(e).find('#tdItemID').text(),
                            ItemName: ItemName,
                            AssetID: $(e).find('#tdAssetID').text(),
                            PurchaseDate: $(e).find('#tdPurchaseDate').text(),
                        });
                        binditemlistUL($(e).find('#tdAssetID').text(), ItemName, function () { });
                    }
                    else {
                        $('#ulitemlist #' + $(e).find('#tdAssetID').text()).remove();
                        $(e).find('input[type=checkbox]').prop('checked', false);
                    }
                });
        }

        var binditemlistUL = function (assetid, itemname, callback) {
            var ItemList = $('#divitemlist')
            var ob = ItemList.find('#ulitemlist')
            var isExist = $(ob).find('#' + assetid);
            if (isExist.length < 1) {
                ItemList.find('ul').append('<li id=' + assetid + ' class="search-choice"><span style="color: blue;font-weight: 700;">' + itemname + '</span></li>');
            }
            callback();
        }
        var checkAssetValidate = function (callback) {
            var isChecked = 0;

            if ($('#tblAsset tbody tr').filter(function () {
                return ($(this).find('input[type=checkbox]').is(':checked'))
            }).length > 0) {
                isChecked = 1;
            }
            if (isChecked == 0) {
                modelAlert('Please Select Any Asset to Enter Details');
                return false;
            }
            callback(true);
        }
        var showWarrantyDiv = function () {
            checkAssetValidate(function () {
                loadWarratyAssetItem(function () {
                    HideandShow('WarrantyShow');
                });
            });
        }
        var loadWarratyAssetItem = function (callback) {
            ddlWItemName = $('#ddlWItemName');
            response = selectedItem;
            ddlWItemName.bindDropDown({ defaultValue: 'Select', data: response, valueField: 'ItemID', textField: 'ItemName', isSearchAble: true, customAttr: ['AssetID'] });
            callback(ddlWItemName.val());
        }
        var loadAccessories = function (ItemID, callback) {
            if ($(ItemID).val() == 0) {
                return false;
            }
            ddlWAccessories = $('#ddlWAccessories');
            serverCall('Services/WebService.asmx/bindtaggesAccessories', { GRNNo: 0, ItemID: 0, AssetID: $(ItemID).find('option:selected').attr('AssetID') }, function (response) {
                ddlWAccessories.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'AccessoriesID', textField: 'AccessoriesName', isSearchAble: true, customAttr: ['AssetID'] });
                callback(ddlWAccessories.val());
            });
        }

        var CalculateWarrantyPeriod = function (FromDate, periodvalue, periodType, callback) {
            var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            var PurchaseDate = FromDate;
            var perioddate = new Date(PurchaseDate);
            if (periodType == "D")
                perioddate.setDate(perioddate.getDate() + periodvalue);
            else if (periodType == "M")
                perioddate.setMonth(perioddate.getMonth() + periodvalue);
            else
                perioddate.setFullYear(perioddate.getFullYear() + periodvalue);

            var WarrantyTo = perioddate.getDate() + '-' + monthNames[perioddate.getMonth()] + '-' + perioddate.getFullYear()
            callback({ WarrantyFrom: PurchaseDate, WarrantyTo: WarrantyTo })
        }
        var AddWarranty = function () {
            data = [];
            WarrantyPeriod = [];
            CalculateWarrantyPeriod(selectedItem[0].PurchaseDate, Number($('#txtWPeriod').val().trim()), $('#ddlWPeriod').val(), function (response) {
                WarrantyPeriod = response;
            });
            data.push({
                SupplierID: $('#ddlWSupplier').val(),
                SupplierName: $('#ddlWSupplier option:selected').text(),
                Period: $('#txtWPeriod').val().trim() + ' ' + $('#ddlWPeriod option:selected').text(),
                PeriodValue: $('#txtWPeriod').val(),
                Remarks: $('#txtWRemarks').val().trim(),
                WarrantyFrom: WarrantyPeriod.WarrantyFrom,
                WarrantyTo: WarrantyPeriod.WarrantyTo,
            });
            if (data[0].SupplierID == 0) {
                modelAlert('Please Select Supplier', function () {
                    $('#ddlWSupplier').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data[0].PeriodValue) || data[0].PeriodValue == 0) {
                modelAlert('Please Enter Warranty Period', function () {
                    $('#txtWPeriod').focus();
                });
                return false;
            }
            isValidate = 1;
            if ($('#tblWarranty tbody tr #tdSupplierID').filter(function () { return ($(this).text().trim() == data[0].SupplierID) }).length > 0) {
                isValidate = 0;
            }
            if (isValidate == 0) {
                modelAlert('Supplier Already Selected');
                return false;
            }
            bindWarrantyDetail(data);
        }
        var bindWarrantyDetail = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblWarranty tbody tr').length + 1;
                var row = '<tr>';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdSupplierID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td id="tdWarrantyFrom" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyFrom + '</td>';
                row += '<td id="tdWarrantyto" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyTo + '</td>';
                row += '<td id="tdwPeriod" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Period + '</td>';
                row += '<td id="tdwRemarks" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre"><img id="imgEdit" src="../../Images/Delete.gif" onclick="removeWarranty(this);" style="cursor: pointer;" title="Click To Remove" /></td>';
                row += '</tr>';
                $('#tblWarranty tbody').append(row);
            }
        }

        var removeWarranty = function (rowID) {
            var i = rowID.parentNode.parentNode.rowIndex;
            document.getElementById("tblWarranty").deleteRow(i);
            var j = 1;
            $('#tblWarranty tbody tr').each(function () {
                $(this).find('#tdsrno').html(j);
                j++;
            });
        }
        var AddAccessories = function () {
            data = [];
            WarrantyPeriod = [];
            CalculateWarrantyPeriod(selectedItem[0].PurchaseDate, Number($('#txtAPeriod').val().trim()), $('#ddlAPeriod').val(), function (response) {
                WarrantyPeriod = response;
            });
            data.push({
                SupplierID: $('#ddlASupplier').val(),
                SupplierName: $('#ddlASupplier option:selected').text(),
                Period: $('#txtAPeriod').val().trim() + ' ' + $('#ddlAPeriod option:selected').text(),
                PeriodValue: $('#txtAPeriod').val(),
                Remarks: $('#txtARemarks').val().trim(),
                WarrantyFrom: WarrantyPeriod.WarrantyFrom,
                WarrantyTo: WarrantyPeriod.WarrantyTo,
                ItemID: $('#ddlWItemName').val(),
                ItemName: $('#ddlWItemName option:selected').text(),
                AssetID: $('#ddlWItemName option:selected').attr('AssetID'),
                AccessoriesID: $('#ddlWAccessories').val(),
                AccessoriesName: $('#ddlWAccessories option:selected').text(),
            });
            if (data[0].ItemID == 0) {
                modelAlert('Please Select Item', function () {
                    $('#ddlWItemName').focus();
                });
                return false;
            }
            if (data[0].AccessoriesID == 0) {
                modelAlert('Please Select Item', function () {
                    $('#ddlWAccessories').focus();
                });
                return false;
            }
            if (data[0].SupplierID == 0) {
                modelAlert('Please Select Supplier', function () {
                    $('#ddlWSupplier').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data[0].PeriodValue) || data[0].PeriodValue == 0) {
                modelAlert('Please Enter Warranty Period', function () {
                    $('#txtWPeriod').focus();
                });
                return false;
            }
            isDuplicate = 1;
            $('#tblAccess tbody tr').each(function (i, row) {
                if (($(row).find('#tdAccessoriesID').text().trim() == data[0].AccessoriesID) && ($(row).find('#tdAAssetID').text().trim() == data[0].AssetID) && ($(row).find('#tdASupplierID').text().trim() == data[0].SupplierID)) {
                    isDuplicate = 1;
                }
            });
            if (isDuplicate == 0) {
                modelAlert('Supplier Already Added for this Accessories');
                return false;
            }
            bindAccessoriesDetail(data);
        }
        var bindAccessoriesDetail = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblAccess tbody tr').length + 1;
                var row = '<tr>';
                row += '<td id="tdAsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdASupplierID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td id="tdAItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '<td id="tdAAssetID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].AssetID + '</td>';
                row += '<td id="tdAccessoriesID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].AccessoriesID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AccessoriesName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SupplierName + '</td>';
                row += '<td id="tdAWarrantyFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].WarrantyFrom + '</td>';
                row += '<td id="tdAWarrantyTo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].WarrantyTo + '</td>';
                row += '<td id="tdAPeriod" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Period + '</td>';
                row += '<td id="tdARemarks" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre"><img id="imgEdit" src="../../Images/Delete.gif" onclick="removeAccessories(this);" style="cursor: pointer;" title="Click To Remove" /></td>';
                row += '</tr>';
                $('#tblAccess tbody').append(row);
            }
        }
        var removeAccessories = function (rowID) {
            var i = rowID.parentNode.parentNode.rowIndex;
            document.getElementById("tblAccess").deleteRow(i);
            var j = 1;
            $('#tblAccess tbody tr').each(function () {
                $(this).find('#tdAsrno').html(j);
                j++;
            });
        }
        var SaveWarranty = function () {
            getWarrantyDetails(function (data) {
                serverCall('Services/WarrantyAMC.asmx/SaveWarrantyDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            HideandShow('WarrantySave');
                        });
                    }
                    else {
                        modelAlert(responseData.response, function () {

                        });
                    }
                });
            });
        }
        var getWarrantyDetails = function (callback) {
            warranty = [];
            accessories = [];
            ItemDetails = selectedItem;

            var tbwarranty = $('#tblWarranty tbody tr').clone();
            $(tbwarranty).each(function (index, row) {
                warranty.push({
                    SupplierID: $(row).find('#tdSupplierID').text().trim(),
                    WarrantyFrom: $(row).find('#tdWarrantyFrom').text().trim(),
                    WarrantyTo: $(row).find('#tdWarrantyto').text().trim(),
                    Period: $(row).find('#tdwPeriod').text().trim(),
                    Remarks: $(row).find('#tdwRemarks').text().trim(),
                });
            });
            if (warranty.length < 1) {
                modelAlert('Please Add Warranty Details');
                return false;
            }

            var tbAccess = $('#tblAccess tbody tr').clone();
            $(tbAccess).each(function (index, row) {
                accessories.push({
                    SupplierID: $(row).find('#tdASupplierID').text().trim(),
                    ItemID: $(row).find('#tdAItemID').text().trim(),
                    AssetID: $(row).find('#tdAAssetID').text().trim(),
                    AccessoriesID: $(row).find('#tdAccessoriesID').text().trim(),
                    WarrantyFrom: $(row).find('#tdAWarrantyFrom').text().trim(),
                    WarrantyTo: $(row).find('#tdAWarrantyTo').text().trim(),
                    Period: $(row).find('#tdAPeriod').text().trim(),
                    Remarks: $(row).find('#tdARemarks').text().trim(),
                });
            });

            if (accessories.length < 1) {
                modelConfirmation('Are you sure ?', 'Accessories Warranty Detail is not Added', 'Continue', 'Cancel', function (status) {
                    if (status) {
                        callback({ warranty: warranty, ItemDetails: ItemDetails, accessories: accessories });
                    }
                    else
                        return false;
                });
            }
            else {
                callback({ warranty: warranty, ItemDetails: ItemDetails, accessories: accessories });
            }
        }

        //---------Add AMC Start ---- 
        var showAMCDiv = function () {
            checkAssetValidate(function () {
                HideandShow('AmcShow');
            });
        }

        var AddAMC = function () {
            data = [];
            AmcPeriod = [];
            CalculateWarrantyPeriod($('#txtAMCFromDate').val(), Number($('#txtAMCPeriodValue').val().trim()), $('#ddlAMCPeriod').val(), function (response) {
                AmcPeriod = response;
            });
            data.push({
                SupplierID: $('#ddlAMCSupplier').val(),
                SupplierName: $('#ddlAMCSupplier option:selected').text(),
                Period: $('#txtAMCPeriodValue').val().trim() + ' ' + $('#ddlAMCPeriod option:selected').text(),
                PeriodValue: $('#txtAMCPeriodValue').val(),
                Remarks: $('#txtAMCRemarks').val().trim(),
                WarrantyFrom: AmcPeriod.WarrantyFrom,
                WarrantyTo: AmcPeriod.WarrantyTo,
                AMCAmount: $('#txtAMCAmount').val().trim(),
                NoOfVisit: $('#txtNoOfVisit').val().trim(),
            });
            if (data[0].SupplierID == 0) {
                modelAlert('Please Select Supplier', function () {
                    $('#ddlWSupplier').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data[0].PeriodValue) || data[0].PeriodValue == 0) {
                modelAlert('Please Enter AMC Up to Period', function () {
                    $('#txtWPeriod').focus();
                });
                return false;
            }
            if (data[0].AMCAmount == 0) {
                modelAlert('Please Enter AMC Amount', function () {
                    $('#txtAMCAmount').focus();
                });
                return false;
            }
            isValidate = 1;
            if ($('#tblAMC tbody tr #tdAMCSupplierID').filter(function () { return ($(this).text().trim() == data[0].SupplierID) }).length > 0) {
                isValidate = 0;
            }
            if (isValidate == 0) {
                modelAlert('Supplier Already Selected');
                return false;
            }
            bindAMCDetail(data);
        }

        var bindAMCDetail = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblAMC tbody tr').length + 1;
                var row = '<tr>';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdAMCSupplierID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td id="tdAMCWarrantyFrom" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyFrom + '</td>';
                row += '<td id="tdAMCWarrantyto" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyTo + '</td>';
                row += '<td id="tdAMCAmount" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].AMCAmount + '</td>';
                row += '<td id="tdAMCNoOfVisit" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].NoOfVisit + '</td>';
                row += '<td id="tdAMCRemarks" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre"><img id="imgEditAMC" src="../../Images/Delete.gif" onclick="removeAMC(this);" style="cursor: pointer;" title="Click To Remove" /></td>';
                row += '</tr>';
                $('#tblAMC tbody').append(row);
            }
        }

        var SaveAMC = function () {
            getAMCDetails(function (data) {
                serverCall('Services/WarrantyAMC.asmx/SaveAMCDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            HideandShow('AMCSave');
                        });
                    }
                    else {
                        modelAlert(responseData.response, function () {
                        });
                    }
                });
            });
        }

        var getAMCDetails = function (callback) {
            amc = [];
            ItemDetails = selectedItem;

            var tbAMC = $('#tblAMC tbody tr').clone();
            $(tbAMC).each(function (index, row) {
                amc.push({
                    SupplierID: $(row).find('#tdAMCSupplierID').text().trim(),
                    WarrantyFrom: $(row).find('#tdAMCWarrantyFrom').text().trim(),
                    WarrantyTo: $(row).find('#tdAMCWarrantyto').text().trim(),
                    Remarks: $(row).find('#tdAMCRemarks').text().trim(),
                    Amount: $(row).find('#tdAMCAmount').text().trim(),
                    NoOfVisit: $(row).find('#tdAMCNoOfVisit').text().trim(),
                });
            });
            if (amc.length < 1) {
                modelAlert('Please Add AMC Details');
                return false;
            }

            callback({ amc: amc, ItemDetails: ItemDetails });

        }

        //---------Add AMC END ----

        //--------- Add Insurance Start ----------

        var showInsuranceDiv = function () {
            checkAssetValidate(function () {
                HideandShow('InsuranceShow');
            });
        }

        var AddInsurance = function () {
            data = [];
            data.push({
                SupplierID: $('#ddlInsSupplier').val(),
                SupplierName: $('#ddlInsSupplier option:selected').text(),
                FromDate: $('#txtInsuranceFromDate').val().trim(),
                ToDate: $('#txtInsuranceToDate').val().trim(),
                InsuranceAmount: $('#txtInsuranceAmount').val().trim(),
                RiskCoverageAmount: $('#txtRiskCoverageAmount').val().trim(),
                Remarks: $('#txtInsuranceRemarks').val().trim(),
            });
            if (data[0].SupplierID == 0) {
                modelAlert('Please Select Supplier', function () {
                    $('#ddlInsSupplier').focus();
                });
                return false;
            }
            if (Number(data[0].InsuranceAmount) == 0) {
                modelAlert('Please Enter Insurance Amount', function () {
                    $('#txtInsuranceAmount').focus();
                });
                return false;
            }
            if (Number(data[0].RiskCoverageAmount) == 0) {
                modelAlert('Please Enter Risk Coverage Amount', function () {
                    $('#txtRiskCoverageAmount').focus();
                });
                return false;
            }
            //isValidate = 1;
            //if ($('#tblAMC tbody tr #tdAMCSupplierID').filter(function () { return ($(this).text().trim() == data[0].SupplierID) }).length > 0) {
            //    isValidate = 0;
            //}
            //if (isValidate == 0) {
            //    modelAlert('Supplier Already Selected');
            //    return false;
            //}
            bindInsuranceDetail(data);
        }

        var bindInsuranceDetail = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblInsurance tbody tr').length + 1;
                var row = '<tr>';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdInsSupplierID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td id="tdInsFrom" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].FromDate + '</td>';
                row += '<td id="tdInsTo" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].ToDate + '</td>';
                row += '<td id="tdInsAmount" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].InsuranceAmount + '</td>';
                row += '<td id="tdRiskAmount" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].RiskCoverageAmount + '</td>';
                row += '<td id="tdInsRemarks" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre"><img id="imgEditIns" src="../../Images/Delete.gif" onclick="removeInsurance(this);" style="cursor: pointer;" title="Click To Remove" /></td>';
                row += '</tr>';
                $('#tblInsurance tbody').append(row);
            }
        }
        var removeInsurance = function (rowID) {
            var i = rowID.parentNode.parentNode.rowIndex;
            document.getElementById("tblInsurance").deleteRow(i);
            var j = 1;
            $('#tblInsurance tbody tr').each(function () {
                $(this).find('#tdsrno').html(j);
                j++;
            });
        }

        var SaveInsurance = function () {
            getInsuranceDetails(function (data) {
                serverCall('Services/WarrantyAMC.asmx/SaveInsuranceDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            HideandShow('InsuranceSave');
                        });
                    }
                    else {
                        modelAlert(responseData.response, function () {
                        });
                    }
                });
            });
        }

        var getInsuranceDetails = function (callback) {
            insurance = [];
            ItemDetails = selectedItem;

            var tblInsurance = $('#tblInsurance tbody tr').clone();
            $(tblInsurance).each(function (index, row) {
                insurance.push({
                    SupplierID: $(row).find('#tdInsSupplierID').text().trim(),
                    FromDate: $(row).find('#tdInsFrom').text().trim(),
                    ToDate: $(row).find('#tdInsTo').text().trim(),
                    Remarks: $(row).find('#tdInsRemarks').text().trim(),
                    InsuranceAmount: $(row).find('#tdInsAmount').text().trim(),
                    RiskCoverageAmount: $(row).find('#tdRiskAmount').text().trim(),
                });
            });
            if (insurance.length < 1) {
                modelAlert('Please Add Insurance Details');
                return false;
            }

            callback({ insurance: insurance, ItemDetails: ItemDetails });

        }

        //--------- Add Insurance End ----------

        //-----------Start Add Service Provider-------

        var showServiceDiv = function () {
            checkAssetValidate(function () {
                HideandShow('SerivceProvShow');
            });
        }

        var AddService = function () {
            data = [];
            data.push({
                SupplierID: $('#ddlServiceSupplier').val(),
                SupplierName: $('#ddlServiceSupplier option:selected').text(),
                ContactPerson: $('#ddlServiceSupplier option:selected').attr('contactperson'),
                Address: $('#ddlServiceSupplier option:selected').attr('address'),
                Mobile: $('#ddlServiceSupplier option:selected').attr('mobile'),
                Remarks: $('#txtServiceRemarks').val().trim(),
            });
            if (data[0].SupplierID == 0) {
                modelAlert('Please Select Supplier', function () {
                    $('#ddlServiceSupplier').focus();
                });
                return false;
            }
            bindServiceProiderDetail(data);
        }

        var bindServiceProiderDetail = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblServiceProvider tbody tr').length + 1;
                var row = '<tr>';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdServiceSupplierID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td id="tdServiceContPerson" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].ContactPerson + '</td>';
                row += '<td id="tdServiceMobile" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Mobile + '</td>';
                row += '<td id="tdServiceAddress" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Address + '</td>';
                row += '<td id="tdServiceRemarks" class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre"><img id="imgEditIns" src="../../Images/Delete.gif" onclick="removeServiceProvider(this);" style="cursor: pointer;" title="Click To Remove" /></td>';
                row += '</tr>';
                $('#tblServiceProvider tbody').append(row);
            }
        }

        var removeServiceProvider = function (rowID) {
            var i = rowID.parentNode.parentNode.rowIndex;
            document.getElementById("tblServiceProvider").deleteRow(i);
            var j = 1;
            $('#tblServiceProvider tbody tr').each(function () {
                $(this).find('#tdsrno').html(j);
                j++;
            });
        }

        var SaveServiceProvider = function () {
            getServiceProviderDetails(function (data) {
                serverCall('Services/WarrantyAMC.asmx/SaveServiceProviderDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            HideandShow('SerivceProvSave');
                        });
                    }
                    else {
                        modelAlert(responseData.response, function () {
                        });
                    }
                });
            });
        }

        var getServiceProviderDetails = function (callback) {
            serviceprovider = [];
            ItemDetails = selectedItem;

            var tblServiceProvider = $('#tblServiceProvider tbody tr').clone();
            $(tblServiceProvider).each(function (index, row) {
                serviceprovider.push({
                    SupplierID: $(row).find('#tdServiceSupplierID').text().trim(),
                    Remarks: $(row).find('#tdServiceRemarks').text().trim(),
                });
            });
            if (serviceprovider.length < 1) {
                modelAlert('Please Add Service Details');
                return false;
            }

            callback({ serviceprovider: serviceprovider, ItemDetails: ItemDetails });

        }

        //-----------End Serivce Provider

        //-----------Start Not Applicable---------------


        var showNotApplicableDiv = function () {
            checkAssetValidate(function () {
                HideandShow('NotAppShow');
            });
        }

        var AddNTDetail = function (elem) {
            ischecked = $(elem).is(':checked');
            detailid = $(elem).val();

            data = [];
            data.push({
                DetailID: detailid,
            });


            IsDuplicate = 0;
            $('#tblNotApplicable tbody tr').each(function (i, row) {
                if ($(row).find('#tdDetailID').text() == data[0].DetailID) {
                    IsDuplicate = 1;
                    $(row).remove();
                }
            });

            if (IsDuplicate == 0 && ischecked) {
                bindNotApplicableDetail(data);
            }

        }

        var removeNotApplicableDetail = function (rowID) {
            $(rowID).closest('tr').remove();
        }

        var bindNotApplicableDetail = function (data) {
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblNotApplicable tbody tr').length + 1;
                var row = '<tr id=' + data[i].DetailID + '>';
                row += '<td id="tdDetailID" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DetailID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre"><input type="text" /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre"><img id="imgEditAMC" src="../../Images/Delete.gif" onclick="removeNotApplicableDetail(this);" style="cursor: pointer;" title="Click To Remove" /></td>';
                row += '</tr>';
                $('#tblNotApplicable tbody').append(row);
            }
        }


        var SaveNotApplicable = function () {
            getNotApplicableDetails(function (data) {
                serverCall('Services/WarrantyAMC.asmx/SaveNotApplicableDetails', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            HideandShow('NotAppSave');
                        });
                    }
                    else {
                        modelAlert(responseData.response, function () {
                        });
                    }
                });
            });
        }

        var getNotApplicableDetails = function (callback) {
            notapplicable = [];
            ItemDetails = selectedItem;

            var tblNotApplicable = $('#tblNotApplicable tbody tr').clone();
            $(tblNotApplicable).each(function (index, row) {
                notapplicable.push({
                    DetailID: $(row).find('#tdDetailID').text().trim(),
                    Remarks: $(row).find('input[type=text]').val().trim(),
                });
            });
            if (notapplicable.length < 1) {
                modelAlert('Please Select Not Applicable');
                return false;
            }
            var blankremarks = notapplicable.filter(function (i) {
                if (String.isNullOrEmpty(i.Remarks)) {
                    return i;
                }
            });
            if (blankremarks.length > 0) {
                modelAlert('Please Enter Remarks for Each Details.');
                return false;
            }
            callback({ notapplicable: notapplicable, ItemDetails: ItemDetails });

        }
        //-----------End Not Applicable---------------

        //---------Start UploadDocument--------
        var OpenDocumentModal = function (rowID) {
            var row = $(rowID).closest('tr');
            var AssetID = row.find('#tdAssetID').text().trim();
            $('#SpnDocAssetID').text(AssetID);
            $('#SpnDocGRNNo').text(row.find('#tdGRNNo').text().trim());
            $('#spnDocItemName').text(row.find('#tdItemName').text().trim());
            $('#spnDocAssetNo').text(row.find('#tdAssetNo').text().trim());
            $('#spnDocBatchNo').text(row.find('#tdBatchNo').text().trim());
            $('#spnDocModelNo').text(row.find('#tdModelNo').text().trim());
            $('#spnDocSerialNo').text(row.find('#tdSerialNo').text().trim());

            $('#divDocumentUpload').showModel();
            loaddocument(AssetID, function () { });
        }
        var loaddocument = function (AssetID, callback) {
            serverCall('Services/WarrantyAMC.asmx/BindAssetDocument', { AssetID: AssetID }, function (response) {
                var responseData = JSON.parse(response);
                bindAssetDocumentDetails(responseData);
                callback(true);

            });
        }
        var bindAssetDocumentDetails = function (data) {
            var row = '';
            $('#tblDocuemnt tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tblDocuemnt tbody tr').length + 1;
                var color = data[i].STATUS == 'true' ? 'lightgreen' : ''
                var show = data[i].STATUS == 'true' ? 'block' : 'none'
                var url = encodeURIComponent(data[i].Url);
                row += '<tr id="' + data[i].ID + '" style="background-color:' + color + '">';
                row += '<td id="tdsrno" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdDocumentID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].DocumentName + '</td>';
                row += '<td class="GridViewLabItemStyle" ><input type="file"  accept=".pdf,.gif,.jpg,.jpeg,.png,.doc,.docx,.txt.xlsx"  id="' + data[i].ID + '" /></td>'
                row += '<td class="GridViewLabItemStyle" ><input type="text"  id="' + data[i].ID + '"  value="' + data[i].Remark + '" /></td>'
                row += '<td class="GridViewLabItemStyle" >' + data[i].Upload_Date + '</td>'
                row += '<td class="GridViewLabItemStyle" ><a target="_blank" onclick="showdocument(this)" url="' + url + '"  style="display:' + show + '" ><img style="cursor:pointer" src="../../Images/view.GIF" ></a></td>'
                row += '</tr>';
            }
            $('#tblDocuemnt tbody').append(row);
        }

        var UploadDocument = function () {
            var result = "";
            $('#tblDocuemnt tbody').find('input[type=file]').each(function () {
                var id = $(this).closest('tr').attr('id');
                var fileupload = $(this).closest('tr').find('input[type=file]').get(0);
                var Remark = $(this).closest('tr').find('input[type=text]').val();
                var AssetID = $('#SpnDocAssetID').text().trim();
                var UserID = '<%=Util.GetString(Session["ID"])%>';
                var files = fileupload.files;
                var Data = new FormData();
                for (var i = 0; i < files.length; i++) {
                    Data.append(files[i].name, files[i]);
                }
                Data.append('AssetID', AssetID);
                Data.append('ID', id);
                Data.append('Remark', Remark);
                Data.append('UserID', UserID);
                if (files.length > 0) {
                    $.ajax({
                        url: 'Services/ImageHandler.ashx',
                        type: 'POST',
                        data: Data,
                        cache: false,
                        contentType: false,
                        processData: false,
                        success: function (result) {
                            loaddocument(AssetID, function () { $('#tblDocuemnt tbody').find('input[type=file]').val(''); });
                        },
                        error: function (err) { alert(err.statusText); }
                    });
                }
            });
        }

        function showdocument(el) {
            var Path = $(el).closest('a').attr('url');
            window.open("Showdocument.aspx?p=" + Path + "", "AssetDocumentPDFWindow", "width=600,height=600");
        }

        //---------End UploadDocument--------

        var ShowDetailModal = function (rowID) {
            var row = $(rowID).closest('tr');
            var AssetID = row.find('#tdAssetID').text().trim();
            var Detailfor = $(rowID).closest('td').attr("id");
            $('#SpnDAssetID').text(AssetID);
            $('#spnDGRNNo').text(row.find('#tdGRNNo').text().trim());
            $('#spnDItemName').text(row.find('#tdItemName').text().trim());
            $('#spnDAssetNo').text(row.find('#tdAssetNo').text().trim());
            $('#spnDBatchNo').text(row.find('#tdBatchNo').text().trim());
            $('#spnDModelNo').text(row.find('#tdModelNo').text().trim());
            $('#spnDSerialNo').text(row.find('#tdSerialNo').text().trim());
            if (Detailfor == "warranty") {
                $('#spnDetailName').text('Warranty Details');
                loadWarrantyDetails(AssetID, function (response) {
                    bindAddedWarrantyDetails(response);
                });
                HideandShow('viewwarrantydetail');
            }
            else if (Detailfor == "amc") {
                $('#spnDetailName').text('AMC Details');
                loadAMCDetails(AssetID, function (response) {
                    bindAddedAMCDetails(response);
                });
                HideandShow('viewamcdetail');
            }
            else if (Detailfor == "insurance") {
                $('#spnDetailName').text('Insurance Details');
                loadInsuranceDetails(AssetID, function (response) {
                    bindAddedInsuranceDetails(response);
                });
                HideandShow('viewinsurancedetail');
            }
            else if (Detailfor == "service") {
                $('#spnDetailName').text('Service Provider Details');
                loadServiceProviderDetails(AssetID, function (response) {
                    bindAddedServiceProviderDetails(response);
                });
                HideandShow('viewservicedetail');
            }
            $('#divDetails').showModel();
        }

        var loadWarrantyDetails = function (AssetID, callback) {
            serverCall('Services/WarrantyAMC.asmx/LoadWarrantyDetails', { AssetID: AssetID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }
        var loadAMCDetails = function (AssetID, callback) {
            serverCall('Services/WarrantyAMC.asmx/LoadAMCDetails', { AssetID: AssetID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }
        var loadInsuranceDetails = function (AssetID, callback) {
            serverCall('Services/WarrantyAMC.asmx/LoadInsuranceDetails', { AssetID: AssetID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }
        var loadServiceProviderDetails = function (AssetID, callback) {
            serverCall('Services/WarrantyAMC.asmx/LoadServiceProviderDetails', { AssetID: AssetID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }

        var bindAddedWarrantyDetails = function (data) {
            $('.warrantydetail table tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('.warrantydetail table tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyFrom + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyTo + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Period + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedDate + '</td>';
                row += '</tr>';
                $('.warrantydetail table tbody').append(row);
            }
        }

        var bindAddedAMCDetails = function (data) {
            $('.amcdetail table tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('.amcdetail table tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyFrom + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].WarrantyTo + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].AMCAmount + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].NoOfVisit + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedDate + '</td>';
                row += '</tr>';
                $('.amcdetail table tbody').append(row);
            }
        }
        var bindAddedInsuranceDetails = function (data) {
            $('.insurancedetail table tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('.insurancedetail table tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].FromDate + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].ToDate + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].InsuranceAmount + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].RiskCoverageAmount + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedDate + '</td>';
                row += '</tr>';
                $('.insurancedetail table tbody').append(row);
            }
        }
        var bindAddedServiceProviderDetails = function (data) {
            $('.servicedetail table tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('.servicedetail table tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SupplierID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].SupplierName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].ContactPerson + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Mobile + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Address + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align:centre">' + data[i].CreatedDate + '</td>';
                row += '</tr>';
                $('.servicedetail table tbody').append(row);
            }
        }

        var HideandShow = function (DivID) {
            if (DivID == "Search") {
                $('.search').removeClass('hidden');
                $('#btnWarranty,#btnAMC,#btnInsurance,#btnServiceP,#btnNotApplicable').removeClass('CurrentButton');
                $('.warranty').find('input[type=text]').val('');
                $('.warranty').find('textarea').val('');
                $('.warranty').addClass('hidden').find('table tbody').empty();
                $('.insurance').find('input[type=text]').not('#txtInsuranceFromDate,#txtInsuranceToDate').val('');
                $('.insurance').addClass('hidden').find('table tbody').empty();
                $('.insurance').find('textarea').val('');
                $('.amc').find('input[type=text]').not('#txtAMCFromDate').val('');;
                $('.amc').addClass('hidden').find('table tbody').empty();
                $('.amc').find('textarea').val('');
                $('.serviceprov').find('input[type=text]').val('');
                $('.serviceprov').addClass('hidden').find('table tbody').empty();
                $('.serviceprov').find('textarea').val('');
                $('#divAssetSearch').removeClass('hidden');
                $('.selectedlist').addClass('hidden').find('ul').empty();
            }
            else if (DivID == "WarrantyShow") {
                $('.warranty').removeClass('hidden');
                $('#divAssetSearch').addClass('hidden');
                $('.amc').addClass('hidden');
                $('.insurance').addClass('hidden');
                $('.serviceprov').addClass('hidden');
                $('.notappl').addClass('hidden');
                $('#btnWarranty').addClass('CurrentButton');
                $('#btnAMC,#btnInsurance,#btnServiceP,#btnNotApplicable').removeClass('CurrentButton');
            }
            else if (DivID == "WarrantySave") {
                $('.warranty').find('input[type=text]').val('');
                $('.warranty').addClass('hidden').find('table tbody').empty();
            }
            else if (DivID == "AmcShow") {
                $('.warranty').addClass('hidden');
                $('.amc').removeClass('hidden');
                $('.insurance').addClass('hidden');
                $('.serviceprov').addClass('hidden');
                $('.notappl').addClass('hidden');
                $('#divAssetSearch').addClass('hidden');
                $('#btnAMC').addClass('CurrentButton');
                $('#btnWarranty,#btnInsurance,#btnServiceP,#btnNotApplicable').removeClass('CurrentButton');
            }
            else if (DivID == "AmcSave") {
                $('.amc').find('input[type=text]').val('');
                $('.amc').addClass('hidden').find('table tbody').empty();
            }
            else if (DivID == "InsuranceShow") {
                $('.warranty').addClass('hidden');
                $('.amc').addClass('hidden');
                $('.insurance').removeClass('hidden')
                $('.serviceprov').addClass('hidden')
                $('.notappl').addClass('hidden')
                $('#divAssetSearch').addClass('hidden');
                $('#btnInsurance').addClass('CurrentButton');
                $('#btnWarranty,#btnAMC,#btnServiceP,#btnNotApplicable').removeClass('CurrentButton');
            }
            else if (DivID == "InsuranceSave") {
                $('.insurance').find('input[type=text]').val('');
                $('.insurance').addClass('hidden').find('table tbody').empty();
            }
            else if (DivID == "SerivceProvShow") {
                $('.warranty').addClass('hidden');
                $('.amc').addClass('hidden');
                $('.insurance').addClass('hidden')
                $('.serviceprov').removeClass('hidden')
                $('.notappl').addClass('hidden')
                $('#divAssetSearch').addClass('hidden');
                $('#btnServiceP').addClass('CurrentButton');
                $('#btnWarranty,#btnInsurance,#btnAMC,#btnNotApplicable').removeClass('CurrentButton');
            }
            else if (DivID == "SerivceProvSave") {
                $('.serviceprov').find('input[type=text]').val('');
                $('.serviceprov').addClass('hidden').find('table tbody').empty();
            }
            else if (DivID == "NotAppShow") {
                $('.warranty').addClass('hidden');
                $('.amc').addClass('hidden');
                $('.insurance').addClass('hidden')
                $('.serviceprov').addClass('hidden')
                $('.notappl').removeClass('hidden')
                $('#divAssetSearch').addClass('hidden');
                $('#btnNotApplicable').addClass('CurrentButton');
                $('#btnWarranty,#btnInsurance,#btnServiceP,#btnAMC').removeClass('CurrentButton');
            }
            else if (DivID == "NotAppSave") {
                $('.notappl').find('input[type=text]').val('');
                $('.notappl').addClass('hidden').find('table tbody').empty();
            }
            else if (DivID == "viewwarrantydetail") {
                $('.warrantydetail').removeClass('hidden');
                $('.amcdetail').addClass('hidden');
                $('.insurancedetail').addClass('hidden');
                $('.servicedetail').addClass('hidden');
            }
            else if (DivID == "viewamcdetail") {
                $('.warrantydetail').addClass('hidden');
                $('.amcdetail').removeClass('hidden');
                $('.insurancedetail').addClass('hidden');
                $('.servicedetail').addClass('hidden');
            }
            else if (DivID == "viewinsurancedetail") {
                $('.warrantydetail').addClass('hidden');
                $('.amcdetail').addClass('hidden');
                $('.insurancedetail').removeClass('hidden');
                $('.servicedetail').addClass('hidden');
            }
            else if (DivID == "viewservicedetail") {
                $('.warrantydetail').addClass('hidden');
                $('.amcdetail').addClass('hidden');
                $('.insurancedetail').addClass('hidden');
                $('.servicedetail').removeClass('hidden');
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Asset Warranty/AMC/Insurance/Service Provider Entry</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <select id="ddlFromDate" style="width: 120px">
                                <option value="G">From Purchase Date</option>
                                <option value="I">From Invoice Date</option>
                            </select>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ReadOnly="true"> </asp:TextBox>
                            <cc1:CalendarExtender ID="fromdate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ReadOnly="true"> </asp:TextBox>
                            <cc1:CalendarExtender ID="todate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <select id="ddlSearchID" style="width: 120px">
                                <option value="B">BatchNo</option>
                                <option value="M">ModelNo</option>
                                <option value="S">SerialNo</option>
                                <option value="A">AssetNo</option>
                            </select>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearchValue" maxlength="50" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <input type="checkbox" id="chkPending" />Pending
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPendigID">
                                <option value="W">Warranty</option>
                                <option value="A">AMC</option>
                                <option value="I">Insurance</option>
                                <option value="S">Service Provider</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-11"></div>
                <div class="col-md-2 divcentre">
                    <input type="button" id="btnSearch" value="Search" onclick="Search()" />
                </div>
                <div class="col-md-11">
                    <%--<span>W : Warranty</span>&nbsp;&nbsp;&nbsp;                    
                    <span>A : AMC</span>&nbsp;&nbsp;&nbsp;
                    <span>I : Insurance</span>&nbsp;&nbsp;&nbsp;
                    <span>SP : Service Provider</span>--%>
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory hidden" id="divAssetSearch">
            <div class="row">
                <div style="max-height: 200px; overflow-x: auto">
                    <table class="FixedHeader" id="tblAsset" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 10px;">#</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">GRN No.</th>
                                <th class="GridViewHeaderStyle" style="width: 60px;">Pur. Date</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">Invoice No.</th>
                                <th class="GridViewHeaderStyle" style="width: 60px;">Inv. Date</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">ItemName</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">Batch No.</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">Model No.</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">Serial No.</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">Asset No.</th>
                                <th class="GridViewHeaderStyle" style="width: 10px;"></th>
                                <th class="GridViewHeaderStyle" style="width: 20px;">W</th>
                                <th class="GridViewHeaderStyle" style="width: 20px;">A</th>
                                <th class="GridViewHeaderStyle" style="width: 20px;">I</th>
                                <th class="GridViewHeaderStyle" style="width: 20px;">SP</th>
                                <th class="GridViewHeaderStyle" style="width: 20px;">#</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory selectedlist hidden">
            <div class="row">
                <div id="divitemlist" class="chosen-container-multi">
                    <ul id="ulitemlist" style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                    </ul>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory search hidden">
            <div class="row">
                <div class="col-md-5"></div>
                <div class="col-md-3 divcentre">
                    <input type="button" id="btnWarranty" value="Warranty" onclick="showWarrantyDiv()" class="showbutton" />
                </div>
                <div class="col-md-3 divcentre">
                    <input type="button" id="btnAMC" value="AMC" onclick="showAMCDiv()" class="showbutton" />
                </div>
                <div class="col-md-3 divcentre">
                    <input type="button" id="btnInsurance" value="Insurance" onclick="showInsuranceDiv()" class="showbutton" />
                </div>
                <div class="col-md-3 divcentre">
                    <input type="button" id="btnServiceP" value="Service Provider" onclick="showServiceDiv()" class="showbutton" />
                </div>
                <div class="col-md-3 divcentre">
                    <input type="button" id="btnNotApplicable" value="Not Applicable" onclick="showNotApplicableDiv()" class="showbutton" />
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory warranty hidden">
            <div class="Purchaseheader">
                Warranty Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Supplier</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlWSupplier" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Warranty Period</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <select id="ddlWPeriod">
                                <option value="Y">Year</option>
                                <option value="M">Months</option>
                                <option value="D">Days</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtWPeriod" onlynumber="10" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtWRemarks" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;"></textarea>
                        </div>
                    </div>
                    <div class="row divcentre">
                        <input type="button" id="btnAddWarranty" value="Add" onclick="AddWarranty()" />
                    </div>
                    <div class="row">
                        <div style="max-height: 100px; overflow-x: auto">
                            <table class="FixedHeader" id="tblWarranty" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">Warranty From</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Warranty To</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">Period</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row"></div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="Purchaseheader">
                Accessories Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlWItemName" class="requiredField" onchange="loadAccessories($(this),function(){});"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Accessories</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlWAccessories" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Supplier</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlASupplier" class="requiredField"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Warranty Period</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <select id="ddlAPeriod">
                                <option value="Y">Year</option>
                                <option value="M">Months</option>
                                <option value="D">Days</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtAPeriod" onlynumber="10" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtARemarks" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;"></textarea>
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-5">
                            <input type="button" id="btnAddAccessories" value="Add" onclick="AddAccessories()" />
                        </div>
                    </div>
                    <div class="row">
                        <div style="max-height: 100px; overflow-x: auto">
                            <table class="FixedHeader" id="tblAccess" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Item</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Accessories</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">Warranty From</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Warranty To</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">Period</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row divcentre">
                <input type="button" id="btnSaveWarranty" value="Save" onclick="SaveWarranty()" />
            </div>
        </div>
        <div class="POuter_Box_Inventory amc hidden">
            <div class="Purchaseheader">
                AMC Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Supplier</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlAMCSupplier" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Start From</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAMCFromDate" runat="server" ClientIDMode="Static" ReadOnly="true"> </asp:TextBox>
                            <cc1:CalendarExtender ID="cc2" TargetControlID="txtAMCFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Up To</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <select id="ddlAMCPeriod">
                                <option value="Y">Year</option>
                                <option value="M">Months</option>
                                <option value="D">Days</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtAMCPeriodValue" onlynumber="10" maxlength="3" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">AMC Amount</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtAMCAmount" onlynumber="10" maxlength="8" class="requiredField" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">No. of Visit</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtNoOfVisit" onlynumber="10" maxlength="8" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtAMCRemarks" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;"></textarea>
                        </div>
                    </div>
                    <div class="row divcentre">
                        <input type="button" id="btnAddAMC" value="Add" onclick="AddAMC()" />
                    </div>
                    <div class="row">
                        <div style="max-height: 100px; overflow-x: auto">
                            <table class="FixedHeader" id="tblAMC" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">AMC From</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">AMC To</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">AMC Amount</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">No. of Visit</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row divcentre">
                        <input type="button" id="btnSaveAMC" value="Save" onclick="SaveAMC()" />
                    </div>
                    <div class="row"></div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory insurance hidden">
            <div class="Purchaseheader">
                Insurance Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Supplier</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlInsSupplier" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInsuranceFromDate" runat="server" ClientIDMode="Static" ReadOnly="true"> </asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtInsuranceFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInsuranceToDate" runat="server" ClientIDMode="Static" ReadOnly="true"> </asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" TargetControlID="txtInsuranceToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Insurance Amount</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtInsuranceAmount" onlynumber="10" maxlength="8" class="requiredField" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Risk Coverage Amount</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtRiskCoverageAmount" onlynumber="10" maxlength="8" class="requiredField" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtInsuranceRemarks" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;"></textarea>
                        </div>
                    </div>
                    <div class="row divcentre">
                        <input type="button" id="btnAddInsurance" value="Add" onclick="AddInsurance()" />
                    </div>
                    <div class="row">
                        <div style="max-height: 100px; overflow-x: auto">
                            <table class="FixedHeader" id="tblInsurance" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">From Date</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">To Date</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Insurance Amount</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Risk Coverage Amount</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row divcentre">
                        <input type="button" id="btnSaveInsurance" value="Save" onclick="SaveInsurance()" />
                    </div>
                    <div class="row"></div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory serviceprov hidden">
            <div class="Purchaseheader">
                Service Provider Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Supplier</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlServiceSupplier" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtServiceRemarks" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;"></textarea>
                        </div>
                        <div class="col-md-5"></div>
                        <div class="col-md-3">
                            <input type="button" id="btnAddService" value="Add" onclick="AddService()" />
                        </div>
                    </div>
                    <div class="row">
                        <div style="max-height: 100px; overflow-x: auto">
                            <table class="FixedHeader" id="tblServiceProvider" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">Contact Person</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">Contact No</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Address</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row divcentre"></div>
                    <div class="row divcentre">
                        <input type="button" id="btnSaveServiceProvider" value="Save" onclick="SaveServiceProvider()" />
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory notappl hidden">
            <div class="Purchaseheader">
                Not Applicable
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Details</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <input type="checkbox" class="chkNTdtl" value="Warranty" onclick="AddNTDetail(this)" />Warranty
                            <input type="checkbox" class="chkNTdtl" value="AMC" onclick="AddNTDetail(this)" />AMC
                            <input type="checkbox" class="chkNTdtl" value="Insurance" onclick="AddNTDetail(this)" />Insurance
                            <input type="checkbox" class="chkNTdtl" value="Service Provider" onclick="AddNTDetail(this)" />Service Provider
                        </div>
                    </div>
                    <div class="row">
                        <div style="max-height: 200px; overflow-x: auto">
                            <table class="FixedHeader" id="tblNotApplicable" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Details</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row divcentre">
                        <input type="button" id="btnSaveNotApplicable" value="Save" onclick="SaveNotApplicable()" />
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
    </div>

    <div id="divDocumentUpload" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 480px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divDocumentUpload" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Upload Documents </h4>
                    <span class="hidden" id="SpnDocAssetID"></span>
                </div>
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">GRN No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="SpnDocGRNNo" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDocItemName" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDocAssetNo" class="patientInfo"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Batch No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDocBatchNo" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Model No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDocModelNo" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Serial No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDocSerialNo" class="patientInfo"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div style="height: 270px; max-height: 270px; overflow-x: auto">
                            <table class="FixedHeader" id="tblDocuemnt" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Document Name</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Upload</th>
                                        <th class="GridViewHeaderStyle" style="width: 150px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Upload DateTime</th>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">View</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="UploadDocument()">Upload</button>
                    <button type="button" data-dismiss="divDocumentUpload">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divDetails" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 380px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divDetails" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><span id="spnDetailName"></span></h4>
                    <span class="hidden" id="spnDAssetID"></span>
                </div>
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">GRN No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDGRNNo" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDItemName" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDAssetNo" class="patientInfo"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Batch No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDBatchNo" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Model No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDModelNo" class="patientInfo"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Serial No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnDSerialNo" class="patientInfo"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-body" style="height: 200px">
                    <div class="row warrantydetail hidden">
                        <div style="height: 180px; max-height: 180px; overflow-x: auto">
                            <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">Warranty From</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Warranty To</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">Period</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredBy</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredDate</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row amcdetail hidden">
                        <div style="max-height: 180px; overflow-x: auto">
                            <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">AMC From</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">AMC To</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">AMC Amount</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">No. of Visit</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredBy</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredDate</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row insurancedetail hidden">
                        <div style="max-height: 180px; overflow-x: auto">
                            <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">From Date</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">To Date</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Insurance Amount</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Risk Coverage Amount</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredBy</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredDate</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row servicedetail hidden">
                        <div style="max-height: 180px; overflow-x: auto">
                            <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 10px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">Supplier</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">Contact Person</th>
                                        <th class="GridViewHeaderStyle" style="width: 60px;">Contact No</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Address</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Remarks</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredBy</th>
                                        <th class="GridViewHeaderStyle" style="width: 50px;">EnteredDate</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="divDetails">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
