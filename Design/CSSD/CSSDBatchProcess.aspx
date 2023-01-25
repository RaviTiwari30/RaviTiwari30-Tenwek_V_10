<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CSSDBatchProcess.aspx.cs" Inherits="Design_CSSD_CSSDBatchProcess" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Process Set In Batch</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3" style="display: none;">
                            <label class="pull-left">
                                Process Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7" style="display: none;">
                            <asp:RadioButtonList ID="rblProcessType" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" onchange="bindRequestList(function(){});">
                                <asp:ListItem Text="CSSD Sets" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Returned Sets" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set List
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <select id="ddlRequestList" class="requiredField"></select>
                        </div>
                        <div class="col-md-3">
                            <input type="button" value="Add Items" onclick="AddItems()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Batch Items List
            </div>
            <div class="row" style="height: 350px; overflow-y: scroll;">
                <table id="tablesetItemList" cellspacing="0" class="GridViewStyle" style="width: 100%; border-collapse: collapse; display: none">
                    <thead>
                        <tr class="tblTitle">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 5%">S.No.<br />
                                <input type="checkbox" id="cbCheckAll" checked="checked" onclick="checkAll(this)" /></th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%; text-align: left; display: none;">Request/Return Id</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30%; text-align: left;">Set Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 15%; text-align: left;">Department</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%;text-align:center;">Total Items</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%;display: none;">Stock Qty</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%; display: none;">Request Qty</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 10%">View Items</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Approx Start Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="FrmDate" runat="server" ToolTip="Enter Approx Start Date" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFrmDate" runat="server" TargetControlID="FrmDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtFromTime" runat="server" MaxLength="5" ToolTip="Enter Approx Start Time" ClientIDMode="Static"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtFromTime" AcceptAMPM="True">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Approx End Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="ToDate" runat="server" ToolTip="Enter Approx End Date"
                                onchange="javascript:ValidateDate();" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtToTime" ToolTip="Enter Approx End Time" runat="server"
                                MaxLength="5" ClientIDMode="Static"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTo" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtToTime"
                                AcceptAMPM="True">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTo" runat="server" ControlToValidate="txtToTime"
                                ControlExtender="masTo" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Boiler Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <select id="ddlBoilerType" class="requiredField"></select>
                        </div>
                        <div class="col-md-1">
                            <input type="button" value="New" onclick="$('#divBoilerMaster').showModel();" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemarks" ClientIDMode="Static" runat="server" TextMode="MultiLine" MaxLength="100"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Save" id="btnSave" style="width: 100px; margin-top: 7px;" disabled="disabled" onclick="SaveData()" />
        </div>
    </div>

    <div id="divBoilerMaster" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1000px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divBoilerMaster" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Create/Update Boiler Type</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Select Boiler</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlEditBoiler" onchange="getEditDetails()">
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBoilerName" class="form-control ItDoseTextinputText requiredField" autocomplete="off" maxlength="100" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Serial No.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSerialNo" class="form-control ItDoseTextinputText" autocomplete="off" maxlength="100" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Batch Prefix</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPreFix" maxlength="20" autocomplete="off" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
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
                    <button type="button" onclick="SaveBoiler()" id="btnSaveBoiler">Create New</button>
                    <button type="button" data-dismiss="divBoilerMaster">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div id="divSetItemDetails" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1000px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divSetItemDetails" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Set Item Details</h4>
                </div>
                <div class="modal-body">
                    <div class="row" id="divItems" style="max-height:300px;overflow-y:scroll;">
                       
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="divSetItemDetails">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            bindBoiler(function () {
                bindRequestList(function () {

                });
            });

        });


        var bindBoiler = function (callback) {
            serverCall('CSSDBatchProcess.aspx/getBoilerList', {}, function (response) {
                if (String.isNullOrEmpty(response)) {
                    $('#ddlBoilerType,#ddlEditBoiler').append('<option value="0">No Data Bound</option>');
                }
                else {
                    var responseData = JSON.parse(response);
                    $('#ddlEditBoiler').bindDropDown({ defaultValue: 'New', data: responseData, valueField: 'BoilerId', textField: 'NAME', isSearchAble: true });
                    var activeData = responseData.filter(function (i) { if (i.isActive == 1) return i; });
                    $('#ddlBoilerType').bindDropDown({ defaultValue: 'Select', data: activeData, valueField: 'BoilerId', textField: 'NAME', isSearchAble: true });

                }
                callback(true);
            });


        }

        var bindRequestList = function (callback) {
            $('#tablesetItemList tbody').empty();
            $('#tablesetItemList').hide();
            $('#btnSave').attr('disabled');
            var type = $('#rblProcessType').find(':checked').val();
            serverCall('CSSDBatchProcess.aspx/getSetList', { searchType: type }, function (response) {
                if (String.isNullOrEmpty(response)) {
                    $('#ddlRequestList').empty();
                    $('#ddlRequestList').append('<option value="0">No Data Bound</option>');
                }
                else {
                    var responseData = JSON.parse(response);
                    $('#ddlRequestList').bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'id', textField: 'name', isSearchAble: true });

                }
                callback(true);

            });

        }
        var AddItems = function () {
            if (validateRequest()) {
                var id = $('#ddlRequestList').val();
                serverCall('CSSDBatchProcess.aspx/getSetDetails', { setStockId: id }, function (response) {
                    var responseData = JSON.parse(response);
                    AddSetRow(responseData[0]);
                });

            }






            //if (validateRequest()) {
            //    var type = $('#rblProcessType').find(':checked').val();
            //    var id = $('#ddlRequestList').val();
            //    serverCall('CSSDBatchProcess.aspx/GetRequestDetails', { searchType: type, id: id }, function (response) {
            //        if (!String.isNullOrEmpty(response)) {
            //            var responseData = JSON.parse(response);
            //            for (var i = 0; i < responseData.length; i++) {
            //                var allowQty = responseData[i].reqQty;
            //                if (responseData[i].reqQty > responseData[i].StockQty)
            //                    allowQty = 0;
            //                //allowQty = responseData[i].StockQty;
            //                AddItemRow(responseData[i].RequestId, responseData[i].setId, responseData[i].SetName, responseData[i].ItemName, responseData[i].itemId, responseData[i].masterQty, responseData[i].StockQty, responseData[i].reqQty, allowQty, type);
            //            }
            //        }
            //    });
            //}
        }
        //var AddItemRow = function ($requestId, $setId, $setName, $itemName, $itemId, $masterQty, $stockQty, $requestedQty, $allowQty, $processType) {

        //    var table = $('#tablesetItemList tbody');
        //    var tablelength = $('#tablesetItemList tbody tr').length;
        //    var appendString = '<tr>';
        //    appendString += '<td  class="GridViewLabItemStyle" style="text-align:center;">' + (tablelength + 1) + '.<input type="checkbox" id="cbSelect" checked="checked" /></td>';
        //    appendString += '<td id="tdRequestId" class="GridViewLabItemStyle" style="text-align:left;display:none;">' + $requestId + '</td>';
        //    appendString += '<td id="tdSetName" class="GridViewLabItemStyle" style="text-align:left;">' + $setName + '</td>';
        //    appendString += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align:left;">' + $itemName + '</td>';
        //    appendString += '<td id="tdMasterQty" class="GridViewLabItemStyle" style="text-align:center;">' + $masterQty + '</td>';
        //    appendString += '<td id="tdStockQty" class="GridViewLabItemStyle" style="text-align:center;">' + $stockQty + '</td>';
        //    appendString += '<td id="tdRequestedQty" class="GridViewLabItemStyle" style="text-align:center;display:none;">' + $requestedQty + '</td>';
        //    appendString += '<td class="GridViewLabItemStyle"  style="text-align:center;"><input type="text" id="txtQty" class="ItDoseTextinputNum requiredField" onlynumber="5" autocomplete="off" value="' + $allowQty + '" max-value="' + $allowQty + '"  onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" disabled="disabled" /></td>';
        //    appendString += '<td id="tdItemId" style="display:none;">' + $itemId + '</td>';
        //    appendString += '<td id="tdSetId" style="display:none;">' + $setId + '</td>';
        //    appendString += '<td id="tdProcessType" style="display:none;">' + $processType + '</td>';
        //    appendString += '</tr>';
        //    table.append(appendString);
        //    showHideItemList();

        //}


        var AddSetRow = function (data) {

            var table = $('#tablesetItemList tbody');
            var tablelength = $('#tablesetItemList tbody tr').length;
            var appendString = '<tr>';
            appendString += '<td  class="GridViewLabItemStyle" style="text-align:center;">' + (tablelength + 1) + '.<input type="checkbox" id="cbSelect" checked="checked" /></td>';
            appendString += '<td id="tdSetName" class="GridViewLabItemStyle" style="text-align:left;">' + data.name + '</td>';
            appendString += '<td id="tdSetDept" class="GridViewLabItemStyle" style="text-align:left;">' + data.setDepartment + '</td>';
            appendString += '<td id="tdTotalItems" class="GridViewLabItemStyle" style="text-align:center;">' + data.ItemCount + '</td>';
            appendString += '<td class="GridViewLabItemStyle" style="text-align:center;"><img alt="Select" src="../../Images/view.GIF" style="border: 0px solid #FFFFFF;cursor:pointer;" onclick="getSetItems(this)"></td>';
            appendString += '<td class="GridViewLabItemStyle" style="text-align:center;display:none;" id="tdSetId">' + data.setId + '</td>';
            appendString += '<td class="GridViewLabItemStyle" style="text-align:center;display:none;" id="tdSetStockId">' + data.SetStockID + '</td>';
            appendString += '</tr>';
            table.append(appendString);
            showHideItemList();

        }


        var validateRequest = function () {
            if ($('#ddlRequestList').val() == '0') {
                modelAlert('Please Select Any Set.', function () {
                    $('#ddlRequestList').focus();
                });
                return false;

            }
            $isDuplicate = 0;
            $('#tablesetItemList tbody tr').each(function () {
                if ($(this).find('#tdSetStockId').text() == $('#ddlRequestList').val())
                    $isDuplicate = 1;

            });
            if ($isDuplicate == 1) {
                modelAlert('Set Already Added');
                return false;
            }
            else
                return true;
        }
        var checkAll = function (sender) {
            if ($(sender).prop('checked'))
                $('[id$=cbSelect]').prop('checked', true);
            else
                $('[id$=cbSelect]').prop('checked', false)

        }
        var showHideItemList = function () {
            if ($('#tablesetItemList tbody tr').length > 0) {
                $('#tablesetItemList').show();
                $('#btnSave').removeAttr('disabled');
            }
            else {
                $('#tablesetItemList').hide();
                $('#btnSave').attr('disabled');
            }

        }
        var SaveData = function () {
            if ($('#ddlBoilerType').val() == "0") {
                modelAlert('Please Select Boiler First', function () {
                    $('#ddlBoilerType').focus();
                });
                return false;

            }
            var start_time1 = $('#txtFromTime').val();
            var end_time1 = $('#txtToTime').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            var start11 = $("#FrmDate").val();
            var end11 = $("#ToDate").val();

            var splitdate11 = start11.split("-");
            var dt111 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];
            var splitdate111 = end11.split("-");
            var dt211 = splitdate111[1] + " " + splitdate111[0] + ", " + splitdate111[2];

            var newStartDate11 = Date.parse(dt111);
            var newEndDate112 = Date.parse(dt211);

            var start_time1 = $('#txtFromTime').val();
            var end_time1 = $('#txtToTime').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            if ((newStartDate11 + stt1) > (newEndDate112 + endt1)) {
                modelAlert('Approx End Date Time always greater then Start Date Time', function () {
                    $('#txtToTime').focus();
                });
                return false;
            }

            if (validateStock()) {
                var dataList = [];
                $('#tablesetItemList tbody tr').each(function () {
                    if ($(this).find('#cbSelect').prop('checked')) {
                        dataList.push({
                            setId: $(this).find('#tdSetId').text(),
                            setStockId:$(this).find('#tdSetStockId').text()
                        });

                    }
                });
                if (dataList.length == 0) {
                    modelAlert('Please Select Atleast One Set.');
                    return false;
                }

              //  var zeroQtyItem = dataList.filter(function (i) { if (i.qty == 0) { return i; } })
             //   if (zeroQtyItem.length > 0) {
             //       modelAlert('Item : <span class="patientInfo">' + zeroQtyItem[0].itemName + '</span> In Set  :<span class="patientInfo">' + zeroQtyItem[0].setName + '</span> has zero Qty.Please Check.');
            //        return false;
           //     }

                var batchDetails = { data: dataList, boilerId: $('#ddlBoilerType').val(), boilerName: $('#ddlBoilerType option:selected').html(), aStartDate: $('#FrmDate').val() + ' ' + $('#txtFromTime').val(), aEndTime: $('#ToDate').val() + ' ' + $('#txtToTime').val(), remarks: $.trim($('#txtRemarks').val()) };
                serverCall('CSSDBatchProcess.aspx/saveData', batchDetails, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                        if (responseData.status)
                            location.reload();
                    });
                });
            }

        }

        var getSetItems = function (sender) {
            $setStockId=$(sender).closest('tr').find('#tdSetStockId').text();
            serverCall('CSSDBatchProcess.aspx/getSetItemDetails', { setStockId: $setStockId }, function (response) {
                if (response != '') {
                    DataSetItemDetails  = JSON.parse(response);
                    var output = $('#tb_SetItem').parseTemplate(DataSetItemDetails );
                    $('#divItems').html(output).customFixedHeader();
                    $('#divSetItemDetails').showModel();
                }

            });


        }



        var validateStock = function () {
            var isValid = true;
            $('#tablesetItemList tbody tr').each(function () {
                if ($(this).find('#cbSelect').prop('checked')) {
                    var itemId = $(this).find('#tdItemId').text();
                    var availStock = Number($(this).find('#tdStockQty').text());
                    var requiredQty = 0;
                    $('#tablesetItemList tbody tr').each(function () {
                        if ($(this).find('#cbSelect').prop('checked') && $(this).find('#tdItemId').text() == itemId)
                            requiredQty += Number($(this).find('#txtQty').val());

                    });
                }
                if (availStock < requiredQty) {
                    isValid = false;
                    modelAlert('Total Required QTY is Greater than Available QTY of Item : <span class="patientInfo">' + $(this).find('#tdItemName').text() + '</span>.Please Check.');
                    return false;
                }

            });

            return isValid;
        }


        var getEditDetails = function () {
            var boilerId = $('#ddlEditBoiler').val();
            if (boilerId == '0' || boilerId == '') {
                clearBoilerDetails(function () { });
            } else {

                serverCall('CSSDBatchProcess.aspx/getEditBoiler', { boilerId: boilerId }, function (response) {
                    var responseData = JSON.parse(response);
                    $('#txtBoilerName').val(responseData[0].NAME);
                    $('#txtSerialNo').val(responseData[0].SerialNo);
                    $('#txtPreFix').val(responseData[0].BatchPreFix);
                    $('#ddlIsActive').val(responseData[0].IsActive);
                    $('#btnSaveBoiler').html('Update');
                });

            }


        }
        var clearBoilerDetails = function (callback) {
            $('#txtBoilerName,#txtSerialNo,#txtPreFix').val('');
            $('#ddlIsActive').val('1');
            $('#ddlEditBoiler').chosen('destroy').val('0').chosen();
            $('#btnSaveBoiler').html('Create New');
            callback(true);
        }
        var SaveBoiler = function () {

            if ($.trim($('#txtBoilerName').val()) == '') {
                modelAlert('Please Enter Boiler Name', function () {
                    $('#txtBoilerName').focus();
                });
                return false;
            }

            if ($.trim($('#txtPreFix').val()) == '') {
                modelAlert('Please Enter Any Bacth Prefix', function () {
                    $('#txtPreFix').focus();
                });
                return false;


            }

            var data = {
                boilerName: $.trim($('#txtBoilerName').val()),
                serialNo: $.trim($('#txtSerialNo').val()),
                isActive: $('#ddlIsActive').val(),
                boilerId: $('#ddlEditBoiler').val(),
                batchPrefix: $.trim($('#txtPreFix').val())
            };
            serverCall('CSSDBatchProcess.aspx/saveBoiler', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        bindBoiler(function () {
                            clearBoilerDetails(function () {

                            });
                        });
                    }

                });

            });

        }
    </script>

    <script id="tb_SetItem" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
		<tr id="trheader">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col">Set Name</th>
            <th class="GridViewHeaderStyle" scope="col">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col">Item Batch No</th>
            <th class="GridViewHeaderStyle" scope="col">QTY</th>
            
		</tr>
        <#       
        var dataLength=DataSetItemDetails.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        
        for(var j=0;j<dataLength;j++)
        {       
        objRow = DataSetItemDetails[j];
        #>
                    <tr>                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.SetName#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.ItemBatch#></td>
                    <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.QTY#></td>
                   
 </tr>   
        <#}#>                     
     </table>    
    </script>


</asp:Content>

