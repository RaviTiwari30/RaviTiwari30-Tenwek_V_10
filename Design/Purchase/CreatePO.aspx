<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CreatePO.aspx.cs" Inherits="Design_Purchase_CreatePO" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />


    <style type="text/css">
        .customRow
        {
            cursor: pointer;
        }

            .customRow:hover
            {
                background-color: #b0f8f8;
            }

        .htDimmed
        {
            background-color: #a1f6ec;
            color: #0e0e0e !important;
        }

        .listbox:only-child .htDimmed
        {
            background-color: white !important;
        }

        .ht_clone_top
        {
            z-index: 0 !important;
        }

        .ht_clone_left
        {
            z-index: 0 !important;
        }

        .handsomeTableCustomize
        {
            font-size: 12px !important;
        }

        #Pbody_box_inventory
        {
            width: 1345px !important;
        }

        .POuter_Box_Inventory
        {
            width: 1340px !important;
        }

        .htCommentTextArea
        {
            pointer-events: none;
        }


        .autocompleteEditor
        {
            position: fixed;
        }
    </style>
    <script id="script1" type="text/javascript">

       /// var gstPercentage = [];

        $(document).ready(function () {

            getCategorys(function () { });
            getMedicineGroup(function () { });
            //getCurrencyDetails(function (SelectedCountryID) {
            //    getCurrencyFactor(SelectedCountryID, function () { });
            //});
            getPurchaseMarkUpPercent(function () { });
            getVendors(function () {
                getTermsAndConditions(function () {
                    getTaxGroups(function () {
                        getTaxCalOn(function () {
                            POByItemInit();
                            getStoreByCenter();
                                bindGSTPer();
                            getPurchaseOrders(true);
                            if (!String.isNullOrEmpty(editPurchaseOrderNo))
                                bindPurchaseOrderForEdit(editPurchaseOrderNo)

                        });
                    });
                });
            });


            $('#ddlSupplier').change(function () {
                getDepartmentItems(function () {
                    POByItemInit();
                }, 1);

            });

            $('[name=storeType],#ddlPurchaseOrderType,#ddlCategory').change(function () {
                getDepartmentItems(function () {
                    POByItemInit();
                }, 1);
            });
        });








        //*****Global Variables*******
        var hTables = {};
        var matching = [];
        var items = [];
        var vendors = [];
        var taxGroups = [];
        var centreID = '<%=ViewState["centerID"].ToString()%>';
        var departmentLedgerNo = '<%=ViewState["deptLedgerNo"].ToString()%>';
        var userID = '<%=ViewState["userID"].ToString()%>';
        var hospitalID = '<%=ViewState["HOSPID"].ToString()%>';
        var IsFree = ['No', 'Yes'];
        var taxCalOn = [];
        var centerWiseMarkUp = [];
        var editPurchaseOrderNo = '<%=ViewState["PurchaseOrderNo"].ToString()%>';
        var editPurchaseOrderNoVendorID = '';
        var CurrencyMaster = [];
        vendorTermsAndConditions = [];
        //****************************


        var getTermsAndConditions = function (callback) {
            serverCall('Services/CreatePO.asmx/GetTermAndConditions', {}, function (response) {
                var responseData = JSON.parse(response);
                vendorTermsAndConditions = responseData;
                callback(responseData);
            });
        }


        var bindGSTPer = function () {
            //dev
            var IsGSTApp = '<%=Resources.Resource.IsGSTApplicable%>';
            if (IsGSTApp == 1) {
                var ID = $('#ddlGSTGroup').val();
                var filterGST = taxGroups.filter(function (i) { return i.id == ID });
                $("#spnGSTDetails").text('');
                $('#txtVatPercent').val(filterGST[0].TotalGST);
                if (filterGST[0].TaxGroup.toUpperCase() == 'IGST') {
                    $("#spnGSTDetails").text('IGST(%) : ' + filterGST[0].IGSTPer);
                }
                else if (filterGST[0].TaxGroup.toUpperCase() == 'CGST&SGST') {
                    $("#spnGSTDetails").text('CGST(%) : ' + filterGST[0].CGSTPer + '  ,  SGST(%) : ' + filterGST[0].SGSTPer);
                }
                else {
                    $("#spnGSTDetails").text('CGST(%) : ' + filterGST[0].CGSTPer + '  ,  UTGST(%) : ' + filterGST[0].UTGSTPer);
                }
            }
            else {
                $('#txtVatPercent').val(0);
            }

        }

        var getPurchaseMarkUpPercent = function () {
            serverCall('../Store/Services/CommonService.asmx/GetPurchaseMarkUpPercent', {}, function (response) {
                var responseData = JSON.parse(response);
                centerWiseMarkUp = responseData; //assign to global variables
            });
        }
        var getVatTaxPercent = function (data, callback) {
            serverCall('../Store/Services/CommonService.asmx/GetVatTaxPercent', data, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }

        var getCurrencyDetails = function (callback) {
            var ddlCurrency = $('#ddlCurrency');
            serverCall('../Common/CommonService.asmx/LoadCurrencyDetail', {}, function (response) {
                var responseData = JSON.parse(response);
                CurrencyMaster = JSON.parse(response);
                $(ddlCurrency).bindDropDown({
                    data: responseData.currancyDetails,
                    valueField: 'CountryID',
                    textField: 'Currency',
                    selectedValue: responseData.baseCountryID
                });
                callback(ddlCurrency.val());
            });
        }

        var filterCurrency = function (query, process) {
            if (query.length > 0) {
                i = CurrencyMaster.currancyDetails;

                var matcher = new RegExp(query.replace(/([.?*+^$[\]\\(){}|-])/g, '\\$1'), 'i');
                matching = $.grep(i, function (obj) {
                    return matcher.test(obj.Currency);
                });
                process(matching.map(function (i) { return i.Currency }));
            }
            else {
                matching = [];
                process([]);
            }
        }

        var getSubCategory = function () {
            var categoryID = $("#ddlCategory option:selected").val();
            serverCall('Services/CreatePO.asmx/GetSubCategoryByCategory', { categoryID: categoryID }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSubCategory').bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name' });
            });
        }


        var getMedicineGroup = function (callback) {
            //serverCall('Services/CreatePO.asmx/GetMedicineGroup', {}, function (response) {
            //    var responseData = JSON.parse(response);
            //    callback($('#ddlMedicineGroup').bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'ItemGroup', defaultValue: 'All' }));
            //});
        }

        var getCategorys = function (callback) {
            serverCall('Services/CreatePO.asmx/GetCategorys', {}, function (response) {
                var responseData = JSON.parse(response).reverse();
                callback($('#ddlCategory').bindDropDown({ data: JSON.parse(response).reverse(), valueField: 'CategoryID', textField: 'Name' }));
                getSubCategory();
            });
        }

        var getSubCategorys = function (categoryID) {
            serverCall('Services/CreatePO.asmx/GetSubCategoryByCategory', { categoryID: categoryID }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSubCategory').bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name' });
            });
        }

        var onPurchaseOrderTypeChange = function (elem) {
            var _purchaseOrderBySupplier = $('.purchaseOrderBySupplier');
            var _purchaseOrderByPurchaseRequest = $('.purchaseOrderByPurchaseRequest');
            var _purchaseOrderByReorderLevel = $('.POByROL');
            var _ddlSupplier = $('#ddlSupplier');
            var _purchaseRequestType = Number(elem.value);


            if (_purchaseRequestType == 1) {
                _purchaseOrderBySupplier.hide();
                _purchaseOrderByPurchaseRequest.hide();
                _purchaseOrderByReorderLevel.show();
                _ddlSupplier.empty();
                var id = $("#ddlCategory option:selected").val();
                getDepartmentItems(function () {

                }, id);
            }
            else if (_purchaseRequestType == 2) {
                _purchaseOrderBySupplier.show();
                _purchaseOrderByPurchaseRequest.hide();
                _ddlSupplier.bindDropDown({ data: vendors, valueField: 'ID', textField: 'LedgerName' });
                _ddlSupplier.prop('disabled', false)
            }
            else if (_purchaseRequestType == 3) {
                _purchaseOrderBySupplier.hide();
                _purchaseOrderByPurchaseRequest.hide();
                _purchaseOrderByReorderLevel.show();
                _ddlSupplier.empty();
                var id = $("#ddlCategory option:selected").val();
                var Subid = $("#ddlSubCategory option:selected").val();
                if (Subid == undefined) {
                    alert("please select subcategory");
                }
                else {
                    getPurchaseOrderItemsByReoderLevel();

                    getDepartmentItems(function () {

                    }, id);
                }
            }
            else if (_purchaseRequestType == 4) {
                _purchaseOrderByPurchaseRequest.show();
                _purchaseOrderBySupplier.hide();
            }
            else {
                _purchaseOrderBySupplier.hide();
                _purchaseOrderByPurchaseRequest.hide();
                _purchaseOrderByReorderLevel.hide();
                _ddlSupplier.empty();
            }
            if (_purchaseRequestType != 3) {
                getDepartmentItems(function () {
                    POByItemInit();
                }, 1);
            }


        }

        var POByItemInit = function () {
            var $container = document.getElementById('divPOContainer');
            $container.innerHTML = '';
            getGridSetting([], function (s) {
                hTables = new Handsontable($container, s);
                hTables.render();
            });
        }


        var getVendors = function (callback) {
            serverCall('../Store/Services/CommonService.asmx/GetVendors', {}, function (response) {
                vendors = JSON.parse(response);
                $('#ddlQuotationSupplier').bindDropDown({
                    defaultValue: 'Select',
                    data: vendors,
                    valueField: 'ID',
                    textField: 'LedgerName',
                    customAttr: ['VATType', 'Currency', 'CountryID']
                });
                callback(vendors);
            });
        }

        var filterVender = function (query, process) {

            if (query.length > 0) {
                i = vendors;

                if (!String.isNullOrEmpty(editPurchaseOrderNoVendorID))
                    i = vendors.filter(function (v) { return v.ID == editPurchaseOrderNoVendorID; });

                var matcher = new RegExp(query.replace(/([.?*+^$[\]\\(){}|-])/g, '\\$1'), 'i');
                matching = $.grep(i, function (obj) {
                    return matcher.test(obj.LedgerName);
                });
                process(matching.map(function (i) { return i.LedgerName }));
            }
            else {
                matching = [];
                process([]);
            }
        }

        var getTaxGroups = function (callback) {
            serverCall('../Store/Services/CommonService.asmx/GetTaxGroups', {}, function (response) {
                taxGroups = JSON.parse(response);
                $('#ddlGSTGroup').bindDropDown({ data: taxGroups, valueField: 'id', textField: 'TaxGroupLabel', isSearchable: false });
                callback($('#ddlGSTGroup').val());
                callback(taxGroups);
            })
        }

        var getTaxCalOn = function (callback) {
            serverCall('../Store/Services/CommonService.asmx/GetTaxCalOn', {}, function (response) {
                taxCalOn = ['RateAD']; JSON.parse(response);
                $('#ddlTaxCalculatedOn').bindDropDown({ data: taxCalOn });
                callback(taxCalOn);
            })
        }

        var getStoreByCenter = function () {
            serverCall('../Store/Services/CommonService.asmx/GetStoreByCenter', { centerId: centreID }, function (response) {
                $('#ddlPODept').bindDropDown({ data: JSON.parse(response), valueField: 'DeptLedgerNo', textField: 'RoleName' });
            });
        }

        var getGridSetting = function (data, callback) {
            var selectedPurchaseOrderType = Number($('#ddlPOType').val());
            if (typeof (hTables.destroy) == 'function')
                hTables.destroy();

            var disableVendorSelection = false;
            if (selectedPurchaseOrderType == 2)
                disableVendorSelection = true;



            var isPurchaseOrderUsingPurchaseRequest = false;

            if (selectedPurchaseOrderType == 4)
                isPurchaseOrderUsingPurchaseRequest = true


            if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                var colwidth = [450, 300, 65, 65, 65, 65, 65, 65, 90, 65, 65, 85, 75, 80, 58, 70, 70, 70, 50];
                var table = ['ItemName', 'Supplier', 'Currency', 'Factor', 'Qty.', 'Rate', 'MRP', 'Discount', 'GSTGroup', 'IGST', 'CGST', 'SGST/UTGST', 'Tax On', 'P-Unit', 'Total GST%', 'GST Amt.', 'Net Amt.', 'Budget', 'Free'];//'GSTGroup'
            }
            else {
                var colwidth = [450, 300, 65, 65, 65, 65, 65, 65, 50, 80, 58, 70, 70, 70, 50, 50];
                var table = ['ItemName', 'Supplier', 'Currency', 'Factor', 'Qty.', 'Rate', 'MRP', 'Discount', 'Tax On', 'P-Unit', 'VAT', 'Tax Amt.', 'Net Amt.', 'Budget', 'Free'];
            }

            debugger;
            var s = {
                data: data,
                minSpareRows: isPurchaseOrderUsingPurchaseRequest ? 0 : 1,
                comments: true,
                rowHeaders: true,
                filters: true,
                allowInsertRow: true,
                contextMenu: { callback: function (key, selection, clickEvent) { }, items: { 'row_above': {}, 'row_below': {}, 'remove_row': {} } },
                outsideClickDeselects: false,
                colWidths: colwidth,
                colHeaders: table,
              
                columns: [
                    {
                        type: 'autocomplete',
                        data: 'ItemName',
                        source: filterItems,
                        strict: true,
                        readOnly: isPurchaseOrderUsingPurchaseRequest
                       
                    },
                    {
                        type: 'autocomplete',
                        data: 'Supplier',
                        source: filterVender,
                        strict: true,
                        readOnly: disableVendorSelection,
                        //  readOnly: false
                    },
                    {
                        type: 'text',
                        data: 'Currency',
                        readOnly: true
                    },
                    { data: 'CurrencyFactor', type: 'numeric', format: '0.0000' },

                        { data: 'Quantity', type: 'numeric', format: '0.0000' },

                        { data: 'Rate', type: 'numeric', readOnly: false, format: '0.0000' },
                        { data: 'MRP', type: 'numeric', readOnly: false, format: '0.0000' },
                        { data: 'Discount', type: 'numeric', readOnly: true, format: '0.0000' },

                       
                        //{ data: 'GSTGroup', type: 'text', readOnly: false, },
                        //{ data: 'IGST', type: 'numeric', readOnly: true, format: '0.0000' },
                        //{ data: 'CGST', type: 'numeric', readOnly: true, format: '0.0000' },
                        //{ data: 'SGST', type: 'numeric', readOnly: true, format: '0.0000' },
                       
                        {
                            type: 'autocomplete',
                            data: 'TaxOn',
                            source: taxCalOn,
                            strict: true,
                        },
                        { data: 'PUnit', type: 'text', readOnly: true },

                         {
                             type: 'numeric',
                             data: 'VAT',
                             source: $.map(taxGroups, function (t) { return t.TaxGroup }),
                             strict: true,
                             readOnly: false,
                             format: '0.0000'
                         },

                        { data: 'TaxAmt', type: 'text', readOnly: true, format: '0.0000' },

                        { data: 'NetAmount', type: 'text', readOnly: true, format: '0.0000' },
                        { data: 'Budget', type: 'text', readOnly: true, format: '0.0000' },

                        {
                            type: 'autocomplete',
                            data: 'Free',
                            source: IsFree,
                            strict: true,
                        },
                        
                ],
                hiddenColumns: {
                    columns: [8, 9, 10,11],
                    indicators: true
                },
                    beforeChange: function (changes, source) {
                        if (source === 'loadData' || source === 'internal' || changes.length > 1)
                            return;

                        var h = this;
                        var row = changes[0][0];
                        var prop = changes[0][1];
                        var value = $.trim(changes[0][3]);
                       // alert(prop);
                        if (prop === 'ItemName') {

                            //alert("ff");
                            matching = matching.filter(function (i) { if (i.ItemName == value) { return i; } }); //global Variable

                            if (matching.length < 1)
                                return false;

                            var selectedData = matching[0];


                            h.setDataAtRowProp(row, h.propToCol('SubCategoryID'), selectedData.SubCategoryID);
                            h.setDataAtRowProp(row, h.propToCol('ManufactureID'), selectedData.ManufactureID);
                            h.setDataAtRowProp(row, h.propToCol('ManuFacturer'), selectedData.ManuFacturer);
                            h.setDataAtRowProp(row, h.propToCol('ItemID'), selectedData.ItemID);
                            h.setDataAtCell(row, h.propToCol('PUnit'), selectedData.MajorUnit);
                            h.setDataAtRowProp(row, h.propToCol('HSNCode'), selectedData.HSNCode);
                           
                            //h.setDataAtCell(row, h.propToCol('GSTGroup'), 'IGST-12%');//
                            h.setDataAtRowProp(row, h.propToCol('VatType'), selectedData.VatType);
                            h.setDataAtRowProp(row, h.propToCol('AdvanceAmount'), 0);

                            
                            h.setDataAtRowProp(row, h.propToCol('TaxCalulatedOn'), 'RateAD')

                            h.setDataAtCell(row, h.propToCol('CurrencyFactor'), 0);
                            h.setDataAtCell(row, h.propToCol('Rate'), 0);
                            h.setDataAtCell(row, h.propToCol('MRP'), 0);
                            h.setDataAtCell(row, h.propToCol('Discount'), 0);
                            h.setDataAtCell(row, h.propToCol('TaxOn'), 'RateAD');
                            h.setDataAtCell(row, h.propToCol('Free'), 'No');
                            h.setDataAtCell(row, h.propToCol('Quantity'), 0);
                            h.setDataAtCell(row, h.propToCol('TaxAmt'), 0);
                            h.setDataAtCell(row, h.propToCol('NetAmount'), 0);
                            if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                                h.setDataAtRowProp(row, h.propToCol('IGSTPercent'), 0);
                                h.setDataAtRowProp(row, h.propToCol('IGSTAmt'), 0);
                                h.setDataAtRowProp(row, h.propToCol('CGSTPercent'), 0);
                                h.setDataAtRowProp(row, h.propToCol('CGSTAmt'), 0);
                                h.setDataAtRowProp(row, h.propToCol('SGSTPercent'), 0);
                                h.setDataAtRowProp(row, h.propToCol('SGSTAmt'), 0);
                                h.setDataAtRowProp(row, h.propToCol('GSTType'), 'IGST');//
                                h.setDataAtCell(row, h.propToCol('IGST'), 0);
                                h.setDataAtCell(row, h.propToCol('CGST'), 0);
                                h.setDataAtCell(row, h.propToCol('SGST'), 0);
                            }
                            //h.setDataAtCell(row, h.propToCol('netAmountWithOutTax'), 0);

                            getItemQuotationDetails(selectedData.ItemID, function (quotationDetails) {
                                if (quotationDetails.length > 0) {
                                  //  alert(quotationDetails[0].VAT);
                                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                                        h.setDataAtCell(row, h.propToCol('MRP'), quotationDetails[0].MRP);

                                        h.setDataAtRowProp(row, h.propToCol('IGSTPercent'), quotationDetails[0].IGSTPercent);
                                        h.setDataAtRowProp(row, h.propToCol('CGSTPercent'), quotationDetails[0].CGSTPercent);
                                        h.setDataAtRowProp(row, h.propToCol('SGSTPercent'), quotationDetails[0].SGSTPercent);
                                        h.setDataAtRowProp(row, h.propToCol('GSTType'), quotationDetails[0].GSTType);

                                        h.setDataAtCell(row, h.propToCol('GSTGroup'), quotationDetails[0].TaxGroup);
                                        h.setDataAtCell(row, h.propToCol('IGST'), quotationDetails[0].IGSTPercent);
                                        h.setDataAtCell(row, h.propToCol('CGST'), quotationDetails[0].CGSTPercent);
                                        h.setDataAtCell(row, h.propToCol('SGST'), quotationDetails[0].SGSTPercent);
                                    }
                                    h.setDataAtCell(row, h.propToCol('VAT'), quotationDetails[0].VAT);
                                    h.setDataAtCell(row, h.propToCol('TaxAmt'), quotationDetails[0].TaxAmt);
                                    h.setDataAtCell(row, h.propToCol('Discount'), quotationDetails[0].DiscountPercent);
                                    h.setDataAtCell(row, h.propToCol('TaxOn'), quotationDetails[0].TaxCalulatedOn);
                                    h.setDataAtCell(row, h.propToCol('Rate'), quotationDetails[0].rate);

                                    if (!String.isNullOrEmpty(editPurchaseOrderNoVendorID))
                                        quotationDetails[0].Vendor_ID = editPurchaseOrderNoVendorID;


                                    var vendor = vendors.filter(function (v) { if (v.ID == quotationDetails[0].Vendor_ID) { return v; } });
                                    if (vendor.length > 0)
                                        h.setDataAtCell(row, h.propToCol('Supplier'), vendor[0].LedgerName);
                                    else
                                        h.setDataAtCell(row, h.propToCol('Supplier'), '');



                                    h.setDataAtCell(row, h.propToCol('Currency'), quotationDetails[0].Currency);
                                    h.setDataAtCell(row, h.propToCol('CurrencyFactor'), quotationDetails[0].Currency_Factor);
                                    h.setDataAtRowProp(row, h.propToCol('CurrencyCountryID'), quotationDetails[0].CurrencyCountryID);
                                    h.setDataAtRowProp(row, h.propToCol('ConversionFactor'), quotationDetails[0].ConversionFactor)
                                    h.setDataAtRowProp(row, h.propToCol('Minimum_Tolerance_Qty'), quotationDetails[0].Minimum_Tolerance_Qty);
                                    h.setDataAtRowProp(row, h.propToCol('Maximum_Tolerance_Qty'), quotationDetails[0].Maximum_Tolerance_Qty);
                                    h.setDataAtRowProp(row, h.propToCol('Minimum_Tolerance_Rate'), quotationDetails[0].Minimum_Tolerance_Rate);
                                    h.setDataAtRowProp(row, h.propToCol('Maximum_Tolerance_Rate'), quotationDetails[0].Maximum_Tolerance_Rate);

                                    //  h.setDataAtCell(row, h.propToCol('ConversionFactor'), quotationDetails[0].ConversionFactor)
                                }
                                else {
                                    if (!String.isNullOrEmpty(editPurchaseOrderNoVendorID)) {
                                        var vendor = vendors.filter(function (v) { if (v.ID == editPurchaseOrderNoVendorID) { return v; } });
                                        if (vendor.length > 0)
                                            h.setDataAtCell(row, h.propToCol('Supplier'), vendor[0].LedgerName);
                                        else
                                            h.setDataAtCell(row, h.propToCol('Supplier'), '');
                                    }
                                }
                            });
                        }
                        else if (prop === 'Quantity') {
                            calculateTaxAmount(h, row, value, function () { });

                        }



                        else if (prop === 'Supplier') {
                            var matchedSupplier = vendors.filter(function (v) { if (v.LedgerName == value) { return v; } }); //global Variable

                            if (matchedSupplier.length < 1)
                                return false;

                            h.setDataAtRowProp(row, h.propToCol('supplierID'), matchedSupplier[0].ID);

                            if (source == 'edit') {
                                getCurrencyFactor(matchedSupplier[0].Currency, function (currencyFactorDetail) {
                                    h.setDataAtCell(row, h.propToCol('CurrencyFactor'), precise_round(currencyFactorDetail.currencyFactor, 4));
                                    h.setDataAtCell(row, h.propToCol('Currency'), matchedSupplier[0].Currency);
                                });
                            }
                        }



                        else if (['TaxOn', 'Deal', 'GSTGroup', 'Rate', 'Free'].indexOf(prop) > -1) {
                            if (prop === 'Free') {
                                var FreeCon = IsFree.filter(function (i) { if (i == value) { return i; } });//global Variable
                                if (FreeCon.length < 1)
                                    return false;
                            }
                            if (prop === 'GSTGroup') {
                                var matchedGroup = taxGroups.filter(function (t) { if (t.TaxGroup == value) { return t; } }); //global Variable
                                if (matchedGroup.length < 1)
                                    return false;
                            }
                            if (prop === 'TaxOn') {
                                var matchedType = taxCalOn.filter(function (t) { if (t == value) { return t; } }); //global Variable
                                if (matchedType.length < 1)
                                    return false;
                            }

                            var quantity = h.getDataAtRowProp(row, 'Quantity');
                            if (!String.isNullOrEmpty(quantity))
                                h.setDataAtCell(row, h.propToCol('Quantity'), Number(quantity));
                        }

                        //hTables.hideColumns([8, 9, 10, 11]);
                        hTables.render();
                        updateAmounts();
                    },
                    afterChange: function (changes, source) {
                        if (source === 'loadData' || source === 'internal' || changes.length > 1)
                            return;

                        var h = this;
                        var row = changes[0][0];
                        var prop = changes[0][1];
                        var value = $.trim(changes[0][3]);
                    //   if( prop === 'SGST' || prop === 'CGST' || prop === 'IGST') {
                    if (prop === 'VAT') {
                        var quantity = h.getDataAtRowProp(row, 'Quantity');
                        if (!String.isNullOrEmpty(quantity))
                            h.setDataAtCell(row, h.propToCol('Quantity'), Number(quantity));
                    }


                        var recordsCount = hTables.countRows();
                        if (recordsCount > 1)
                            $('input:radio[name=storeType],#ddlSupplier,#ddlPurchaseOrderType,#ddlCurrency,#txtCurrencyFactor').prop('disabled', true);
                    },
                    afterRemoveRow: function (s, c, d) {
                        updateAmounts();
                        var recordsCount = hTables.countRows();
                        if (recordsCount < 2)
                            $('input:radio[name=storeType],#ddlSupplier,#ddlPurchaseOrderType,#ddlCurrency,#txtCurrencyFactor').prop('disabled', false);
                    },
                }
            callback(s);
        }

        var filterItems = function (query, process) {
            getDepartmentItems(function (i) {
                if (query.length > 1) {
                    var matcher = new RegExp(query.replace(/([.?*+^$[\]\\(){}|-])/g, '\\$1'), 'i');
                    matching = $.grep(i, function (obj) {
                        return matcher.test(obj.ItemName);
                    });
                    process(matching.map(function (i) { return i.ItemName }));
                }
                else {
                    matching = [];
                    process([]);
                }
            }, 0);
        }

        var getDepartmentItems = function (callback, IsDepartMentChange) {

            var vendorId = 0;
            var purchaseOrderBy = Number($('#ddlPOType').val());
            var storeType = $("#ddlCategory option:selected").val();
            var purchaseOrderType = Number($("#ddlPurchaseOrderType option:selected").val());


            if (purchaseOrderBy == 2)
                vendorId = ($('#ddlSupplier').val());

            if (IsDepartMentChange != 0 && IsDepartMentChange != 1) {
                var data = {
                    centreID: centreID,
                    departmentLedgerNo: departmentLedgerNo,
                    vendorId: vendorId,
                    storeType: storeType,
                    purchaseOrderType: purchaseOrderType
                    //parseInt($('input:radio[name=storeType]:checked').val())
                }
                serverCall('Services/CreatePO.asmx/GetItems', data, function (response) {
                    var responseData = JSON.parse(response);
                    items = responseData;
                    callback(items);
                });
            }
            else if (items.length == 0 || IsDepartMentChange == 1) {
                var data = {
                    centreID: centreID,
                    departmentLedgerNo: departmentLedgerNo,
                    vendorId: vendorId,
                    storeType: storeType,
                    purchaseOrderType: purchaseOrderType
                    //$("#ddlCategory option:selected").val()                                                    //parseInt($('input:radio[name=storeType]:checked').val())
                }
                serverCall('Services/CreatePO.asmx/GetItems', data, function (response) {
                    var responseData = JSON.parse(response);
                    items = responseData;
                    callback(items);
                });
            }

            else {
                callback(items);
            }
        }

        var getItemQuotationDetails = function (itemID, callback) {
            var data = {
                itemID: itemID,
                centreID: centreID,
                departmentLedgerNo: departmentLedgerNo,

            };
            serverCall('Services/CreatePO.asmx/GetItemQuotationDetails', data, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.length < 1) {
                    modelAlert('Quotation Not Found.');
                    return false;
                }
                else
                    callback(responseData);

            });
        }

        var calculateTaxAmount = function (h, row, value, callback) {

            var extraCost = Number($('#txtExtraCost').val());
            var dealValue = h.getDataAtRowProp(row, 'Deal');
            if (String.isNullOrEmpty(dealValue))
                dealValue = '';


            var deals = dealValue.split('+');
            var discountPercent = h.getDataAtRowProp(row, 'Discount');
            var taxCalculateOn = h.getDataAtRowProp(row, 'TaxOn');
            var taxGroup = h.getDataAtRowProp(row, 'GSTGroup');
            var rate = Number(h.getDataAtRowProp(row, 'Rate'));
            var MRP = Number(h.getDataAtRowProp(row, 'MRP'));
            var TaxPer = Number(h.getDataAtRowProp(row, 'VAT'));
            var subCategoryID = h.getDataAtRowProp(row, 'SubCategoryID');
            var ItemID = h.getDataAtRowProp(row, 'ItemID');
            var deal2 = 0;
            var deal = Number(deals[0]);
            if (deals.length > 1)
                deal2 = Number(deals[1]);

            var qty = Number(value);
            var data = { Rate: rate, ActualRate: rate, MRP: MRP, deal: deal, deal2: deal2, DiscPer: discountPercent, Type: taxCalculateOn, Quantity: qty, TaxPer: TaxPer };

            
            if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                getTaxAmount(data, 0, function (response) {
                    var responseData = response;

                    h.setDataAtRowProp(row, h.propToCol('netAmountWithOutTax'), precise_round((responseData.netAmountWithOutTax), 4));
                    h.setDataAtCell(row, h.propToCol('TaxAmt'), precise_round(responseData.taxAmount, 4));
                    h.setDataAtCell(row, h.propToCol('NetAmount'), precise_round(responseData.netAmount, 4));
                    debugger;
                    var itemMRP = calculateItemMRP({
                        rate: rate,
                        quantity: qty,
                        totalOrderAmount: responseData.netAmount,
                        otherCharges: extraCost,
                        markUpPercent: '',
                        subCategoryID: subCategoryID,
                        centerWiseMarkUp: centerWiseMarkUp,
                        netAmount: responseData.netAmount,
                        itemId: ItemID
                    });
                    h.setDataAtCell(row, h.propToCol('MRP'), precise_round(itemMRP, 4));
                    h.render();
                });

            }
            else {
                getTaxAmount(data, 0, function (response) {
                    var responseData = response;

                    h.setDataAtRowProp(row, h.propToCol('netAmountWithOutTax'), precise_round((responseData.netAmountWithOutTax), 4));
                    h.setDataAtCell(row, h.propToCol('TaxAmt'), precise_round(responseData.taxAmount, 4));
                    h.setDataAtCell(row, h.propToCol('NetAmount'), precise_round(responseData.netAmount, 4));
                        if (taxGroup == 'IGST') {
                            h.setDataAtCell(row, h.propToCol('IGST'), TaxPer);
                            h.setDataAtCell(row, h.propToCol('CGST'), 0);
                            h.setDataAtCell(row, h.propToCol('SGST'), 0);
                            h.setDataAtRowProp(row, h.propToCol('IGSTPercent'), TaxPer);
                            h.setDataAtRowProp(row, h.propToCol('CGSTPercent'), 0);
                            h.setDataAtRowProp(row, h.propToCol('SGSTPercent'), 0);
                        } else{
                            h.setDataAtCell(row, h.propToCol('CGST'), TaxPer / 2);
                            h.setDataAtCell(row, h.propToCol('SGST'), TaxPer / 2);
                            h.setDataAtRowProp(row, h.propToCol('CGSTPercent'), TaxPer / 2);
                            h.setDataAtRowProp(row, h.propToCol('SGSTPercent'), TaxPer / 2);
                            h.setDataAtCell(row, h.propToCol('IGST'), 0);
                            h.setDataAtRowProp(row, h.propToCol('IGSTPercent'), 0);
                        }

                    h.setDataAtRowProp(row, h.propToCol('IGSTAmt'), precise_round(responseData.igstTaxAmount, 4));
                    h.setDataAtRowProp(row, h.propToCol('CGSTAmt'), precise_round(responseData.cgstTaxAmount, 4));
                    h.setDataAtRowProp(row, h.propToCol('SGSTAmt'), precise_round(responseData.sgstTaxAmount, 4));

                    //debugger;
                    //var itemMRP = calculateItemMRP({
                    //    rate: rate,
                    //    quantity: qty,
                    //    totalOrderAmount: responseData.netAmount,
                    //    otherCharges: extraCost,
                    //    markUpPercent: '',
                    //    subCategoryID: subCategoryID,
                    //    centerWiseMarkUp: centerWiseMarkUp,
                    //    netAmount: responseData.netAmount,
                    //    itemId: ItemID
                    //});
                    //h.setDataAtCell(row, h.propToCol('MRP'), precise_round(itemMRP, 4));
                    h.render();
                });
            }
        }

        var getTaxAmountGST = function (d, taxGroupID, callback) {
            serverCall('Services/CreatePO.asmx/CalculateTaxAmount', { taxCalculationOn: d, taxGroupID: taxGroupID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }

        var getTaxAmount = function (d, taxGroupID, callback) {
            if (d.MRP == null || isNaN(d.MRP))
                d.MRP = 0;

            if (d.ActualRate == null || isNaN(d.ActualRate))
                d.ActualRate = 0;

            if (d.Rate == null || isNaN(d.Rate))
                d.Rate = 0;

            if (d.TaxPer == null || isNaN(d.TaxPer))
                d.TaxPer = 0;

            if (d.IGSTPercent == null || isNaN(d.IGSTPercent))
                d.IGSTPercent = 0;

            if (d.CGSTPercent == null || isNaN(d.CGSTPercent))
                d.CGSTPercent = 0;

            if (d.SGSTPercent == null || isNaN(d.SGSTPercent))
                d.SGSTPercent = 0;

            if (d.Rate != 0) {

                var TaxAmount = 0;
                var NetAmount = 0;
                var Amount = 0;
                var DiscountAmount = 0;
                var UnitPrice = 0;
                var MRPValue = 0;
                var ExciseAmount = 0;
                var ExcisePer = 0;
                var Rate = 0;

                var igstTaxAmt = 0;
                var cgstTaxAmt = 0;
                var sgstTaxAmt = 0;

                var igstTaxPer = 0;
                var cgstTaxPer = 0;
                var sgstTaxPer = 0;


                var SpecialDiscAmt = 0;
                d = [d];

                if (d[0].deal == 0 && d[0].deal2 == 0) {
                    Amount = (d[0].Quantity * d[0].Rate);
                    Rate = d[0].Rate;
                }
                else {
                    Amount = (d[0].deal * d[0].Rate);
                    Rate = (d[0].ActualRate * d[0].deal) / (d[0].deal + d[0].deal2);
                }
                if (d[0].DiscPer > 0)
                    DiscountAmount = ((Amount * d[0].DiscPer) / 100);
                else
                    DiscountAmount = 0;



                TaxAmount = ((Amount - DiscountAmount - SpecialDiscAmt) * d[0].TaxPer) / 100;
                NetAmount = (Amount + TaxAmount - DiscountAmount - SpecialDiscAmt);
                igstTaxPer = d[0].IGSTPercent;
                cgstTaxPer = d[0].CGSTPercent;
                sgstTaxPer = d[0].SGSTPercent;
                igstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * d[0].IGSTPercent) / 100;
                cgstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * d[0].CGSTPercent) / 100;
                sgstTaxAmt = ((Amount - DiscountAmount - SpecialDiscAmt) * d[0].SGSTPercent) / 100;

                MRPValue = (d[0].MRP * d[0].Quantity);

                var responseData = {
                    amount: precise_round(Number(Amount), 4),
                    netAmount: precise_round(Number(NetAmount), 4),
                    netAmountWithOutTax: precise_round(Number((d[0].Quantity * d[0].Rate)), 4),
                    taxAmount: precise_round(Number(TaxAmount), 4),
                    discountAmount: precise_round(Number(DiscountAmount), 4),
                    discountPercent: precise_round(Number(d[0].DiscPer), 4),
                    unitPrice: precise_round(Number(UnitPrice), 4),
                    MRP: precise_round(Number(MRPValue), 4),
                    exciseAmount: 0,
                    excisePercent: 0,
                    igstTaxAmount: igstTaxAmt,
                    IGSTPrecent: igstTaxPer,
                    CGSTPercent: cgstTaxPer,
                    SGSTPercent: sgstTaxPer,
                    cgstTaxAmount: cgstTaxAmt,
                    sgstTaxAmount: sgstTaxAmt,
                    specialDiscountPer: 0,
                    specialDiscountAmount: 0

                };

                callback(responseData);
            }
            else {
              //  modelAlert("Quatation Not Found", function () { });
            }
        }

        var updateAmounts = function () {
            var totalNetAmount = 0;
            var totalNetAmountWithOutTax = 0;
            var purchaseOrderItems = [];
            $.merge(purchaseOrderItems, hTables.getData());
            var purchaseOrderType = Number($('#ddlPOType').val());

            if (purchaseOrderType != 4)
                purchaseOrderItems.pop(purchaseOrderItems.length, 1);

            for (var i = 0; i < purchaseOrderItems.length; i++) {
                totalNetAmount += Number(purchaseOrderItems[i].NetAmount) * Number(purchaseOrderItems[i].CurrencyFactor);
                totalNetAmountWithOutTax += (Number(purchaseOrderItems[i].Quantity) * Number(purchaseOrderItems[i].Rate)) * Number(purchaseOrderItems[i].CurrencyFactor);
            }

            totalNetAmount += Number($('#txtExtraCost').val());

            $('#txtNetAmount').val(precise_round(totalNetAmount, 4)).attr('totalnetamountwithouttax', precise_round(totalNetAmountWithOutTax, 4));
            $('#txtRoundOff').val(precise_round(totalNetAmount - precise_round(totalNetAmount, 4), 4));

        }

        var extraChargeChange = function (el) {
            var totalNetAmountWithTax = Number($('#txtNetAmount').val());
            //  calculateMRP(totalNetAmountWithTax);
            updateAmounts();
        }

        var calculateMRP = function (totalNetAmount) {

            var extraCost = Number($('#txtExtraCost').val());
            var grid = hTables.getData();
            for (var i = 0; i < grid.length - 1; i++) {
                var subCategoryID = hTables.getDataAtRowProp(i, 'SubCategoryID');
                var rate = Number(hTables.getDataAtRowProp(i, 'Rate'));
                var quantity = Number(hTables.getDataAtRowProp(i, 'Quantity'));
                var currencyFactor = Number(hTables.getDataAtRowProp(i, 'CurrencyFactor'));
                var netAmt = hTables.getDataAtRowProp(i, 'NetAmount')  //precise_round((totalNetAmount * currencyFactor), 4);
                var ItemID = hTables.getDataAtRowProp(i, 'ItemID');
                debugger;
                var itemMRP = calculateItemMRP({
                    rate: rate,
                    quantity: quantity,
                    totalOrderAmount: netAmt,
                    otherCharges: extraCost,
                    markUpPercent: '',
                    subCategoryID: subCategoryID,
                    centerWiseMarkUp: centerWiseMarkUp,
                    netAmount: netAmt,
                    itemId: ItemID
                });

                hTables.setDataAtCell(i, hTables.propToCol('MRP'), itemMRP);
            }
        }

        //var calculateItemMRP = function (data) {
        //    var rate = data.rate;
        //    var quantity = data.quantity;
        //    var totalOrderAmount = data.totalOrderAmount;
        //    var otherCharges = data.otherCharges;
        //    var markUpPercent = data.markUpPercent;
        //    var netAmount = data.netAmount;

        //    if (String.isNullOrEmpty(markUpPercent)) {
        //        var filterMarkup = [];
        //        for (var j = 0; j < data.centerWiseMarkUp.length; j++) {
        //            if (data.centerWiseMarkUp[j].SubCategoryID == data.subCategoryID) {
        //                if (data.rate  <= data.centerWiseMarkUp[j].ToRate) {
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

        //  //  var itemMRP = precise_round((((((rate * quantity) / totalOrderAmount) * otherCharges)) / quantity) + (rate * markUpPercent), 4);
        //    var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);

        //    return (isNaN(itemMRP) ? 0 : itemMRP);

        //}

        var calculateItemMRP = function (data) {
            var rate = data.rate;
            var quantity = data.quantity;
            var totalOrderAmount = data.totalOrderAmount;
            var otherCharges = data.otherCharges;
            var markUpPercent = data.markUpPercent;
            var netAmount = data.netAmount;

            if (String.isNullOrEmpty(markUpPercent)) {
                var filterMarkup = [];

                

                var filterMarkup = data.centerWiseMarkUp.filter(function (i) { return i.ItemID == data.itemId && i.MarkUpType == "CentreWiseItemWise" });
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

            //if (markUpPercent <= 0) {
            //    modelAlert('Mark Up Percentage Not Found.');
            //    return 0;
            //}

            //  var itemMRP = precise_round((((((rate * quantity) / totalOrderAmount) * otherCharges)) / quantity) + (rate * markUpPercent), 4);
            var itemMRP = precise_round((netAmount + (netAmount * markUpPercent * 0.01)) / quantity, 4);

            return (isNaN(itemMRP) ? 0 : itemMRP);

        }

        var calculateDisPerAmt = function (type) {

            
            var divNewItemQuotation = $('#divNewItemQuotation');
            var rate = Number(divNewItemQuotation.find('#txtRate').val());
            var discAmt = 0;
            var disPer = 0;

            if (type == 1) {
                 discAmt = Number(divNewItemQuotation.find('#txtDiscAmt').val());
                 disPer = (discAmt * 100) / rate;
                divNewItemQuotation.find('#txtDiscountPercent').val(disPer);
            } else if (type == 2) {
                 disPer = Number(divNewItemQuotation.find('#txtDiscountPercent').val());
                 discAmt = (disPer * rate) / 100;
                 divNewItemQuotation.find('#txtDiscAmt').val(discAmt);
            }
            calculateQuotationMRP();
        }

        var calculateQuotationMRP = function () {

            if (Number('<%=Resources.Resource.IsGSTApplicable %>')== 0) {
                var divNewItemQuotation = $('#divNewItemQuotation');
                var rate = Number(divNewItemQuotation.find('#txtRate').val());

                var subCategoryID = divNewItemQuotation.find('#divQuotationFor').attr('subcategoryid');
                var quantity = 1;
                var otherCharges = 0;
                var discPer = Number(divNewItemQuotation.find('#txtDiscountPercent').val());
                var taxPer = Number(divNewItemQuotation.find('#txtVatPercent').val());

                var netAmt = rate - (rate * discPer * 0.01) + ((rate - (rate * discPer * 0.01)) * taxPer * 0.01);

                var ItemID = $.trim(divNewItemQuotation.find('#divQuotationFor').attr('itemID'));

                var itemMRP = calculateItemMRP({
                    rate: rate,
                    quantity: quantity,
                    totalOrderAmount: (rate * quantity),
                    otherCharges: otherCharges,
                    markUpPercent: '',
                    subCategoryID: subCategoryID,
                    centerWiseMarkUp: centerWiseMarkUp, //from Global Variable
                    netAmount: netAmt,
                    itemId: ItemID
                });

                divNewItemQuotation.find('#txtMRP').val(itemMRP);
            }
        }

        var onAttachDocument = function (fileInput) {
            var files = fileInput.files;
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var img = document.getElementById("spnAttachDocument");
                var reader = new FileReader();
                reader.onload = (function (d) {
                    return function (e) {
                        $(d).text(e.target.result);
                    };
                })(doc);
                reader.readAsDataURL(file);
            }
        }

        var save = function () {
            validatePurchaseOrder(function () {
                showVendorAdvanceDetails(function () { });
            });
        }


        var getSupplierAdvanceDetail = function (callback) {
            var supplierAdvanceDetails = [];
            $('#divVendorAdvanceDetails table tbody .trVendor').each(function () {
                var data = JSON.parse(($(this).find('.tdData').text()));
                var advanceAmount = Number($(this).find('input[type=text]').val());
                var paymentModeID = Number($(this).find('select').val());
                var supplierID = data.supplierID;
                supplierAdvanceDetails.push({
                    supplierID: supplierID,
                    advanceAmount: advanceAmount,
                    paymentModeID: paymentModeID
                });
            });
            callback(supplierAdvanceDetails);
        }
        //trVendorTerms
        var getSupplierAdvanceTermsDetails = function (callback) {
            var supplierAdvanceTermsDetails = [];
            $('#divVendorAdvanceDetails table tbody .trVendor ').each(function () {
                var data = JSON.parse(($(this).find('.tdData').text()));
                var supplierID = data.supplierID;
                $(this).next().find('.vendorTerms ul li').each(function () {
                    supplierAdvanceTermsDetails.push({
                        supplierID: supplierID,
                        DetailsID: $(this).attr('id'),
                        Details: $(this).find('span').text()
                    });
                });
            });
            callback(supplierAdvanceTermsDetails);
        }


        var savePurchaseOrder = function (el) {
            getPurchaseOrderDetails(function (purchaseOrderDetails) {
                getSupplierAdvanceDetail(function (supplierAdvanceDetails) {
                    getSupplierAdvanceTermsDetails(function (supplierAdvanceTermsDetails) {
                        purchaseOrderDetails.supplierAdvanceDetails = supplierAdvanceDetails;
                        purchaseOrderDetails.supplierAdvanceTermsDetails = supplierAdvanceTermsDetails;
                        serverCall('Services/CreatePO.asmx/Save', purchaseOrderDetails, function (response) {
                            var responseData = JSON.parse(response);
                            modelAlert(responseData.message, function () {
                                if (responseData.status) {
                                    $.each(responseData.purchaseOrderList, function () {
                                        var ImagesToprint = 1;
                                        // window.open('POReport.aspx?PONumber=' + this + '&ImageToPrint=' + ImagesToprint, '', '', this, 'width=' + $(window).width() + ',height=' + $(window).height());
                                    });
                                    window.location.href = 'CreatePO.aspx';
                                }
                            });
                        });
                    });
                });
            });
        }



        var draftID = "";
        var getPurchaseOrderDetails = function (callback) {
            var Freight = 0;
            if ($('#txtFreight').val() != '')
                Freight = parseFloat($('#txtFreight').val());

            var PODetails = {
                data: $.extend([], hTables.getData()),
                POAmount: parseFloat($('#txtNetAmount').val()),
                RoundOff: parseFloat($('#txtRoundOff').val()),
                FreightCharges: Freight,
                PODate: $('#txtPODate').val(),
                validDate: $('#txtValidDate').val(),
                DeliveryDate: $('#txtDeliveryDate').val(),
                POType: $('#ddlType option:selected').html(),
                Remarks: $('#txtRemarks').val(),
                StoreType: ($('input:radio[name=storeType]:checked').val()),
                purchaseOrderNumber: editPurchaseOrderNo,
                isConsolidated: Number($('input:radio[name=rdoConsolidated]:checked').val()),
                draftID: draftID,
                otherCharges: Number($('#txtExtraCost').val()),
                IsService: Number($('#ddlPurchaseOrderType').val()),
                documentBase64: $('#spnAttachDocument').text(),

            }

            PODetails.isConsolidated = (PODetails.isConsolidated == 1 ? true : false);

            var purchaseOrderType = Number($('#ddlPOType').val());

            if (purchaseOrderType != 4)
                PODetails.data.pop(PODetails.length - 1);

           
            callback(PODetails);
        }

        var getPurchaseOrderItemsByReoderLevel = function () {
            var data = {
                departmentLedgerNo: $('#ddlPODept').val(),
                centreID: centreID,
                categoryID: $("#ddlCategory option:selected").val(),
                subcategoryid: $("#ddlSubCategory option:selected").val(),
                groupId: 0,
            };
            serverCall('Services/CreatePO.asmx/GetPurchaseOrderItemsByReoderLevel', data, function (response) {
                var responseData = JSON.parse(response);
                var $container = document.getElementById('divPOContainer');
                $container.innerHTML = '';
                if (responseData.status) {
                    getGridSetting(responseData.response, function (s) {
                        s.cell = [];
                        $(s.data).each(function (i, e) { s.cell.push({ row: i, col: 1, comment: 'Min Label:' + e.MinLevel + '\nMax Label:' + e.MaxLevel + '\nRe-Order :' + e.ReorderLevel }) });
                        hTables = new Handsontable($container, s);
                        hTables.render();
                        $(hTables.getData()).each(function (i) {
                            if (!String.isNullOrEmpty(this.ItemID))
                                calculateTaxAmount(hTables, i, this.Quantity, function () { });
                        });
                    });

                }
            });



        }


        var validatePurchaseOrder = function (callback) {
            debugger;
            var purchaseOrderItems = hTables.getData();


            
var purchaseOrderType = Number($('#ddlPOType').val());

            if (purchaseOrderType == 4) {


                if (purchaseOrderItems.length == 0) {
                    modelAlert('Please Select Item.');
                    return false;
                }
            }
            else {
                if (purchaseOrderItems.length == 1) {
                    modelAlert('Please Select Item.');
                    return false;
                }

            }



            var rowCount = 0;
            var isValid = 1;
            purchaseOrderItems.filter(function (i) {
                rowCount++;
                if ((i.ItemID == undefined) && (i.Rate != undefined || i.Quantity != undefined || i.MRP != undefined || i.Discount != undefined || i.Deal != undefined || i.GSTGroup != undefined || i.TaxOn != undefined || i.Supplier != undefined || i.Free != undefined)) {
                    modelAlert('Please Select Item.<br /><b class="patientInfo"> Row : ' + rowCount + '</b>');
                    isValid = 0;
                    return false;
                }
                if ((i.ItemID != undefined) && (i.Rate == undefined || parseFloat(i.Rate) <= 0 || isNaN(Number(i.Rate)))) {
                    modelAlert('Please Enter a Valid Rate.<br /><b class="patientInfo"> Row : ' + rowCount + '</b>');
                    isValid = 0;
                    return false;
                }

                if ((i.ItemID != undefined) && (i.CurrencyFactor == undefined || parseFloat(i.CurrencyFactor) <= 0 || isNaN(Number(i.CurrencyFactor)))) {
                    modelAlert('Please Enter a Currency Factor. <br /><b class="patientInfo"> Row : ' + rowCount + '</b>');
                    isValid = 0;
                    return false;
                }

                if ((i.ItemID != undefined) && (i.Quantity == undefined || parseFloat(i.Quantity) < 1 || isNaN(Number(i.Quantity)))) {
                    modelAlert('Please Enter a Valid Quantity. <br /><b class="patientInfo"> Row : ' + rowCount + '</b>');
                    isValid = 0;
                    return false;
                }
                if ((i.ItemID != undefined) && (i.MRP == undefined || parseFloat(i.MRP) <= 0 || isNaN(Number(i.MRP)))) {
                    modelAlert('Please Enter a Valid MRP.<br /><b class="patientInfo"> Row : ' + rowCount + '</b>');
                    isValid = 0;
                    return false;
                }
                if ((i.ItemID != undefined) && (i.Discount == undefined || isNaN(parseFloat(i.Discount)))) {
                    modelAlert('Please Enter a Valid Discount. <br /><b class="patientInfo"> Row : ' + rowCount + '</b>');
                    isValid = 0;
                    return false;
                }
                if ((i.ItemID != undefined) && (i.Supplier == undefined)) {
                    modelAlert('Please Select Supplier. <br /><b class="patientInfo"> Row : ' + rowCount + '</b>');
                    isValid = 0;
                    return false;
                }
            });


            hTables.getData().filter(function (i) {
                var isDuplicate = 0;
                hTables.getData().filter(function (j) {
                    if ((i.ItemID == j.ItemID) && (i.Free == j.Free) && (i.ItemID != undefined))
                        isDuplicate++;
                });
                if (isDuplicate > 1) {
                    modelAlert('<b class="patientInfo">"' + i.ItemName + '"</b><br /> Is Duplicate in Some Rows.');
                    isValid = 0;
                    return false;
                }
            });


            if (isValid == 0)
                return false;

            if ((new Date($('#txtPODate').val()) > new Date($('#txtValidDate').val())) || (new Date($('#txtDeliveryDate').val()) > new Date($('#txtValidDate').val()))) {
                modelAlert('Valid Date cannot be less than <br /> PO Date or Delivery Date.', function () {
                    $('#txtValidDate').focus();
                });
                return false;

            }
            if (new Date($('#txtPODate').val()) > new Date($('#txtDeliveryDate').val())) {
                modelAlert('Delivert Date cannot be less than PO Date.', function () {
                    $('#txtDeliveryDate').focus();
                });
                return false;
            }

            var _txtRemarks = $('#txtRemarks');
            if (String.isNullOrEmpty(_txtRemarks.val())) {
                modelAlert('Please Enter Remarks', function () {
                    _txtRemarks.focus();
                });
                return false;
            }

            callback(true);

        }


        var searchPO = function (e, isByPONo) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (isByPONo) {
                if (code == 13)
                    getPurchaseOrders(false);

            }
            else
                getPurchaseOrders(false);

        }

        var getPurchaseOrders = function (searchType) {
            var data = {
                PONo: $.trim($('#txtPONo').val()),
                fromDate: $.trim($('#txtFromDate').val()),
                toDate: $.trim($('#txtToDate').val()),
                searchType: searchType,
                centerId: centreID,
                deptLedgerNo: departmentLedgerNo,
            }
            serverCall('Services/CreatePO.asmx/GetPOList', data, function (reponse) {
                searchPOList = JSON.parse(reponse);
                $('#divPODetails').html($('#template_POList').parseTemplate(searchPOList));
            });
        }

        var getPOPrint = function (sender) {
            var PONo = $(sender).closest('tr').find('#tdPONo').text();
            window.open('POReport.aspx?PONumber=' + PONo + '&ImageToPrint=1');
        }

        var getHistory = function () {
            var selectedRow = hTables.getSelected();
            if (selectedRow == undefined) {
                modelAlert('Please select any item row.');
                return false;
            }
            var rowIndex = selectedRow[0];
            if (hTables.getData()[rowIndex]["ItemID"] == undefined) {
                modelAlert('Please Select Any Item.');
                return false;
            }
            var ItemId = hTables.getData()[rowIndex]["ItemID"];
            serverCall('Services/CreatePO.asmx/getPurchaseHistory', { ItemId: ItemId }, function (response) {
                if (response != '') {
                    itemHistory = JSON.parse(response);
                    $('#spnHistoryItem').text(itemHistory[0]['ItemName']);
                    $('#divHistoryList').html($('#template_history').parseTemplate(itemHistory));
                    $('#divPurchaseHistory').showModel();
                    $('#spnSelectedRowIndex').text(rowIndex);
                }
                else {
                    modelAlert('No Item History Found.');
                    $('#spnSelectedRowIndex').text('');
                }
            });
        }

        var openCreateNewQuotationModel = function () {
            var divNewItemQuotation = $('#divNewItemQuotation');
            var selectedRow = hTables.getSelected();
            if (selectedRow == undefined) {
                modelAlert('Please select any item row.');
                return false;
            }
            var rowIndex = selectedRow[0];
            if (hTables.getData()[rowIndex]['ItemID'] == undefined) {
                modelAlert('Please Select Any Item.');
                return false;
            }
            var data = {};
            data.itemID = hTables.getData()[rowIndex]['ItemID'];
            data.ItemName = hTables.getData()[rowIndex]['ItemName'];
            data.MajorUnit = hTables.getData()[rowIndex]['PUnit'];
            data.SubCategoryID = hTables.getData()[rowIndex]['SubCategoryID'];
            data.ManufactureID = hTables.getData()[rowIndex]['ManufactureID'];
            data.ManuFacturer = hTables.getData()[rowIndex]['ManuFacturer'];
            data.HSNCode = hTables.getData()[rowIndex]['HSNCode'];
            data.VatType = hTables.getData()[rowIndex]['VatType'];
            data.SubCategoryID = hTables.getData()[rowIndex]['SubCategoryID'];


            divNewItemQuotation.find('input[type=text]').val('');
            divNewItemQuotation.find('select').val('0');

            divNewItemQuotation.find('#divQuotationFor').text(data.ItemName).attr('itemid', data.itemID).attr('vattype', data.VatType).attr('subcategoryid', data.SubCategoryID);
            divNewItemQuotation.find('#divManufacturer').text(data.ManuFacturer).attr('manufacturerid', data.ManufactureID);
            divNewItemQuotation.find('#lblPurchaseUnit').text(data.MajorUnit);

            $('#divNewItemQuotation').showModel();


        }

        var onQuotationSupplierChange = function (el) {
            var ItemID = $('#divQuotationFor').attr('itemID');
            var itemVatType = $('#divQuotationFor').attr('vattype');
            var seletcedVendor = el.selectedOptions[0];
            var txtVatPercent = $('#txtVatPercent');
            if (el.value == '0') {
                $(txtVatPercent).val(0);
                return false;
            }

            var vendorVatType = $(seletcedVendor).attr('vattype');
            var vendorCurrency = $(seletcedVendor).attr('currency');
            
            var data = {
                itemID: ItemID,
                vendorID: '',
                vendorVatType: vendorVatType,
                itemVatType: itemVatType,
                vendorCurrency: vendorCurrency
            }

            getCurrencyFactor(data.vendorCurrency, function (vendorCurrencyDetails) {
                $('#txtQCurrencyFactor').val(vendorCurrencyDetails.currencyFactor);
                $('#txtCurrency').val(vendorCurrencyDetails.currency).attr('currencyCountryID', vendorCurrencyDetails.currencyCountryID);
            });

            getVatTaxPercent(data, function (vatTaxDetails) {
                if (vatTaxDetails.length > 0)
                    $(txtVatPercent).val(vatTaxDetails[0].VatPercentage);
                else
                    $(txtVatPercent).val(0);
            });





        }

        var bindItemPurchaseDetails = function (sender) {
            var rowIndex = $('#spnSelectedRowIndex').text();
            hTables.setDataAtCell(rowIndex, hTables.propToCol('Rate'), $(sender).closest('tr').find('#tdRate').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('MRP'), $(sender).closest('tr').find('#tdMRP').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('Deal'), $(sender).closest('tr').find('#tdDeal').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('Discount'), $(sender).closest('tr').find('#tdDiscPer').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('GSTGroup'), $(sender).closest('tr').find('#tdGSTType').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('TaxOn'), $(sender).closest('tr').find('#tdTaxOn').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('PUnit'), $(sender).closest('tr').find('#tdPUnit').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('Supplier'), $(sender).closest('tr').find('#tdSupplier').text());
            hTables.setDataAtRowProp(rowIndex, hTables.propToCol('supplierID'), $(sender).closest('tr').find('#tdVendorId').text());
            hTables.setDataAtCell(rowIndex, hTables.propToCol('Quantity'), 0);
            $('#divPurchaseHistory').hide();
        }

        var getCurrencyFactor = function (currencyNotation, callback) {
            serverCall('../Store/Services/CommonService.asmx/getCurrencyFactor', { currencyNotation: currencyNotation }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }

    </script>

    <script id="template_POList" type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="Table1" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle">#</th>
						<th class="GridViewHeaderStyle">PO No.</th>
						<th class="GridViewHeaderStyle">Supplier</th>
						<th class="GridViewHeaderStyle">Raised Date</th>
						<th class="GridViewHeaderStyle">Type</th>
						<th class="GridViewHeaderStyle">Total Cost</th>
                        <th class="GridViewHeaderStyle">Status</th>
						<th class="GridViewHeaderStyle">Narration</th>
						<th class="GridViewHeaderStyle">Edit</th>
						</tr>
				</thead>
				   <tbody>
			<#
			 var dataLength=searchPOList.length;        
			 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = searchPOList[j];
				#>          
				<tr style="cursor:pointer" class="customRow">
					<td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Reject'){#> ondblclick="getPOPrint(this)" <#}#>class="GridViewLabItemStyle"><#= j+1 #></td>
					<td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Reject'){#> ondblclick="getPOPrint(this)" <#}#> class="GridViewLabItemStyle" id="tdPONo" ><#=objRow.PONo#></td>
					<td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Reject'){#> ondblclick="getPOPrint(this)" <#}#>  class="GridViewLabItemStyle"> <#=objRow.VendorName#></td>
					<td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Reject'){#> ondblclick="getPOPrint(this)" <#}#> class="GridViewLabItemStyle textCenter"> <#=objRow.RaisedDate#></td>
					<td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Reject'){#> ondblclick="getPOPrint(this)" <#}#> class="GridViewLabItemStyle textCenter"> <#=objRow.Type#></td>
                    <td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Reject'){#> ondblclick="getPOPrint(this)" <#}#> class="GridViewLabItemStyle textCenter"> <#=objRow.NetTotal#></td>
                    <td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Reject'){#> ondblclick="getPOPrint(this)" <#}#> class="GridViewLabItemStyle textCenter" style="font-weight:bold;
                        
                        <#if(objRow.StatusDisplay=='Close'){#>
                             color:Green
                        <#}#>

                        <#if(objRow.StatusDisplay=='Open'){#>
                             color:blue
                        <#}#>

                         <#if(objRow.StatusDisplay=='Reject'){#>
                             color:red
                        <#}#>

                        <#if(objRow.StatusDisplay=='Pending'){#>
                              color:black
                        <#}#>

                         

                        "> <#=objRow.StatusDisplay#></td>
					<td <#if(objRow.StatusDisplay!='Pending' && objRow.StatusDisplay!='Close'){#> ondblclick="getPOPrint(this)" <#}#> class="GridViewLabItemStyle"> <#=objRow.Subject#></td>
                    <td class="GridViewLabItemStyle textCenter">
                        <#if(objRow.Status==0 || objRow.Status==2){#>
                           <#if(objRow.IsStock==0){#>
                           <#if(objRow.CanEditPurchaseOrder==1){#>
                                    <img alt="X" onclick="onPurchaseOrderEdit(this);" class="btnOperation" style="cursor:pointer" src="../../Images/Post.gif"/>
                             <#}#>
                          <#}#>
                        <#}#>
                    </td>
				</tr>
                    
			   <#}#>     
					</tbody>       
		 </table>    
	</script>






    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b>Create Purchase Order</b>
        </div>
        <asp:ScriptManager ID="sm" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Purchase Order Type
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Store Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="radio" name="storeType" checked="checked" value="STO00001" class="pull-left" />
                    <span class="pull-left">Medical Store</span>
                    <input type="radio" name="storeType" value="STO00002" class="pull-left" />
                    <span class="pull-left">General Store</span>
                </div>


                <div class="col-md-3">
                    <label class="pull-left">
                        PO Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlPurchaseOrderType" onchange="">
                        <option value="0">No-Service</option>
                        <option value="1">Service</option>
                    </select>
                </div>



                
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select onchange="getSubCategorys(this.value)"  id="ddlCategory"></select>
                </div>
		<div class="col-md-3 hidden">
                    <label class="pull-left">Group</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 hidden">
                    <select id="ddlMedicineGroup"></select>

                </div>
                <div class="col-md-3">
					<label class="pull-left">SubCategory </label>
					<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					<select id="ddlSubCategory">
                        <option value="0">All</option>
					</select>
				</div>
                
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        PO Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <select onchange="onPurchaseOrderTypeChange(this)" id="ddlPOType">
                        <option value="1">PO By Item</option>
                        <option value="2">PO By Supplier</option>
                        <%--<option value="3">PO By Re-Order</option>--%>
                        <option value="4">PO By PR</option>

                    </select>
                </div>

                 <div class="col-md-2" style="padding: 0px;" >
                    <input class="purchaseOrderByPurchaseRequest" type="button" onclick="purchaseRequestModelOpen()" value="Purchase Request"    style="display:none;box-shadow:none" />
                </div>


               
                 <div class="col-md-3 purchaseOrderBySupplier" style="display:none;">
                    <label class="pull-left">
                        Supplier
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 purchaseOrderBySupplier"  style="display:none;">
                    <select id="ddlSupplier" class="requiredField">
                    </select>
                </div>
                 <div class="col-md-3" style="display:none;">
                    <label class="pull-left">
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5"  style="display:none;">
                    <select id="ddlPODept" class="requiredField">
                    </select>
                </div>

               
               <%-- <div class="col-md-3 purchaseOrderByPurchaseRequest"  style="display:none;" >
                    <label class="pull-left">
                        Create Consolidated
                    </label>
                    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-3 purchaseOrderByPurchaseRequest"  style="display:none;" >
                        <input  type="radio" name="rdoConsolidated"    value="1" class="pull-left"/>
				        <span class="pull-left">Yes</span>
				        <input  type="radio" name="rdoConsolidated"   checked="checked"  value="0"  class="pull-left"/>
				        <span class="pull-left">No</span>
                </div>--%>

              <%-- <div class="col-md-3 purchaseOrderByPurchaseRequest POByROL"  style="" >
                    <label class="pull-left">
                        Default Supplier
                    </label>
                    <b class="pull-right">:</b>
                </div>
                 <div class="col-md-5 purchaseOrderByPurchaseRequest POByROL"  style="" >
                        <input  type="radio" name="rdoDefaultSupplier" onclick="fillBestOrLastVendor()"   value="1" class="pull-left"/>
				        <span class="pull-left">Best</span>
				        <input  type="radio" name="rdoDefaultSupplier"    value="0" onclick="fillBestOrLastVendor()"  class="pull-left"/>
				        <span class="pull-left">Last</span>
                </div>--%>
                 <div class="col-md-3 hidden">
                        <label class="pull-left">
                        Other Charges
                    </label>
                    <b class="pull-right">:</b>
                 </div>

                <div class="col-md-5 hidden">
                    <input type="text" id="txtExtraCost" onchange="extraChargeChange(this)" class="ItDoseTextinputNum" />
                     
                </div>



            </div>
        </div>
                        

        <div class="POuter_Box_Inventory">
              <div style="height: 320px;overflow:auto" id="">

               <div id="divPOContainer" class="hot handsontable htRowHeaders htColumnHeaders"
                    style="height: 315px;font-size:11px;  width: 100%;" 
                   data-originalstyle="height: 320px; overflow: hidden; width: 100%;">
               </div>
              </div>

        </div>
        <div class="POuter_Box_Inventory textCenter">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Net Amount
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtNetAmount" disabled="disabled" value="0.00" />

                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Round Off
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtRoundOff" disabled="disabled" value="0.00" />
                </div>
                <div class="col-md-3" style="display:none;">
                    <label class="pull-left">
                        Freight Charges
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display:none;">
                    <input type="text" id="txtFreight" decimalplace="2" onlynumber="10" value="0.00" />
                </div>
                   <div class="col-md-3">
                    <label class="pull-left">
                        Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlType" runat="server" ClientIDMode="Static"></asp:DropDownList>

                </div>

            </div>
            <div class="row">

                <div class="col-md-3">
                    <label class="pull-left">
                        PO Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPODate" runat="server" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="calPODate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtPODate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Valid Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtValidDate" runat="server" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="calValid" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtValidDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Delivery Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDeliveryDate" runat="server" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
                    <cc1:CalendarExtender ID="calDelivery" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtDeliveryDate"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
             
                <div class="col-md-3">
                    <label class="pull-left">
                        Remarks
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-13">
                    <asp:TextBox ID="txtRemarks"  Height="29px" runat="server" CssClass="requiredField" TextMode="MultiLine" ClientIDMode="Static" MaxLength="50"></asp:TextBox>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Attach Document
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="file" onchange="onAttachDocument(this)" />
                    <span id="spnAttachDocument" class="hidden"></span>
                </div>



            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                 <div class="col-md-10" style="padding: 0px;">
                     <a href="javascript:void(0)" style="margin-right: 10px;" onclick="getDepartmentItems(function () {}, 1);">Refesh Item`s</a>
               
                     <a href="javascript:void(0)" style="margin-right: 10px;" onclick="getHistory(hTables.getSelected())">Get Item History</a>
                
                     <a href="javascript:void(0)" style="margin-right: 10px;" onclick="openCreateNewQuotationModel(hTables.getSelected())">Set Item Quotation</a>
              
                     <a href="javascript:void(0)" style="margin-right: 10px;" onclick="getItemBudget(function () {}, 1);">Get Item Budget</a>

                      
                </div>


                <div class="col-md-4 textCenter">
                    <input type="button" value="Save" id="btnSave" onclick="save();" class="save" />
                    <input type="button" id="btnCancel" value="Cancel" class="save" style="display:none"  onclick="location.href = 'CreatePO.aspx'" />
                </div>

                  <div class="col-md-2">
                     
                </div>
                
                  <div class="col-md-3">
                     
                </div>
                 

            </div>


             
             
            
        </div>
        <div class="POuter_Box_Inventory">
			<div class="Purchaseheader">
				Search PO Details
			</div>
			<div class="row">
				<div class="col-md-3">
					<label class="pull-left"> PO  No.</label>
					<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					<input type="text" placeholder="Press Enter To Search." onkeyup="searchPO(event,true);" id="txtPONo" />
				</div>
				<div class="col-md-3">
					<label class="pull-left">From Date</label>
					<b class="pull-right">:</b>
				</div>

				<div class="col-md-5">
					<asp:TextBox runat="server" ID="txtFromDate" onchange="searchPO(event,false);" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
					<cc1:CalendarExtender runat="server" ID="calExtFromDate" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
				</div>


				<div class="col-md-3">
					<label class="pull-left">To Date</label>
					<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					<asp:TextBox runat="server" ID="txtToDate" onchange="searchPO(event,false);" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
					<cc1:CalendarExtender runat="server" ID="calExtToDate" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
				</div>

			</div>

		</div>

        <div class="POuter_Box_Inventory">
			<div class="row">
				<div class="col-md-24">
					<div style="height: 230px; overflow: auto" id="divPODetails">
					</div>
				</div>
			</div>
		</div>
    </div>









    <div id="divPurchaseRequestSearch" class="modal fade" style="">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1020px">
            <div class="modal-header">
                <button type="button" class="close" onclick="purchaseRequestModelClose()" aria-hidden="true">×</button>
                <h4 class="modal-title">Purchase Request's</h4>
            </div>
            <div class="modal-body">
                <div class ="row">
                    	<div class="col-md-3">
					<label class="pull-left">From Date</label>
					<b class="pull-right">:</b>
				            </div>

                    <div class="col-md-5">
                        <asp:TextBox runat="server" onchange="searchPurchaseRequests(function(){})" ClientIDMode="Static" ID="txtFromDateSearch"></asp:TextBox>
                        <cc1:CalendarExtender ID="calExtenderFromDate" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtFromDateSearch"></cc1:CalendarExtender>
                        </div>
                    <div class="col-md-3">
					<label class="pull-left">To Date</label>
					<b class="pull-right">:</b>
				            </div>
                    <div class="col-md-5">
                        <asp:TextBox runat="server" onchange="searchPurchaseRequests(function(){})" ClientIDMode="Static" ID="txtToDateSearch"></asp:TextBox>
                          <cc1:CalendarExtender ID="calExtenderToDate" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtToDateSearch"></cc1:CalendarExtender>
                        </div>

                     <div class="col-md-3">
                    	<label class="pull-left">Request No.</label>
					<b class="pull-right">:</b>
				            </div>
                    <div class="col-md-5">
                        
                        <input type="text" />
                        </div>
                    </div>
            

                <div class="row">
                    <div class="col-md-24">
                        <div style="height:350px;overflow:auto" id="divpurchaseRequestDetails">         

                        </div>
                    </div>
                </div>
                </div>
            <div class="modal-footer">
                <button type="button" onclick="getPurchaseRequestItems(this)">Add To Purchase Request.</button>
                <button type="button" onclick="purchaseRequestModelClose()">Close</button>
            </div>
            </div>
        </div>
    </div>
    <div id="divPurchaseHistory" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1020px">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="divPurchaseHistory" aria-hidden="true">×</button>
                <h4 class="modal-title">Purchase History of <span id="spnHistoryItem" style="color:red;"></span>
                    <span id="spnSelectedRowIndex" style="display:none;"></span>
                </h4>
            </div>
            <div class="modal-body">
               <div class="row">
                    <div class="col-md-24">
                        <div style="height:350px;overflow:auto" id="divHistoryList">         

                        </div>
                    </div>
                </div>
                </div>
            <div class="modal-footer">
            </div>
            </div>
        </div>
    </div>

      <script id="template_purchaseRequests" type="text/html">
        <table  id="tablePurchaseRequests" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Purchase RequestNo</th>
            <th class="GridViewHeaderStyle" scope="col" >Subject</th>
            <th class="GridViewHeaderStyle" scope="col" >Total Item</th>
            <th class="GridViewHeaderStyle" scope="col" >Raised On</th>
            <th class="GridViewHeaderStyle" scope="col">Raised By</th>                         
            <th class="GridViewHeaderStyle" scope="col">Raised From</th>   
            <th class="GridViewHeaderStyle" scope="col">
                <input id="chkAll" onchange="toggleCheck(this,$('#tablePurchaseRequests tbody'),true)" type="checkbox" />
            </th>                                                
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=purchaseRequests.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = purchaseRequests[j];
                #>          
                
                    
                    <tr onmouseover="this.style.color='#00F'"'  onMouseOut="this.style.color=''" id="<#=j+1#>" style='cursor:pointer;'>                                                                            
                        <td onclick="getPurchaseRequestItemDetails(this)" class="GridViewLabItemStyle" id="td1"><#=j+1#></td>
                        <td onclick="getPurchaseRequestItemDetails(this)"  class="GridViewLabItemStyle" id="tdPurchaseRequestNo" style=""><#=objRow.PurchaseRequestNo#></td> 
                        <td onclick="getPurchaseRequestItemDetails(this)" class="GridViewLabItemStyle" id="td2" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.Subject#></td>
                        <td onclick="getPurchaseRequestItemDetails(this)" class="GridViewLabItemStyle textCenter" id="td4" style=""><#=objRow.Quantity#></td> 
                        <td onclick="getPurchaseRequestItemDetails(this)" class="GridViewLabItemStyle" id="td6" style=""><#=objRow.RaisedDate#></td> 
                        <td onclick="getPurchaseRequestItemDetails(this)" class="GridViewLabItemStyle" id="td5" style=""><#=objRow.Name#></td> 
                        <td onclick="getPurchaseRequestItemDetails(this)" class="GridViewLabItemStyle" id="td12" style=""><#=objRow.DepartMentName#></td>    
                        <td class="GridViewLabItemStyle" id="td7" style="text-align: center;padding-left: 1px;">
                            <input onchange="toggleCheck($('#chkAll'),$('#tablePurchaseRequests tbody'),false)" type="checkbox" />
                        </td>    
                                             
                        </tr>    
                       <tr style="display:none" class="trPurchaseRequestItemsDetail">
				         <td colspan="9"  class="GridViewLabItemStyle" >
                           <div style="max-height:308px;overflow:auto" ></div>
				         </td>
			        </tr>        

            <#}#>            
            </tbody>
         </table>    
    </script>
     <script id="template_history" type="text/html">
        <table  id="tblHistoryItem" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr>
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Supplier Name</th>
            <th class="GridViewHeaderStyle" scope="col" >GRN No</th>
            <th class="GridViewHeaderStyle" scope="col" >GRN Date</th>
            <th class="GridViewHeaderStyle" scope="col" >Rate</th>
            <th class="GridViewHeaderStyle" scope="col">Disc(%)</th>                         
            <th class="GridViewHeaderStyle" scope="col">Deal</th>
            <th class="GridViewHeaderStyle" scope="col">MRP</th>
            <th class="GridViewHeaderStyle" scope="col">Tax On</th>
            <th class="GridViewHeaderStyle" scope="col">GST Type</th>   
                                                        
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=itemHistory.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = itemHistory[j];
                #>          
                
                    
                    <tr onmouseover="this.style.color='#00F'"'  onMouseOut="this.style.color=''" id="<#=j+1#>" >                                                                            
                        <td  class="GridViewLabItemStyle" ><img src="../../Images/Post.gif" style='cursor:pointer;' onclick="bindItemPurchaseDetails(this);" /></td>
                        <td  class="GridViewLabItemStyle" id="tdSupplier" style=""><#=objRow.Supplier#></td>
                        <td  class="GridViewLabItemStyle" id="tdGRNNo" style=""><#=objRow.GRNNo#></td>
                        <td  class="GridViewLabItemStyle" id="tdGRNDate" style=""><#=objRow.GRNDate#></td>
                        <td  class="GridViewLabItemStyle" id="tdRate" style=""><#=objRow.Rate#></td>
                        <td  class="GridViewLabItemStyle" id="tdDiscPer" style=""><#=objRow.DiscPer#></td>
                        <td  class="GridViewLabItemStyle" id="tdDeal" style=""><#=objRow.isDeal#></td>
                        <td  class="GridViewLabItemStyle" id="tdMRP" style=""><#=objRow.MRP#></td>                        
                        <td  class="GridViewLabItemStyle" id="tdTaxOn" style=""><#=objRow.TaxOn#></td>
                        <td  class="GridViewLabItemStyle" id="tdGSTType" style=""><#=objRow.GSTType#></td>
                        <td  class="GridViewLabItemStyle" id="tdPUnit" style="display:none;"><#=objRow.PUnit#></td>
                        <td  class="GridViewLabItemStyle" id="tdVendorId" style="display:none;"><#=objRow.VendorId#></td>
                        </tr>    
                     
            <#}#>            
            </tbody>
         </table>    
    </script>
    <script type="text/javascript">

        var purchaseRequestModelOpen = function () {
            searchPurchaseRequests(function () {
                $('#divPurchaseRequestSearch').showModel();
            });
        }


        var searchPurchaseRequests = function (callback) {
            var data = {
                fromDate: $.trim($('#txtFromDateSearch').val()),
                toDate: $.trim($('#txtToDateSearch').val()),
                storetype: $('input:radio[name=storeType]:checked').val()
            };
            serverCall('Services/CreatePO.asmx/GetPurchaseRequests', data, function (response) {
                purchaseRequests = JSON.parse(response);
                var _parseHTML = $('#template_purchaseRequests').parseTemplate(purchaseRequests);
                callback($('#divpurchaseRequestDetails').html(_parseHTML));
            });
        }

        var purchaseRequestModelClose = function () {
            $('#divPurchaseRequestSearch').hideModel();
        }


        var toggleCheck = function (allCheckBox, parentTable, isAllCheckedChange) {
            if (isAllCheckedChange)
                $(parentTable).find('input[type=checkbox]').prop('checked', $(allCheckBox).prop('checked'));
            else {
                var status = (($(parentTable).find('input[type=checkbox]').length == $(parentTable).find('input[type=checkbox]:checked').length) ? true : false);
                $(allCheckBox).prop('checked', status);
            }
        }


        var getSelectedPurchaseRequests = function (callback) {
            var selectedPurchaseRequests = [];
            $('#tablePurchaseRequests tbody tr td input[type=checkbox]:checked').closest('tr').find('#tdPurchaseRequestNo').each(function () {
                selectedPurchaseRequests.push(this.innerHTML);
            });
            callback(selectedPurchaseRequests);
        }



        var getPurchaseRequestItems = function (elem) {
            getSelectedPurchaseRequests(function (selectedPurchaseRequests) {
                var data = {
                    purchaseRequests: selectedPurchaseRequests,
                    departmentLedgerNo: departmentLedgerNo,
                    centreID: centreID
                };
                serverCall('Services/CreatePO.asmx/GetPurchaseRequestItems', data, function (response) {
                    var responseData = JSON.parse(response);
                    bindPRItemsForPurchaseOrder(responseData);

                    if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                    var nonQuotationItems = responseData.filter(function (i) {
                        if (Number(i.supplierID) == 0)
                            return i;
                    });

                    var quotationItems = responseData.filter(function (i) { return i.supplierID != '0' });

                    
                        var extraCost = 0;
                        for (var i = 0; i < quotationItems.length; i++) {
                            var data = {
                                Rate: quotationItems[i].Rate,
                                ActualRate: quotationItems[i].Rate,
                                MRP: quotationItems[i].MRP,
                                deal: 0,
                                deal2: 0,
                                DiscPer: quotationItems[i].DiscountPercent,
                                Type: quotationItems[i].TaxCalulatedOn,
                                Quantity: quotationItems[i].RequestedQty,
                                TaxPer: quotationItems[i].TotalTaxPercent
                            };

                            getTaxAmount(data, 0, function (response) {
                                var responseData = response;
                                quotationItems[i].netAmountWithOutTax = responseData.netAmountWithOutTax;
                                quotationItems[i].TaxAmt = responseData.taxAmount;
                                quotationItems[i].NetAmount = responseData.netAmount;


                                if ('<%=Resources.Resource.IsGSTApplicable%>' == '0') {
                                    var itemMRP = calculateItemMRP({
                                        rate: data.Rate,
                                        quantity: data.Quantity,
                                        totalOrderAmount: responseData.netAmount,
                                        otherCharges: extraCost,
                                        markUpPercent: '',
                                        subCategoryID: quotationItems[i].SubCategoryID,
                                        centerWiseMarkUp: centerWiseMarkUp,
                                        netAmount: responseData.netAmount,
                                        itemId: quotationItems[i].ItemID
                                    });
                                    quotationItems[i].MRP = itemMRP;
                                }
                                else if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {

                                    quotationItems[i].IGSTAmt = responseData.igstTaxAmount;
                                    quotationItems[i].CGSTAmt = responseData.cgstTaxAmount;
                                    quotationItems[i].SGSTAmt = responseData.sgstTaxAmount;
                                }
                            });
                        }


                        bindPRItemsForPurchaseOrder(quotationItems);
                    }


                    //if (nonQuotationItems.length < 1)
                    //    bindPRItemsForPurchaseOrder(responseData);
                    //else {
                    //    modelAlert('Quotation Not Found.', function () {
                    //        var message = '<p class="patientInfo">Create Quotation For:-</p>';
                    //        for (var i = 0; i < nonQuotationItems.length; i++) {
                    //            message += nonQuotationItems[i].ItemName + '</br>';
                    //        }
                    //        modelAlert(message);
                    //    });
                    //}
                });
            });
        }

        var bindPRItemsForPurchaseOrder = function (data) {
            var $container = document.getElementById('divPOContainer');
            $container.innerHTML = '';
            getGridSetting(data, function (s) {
                hTables = new Handsontable($container, s);
                hTables.render();
                purchaseRequestModelClose();
               
                if ('<%=Resources.Resource.IsGSTApplicable%>' == '1') {
                    $(hTables.getData()).each(function (i) {
                        if (!String.isNullOrEmpty(this.ItemID))
                            calculateTaxAmount(hTables, i, this.Quantity, function () { });
                    });
                }
                updateAmounts();
            });
        }


        var getPurchaseRequestItemDetails = function (elem) {
            var row = $(elem).closest('tr');
            var requestNo = $.trim(row.find('#tdPurchaseRequestNo').text());
            var data = { purchaseRequestNo: requestNo };
            serverCall('Services/CreatePO.asmx/GetPurchaseRequestItemDetails', data, function (response) {
                var responseData = JSON.parse(response);
                bindPurchaseRequestItemDetails(elem, responseData);
            });

        }


        var bindPurchaseRequestItemDetails = function (elem, data) {
            var selectedRow = $(elem).closest('tr');
            var isAlreadySelected = selectedRow.hasClass('selectedRow');
            $(elem).closest('tbody').find('tr').removeClass('selectedRow').hide();
            if (!isAlreadySelected) {
                $('.trPurchaseRequestItemsDetail').hide().find('td').find('div').html('');
                requistionItemsDetail = data;
                selectedRow.addClass('selectedRow').show().next('.trPurchaseRequestItemsDetail')
					.show().find('td').find('div').html($('#template_requistionItemsDetail').parseTemplate(requistionItemsDetail)).customFixedHeader();
            }
            else {
                $(elem).closest('tbody').find('tr').removeClass('selectedRow').show();
                $('.trPurchaseRequestItemsDetail').hide().find('td').find('div').html('');
            }
        }



        var onPurchaseOrderEdit = function (elem) {
            var purchaseOrderNo = $(elem).closest('tr').find('#tdPONo').text();
            location.href = 'CreatePO.aspx?purchaseOrderNo=' + purchaseOrderNo;
        }

        var getPurchaseOrderItemDetails = function (data, callback) {
            serverCall('Services/CreatePO.asmx/GetPurchaseOrderItemDetails', data, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });

        }

        var bindPurchaseOrderForEdit = function (purchaseOrderNo) {
            getPurchaseOrderItemDetails({ purchaseOrderNo: purchaseOrderNo, centreID: centreID, departmentLedgerNo: departmentLedgerNo }, function (d) {
                getGridSetting(d, function (s) {

                    debugger;

                    var isPurchaseOrderUsingPurchaseRequest = false;

                    if (d[0].isPOByPR > 0)
                        isPurchaseOrderUsingPurchaseRequest = true;




                    if (isPurchaseOrderUsingPurchaseRequest) {
                        s.minSpareRows = 0;
                        s.columns[0].readOnly = true;
                    }

                    var $container = document.getElementById('divPOContainer');
                    $container.innerHTML = '';
                    hTables = new Handsontable($container, s);
                    hTables.render();
                    if (d.length > 0) {

                        $('#txtNetAmount').val(d[0].NetTotal);
                        $('#txtRoundOff').val(d[0].Roundoff);
                        $('#txtRemarks').val(d[0].Remarks);
                        editPurchaseOrderNoVendorID = Number(d[0].VendorID);
                        $('input[type=radio][name=storeType]').prop('disabled', true);

                        $('#ddlPurchaseOrderType').prop('disabled', true);

                        if (isPurchaseOrderUsingPurchaseRequest)
                            $('#ddlPOType').val(4).prop('disabled', true);
                        else
                            $('#ddlPOType').prop('disabled', true);





                        $('#ddlCurrency').val(d[0].S_CountryID);
                        $('#txtCurrencyFactor').val(d[0].C_Factor);
                        $('#btnSave').val('Update');
                        $('#btnCancel').show()
                    }
                });
            });
        }




        var getItemBudget = function () {
            var itemDetails = $.merge([], hTables.getData());
            itemDetails.pop(itemDetails.length);
            var data = [];
            for (var i = 0; i < itemDetails.length; i++) {
                data.push({
                    itemID: itemDetails[i].ItemID,
                    amount: 0
                });
            }
            serverCall('Services/CreatePO.asmx/GetItemBudget', { budgetDetails: data }, function (res) {
                var responseData = JSON.parse(res);

                for (var i = 0; i < itemDetails.length; i++) {
                    var budget = responseData.filter(function (j) { return j.itemID == itemDetails[i].ItemID });
                    if (budget.length > 0)
                        hTables.setDataAtCell(i, hTables.propToCol('Budget'), budget[0].amount);

                }
            });
        }



    </script>


    <script id="template_requistionItemsDetail" type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="Table2" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle">#</th>
						<th class="GridViewHeaderStyle">Item Name</th>
						<th class="GridViewHeaderStyle">Requested</th>
						<th class="GridViewHeaderStyle">Approved</th>
						<th class="GridViewHeaderStyle">Unit</th>
<th class="GridViewHeaderStyle">PO Number</th>
                        <th class="GridViewHeaderStyle">Remarks</th>
						</tr>
				</thead>
				   <tbody>
			<#
			 var dataLength=requistionItemsDetail.length;        
			 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = requistionItemsDetail[j];
				#>          
				<tr>
					<td class="GridViewLabItemStyle"><#= j+1 #></td>
					<td class="GridViewLabItemStyle" id="td3" > <#=objRow.ItemName#></td>
					<td class="GridViewLabItemStyle textCenter"><#=objRow.RequestedQty#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=objRow.ApprovedQty#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=objRow.Unit#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=objRow.Purpose#></td>
<td class="GridViewLabItemStyle textCenter"> <#=objRow.PONumber#></td>
				</tr>
			   <#}#>     
					</tbody>       
		 </table>    
	</script>


    <script type="text/javascript">

        var fillBestOrLastVendor = function () {
            var data = hTables.getData();
            var itemIDs = $.map(data, function (i) { return i.ItemID; });
            var data = {
                itemIDs: itemIDs,
                vendorType: Number($('input[type=radio][name=rdoDefaultSupplier]:checked').val())
            };
            serverCall('Services/CreatePO.asmx/GetBestLastVendor', data, function (response) {
                var responseData = JSON.parse(response);
                var data = hTables.getData();

                for (var i = 0; i < data.length; i++) {
                    var itemID = hTables.getDataAtRowProp(i, 'ItemID');
                    var vendor = responseData.filter(function (i) { return i.ItemID == itemID });
                    if (vendor.length > 0) {
                        hTables.setDataAtCell(i, hTables.propToCol('Supplier'), vendor[0].VendorName);
                        hTables.setDataAtRowProp(i, hTables.propToCol('supplierID'), vendor[0].VendorID);
                        hTables.setDataAtCell(i, hTables.propToCol('Rate'), vendor[0].Rate);
                    }
                }
            });
        }





        var showVendorAdvanceDetails = function (callback) {

            var itemDetails = $.merge([], hTables.getData());
           // itemDetails.pop(itemDetails.length);

 var purchaseOrderType = Number($('#ddlPOType').val());

            if (purchaseOrderType != 4)
                itemDetails.pop(itemDetails.length - 1);

            var distinctVendors = [];
            for (var i = 0; i < itemDetails.length; i++) {

                var isExits = distinctVendors.filter(function (v) {
                    return v.supplierID == itemDetails[i].supplierID;
                });
                if (isExits.length == 0) {
                    if (itemDetails[i].supplierID != "0") {
                    distinctVendors.push(
                        {
                            supplierID: itemDetails[i].supplierID,
                            supplier: itemDetails[i].Supplier,
                            advanceAmount: itemDetails[i].AdvanceAmount,
                            currency: itemDetails[i].Currency
                        });
                    }
                }
            }

            responseData = distinctVendors;
            var parseHTML = $('#templateVendorAdvance').parseTemplate(responseData);
            var divVendorAdvanceDetails = $('#divVendorAdvanceDetails').html(parseHTML);

            getTermsAndConditions(function (data) {

                divVendorAdvanceDetails.find('#ddlTerms').bindDropDown({
                    data: data,
                    valueField: 'Id',
                    textField: 'Terms',
                    defaultValue: 'Select',
                    //isSearchable: true
                });

                $('#divVendorSummaryAndAdvance').showModel();
                callback();
            });
            serverCall('Services/CreatePO.asmx/GetPurchaseOrderItemDetailsTerms', { purchaseOrderNo: editPurchaseOrderNo }, function (response) {
                var responseData = JSON.parse(response);
                for (var i = 0; i < responseData.length; i++) {
                    var data = {
                        value: responseData[i].DetailsID,
                        text: responseData[i].Details
                    };
                    var vendorTermsParentDiv = $('#divVendorAdvanceDetails table tbody tr .vendorTerms')
                    bindVendorTermsAndCondition(vendorTermsParentDiv, data, function () {
                    });
                }
            });
        }


        var onVendorTermConditionChange = function (el) {

            if (el.value == '0')
                return false;

            var data = {
                value: el.value,
                text: $(el.selectedOptions).text()
            };
            var vendorTermsParentDiv = $(el).closest('tr').next().find('.vendorTerms')
            bindVendorTermsAndCondition(vendorTermsParentDiv, data, function () {

            });

        }









        var bindVendorTermsAndCondition = function (vendorTermsParentDiv, data, callback) {



            var isAlreadyExits = vendorTermsParentDiv.find('#' + data.value);
            if (isAlreadyExits.length > 0) {
                modelAlert('Term & Condition Already Seleted.');
                return false;
            }
            vendorTermsParentDiv.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a></li>');
            //  callback(doctorList);
        }
    </script>

    <script type="text/javascript" id="scriptQuotation">

        var getNewQuotationDetails = function (callback) {

            var ID = $('#ddlGSTGroup').val();
            var filterGST = taxGroups.filter(function (i) { return i.id == ID });

            var divNewItemQuotation = $('#divNewItemQuotation');


            var rate = Number(divNewItemQuotation.find('#txtRate').val()) / Number(divNewItemQuotation.find('#txtQCurrencyFactor').val());
            var discAmt= Number(divNewItemQuotation.find('#txtDiscAmt').val()) / Number(divNewItemQuotation.find('#txtQCurrencyFactor').val());
            var taxPer= Number(divNewItemQuotation.find('#txtVatPercent').val());
            var taxAmt =(rate - discAmt) * taxPer * 0.01;
            var netAmount = rate - discAmt + taxAmt;

            var data = {
                ItemId: $.trim(divNewItemQuotation.find('#divQuotationFor').attr('itemID')),
                fromDate: $.trim(divNewItemQuotation.find('#txtQuotationFromDate').val()),
                toDate: $.trim(divNewItemQuotation.find('#txtQuotationToDate').val()),
                subcategoryID: $.trim(divNewItemQuotation.find('#divQuotationFor').attr('subcategoryid')),
                vendorID: $.trim(divNewItemQuotation.find('#ddlQuotationSupplier').val()),
                vendorName: $.trim(divNewItemQuotation.find('#ddlQuotationSupplier option:selected').text()),
                ItemName: $.trim(divNewItemQuotation.find('#divQuotationFor').text()),
                unit: $.trim(divNewItemQuotation.find('#lblPurchaseUnit').text()),
                rate: rate,
                taxGroupID: $('#ddlGSTGroup').val(),
                taxGroupName: $.trim($('#ddlGSTGroup option:selected').text()),
                discountPercent: Number(divNewItemQuotation.find('#txtDiscountPercent').val()),
                discountAmount: discAmt,
                deal1: Number(divNewItemQuotation.find('#txtDeal1').val()),
                deal2: Number(divNewItemQuotation.find('#txtDeal2').val()),
                taxCalculatedOn: $.trim(divNewItemQuotation.find('#ddlTaxCalculatedOn').val()),
                IsActive: (divNewItemQuotation.find('input[type=radio][name=isActive]:checked').val()),
                MRP: Number(divNewItemQuotation.find('#txtMRP').val()) / Number(divNewItemQuotation.find('#txtQCurrencyFactor').val()),
                HSNCode: $.trim(divNewItemQuotation.find('#txtHSNCode').val()),
                remarks: $.trim(divNewItemQuotation.find('#txtRemarks').val()),
                manufacturerID: $.trim(divNewItemQuotation.find('#divManufacturer').attr('manufacturerID')),
                manufacturer: $.trim(divNewItemQuotation.find('#divManufacturer').text()),
                categoryID: '',
                totalTaxPercent: taxPer,
                taxAmount: taxAmt,
                currencyNotation: $.trim(divNewItemQuotation.find('#txtCurrency').val()),
                currencyFactor: $.trim(divNewItemQuotation.find('#txtQCurrencyFactor').val()),
                currencyCountryID: $.trim(divNewItemQuotation.find('#txtCurrency').attr('currencyCountryID')),
                minimum_Tolerance_Qty: Number($('#txtMaxQty').val()),
                maximum_Tolerance_Qty: Number($('#txtMaxQty').val()),
                minimum_Tolerance_Rate: Number($('#txtMinRate').val()),
                maximum_Tolerance_Rate: Number($('#txtMaxRate').val()),
                GSTType: filterGST[0].TaxGroup.toUpperCase(),
                IGSTPercent: filterGST[0].IGSTPer,
                CGSTPercent: filterGST[0].CGSTPer,
                SGSTPercent: Number(filterGST[0].SGSTPer) + Number(filterGST[0].UTGSTPer),
                netAmount: netAmount,
                profit: Number(divNewItemQuotation.find('#txtMRP').val()) / Number(divNewItemQuotation.find('#txtQCurrencyFactor').val()) - netAmount
            }

           

            if (String.isNullOrEmpty(data.fromDate)) {
                modelAlert('Please Select From Date.', function () {
                    $('#txtQuotationFromDate').focus();
                });
                return false;
            }


            if (String.isNullOrEmpty(data.toDate)) {
                modelAlert('Please Select To Date.', function () {
                    $('#txtQuotationToDate').focus();
                });
                return false;
            }

            if (data.rate <= 0) {
                modelAlert('Please Enter Rate.', function () {
                    $('#txtRate').focus();
                });
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


            if (data.vendorID == '0') {
                modelAlert('Please Select Vendor.', function () {

                });
                return false;
            }

            if (data.CurrencyFactor == "" || data.Currency == "0") {
                modelAlert('Please Enter Currency Factor', function () {
                    $('#txtQCurrencyFactor').focus();
                });
                return false;
            }
            callback(data);

        }



        var saveNewQuotation = function (el) {
            getNewQuotationDetails(function (response) {
                serverCall('QuotationAndCompare.aspx/SaveQuotation', { quotationList: [response] }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        if (responseData.status) {
                            $('#divNewItemQuotation').closeModel();
                        }
                    });
                });
            });
        }



    </script>


    <div id="divNewItemQuotation" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="width:1250px;">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="divNewItemQuotation" aria-hidden="true">×</button>
				<h4 class="modal-title">Items Pricing Detail</h4>
			</div>
		
			<div class="modal-body">
				<div style="height:160px" class="row">
					<div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Quotation For</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 patientInfo">
                                    <span class="clearText" id="divQuotationFor" itemid=""></span>
                                </div>

                                <div class="col-md-3">
                                    <label class="pull-left">Supplier From</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 patientInfo">
                                    <select id="ddlQuotationSupplier" class="required" onchange="onQuotationSupplierChange(this)"></select>
                                </div>

                                <div class="col-md-3">
                                    <label class="pull-left">Manufacturer</label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 patientInfo">
                                    <span class="clearText" id="divManufacturer" manufacturerid="0"></span>
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
                                    <asp:TextBox runat="server" ID="txtQuotationFromDate" ClientIDMode="Static" class="required" ></asp:TextBox>
                                    <cc1:CalendarExtender runat="server" ID="CalendarExtender1" Format="dd-MMM-yyyy" TargetControlID="txtQuotationFromDate"></cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        To Date
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox runat="server" ID="txtQuotationToDate" ClientIDMode="Static" class="required"></asp:TextBox>
                                    <cc1:CalendarExtender runat="server" ID="CalendarExtender2" Format="dd-MMM-yyyy" TargetControlID="txtQuotationToDate"></cc1:CalendarExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Currrency
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-2 patientInfo">
                                    <input type="text" id="txtCurrency" class="clearText" disabled="disabled"/>
                                </div>
                                 <div class="col-md-3 patientInfo">
                                     <input type="text" id="txtQCurrencyFactor" />
                                 </div>


                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        MRP
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input  id="txtMRP" <%if (Resources.Resource.IsGSTApplicable == "0")
                                                          { %>  disabled="disabled" class="ItDoseTextinputNum " <%}
                                                          else
                                                          { %> class="ItDoseTextinputNum requiredField" <%} %> value="0.00" onlynumber="7" decimalplace="4" max-value="1000000" type="text"/>
                                </div>

                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Rate
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input class="ItDoseTextinputNum requiredField" id="txtRate" type="text"  value="0.00" onlynumber="7" decimalplace="4" max-value="1000000"   onchange="calculateQuotationMRP()" />
                                </div>


                                <div class="col-md-3">
                                    <label class="pull-left">
                                        HSN Code 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" id="txtHSNCode"/>
                                </div>
                            </div>
                            <div class="row">
                               <%-- <div class="col-md-3">
                                    <label class="pull-left">
                                        GST Group
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlGSTGroup" >
                        
                                    </select>
                                </div>--%>

                                 <div class="col-md-3">
                                    <label class="pull-left">
                                        <%if (Resources.Resource.IsGSTApplicable == "0")
                                          { %>
                                            Vat
                                        <%}
                                          else
                                          { %>
                                        GST Group
                                        <%} %>
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                       <input type="text" id="txtVatPercent" class="ItDoseTextinputNum required" <%if (Resources.Resource.IsGSTApplicable == "1")
                                                                                                                   { %> style="display:none" <%}%> />

                                    <select id="ddlGSTGroup" onchange="bindGSTPer();" <%if (Resources.Resource.IsGSTApplicable == "0")
                                                                                        { %> style="display:none" <%}%> > </select>
                                </div>

                                  <div class="col-md-3">
                                    <label class="pull-left">
                                        Tax  On
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlTaxCalculatedOn"></select>
                                </div>

                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Is Deal
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-2">
                                    <input type="text" class="ItDoseTextinputNum" id="txtDeal1"/>
                                </div>
                                <div class="col-md-1 textCenter">
                                    <b class="patientInfo">+ </b>
                                </div>
                                <div class="col-md-2">
                                    <input type="text" class="ItDoseTextinputNum" id="txtDeal2"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Dis. Amount
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" class="ItDoseTextinputNum" id="txtDiscAmt" onlynumber="7" onchange="calculateDisPerAmt(1)" decimalplace="4" max-value="1000000" />
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Dis. Percent
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" class="ItDoseTextinputNum" id="txtDiscountPercent" onchange="calculateDisPerAmt(2)" onlynumber="7" decimalplace="4" max-value="100"/>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Remarks
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" id="txtQuatationRemarks"/>
                                </div>
                            </div>

                              <div class="row" style="display:none;">
                                   <div class="col-md-3">
                                    <label class="pull-left">
                                        Max Tolerance  Qty
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                      <input type="text" id="txtMaxQty" onlynumber="10" decimalplace="4" />
                                </div>
                                    <div class="col-md-3">
                                    <label class="pull-left">
                                        Min Tolerance  Qty
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                      <input type="text" id="txtMinQty" onlynumber="10" decimalplace="4" />
                                </div>

                                  <div class="col-md-3">
                                    <label class="pull-left">
                                        Max Tolerance  Rate
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" id="txtMaxRate" onlynumber="10" decimalplace="4" />
                                </div>

                              </div>
                     

                            <div class="row">
                              
                                <div class="col-md-3" style="display:none;">
                                    <label class="pull-left">
                                        Min Tolerance  Rate
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5" style="display:none;">
                                    <input type="text" id="txtMinRate"  onlynumber="10" decimalplace="4" />
                                </div>
                                 <%if (Resources.Resource.IsGSTApplicable == "1")
                                   { %> 
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Note
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <span id="spnGSTDetails" class="patientInfo"></span>
                                </div>
                                 <%}%> 
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Set As Default 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <input id="Radio1" type="radio" name="isActive" checked="checked" value="1" class="pull-left"/>
                                    <span class="pull-left">Yes</span>
                                    <input id="Radio2" type="radio" name="isActive" value="0" class="pull-left"/>
                                    <span class="pull-left">No</span>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Purchase Unit
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5 patientInfo">
                                    <span class="clearText" id="lblPurchaseUnit" ></span>
                                </div>
                            </div>
				</div>
			</div>
			<div class="modal-footer">
				 <button type="button" class="save"  onclick="saveNewQuotation(this)" >Save</button>
				 <button type="button" class="save" data-dismiss="divNewItemQuotation">Close</button>
			</div>
		</div>
	</div>
   </div>
   

    <div id="divVendorSummaryAndAdvance" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" >
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="divVendorSummaryAndAdvance" aria-hidden="true">×</button>
				<h4 class="modal-title">Supplier Advance</h4>
			</div>
		
			<div class="modal-body" style="width:1024px;height:350px;overflow:auto">
				<div  class="row" id="divVendorAdvanceDetails">
					   
				</div>
			</div>
			<div class="modal-footer">
				 <button type="button" class="save"  onclick="savePurchaseOrder(this)" >Save</button>
				 <button type="button" class="save" data-dismiss="divVendorSummaryAndAdvance">Close</button>
			</div>
		</div>
	</div>
   </div>




    <script id="templateVendorAdvance" type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="Table3" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle">#</th>
						<th class="GridViewHeaderStyle">Supplier</th>
                        <th class="GridViewHeaderStyle" style="width: 80px;">Currency</th>
                        <th class="GridViewHeaderStyle" style="width: 120px;">Payment Mode</th>
						<th class="GridViewHeaderStyle" style="width: 125px;">Advance Amount</th>	
                        <th class="GridViewHeaderStyle" style="width: 305px;">Terms & Condition </th>
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
				<tr class="trVendor">
					<td class="GridViewLabItemStyle"><#= j+1 #></td>
					<td class="GridViewLabItemStyle" id="td8" > <#=objRow.supplier#></td>
                    <td class="GridViewLabItemStyle textCenter" id="td9" > <#=objRow.currency#></td>
                    <td class="GridViewLabItemStyle textCenter" id="td10" > 
                        <select id="ddlPaymentType">
                            <option value="4">Credit</option>
                            <option value="1">Cash</option>
                        </select>
                    </td>
                    <td class="GridViewLabItemStyle tdData hidden"> <#= JSON.stringify(objRow) #></td>
					<td class="GridViewLabItemStyle textCenter">
                        <input type="text" value='<#=objRow.advanceAmount#>' onlynumber="10"  max-value="9999999999" autocomplete="off" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)"    class="ItDoseTextinputNum"   />
					</td>

                    <td class="GridViewLabItemStyle textCenter">

                        <select id="ddlTerms" onchange="onVendorTermConditionChange(this)">
                            
                        </select>
                       

                    </td>

				</tr>
                    <tr class="trVendorTerms">
                         <td class="GridViewLabItemStyle" colspan="6">
                             <div class="col-md-2">
                                 <label class="pull-left bold patientInfo"> Terms</label>
			                     <b class="pull-right bold patientInfo">:</b>
                             </div>
                                <div class="chosen-container-multi col-md-22 vendorTerms">
                                     <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices"></ul>
                                </div>  
                         </td>
                    </tr>
			   <#}#>     
					</tbody>       
		 </table>    
	</script>


</asp:Content>

