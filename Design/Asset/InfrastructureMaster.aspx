<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="InfrastructureMaster.aspx.cs" Inherits="Design_Asset_InfrastructureMaster" %>

<asp:Content ID="c1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        #show input[type=button]
        {
            width: 100px !important;
            font-size: large !important;
        }

        .CurrentButton
        {
            background-color: #31c531 !important;
        }

        .divCentre
        {
            text-align: center;
        }

        .hidden
        {
            display: none;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            bindCentre(function (CentreID) {
                bindBlock(CentreID, function (BlockID) {
                    bindBuilding(CentreID, BlockID, function (BuildingID) {
                        bindFloor(function (f) {
                            bindFloorMappedWithBuilding(BuildingID, function (FloorID) {
                                bindRoomType(function () {
                                    bindDepartment(function (DeptLedgerNo) {
                                        bindRoom(CentreID, BlockID, BuildingID, FloorID,DeptLedgerNo, function (RoomID) {
                                            bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, function (CubicalID) {


                                            });
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        });
        var bindCentre = function (callback) {
            ddlCentre = $('#ddlCentre');
            serverCall('../Common/CommonService.asmx/BindAllCentre', {}, function (response) {
               // ddlCentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
               // Saurabh For now i passing centre id 1 for testing.
			    ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: '1' });
                callback(ddlCentre.val());
            });
        }
        var bindBlock = function (CentreID, callback) {
            ddlBBlock = $('#ddlBBlock');
            ddlFBlock = $('#ddlFBlock');
            ddlRBlock = $('#ddlRBlock');
            ddlCBlock = $('#ddlCBlock');
            serverCall('Services/InfrastructureMaster.asmx/bindBlock', { CentreID: CentreID }, function (response) {
                ddlBBlock.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BlockName', isSearchAble: true });
                ddlFBlock.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BlockName', isSearchAble: true });
                ddlRBlock.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BlockName', isSearchAble: true });
                ddlCBlock.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BlockName', isSearchAble: true });
                callback(ddlBBlock.val());
            });
        }
        var bindBuilding = function (CentreID, BlockID, callback) {
            data = {
                CentreID: CentreID,
                BlockID: BlockID
            }
            ddlFBuilding = $('#ddlFBuilding');
            ddlRBuilding = $('#ddlRBuilding');
            ddlCBuilding = $('#ddlCBuilding');
            serverCall('Services/InfrastructureMaster.asmx/bindBuilding', data, function (response) {
                ddlFBuilding.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BuildingName', isSearchAble: true });
                ddlRBuilding.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BuildingName', isSearchAble: true });
                ddlCBuilding.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BuildingName', isSearchAble: true });
                callback(ddlFBuilding.val());
            });
        }
        var bindFloor = function (callback) {
            ddlFloor = $('#ddlFloor');
            serverCall('Services/InfrastructureMaster.asmx/bindFloor', {}, function (response) {
                ddlFloor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'NAME', isSearchAble: true });
                callback(ddlFloor.val());
            });
        }
        var bindFloorMappedWithBuilding = function (BuildingID, callback) {
            ddlRFloor = $('#ddlRFloor');
            ddlCFloor = $('#ddlCFloor');
            serverCall('Services/InfrastructureMaster.asmx/bindFloorMappedWithBuilding', { BuildingID: BuildingID }, function (response) {
                ddlRFloor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'FloorID', textField: 'FloorName', isSearchAble: true });
                ddlCFloor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'FloorID', textField: 'FloorName', isSearchAble: true });
                callback(ddlRFloor.val());
            });
        }
        var bindRoomType = function (callback) {
            ddlRoomType = $('#ddlRoomType');
            ddlCRoomType = $('#ddlCRoomType');
            serverCall('Services/InfrastructureMaster.asmx/bindRoomType', { }, function (response) {
                ddlRoomType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoomTypeName', isSearchAble: true });
                ddlCRoomType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoomTypeName', isSearchAble: true });
                callback(ddlRoomType.val());
            });
        }
        var bindRoom = function (CentreID, BlockID, BuildingID, FloorID,DeptLedgerNo, callback) {
            ddlCRoom = $('#ddlCRoom');
            serverCall('Services/InfrastructureMaster.asmx/bindRoom', { CentreID: CentreID, BlockID: BlockID, BuildingID: BuildingID, FloorID: FloorID,RoomTypeID:'0',DeptLedgerNo:'0' }, function (response) {
                ddlCRoom.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoomName', isSearchAble: true });
            });
            callback(ddlCRoom.val());
        }
        var bindCubical = function (CentreID, BlockID, BuildingID, FloorID, RoomID, callback) {
            //ddlCentre = $('#ddlCentre');
            //serverCall('../Common/CommonService.asmx/LoadCentre', {}, function (response) {
            //    ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
            //    callback(ddlCentre.val());
            //});
            callback();
        }
        var bindDepartment = function (callback) {
            ddlDepartment = $('#ddlDepartment');
            serverCall('Services/AssetIssue.asmx/BindAllDepartment', {}, function (response) {
                ddlDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
                callback(ddlDepartment.val());
            });
        }

        //--------Block Save Start---------
        var showBlockDiv = function () {
            ValidateCentre(function () {
                HideandShow('block', function () {
                    loadBlockDetail(function () {
                        ClearControls('block');
                    });
                });
            });
        }

        var SaveBlocks = function () {
            data = {
                BlockName: $('#txtBlockName').val().trim(),
                IsActive: $('input[name=rdoBlockActive]:checked').val(),
                BlockID: $('#spnBlockID').text().trim(),
                CentreID: $('#ddlCentre').val(),
            }
            if (String.isNullOrEmpty(data.BlockName)) {
                modelAlert('Please Enter Block', function () {
                    $('#txtBlockName').focus();
                });
                return false;
            }
            serverCall('Services/InfrastructureMaster.asmx/SaveBlocks', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        loadBlockDetail(function () {
                            ClearControls('block');
                        });
                    });
                }
                else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }
        var loadBlockDetail = function (callback) {
            CentreID = $('#ddlCentre').val();
            serverCall('Services/InfrastructureMaster.asmx/loadBlockDetails', { CentreID: CentreID }, function (response) {
                var responseData = JSON.parse(response);
                bindBlockDetail(responseData);
            });
            callback();
        }
        var bindBlockDetail = function (data) {
            var table = $('.block table tbody');
            $(table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CentreName + '</td>';
                row += '<td id="tdb_BlockName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BlockName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ActiveStatus + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].UpdatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditBlock(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdb_BlockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BlockID + '</td>';
                row += '<td id="tdb_Active" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '<td id="tdb_CentreID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CentreID + '</td>';
                row += '</tr>';
                $(table).append(row);
            }
        }
        var EditBlock = function (rowID) {
            var row = $(rowID).closest('tr');
            $('#ddlCentre').val($(row).find('#tdb_CentreID').text().trim()).change().chosen("destroy").chosen();
            $('#txtBlockName').val($(row).find('#tdb_BlockName').text().trim());
            $('input[name=rdoBlockActive][value=' + $(row).find('#tdb_Active').text().trim() + ']').prop('checked', true);
            $('#btnSaveBlock').val('Update');
            $('#spnBlockID').text($(row).find('#tdb_BlockID').text().trim());
        }
        //--------Block End---------

        //------Building Save Start---------
        var showBuildingDiv = function () {
            ValidateCentre(function () {
                HideandShow('building', function () {
                    loadBuildingDetail(0, function () {
                        ClearControls('building');
                    });
                });
            });
        }
        var SaveBuilding = function () {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlBBlock').val().trim(),
                BuildingName: $('#txtBuildingName').val().trim(),
                IsActive: $('input[name=rdoBuildingActive]:checked').val(),
                BuildingID: $('#spnBuildingID').text().trim(),
            }
            if (data.BlockID == "0") {
                modelAlert('Please Select Block', function () {
                    $('#ddlBBlock').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data.BuildingName)) {
                modelAlert('Please Enter Building Name', function () {
                    $('#txtBlockName').focus();
                });
                return false;
            }
            serverCall('Services/InfrastructureMaster.asmx/SaveBuilding', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        loadBuildingDetail(data.BlockID, function () {
                            ClearControls('building');
                        });
                    });
                }
                else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }
        var loadBuildingDetail = function (BlockID, callback) {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlBBlock').val(),
            }
            serverCall('Services/InfrastructureMaster.asmx/loadBuildingDetail', data, function (response) {
                var responseData = JSON.parse(response);
                bindBuildingDetail(responseData);
            });
            callback(true);
        }

        var bindBuildingDetail = function (data) {
            var table = $('.building table tbody');
            $(table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CentreName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BlockName + '</td>';
                row += '<td id="tdBuildingName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BuildingName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ActiveStatus + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].UpdatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditBuilding(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdbd_BuildingID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BuildingID + '</td>';
                row += '<td id="tdbd_BlockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BlockID + '</td>';
                row += '<td id="tdbd_CentreID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CentreID + '</td>';
                row += '<td id="tdbd_Active" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '</tr>';
                $(table).append(row);
            }
        }

        var EditBuilding = function (rowID) {
            var row = $(rowID).closest('tr');
            $('#ddlCentre').val($(row).find('#tdbd_CentreID').text().trim()).change().chosen("destroy").chosen();
            $('#ddlBBlock').val($(row).find('#tdbd_BlockID').text().trim()).change().chosen("destroy").chosen();
            $('#txtBuildingName').val($(row).find('#tdBuildingName').text().trim());
            $('input[name=rdoBuildingActive][value=' + $(row).find('#tdbd_Active').text().trim() + ']').prop('checked', true);
            $('#btnSaveBuilding').val('Update');
            $('#spnBuildingID').text($(row).find('#tdbd_BuildingID').text().trim());
        }

        //-------Building End-----------

        //-------Floor Map with Building Start------
        var showFloorDiv = function () {
            ValidateCentre(function () {
                HideandShow('floor', function () {
                    loadFloorDetail(0, 0, function () {
                        ClearControls('floor');
                    });
                });
            });
        }
        var SaveFloorBuildingMapping = function () {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlFBlock').val().trim(),
                BuildingID: $('#ddlFBuilding').val().trim(),
                FloorID: $('#ddlFloor').val(),
                FloorName: $('#ddlFloor option:selected').text(),
            }
            if (data.BlockID == "0") {
                modelAlert('Please Select Block', function () {
                    $('#ddlFBlock').focus();
                });
                return false;
            }
            if (data.BuildingID == "0") {
                modelAlert('Please Select Building', function () {
                    $('#ddlFBuilding').focus();
                });
                return false;
            }
            if (data.FloorID == "0") {
                modelAlert('Please Select Floor', function () {
                    $('#ddlFloor').focus();
                });
                return false;
            }
            serverCall('Services/InfrastructureMaster.asmx/SaveFloorBuildingMapping', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        loadFloorDetail(data.BlockID, data.BuildingID, function () {
                            ClearControls('floor');
                        });
                    });
                }
                else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }

        var loadFloorDetail = function (BlockID, BuildingID, callback) {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlFBlock').val(),
                BuildingID: $('#ddlFBuilding').val()
            }
            serverCall('Services/InfrastructureMaster.asmx/loadFloorMappingDetail', data, function (response) {
                var responseData = JSON.parse(response);
                bindFloorDetail(responseData);
            });
            callback(true);
        }
        var bindFloorDetail = function (data) {
            var table = $('.floor table tbody');
            $(table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CentreName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BlockName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BuildingName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FloorName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/Delete.gif" onclick="EditFloor(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdf_MappingID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].MappingID + '</td>';
                row += '</tr>';
                $(table).append(row);
            }
        }
        var EditFloor = function (rowID) {
            var row = $(rowID).closest('tr');
            var MappingID = $(row).find('#tdf_MappingID').text().trim();
            serverCall('Services/InfrastructureMaster.asmx/UpdateFloorMapping', { MappingID: MappingID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        loadFloorDetail(data.BlockID, data.BuildingID, function () {
                            ClearControls('floor');
                        });
                    });
                }
                else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }
        //-------Floor Map with Building END ------

        //-------Room Start-----
        var showRoomDiv = function () {
            ValidateCentre(function () {
                HideandShow('room', function () {
                    loadRoomDetail(0, 0, 0, function () {
                        ClearControls('room');
                    });
                });
            });
        }
        var SaveRoom = function () {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlRBlock').val().trim(),
                BuildingID: $('#ddlRBuilding').val().trim(),
                FloorID: $('#ddlRFloor').val(),
                RoomName: $('#txtRoomName').val().trim(),
                IsActive: $('input[name=rdoRoomActive]:checked').val(),
                RoomID: $('#spnRoomID').text().trim(),
                RoomTypeID: $('#ddlRoomType').val(),
                DeptLedgerNo: $('#ddlDepartment').val(),
            }
            if (data.BlockID == "0") {
                modelAlert('Please Select Block', function () {
                    $('#ddlRBlock').focus();
                });
                return false;
            }
            if (data.BuildingID == "0") {
                modelAlert('Please Select Building', function () {
                    $('#ddlRBuilding').focus();
                });
                return false;
            }
            if (data.FloorID == "0") {
                modelAlert('Please Select Floor', function () {
                    $('#ddlRFloor').focus();
                });
                return false;
            }
            if (data.RoomTypeID == "0") {
                modelAlert('Please Select RoomType', function () {
                    $('#ddlRoomType').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data.RoomName)) {
                modelAlert('Please Enter Room Name', function () {
                    $('#txtRoomName').focus();
                });
                return false;
            }
            serverCall('Services/InfrastructureMaster.asmx/SaveRoom', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        loadRoomDetail(data.BlockID, data.BuildingID, data.FloorID, function () {
                            ClearControls('room');
                        });
                    });
                }
                else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }

        var loadRoomDetail = function (BlockID, BuildingID, FloorID, callback) {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlRBlock').val(),
                BuildingID: $('#ddlRBuilding').val(),
                FloorID: $('#ddlRFloor').val(),
            }
            serverCall('Services/InfrastructureMaster.asmx/loadRoomDetail', data, function (response) {
                var responseData = JSON.parse(response);
                bindRoomDetail(responseData);
            });
            callback(true);
        }

        var bindRoomDetail = function (data) {
            var table = $('.room table tbody');
            $(table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CentreName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BlockName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BuildingName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FloorName + '</td>';
                row += '<td id="tdRoomName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RoomName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ActiveStatus + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].UpdatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditRoom(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdr_RoomID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].RoomID + '</td>';
                row += '<td id="tdr_FloorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].FloorID + '</td>';
                row += '<td id="tdr_BuildingID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BuildingID + '</td>';
                row += '<td id="tdr_BlockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BlockID + '</td>';
                row += '<td id="tdr_CentreID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CentreID + '</td>';
                row += '<td id="tdr_Active" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '</tr>';
                $(table).append(row);
            }
        }

        var EditRoom = function (rowID) {
            var row = $(rowID).closest('tr');
            $('#ddlCentre').val($(row).find('#tdr_CentreID').text().trim()).change().chosen("destroy").chosen();
            $('#ddlRBlock').val($(row).find('#tdr_BlockID').text().trim()).change().chosen("destroy").chosen();
            $('#ddlRBuilding').val($(row).find('#tdr_BuildingID').text().trim()).change().chosen("destroy").chosen();
            $('#ddlRFloor').val($(row).find('#tdr_FloorID').text().trim()).chosen("destroy").chosen();
            $('#txtRoomName').val($(row).find('#tdRoomName').text().trim());
            $('input[name=rdoRoomActive][value=' + $(row).find('#tdr_Active').text().trim() + ']').prop('checked', true);
            $('#btnSaveRoom').val('Update');
            $('#spnRoomID').text($(row).find('#tdr_RoomID').text().trim());
        }
        //-------Room END------

        //-------Cubical Start-------

        var showCubicalDiv = function () {
            ValidateCentre(function () {
                HideandShow('cubical', function () {
                    loadCubicalDetail(0, 0, 0, 0, function () {
                        ClearControls('cubical');
                    });
                });
            });
        }
        var SaveCubical = function () {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlCBlock').val().trim(),
                BuildingID: $('#ddlCBuilding').val().trim(),
                FloorID: $('#ddlCFloor').val(),
                RoomID: $('#ddlCRoom').val(),
                CubicalName: $('#txtCubicalName').val().trim(),
                IsActive: $('input[name=rdoCubicalActive]:checked').val(),
                CubicalID: $('#spnCubicalID').text().trim(),
                RoomTypeID: $('#ddlCRoomType').val(),
            }
            if (data.BlockID == "0") {
                modelAlert('Please Select Block', function () {
                    $('#ddlCBlock').focus();
                });
                return false;
            }
            if (data.BuildingID == "0") {
                modelAlert('Please Select Building', function () {
                    $('#ddlCBuilding').focus();
                });
                return false;
            }
            if (data.FloorID == "0") {
                modelAlert('Please Select Floor', function () {
                    $('#ddlCFloor').focus();
                });
                return false;
            }
            if (data.RoomTypeID == "0") {
                modelAlert('Please Select RoomType', function () {
                    $('#ddlCRoomType').focus();
                });
                return false;
            }
            if (data.RoomID == "0") {
                modelAlert('Please Select Room', function () {
                    $('#ddlCRoom').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data.CubicalName)) {
                modelAlert('Please Enter Cubical Name', function () {
                    $('#txtCubicalName').focus();
                });
                return false;
            }
            serverCall('Services/InfrastructureMaster.asmx/SaveCubical', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        loadCubicalDetail(data.BlockID, data.BuildingID, data.FloorID,data.RoomID, function () {
                            ClearControls('cubical');
                        });
                    });
                }
                else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }

        var loadCubicalDetail = function (BlockID, BuildingID, FloorID,RoomID, callback) {
            data = {
                CentreID: $('#ddlCentre').val(),
                BlockID: $('#ddlCBlock').val(),
                BuildingID: $('#ddlCBuilding').val(),
                FloorID: $('#ddlCFloor').val(),
                RoomID: $('#ddlCRoom').val(),
            }
            serverCall('Services/InfrastructureMaster.asmx/loadCubicalDetail', data, function (response) {
                var responseData = JSON.parse(response);
                bindCubicalDetail(responseData);
            });
            callback(true);
        }

        var bindCubicalDetail = function (data) {
            var table = $('.cubical table tbody');
            $(table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CentreName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BlockName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BuildingName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].FloorName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].RoomName + '</td>';
                row += '<td id="tdCubicalName"class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CubicalName + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ActiveStatus + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].UpdatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditCubical(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdc_CubicalID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CubicalID + '</td>';
                row += '<td id="tdc_RoomID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].RoomID + '</td>';
                row += '<td id="tdc_FloorID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].FloorID + '</td>';
                row += '<td id="tdc_BuildingID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BuildingID + '</td>';
                row += '<td id="tdc_BlockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].BlockID + '</td>';
                row += '<td id="tdc_CentreID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CentreID + '</td>';
                row += '<td id="tdc_Active" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '</tr>';
                $(table).append(row);
            }
        }
        var EditCubical = function (rowID) {
            var row = $(rowID).closest('tr');
            $('#ddlCentre').val($(row).find('#tdc_CentreID').text().trim()).change().chosen("destroy").chosen();
            $('#ddlCBlock').val($(row).find('#tdc_BlockID').text().trim()).change().chosen("destroy").chosen();
            $('#ddlCBuilding').val($(row).find('#tdc_BuildingID').text().trim()).change().chosen("destroy").chosen();
            $('#ddlCFloor').val($(row).find('#tdc_FloorID').text().trim()).chosen("destroy").chosen();
            $('#ddlCRoom').val($(row).find('#tdc_FloorID').text().trim()).chosen("destroy").chosen();
            $('#txtCubicalName').val($(row).find('#tdCubicalName').text().trim());
            $('input[name=rdoCubicalActive][value=' + $(row).find('#tdc_Active').text().trim() + ']').prop('checked', true);
            $('#btnSaveCubical').val('Update');
            $('#spnCubicalID').text($(row).find('#tdc_CubicalID').text().trim());
        }
        //-------Cubical End

        var HideandShow = function (DivID, callback) {
            if (DivID == "block") {
                $('#btnShowBlock').addClass('CurrentButton');
                $('#btnShowBuilding').removeClass('CurrentButton');
                $('#btnShowFloor').removeClass('CurrentButton');
                $('#btnShowRoom').removeClass('CurrentButton');
                $('#btnShowCubical').removeClass('CurrentButton');
                $('.block').removeClass('hidden');
                $('.building').addClass('hidden');
                $('.floor').addClass('hidden');
                $('.room').addClass('hidden');
                $('.cubical').addClass('hidden');
            }
            else if (DivID == "building") {
                $('#btnShowBlock').removeClass('CurrentButton');
                $('#btnShowBuilding').addClass('CurrentButton');
                $('#btnShowFloor').removeClass('CurrentButton');
                $('#btnShowRoom').removeClass('CurrentButton');
                $('#btnShowCubical').removeClass('CurrentButton');
                $('.block').addClass('hidden');
                $('.building').removeClass('hidden');
                $('.floor').addClass('hidden');
                $('.room').addClass('hidden');
                $('.cubical').addClass('hidden');
            }
            else if (DivID == "floor") {
                $('#btnShowBlock').removeClass('CurrentButton');
                $('#btnShowBuilding').removeClass('CurrentButton');
                $('#btnShowFloor').addClass('CurrentButton');
                $('#btnShowRoom').removeClass('CurrentButton');
                $('#btnShowCubical').removeClass('CurrentButton');
                $('.block').addClass('hidden');
                $('.building').addClass('hidden');
                $('.floor').removeClass('hidden');
                $('.room').addClass('hidden');
                $('.cubical').addClass('hidden');
            }
            else if (DivID == "room") {
                $('#btnShowBlock').removeClass('CurrentButton');
                $('#btnShowBuilding').removeClass('CurrentButton');
                $('#btnShowFloor').removeClass('CurrentButton');
                $('#btnShowRoom').addClass('CurrentButton');
                $('#btnShowCubical').removeClass('CurrentButton');
                $('.block').addClass('hidden');
                $('.building').addClass('hidden');
                $('.floor').addClass('hidden');
                $('.room').removeClass('hidden');
                $('.cubical').addClass('hidden');
            }
            else if (DivID == "cubical") {
                $('#btnShowBlock').removeClass('CurrentButton');
                $('#btnShowBuilding').removeClass('CurrentButton');
                $('#btnShowFloor').removeClass('CurrentButton');
                $('#btnShowRoom').removeClass('CurrentButton');
                $('#btnShowCubical').addClass('CurrentButton');
                $('.block').addClass('hidden');
                $('.building').addClass('hidden');
                $('.floor').addClass('hidden');
                $('.room').addClass('hidden');
                $('.cubical').removeClass('hidden');
            }
            callback(true);
        }
        var ValidateCentre = function (callback) {
            if ($('#ddlCentre').val() == "0") {
                modelAlert('Please Select Centre', function () {
                    $('#ddlCentre').focus();
                });
                return false;
            }
            callback(true);
        }
        var ClearControls = function (div) {
            if (div == "block") {
                $('#txtBlockName').val('');
                $('input[name=rdoBlockActive][value=1]').prop('checked', true);
                $('#btnSaveBlock').val('Save');
                $('#spnBlockID').text('');
            }
            else if (div == "building") {
                $('#txtBuildingName').val('');
                $('input[name=rdoBuildingActive][value=1]').prop('checked', true);
                $('#spnBlockID').text('');
                $('#btnSaveBuilding').val('Save');
            }
            else if (div == "room") {
                $('#txtRoomName').val('');
                $('input[name=rdoRoomActive][value=1]').prop('checked', true);
                $('#btnSaveRoom').val('Save');
                $('#spnRoomID').text('');
            }
            else if (div == "cubical") {
                $('#txtCubicalName').val('');
                $('input[name=rdoCubicalActive][value=1]').prop('checked', true);
                $('#btnSaveCubical').val('Save');
                $('#spnCubicalID').text('');
            }
        }

        var ShowRoomTypeModal = function () {
            $('#divAddRoomType').showModel();
        }
        var $saveNewRoomType = function (dt) {
            if (!String.isNullOrEmpty(dt.RoomTypeName)) {
                serverCall('Services/InfrastructureMaster.asmx/SaveRoomType', { RoomTypeName: dt.RoomTypeName }, function (response) {
                    var res = JSON.parse(response);
                    modelAlert(res.response);
                    $('#divAddRoomType').closeModel();
                    $("#ddlRoomType").append($("<option></option>").val(res.RoomTypeID).html(dt.RoomTypeName)).val(res.RoomTypeID).chosen("destroy").chosen();
                });
            }
            else
                modelAlert('Please Enter RoomType Name');
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Infrastructure Master</b>
            <span class="hidden" id="spnBlockID"></span>
            <span class="hidden" id="spnBuildingID"></span>
            <span class="hidden" id="spnRoomID"></span>
            <span class="hidden" id="spnCubicalID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row divCentre">
                <div class="col-md-8"></div>
                <div class="col-md-3">
                    <label class="pull-left">Centre</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlCentre" class="requiredField"></select>
                </div>
                <div class="col-md-8"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div id="show" class="row divCentre">
                        <div class="col-md-2"></div>
                        <div class="col-md-4">
                            <input type="button" id="btnShowBlock" value="Block" onclick="showBlockDiv()" />
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnShowBuilding" value="Building" onclick="showBuildingDiv()" />
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnShowFloor" value="Floor" onclick="showFloorDiv()" />
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnShowRoom" value="Room" onclick="showRoomDiv()" />
                        </div>
                        <div class="col-md-4">
                            <input type="button" id="btnShowCubical" value="Cubical" onclick="showCubicalDiv()" />
                        </div>
                        <div class="col-md-2"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="block hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Create Blocks
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Block Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtBlockName" maxlength="200" class="requiredField" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Is Active</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="radio" name="rdoBlockActive" value="1" checked="checked" />Yes
                                <input type="radio" name="rdoBlockActive" value="0" />No
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <input type="button" id="btnSaveBlock" value="Save" onclick="SaveBlocks()" />
                    <input type="button" id="btnClearBlock" value="Clear" onclick="ClearControls('block')" />
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <div style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Centre Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Block Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Active Status</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Created Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Updated Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Edit</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="building hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Create Building
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Block</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlBBlock" onchange="loadBuildingDetail(this.value,function(){});" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Building Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtBuildingName" maxlength="200" class="requiredField" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Is Active</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="radio" name="rdoBuildingActive" value="1" checked="checked" />Yes
                                <input type="radio" name="rdoBuildingActive" value="0" />No
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <input type="button" id="btnSaveBuilding" value="Save" onclick="SaveBuilding()" />
                    <input type="button" id="btnClearBuilding" value="Clear" onclick="ClearControls('building')" />
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <div style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Centre Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Block Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 120px;">Building Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px;">Active Status</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Created Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Updated Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Edit</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="floor hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Map Floor with building
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Block</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlFBlock" onchange="bindBuilding($('#ddlCentre').val(),this.value,function(){})" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Building</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlFBuilding" onchange="loadFloorDetail(0,this.value,function(){})" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Floor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlFloor" onchange="" class="requiredField"></select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <input type="button" id="btnMapFloor" value="Save" onclick="SaveFloorBuildingMapping()" />
                    <input type="button" id="btnClearFloor" value="Clear" onclick="ClearControls('floor')" />
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <div style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Centre Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Block Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 120px;">Building Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 120px;">Floor Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Created Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Remove</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="room hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Create Room
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Block</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlRBlock" onchange="bindBuilding($('#ddlCentre').val(),this.value,function(){})" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Building</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlRBuilding" onchange="bindFloorMappedWithBuilding(this.value,function(){});loadRoomDetail($('#ddlRBlock').val(),this.value,0,function(){});" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Floor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlRFloor" onchange="loadRoomDetail($('#ddlRBlock').val(),$('#ddlRBuilding').val(),this.value,function(){});" class="requiredField"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Room Type</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <select id="ddlRoomType" onchange="" class="requiredField"></select>
                            </div>
                             <div class="col-md-1">
                                <input type="button" id="btnAddNewRoomType" value="New" onclick="ShowRoomTypeModal()" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Room Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtRoomName" maxlength="200" class="requiredField" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Department</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDepartment"></select>
                            </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Is Active</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="radio" name="rdoRoomActive" value="1" checked="checked" />Yes
                                <input type="radio" name="rdoRoomActive" value="0" />No
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <input type="button" id="btnSaveRoom" value="Save" onclick="SaveRoom()" />
                    <input type="button" id="btnClearRoom" value="Clear" onclick="ClearControls('room')" />
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <div style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Centre Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Block Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Building Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 60px;">Floor</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Room Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px;">Active Status</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Created Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Updated Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">Edit</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="cubical hidden">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Create Cubical
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Block</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCBlock" onchange="bindBuilding($('#ddlCentre').val(),this.value,function(){})" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Building</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCBuilding" onchange="bindFloorMappedWithBuilding(this.value,function(){});loadCubicalDetail($('#ddlCBlock').val(),this.value,0,0,function(){})" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Floor</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCFloor" onchange="bindRoom($('#ddlCentre').val(),$('#ddlCBlock').val(),$('#ddlCBuilding').val(),this.value,function(){});loadCubicalDetail($('#ddlCBlock').val(),$('#ddlCBuilding').val(),this.value,0,function(){})" class="requiredField"></select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">RoomType</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCRoomType" onchange="" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Room</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlCRoom" onchange="loadCubicalDetail($('#ddlCBlock').val(),$('#ddlCBuilding').val(),$('#ddlCFloor').val(),this.value,function(){})" class="requiredField"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Cubical Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtCubicalName" maxlength="200" class="requiredField" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Is Active</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="radio" name="rdoCubicalActive" value="1" checked="checked" />Yes
                                <input type="radio" name="rdoCubicalActive" value="0" />No
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <input type="button" id="btnSaveCubical" value="Save" onclick="SaveCubical()" />
                    <input type="button" id="btnClearCubical" value="Clear" onclick="ClearControls('cubical')" />
                </div>
            </div>
            <div class="POuter_Box_Inventory divCentre">
                <div class="row">
                    <div style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Centre Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Block Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px;">Building Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 60px;">Floor</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Room Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 80px;">Cubical Name</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px;">Active Status</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Created Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 150px;">Updated Detail</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">Edit</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
     <div id="divAddRoomType"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:320px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddRoomType" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add RoomType</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">   RoomType Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="30" id="txtRoomTypeName" class="form-control ItDoseTextinputText" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveNewRoomType({RoomTypeName:$('#txtRoomTypeName').val()})">Save</button>
						 <button type="button"  data-dismiss="divAddRoomType" >Close</button>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
