<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CSSDSetMaster.aspx.cs" Inherits="Design_CSSD_CSSDSetMaster" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>CSSD Set Master</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSetList" class="requiredField" onchange="loadSetItems()"></select>
                        </div>
                        <div class="col-md-1">
                            <input type="button" value="New" onclick="$('#divSetMaster').showModel();" />
                        </div>
                         
                        <div class="col-md-4">
                            <label class="pull-left" for="chkOtherSetItem">
                               Get Other Set Item
                            </label>
                            <b class="pull-right">:</b>
                            <input type="checkbox" id="chkOtherSetItem" onclick="HideShowOtherSetItem()" />
                        </div>
                        <div class="col-md-5 OtherSetItem">
                            <select id="ddlSetListCopyFrom" class="requiredField"></select>
                        </div>
                        <div class="col-md-1 OtherSetItem">
                            <input type="button" value="Get Item" onclick="loadCopySetItems()" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <input type="text" id="txtSearchItem" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Selected Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <label id="lblSelectedItem" style="font-weight: bold; color: #f15137;"></label>
                            <span id="spnSelectedItemId" style="display: none;"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                QTY
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <input type="text" id="txtQty" class="ItDoseTextinputNum requiredField" onlynumber="5" autocomplete="off" value="1" />
                        </div>
                        <div class="col-md-1">
                            <input type="button" value="Add" onclick="AddItem()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divSetItemList" style="display: none;">
            <div class="Purchaseheader">
                Set Item List
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <table id="tablesetItemList" cellspacing="0" class="GridViewStyle" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr class="tblTitle" id="Header">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 5%">S.No.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30%; text-align: left;">Set Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50%; text-align: left;">Item Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10%">Quantity</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 5%">Remove</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="row" style="text-align: center;">
                <input type="button" value="Save" style="margin-top: 7px; width: 100px;" onclick="SaveSetItems()" />
            </div>
        </div>
    </div>


    <div id="divSetMaster" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1000px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSetMaster" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Create/Update CSSD Set</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Select Set</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlEditSet" onchange="getEditSetDetails()">
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Set Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSetName" class="form-control ItDoseTextinputText requiredField" autocomplete="off" maxlength="100" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Description</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtDescription" class="form-control ItDoseTextinputText" autocomplete="off" onlytext="100" allowcharscode="47" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Validity Days</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtValidityDays" class="ItDoseTextinputNum requiredField" onlynumber="4" autocomplete="off" value="1" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSetDept" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlIsActive">
                                <option value="1">Yes</option>
                                <option value="0">No</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="SaveSet()" id="btnSaveSet">Create New</button>
                    <button type="button" data-dismiss="divSetMaster">Close</button>
                </div>
            </div>
        </div>
    </div>



    <script>
        var SaveSet = function () {
            if ($.trim($('#txtSetName').val()) == '') {
                modelAlert('Please Enter Set Name', function () {
                    $('#txtSetName').focus();
                });
                return false;
            }
            if (Number($('#txtValidityDays').val()) == 0) {
                modelAlert('Please Enter valid Validity Days', function () {
                    $('#txtValidityDays').focus();
                });
                return false;

            }



            if ($('#ddlSetDept').val() == '0') {
                modelAlert('Please Select Department', function () {
                    $('#ddlSetDept').focus();
                });
                return false;

            }

            var data = {
                SetName: $.trim($('#txtSetName').val()),
                Description: $.trim($('#txtDescription').val()),
                isActive: $('#ddlIsActive').val(),
                setId: $('#ddlEditSet').val(),
                validityDays: Number($.trim($('#txtValidityDays').val())),
                setDeptId: $('#ddlSetDept').val(),
                setDeptName: $('#ddlSetDept option:selected').html()
            };
            serverCall('Services/SetMaster.asmx/SaveSet', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        bindSets(function () {
                            clearSetDetails(function () {

                            });
                        });
                    }

                });

            });



        }

        $(document).ready(function () {
            // $('#ddlEditSet,#ddlSetList').chosen();

            HideShowOtherSetItem();
            bindSets(function () {
                bindSetDepartment(function () {
                    initSearchAutoComplete(function () {

                    });
                });
            });

        });

        var bindSets = function (callback) {
            serverCall('Services/SetMaster.asmx/LoadSetsForEdit', {}, function (response) {
                if (String.isNullOrEmpty(response)) {
                    $('#ddlEditSet,#ddlSetList,#ddlSetListCopyFrom').append('<option value="0">No Data Bound</option>');
                }
                else {
                    var responseData = JSON.parse(response);
                    $('#ddlEditSet').bindDropDown({ defaultValue: 'New', data: responseData, valueField: 'Set_ID', textField: 'SetName', isSearchAble: true });
                    var activeSets = responseData.filter(function (i) { if (i.IsActive == 1) return i; });
                    $('#ddlSetList').bindDropDown({ defaultValue: 'Select', data: activeSets, valueField: 'Set_ID', textField: 'SetName', isSearchAble: true });

                    $('#ddlSetListCopyFrom').bindDropDown({ defaultValue: 'Select', data: activeSets, valueField: 'Set_ID', textField: 'SetName', isSearchAble: true });

                }
                callback(true);
            });


        }


        var bindSetDepartment = function (callback) {
            serverCall('Services/SetMaster.asmx/getSetDept', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSetDept').bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'id', textField: 'name', isSearchAble: true });
                callback(true);
            });






        }



        var clearSetDetails = function (callback) {
            $('#txtSetName,#txtDescription').val('');
            $('#txtValidityDays,#ddlIsActive').val('1');
            $('#ddlEditSet,#ddlSetDept').chosen('destroy').val('0').chosen();
            $('#btnSaveSet').html('Create New');
            callback(true);
        }
        var getEditSetDetails = function () {
            var setId = $('#ddlEditSet').val();
            if (setId == '0' || setId == '') {
                clearSetDetails(function () { });
            }
            else {
                validateSetForEdit(setId, function (isValid) {
                    if (isValid) {
                        serverCall('Services/SetMaster.asmx/getEditSetMasterDetails', { setId: setId }, function (response) {
                            var responseData = JSON.parse(response);
                            $('#txtSetName').val(responseData[0].SetName);
                            $('#txtDescription').val(responseData[0].Desc);
                            $('#txtValidityDays').val(responseData[0].validityDays);
                            $('#ddlIsActive').val(responseData[0].IsActive);
                            $('#ddlSetDept').chosen('destroy').val(responseData[0].setDeptId).chosen();
                            $('#btnSaveSet').html('Update');
                        });
                    }
                });
            }


        }
        var validateSetForEdit = function (setId, callback) {
            // Code to Be Written for A set cannot be Editted until it is requested,processd or in any step of process
            serverCall('Services/SetMaster.asmx/validateSetForEdit', { setId: setId }, function (response) {
                var responseData = JSON.parse(response);
                if (!responseData.status) {
                    modelAlert(responseData.response, function () { });
                    callback(false);
                }
                else {
                    callback(true);
                }
            });


        }



        var initSearchAutoComplete = function (callback) {
            $('#txtSearchItem').autocomplete({
                source: function (request, response) {
                    getCSSDItems(request.term, function (responseItems) {
                        response(responseItems)
                    });

                },
                select: function (e, i) {
                    $('#lblSelectedItem').text(i.item.label);
                    $('#spnSelectedItemId').text(i.item.val);
                },
                close: function (el) {
                    el.target.value = '';
                    $('#txtQty').focus();
                },
                open: function () {
                    $('#txtSearchItem').autocomplete('widget').css(
                         { 'overflow-y': 'auto', 'max-height': '300px', 'overflow-x': 'hidden', 'border-radius': '5px' });
                },
                minLength: 2

            });
            callback(true);
        }


        var getCSSDItems = function (prefix, callback) {
            serverCall('Services/SetMaster.asmx/getCSSDItems', { prefix: prefix }, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.ItemName,
                        val: item.ItemID,

                    }
                });

                callback(responseData);
            });


        }

        var AddItem = function () {
            if (valideData())
                AddItemRow($('#ddlSetList').val(), $('#ddlSetList option:selected').html(), $('#lblSelectedItem').text(), $('#spnSelectedItemId').text(), $('#txtQty').val());
        }

        var AddItemRow = function ($setId, $setName, $itemName, $itemId, $qty) {

            var table = $('#tablesetItemList tbody');
            var tablelength = $('#tablesetItemList tbody tr').length;
            var appendString = '<tr>';
            appendString += '<td  class="GridViewLabItemStyle" style="text-align:center;">' + (tablelength + 1) + '.</td>';
            appendString += '<td id="tdSetName" class="GridViewLabItemStyle" style="text-align:left;">' + $setName + '</td>';
            appendString += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align:left;">' + $itemName + '</td>';
            appendString += '<td id="tdQty" class="GridViewLabItemStyle" style="text-align:center;">' + $qty + '</td>';
            appendString += '<td class="GridViewLabItemStyle"  style="text-align:center;"><img  title="Remove Item" onclick="removeRow(this)" src="../../Images/Delete.gif"></td>';
            appendString += '<td id="tdItemId" style="display:none;">' + $itemId + '</td>';
            appendString += '<td id="tdSetId" style="display:none;">' + $setId + '</td>';
            appendString += '</tr>';
            table.append(appendString);
            clearItemDetails();

        }
        var clearItemDetails = function () {
            $('#spnSelectedItemId,#lblSelectedItem').text('');
            $('#txtQty').val('1');
            if ($('#tablesetItemList tbody tr').length > 0)
                $('#divSetItemList').show();
            else
                $('#divSetItemList').hide();
        }
        var removeRow = function (sender) {
            $(sender).closest('tr').remove();
            if ($('#tablesetItemList tbody tr').length == 0)
                $('#divSetItemList').hide();
        }
        var valideData = function () {
            if ($('#ddlSetList').val() == '0') {
                modelAlert('Please Select Set', function () {
                    $('#ddlSetList').focus();
                });
                return false;
            }
            if ($('#spnSelectedItemId').text() == '') {
                modelAlert('Please Select Item First.', function () {
                    $('#txtSearchItem').focus();
                });
                return false;
            }
            if (Number($('#txtQty').val()) == 0) {
                modelAlert('Please Enter A Valid QTY.', function () {
                    $('#txtQty').focus();
                });
                return false;
            }

            $isDuplicate = 0;
            $('#tablesetItemList tbody tr').each(function () {
                if (($(this).find('#tdItemId').text() == $('#spnSelectedItemId').text()))
                    $isDuplicate = 1;


            });
            if ($isDuplicate == 1) {
                modelAlert('Item Already Exist.');
                return false;

            }
            else
                return true;


        }
        var SaveSetItems = function () {
            var dataIetmList = [];
            $('#tablesetItemList tbody tr').each(function () {
                dataIetmList.push({
                    SetID: $(this).find('#tdSetId').text(),
                    SetName: $(this).find('#tdSetName').text(),
                    ItemID: $(this).find('#tdItemId').text(),
                    ItemName: $(this).find('#tdItemName').text(),
                    Quantity: $(this).find('#tdQty').text(),
                });

            });
            if (dataIetmList.length == 0) {
                modelAlert('Please Map At least One Item With Set.');
                return false;

            }
            serverCall('Services/SetMaster.asmx/SaveSetItemMapping', { data: dataIetmList }, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        location.reload();

                });


            });
        }
        var loadSetItems = function () {
            $('#tablesetItemList tbody').empty();
            clearItemDetails();
            var setId = $('#ddlSetList').val();
            if (setId != '0' && setId != '') {
                validateSetForEdit(setId, function (isValid) {
                    if (isValid) {
                        serverCall('Services/SetMaster.asmx/loadSetItems', { setId: setId }, function (response) {
                            if (response != '') {
                                var responseData = JSON.parse(response);
                                for (var i = 0; i < responseData.length; i++) {
                                    AddItemRow(responseData[i].SetID, responseData[i].SetName, responseData[i].ItemName, responseData[i].ItemID, responseData[i].Qty);
                                }
                            }
                        });
                    }
                });

            }


        }


    </script>

    <script type="text/javascript">

        function HideShowOtherSetItem() {

            var IsOtherSetItem = $("#chkOtherSetItem").is(':checked');

            if (IsOtherSetItem) {
                $(".OtherSetItem").show();
            } else {
                $('#tablesetItemList tbody').empty();
                clearItemDetails();
                $(".OtherSetItem").hide();
            }
        }

        var loadCopySetItems = function () {
            // $('#tablesetItemList tbody').empty();
            // clearItemDetails();
            var setId = $('#ddlSetListCopyFrom').val();
            var CopySetName = "";
            var CopyToSetId = $('#ddlSetList').val();

            if (CopyToSetId != '0' && CopyToSetId != '') {
                CopySetName = $("#ddlSetList option:selected").text();
                 
            } else {

                modelAlert("Please Select Copy To Set Name.")
                return false;
            }

            if (CopyToSetId == setId) {
                modelAlert("Please Select Different Set to copy.")
                return false;
            }
            if (setId != '0' && setId != '') {
                validateSetForEdit(CopyToSetId, function (isValid) {
                    if (isValid) {
                        serverCall('Services/SetMaster.asmx/loadSetItems', { setId: setId }, function (response) {
                            if (response != '') {
                                var responseData = JSON.parse(response);
                                for (var i = 0; i < responseData.length; i++) {

                                    var IsDuplicate = 0;

                                    $('#tablesetItemList tbody tr').each(function () {
                                        if (($(this).find('#tdItemId').text() == responseData[i].ItemID)) {
                                            IsDuplicate = 1;
                                        }
                                    });

                                    if (IsDuplicate==0) {
                                        AddItemRow(CopyToSetId, CopySetName, responseData[i].ItemName, responseData[i].ItemID, responseData[i].Qty);

                                    }                                  

                                }

                            }
                        });
                    }
                });

            } else {
                modelAlert("Please Select Copy From Set Name.")
                return false;
            }


        }


    </script>



</asp:Content>

