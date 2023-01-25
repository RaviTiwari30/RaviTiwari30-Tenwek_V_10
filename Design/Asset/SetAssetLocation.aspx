<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetAssetLocation.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_Asset_SetAssetLocation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <link rel="Stylesheet" href="../../Styles/easyui.css" type="text/css" />

    <script type="text/javascript">
        $(document).ready(function () {
            bindDepartment(function (deptledgerno) {
                bindRoom(deptledgerno, function (roomid) {
                    bindCubical(roomid, function (cubicalid) {
                        bindLocation(roomid, cubicalid, function () {
                            SearchSetLocation(0, 0, 0, function () {
                                LoadAssetItems(function (callback) {
                                    $commonJsInit(function () {

                                    });
                                });
                            });
                        });
                    });
                });
            });
        });

        var bindDepartment = function (callback) {
            ddlDepartment = $('#ddlDepartment');
            deptLedgerNo = '<%=Session["deptLedgerNo"]%>';
            serverCall('Services/AssetIssue.asmx/BindAllDepartment', {}, function (response) {
                ddlDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true, selectedValue: deptLedgerNo });
                callback(ddlDepartment.val());
            });
        }

        var bindRoom = function (deptledgerno, callback) {
            ddlRoom = $('#ddlRoom');
            ddlSRoom = $('#ddlSRoom');
            $('#lblDeptLedgerNo').text(deptledgerno);
            var options = $('#txtItemSearch').combogrid('options');
            options.queryParams.DeptLedgerNo = deptledgerno;
            serverCall('Services/InfrastructureMaster.asmx/bindRoom', { CentreID: 0, BlockID: 0, BuildingID: 0, FloorID: 0, RoomTypeID: 0, DeptLedgerNo: deptledgerno }, function (response) {
                ddlRoom.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoomName', isSearchAble: true });
                ddlSRoom.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'RoomName', isSearchAble: true });
                callback(ddlRoom.val());
            });
        }
        var bindCubical = function (RoomID, callback) {
            ddlCubical = $('#ddlCubical');
            ddlSCubical = $('#ddlSCubical');
            serverCall('Services/InfrastructureMaster.asmx/bindCubical', { CentreID: 0, BlockID: 0, BuildingID: 0, FloorID: 0, RoomID: RoomID, RoomTypeID: 0 }, function (response) {
                ddlCubical.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'CubicalName', isSearchAble: true });
                ddlSCubical.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'CubicalName', isSearchAble: true });
                bindLocation(RoomID, 0, function () { });
                callback(ddlCubical.val());
            });
        }
        var bindLocation = function (RoomID, CubicalID, callback) {
            ddlLocation = $('#ddlLocation');
            ddlSLocation = $('#ddlSLocation');
            serverCall('Services/InfrastructureMaster.asmx/bindMappedLocationMaster', { RoomID: RoomID, CubicalID: CubicalID }, function (response) {
                ddlLocation.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LocationID', textField: 'LocationName', isSearchAble: true });
                ddlSLocation.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'LocationID', textField: 'LocationName', isSearchAble: true });
                callback(ddlLocation.val());
            });
        }

        var LoadAssetItems = function (callback) {
            try {
                getComboGridOption(function (response) {

                    $('#txtItemSearch').combogrid(response);

                    callback(true);
                });
            } catch (e) {

            }
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
                    isAssetLocation:'1',
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

        var onSearchTypeChange = function (elem) {
            try {
                var options = $('#txtItemSearch').combogrid('options');
                options.queryParams.SearchBy = elem.value;
            } catch (e) {

            }
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
                DeptLedgerNo: $('#ddlDepartment').val(),
                DeptName: $('#ddlDepartment option:selected').text(),
                RoomID: $('#ddlRoom').val(),
                RoomName: $('#ddlRoom option:selected').text(),
                CubcalID: $('#ddlCubical').val(),
                CubcalName: $('#ddlCubical option:selected').text(),
                LocationID: $('#ddlLocation').val(),
                LocationName: $('#ddlLocation option:selected').text(),
            }
            //if (data.DeptLedgerNo == '0') {
            //    modelAlert('Please Select Department', function () {
            //        $('#ddlDepartment').focus();
            //    });
            //    return;
            //}
            //if (data.RoomID == '0') {
            //    modelAlert('Please Select Room', function () {
            //        $('#ddlRoom').focus();
            //    });
            //    return;
            //}
            //if (data.LocationID == '0') {
            //    modelAlert('Please Select Location', function () {
            //        $('#ddlLocation').focus();
            //    });
            //    return;
            //}




            validateDuplicateSelection(data, function (setID) {
                bindItem(data, setID, function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtItemSearch.combogrid('reset');
                });
            });

            if (code == 9 && e.target.type == 'text') {
                $(this).parent().find('input[type=button]').focus();
            }

        }
        var validateDuplicateSelection = function (data, callback) {
            var alreadySelectBool = $('#tr_' + data.StockID).length > 0 ? true : false;
            if (alreadySelectBool) {
                modelAlert('Item Already Added', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtItemSearch.combogrid('reset');
                });
                return false;
            }
            else {
                serverCall('Services/SetAssetLocation.asmx/ValidateDuplicateAssetLocation', { AssetID: data.AssetID }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        callback(responseData.SetID);
                    }
                    else {
                        modelConfirmation('Are You Sure !!! ', data.ItemName + ' Already Set at <br/>' + responseData.response + '<br/> Do you want to delete from this location', 'Continue', 'Cancel', function (response) {
                            if (response) {
                                callback(responseData.SetID);
                            }
                            else
                                return false;
                        });
                    }
                });
            }

        }
        var bindItem = function (data, setID, callback) {
            getAccessoriesDetails(data, function (acccessories) {
                addAssetNewRow(data, setID, acccessories, function () {

                });
            });
        }
        var getAccessoriesDetails = function (data, callback) {
            serverCall('Services/WebService.asmx/bindtaggesAccessories', { GRNNo: '', ItemID: '', AssetID: data.AssetID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }

        addAssetNewRow = function (data, setID, acccessories, callback) {
            var table = $('#tblSelectedItems tbody.asset');
            var j = $(table).find('tr.assetRow').length + 1;
            var row = '<tr class="assetRow tr_' + data.StockID + '" id="tr_' + data.StockID + '">';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
            row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data.ItemName + '</td>';
            row += '<td id="tdBatchNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.BatchNo + '</td>';
            row += '<td id="tdModelNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.ModelNo + '</td>';
            row += '<td id="tdSerialNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.SerialNo + '</td>';
            row += '<td id="tdAssetNo" class="GridViewLabItemStyle" style="text-align: center;">' + data.AssetNo + '</td>';
            row += '<td id="tdRoomName" class="GridViewLabItemStyle" style="text-align: center;">' + data.RoomName + '</td>';
            row += '<td id="tdCubicalName" class="GridViewLabItemStyle" style="text-align: center;">' + data.CubcalName + '</td>';
            row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;">' + data.LocationName + '</td>';
            row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgRmv" src="../../Images/Delete.gif" onclick="removeAsset(this);" style="cursor:pointer;" title="Click To Remove"></td>';
            if (acccessories.length > 0)
                row += '<img id="imghide" src="../../Images/showminus.png" onclick="hideAccessories(this);" style="cursor:pointer;" title="Click To Hide Accessories">';
            row += '<img id="imgshow" src="../../Images/showplus.png" onclick="showAccessories(this);" style="cursor:pointer;display:none" title="Click To Show Accessories">';
            row += '<td id="tdAssetID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.AssetID + '</td>';
            row += '<td id="tdStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.StockID + '</td>';
            row += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.ItemID + '</td>';
            row += '<td id="tdf_StockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.f_StockID + '</td>';
            row += '<td id="tdDeptledgerNo" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.DeptLedgerNo + '</td>';
            row += '<td id="tdRoomID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.RoomID + '</td>';
            row += '<td id="tdCubicalID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.CubcalID + '</td>';
            row += '<td id="tdLocationID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data.LocationID + '</td>';
            row += '<td id="tdSetID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + setID + '</td>';
            row += '</tr>';
            if (acccessories.length > 0) {
                row += '<tr class="Access_' + data.StockID + '">';
                row += '<td class="GridViewLabItemStyle" colspan="5"></td>'
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

        var Save = function () {
            getAddedLocationDetails(function (data) {
                serverCall('Services/SetAssetLocation.asmx/SaveAssetLocation', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            window.location.reload();
                        });
                    } else {
                        modelAlert(responseData.response, function () { });
                    }
                });
            });
        }
        var getAddedLocationDetails = function (callback) {
            var Setlocation = [];
            var $table = $('#tblSelectedItems tbody tr.assetRow');
            $($table).each(function (i, e) {
                Setlocation.push({
                    AssetID: $(e).find('#tdAssetID').text().trim(),
                    ItemName: $(e).find('#tdItemName').text().trim(),
                    BatchNo: $(e).find('#tdBatchNo').text().trim(),
                    ModelNo: $(e).find('#tdModelNo').text().trim(),
                    SerialNo: $(e).find('#tdSerialNo').text().trim(),
                    AssetNo: $(e).find('#tdAssetNo').text().trim(),
                    StockID: $(e).find('#tdStockID').text().trim(),
                    ItemID: $(e).find('#tdItemID').text().trim(),
                    f_StockID: $(e).find('#tdf_StockID').text().trim(),

                    DeptLedgerNo: $(e).find('#tdDeptledgerNo').text().trim(),
                    RoomID: $(e).find('#tdRoomID').text().trim(),
                    CubicalID: $(e).find('#tdCubicalID').text().trim(),
                    LocationID: $(e).find('#tdLocationID').text().trim(),
                    SetID: $(e).find('#tdSetID').text().trim(),
                });
            });
            if (Setlocation.length <= 0) {
                modelAlert('Please Add Any Asset');
                return false;
            }
            callback({ Setlocation: Setlocation });
        }

        var SearchSetLocation = function (roomID, cubicalID, locationID, callback) {
            data = {
                deptledgerNo: $('#ddlDepartment').val(),
                roomID: roomID,
                cubicalID: cubicalID,
                locationID: locationID,
            }
            serverCall('Services/SetAssetLocation.asmx/SearchSetLocationDetails', data, function (response) {
                var responseData = JSON.parse(response);
                bindSearchDetail(responseData);
            });
            callback(true);
        }
        var bindSearchDetail = function (data) {
            var table = $('#tblSearch tbody');
            $(table).empty();
            for (i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetName + '</td>';
                row += '<td id="tdBatchNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BatchNumber + '</td>';
                row += '<td id="tdModelNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ModelNo + '</td>';
                row += '<td id="tdSerialNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SerialNo + '</td>';
                row += '<td id="tdAssetNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetNo + '</td>';
                row += '<td id="tdRoomName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RoomName + '</td>';
                row += '<td id="tdCubicalName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CubicalName + '</td>';
                row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LocationName + '</td>';
                row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].createdby + '</td>';
                row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDate + '</td>';
                if (data[i].isInstallationDone == '1')
                    row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;"><span style="cursor:pointer;color:white;background-color:green;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="EnterInstallationDate(this);">I</span></td>';
                else
                    row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;"><span style="cursor:pointer;color:white;background-color:red;font-size:15px;padding-left:5px;padding-right:5px;border-radius:150px;" onclick="EnterInstallationDate(this);">I</span></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgRmv" src="../../Images/Edit.png" onclick="EditAssetLocation(this);" style="cursor:pointer;" title="Click To Edit"></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteAssetLocation(this);" style="cursor:pointer;" title="Click To Remove"></td>';
                row += '<td id="tdSetID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SetID + '</td>';
                row += '<td id="tdStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].StockID + '</td>';
                row += '<td id="tdLocationID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].LocationID + '</td>';
                row += '<td id="tdRoomID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].RoomID + '</td>';
                row += '<td id="tdCubicalID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CubicalID + '</td>';
                row += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '<td id="tdAssetID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].AssetID + '</td>';
                row += '<td id="tdInstallationDate" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].InstallationDate + '</td>';
                row += '<td id="tdInstallationBy" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].InstallationBy + '</td>';
                row += '<td id="tdInstallationRemarks" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].InstallationRemarks + '</td>';
                row += '<td id="tdisInstallationDone" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].isInstallationDone + '</td>';
                row += '</tr>';
                $(table).append(row);
            }

        }

        var DeleteAssetLocation = function (rowID) {
            var row = $(rowID).closest('tr');
            var SetID = $(row).find('#tdSetID').text().trim();
            $('#spnSetID').text(SetID);
            $('#divDelete').showModel();
        }

        var DeleteMapping = function (data) {
            if (String.isNullOrEmpty(data.Remarks)) {
                modelAlert('Please Enter Remarks');
                return false;
            }
            serverCall('Services/SetAssetLocation.asmx/DeleteAssetLocation', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    SearchSetLocation($('#ddlSRoom').val(), $('#ddlSCubical').val(), $('#ddlSLocation').val(), function () {
                        LoadAssetItems(function (callback) {
                            $commonJsInit(function () {
                                $('#divDelete').closeModel();
                            });
                        });
                    });
                });
            });
        }
        var EditAssetLocation = function (rowID) {
            var row = $(rowID).closest('tr');
            var SetID = $(row).find('#tdSetID').text().trim();
            var RoomID = $(row).find('#tdRoomID').text().trim();
            var CubicalID = $(row).find('#tdCubicalID').text().trim();
            var LocationID = $(row).find('#tdLocationID').text().trim();

            $('#spnAssetSetID').text(SetID);

            $('.divEditItems').show();
            $('.divSelectedItems').hide();
            $('#divSave').hide();
            $('.textbox-text.validatebox-text,#btnAdd').prop('disabled', true);

            $('#ddlRoom').val(RoomID).change().chosen("destroy").chosen();
            $('#ddlCubical').val(CubicalID).change().chosen("destroy").chosen();
            $('#ddlLocation').val(LocationID).chosen("destroy").chosen();

            $('#spnAssetName').text($(row).find('#tdItemName').text().trim());
            $('#spnBatchNo').text($(row).find('#tdBatchNo').text().trim());
            $('#spnModelNo').text($(row).find('#tdModelNo').text().trim());
            $('#spnSerialNo').text($(row).find('#tdSerialNo').text().trim());
            $('#spnAssetNo').text($(row).find('#tdAssetNo').text().trim());

        }

        var Clear = function () {
            $('.divEditItems').hide();
            $('.textbox-text.validatebox-text,#btnAdd').prop('disabled', false);
            $('#spnAssetSetID').text('');
        }

        var Update = function () {
            var data = {
                roomID: $('#ddlRoom').val(),
                cubicalID: $('#ddlCubical').val(),
                locationID: $('#ddlLocation').val(),
                setID: $('#spnAssetSetID').text(),
                DeptLedgerNo: $('#ddlDepartment').val(),
            }
            if (data.roomID == '0') {
                modelAlert('Please Select Room');
                return false;
            }
            if (data.locationID == '0') {
                modelAlert('Please Select Location');
                return false;
            }
            serverCall('Services/SetAssetLocation.asmx/UpdateAssetLocation', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    Clear();
                    SearchSetLocation($('#ddlSRoom').val(), $('#ddlSCubical').val(), $('#ddlSLocation').val(), function () { });
                });
            });
        }

        var EnterInstallationDate = function (rowID) {
            var row = $(rowID).closest('tr');
            var AssetID = $(row).find('#tdAssetID').text().trim();

            $('#divInstallationDate').showModel();
            $('#spnAssetID').text(AssetID);
            if ($(row).find('#tdisInstallationDone').text().trim() == '1') {
                $('#txtInstallationDate').val($(row).find('#tdInstallationDate').text().trim());
                $('#txtInstallBy').val($(row).find('#tdInstallationBy').text().trim());
                $('#txtInstallationRemarks').val($(row).find('#tdInstallationRemarks').text().trim());
            }
        }
        var saveInstallationDetails = function (dtl) {
            if (String.isNullOrEmpty(dtl.By)) {
                modelAlert('Please Enter Installation By Name');
                return false;
            }
            serverCall('Services/WarrantyAMC.asmx/SaveInstallationDetails', dtl, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        SearchSetLocation($('#ddlSRoom').val(), $('#ddlSCubical').val(), $('#ddlSLocation').val(), function () {
                            $('#divInstallationDate').closeModel();
                        });
                    });
                } else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Set Asset Location</b>
                <span id="lblDeptLedgerNo" style="display: none"></span>
                <span id="spnAssetSetID" style="display: none"></span>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Department </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDepartment" onchange="bindRoom(this.value,function(){})" disabled="disabled"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Rooms </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlRoom" onchange="bindCubical(this.value,function(){});" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Cubicals </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCubical" onchange="bindLocation($('#ddlRoom').val(),this.value,function(){})" class="requiredField"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Location </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlLocation" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <div class="pull-left">
                                <select id="ddlSearchtype" tabindex="2" onchange="onSearchTypeChange(this)" title="Select to Search by">
                                    <option value="1">Asset Name</option>
                                    <option value="2">Batch No</option>
                                    <option value="3">Model No</option>
                                    <option value="4">Serial No</option>
                                    <option value="5">Asset No</option>
                                </select>
                            </div>
                            <div>
                                <b class="pull-right">:</b>
                            </div>
                        </div>
                        <div class="col-md-8 pull-left">
                            <input type="text" id="txtItemSearch" tabindex="3" class="easyui-combogrid requiredField" />
                        </div>
                        <div class="col-md-3 pull-right">
                            <input type="button" id="btnAdd" value="Add" tabindex="4" onclick="AddAsset(event)" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory divSelectedItems" style="display: none">
            <div class="Purchaseheader">
                Added Location of Asset
            </div>
            <div class="row">
                <table id="tblSelectedItems" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Item Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">BatchNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">ModelNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">SerialNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">AssetNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">RoomName</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">CubicalName</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Location</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">#</th>
                        </tr>
                    </thead>
                    <tbody class="asset">
                    </tbody>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory divEditItems" style="display: none">
            <div class="Purchaseheader">
                Edit Location of Asset
            </div>
            <div class="row">
                <div class="col-md-1">
                </div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Asset Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <b><span id="spnAssetName" class="patientInfo"></span></b>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Asset No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <b><span id="spnAssetNo" class="patientInfo"></span></b>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Batch No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <b><span id="spnBatchNo" class="patientInfo"></span></b>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Model No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <b><span id="spnModelNo" class="patientInfo"></span></b>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Serial No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <b><span id="spnSerialNo" class="patientInfo"></span></b>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row" style="text-align: center">
                <input type="button" id="btnUpdate" value="Update" onclick="Update()" />
                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />
            </div>
        </div>
        <div id="divSave" class="POuter_Box_Inventory" style="display: none; text-align: center">
            <div class="row">
                <input type="button" id="btnSaveMapping" value="Save" tabindex="4" onclick="Save()" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Previous Set Asset Location Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Rooms </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSRoom" onchange="bindCubical(this.value,function(){}); SearchSetLocation(this.value,0,0,function(){})" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Cubicals </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSCubical" onchange="bindLocation($('#ddlSRoom').val(),this.value,function(){});SearchSetLocation($('#ddlSRoom').val(),this.value,0,function(){})" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Location </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSLocation" class="requiredField" onchange="SearchSetLocation($('#ddlSRoom').val(),$('#ddlSCubical').val(),this.value,function(){})"></select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <table id="tblSearch" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Item Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">BatchNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">ModelNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">SerialNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">AssetNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">RoomName</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">CubicalName</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Location</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">CreatedBy</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">CreatedDate</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;"></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;"></th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="divInstallationDate" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 875px; height: 225px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divInstallationDate" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Enter Installation Detail</h4>
                    <span id="spnAssetID" style="display: none"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Installation Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:TextBox ID="txtInstallationDate" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtInstallationDate"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Installation By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <input type="text" id="txtInstallBy" maxlength="50" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <textarea id="txtInstallationRemarks" maxlength="100" style="margin: 0px; width: 306px; height: 166px; max-height: 80px; max-width: 270px;"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="saveInstallationDetails({Date:$('#txtInstallationDate').val().trim(),By:$('#txtInstallBy').val().trim(),Remarks:$('#txtInstallationRemarks').val().trim(),AssetID:$('#spnAssetID').text().trim()})">Save</button>
                    <button type="button" data-dismiss="divInstallationDate">Close</button>
                </div>
            </div>
        </div>
    </div>

     <div id="divDelete" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 300px; height: 200px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divDelete" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Enter Delete Remarks</h4>
                    <span id="spnSetID" style="display:none"></span>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <textarea id="txtDeleteRemarks" maxlength="100" style="margin: 0px; width: 306px; height: 166px; max-height: 80px; max-width: 270px;" placeholder="Enter Remarks" class="requiredField"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="DeleteMapping({setID:$('#spnSetID').text().trim(),Remarks:$('#txtDeleteRemarks').val().trim()})">Save</button>
                    <button type="button" data-dismiss="divDelete">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
