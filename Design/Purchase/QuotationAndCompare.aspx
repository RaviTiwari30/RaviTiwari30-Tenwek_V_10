<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="QuotationAndCompare.aspx.cs" Inherits="Design_Purchase_QuotationAndCompare" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager runat="server" ID="scrpt1"></cc1:ToolkitScriptManager>


    <style type="text/css">
        .ui-autocomplete {
            max-height: 200px;
            overflow: auto;
        }


        .ui-state-focus {
            background-color: #c6dff9 !important;
            border: none !important;
        }

        .ui-menu-item {
            width: 370px;
            max-width: 370px;
            overflow-y: auto;
            overflow-x: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .ui-widget-content {
            border-radius: 5px;
        }

        .GridViewHeaderStyle {
            font-size: smaller;
        }
    </style>
      

    <script type="text/javascript">

        //*****Global Variables*******

        var centerWiseMarkUp = [];
        var gstPercentage = [];
        //********************

        $(document).ready(function () {
            getPurchaseMarkUpPercent();
            getGSTPercentage();
            getVendors(function () {
                getCategories(function (categoryId) {
                    getManufacturers(function () {
                        getTaxGroups(function () {
                            bindGSTPer();
                            getSubCategories(categoryId);
                            bindMedicineSearch();
                            addItemEvents();
                            MarcTooltips.add('.trimText', '', { position: 'up', align: 'left', mouseover: true });
                        });
                    });
                });
            });

        });



        var getPurchaseMarkUpPercent = function () {
            serverCall('../Store/Services/CommonService.asmx/GetPurchaseMarkUpPercent', {}, function (response) {
                var responseData = JSON.parse(response);
                centerWiseMarkUp = responseData; //assign to global variables
            });
        }

        var getGSTPercentage = function () {
            serverCall('../Store/Services/CommonService.asmx/GetTaxGroups', {}, function (response) {
                var responseData = JSON.parse(response);
                gstPercentage = responseData; //assign to global variables
            });
        }

        var bindGSTPer = function () {
            //dev
            var ID = $('#ddlGSTGroup').val();
            var filterGST = gstPercentage.filter(function (i) { return i.id == ID });

            $('#txtVatPercent').val(filterGST[0].TotalGST);
            $('#spnGSTType').text(filterGST[0].TaxGroup.toUpperCase());
            if (filterGST[0].TaxGroup.toUpperCase() == 'IGST') {
                $("#spnIGSTCGSTCap").text('IGST(%)');
                $("#spnIGSTCGSTPer").text(filterGST[0].IGSTPer);
                $("#spnSGSTUTGSTCap").text('');
                $("#spnSGSTUTGSTPer").text('');

            } else if (filterGST[0].TaxGroup.toUpperCase() == 'CGST&SGST') {
                $("#spnIGSTCGSTCap").text('CGST(%)');
                $("#spnIGSTCGSTPer").text(filterGST[0].CGSTPer);
                $("#spnSGSTUTGSTCap").text('SGST(%)');
                $("#spnSGSTUTGSTPer").text(filterGST[0].SGSTPer);
            }
            else {
                $("#spnIGSTCGSTCap").text('CGST(%)');
                $("#spnIGSTCGSTPer").text(filterGST[0].CGSTPer);
                $("#spnSGSTUTGSTCap").text('UTGST(%)');
                $("#spnSGSTUTGSTPer").text(filterGST[0].UTGSTPer);
            }

        }
        function DiscPer() {
            var rate = $("#txtRate").val();
            var discountAmount = $("#txtDiscAmt").val();
            var dis_per = rate / discountAmount;
            if (discountAmount == "") {
                $("#txtDiscountPercent").val("");
            }
            else {
                $("#txtDiscountPercent").val(precise_round(dis_per, 4));

            }
        }

        var getVendors = function (callback) {
            serverCall('../Store/Services/CommonService.asmx/GetVendors', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlSupplier').bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'ID', textField: 'LedgerName', isSearchable: true, customAttr: ['VATType', 'Currency', 'CountryID'] }));
            });
        }


        var getCategories = function (callback) {
            serverCall('QuotationAndCompare.aspx/GetCategories', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlCategory = $('#ddlCategory');
                var categories = [];
                if (responseData.status)
                    categories = responseData.dt.reverse();

                ddlCategory.bindDropDown({ data: categories, valueField: 'CategoryID', textField: 'Name', isSearchable: true });
                callback(ddlCategory.val());
            });
        }


        var getSubCategories = function (categoryId) {
            serverCall('QuotationAndCompare.aspx/GetSubCategories', { categoryID: categoryId }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSubCategory').bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'SubCategoryID', textField: 'Name', isSearchable: true });
            });
        }


        var getManufacturers = function (callback) {
            serverCall('QuotationAndCompare.aspx/GetManufacturers', {}, function (response) {
                var responseData = JSON.parse(response);
                var ddlManufacturer = $('#ddlManufacturer');
                ddlManufacturer.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ManufactureID', textField: 'Name', isSearchable: true });
                callback(ddlManufacturer.val());
            });
        }




        var bindMedicineSearch = function () {
            $('#txtItemSearch').autocomplete({
                source: function (request, response) {
                    var categoryID = $('#ddlCategory').val();
                    var subCategoryID = $('#ddlSubCategory').val();
                    getItems({ prefix: request.term, categoryID: categoryID, subCategoryID: subCategoryID }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    addSeletedItems({ value: i.item.val, text: i.item.label, majorUnit: i.item.majorUnit, vatType: i.item.vatType, subCategoryID: i.item.subCategoryID, ManuFacturer: i.item.ManuFacturer });
                },
                close: function (el) {
                    el.target.value = '';
                },
                minLength: 2
            });

        }





        var getQuotationItemDetails = function (callback) {

            var ID = $('#ddlGSTGroup').val();
            var filterGST = gstPercentage.filter(function (i) { return i.id == ID });

            var data = {
                ItemId: $.trim($('#divQuotationFor').attr('itemID')),
                fromDate: $.trim($('#txtFromDate').val()),
                toDate: $.trim($('#txtToDate').val()),
                subcategoryID: $.trim($('#txtFromDate').val()),
                vendorID: $.trim($('#divSupplier').attr('supplierID').split('#')[0]),
                vendorName: $.trim($('#divSupplier').text()),
                ItemName: $.trim($('#divQuotationFor').text()),
                unit: $.trim($('#lblPurchaseUnit').text()),
                rate: Number($('#txtRate').val()) / Number($('#txtQCurrencyFactor').val()),
                taxGroupID: Number($('#ddlGSTGroup').val()),
                taxGroupName: $.trim($('#ddlGSTGroup option:selected').text()),
                discountPercent: Number($('#txtDiscountPercent').val()),
                discountAmount: Number($('#txtDiscAmt').val()) / Number($('#txtQCurrencyFactor').val()),
                deal1: Number($('#txtDeal1').val()),
                deal2: Number($('#txtDeal2').val()),
                taxCalculatedOn: $.trim($('#ddlTaxCalculatedOn').val()),
                IsActive: ($('input[type=radio][name=isActive]:checked').val()),
                MRP: Number($('#txtRate').val()) / $('#txtQCurrencyFactor').val(),
                HSNCode: $.trim($('#txtHSNCode').val()),
                remarks: $.trim($('#txtRemarks').val()),
                manufacturerID: $.trim($('#divManufacturer').attr('manufacturerID')),
                manufacturer: $.trim($('#divManufacturer').text()),
                categoryID: $.trim($('#ddlCategory').val()),
                totalTaxPercent: Number($('#txtVatPercent').val()),
                minimum_Tolerance_Qty: Number($('#txtTorQty').val()),
                maximum_Tolerance_Qty: Number($('#txtTorQty1').val()),
                minimum_Tolerance_Rate: Number($('#txtTorRate').val()) / $('#txtQCurrencyFactor').val(),
                maximum_Tolerance_Rate: Number($('#txtTorRate1').val()) / $('#txtQCurrencyFactor').val(),
                currencyNotation: $('#SpnCurrency').text(),
                CurrencyFactor: $('#txtQCurrencyFactor').val(),
                currencyCountryID: Number($('#txtQCurrencyFactor').attr('currencyCountryID')),
                GSTType: filterGST[0].TaxGroup.toUpperCase(),
                IGSTPercent: filterGST[0].IGSTPer,
                CGSTPercent: filterGST[0].CGSTPer,
                SGSTPercent: Number(filterGST[0].SGSTPer) + Number(filterGST[0].UTGSTPer)

            }



            if (data.rate <= 0) {
                modelAlert('Please Enter Rate.');
                $('#txtRate').focus();
                return false;
            }

            if (Number('<% =Resources.Resource.IsGSTApplicable%>') == 1) {
                if (data.MRP < 1) {
                    modelAlert('Please Enter MRP');
                    $('#txtMRP').focus();
                    return false;
                }
                if (data.MRP < data.rate) {
                    modelAlert("MRP Can't  Less Then Rate.");
                    $('#txtMRP').focus();
                    return false;
                }
            }

            //if (data.taxGroupID < 1) {
            //    modelAlert('Please Select Tax Category.');
            //    return false;
            //}



            callback(data);
            console.log(JSON.stringify(data));
        }






        var onRateChange = function (el) {

            var rate = Number(el.value);

            var taxPercent = Number($('#txtVatPercent').val());
            var discountPercent = $('#txtDiscountPercent').val();

            var discountAmount = (rate * discountPercent / 100);
            var taxAmount = precise_round(((rate - discountAmount) * taxPercent) / 100, 4);
            var netAmount = precise_round((rate + taxAmount) - (discountAmount), 4);
            var subCategoryID = $('#divQuotationFor').attr('subcategoryid');
            var ItemID = $('#divQuotationFor').attr('itemID');
            var d = calculateItemMRP({
                rate: rate,
                quantity: 1,
                netAmount: netAmount,
                markUpPercent: '',
                centerWiseMarkUp: centerWiseMarkUp,
                subCategoryID: subCategoryID,
                itemId: ItemID
            });

            $('#txtMRP').val(d.itemMRP);
            $('#txtDiscAmt').val(discountAmount);
        }

        var onDiscountAmountChange = function (el) {
            var rate = Number($('#txtRate').val());
            var discountAmount = Number($('#txtDiscAmt').val());
			
			 if (discountAmount > rate)
            {
                modelAlert('Dicsount Amount Should be Less Than Or Equal To Rate');
                $('#txtDiscAmt').val('0');
                discountAmount = 0;
            }
			
            var discountPercent = Number((discountAmount * 100) / rate);
			
            if (Number('<%= Resources.Resource.IsGSTApplicable%>') == 0) {
                var taxPercent = Number($('#txtVatPercent').val());
                var taxAmount = precise_round(((rate - discountAmount) * taxPercent) / 100, 4);
                var netAmount = precise_round((rate + taxAmount) - (discountAmount), 4);
                var subCategoryID = $('#divQuotationFor').attr('subcategoryid');
                var ItemID = $('#divQuotationFor').attr('itemID');
                var d = calculateItemMRP({
                    rate: rate,
                    quantity: 1,
                    netAmount: netAmount,
                    markUpPercent: '',
                    centerWiseMarkUp: centerWiseMarkUp,
                    subCategoryID: subCategoryID,
                    itemId: ItemID
                });

                $('#txtMRP').val(d.itemMRP);
            }
            $('#txtDiscountPercent').val(discountPercent);

        }


        var onDiscountPercentChange = function () {


            var rate = Number($('#txtRate').val());
            var discountPercent = $('#txtDiscountPercent').val();

            var discountAmount = (rate * discountPercent / 100);

             if (Number('<%= Resources.Resource.IsGSTApplicable%>') == 0) {
                var taxPercent = Number($('#txtVatPercent').val());
                //var discountPercent = Number((discountAmount * 100) / rate);
                var taxAmount = precise_round(((rate - discountAmount) * taxPercent) / 100, 4);
                var netAmount = precise_round((rate + taxAmount) - (discountAmount), 4);
                var subCategoryID = $('#divQuotationFor').attr('subcategoryid');
                var ItemID = $('#divQuotationFor').attr('itemID');
                var d = calculateItemMRP({
                    rate: rate,
                    quantity: 1,
                    netAmount: netAmount,
                    markUpPercent: '',
                    centerWiseMarkUp: centerWiseMarkUp,
                    subCategoryID: subCategoryID,
                    itemId: ItemID
                });

                $('#txtMRP').val(d.itemMRP);
            }
            $('#txtDiscAmt').val(discountAmount);

        }



        var addItems = function () {
            getQuotationItemDetails(function (data) {
                serverCall('QuotationAndCompare.aspx/addItems', { quotation: data }, function (response) {
                    var responseData = JSON.parse(response);

                    if (responseData.status) {
                        quotation = responseData.quotation;
                        $('#tblQuotation tbody').append($('#tb_Quotation').parseTemplate(quotation));
                        MarcTooltips.add('.trimText', '', { position: 'up', align: 'left', mouseover: true });
                        addItemEvents();
                    }
                    else
                        modelAlert(responseData.message);
                });
            });
        }

        var getVatTaxPercent = function (data, callback) {
            serverCall('../Store/Services/CommonService.asmx/GetVatTaxPercent', data, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }

        var GetTaxAmount = function (data, callback) {//
            serverCall('../Store/Services/CommonService.asmx/GetTaxAmount', data, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }




        var getItems = function (data, callback) {
            serverCall('QuotationAndCompare.aspx/GetItems', data, function (response) {
                var reponseData = JSON.parse(response);
                var items = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.TypeName,
                        val: item.ItemId,
                        majorUnit: item.majorUnit,
                        vatType: item.VatType,
                        subCategoryID: item.SubCategoryID,
                        ManuFacturer: item.ManuFacturer
                    }
                });
                callback(items);
            });
        }



        var getTaxGroups = function (callback) {
           // serverCall('../Store/Services/CommonService.asmx/GetTaxGroups', {}, function (response) {
              //  var responseData = JSON.parse(response);
           $('#ddlGSTGroup').bindDropDown({ data: gstPercentage, valueField: 'id', textField: 'TaxGroupLabel', isSearchable: false });
            callback($('#ddlGSTGroup').val());
           // })
        }


        var addSeletedItems = function (data) {
            $('#divSelectedItems').find('ul').append('<li  style="cursor:pointer"  id=' + data.value + ' class="search-choice"><span onclick="onCreateNewQuotation(this)" subCategoryID="' + data.subCategoryID + '"     unit="' + data.majorUnit + '" vatType="' + data.vatType + '" ManuFacturer="' + data.ManuFacturer + '" >' + data.text + '</span><a onclick="removeSelectedItem(this)" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a></li>');
            searchQuotation();
            //bindData();
        }






        var onCreateNewQuotation = function (elem) {

          
            var ddlSupplier = $('#ddlSupplier option:selected');

            if (ddlSupplier[0].value == '0') {
                modelAlert('Please Select Supplier.');
                return false;
            }


            var p = $(elem).parent();


            var itemID = $(p).find('a').text();
            var itemVatType = $(elem).attr('vattype');
            var subCategoryID = $(elem).attr('subCategoryID');
            var vendorVatType = $(ddlSupplier[0]).attr('vattype');
            var vendorCurrency = $(ddlSupplier[0]).attr('currency');
            var vendorCountryID = $(ddlSupplier[0]).attr('countryid');
            var data = {
                itemID: '',
                vendorID: '',
                vendorVatType: vendorVatType,
                itemVatType: itemVatType,
                vendorCurrency: vendorCurrency,
                vendorCountryID: vendorCountryID
            }
            

            getCurrencyFactor(data.vendorCurrency, function () { });

            if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                var d = {
                    itemID: itemID
                }
                GetTaxAmount(d, function (TaxDetails) {//
                    if (TaxDetails.length > 0) {
                        $('#txtVatPercent').val(TaxDetails[0].Taxpercent);
                       // $('#ddlGSTGroup').val(TaxDetails[0].GSTType);

                        $("#ddlGSTGroup option:contains('" + TaxDetails[0].GSTType + "')").attr('selected', true);
                        $('#ddlGSTGroup').change();
                        
                    }
                    else { $('#txtVatPercent').val(0); }

                    $('#divQuotationFor').text($(p).find('span').text()).attr('itemID', itemID).attr('subCategoryID', subCategoryID);

                    $('#divSupplier').text(ddlSupplier[0].text).attr('supplierID', ddlSupplier[0].value);
                   // var ddlManufacturer = $('#ddlManufacturer option:selected');
                    //$('#divManufacturer').text(ddlManufacturer[0].value == '0' ? '' : ddlManufacturer[0].text).attr('manufacturerID', ddlManufacturer[0].value);

                    $('#divManufacturer').text($(p).find('span').attr('ManuFacturer'));//
                    $('#lblPurchaseUnit').text($(p).find('span').attr('unit'));
                    $('#SpnCurrency').text(vendorCurrency);

                    $('.newQuotation').show();

                    $("#spnGSTType").text(itemVatType);
                });
            }
            else {
                getVatTaxPercent(data, function (vatTaxDetails) {
                    if (vatTaxDetails.length > 0)
                        $('#txtVatPercent').val(vatTaxDetails[0].VatPercentage);
                    else
                        $('#txtVatPercent').val(0);

                    $('#divQuotationFor').text($(p).find('span').text()).attr('itemID', itemID).attr('subCategoryID', subCategoryID);

                    $('#divSupplier').text(ddlSupplier[0].text).attr('supplierID', ddlSupplier[0].value);
                   // var ddlManufacturer = $('#ddlManufacturer option:selected');
                  //  $('#divManufacturer').text(ddlManufacturer[0].value == '0' ? '' : ddlManufacturer[0].text).attr('manufacturerID', ddlManufacturer[0].value);

                    $('#divManufacturer').text($(p).find('span').attr('ManuFacturer'));//
                    $('#lblPurchaseUnit').text($(p).find('span').attr('unit'));
                    $('#SpnCurrency').text(vendorCurrency);
                    $('.newQuotation').show();
                });
            }
        }

        var getCurrencyFactor = function (currencyNotation, callback) {
            serverCall('../Store/Services/CommonService.asmx/getCurrencyFactor', { currencyNotation: currencyNotation }, function (response) {
                var responseData = JSON.parse(response);
                $('#txtQCurrencyFactor').val(responseData.currencyFactor).attr('currencyCountryID', responseData.currencyCountryID);
                callback(true);
            });
        }

        var removeSelectedItem = function (elem) {
            $(elem).parent().remove();
        }



        var addItemEvents = function () {
            var li = $('#tblQuotation tbody tr').length;
            if (li > 0)
                $('.newQuotationExits').show();
            else
                $('.newQuotationExits').hide();
        }





        var getQuotationDetailsList = function (callback) {
            var quotationList = [];
            $('#tblQuotation tbody tr').each(function () {
                var data = JSON.parse($(this).attr('data'));
                quotationList.push(data);
            });
            callback(quotationList);
        }



        var save = function () {
            getQuotationDetailsList(function (response) {
                serverCall('QuotationAndCompare.aspx/SaveQuotation', { quotationList: response }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        if (responseData.status) {
                            clearQuotation();
                            searchQuotation();
                        }
                    });
                });
            });
        }


        var clearQuotation = function () {
            $('.newQuotation').find('input[type=text]').not('#txtFromDate,#txtToDate').val('');
            $('.newQuotation').find('select').val('0').trigger("chosen:updated");
            $('.newQuotation').find('.clearText').text('');
            $('#tblQuotation').hide().find('tbody tr').remove();
            $('.newQuotation').hide();
            $('.newQuotationExits').hide();
        }


        var searchQuotation = function () {
            var itemIDs = [];
            $('#divSelectedItems').find('ul li').each(function () {
                itemIDs.push($(this).find('a').text());
            });
            var data = {
                vendorID: $('#ddlSupplier').val().split('#')[0],
                itemIDs: itemIDs
            };
            serverCall('QuotationAndCompare.aspx/SearchQuotation', data, function (response) {
                quotationDetails = JSON.parse(response);
                var h = $('#templateQuotationsDetails').parseTemplate(quotationDetails);
                $('#divQuotationDetails').find('.col-md-24').html(h);
            });
        }



        var setDefault = function (elem) {
            var data = JSON.parse($(elem).closest('tr').attr('data'));

            $('#spnRateid').text(data.StoreRateID);
            $('#spnItemid').text(data.ItemID);

            $('#divSetDefaultRemarks').showModel();

        }


        var onNewItemCreate = function () {
            var w = screen.width;
            var h = screen.height;

            var newItemWindow = window.open('../Store/ItemMaster.aspx?Mode=1', '_blank', 'toolbar=yes,scrollbars=yes,resizable=yes,top=0,left=0,width=' + w + ',height=' + h);
            newItemWindow.addEventListener("beforeunload", function (e) {


            });
        }

        var onNewManufacturerCreate = function () {
            var w = screen.width;
            var h = screen.height;
            debugger;
            var newItemWindow = window.open('../Store/ManufactureMaster.aspx?Mode=1', '_blank', 'toolbar=yes,scrollbars=yes,resizable=yes,top=0,left=0,width=' + w + ',height=' + h);
            newItemWindow.addEventListener("beforeunload", function (e) {
                debugger;
                getManufacturers(function () { });
            });
        }


        var onNewVendorCreate = function () {
            var w = screen.width;
            var h = screen.height;


            var newItemWindow = window.open('../Store/VendorDetail.aspx?Mode=1', '_blank', 'toolbar=yes,scrollbars=yes,resizable=yes,top=0,left=-10,width=' + w + ',height=' + h);
            newItemWindow.addEventListener("beforeunload", function (e) {
                getVendors(function () { });
            });
        }






        var exportToExcel = function () {
            getItemMaster(function (data) {
                var centerName = $('#ddlCentre option:selected').text();
                var departmentName = $('#ddlDepartment option:selected').text();
                //var data = [{
                //    ItemId: '',
                //    ItemName: '',
                //    fromDate: '',
                //    toDate: '',
                //    vendorID: '',
                //    vendorName: '',
                //    rate: '',
                //    discountPercent: '',
                //    minimum_Tolerance_Qty: '',
                //    maximum_Tolerance_Qty: '',
                //    minimum_Tolerance_Rate: '',
                //    maximum_Tolerance_Rate: '',
                //    currencyNotation: '',
                //    currencyFactor: '',
                //}];
                serverCall('Services/QuotationAndCompare.asmx/ConvertToExcel', { fileName: 'QuotationCompareExcelFormat', data: data }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        window.open('../Common/CreateExcel.aspx');
                    }
                });
            });
        }







        var getItemMaster = function (callback) {
            var selectedItems = $('#divSelectedItems ul li');
            if (selectedItems.length > 0) {
                var data = [];
                $(selectedItems).each(function () {
                    var d = {
                        ItemId: '',
                        ItemName: '',
                        fromDate: '',
                        toDate: '',
                        vendorID: '',
                        vendorName: '',
                        rate: '',
                        discountPercent: '',
                        minimum_Tolerance_Qty: '',
                        maximum_Tolerance_Qty: '',
                        minimum_Tolerance_Rate: '',
                        maximum_Tolerance_Rate: '',
                        currencyNotation: '',
                        currencyFactor: '',
                        SetDefault:'',
                    };
                    d.ItemId = $.trim($(this).find('a').text());
                    d.ItemName = $.trim($(this).find('span').text());
                    d.SetDefault = 'YES';
                    data.push(d);

                });
                callback(data);
            }
            else {
                serverCall('Services/QuotationAndCompare.asmx/GetItemMaster', {}, function (response) {
                    var responseData = JSON.parse(response);
                    callback(responseData);

                });
            }
        }


        var onImportExcel = function () {

            var selectedSupplier = $('#ddlSupplier').val();
            if (selectedSupplier == '0') {
                modelAlert('Please select supplier.');
                return false;
            }

            $('#divImportMapping').showModel();
        }




        var uploadFile = function () {
            var data = new FormData();
            var files = $('#fileUploaderExcel').get(0).files;
            if (files.length < 1) {
                modelAlert('Please Select .xlxs File', function () { });
                return false;
            }
            data.append("excelFile", files[0]);
            var ajaxRequest = $.ajax({
                type: 'POST',
                url: '../Common/ConvertXLSToJSON.asmx/Convert',
                contentType: false,
                processData: false,
                data: data,
                complete: function (data) {
                    var responseData = JSON.parse(data.responseText);
                    if (responseData.status) {
                        excelData = responseData.data;
                        validateExcelData(excelData, function (data) {
                            console.log(data);
                            $('#divImportMapping').closeModel();
                        });
                    }
                    else {
                        modelAlert(responseData.message);
                    }
                },
            });
        }



        var validateExcelData = function (data, callback) {


            var selectedSupplierID = $('#ddlSupplier').val();
            var selectedSupplierName = $('#ddlSupplier').val();


            for (var i = 0; i < data.length; i++) {

                data[i].taxGroupID = 0;
                data[i].deal1 = 0;
                data[i].deal2 = 0;
                
                data[i].MRP = 0;
                data[i].unitPrice = 0;
                data[i].IGSTPercent = 0;
                data[i].CGSTPercent = 0;
                data[i].SGSTPercent = 0;
                data[i].taxAmount = 0
                data[i].profit = 0;
                data[i].netAmount = 0;
                data[i].grossAmount = 0
                data[i].totalTaxPercent = 0;
                data[i].currencyCountryID = 0;
                data[i].discountAmount = 0;
                data[i].vendorID=selectedSupplierID;
                data[i].vendorName = selectedSupplierName;

                if (String.isNullOrEmpty(data[i].rate))
                    data[i].rate = 0;


                if (String.isNullOrEmpty(data[i].discountPercent))
                    data[i].discountPercent = 0;


                if (String.isNullOrEmpty(data[i].minimum_Tolerance_Qty))
                    data[i].minimum_Tolerance_Qty = 0;

                if (String.isNullOrEmpty(data[i].maximum_Tolerance_Qty))
                    data[i].maximum_Tolerance_Qty = 0;


                if (String.isNullOrEmpty(data[i].minimum_Tolerance_Rate))
                    data[i].minimum_Tolerance_Rate = 0;

                if (String.isNullOrEmpty(data[i].maximum_Tolerance_Rate))
                    data[i].maximum_Tolerance_Rate = 0;

                if (String.isNullOrEmpty(data[i].currencyNotation))
                    data[i].currencyNotation = '<%=Resources.Resource.BaseCurrencyNotation%>';

               if (String.isNullOrEmpty(data[i].currencyFactor))
                   data[i].currencyFactor = 1;
               if (!String.isNullOrEmpty(data[i].SetDefault) && data[i].SetDefault.toUpperCase()=='YES')
                   data[i].IsActive = 1;
               else
                   data[i].IsActive = 0;



        }



            var d = data.filter(function (i) {
                return !String.isNullOrEmpty(i.ItemId);

            });


            serverCall('QuotationAndCompare.aspx/ValidateImportData', { excelData: d, vendorID: $('#ddlSupplier').val() }, function (response) {
                var responseData = JSON.parse(response);
                calculateQuotationField(responseData.data, function () {
                    callback(responseData);
                });
            });
        }




    var calculateQuotationField = function (data, callback) {


        if (data.length < 1) {
            modelAlert('0 Valid Quotation Found.');
            return false;
        }
        $('#tblQuotation tbody').find('tr').remove();
        for (var i = 0; i < data.length; i++) {
            var d = calculateItemMRP({
                rate: data[i].rate,
                quantity: 1,
                netAmount: data[i].netAmount,
                markUpPercent: '',
                centerWiseMarkUp: centerWiseMarkUp,
                subCategoryID: data[i].subcategoryID,
                itemId: data[i].ItemId
            });
            data[i].MRP = d.itemMRP;
            data[i].unitPrice = d.itemMRP;
            data[i].profit = d.itemMRP - data[i].netAmount;
            quotation = data[i];
            $('#tblQuotation tbody').append($('#tb_Quotation').parseTemplate(quotation));
            MarcTooltips.add('.trimText', '', { position: 'up', align: 'left', mouseover: true });
            addItemEvents();
        }

        $('.importQuotation').show();
        $('#divImportMapping').hideModel();
    }




    //var calculateItemMRP = function (data) {
    //    var rate = data.rate;
    //    var quantity = data.quantity;
    //    var netAmount = data.netAmount;
    //    //var otherCharges = data.otherCharges;
    //    var markUpPercent = data.markUpPercent;


    //    if (String.isNullOrEmpty(markUpPercent)) {
    //        var filterMarkup = [];
    //        for (var j = 0; j < data.centerWiseMarkUp.length; j++) {
    //            if (data.centerWiseMarkUp[j].SubCategoryID == data.subCategoryID) {
    //                if (data.rate <= data.centerWiseMarkUp[j].ToRate) {
    //                    filterMarkup.push(data.centerWiseMarkUp[j]);
    //                    break;
    //                }
    //            }
    //        }
    //    }

    //    if (filterMarkup.length > 0)
    //        markUpPercent = filterMarkup[0].MarkUpPercentage;

    //    if (markUpPercent <= 0) {
    //        modelAlert('Mark Up Percentage Not Found.');
    //        return 0;
    //    }

    //    var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);


    //    return { itemMRP: itemMRP, markUpPercent: markUpPercent };

    //}

    var calculateItemMRP = function (data) {
        var rate = data.rate;
        var quantity = data.quantity;
        var netAmount = data.netAmount;
        //var otherCharges = data.otherCharges;
        var markUpPercent = data.markUpPercent;


        if (String.isNullOrEmpty(markUpPercent)) {
            var filterMarkup = [];

             filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.ItemID == data.itemId && i.MarkUpType == "CentreWiseItemWise" });
            if (filterMarkup.length == 0)
                filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.ItemID == data.itemId && i.MarkUpType == "UniversalItemWise" });
            if (filterMarkup.length == 0)
                filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.SubCategoryID == data.subCategoryID && i.MarkUpType == "UniversalSubCategoryWise" && i.ToRate >= data.rate });

            //for (var j = 0; j < data.centerWiseMarkUp.length; j++) {
            //    if (data.centerWiseMarkUp[j].SubCategoryID == data.subCategoryID) {
            //        if (data.rate <= data.centerWiseMarkUp[j].ToRate) {
            //            filterMarkup.push(data.centerWiseMarkUp[j]);
            //            break;
            //        }
            //    }
            //}
        }

        if (filterMarkup.length > 0)
            markUpPercent = filterMarkup[0].MarkUpPercentage;

        if (markUpPercent <= 0) {
           // modelAlert('Mark Up Percentage Not Found.');
            //return 0;
        }

        var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);


        return { itemMRP: itemMRP, markUpPercent: markUpPercent };

    }
    function $SaveDefaultremarks() {
        if ($('#txtDefaultremarks').val() == '')
        {
            modelAlert('Enter Remarks');
            return;
        }

        serverCall('QuotationAndCompare.aspx/SetDefault', { ItemID: $('#spnItemid').text(), rateID: $('#spnRateid').text(), Remarks: $('#txtDefaultremarks').val() }, function (response) {
            var responseData = JSON.parse(response);
            if (responseData.status) {
                modelAlert(responseData.message, function () {
                    $('#txtDefaultremarks').val('');
                    $('#divSetDefaultRemarks').hideModel();
                    searchQuotation();

                });
            }
        });
    }
    </script>

  



    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b>Set Item Pricing</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search & Compare Item Rate
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Category
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlCategory" onchange="getSubCategories(this.value)"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Sub Category
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlSubCategory"></select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Manufacturer
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlManufacturer"></select>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Supplier
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <select id="ddlSupplier"></select>
                </div>
                <div class="col-md-5">
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-5">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Search Item
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <input type="text" id="txtItemSearch" />
                </div>
                <div class="col-md-13">
                    <input type="button" class="pull-right" style="margin-left: 5px;" onclick="exportToExcel()" value="Get-Excel-Format" />
                    <input type="button" class="pull-right" style="margin-left: 5px;" onclick="onImportExcel()" value="Import-From-Excel" />
                    <input type="button" class="pull-right" style="margin-left: 5px;display:none" onclick="onNewVendorCreate()" value="Create New Vendor"  />
                    <input type="button" class="pull-right"  style="margin-left: 5px;" onclick="onNewManufacturerCreate()" value="Create New Manufacturer" />
                    <input type="button" class="pull-right" onclick="onNewItemCreate()" value="Create New Item" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label style="font-weight: bold" class="pull-left patientInfo">
                        Selected Items
                    </label>
                    <b style="font-weight: bold" class="pull-right patientInfo">:</b>
                </div>
                <div id="divSelectedItems" class="col-md-21">
                    <div class="chosen-container-multi">
                        <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                        </ul>
                    </div>
                </div>

            </div>


        </div>

        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-8">
                    <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color:#8fec96;" class="circle"></button>
                    <b style="margin-top: 5px; margin-left: 5px; float: left">Default Supplier</b>
                </div>
                <div class="col-md-8 textCenter">
                    <input type="button" onclick="searchQuotation(this)" class="save" value="Search" />
                </div>
                <div class="col-md-8">
                </div>
            </div>

            <%--<input type="button" class="margin-top-on-btn"  value="Create New Quotation" />--%>
        </div>

        <div id="divQuotationDetails" class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                </div>
            </div>
        </div>



        <div style="display: none" class="POuter_Box_Inventory newQuotation " id="divItemPricingDetails">
            <div class="Purchaseheader">
                Items Pricing Detail
            </div>

            <div class="row">

                <div class="col-md-3">
                    <label class="pull-left">Quotation For</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 patientInfo">
                    <span class="clearText" id="divQuotationFor"></span>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Supplier From</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 patientInfo">
                    <span class="clearText" id="divSupplier"></span>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Manufacturer</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 patientInfo">
                    <span class="clearText" id="divManufacturer"></span>
                </div>

            </div>



            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static">
                    </asp:TextBox>
                    <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static">
                    </asp:TextBox>
                    <cc1:CalendarExtender ID="calEntryDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate">
                    </cc1:CalendarExtender>
                </div>


                <div class="col-md-3">
                    <label class="pull-left">
                        Purchase Unit
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 patientInfo">
                    <span class="newQuotation" id="lblPurchaseUnit"></span>
                </div>


            </div>
            <div class="row">
              

                <div class="col-md-3">
                    <label class="pull-left" >
                        Rate
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" >
                    <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                        <input class="ItDoseTextinputNum requiredField" onlynumber="15" decimalplace="4"   id="txtRate" type="text" /><%--onchange="onRateChange(this)"-- %>
                    <%}else{  %>
                    <input class="ItDoseTextinputNum requiredField" onlynumber="15" decimalplace="4"  id="txtRate" type="text" /><%-- onchange="onRateChange(this)"--%>
                    <%} %>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            Vat
                        <%}else{ %>
                        <span id="spnIGSTCGSTCap">CGST(%)</span> 
                        <%} %>
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                       <input type="text" id="txtVatPercent" onlunumber="10" decimalplace="4" disabled="disabled"
                             <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                           
                        <%}else{ %>
                         style="display:none;" 
                        <%} %>
                       />

                     <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                     <span id="spnIGSTCGSTPer" style="font-weight:bold;" class="patientInfo">0.00</span>
                     <%} %>
                </div>
               <div class="col-md-3">
                    <label class="pull-left">
                        Tax Calculated On
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlTaxCalculatedOn" disabled="disabled">
                        <option value="RateAD" selected="selected">RateAD</option>
                        <option value="MRP">MRP</option>
                        <option value="Rate">Rate</option>
                        <option value="RateRev">Rate Rev.</option>
                        <option value="RateExcl">Rate Excl.</option>
                        <option value="MRPExcl">MRP Excl.</option>
                        <option value="ExciseAmt">Excise Amt.</option>
                    </select>

                </div>
                
                
            </div>
            <div class="row">
                <div class="col-md-3" style="display:none">
                    <label class="pull-left">
                        Is Deal
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2"style="display:none">
                    <input type="text" class="ItDoseTextinputNum" id="txtDeal1" />
                </div>
                <div class="col-md-1 textCenter" style="display:none">
                    <b class="patientInfo">+ </b>
                </div>
                <div class="col-md-2" style="display:none">
                    <input type="text" class="ItDoseTextinputNum" id="txtDeal2" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        HSN Code 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtHSNCode" />
                </div>
                 <div class="col-md-3">
                    <label class="pull-left">
                        Set As Default 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input id="Radio1" type="radio" name="isActive" value="1" class="pull-left" />
                    <span class="pull-left">Yes</span>
                    <input id="Radio2" type="radio" name="isActive"  checked="checked" value="0" class="pull-left" />
                    <span class="pull-left">No</span>

                </div>
                
                 <div class="col-md-3">
                    <label class="pull-left">
                        Currrency
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2 patientInfo">
                    <span class="clearText" id="SpnCurrency" ></span>
                </div>
                <div class="col-md-3 patientInfo">
                    <input type="text" id="txtQCurrencyFactor" onlynumber="10" decimalplace="4"  class="patientInfo" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Discount Amount
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                    <input type="text" class="ItDoseTextinputNum" id="txtDiscAmt" decimalplace="4" onlynumber="15" onchange="onDiscountAmountChange(this)"  />
                    <%}else{ %>
                    <input type="text" class="ItDoseTextinputNum" id="txtDiscAmt" decimalplace="4" onlynumber="15"  onchange="onDiscountAmountChange(this)"  />   <%--onChange="onDiscountAmountChange(this)"--%>
                    <%} %>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Discount Percent
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                    <input type="text" class="ItDoseTextinputNum" id="txtDiscountPercent"  max-value="100" onchange="onDiscountPercentChange(this)"  onlynumber="15" decimalplace="4"   />
                    <%}else{ %>
                    <input type="text" class="ItDoseTextinputNum" id="txtDiscountPercent"  max-value="100"  onchange="onDiscountPercentChange(this)"  onlynumber="15" decimalplace="4"   />  <%--onChange="onDiscountPercentChange(this)"--%>
                    <%} %>
                </div>


                
            </div>
            <div class="row">
                  <div class="col-md-3" style="display:none">
                    <label class="pull-left">
                        MRP
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display:none">
                    <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                        <input class="ItDoseTextinputNum " id="txtMRP" disabled="disabled"  decimalplace="4" type="text" />
                    <%}else{ %>
                        <input class="ItDoseTextinputNum requiredField" id="Text1"  decimalplace="4" type="text" />
                    <%} %>
                </div>

               
                <div class="col-md-3"  <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            style="display:none"
                        <%}else{ %>
                         
                        <%} %> >
                    <label class="pull-left">
                        GST Group
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            style="display:none"
                        <%}else{ %>
                         
                        <%} %>>
                    <select  id="ddlGSTGroup" onchange="bindGSTPer();"></select>
                </div>

                   
                  <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                <div class="col-md-3">
                    <label class="pull-left">
                       <span id="spnSGSTUTGSTCap">SGST(%)</span>  
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <span id="spnGSTType" style="font-weight:bold; display:none;"></span>
                      <span id="spnSGSTUTGSTPer" style="font-weight:bold;"  class="patientInfo">0.00</span>
                </div>
                <%} %>


            </div>

            <div class="row" style="display:none;">
                <div class="col-md-3">
                    <label class="pull-left">
                        Tolerance Qty(-)
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                       <input type="text" id="txtTorQty" onlynumber="15"  class="ItDoseTextinputNum"/>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Tolerance Qty(+) 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                  <div class="col-md-5">
                       <input type="text" id="txtTorQty1" onlynumber="15" class="ItDoseTextinputNum"/>
                </div>


                   <div class="col-md-3">
                    <label class="pull-left">
                        Tolerance Rate(-) 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                       <input type="text" id="txtTorRate" onlynumber="15"  decimalplace="4" class="ItDoseTextinputNum"/>
                </div>


            </div>

            <div class="row">
                <div class="col-md-3" style="display:none;">
                    <label class="pull-left">
                        Tolerance  Rate(+) 
                    </label>
                    <b class="pull-right">:</b>
                </div>
               <div class="col-md-5" style="display:none;">
                       <input type="text" id="txtTorRate1" onlynumber="15" decimalplace="4" class="ItDoseTextinputNum"/>
                </div>
              
                <div class="col-md-3">
                    <label class="pull-left">
                        Remarks
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-13">
                    <input type="text" id="txtRemarks" />
                </div>

                </div>
              </div>
   
        <div style="display: none" class="POuter_Box_Inventory textCenter newQuotation">
            <input type="button" onclick="addItems()" id="btnAdd" class="save margin-top-on-btn" value="Add" />
        </div>

        <div style="display: none" class="POuter_Box_Inventory newQuotation importQuotation">
            <div class="row">
                <div class="col-md-24">
                    <table class="newQuotationExits" id="tblQuotation" style="width: 100%; border-collapse: collapse; margin: 0; padding: 0;">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle">#</th>
                                <th class="GridViewHeaderStyle">Supplier Name</th>
                                <th class="GridViewHeaderStyle">Manufacturer</th>
                                <th class="GridViewHeaderStyle">Item Name</th>
                                <th class="GridViewHeaderStyle">Unit</th>
                                <th class="GridViewHeaderStyle">From Date</th>
                                <th class="GridViewHeaderStyle">To Date</th>
                                <th class="GridViewHeaderStyle">MRP</th>
                                <th class="GridViewHeaderStyle">Rate</th>
                                <th class="GridViewHeaderStyle">Dis. Amt.</th>
                                <th class="GridViewHeaderStyle">Dis. Per.</th>
                                <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                                <th class="GridViewHeaderStyle">GST</th>
                                
                                
                                <th class="GridViewHeaderStyle">GST Group</th>
                                <th class="GridViewHeaderStyle">HSNCode</th>
                                <%} %>
                                <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                                <th class="GridViewHeaderStyle">VAT</th>
                                <th class="GridViewHeaderStyle">Tax Amt.</th>
                                 <%} %>

                                 <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                                <th class="GridViewHeaderStyle">GST Amt.</th>
                                 <%} %>

                                <th class="GridViewHeaderStyle">Net Amt.</th>
                                <th class="GridViewHeaderStyle" style="display:none">Tolerance Qty(-)</th>
                                <th class="GridViewHeaderStyle" style="display:none">Tolerance Qty(+)</th>
                                <th class="GridViewHeaderStyle"style="display:none">Tolerance Rate(-)</th>
                                <th class="GridViewHeaderStyle"style="display:none">Tolerance Rate(+)</th>
                                <th class="GridViewHeaderStyle">Is Default</th>
                                <th class="GridViewHeaderStyle">Currency</th>
                                <th class="GridViewHeaderStyle hidden">CurrencyFactor</th>
                                <th class="GridViewHeaderStyle">Remarks</th>
                                <th class="GridViewHeaderStyle"></th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>


        </div>
        <div style="display: none" class="POuter_Box_Inventory textCenter newQuotationExits importQuotation">
            <input type="button" id="btnSave" onclick="save(this)" class="save margin-top-on-btn" value="Save" />
            <input type="button" id="btnCancel" onclick="clearQuotation(this)" class="save margin-top-on-btn" value="Cancel" />
        </div>

  
    </div>



    <script id="tb_Quotation" type="text/html">
        <# 
                        var q=quotation;
                     
       #>
                        <tr data='<#= JSON.stringify(q)#>'>
                            <td class="GridViewLabItemStyle" id="tdIndex" style="width: 30px;"><#=1#></td>
                            <td class="GridViewLabItemStyle trimText" id="tdSuppName" data-title="<#=q.vendorName#>" style="max-width: 143px"><#=q.vendorName#></td>
                            <td class="GridViewLabItemStyle trimText" id="tdmanufacturer" data-title="<#=q.manufacturer#>" style="max-width: 100px"><#=q.manufacturer#></td>
                            <td class="GridViewLabItemStyle trimText" id="TdItemname" data-title="<#=q.ItemName#>" style="max-width: 150px"><#=q.ItemName#></td>
                            <td class="GridViewLabItemStyle" id="Tdunit"><#=q.unit#></td>
                            <td class="GridViewLabItemStyle" id="tdFromDate"><#=q.fromDate#></td>
                            <td class="GridViewLabItemStyle" id="tdToDatenew"><#=q.toDate#></td>
                            <td class="GridViewLabItemStyle" id="TDMrp"><#=q.MRP#></td>
                            <td class="GridViewLabItemStyle" id="tdnewrate"><#=q.rate#></td>
                            <td class="GridViewLabItemStyle" id="tddiscamt"><#=q.discountAmount#></td>
                            <td class="GridViewLabItemStyle" id="tdDiscPr"><#=q.discountPercent#></td>
                            <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                            <td class="GridViewLabItemStyle" id="tdTotaltaxper"><#=q.totalTaxPercent#></td>
                      
                            <td class="GridViewLabItemStyle" id="tdGsttype"><#=q.taxGroupName#></td>
                            <td class="GridViewLabItemStyle" id="tdhsncode"><#=q.HSNCode#></td>
                                  <%} %>

                            <td class="GridViewLabItemStyle hidden" id="tddeal"><#=q.deal1#>+<#=q.deal2#></td>
                            <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            <td class="GridViewLabItemStyle" id="tdTaxPercent"><#=q.totalTaxPercent#></td>
                            <%} %>
                            
                            <td class="GridViewLabItemStyle" id="tdtaxamount"><#=q.taxAmount#></td>

                            <td class="GridViewLabItemStyle" id="tdnetamount"><#=q.netAmount#></td>
                            <td class="GridViewLabItemStyle" id="tdmtq" style="display:none"><#=q.minimum_Tolerance_Qty#></td>
                            <td class="GridViewLabItemStyle" id="tdmtq1" style="display:none"><#=q.maximum_Tolerance_Qty#></td>
                            <td class="GridViewLabItemStyle" id="tdmtr1"style="display:none" ><#=q.minimum_Tolerance_Rate#></td>
                            <td class="GridViewLabItemStyle" id="tdmtr"style="display:none"><#=q.maximum_Tolerance_Rate#></td>
                            <td class="GridViewLabItemStyle" id="td2"><#= q.IsActive==1?'True':'False' #></td>
                            <td class="GridViewLabItemStyle" id="tdCurrency"><#= q.currencyNotation#></td>
                            <td class="GridViewLabItemStyle hidden" id="tdCurrencyFactor"><#= q.CurrencyFactor#></td>
                            <td class="GridViewLabItemStyle" id="td4"><#= q.remarks#></td>
                            <td class="GridViewLabItemStyle">
                                <img style="cursor:pointer" alt="X" src="../../Images/Delete.gif" onclick="$(this).closest('tr').remove();addItemEvents();" />
                            </td>
                        </tr>

    </script>




    <script id="templateQuotationsDetails" type="text/html">   
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="tblQuotationDetais" style="width:100%;border-collapse:collapse;">                                  
        <tr id="MedHeader">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Supplier</th>
            <th class="GridViewHeaderStyle" scope="col" >Manufacturer</th>
            <th class="GridViewHeaderStyle" scope="col" >Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Rate</th>
            <th class="GridViewHeaderStyle" scope="col" >Discount</th>
            <th class="GridViewHeaderStyle" scope="col" >Tax</th>
            <%--<th class="GridViewHeaderStyle" scope="col" >GST Type</th>--%>
            <th class="GridViewHeaderStyle" scope="col" style="display:none">Deal</th>
            <th class="GridViewHeaderStyle" scope="col" >CostPrice</th>
            <th class="GridViewHeaderStyle" scope="col" >MRP</th>
            <th class="GridViewHeaderStyle" scope="col" >Profit</th>
            <th class="GridViewHeaderStyle" scope="col" >IsActive</th>
            <th class="GridViewHeaderStyle" scope="col" >FromDate</th>
            <th class="GridViewHeaderStyle" scope="col" >ToDate</th>
            <th class="GridViewHeaderStyle" scope="col" >EntryDate</th>
            <th class="GridViewHeaderStyle" style="display:none">Tolerance Qty(-)</th>
            <th class="GridViewHeaderStyle" style="display:none">Tolerance Qty(+)</th>
            <th class="GridViewHeaderStyle" style="display:none">Tolerance Rate(-)</th>
            <th class="GridViewHeaderStyle" style="display:none">Tolerance Rate(+)</th>
            <th class="GridViewHeaderStyle" scope="col" >Set Default</th>
       </tr>
       <#       
              var dataLength=quotationDetails.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var k=0;k<dataLength;k++)
        {
        objRow = quotationDetails[k];      
            #>        
                  <tr data='<#= JSON.stringify(quotationDetails[k])#>' id="<#=k+1#>" 
                             <#
                         if(quotationDetails[k].AppStatus =="False")
                          {#>   style="background-color:''" <#} 
                            else 
                             {
                               if(quotationDetails[k].AppStatus =="True")
                                 {#> style="background-color:#8fec96"  <#} 
                              } 
                             #>
                            >                            
                    <td class="GridViewLabItemStyle" > <#=k+1#></td> 
                    <td class="GridViewLabItemStyle" id="tdVendorName" ><#=objRow.VendorName#></td>
                    <td class="GridViewLabItemStyle" id="td1" style="text-align:center"><#=objRow.Name#></td>
                    <td class="GridViewLabItemStyle" id="td3" style="text-align:center"><#=objRow.ItemName#></td>   
                    <td class="GridViewLabItemStyle" id="tdrate" style="text-align:center"><#=objRow.Rate#></td>                 
                    <td class="GridViewLabItemStyle" id="tddiscsamt" style="text-align:right"><#=objRow.DiscAmt#></td>
                    <td class="GridViewLabItemStyle" id="tdtaxamt" style="text-align:right"><#=objRow.TaxAmt#></td>
                    <%--<td class="GridViewLabItemStyle" id="td4" style="text-align:right"><#=objRow.GSTType#></td>--%>
                    <td class="GridViewLabItemStyle" id="tdisdeal" style="text-align:center;display:none"><#=objRow.IsDeal#></td>
                    <td class="GridViewLabItemStyle" id="tdnetamt" ><#=objRow.NetAmt#></td>
                    <td class="GridViewLabItemStyle" id="td5" style="text-align:center"><#=objRow.MRP#></td>
                    <td class="GridViewLabItemStyle" id="tdProfit" style="text-align:center"><#=objRow.Profit#></td>
                    <td class="GridViewLabItemStyle" id="tdIsActive" style="text-align:center"><#=objRow.AppStatus#></td>
                    <td class="GridViewLabItemStyle" id="td6" style="text-align:center"><#=objRow.FromDate#></td>                 
                    <td class="GridViewLabItemStyle" id="tdtodate" style="text-align:right"><#=objRow.ToDate#></td>
                    <td class="GridViewLabItemStyle" id="tdentrydate" style="text-align:right"><#=objRow.EntryDate#></td>
                    <td class="GridViewLabItemStyle" id="td7" style="text-align:center;display:none"><#=objRow.Minimum_Tolerance_Qty#></td>
                    <td class="GridViewLabItemStyle" id="td8" style="text-align:center;display:none"><#=objRow.Maximum_Tolerance_Qty#></td>
                    <td class="GridViewLabItemStyle" id="td9" style="text-align:center;display:none"><#=objRow.Minimum_Tolerance_Rate#></td>
                    <td class="GridViewLabItemStyle" id="td10" style="text-align:center;display:none"><#=objRow.Maximum_Tolerance_Rate#></td>
                      <td class="GridViewLabItemStyle textCenter" id="tdsetvendor">
                            <a onclick="setDefault(this)" href="javascript:void(0)">Set</a>
                      </td>
                       <%--<td class="GridViewLabItemStyle" id="tdEdit" style="">
                        
                      </td>--%>
                        
                 </tr>
            <#}#>                      
     </table>     
    </script>





    <div id="divImportMapping" class="modal fade" >
        <div class="modal-dialog">
            <div class="modal-content" style="width:350px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divImportMapping" aria-hidden="true">×</button>
                    <h4 class="modal-title">Import .xlsx File.</h4>
                </div>
                <div class="modal-body">
                     <div class="row">
                         <div class="col-md-24">
                             <input type="file"  id="fileUploaderExcel" />
                         </div>
                      </div>
                </div>
                  <div class="modal-footer">
                         <button type="button" class="save" onclick="uploadFile()">Upload File</button>
                </div>
            </div>
        </div>
    </div>

        <div id="divSetDefaultRemarks" class="modal fade" >
        <div class="modal-dialog">
            <div class="modal-content" style="width:350px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSetDefaultRemarks" aria-hidden="true">×</button>
                    <h4 class="modal-title">Remarks</h4>
                    <span id="spnItemid" style="display:none"></span>
                    <span id="spnRateid" style="display:none"></span>
                </div>
                <div class="modal-body">
                     <div class="row">
                        <div class="col-md-10">
                                    <label class="pull-left">Remarks </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-14">
                                    <input type="text" autocomplete="off" onlytext="30" id="txtDefaultremarks" class="form-control ItDoseTextinputText requiredField"  />
                                </div>
                      </div>
                </div>
                  <div class="modal-footer">
                            <button type="button" onclick="$SaveDefaultremarks()" id="btnSavedefaultremarks" value="Save">Save</button>
                            <button type="button" data-dismiss="divSetDefaultRemarks">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

