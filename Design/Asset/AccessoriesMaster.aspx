<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="AccessoriesMaster.aspx.cs" Inherits="Design_Asset_AccessoriesMaster" %>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">
        $(document).ready(function () {
            loadGroup(function () {
                loadUnit(function () {
                    bindAccessoriesMaster(0,function () {

                    });
                });
            });
        });
        var loadGroup = function (callback) {
            ddlGroup = $('#ddlGroup');
            serverCall('Services/WebService.asmx/loadGroup', {}, function (response) {
                ddlGroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'SubCategoryName', isSearchAble: true });
                callback(ddlGroup.val());
            });
        }
        var loadUnit = function (callback) {
            ddlUnit = $('#ddlUnit');
            serverCall('Services/WebService.asmx/loadUnit', {}, function (response) {
                ddlUnit.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'UnitName', textField: 'UnitName', isSearchAble: true });
                callback(ddlUnit.val());
            });
        }

        var Save = function () {
            var data = {
                SubCategoryID: $('#ddlGroup').val(),
                Name: $('#txtName').val().trim(),
                Unit: $('#ddlUnit').val(),
                Code: $('#txtCode').val().trim(),
                Remarks: $('#txtRemarks').val().trim(),
                Savetype: $('#btnSave').val(),
                AccessoriesID: $('#spnAccessoriesID').text().trim(),
                IsActive: $('input[type=radio][name=rdoactive]:checked').val(),
            }
            
            if (String.isNullOrEmpty(data.Name)) {
                modelAlert('Please Enter Accessories Name', function () {
                    $('#txtName').focus();
                });
                return false;
            }
            if (data.Unit == 0) {
                modelAlert('Please Select Unit', function () {
                    $('#ddlUnit').focus();
                });
                return false;
            }

            serverCall('Services/WebService.asmx/SaveAccessoriesMaster', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindAccessoriesMaster(0, function () {
                        Clear();
                    });
                });
            });
        }
        
        var bindAccessoriesMaster = function (groupID,callback) {
            serverCall('Services/WebService.asmx/bindAccessoriesMasterDetails', { groupid: groupID }, function (response) {
                var responseData = JSON.parse(response);
                bindDetails(responseData);
            });
            callback(true);
        }
        var bindDetails = function (data) {
            $('#tbAccessList tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbAccessList tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdAName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AccessoriesName + '</td>';
                row += '<td id="tdAUnit" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Unit + '</td>';
                row += '<td id="tdACode" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AccessoriesCode + '</td>';
                row += '<td id="tdARemarks" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Remarks + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Active + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CreatedBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LastUpdateBy + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '<td id="tdActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsActive + '</td>';
                row += '</tr>';
                $('#tbAccessList tbody').append(row);
            }
        }
        var Edit = function (rowID) {
            var row = $(rowID).closest('tr');
            $('#txtName').val(row.find('#tdAName').text());
            $('#ddlUnit').val(row.find('#tdAUnit').text()).chosen("destroy").chosen();
            $('#txtCode').val(row.find('#tdACode').text());
            $('#txtRemarks').val(row.find('#tdARemarks').text());
            $('#spnAccessoriesID').text(row.find('#tdAID').text());
            $('input[type=radio][name=rdoactive][value=' + row.find('#tdActive').text() + ']').prop('checked',true);
            $('#btnSave').val('Update');
        }
        var Clear = function () {
            $('#txtName').val('');
            $('#ddlUnit').val(0).chosen("destroy").chosen();
            $('#txtCode').val('');
            $('#txtRemarks').val('');
            $('#spnAccessoriesID').text('');
            $('input[type=radio][name=rdoactive][value=1]').prop('checked', true);
            $('#btnSave').val('Save');
        }

        var SearchbyfirstName = function (elem) {
            var name = $.trim($(elem).val());
            var length = $.trim($(elem).val()).length;

            $('#tbAccessList tr').hide();
            $('#tbAccessList tr:first').show();
            $('#tbAccessList tr').find('td:eq(1)').filter(function () {
                    if ($(this).text().substring(0, length).toLowerCase() == name.toLowerCase())
                        return $(this);
                }).parent('tr').show();;
        }

    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Accessories Master</b>
            <span style="display:none" id="spnAccessoriesID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">Group Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="display:none">
                            <select id="ddlGroup" class="requiredField" ></select>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">Aceess. Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtName" class="requiredField" maxlength="200" placeHolder="Enter Accessories Name here" />
                        </div>
                        
                        <div class="col-md-3">
                            <label class="pull-left">Unit</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlUnit" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Code</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtCode" placeHolder="Enter Accessories Code here" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Remarks</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea id="txtRemarks" style="height: 56px; text-transform: uppercase; margin: 0px; width: 228px; max-width: 228px; max-height: 90px;" placeHolder="Enter Accessories Remarks here"></textarea>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rdoactive" value="1" checked="checked" />Yes
                            <input type="radio" name="rdoactive" value="2" />No
                        </div>
                    </div>
                </div>
                 <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSave" value="Save" onclick="Save()" />
                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />
                
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Accessories Details
            </div>
            <div class="row">
                <div class="col-md-3">
                            <label class="pull-left">Search Accessories</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtsearch" onkeyup="SearchbyfirstName(this)" placeholder="Search by first name" />
                        </div>
            </div>
            <div class="row">
                <div id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tbAccessList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Accessories Name</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">Unit</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Code</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Remarks</th>
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
</asp:Content>
