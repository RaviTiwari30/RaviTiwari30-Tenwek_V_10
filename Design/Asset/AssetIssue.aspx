<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="AssetIssue.aspx.cs" Inherits="Design_Asset_AssetIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <link rel="Stylesheet" href="../../Styles/easyui.css" type="text/css" />

    <style type="text/css">
        .selectedRow
        {
            background-color:aqua;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            hideandShow(1, function () {
                bindDepartment(function () {
                    LoadAssetItems(function (callback) {
                        $commonJsInit(function () {
                          
                        });
                    });
                });
            });
        });
        var LoadAssetItems = function (callback) {
            try {
                getComboGridOption(function (response) {

                    $('#txtItemSearch').combogrid(response);

                    callback(true);
                });
            } catch (e) {

            }
        }

        var hideandShow = function (value, callback) {
            if (value == 1) {
                $('.indent').hide();
                $('.direct').show();
            }
            else {
                $('.indent').show();
                $('.direct').hide();
            }
            callback();
        }
        var bindDepartment = function (callback) {
            ddlIssueToDepartment = $('#ddlIssueToDepartment');
            ddlReqDepartment = $('#ddlReqDepartment');
            serverCall('Services/AssetIssue.asmx/BindDepartment', {}, function (response) {
                ddlIssueToDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
                ddlReqDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
                callback(ddlIssueToDepartment.val());
            });
        }

        var getComboGridOption = function (callback) {
            var setting = {
                panelWidth: 500,
                idField: 'AssetID',
                textField: 'ItemName',
                mode: 'remote',
                url: 'Services/AssetIssue.asmx/LoadItems?cmd=item',
                loadMsg: 'Searching... ',
                method: 'get',
                pagination: true,
                pageSize: 20,
                rownumbers: true,
                fit: true,
                border: false,
                cache: false,
                nowrap: true,
                emptyrecords: 'No records to display.',
                queryParams: {
                    q: '',
                    SearchBy: $('#ddlSearchtype').val(),
                    DeptLedgerNo: $('#lblDeptLedgerNo').text().trim(),
                    isAssetLocation:'0'
                },
                onHidePanel: function () { },
                columns: [[
                    { field: 'ItemName', title: 'ItemName', align: 'left', sortable: true },
                    { field: 'BatchNumber', title: 'BatchNumber.', align: 'center', sortable: true },
                    { field: 'ModelNo', title: 'ModelNo.', align: 'center', sortable: true },
                    { field: 'SerialNo', title: 'SerialNo.', align: 'center', sortable: true },
                    { field: 'AssetNo', title: 'AssetNo.', align: 'center', sortable: true },

                ]],
                fitColumns: true,
                rowStyler: function (index, row) {
                    if (row.alterNate > 0) {
                        return 'background-color:antiquewhite;';
                    }
                }
            }
            callback(setting);
        }

        var AddAsset = function (e) {
            var txtItemSearch = $('#txtItemSearch');
            var quantity = 1
            var grid = txtItemSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            var code = (e.keyCode ? e.keyCode : e.which);
            if (String.isNullOrEmpty(selectedRow)) {
                modelAlert('Please Select Item First', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtItemSearch.combogrid('reset');
                });
                return;
            }



            var data = {
                StockID: $.trim(selectedRow.StockID),
                ItemID: $.trim(selectedRow.ItemID),
                AssetID: $.trim(selectedRow.AssetID),
                BatchNo: $.trim(selectedRow.BatchNumber),
                ModelNo: $.trim(selectedRow.ModelNo),
                SerialNo: $.trim(selectedRow.SerialNo),
                AssetNo: $.trim(selectedRow.AssetNo),
                ItemName: $.trim(selectedRow.ItemName),
                Quantity: quantity,
                f_StockID: $.trim(selectedRow.f_StockID),
            }

            var alreadySelectBool = $('#tr_' + data.StockID).length > 0 ? true : false;
            if (alreadySelectBool) {
                modelAlert('Item Already Added', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtItemSearch.combogrid('reset');
                });
                return;
            }

            bindItem(data, function () {
                $('.textbox-text.validatebox-text').focus();
                txtItemSearch.combogrid('reset');
            });

            if (code == 9 && e.target.type == 'text') {
                $(this).parent().find('input[type=button]').focus();
            }

        }

        var bindItem = function (data, callback) {
            getAccessoriesDetails(data, function (acccessories) {
                addAssetNewRow(data, acccessories, function () {

                });
            });
        }
        addAssetNewRow = function (data, acccessories, callback) {
            var table = $('#tblSelectedItems tbody.asset');
            var j = $(table).find('tr.assetRow').length + 1;
            var row = '<tr class="assetRow tr_' + data.StockID + '" id="tr_' + data.StockID + '">';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
            row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data.ItemName + '</td>';
            row += '<td id="tdBatchNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.BatchNo + '</td>';
            row += '<td id="tdModelNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.ModelNo + '</td>';
            row += '<td id="tdSerialNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.SerialNo + '</td>';
            row += '<td id="tdAssetNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.AssetNo + '</td>';
            row += '<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align: center;">' + data.Quantity + '</td>';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgRmv" src="../../Images/Delete.gif" onclick="removeAsset(this);" style="cursor:pointer;" title="Click To Remove"></td>';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;">';
            if (acccessories.length > 0)
                row += '<img id="imghide" src="../../Images/showminus.png" onclick="hideAccessories(this);" style="cursor:pointer;" title="Click To Hide Accessories">';
            row += '<img id="imgshow" src="../../Images/showplus.png" onclick="showAccessories(this);" style="cursor:pointer;display:none" title="Click To Show Accessories">';
            row += '</td>';
            row += '<td id="tdAssetID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.AssetID + '</td>';
            row += '<td id="tdStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.StockID + '</td>';
            row += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.ItemID + '</td>';
            row += '<td id="tdf_StockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.f_StockID + '</td>';
            row += '</tr>';
            if (acccessories.length > 0) {
                row += '<tr class="Access_' + data.StockID + '">';
                row += '<td class="GridViewLabItemStyle" colspan="4"></td>'
                row += '<td class="GridViewLabItemStyle" colspan="5">';
                row += '<table style="width:100%" border-collapse: collapse; cellspacing="0" rules="all" border="1"><thead><tr>';
                row += '<th class="GridViewHeaderStyle" scope="col">Srno</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">AccessoriesName</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">ModelNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">SerialNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">BatchNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">LicenceNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">Qty</th>';
                row += '</tr></thead>';
                row += '<tbody>';
                for (var i = 0; i < acccessories.length; i++) {
                    row += '<tr>';
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + (i + 1) + '</td>';
                    row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories[i].AccessoriesName + '</td>';
                    row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories[i].ModelNo + '</td>';
                    row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories[i].SerialNo + '</td>';
                    row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories[i].BatchNo + '</td>';
                    row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories[i].LicenceNo + '</td>';
                    row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories[i].Quantity + '</td>';
                    row += '<td id="tdtaggedID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + acccessories[i].TaggedID + '</td>';
                    row += '<td id="tdaccessoriesID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + acccessories[i].AccessoriesID + '</td>';
                    row += '</tr>';
                }
                row += '</tbody>';
                row += '</table>';
                row += '</td>'
                row += '</tr>';
            }
            $(table).append(row);
            callback(true);
            $('.divSelectedItems').show();
            $('#divSave').show();
            var txtItemSearch = $('#txtItemSearch');
            txtItemSearch.combogrid('reset');
        }

        var showAccessories = function (ctrl) {
            $(ctrl).closest('tr').find('#imgshow').hide();
            $(ctrl).closest('tr').find('#imghide').show();
            var stockID = $(ctrl).closest('tr').find('#tdStockID').text();
            $('.Access_' + stockID).show();
        }
        var hideAccessories = function (ctrl) {
            $(ctrl).closest('tr').find('#imgshow').show();
            $(ctrl).closest('tr').find('#imghide').hide();
            var stockID = $(ctrl).closest('tr').find('#tdStockID').text();
            $('.Access_' + stockID).hide();
        }
        var getAccessoriesDetails = function (data, callback) {
            serverCall('Services/WebService.asmx/bindtaggesAccessories', { GRNNo: '', ItemID: '', AssetID: data.AssetID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }
        var removeAsset = function (elem) {
            $(elem).parent().parent().remove();
            var row = $(elem).parent().parent();
            var stockID = row.find('#tdStockID').text().trim();
            $('#tblSelectedItems tbody .Access_' + stockID).remove();
            if ($("#tblSelectedItems tr").length - 1 == "0") {
                $('.divSelectedItems').hide();
                $('#divSave').hide();
            }
        }
        var onSearchTypeChange = function (elem) {
            try {
                var options = $('#txtItemSearch').combogrid('options');
                options.queryParams.SearchBy = elem.value;
            } catch (e) {

            }
        }
        var SaveDirectIssue = function () {
            getDirectIssueDetails(function (data) {
                Save(data, function () { });
            });
        }

        var getDirectIssueDetails = function (callback) {
            if ($('#ddlIssueToDepartment').val() == '0') {
                modelAlert('Please Select Department', function () {
                    $('#ddlIssueToDepartment').focus();
                });
                return false;
            }
            assetDetails = [];
            var table = $('#tblSelectedItems tbody tr.assetRow');
            $(table).each(function (i, e) {
                assetDetails.push({
                    AssetID: $(e).find('#tdAssetID').text().trim(),
                    ItemName: $(e).find('#tdItemName').text().trim(),
                    BatchNo: $(e).find('#tdBatchNo').text().trim(),
                    ModelNo: $(e).find('#tdModelNo').text().trim(),
                    SerialNo: $(e).find('#tdSerialNo').text().trim(),
                    AssetNo: $(e).find('#tdAssetNo').text().trim(),
                    StockID: $(e).find('#tdStockID').text().trim(),
                    ItemID: $(e).find('#tdItemID').text().trim(),
                    f_StockID: $(e).find('#tdf_StockID').text().trim(),
                });
            });
            accessoriesDetails = [];

            assetDetails.forEach(function (elem) {
                var stockID = elem.StockID;
                var tblAcc = $('.Access_' + stockID + ' table tbody tr');
                if (tblAcc.length > 0) {
                    $(tblAcc).each(function (i, e) {
                        accessoriesDetails.push({
                            stockID: stockID,
                            accessoriesID: $(e).find('#tdaccessoriesID').text().trim(),
                            taggedID: $(e).find('#tdtaggedID').text().trim(),
                        });
                    });
                }
            });


            callback({ assetDetails: assetDetails, accessoriesDetails: accessoriesDetails, isDirectIssue: '1', IssueToDeptLedgerNo: $('#ddlIssueToDepartment').val(), takenBy: $('#txtEmployeeName').val().trim(), Narration: $('#txtNarration').val().trim(),IndentNo:'' });
        }

        var getIndentIssueDetails = function (callback) {
            assetDetails = [];
            var table = $('#tblItemStock tbody tr.IndentAssetRow');
            $(table).each(function (i, e) {
                if (!String.isNullOrEmpty($(e).find('#spnStockID').text().trim())) {
                    assetDetails.push({
                        AssetID: $(e).find('#spnAssetID').text().trim(),
                        ItemName: $(e).find('#tdIndentItemName').text().trim(),
                        BatchNo: $(e).find('#spnBatchno').text().trim(),
                        ModelNo: $(e).find('#spnModelno').text().trim(),
                        SerialNo: $(e).find('#spnSerialno').text().trim(),
                        AssetNo: $(e).find('#spnAssetno').text().trim(),
                        StockID: $(e).find('#spnStockID').text().trim(),
                        ItemID: $(e).find('#tdIndentItemID').text().trim(),
                        f_StockID: $(e).find('#spnf_StockID').text().trim(),
                    });
                }
            });
            var isNotBlank = assetDetails.filter(function (i) {
                if (!String.isNullOrEmpty(i.StockID)) {
                    return i;
                }
            });
            if (isNotBlank.length <= 0) {
                modelAlert('Please Select Any Asset to Issue');
                return false;
            }
            if (assetDetails.length <= 0) {
                modelAlert('Please Select Any Asset');
                return false;
            }

            accessoriesDetails = [];

            assetDetails.forEach(function (elem) {
                var stockID = elem.StockID;
                var tblAcc = $('#tblItemStock tbody .Access_' + stockID + ' table tbody tr');
                if (tblAcc.length > 0) {
                    $(tblAcc).each(function (i, e) {
                        accessoriesDetails.push({
                            stockID: stockID,
                            accessoriesID: $(e).find('#tdaccessoriesID').text().trim(),
                            taggedID: $(e).find('#tdtaggedID').text().trim(),
                        });
                    });
                }
            });
            callback({ assetDetails: assetDetails, accessoriesDetails: accessoriesDetails, isDirectIssue: '0', IssueToDeptLedgerNo: $('#spnFromDeptID').text().trim(), takenBy: '', Narration: '', IndentNo: $('#spnIndentNo').text().trim() })

        }
        var SaveIndentIssue = function () {
            getIndentIssueDetails(function (data) {
                Save(data, function () { });
            });
        }
        var Save = function (data, callback) {
            serverCall('Services/AssetIssue.asmx/SaveIssueAsset', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    modelAlert(responseData.response, function () {
                        printAssetIssueReciept(responseData.SalesNo, function () {
                            if ($('input[name=rdoIssueType]:checked').val() == '2')
                                SearchIndent();
                            else
                                window.location.reload();
                        });
                    });
                else
                    modelAlert(responseData.response, function () { });
            });
        }
        var printAssetIssueReciept = function (SalesNo,callback) {
            serverCall('Services/AssetIssue.asmx/ReprintDepartmentIssue', { salesno: SalesNo }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response, function () { });
            });
            callback(true);
        }



        var SearchIndent = function () {
            $('.indentDetail table tbody tr').remove();
            $('.indentDetail #tblacc').remove();
            $('.indentDetail').hide();
            $('.indentSearch').show();
            data = {
                fromdate: $('#txtFromDate').val(),
              //  fromdate: '02-02-2020',
                todate: $('#txtToDate').val(),
                reqdepartment: $('#ddlReqDepartment').val(),
                indentno: $('#txtIndentNo').val().trim(),
                status: $('#ddlStatus').val(),
            }
            debugger;
            serverCall('Services/AssetIssue.asmx/SearchIndent', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    bindIndentData(responseData);
                    AssetStock.dtAsset = [];
                    AssetStock.dtAccessories = [];
                }
                else
                    modelAlert('No Record Found');
            });
        }
        var bindIndentData = function (data) {
            $table = $('#tblSearchIndent tbody');
            $($table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $($table).find('tr').length + 1;
                var row = '';
                if (data[i].StatusNew == '1')
                    row += '<tr style="background-color:lightblue">';
                else if (data[i].StatusNew == '2')
                    row += '<tr style="background-color:#90EE90">';
                else if (data[i].StatusNew == '3')
                    row += '<tr style="background-color:lightpink">';
                else if (data[i].StatusNew == '4')
                    row += '<tr style="background-color:yellow">';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdDateTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].dtEntry + '</td>';
                row += '<td id="tdIndentNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].indentno + '</td>';
                row += '<td id="tdFromDept" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].DeptFrom + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Type + '</td>';
                if (data[i].VIEW=='true')
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="IssueIndent(this);" style="cursor: pointer;" title="Click To Issue" /></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="SearchIndentDetails(this);" style="cursor: pointer;" title="Click To View Details" /></td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].LedgerNumber + '</td>';
                row += '</tr>';
                $($table).append(row);
            }
        }
        var IssueIndent = function (rowID) {
            var row = $(rowID).closest('tr');
            var IndentNo = $(row).find('#tdIndentNo').text().trim();
            serverCall('Services/AssetIssue.asmx/SearchIndentDetails', { IndentNo: IndentNo }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('.indentDetail').show();
                    $('.indentSearch').hide();
                    $('#spnIndentNo').text($(row).find('#tdIndentNo').text().trim());
                    $('#spnFromDept').text($(row).find('#tdFromDept').text().trim());
                    $('#spnDateTime').text($(row).find('#tdDateTime').text().trim());
                    $('#spnFromDeptID').text($(row).find('#tdDeptFrom').text().trim());
                    bindIndentItems(responseData);
                }
            });
        }
        var bindIndentItems = function (data) {
            $table = $('#tblIndentItems tbody');
            $($table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $($table).find('tr').length + 1;
                var row = '<tr id="tr_' + data[i].ItemID + '">';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td id="tdDateTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ReqQty + '</td>';
                row += '<td id="tdDateTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ReceiveQty + '</td>';
                row += '<td id="tdDateTime" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RejectQty + '</td>';
                row += '<td id="tdAvailableQty" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AvailableQty + '</td>';
                row += '<td id="tdRemarks" class="GridViewLabItemStyle" style="text-align: center;"></td>';
                if (Number(data[i].AvailableQty) > 0 && Number(data[i].totalQty)>0)
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="checkbox" onchange="SearchAssetForItems(this);"></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"></tr>';
                row += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '<td id="tdtotalQty" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].totalQty + '</td>';
                row += '</tr>';
                $($table).append(row);
            }
        }
        var SearchAssetForItems = function (rowID) {
            var row = $(rowID).closest('tr');
            row.addClass('selectedRow');
            var ItemID = $(row).find('#tdItemID').text().trim();
            var ItemName = $(row).find('#tdItemName').text().trim();
            var TotalPendingQty = Number($(row).find('#tdtotalQty').text().trim());
            var TotalAvailableQty = Number($(row).find('#tdAvailableQty').text().trim());
            var NetQty = TotalPendingQty;
            if (TotalAvailableQty > TotalPendingQty) {
                NetQty = TotalPendingQty;
            }
            else if (TotalAvailableQty < TotalPendingQty) {
                NetQty = TotalAvailableQty;
            }

            if (!$(rowID).is(':checked')) {
                
                $('#tblItemStock tbody #tr_' + ItemID).remove();
                row.removeClass('selectedRow');
                AssetStock.dtAsset = AssetStock.dtAsset.filter(function (i) { return i.ItemID != ItemID });
                AssetStock.dtAccessories = AssetStock.dtAccessories.filter(function (i) { return i.ItemID != ItemID });
                return false;
            }

            SearchAssetStockbyItemID(ItemID, function (response) {
                var asset = response.dtAsset;
                var batch = response.dtbatch;
                var access = response.dtAccessories;
               
                for (var k = 0; k < asset.length; k++) {
                    AssetStock.dtAsset.push({
                        AssetNo: asset[k].AssetNo,
                        StockID: asset[k].StockID,
                        BatchNumber: asset[k].BatchNumber,
                        SerialNo: asset[k].SerialNo,
                        ModelNo: asset[k].ModelNo,
                        f_StockID: asset[k].f_StockID,
                        AssetID: asset[k].AssetID,
                        ItemID: asset[k].ItemID,
                    });
                }
                for (var k = 0; k < access.length; k++) {
                    AssetStock.dtAccessories.push({
                        StockID: access[k].StockID,
                        AccessoriesID: access[k].AccessoriesID,
                        AssetID: access[k].AssetID,
                        taggingID: access[k].taggingID,
                        SerialNo: access[k].SerialNo,
                        ModelNo: access[k].ModelNo,
                        BatchNo: access[k].BatchNo,
                        Quantity: access[k].Quantity,
                        AccessoriesName: access[k].AccessoriesName,
                        LicenceNo: access[k].LicenceNo,
                        ItemID: access[k].ItemID,
                    });
                }
                bindAssetDetailsTable(ItemID, row, NetQty, asset, batch,ItemName);
            });
        }
       
        var AssetStock = {
            dtAsset: [],
            dtAccessories:[],
        }
        var SearchAssetStockbyItemID = function (ItemID, callback) {
            serverCall('Services/AssetIssue.asmx/SearchAssetStockbyItemID', { ItemID: ItemID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }
        var bindAssetDetailsTable = function (ItemID, rowPrev, Qty, asset, batch,ItemName) {
            $table = $('#tblItemStock tbody.assetIndent');
            for (i = 0; i < Qty; i++) {
                var j = $($table).find('tr.IndentAssetRow').length + 1;
                var row = '<tr class="IndentAssetRow" id="tr_' + ItemID + '">';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdIndentItemName" class="GridViewLabItemStyle" style="text-align: center;">' + ItemName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><select class="ddlBatchno" class="requiredField" style="display:none"></select><span id="spnBatchno"></span></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><select class="ddlAssetno" class="requiredField" style="width:150px" onchange="searchOtherdetails(this,function(){})"></select><span id="spnAssetno" style="display:none"></span></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><select class="ddlModelno" class="requiredField" style="display:none"></select><span id="spnModelno"></span></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><select class="ddlSerialno" class="requiredField" style="display:none"></select><span id="spnSerialno"></span></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none"><span id="spnStockID"></span></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none"><span id="spnf_StockID"></span></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center; display:none"><span id="spnAssetID"></span></td>';
                row += '<td id="tdIndentItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + ItemID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">';
                row += '<img id="imghideindent" src="../../Images/showminus.png" onclick="hideIndentAccessories(this);" style="cursor:pointer;display:none" title="Click To Hide Accessories">';
                row += '<img id="imgshowindent" src="../../Images/showplus.png" onclick="showIndentAccessories(this);" style="cursor:pointer;display:none" title="Click To Show Accessories">';
                row += '</td>';
                row += '</tr>';
                $($table).append(row);
            }
            $($table).find('#tr_' + ItemID).find('.ddlAssetno').bindDropDown({ defaultValue: 'Select', data: asset, valueField: 'StockID', textField: 'AssetNo', isSearchAble: true });
        }

        var searchOtherdetails = function (elem, callback) {
            stockID = $(elem).val();
            var row = $(elem).closest('tr');
            var asset = AssetStock.dtAsset;
            $('.Access_' + $(row).find('#spnStockID').text()).remove();
            $('#tblItemStock tbody tr #spnStockID').each
            var isDuplicate = 0;

            if ($('#tblItemStock tbody tr #spnStockID').filter(function () { return ($(this).text().trim() == stockID) }).length > 0) {
                isDuplicate = 1;
            }
            if (isDuplicate == 1) {
                modelAlert('This Asset Already Seleted');
                return false;

            }

            $(asset).each(function (i, e) {
                if (e.StockID == stockID) {
                    $(row).find('#spnModelno').text(e.ModelNo);
                    $(row).find('#spnAssetno').text(e.AssetNo);
                    $(row).find('#spnBatchno').text(e.BatchNumber);
                    $(row).find('#spnSerialno').text(e.SerialNo);
                    $(row).find('#spnStockID').text(e.StockID);
                    $(row).find('#spnf_StockID').text(e.f_StockID);
                    $(row).find('#spnAssetID').text(e.AssetID);
                }
                else if (stockID==0) {
                    $(row).find('#spnModelno,#spnAssetno,#spnBatchno,#spnSerialno,#spnStockID,#spnf_StockID,#spnAssetID').text('');
                }
            });

            var accessories = AssetStock.dtAccessories;
            var AssetID = $(row).find('#spnAssetID').text();
            $(row).find('#imghideindent').hide();
            $(row).find('#imgshowindent').hide();
            //}
            //else {

            //}
            var accessoriesExist = 0;
            $(accessories).each(function (i, e) {
                if (e.AssetID == AssetID) {
                    bindAccessoriesDetailRow(row, e);
                    accessoriesExist++;
                }
            });
            if (accessoriesExist > 0) {
                $(row).find('#imghideindent').show();
            }
            callback();
        }

        var bindAccessoriesDetailRow = function (CurrRow, acccessories) {
            var AssetRow = $(CurrRow);
            var StockID = $(CurrRow).find('#spnStockID').text();
            var ItemID = $(CurrRow).find('#tdIndentItemID').text().trim();
            var row = '';
            var j = $('.Access_' + StockID + ' table tbody').find('tr').length + 1;
            if ($('.Access_' + StockID + ' table tbody').length < 1) {
                row += '<tr id="tr_'+ItemID+'" class="Access_' + StockID + '">';
                row += '<td class="GridViewLabItemStyle" colspan="2"></td>'
                row += '<td class="GridViewLabItemStyle" colspan="5">';
                row += '<table id="tblacc" style="width:100%" border-collapse: collapse; cellspacing="0" rules="all" border="1"><thead><tr>';
                row += '<th class="GridViewHeaderStyle" scope="col">Srno</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">AccessoriesName</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">ModelNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">SerialNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">BatchNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">LicenceNo</th>';
                row += '<th class="GridViewHeaderStyle" scope="col">Qty</th>';
                row += '</tr></thead>';
                row += '<tbody >';

                row += '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.AccessoriesName + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.ModelNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.SerialNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.BatchNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.LicenceNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">1</td>';
                row += '<td id="tdtaggedID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + acccessories.taggingID + '</td>';
                row += '<td id="tdaccessoriesID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + acccessories.AccessoriesID + '</td>';
                row += '</tr>';

                row += '</tbody>';
                row += '</table>';
                row += '</td>'
                row += '</tr>';
                AssetRow.after(row);
            }
            else {
                row += '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.AccessoriesName + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.ModelNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.SerialNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.BatchNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + acccessories.LicenceNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">1</td>';
                row += '<td id="tdtaggedID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + acccessories.taggingID + '</td>';
                row += '<td id="tdaccessoriesID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + acccessories.AccessoriesID + '</td>';
                row += '</tr>';

                $('.Access_' + StockID + ' table tbody tr').after(row);
            }
            
            
        }

        var showIndentAccessories = function (ctrl) {
            $(ctrl).closest('tr').find('#imgshowindent').hide();
            $(ctrl).closest('tr').find('#imghideindent').show();
            var stockID = $(ctrl).closest('tr').find('#spnStockID').text();
            $('.Access_' + stockID).show();
        }
        var hideIndentAccessories = function (ctrl) {
            $(ctrl).closest('tr').find('#imgshowindent').show();
            $(ctrl).closest('tr').find('#imghideindent').hide();
            var stockID = $(ctrl).closest('tr').find('#spnStockID').text();
            $('.Access_' + stockID).hide();
        }
    </script>



    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
            <div style="text-align: center">
                <b>Asset Issue</b><br />
                <input type="radio" name="rdoIssueType" checked="checked" value="1" onclick="hideandShow(this.value, function () { })" />Direct
                <input type="radio" name="rdoIssueType" value="2" onclick="hideandShow(this.value, function () { })" />Indent
                <asp:Label ID="lblDeptLedgerNo" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
            </div>
        </div>
        <div class="direct">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlIssueToDepartment" class="requiredField" tabindex="1"></select>
                        </div>
                        <div class="col-md-1"></div>
                        <div class="col-md-4">
                            <select id="ddlSearchtype" tabindex="2" onchange="onSearchTypeChange(this)">
                                <option value="1">Search By Asset Name</option>
                                <option value="2">Search By Batch No</option>
                                <option value="3">Search By Model No</option>
                                <option value="4">Search By Serial No</option>
                                <option value="5">Search By Asset No</option>
                            </select>
                        </div>
                        <div class="col-md-8 pull-left">
                            <input type="text" id="txtItemSearch" tabindex="3" class="easyui-combogrid requiredField" />
                        </div>
                        <div class="col-md-3">
                            <input type="button" id="btnAdd" value="Add" tabindex="4" onclick="AddAsset(event)" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="POuter_Box_Inventory divSelectedItems" style="display: none">
                <div class="Purchaseheader">
                    Added Asset Details
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <table id="tblSelectedItems" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr id="IssueItemHeader">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Item Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 120px;">Batch Number</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Model No</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Serial No</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Asset No</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Quantity</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="display: none">Stockid</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="display: none">ItemID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="display: none">DeptID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="display: none">AssetID</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">Remove</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">Accessories</th>
                                </tr>
                            </thead>
                            <tbody class="asset">
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="POuter_Box_Inventory divSelectedItems" style="display: none">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Taken By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtEmployeeName" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Narration</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" id="txtNarration" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div id="divSave" class="POuter_Box_Inventory" style="display: none; text-align: center">
                <div class="row">
                    <input type="button" id="btnDirectSave" value="Save" tabindex="4" onclick="SaveDirectIssue()" />
                </div>
            </div>
        </div>
        <div class="indent">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlReqDepartment" class="requiredField"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Indent No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtIndentNo" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus">
                                <option value="0">All</option>
                                <option value="1">Pending</option>
                                <option value="2">Issued</option>
                                <option value="3">Reject</option>
                                <option value="4">Partial</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <div class="row">
                    <input type="button" id="btnSearchIndent" value="Search" onclick="SearchIndent()" />
                </div>
            </div>
            <div class="POuter_Box_Inventory indentSearch">
                <div class="row">
                    <div class="col-md-6"></div>
                    <div class="col-md-3">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightblue;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Pending</b>
                    </div>
                    <div class="col-md-3">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90EE90;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Issued</b>
                    </div>
                    <div class="col-md-3">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightpink;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Rejected</b>
                    </div>
                    <div class="col-md-3">
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellow;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Partial</b>
                    </div>
                    <div class="col-md-6"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory indentSearch" style="max-height: 400px; overflow-x: auto">
                <table class="FixedHeader" id="tblSearchIndent" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                            <th class="GridViewHeaderStyle" style="width: 100px;">Date Time</th>
                            <th class="GridViewHeaderStyle" style="width: 150px;">Indent No</th>
                            <th class="GridViewHeaderStyle" style="width: 100px;">From Department</th>
                            <th class="GridViewHeaderStyle" style="width: 80px;">Type</th>
                            <th class="GridViewHeaderStyle" style="width: 30px;">Issue</th>
                            <th class="GridViewHeaderStyle" style="width: 30px;">Details</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
            <div class="POuter_Box_Inventory indentDetail" style="display:none">
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Indent No</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <span id="spnIndentNo" class="patientInfo"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">From Department</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <span id="spnFromDept" class="patientInfo"></span>
                                <span id="spnFromDeptID" style="display: none" class="patientInfo"></span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Req.DateTime</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <span id="spnDateTime" class="patientInfo"></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory indentDetail" style="display:none">
                <div class="row">
                    <div class="col-md-10">
                        <div class="Purchaseheader">
                            Item Details
                        </div>
                        <table class="FixedHeader" id="tblIndentItems" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">#</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">ItemName</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Req.Qty</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Is.Qty</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Rej.Qty</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">Avl.Qty</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">Remarks</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">#</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <div class="col-md-14">
                        <div class="Purchaseheader">
                            Stock Details
                        </div>
                        <table class="FixedHeader" id="tblItemStock" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">#</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">ItemName</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">BatchNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">AssetNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">ModelNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SerailNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">Access</th>
                                </tr>
                            </thead>
                            <tbody class="assetIndent"></tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory indentDetail"  style="display:none">
                <div class="row" style="text-align: center">
                    <input type="button" id="btnSaveIndentIssue" value="Save" onclick="SaveIndentIssue()" />
                </div>
            </div>
        </div>
    </div>



</asp:Content>
