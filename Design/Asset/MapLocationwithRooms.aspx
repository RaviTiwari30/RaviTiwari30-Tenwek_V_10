<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MapLocationwithRooms.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_Asset_MapLocationwithRooms" %>

<asp:Content ID="c1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .divCentre
        {
            text-align: center;
        }

        .hidden
        {
            display: none;
        }
        .selectedrow
        {
            background-color:#64ff64;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            bindCentre(function (CentreID) {
                bindBlock(CentreID, function (BlockID) {
                    bindBuilding(CentreID, BlockID, function (BuildingID) {
                        bindFloorMappedWithBuilding(BuildingID, function (FloorID) {
                            bindRoomType(function (RoomTypeID) {
                                bindRoom(CentreID, BlockID, BuildingID, FloorID, RoomTypeID, function (RoomID) {
                                    bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, function (CubicalID) {
                                        bindLocation(RoomID, CubicalID, function (r) {
                                            bindLocationinTable(r);
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
                ddlCentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true });
                callback(ddlCentre.val());
            });
        }
        var bindAllMaster = function (CentreID) {
            bindBlock(CentreID, function (BlockID) {
                bindBuilding(CentreID, BlockID, function (BuildingID) {
                    bindFloorMappedWithBuilding(BuildingID, function (FloorID) {
                        bindRoomType(function (RoomTypeID) {
                            bindRoom(CentreID, BlockID, BuildingID, FloorID, RoomTypeID, function (RoomID) {
                                bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, function (CubicalID) {

                                });
                            });
                        });
                    });
                });
            });
        }
        var bindBlock = function (CentreID, callback) {
            ddlBlock = $('#ddlBlock');
            serverCall('Services/InfrastructureMaster.asmx/bindBlock', { CentreID: CentreID }, function (response) {
                ddlBlock.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BlockName', isSearchAble: true });
                callback(ddlBlock.val());
            });
        }
        var bindBuilding = function (CentreID, BlockID, callback) {
            data = {
                CentreID: CentreID,
                BlockID: BlockID
            }
            ddlBuilding = $('#ddlBuilding');
            serverCall('Services/InfrastructureMaster.asmx/bindBuilding', data, function (response) {
                ddlBuilding.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BuildingName', isSearchAble: true });
                callback(ddlBuilding.val());
            });
        }
        var bindFloorMappedWithBuilding = function (BuildingID, callback) {
            ddlRFloor = $('#ddlFloor');
            serverCall('Services/InfrastructureMaster.asmx/bindFloorMappedWithBuilding', { BuildingID: BuildingID }, function (response) {
                ddlRFloor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'FloorID', textField: 'FloorName', isSearchAble: true });
                callback(ddlRFloor.val());
            });
        }
        var bindRoomType = function (callback) {
            ddlRoomType = $('#ddlRoomType');
            serverCall('Services/InfrastructureMaster.asmx/bindRoomType', {}, function (response) {
                ddlRoomType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoomTypeName', isSearchAble: true });
                callback(ddlRoomType.val());
            });
        }
        var bindRoom = function (CentreID, BlockID, BuildingID, FloorID, RoomTypeID, callback) {
            ddlRoom = $('#ddlRoom');
            serverCall('Services/InfrastructureMaster.asmx/bindRoom', { CentreID: CentreID, BlockID: BlockID, BuildingID: BuildingID, FloorID: FloorID, RoomTypeID: RoomTypeID,DeptLedgerNo:0 }, function (response) {
                ddlRoom.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoomName', isSearchAble: true });
                callback(ddlRoom.val());
            });
        }
        var bindCubical = function (CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, callback) {
            ddlCubical = $('#ddlCubical');
            serverCall('Services/InfrastructureMaster.asmx/bindCubical', { CentreID: CentreID, BlockID: BlockID, BuildingID: BuildingID, FloorID: FloorID, RoomID: RoomID, RoomTypeID: RoomTypeID }, function (response) {
                ddlCubical.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'CubicalName', isSearchAble: true });
                callback(ddlCubical.val());
            });
        }
        var bindLocation = function (RoomID, CubicalID, callback) {
            serverCall('Services/InfrastructureMaster.asmx/bindMappedLocation', {RoomID: RoomID, CubicalID: CubicalID }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }
        var bindAllMasterinBlock = function (CentreID, BlockID, callback) {
            bindBuilding(CentreID, BlockID, function (BuildingID) {
                bindFloorMappedWithBuilding(BuildingID, function (FloorID) {
                    bindRoomType(function (RoomTypeID) {
                        bindRoom(CentreID, BlockID, BuildingID, FloorID, RoomTypeID, function (RoomID) {
                            bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, function (CubicalID) {
                            });
                        });
                    });
                });
            });
        }
        var bindAllMasterinBuilding = function (CentreID, BlockID, BuildingID, callback) {
            bindFloorMappedWithBuilding(BuildingID, function (FloorID) {
                bindRoomType(function (RoomTypeID) {
                    bindRoom(CentreID, BlockID, BuildingID, FloorID, RoomTypeID, function (RoomID) {
                        bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, function (CubicalID) {
                        });
                    });
                });
            });
        }
        var bindAllMasterinFloor = function (CentreID, BlockID, BuildingID, FloorID, callback) {
            bindRoomType(function (RoomTypeID) {
                bindRoom(CentreID, BlockID, BuildingID, FloorID, RoomTypeID, function (RoomID) {
                    bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, function (CubicalID) {
                    });
                });
            });
        }
        var bindAllMasterinRoomType = function (CentreID, BlockID, BuildingID, FloorID, RoomTypeID, callback) {
            bindRoom(CentreID, BlockID, BuildingID, FloorID, RoomTypeID, function (RoomID) {
                bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, function (CubicalID) {
                    bindLocation(RoomID, CubicalID, function (r) {
                        bindLocationinTable(r);
                    });
                });
            });
        }
        var bindAllMasterinRoom = function (CentreID, BlockID, BuildingID, FloorID, RoomTypeID, RoomID, callback) {
            bindCubical(CentreID, BlockID, BuildingID, FloorID, RoomID, RoomTypeID, function (CubicalID) {
                bindLocation(RoomID, CubicalID, function (r) {
                    bindLocationinTable(r);
                });
            });
        }
        
        var bindLocationinTable = function (data) {
            var table = $('#tbLocation tbody');
            $(table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '';
                if (data[i].IsMapped == '0')
                    row = '<tr>';
                else
                    row = '<tr class="selectedrow">';
                if (data[i].IsMapped=='0')
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="checkbox" class="chklocation" onchange="SelectRow(this)" /></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="checkbox" class="chklocation" checked="checked" onchange="SelectRow(this)" /></td>';
                row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LocationName + '</td>';
                row += '<td id="tdDescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                row += '<td id="tdLocationID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].LocationID + '</td>';
                row += '</tr>';
                $(table).append(row);
            }
        }
        var Save = function () {
            getLocationDetails(function (data) {
                serverCall('Services/InfrastructureMaster.asmx/SaveLocationMapping', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response);
                });
            });
        }
        var getLocationDetails = function (callback) {
            roomDetails = {
                RoomID: $('#ddlRoom').val(),
                CubicalID: $('#ddlCubical').val(),
            }
            locationDetails = [];
            var table = $('#tbLocation tbody tr input[type=checkbox]:checked');
            $(table).closest('tr').each(function (i, e) {
                locationDetails.push({
                    locationID: $(e).find('#tdLocationID').text().trim(),
                });
            });

            if (roomDetails.RoomID == 0) {
                modelAlert('Please Select Room or Cubical', function () {
                    $('#ddlRoom').focus();
                });
                return false;
            }
            if (locationDetails.length < 1) {
                modelAlert('Please Select at Least One Location', function () {

                });
                return false;
            }
            callback({ locationDetails: locationDetails, RoomID: $('#ddlRoom').val(), CubicalID: $('#ddlCubical').val() })
        }

        var SelectRow = function (elem) {
            if ($(elem).is(':checked')) {
                $(elem).closest('tr').addClass('selectedrow');
            }
            else
                $(elem).closest('tr').removeClass('selectedrow');
        }
        var SearchlocationinTable = function (elem) {
            var data = elem.value;
            if (data != '') {
                $('#tbLocation tr').hide();
                $('#tbLocation tr:first').show();
                $('#tbLocation tr').find('#tdLocationName').filter(function () {
                    if ($(this).text().toLowerCase().match(data.toLowerCase()))
                        return $(this);
                }).parent('tr').show();
            }
            else
                $('#tbLocation tr').show();
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Map Location With Room and Cubicals</b>
            <span id="spnLocationID" class="hidden"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Centre</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentre" class="requiredField" onchange="bindAllMaster(this.value,function(){})"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Block</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBlock" onchange="bindAllMasterinBlock($('#ddlCentre').val(),this.value,function(){})" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Building</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBuilding" onchange="bindAllMasterinBuilding($('#ddlCentre').val(),$('#ddlBlock').val(),this.value,function(){})" class="requiredField"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Floor</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlFloor" onchange="bindAllMasterinFloor($('#ddlCentre').val(),$('#ddlBlock').val(),$('#ddlBuilding').val(),this.value,function(){})" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">RoomType</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlRoomType" onchange="bindAllMasterinRoomType($('#ddlCentre').val(),$('#ddlBlock').val(),$('#ddlBuilding').val(),$('#ddlFloor').val(),this.value,function(){})" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Room</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlRoom" onchange="bindAllMasterinRoom($('#ddlCentre').val(),$('#ddlBlock').val(),$('#ddlBuilding').val(),$('#ddlFloor').val(),$('#ddlRoomType').val(),this.value,function(){})" class="requiredField"></select>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Cubical</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCubical" onchange="bindLocation($('#ddlRoom').val(), this.value, function (r) {bindLocationinTable(r);})"></select>
                        </div>
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Location </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <div style="max-height: 280px; height:290px; overflow-x: auto">
                                <table id="tbLocation" class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                    <thead>
                                        <tr>
                                            <th class="GridViewHeaderStyle" style="width: 30px;">
                                                <input type="checkbox" class="chklocation" onchange="$('#tbLocation tbody tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                                            <th class="GridViewHeaderStyle" style="width: 120px;">Location Name
                                                <br /><input type="text" onkeyup="SearchlocationinTable(this)" placeholder="Search Location here( In Between )" />
                                            </th>
                                            <th class="GridViewHeaderStyle" style="width: 120px;">Description Name</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                 <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory divCentre">
            <div class="row">
                <input type="button" id="btnSave" value="Save" onclick="Save()" />
            </div>
        </div>
    </div>
</asp:Content>

