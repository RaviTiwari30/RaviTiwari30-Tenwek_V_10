<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SendCSSDRequision.aspx.cs" Inherits="Design_CSSD_SendCSSDRequision" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Send CSSD Requisition</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rblProcessType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" onchange="bindSets(function(){});">
                                <asp:ListItem Text="Request" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Return" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlToDepartment" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set List
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSetList" class="requiredField"></select>
                        </div>
                        <div class="col-md-2">
                            <input type="button" value="Add Items" onclick="loadItemList()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divRequisionData" style="display: none;">
            <div class="Purchaseheader">
                Set Item List
            </div>
            <div class="row">
                <table id="tablesetItemList" cellspacing="0" class="GridViewStyle" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr class="tblTitle">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 5%">S.No.<br />
                                <input type="checkbox" id="cbCheckAll" checked="checked" style="display:none;" /></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 25%; text-align: left;">Set Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 50%; text-align: left;">Item Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%" id="thAllowQty">Master Qty</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%">Request Qty</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%">Comment</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
            <div class="row" style="text-align: center;">
                <input type="button" value="Save" style="margin-top: 7px; width: 100px;" onclick="SaveRequisition()" />
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            bindSets(function () {
                $('#cbCheckAll').click(function () {
                    if ($('#cbCheckAll').prop('checked'))
                        $('[id$=cbSelect]').prop('checked', true)
                    else
                        $('[id$=cbSelect]').prop('checked', false)
                });

            });
        });
        var bindSets = function (callback) {
            var table = $('#tablesetItemList tbody').empty();
            $('#divRequisionData').hide();
            var type = $('#rblProcessType').find(':checked').val();
            if (type == 1)//For Request Load the Set Master
            {
                serverCall('Services/SetMaster.asmx/LoadSetsForEdit', {}, function (response) {
                    if (String.isNullOrEmpty(response)) {
                        $('#ddlSetList').append('<option value="0">No Data Bound</option>');
                    }
                    else {
                        var responseData = JSON.parse(response);
                        var activeSets = responseData.filter(function (i) { if (i.IsActive == 1) return i; });
                        $('#ddlSetList').bindDropDown({ defaultValue: 'Select', data: activeSets, valueField: 'Set_ID', textField: 'SetName', isSearchAble: true });
                    }
                    callback(true);
                });
            }
            else // For Return Load Used and Expired Sets
            {

                serverCall('SendCSSDRequision.aspx/LoadReturnableSets', {}, function (response) {
                    if (String.isNullOrEmpty(response)) {
                        $('#ddlSetList').append('<option value="0">No Data Bound</option>');
                    }
                    else {
                        var responseData = JSON.parse(response);
                        $('#ddlSetList').bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'Set_Id', textField: 'SetName', isSearchAble: true });
                    }
                    callback(true);
                });

            }


        }
        var loadItemList = function () {
            if (validData()) {
                var type = $('#rblProcessType').find(':checked').val();


                if (type == 1)//For Request Load the Set Master
                {
                    var setId = $('#ddlSetList').val();
                    serverCall('SendCSSDRequision.aspx/loadSetItems', { setId: setId }, function (response) {
                        if (response != '') {
                            var responseData = JSON.parse(response);
                            for (var i = 0; i < responseData.length; i++) {
                                AddItemRow(responseData[i].SetID, responseData[i].SetID, responseData[i].SetName, responseData[i].ItemName, responseData[i].ItemID, responseData[i].Qty);
                            }
                            $('#thAllowQty').text('Master Qty');
                        }
                        checkSendDataList();


                    });
                }
                else // For Return Load Used and Expired Sets
                {
                    var selectedValue = $('#ddlSetList').val();
                    serverCall('SendCSSDRequision.aspx/loadReturnableSetItems', { setId: selectedValue.split('#')[1], requestId: selectedValue.split('#')[0] }, function (response) {
                        if (response != '') {
                            var responseData = JSON.parse(response);
                            for (var i = 0; i < responseData.length; i++) {
                                AddItemRow(responseData[i].SetIdSelected, responseData[i].setId, responseData[i].SetName, responseData[i].ItemName, responseData[i].ItemID, responseData[i].Qty);
                            }
                            $('#thAllowQty').text('Available Qty');
                        }
                        checkSendDataList();


                    });

                }
            }



        }
        var validData = function () {
            if ($('#ddlToDepartment').val() == '0') {
                modelAlert('Please Select Requesting Department.', function () {
                    $('#ddlToDepartment').focus();
                });
                return false;

            }

            if ($('#ddlSetList').val() == '0') {
                modelAlert('Please Select Any Set.', function () {
                    $('#ddlSetList').focus();
                });
                return false;

            }

            $isDuplicate = 0;
            $('#tablesetItemList tbody tr').each(function () {
                if (($(this).find('#tdSelectedId').text() == $('#ddlSetList').val()))
                    $isDuplicate = 1;


            });
            if ($isDuplicate == 1) {
                modelAlert('Set Already Selected.');
                return false;

            }
            else
                return true;
        }
        var checkSendDataList = function () {
            if ($('#tablesetItemList tbody tr').length > 0)
                $('#divRequisionData').show();
            else
                $('#divRequisionData').hide();

        }
        var AddItemRow = function ($selectedId,$setId, $setName, $itemName, $itemId, $qty) {

            var table = $('#tablesetItemList tbody');
            var tablelength = $('#tablesetItemList tbody tr').length;
            var appendString = '<tr>';
            appendString += '<td  class="GridViewLabItemStyle" style="text-align:center;">' + (tablelength + 1) + '.<input type="checkbox" id="cbSelect" checked="checked" style="display:none;" /></td>';
            appendString += '<td id="tdSetName" class="GridViewLabItemStyle" style="text-align:left;">' + $setName + '</td>';
            appendString += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align:left;">' + $itemName + '</td>';
            appendString += '<td id="tdMasterQty" class="GridViewLabItemStyle" style="text-align:center;">' + $qty + '</td>';
            appendString += '<td class="GridViewLabItemStyle"  style="text-align:center;"><input type="text" id="txtQty" class="ItDoseTextinputNum requiredField" onlynumber="5" autocomplete="off" value="' + $qty + '" max-value="' + $qty + '"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" disabled /></td>';
            appendString += '<td id="tdItemId" style="display:none;">' + $itemId + '</td>';
            appendString += '<td id="tdSetId" style="display:none;">' + $setId + '</td>';
            appendString += '<td id="tdSelectedId" style="display:none;">' + $selectedId + '</td>';

            appendString += '<td id="tdComment" ><textarea type="text" id="txtComment" style="width: 200px;"></textarea></td>';

            appendString += '</tr>';
            table.append(appendString);


        }
        var SaveRequisition = function () {
            requestType = "Requested";
            if ($('#rblProcessType').find(':checked').val() == 2)
                requestType = "Returned";

            var dataList = [];
            $('#tablesetItemList tbody tr').each(function () {
                if ($(this).find('#cbSelect').prop('checked')) {
                    var retrunAgainstRequestId = '';
                    if ($('#rblProcessType').find(':checked').val() == 2)
                        retrunAgainstRequestId = $(this).find('#tdSelectedId').text().split('#')[0];
                    dataList.push({
                        setId: $(this).find('#tdSetId').text(),
                        itemId: $(this).find('#tdItemId').text(),
                        setName: $(this).find('#tdSetName').text(),
                        itemName: $(this).find('#tdItemName').text(),
                        masterQty: $(this).find('#tdMasterQty').text(),
                        reqQty: Number($(this).find('#txtQty').val()),
                        requestType: requestType,
                        retrunAgainstRequestId: retrunAgainstRequestId,
                        Comment: $(this).find('#txtComment').val()
                    });
                }
            });
            if (dataList.length == 0) {
                modelAlert('Please Select Atleast One Item.');
                return false;
            }

            var zeroQtyItem = dataList.filter(function (i) { if (i.reqQty == 0) { return i; } })
            if (zeroQtyItem.length > 0) {
                modelAlert('Item : <span class="patientInfo">' + zeroQtyItem[0].itemName + '</span> In Set  :<span class="patientInfo">' + zeroQtyItem[0].setName + '</span> has zero Qty.Please Check.');
                return false;
            }
            serverCall('SendCSSDRequision.aspx/SaveRequisition', { data: dataList, toDeptLedgerNo: $('#ddlToDepartment').val() }, function (response) {
                var resposeData = JSON.parse(response);
                modelAlert(resposeData.response, function () {
                    if (resposeData.status)
                        location.reload();
                });

            });

        }
    </script>

</asp:Content>

