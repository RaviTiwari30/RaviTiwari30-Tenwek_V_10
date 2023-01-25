<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateIndent.aspx.cs" Inherits="Design_Store_CreateIndent" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />
    <style type="text/css">
        .htDimmed {
            background-color: #a1f6ec;
            color: #0e0e0e !important;
        }

        .listbox:only-child .htDimmed {
            background-color: white !important;
        }

        .ht_clone_top {
            z-index: 0 !important;
        }

        .ht_clone_left {
            z-index: 0 !important;
        }

        .handsomeTableCustomize {
            font-size: 12px !important;
        }
    </style>
    <script type="text/javascript">

        $(document).ready(function () {
            var storeID = $.trim($('#ddlStoreType option:selected').val());
            getCategorys(storeID, function () { });
            getMedicineGroup(function () { });
            getCentre(function () {
                getDepartMent(function () { });
            });

        });

        function GetSubCatgryOnLoad() {
            var categoryID = $("#ddlCategory option:selected").val();
            serverCall('Services/CommonService.asmx/GetSubCategoryByCategory', { categoryID: categoryID }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSubCategory').bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });

                getItems(function () {

                }, categoryID);
            });
        }

        //*****Global Variables*******
        var hTables = {};
        var matching = [];
        var items = [];
        var selectedPendingIndentItems = [];
        var centreID = '<%=ViewState["centerID"].ToString()%>';
        var departmentLedgerNo = '<%=ViewState["deptLedgerNo"].ToString()%>';
        var userID = '<%=ViewState["userID"].ToString()%>';
        var hospitalID = '<%=ViewState["HOSPID"].ToString()%>';
        var editPurchaseRequestNo = '<%=ViewState["PurchaseRequestNo"].ToString()%>';

        //****************************

        var getMedicineGroup = function (callback) {
            serverCall('Services/CommonService.asmx/GetMedicineGroup', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlMedicineGroup').bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'ItemGroup', defaultValue: 'All', isSearchAble: true }));
            });
        }

        var getCategorys = function (storeID, callback) {
            serverCall('Services/CommonService.asmx/GetCategorysByStoreType', { storeID: storeID }, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlCategory').bindDropDown({ data: JSON.parse(response), valueField: 'CategoryID', textField: 'Name', isSearchAble: true }));
                GetSubCatgryOnLoad();
            });

        }

        var getSubCategorys = function (categoryID, callback) {
            serverCall('Services/CommonService.asmx/GetSubCategoryByCategory', { categoryID: categoryID }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSubCategory').bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true });

                callback(responseData);
                //getItems(function () {

                //}, categoryID);
            });
        }


        var getCentre = function (callback) {
            var EmployeeID = '<%=Session["ID"].ToString()%>';
            serverCall('Services/CommonService.asmx/BindCenter', { EmployeeID: EmployeeID }, function (response) {
                var responseData = JSON.parse(response);
                var _ddlCentre = $('#ddlCenterTo');
                _ddlCentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', selectedValue: centreID, isSearchAble: true });
                callback(_ddlCentre.val());
            });
        }


        var getDepartMent = function (callback) {
            serverCall('CreateIndent.aspx/BindDepartment', { CentreID: $('#ddlCenterTo').val(), storetype: $.trim($('#ddlStoreType').val()) }, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlDepartmentTo').bindDropDown({ defaultValue: 'Select', data: responseData.response, valueField: 'LedgerNumber', textField: 'LedgerName', isSearchAble: true }));
            });
        }


        $(document).ready(function () {
            initCreatePurchaseRequest();
        });

        var initCreatePurchaseRequest = function () {
            getGridSetting(function (s) {
                configureTable(s);
                getItems(function () {
                    if (!String.isNullOrEmpty(editPurchaseRequestNo))
                        getPurchaseRequestItemDetails(editPurchaseRequestNo)

                }, 1);
                getPurchaseRequest(true);
            });
        }



        var onStoreTypeChange = function () {

            var storeID = $.trim($('#ddlStoreType option:selected').val());
            getCentre(function () {
                getDepartMent(function () {
                    getCategorys(storeID, function () {
                        initCreatePurchaseRequest();
                    });
                });
            });
           


        }


        var onCategoryChange = function (categoryId) {
            getSubCategorys(categoryId, function () {
                initCreatePurchaseRequest();
            });
        }


        var configureTable = function (s) {
            var $container = document.getElementById('divPurchaseRequestItems');
            $container.innerHTML = '';
            hTables = new Handsontable($container, s);
            hTables.render();
            hTables.addHook('beforeChange', function (changes, source) {


                if (source === 'loadData' || source === 'internal' || changes.length > 1)
                    return;

                var row = changes[0][0];
                var prop = changes[0][1];
                var value = $.trim(changes[0][3]);
                var issueDetails = this.getData();
                var h = this;
                var quantityTypes = ['Quantity'];
                if (prop === 'ItemName') {
                    matching = matching.filter(function (i) { if ($.trim(i.ItemName) == $.trim(value)) { return i; } }); //global Variable
                    var selectedData = matching[0];
                    if (matching.length < 1) {
                        //selectedData.SubCategoryID = ''; 
                        //selectedData.MajorUnit = '';
                        //selectedData.ItemID = '0';
                        return false;
                    }
                    getItemStockDetails(selectedData.ItemID, function (itemDetails) {
                        h.setDataAtCell(row, h.propToCol('Minlevel'), 0);
                        h.setDataAtCell(row, h.propToCol('Maxlevel'), 0);
                        //h.setDataAtCell(row, h.propToCol('Narration'), '');
                        h.setDataAtRowProp(row, h.propToCol('ItemID'), selectedData.ItemID);
                        h.setDataAtCell(row, h.propToCol('Quantity'), 0);
                        h.setDataAtRowProp(row, h.propToCol('SubCategoryID'), selectedData.SubCategoryID);
                        h.setDataAtCell(row, h.propToCol('PurchaseUnit'), selectedData.MinorUnit);
                        if (itemDetails.length > 0) {
                            h.setDataAtCell(row, h.propToCol('CurrentStock'), itemDetails[0].CurrentStock);
                            h.setDataAtCell(row, h.propToCol('DeptStock'), itemDetails[0].DeptStock);
                            h.setDataAtCell(row, h.propToCol('SalesQuantity'), itemDetails[0].SalesQuantity);
                            h.setDataAtCell(row, h.propToCol('PendingQty'), itemDetails[0].PendingQty);
                        }
                        else {
                            h.setDataAtCell(row, h.propToCol('CurrentStock'), 0);
                            h.setDataAtCell(row, h.propToCol('DeptStock'), 0);
                            h.setDataAtCell(row, h.propToCol('SalesQuantity'), 0);
                            h.setDataAtCell(row, h.propToCol('PendingQty'), 0);
                        }

                        h.setDataAtRowProp(row, h.propToCol('ID'), 0);
                    });
                }
                else if (quantityTypes.indexOf(prop) > -1) {
                    var totalQuantity = 0;
                    for (var i = 0; i < quantityTypes.length; i++) {
                        if (quantityTypes[i] != prop)
                            totalQuantity = totalQuantity + Number(h.getDataAtRowProp(row, quantityTypes[i]));
                    }

                    h.setDataAtCell(row, h.propToCol('NetQuantity'), (totalQuantity + Number(value)));
                }
                this.render();
            });

        }

        var getGridSetting = function (callback) {
            if (typeof (hTables.destroy) == 'function')
                hTables.destroy();



            var quantityFormat = '0';
            var storeType = $('#ddlStoreType').val();
            if (storeType == 'STO00002')
                quantityFormat = '0.0000';


            var s = {
                data: [],
                minSpareRows: 1,
                rowHeaders: true,
                filters: true,
                allowInsertRow: true,
                stretchH: 'all',
                contextMenu: ['row_above', 'row_below', 'remove_row'],
                colWidths: [320, 55, 76, 85, 65, 63, 50, 70, 100, 80, 150,150],
                colHeaders: ['ItemName', 'Qty.', 'Sales Qty.', 'Net Qty.', 'Minlevel', 'Maxlevel', 'Stock', 'Dept. Stock', 'Pen. Indent Qty.', 'Unit','Remarks'],
                columns: [
					{
					    type: 'autocomplete',
					    data: 'ItemName',
					    source: filterItems,
					    strict: true,
					},
					{ data: 'Quantity', type: 'numeric', format: quantityFormat },
                    { data: 'SalesQuantity', type: 'numeric', readOnly: true },

                    { data: 'NetQuantity', type: 'numeric', readOnly: true },
					{ data: 'Minlevel', type: 'numeric', readOnly: true },
					{ data: 'Maxlevel', type: 'numeric', readOnly: true },
					{ data: 'CurrentStock', type: 'numeric', readOnly: true },
                    { data: 'DeptStock', type: 'numeric', readOnly: true },
                    { data: 'PendingQty', type: 'numeric', readOnly: true },

                    { data: 'PurchaseUnit', type: 'text', readOnly: true },
                    { data: 'Remarks', type: 'text', readOnly: false },

                ]
            }
            callback(s);
        }





        var filterItems = function (query, process) {
            getItems(function (i) {
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

        var getItems = function (callback, isStoreTypeChange) {
            if (items.length == 0 || isStoreTypeChange == 1) {
                var data = {
                    storeID: ($('#ddlStoreType').val()),
                    itemtype: 1,
                    DeptLedgerNo: $('#ddlDepartmentTo').val(),
                    SubCategoryID: $('#ddlSubCategory').val()
                }
                serverCall('CreateIndent.aspx/GetItems', data, function (response) {
                    var responseData = JSON.parse(response);
                    items = responseData;
                    callback(items);
                });
            }
            else if (isStoreTypeChange != 1 && isStoreTypeChange != 0) {
                var data = {
                    categoryID: $("#ddlCategory option:selected").val(),
                    subcategoryID: $("#ddlSubCategory option:selected").val(),
                    itemtype: 1
                }
                serverCall('Services/CreatePurchaseRequest.asmx/GetItemsByCategory', data, function (response) {
                    var responseData = JSON.parse(response);
                    items = responseData;
                    callback(items);
                });
            }
            else {
                callback(items);
            }
        }



        var getItemStockDetails = function (itemID, callback) {
            if ($('#ddlCenterTo').val() == 0) {
                modelAlert('Please Select Department.', function () {
                    $('#ddlCenterTo').focus();
                });
                return false;
            }
            if ($('#ddlDepartmentTo').val() == 0) {
                modelAlert('Please Select Department.', function () {
                    $('#ddlDepartmentTo').focus();
                });
                return false;
            }
            var data = {
                itemID: itemID,
                centreID: centreID,
                departmentLedgerID: departmentLedgerNo,
                centreto: $('#ddlCenterTo').val(),
                departmentto: $('#ddlDepartmentTo').val(),
                fromdate: $.trim($('#txtSearchFromDate').val()),
                todate: $.trim($('#txtSearchToDate').val()),
                SubCategoryID : $('#ddlSubCategory').val()
            };
            serverCall('CreateIndent.aspx/getItemStockDetails', data, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }


        var getItemDetails = function (callback) {
            if ($('#ddlCenterTo').val() == 0) {
                modelAlert('Please Select Centre To.', function () {
                    $('#ddlCenterTo').focus();
                });
                return false;
            }
            if ($('#ddlDepartmentTo').val() == 0) {
                modelAlert('Please Select Department To.', function () {
                    $('#ddlDepartmentTo').focus();
                });
                return false;
            }
            if ($('#txtNarration').val() == '') {
                modelAlert('Please Enter Naration.', function () {
                    $('#txtNarration').focus();
                });
                return false;
            }
            var ZeroQuantityItems = [];
            var data = { ItemDetails: $.merge([], hTables.getData()) };

            data.ItemDetails = data.ItemDetails.filter(function (i) {
                if (!String.isNullOrEmpty(i.ItemID)) {
                    if (Number(i.NetQuantity) < 1)
                        ZeroQuantityItems.push(i);
                    else
                        return i;
                }
            });

            if (ZeroQuantityItems.length > 0) {
                modelAlert('Some Item have Invalid Qunatity.');
                return false;
            }

            if (data.ItemDetails.length < 1) {
                modelAlert('Please Select Item First.');
                return false;
            }
            var isValid = 1;
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
            data.storeId = $('#ddlStoreType').val();
            data.narration = $.trim($('#txtNarration').val());
            data.requestType = $('#ddlRequestionType option:selected').text();
            data.requisitionDate = $.trim($('#txtRequisitionOn').val());
            data.issueToDepartment = $.trim($('#ddlDepartmentTo').val());
            data.issueToCenterID = $.trim($('#ddlCenterTo').val());
            data.purchaseRequestNo = editPurchaseRequestNo;
            data.departmeledgerno = departmentLedgerNo;
            data.centreid = centreID;
            callback(data);
        }


        var getAutoPurchaseRequestItemsOnSales = function () {
            var data = {
                departmentLedgerNo: departmentLedgerNo,
                centreID: centreID,
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                minDays: Number($('#txtMinDays').val()),
                reorderInDays: Number($('#txtRequestFor').val()),
                includeStoreToStore: $('#chkStoreTostoreTransfer').prop('checked'),
                CategoryID: $("#ddlCategory option:selected").val(),
                SubCategoryID: $("#ddlSubCategory option:selected").val(),
                groupID: $("#ddlMedicineGroup option:selected").val(),
                centreto: $('#ddlCenterTo').val(),
                departmentto: $('#ddlDepartmentTo').val()
            };

            if (data.fromDate == data.toDate) {
                modelAlert('Please Select Date Range.');
                return false;
            }
            if (data.minDays < 1) {
                modelAlert('Select Enter Min Days.');
                return false;
            }
            if (data.reorderInDays < 1) {
                modelAlert('Select Enter Request Days.');
                return false;
            }


            serverCall('CreateIndent.aspx/GetAutoPurchaseRequestItems', data, function (response) {
                var responseData = JSON.parse(response);
                getGridSetting(function (s) {
                    s.data = responseData;
                    configureTable(s);


                    var IsReduce = $('#chkReducePendingPurchaseOrder').prop('checked');
                    if (IsReduce == 1) {
                        ReducePending(function () { });
                    }
                });
            });

            // 


        }

        var ReducePending = function (callback) {
            serverCall('Services/CreatePurchaseRequest.asmx/ReducePendingPurchase', {}, function (ress) {

                var rdata = JSON.parse(ress);

                for (var j = 1; j <= rdata.length; j++) {
                    var dd = rdata[j];
                    var data1 = $.merge([], hTables.getData());
                    for (var i = 0; i < data1.length; i++) {
                        var tempData = data1[i];
                        if (tempData.ItemID == dd.ItemID) {
                            var salesqty = tempData.SalesQuantity - dd.PendingQty;
                            if (salesqty < 0) {
                                salesqty = 0;
                            }
                            hTables.setDataAtCell(i, hTables.propToCol('SalesQuantity'), salesqty);
                        }
                    }
                }
                callback(rdata);
            });
        }

        var getRequisitionPendingItemsDetails = function (callback) {
            selectedPendingIndentItems = [];
            $('#tableRequistionPendingItems tbody tr td input[type=checkbox]:checked').closest('tr').find('#tdData').each(function () {
                var data = JSON.parse(this.innerHTML)
                selectedPendingIndentItems.push(data.id);
            });

            var data = {
                departmentLedgerNo: departmentLedgerNo,
                centreID: centreID,
                pendingIndentItems: selectedPendingIndentItems
            }
            serverCall('Services/CreatePurchaseRequest.asmx/GetRequisitionPendingItemsDetails', data, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }


        var addPendingItemsToPurchaseRequest = function () {
            getRequisitionPendingItemsDetails(function (data) {
                var _purchaseRequest = $.merge([], hTables.getData());
                _purchaseRequest.pop(_purchaseRequest.length, 0);
                var _newItems = [];
                for (var i = 0; i < data.length; i++) {
                    var _temp = data[i];
                    for (var j = 0; j < _purchaseRequest.length; j++) {
                        var _purchaseRequestTemp = _purchaseRequest[j];
                        if (_temp.ItemID == _purchaseRequestTemp.ItemID) {
                            _purchaseRequest[j].IndentQuantity = (Number(_purchaseRequestTemp.IndentQuantity) + Number(_temp.IndentQuantity));
                            _purchaseRequest[j].IndentNumber = _temp.IndentNumber;
                            _purchaseRequest[j].NetQuantity = (Number(_purchaseRequest[j].IndentQuantity) + Number(_purchaseRequest[j].SalesQuantity) + Number(_purchaseRequest[j].Quantity));
                            data[i].isMerged = 1;
                        }
                    }
                }
                _newItems = data.filter(function (i) { if (i.isMerged == 0) return i; });
                _purchaseRequest = _purchaseRequest.concat(_newItems);
                getGridSetting(function (s) {
                    s.data = _purchaseRequest;
                    configureTable(s);
                    onSearchRequisitionModelClose();
                    onRequisitionPendingItemsModelClose();
                });
                // console.log(_purchaseRequest);
            });
        }






        var save = function (btnSave) {
            getItemDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('CreateIndent.aspx/Save', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        if (responseData.status) {
                            window.open('../../Design/common/Commonreport.aspx');
                            location.reload();
                        }
                        else {
                            var btnValue = Number(0) < 1 ? 'Save' : 'Update';
                            $(btnSave).attr('disabled', false).val(btnValue);
                        }
                    });
                });
            });
        }



        var searchPurchaseRequests = function (e, isSearchType) {
            var code = (e.keyCode ? e.keyCode : e.which);
            if (isSearchType) {
                if (code == 13)
                    getPurchaseRequest(false);

            }
            else
                getPurchaseRequest(false);

        }



        var getPurchaseRequest = function (isFirstLoad) {
            var data = {
                purchaseRequestNo: $('#txtPurchaseRequestNo').val(),
                fromDate: $('#txtSearchPurchaseFromDate').val(),
                toDate: $('#txtSearchPurchaseToDate').val(),
                isFirstLoad: isFirstLoad
            };
            return false;
            //serverCall('Services/CreatePurchaseRequest.asmx/GetPurchaseRequest', data, function (response) {
            //    purchaseRequestSearchDetails = JSON.parse(response);
            //    $('#divPurchaseRequestDetails').html($('#template_purchaseRequest').parseTemplate(purchaseRequestSearchDetails));
            //});
        }

    </script>



    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="scrManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b id="pageTitle">Create Department & Interbranch Indent</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Auto Indent Behalf Of Sales  
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Store Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ClientIDMode="Static" ID="ddlStoreType" onchange="onStoreTypeChange()"  runat="server"></asp:DropDownList>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Center To</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlCenterTo" class="required" onchange="getDepartMent(function () { });"></select>
                </div>


                <div class="col-md-3">
                    <label class="pull-left">Department To</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlDepartmentTo" class="required"></select>
                </div>



            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select onchange="onCategoryChange(this.value)"  id="ddlCategory"></select>
                </div>
                
                <div class="col-md-3" style="display:none">
                    <label class="pull-left">Group</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5" style="display:none">
                    <select id="ddlMedicineGroup" ></select>

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
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ClientIDMode="Static" Text="27-May-2018"  autocomplete="off" ID="txtFromDate"></asp:TextBox>
                    <cc1:CalendarExtender ID="calExtenderFromDate" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ClientIDMode="Static" autocomplete="off" ID="txtToDate"></asp:TextBox>
                    <cc1:CalendarExtender ID="calExtenderToDate" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtToDate"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Min Days</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtMinDays"  value="10" onlynumber="5" autocomplete="off" max-value="100" />
                </div>

            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Request For</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtRequestFor" value="10" class="ItDoseTextinputNum" placeholder="In Days." />
                </div>
                <div class="col-md-16">
                     <input type="button" class="pull-right" style="margin-right: 5px;" onclick="getAutoPurchaseRequestItemsOnSales()" value="Auto Indent On Reorder Level" />
                </div>
            </div>
            <div class="row">
             <div class="col-md-3" style="display:none">
                    <label class="pull-left">Reorder Option</label>
                    <b class="pull-right">:</b>
                </div>
                <%--   <div class="col-md-7">
                    <label>
                        <input type="checkbox" id="chkReducePendingPurchaseOrder" />
                               Reduce Pending Purchase Order Item Quantity.
                       </label>
                </div>--%>
                <div class="col-md-7" style="display:none">
                    <label>
                        <input id="chkStoreTostoreTransfer" type="checkbox" />
                        Include Store To Store Transfer.
                    </label>
                </div>

            </div>
            <div class="row" style="display:none">
                <div class="col-md-24">
                    <input type="button" class="pull-right" style="margin-right: 5px;display:none" onclick="onSearchRequisitionModelOpen()" value="Add Pending Indents." />
                   
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="handsomeTableCustomize" id="divPurchaseRequestItems"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Requisition Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlRequestionType">
                        <option selected="selected" value="1">Normal</option>
                        <option value="2">Urgent</option>
                        <option value="3">Immediate</option>
                        <option value="4">Amended</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Requisition On</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox runat="server" ClientIDMode="Static" ID="txtRequisitionOn" Enabled="false"></asp:TextBox>
                    <cc1:CalendarExtender ID="calExtRequisitionOn" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtRequisitionOn"></cc1:CalendarExtender>
                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Narration</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-8">
                    <textarea id="txtNarration" style="width: 680px;min-width: 680px;max-width: 680px; height: 27px" class="requiredField" cols="0" rows="0"></textarea>
                </div>
            </div>


        </div>

        <div class="POuter_Box_Inventory textCenter">
            <input type="button" id="btnSave" value="Save" onclick="save(this);" class="save margin-top-on-btn" />
            
            <input type="button" id="btnCancel" value="Cancel" class="save margin-top-on-btn"   onclick="location.href = 'CreateIndent.aspx'" />
        </div>

        <div class="POuter_Box_Inventory" style="display:none">
			<div class="Purchaseheader">
				Search Purchase Request's 
			</div>
			<div class="row">
				<div class="col-md-3">
					<label class="pull-left">Purchase Req. No.</label>
					<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					<input type="text" placeholder="Press Enter To Search." onkeyup="searchPurchaseRequests(event,true);" id="txtPurchaseRequestNo"/>
				</div>
				<div class="col-md-3">
					<label class="pull-left">From Date</label>
					<b class="pull-right">:</b>
				</div>

				<div class="col-md-5">
					<asp:TextBox runat="server" ID="txtSearchPurchaseFromDate" onchange="searchPurchaseRequests(event,false);" ClientIDMode="Static" ></asp:TextBox>
					<cc1:CalendarExtender  ID="CalExtenTxtSearchPurchaseFromDate" Format="dd-MMM-yyyy"  runat="server" TargetControlID="txtSearchPurchaseFromDate"></cc1:CalendarExtender>
				</div>


				<div class="col-md-3">
					<label class="pull-left">To Date</label>
					<b class="pull-right">:</b>
				</div>
				<div class="col-md-5">
					<asp:TextBox runat="server" ID="txtSearchPurchaseToDate" onchange="searchPurchaseRequests(event,false);" ClientIDMode="Static" ></asp:TextBox>
                    <cc1:CalendarExtender ID="CalExtenTxtSearchPurchaseToDate" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtSearchPurchaseToDate"></cc1:CalendarExtender>
					
				</div>

			</div>

		</div>
        <div class="POuter_Box_Inventory" style="display:none">
            <div class="row">
                <div class="col-md-24">
                    <div   style="height: 230px; overflow: auto" id="divPurchaseRequestDetails">

                     </div>
                </div>
            </div>
        </div>

    </div>




    <div id="divIndentSearch" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1050px; height: 500px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="onSearchRequisitionModelClose()" aria-hidden="true">×</button>
                    <h4 class="modal-title">Search Requisition</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Requisition No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" onkeyup="searchIndents(event,function(){});" id="txtRequisitionNo" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ClientIDMode="Static" onchange="searchIndents(event,function(){})" ID="txtSearchFromDate"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtSearchFromDate"></cc1:CalendarExtender>

                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" onchange="searchIndents(event,function(){})" ClientIDMode="Static" ID="txtSearchToDate"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" Format="dd-MMM-yyyy" runat="server" TargetControlID="txtSearchToDate"></cc1:CalendarExtender>
                        </div>
                    </div>



                    <div class="row">
                        <div class="col-md-24">
                            <div style="height: 360px; overflow: auto" id="divIndentsSearchDetails"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button onclick="getAllPendingIndentItemsDetails()" type="button">Get All Pending Items.</button>
                    <button onclick="onSearchRequisitionModelClose()" type="button">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divPendingIndentItems" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 700px; height: 420px">
                <div class="modal-header">
                    <button type="button" class="close" onclick="onRequisitionPendingItemsModelClose()" aria-hidden="true">×</button>
                    <h4 class="modal-title">Pending Items</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
              
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <div style="height: 300px; overflow: auto" id="divPendingIndentItemsDetails"></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button onclick="addPendingItemsToPurchaseRequest()" type="button">Add To Purchase Request.</button>
                    <button onclick="onRequisitionPendingItemsModelClose()" type="button">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        var searchIndents = function (e, callback) {
            var data = {
                requisitionNo: $.trim($('#txtRequisitionNo').val()),
                fromDate: $.trim($('#txtSearchFromDate').val()),
                toDate: $.trim($('#txtSearchToDate').val()),
                departmentLedgerNo: departmentLedgerNo,
                centreID: centreID
            }
            serverCall('Services/CreatePurchaseRequest.asmx/SearchIndents', data, function (response) {
                searchIndentDetails = JSON.parse(response);
                $('#divIndentsSearchDetails').html($('#template_Indents').parseTemplate(searchIndentDetails));
                callback(searchIndentDetails);
            });
        }


        var onSearchRequisitionModelOpen = function () {
            searchIndents(null, function () {
                $('#divIndentSearch').showModel();
            });
        }

        var onSearchRequisitionModelClose = function () {
            $('#divIndentSearch').closeModel();
            $('#divIndentsSearchDetails').html('');
        }




        var onRequisitionPendingItemsModelClose = function () {
            $('#divPendingIndentItems').closeModel();
            $('#divPendingIndentItemsDetails').html('');
        }


        var getIndentItemsDetails = function (elem) {
            var row = $(elem).closest('tr');
            var requisitionNo = $.trim(row.find('#tdRequisitionNo').text());
            serverCall('Services/DirectIssue.asmx/GetIndentItemsDetails', { requisitionNo: requisitionNo }, function (response) {
                var responseData = JSON.parse(response);
                bindRequisitionDetails(elem, responseData);
            });
        }


        var getAllPendingIndentItemsDetails = function () {
            var selectedRequisitions = [];
            $('#divIndentsSearchDetails table tbody tr td input[type=checkbox]:checked').closest('tr').find('#tdRequisitionNo').each(function () {
                selectedRequisitions.push($.trim(this.innerHTML));
            });
            serverCall('Services/CreatePurchaseRequest.asmx/GetAllPendingIndentItemsDetails', { selectedRequisitions: selectedRequisitions }, function (response) {
                requistionPendingItems = JSON.parse(response);
                $('#divPendingIndentItemsDetails').html($('#template_requistionPendingItems').parseTemplate(requistionPendingItems));
                $('#divPendingIndentItems').showModel();
            });
        }



        var bindRequisitionDetails = function (elem, data) {
            var selectedRow = $(elem).closest('tr');
            var isAlreadySelected = selectedRow.hasClass('selectedRow');
            $(elem).closest('tbody').find('tr').removeClass('selectedRow').hide();
            if (!isAlreadySelected) {
                $('.trIndentItemsDetail').hide().find('td').find('div').html('');
                requistionItemsDetail = data;
                selectedRow.addClass('selectedRow').show().next('.trIndentItemsDetail')
					.show().find('td').find('div').html($('#template_requistionItemsDetail').parseTemplate(requistionItemsDetail)).customFixedHeader();
            }
            else {
                $(elem).closest('tbody').find('tr').removeClass('selectedRow').show();
                $('.trIndentItemsDetail').hide().find('td').find('div').html('');
            }
        }


        var toggleCheck = function (allCheckBox, parentTable, isAllCheckedChange) {
            if (isAllCheckedChange)
                $(parentTable).find('input[type=checkbox]').prop('checked', $(allCheckBox).prop('checked'));
            else {
                var status = (($(parentTable).find('input[type=checkbox]').length == $(parentTable).find('input[type=checkbox]:checked').length) ? true : false);
                $(allCheckBox).prop('checked', status);
            }
        }

    </script>

    <script id="template_Indents" type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="tableIndents" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle">#</th>
						<th class="GridViewHeaderStyle">Requisition No.</th>
						<th class="GridViewHeaderStyle">Requisition From</th>
						<th class="GridViewHeaderStyle">Requisition On</th>
						<th class="GridViewHeaderStyle">Requisition By</th>
						<th class="GridViewHeaderStyle">Total</th>
                        <th class="GridViewHeaderStyle">Remaning</th>
                        <th class="GridViewHeaderStyle">Status</th>
						<th class="GridViewHeaderStyle" style="padding-left: 5px;" ><input onchange="toggleCheck(this,$('#tableIndents tbody'),true)" id="chkPendingIndentsAll" type="checkbox" /></th>
						
						</tr>
				</thead>
				   <tbody>
			<#
			 var dataLength=searchIndentDetails.length;        
			 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = searchIndentDetails[j];
				#>          
				<tr style="cursor:pointer" >
					<td onclick="getIndentItemsDetails(this)" class="GridViewLabItemStyle"><#= j+1 #></td>
					<td onclick="getIndentItemsDetails(this)" class="GridViewLabItemStyle" id="tdRequisitionNo" > <#=objRow.IndentNo#></td>
					<td onclick="getIndentItemsDetails(this)"  class="GridViewLabItemStyle"> <#=objRow.CentreName#>(<#=objRow.RoleName#>)</td>
					<td onclick="getIndentItemsDetails(this)" class="GridViewLabItemStyle"> <#=objRow.IndentDate#></td>
					<td onclick="getIndentItemsDetails(this)" class="GridViewLabItemStyle"> <#=objRow.IndentBy#></td>
                    <td onclick="getIndentItemsDetails(this)" class="GridViewLabItemStyle textCenter"> <#=objRow.TotalItem#></td>
                    <td onclick="getIndentItemsDetails(this)" class="GridViewLabItemStyle textCenter"> <#= (objRow.RemainItem) #> </td>
                    <td onclick="getIndentItemsDetails(this)" class="GridViewLabItemStyle textCenter" style="font-weight:bold;
                        
                        <#if(objRow.STATUS=='Closed'){#>
                             color:Green
                        <#}#>

                        <#if(objRow.STATUS=='Partial'){#>
                             color:blue
                        <#}#>

                         <#if(objRow.STATUS=='Reject'){#>
                             color:red
                        <#}#>

                        <#if(objRow.STATUS=='UnOpened'){#>
                              color:black
                        <#}#>

                         

                        "> <#=objRow.STATUS#></td>
					<td class="GridViewLabItemStyle textCenter">
						<input onchange="toggleCheck($('#chkPendingIndentsAll'),$('#tableIndents tbody'),false)" type="checkbox" />
					</td>
				</tr>
                    <tr style="display:none" class="trIndentItemsDetail">
				         <td colspan="9"  class="GridViewLabItemStyle" >
                           <div style="max-height:308px;overflow:auto" ></div>
				         </td>
			        </tr>
			   <#}#>     
					</tbody>       
		 </table>    
	</script>

    <script id="template_requistionItemsDetail" type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="Table2" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle">#</th>
						<th class="GridViewHeaderStyle">Item Name</th>
						<th class="GridViewHeaderStyle">Requested</th>
						<th class="GridViewHeaderStyle">Issued</th>
						<th class="GridViewHeaderStyle">Rejected</th>
                        <th class="GridViewHeaderStyle">Remain</th>
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
					<td class="GridViewLabItemStyle" id="td1" > <#=objRow.ItemName#></td>
					<td class="GridViewLabItemStyle textCenter"><#=objRow.ReqQty#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=objRow.ReceiveQty#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=objRow.RejectQty#></td>
					<td class="GridViewLabItemStyle textCenter"> <#=(objRow.ReqQty-(objRow.ReceiveQty+objRow.RejectQty))#></td>
				</tr>
			   <#}#>     
					</tbody>       
		 </table>    
	</script>

    <script id="template_requistionPendingItems" type="text/html">
        <table  id="tableRequistionPendingItems" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px" >Requisition No.</th>
            <th class="GridViewHeaderStyle" scope="col" >ItemName</th>
            <th class="GridViewHeaderStyle" scope="col" style="width: 100px;" >Remain Qty.</th>     
            <th class="GridViewHeaderStyle" scope="col" style="width:10px" ><input id="chkPendingItemsAll" checked="checked" onchange="toggleCheck(this,$('#tableRequistionPendingItems tbody'),true)" type="checkbox" /> </th>                       
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=requistionPendingItems.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = requistionPendingItems[j];
                #>          
                

                    <tr onmouseover="this.style.color='#00F'"     onMouseOut="this.style.color=''" id="<#=j+1#>" style='cursor:pointer;'>                            
                        <td class="GridViewLabItemStyle">
                                <#=j+1#>
                        </td>  
                        <td  class="GridViewLabItemStyle" id="td5"><#=objRow.IndentNo#></td>                                                  
                        <td  class="GridViewLabItemStyle" id="td2"><#=objRow.ItemName#></td>
                        <td  class="GridViewLabItemStyle textCenter" id="td3"><#=objRow.RemainQty#></td>  
                        <td  class="GridViewLabItemStyle textCenter" style="padding-left: 1px;" id="td4"> 
                            <input  onchange="toggleCheck($('#chkPendingItemsAll'),$('#tableRequistionPendingItems tbody'),false)" checked="checked" type="checkbox" />
                        </td>  
                        <td  class="GridViewLabItemStyle" id="tdData" style="display:none">   <#= JSON.stringify(objRow)  #></td>                    
                    </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>



    <script id="template_purchaseRequest" type="text/html">
		<table  style="width: 100%; border-collapse: collapse;"     id="table1" >       
				<thead>
					<tr>
						<th class="GridViewHeaderStyle">#</th>
						<th class="GridViewHeaderStyle">Request No.</th>
						<th class="GridViewHeaderStyle">Subject</th>
						<th class="GridViewHeaderStyle">Request On</th>
						<th class="GridViewHeaderStyle">Requisition By</th>
						<th class="GridViewHeaderStyle">Type</th>
                        <th class="GridViewHeaderStyle">Status</th>
                        <th class="GridViewHeaderStyle">Edit</th>
                    </tr>
				</thead>
				   <tbody>
			<#
			 var dataLength=purchaseRequestSearchDetails.length;        
			 var objRow;    
			
				for(var j=0;j<dataLength;j++)
				{
					objRow = purchaseRequestSearchDetails[j];
				#>          
				<tr style="cursor:pointer" >
					<td  class="GridViewLabItemStyle"><#= j+1 #></td>
					<td  class="GridViewLabItemStyle" id="td6" > <#=objRow.PurchaseRequestNo#></td>
					<td  class="GridViewLabItemStyle"> <#=objRow.Subject#></td>
					<td  class="GridViewLabItemStyle"> <#=objRow.RaisedDate#></td>
					<td  class="GridViewLabItemStyle"> <#=objRow.Name#></td>
                    <td  class="GridViewLabItemStyle textCenter"> <#=objRow.Type#></td>
                    <td  class="GridViewLabItemStyle textCenter"><b> <#= objRow.STATUS #></b> </td>
                    <td class="GridViewLabItemStyle textCenter"> 
                         <#if(objRow.Approved==0){#>
                        <img alt="X" onclick="onEditPurchaseRequestNo(this);" class="btnOperation" style="cursor:pointer" src="../../Images/Post.gif"/>
                        <#}#>
                    </td>
				</tr>
                    <tr style="display:none" class="trIndentItemsDetail">
				         <td colspan="9"  class="GridViewLabItemStyle" >
                           <div style="max-height:308px;overflow:auto" ></div>
				         </td>
			        </tr>
			   <#}#>     
					</tbody>       
		 </table>    
	</script>




    <script type="text/javascript">
        var onEditPurchaseRequestNo = function (elem) {
            var row = $(elem).closest('tr');
            var requisitionNo = $.trim(row.find('#td6').text());
            location.href = 'CreatePurchaseRequest.aspx?PurchaseRequestNo=' + requisitionNo;
        }


        var getPurchaseRequestItemDetails = function (requisitionNo) {
            var data = {
                departmentLedgerNo: departmentLedgerNo,
                centreID: centreID,
                requestNo: requisitionNo
            };
            serverCall('Services/CreatePurchaseRequest.asmx/OnEditPurchaseRequest', data, function (response) {
                var responseData = JSON.parse(response);
                bindEditPurchaseRequestNo(responseData);
            });
        }


        var bindEditPurchaseRequestNo = function (data) {
            getGridSetting(function (s) {
                s.data = data;
                configureTable(s);
                $('#btnSave').val('Update');
                $('#btnCancel').show();
            });
        }

        //$("#ddlStoreType").change(function () {
        //    var id = $(this).val();
        //    getItems(function () {

        //    }, id);
        //});

        $("#ddlDepartmentTo").change(function () {
            var id = $(this).val();
            getItems(function () {

            }, 1);
        });

        $("#ddlSubCategory").change(function () {
            var id = $(this).val();
            getItems(function () {

            }, 1);
        });


    </script>



</asp:Content>


