<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="LocationMaster.aspx.cs" Inherits="Design_Asset_LocationMaster" %>

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
    </style>
    <script type="text/javascript">
        $(document).ready(function () {

            loadLocationDetail(function () {

            });
        });
       
        var Save = function () {
            data = {
                LocationName: $('#txtLocationName').val().trim(),
                Description: $('#txtDescription').val().trim(),
                IsActive: $('input[name=rdoActive]:checked').val(),
                LocationID: $('#spnLocationID').text().trim(),
            }
           
            if (String.isNullOrEmpty(data.LocationName)) {
                modelAlert('Please Enter Location Name', function () {
                    $('#txtLocationName').focus();
                });
                return false;
            }
            serverCall('Services/InfrastructureMaster.asmx/SaveLocation', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function () {
                        loadLocationDetail(function () {
                            ClearControls();
                        });
                    });
                }
                else {
                    modelAlert(responseData.response, function () { });
                }
            });
        }
        var loadLocationDetail = function (callback) {
            serverCall('Services/InfrastructureMaster.asmx/loadLocationDetail', { }, function (response) {
                var responseData = JSON.parse(response);
                bindLocationDetail(responseData);
            });
            callback();
        }
        var bindLocationDetail = function (data) {
            var table = $('.location table tbody');
            $(table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $(table).find('tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdLocationName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LocationName + '</td>';
                row += '<td id="tdDescription" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Description + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ActiveStatus + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].UpdatedDetail + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="EditLocation(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdLocationID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].LocationID + '</td>';
                row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '</tr>';
                $(table).append(row);
            }
        }

        var EditLocation = function (rowID) {
            var row = $(rowID).closest('tr');
            $('#txtLocationName').val($(row).find('#tdLocationName').text().trim());
            $('#txtDescription').val($(row).find('#tdDescription').text().trim());
            $('input[name=rdoActive][value=' + $(row).find('#tdActive').text().trim() + ']').prop('checked', true);
            $('#spnLocationID').text($(row).find('#tdLocationID').text().trim());
        }
        var ClearControls = function () {
            $('#txtLocationName').val('');
            $('#txtDescription').val('');
            $('input[name=rdoActive][value=1]').prop('checked', true);
            $('#spnLocationID').text('');
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Location Master</b>
            <span id="spnLocationID" class="hidden"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">Location Master</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtLocationName" maxlength="200" class="requiredField" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Description</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtDescription" maxlength="200" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoActive" value="1" checked="checked" />Yes
                                <input type="radio" name="rdoActive" value="0" />No
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory divCentre">
            <div class="row">
                <input type="button" id="btnSave" value="Save" onclick="Save()" />
                <input type="button" id="btnClear" value="Clear" onclick="ClearControls()" />
            </div>
        </div>
        <div class="POuter_Box_Inventory divCentre location">
            <div class="row">
                <div style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 120px;">Location Name</th>
                                <th class="GridViewHeaderStyle" style="width: 120px;">Description Name</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Active Status</th>
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
</asp:Content>
