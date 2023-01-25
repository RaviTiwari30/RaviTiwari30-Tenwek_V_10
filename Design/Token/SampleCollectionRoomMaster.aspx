<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleCollectionRoomMaster.aspx.cs" Inherits="Design_EDP_SampleCollectionRoomMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Sample Collection/Radiology Acceptance Room Master</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    <div class="col-md-3">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentre" class="requiredField" onchange="bindRoomList($(this).val(),function(){});bindGroupNameList($(this).val(),function(){});loadMapping($(this).val(),function(){}); $('#tblRoomGroupMappping tbody').empty();"></select>
                        </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Room Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" class="requiredField" id="txtRoomName" maxlength="100" data-title="Enter Room Name For Patient Display" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Room Type
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlRoomType" title="Select Room Type to Show Room in This Role" class="requiredField"></select>
                    </div>
                   
                </div>
                <div class="row" style="text-align:center"></div>
                <div class="row" style="text-align:center">
                     <div class="col-md-24">
                        <input type="button" value="Save" style="width: 100px;" onclick="saveRoom()" />
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Map Room-Token 
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    
                    <div class="col-md-3">
                        <label class="pull-left">
                            Room Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlRoomList" class="requiredField"></select>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Token Group
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlTokenGroup" class="requiredField"></select>
                    </div>
                    <div class="col-md-3">
                        <input type="button" value="Save Mapping" onclick="saveMapping()" />
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Today Running Room-Token Mapping
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    <div class="row" id="divRoomTokenList" style="max-height: 400px; overflow-y: scroll">
                        <table id="tblRoomGroupMappping" cellspacing="0" class="GridViewStyle" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="text-align: center; width: 10%;">S.No.</th>
                                    <th class="GridViewHeaderStyle" style="text-align: left; width: 20%;">Centre Name</th>
                                    <th class="GridViewHeaderStyle" style="text-align: left; width: 20%;">Room Name</th>
                                    <th class="GridViewHeaderStyle" style="text-align: left; width: 30%;">Group Name</th>
                                    <th class="GridViewHeaderStyle" style="text-align: left; width: 30%;">Role Name</th>
                                    <th class="GridViewHeaderStyle" style="text-align: center; width: 10%;">Remove</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        

    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            getCentre(function (CentreID) {
                bindRoomList(CentreID,function () {
                    bindRole(function () {
                        bindGroupNameList(CentreID,function () {
                            loadMapping(CentreID,function () {
                                $('#txtRoomName').focus();
                            });
                        });
                    });
                });
            });
        });
        var getCentre = function (callback) {
            ddlCentre = $('#ddlCentre');
            serverCall('../Common/CommonService.asmx/BindAllCentre', {}, function (response) {
                var responseData = JSON.parse(response);
                ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
                callback(ddlCentre.val());
            });
        }

        var saveRoom = function () {
            if ($('#txtRoomName').val() == '') {
                modelAlert('Please Enter Room Name', function () {
                    $('#txtRoomName').focus();
                    return false;
                });
            }
            if ($('#ddlRoomType option:selected').val() == '0') {
                modelAlert('Please Select Room Type', function () {
                    $('#ddlRoomType').focus();
                    return false;
                });
            }
            serverCall('SampleCollectionRoomMaster.aspx/saveRoom', { roomName: $.trim($('#txtRoomName').val()), RoleID: $('#ddlRoomType option:selected').val(), CentreID: $('#ddlCentre').val() }, function (response) {
                $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status)
                        location.reload();
                });

            });



        }
        var bindRoomList = function (CentreID,callback) {
            var ddlRoomList = $('#ddlRoomList');
            ddlRoomList.empty();
            serverCall('SampleCollectionRoomMaster.aspx/getRoomList', { CentreID: CentreID }, function (response) {
                ddlRoomList.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'id', textField: 'roomName', isSearchable: true });
                callback(true);
            });

        }
        var bindRole = function (callback) {
            var ddlRoomType = $('#ddlRoomType');
            ddlRoomType.empty();
            serverCall('SampleCollectionRoomMaster.aspx/bindRole', {}, function (response) {
                ddlRoomType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoleName', isSearchable: true });
                callback(true);
            });

        }
        
        var bindGroupNameList = function (CentreID,callback) {
            var ddlTokenGroupList = $('#ddlTokenGroup');
            ddlTokenGroupList.empty();
            serverCall('SampleCollectionRoomMaster.aspx/getGroupNameList', { CentreID: CentreID }, function (response) {
                ddlTokenGroupList.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'GroupID', textField: 'GroupName', isSearchable: true });
                callback(true);
            });

        }
        var saveMapping = function () {
            var ddlRoomList = $('#ddlRoomList');
            var ddlTokenGroupList = $('#ddlTokenGroup');
            if (ddlRoomList.val() == 0) {
                modelAlert('Please Select Room Type.', function () {
                    ddlRoomList.focus();
                });
                return false;
            }
            if (ddlTokenGroupList.val() == 0) {
                modelAlert('Please Select Group Name.', function () {
                    ddlTokenGroupList.focus();
                });
                return false;
            }
            serverCall('SampleCollectionRoomMaster.aspx/saveMapping', { roomId: ddlRoomList.val(), groupId: ddlTokenGroupList.val(), CentreID: $('#ddlCentre').val() }, function (response) {
                $responseData = JSON.parse(response);
                modelAlert($responseData.response, function () {
                    if ($responseData.status) {
                        var pushMapping = {
                            roomId: ddlRoomList.val(),
                            groupId: ddlTokenGroupList.val(),
                            roomName: $('#ddlRoomList option:selected').html(),
                            groupName: $('#ddlTokenGroup option:selected').html(),
                            rolename: $('#ddlRoomType option:selected').text(),
                            CentreID: $('#ddlCentre').val(),
                            CentreName: $('#ddlCentre option:selected').text(),
                        }
                        addRowToMapping(pushMapping,0, function () {
                            ddlRoomList.chosen('destroy').val('0').chosen();
                            ddlTokenGroupList.chosen('destroy').val('0').chosen();
                        });
                    }
                });
            });

        }

        var loadMapping = function (CentreID,callback) {
            serverCall('SampleCollectionRoomMaster.aspx/loadMapping', { CentreID: CentreID }, function (response) {
                if (response != '')
                {
                    var responseData = JSON.parse(response);
                    $.each(responseData, function (i,item) {
                        addRowToMapping(item,1, function () { });

                    });
                    callback(true);
                }
            });
        }
        var addRowToMapping = function ($mappingItem, isclear, callback) {
            if (isclear == 1) {
              //  $('#tblRoomGroupMappping tbody').empty();
            }
            var tableBody = $('#tblRoomGroupMappping tbody');
            var tlength = $('#tblRoomGroupMappping tbody tr').length;
            var temp = '<tr>';
            temp += '<td class="GridViewLabItemStyle"  style="text-align:center;">' + (tlength + 1) + '.</td>';
            temp += '<td class="GridViewLabItemStyle"  style="text-align:left;">' + $mappingItem.CentreName + '</td>';
            temp += '<td class="GridViewLabItemStyle"  style="text-align:left;">' + $mappingItem.roomName + '</td>';
            temp += '<td class="GridViewLabItemStyle"  style="text-align:left;">' + $mappingItem.groupName + '</td>';
            temp += '<td class="GridViewLabItemStyle"  style="text-align:left;">' + $mappingItem.rolename + '</td>';
            temp += '<td class="GridViewLabItemStyle"  style="text-align:center;"><img  title="Remove Item" style="cursor:pointer" onclick="removeRow(this)" src="../../Images/Delete.gif"></td>'
            temp += '<td class="GridViewLabItemStyle"  style="display:none;" id="tdRoomId">' + $mappingItem.roomId + '.</td>';
            temp += '<td class="GridViewLabItemStyle"  style="display:none;" id="tdGroupId">' + $mappingItem.groupId + '.</td>';
            temp += '<td class="GridViewLabItemStyle"  style="display:none;" id="tdCentreID">' + $mappingItem.CentreID + '.</td>';
            temp += '</tr>';
            tableBody.append(temp);
            callback(true);
        }
        var removeRow = function (sender) {
            var roomId = $(sender).closest('tr').find('#tdRoomId').text();
            var groupId = $(sender).closest('tr').find('#tdGroupId').text();
            var CentreID = $(sender).closest('tr').find('#tdCentreID').text();
            modelConfirmation('Alert!!!', 'Do You Want To Remove?', 'Remove', 'Close', function (response) {
                if (response) {
                    serverCall('SampleCollectionRoomMaster.aspx/removeMapping', { roomId: roomId, groupId: groupId,CentreID:CentreID }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status)
                                $(sender).closest('tr').remove();

                        });
                    });
                }
            });


        }

    </script>
</asp:Content>

