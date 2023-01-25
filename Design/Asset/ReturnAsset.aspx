<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReturnAsset.aspx.cs" Inherits="Design_Asset_ReturnAsset" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <style type="text/css">
        .selectedRow
        {
            background-color: aqua;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            bindDepartment(function () {
            });
        });

        var bindDepartment = function (callback) {
            ddlReqDepartment = $('#ddlReqDepartment');
            serverCall('Services/AssetIssue.asmx/BindDepartment', {}, function (response) {
                ddlReqDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
                callback(ddlReqDepartment.val());
            });
        }


        var Search = function () {
            data = {
                fromdate: $('#txtFromDate').val(),
                todate: $('#txtToDate').val(),
                deptledgerno: $('#ddlReqDepartment').val(),
                requesttype: $('#ddlRequestType option:selected').text(),
                indentno: $('#txtIndentNo').val().trim(),
                status: $('#ddlStatus').val(),
            }
            serverCall('Services/AssetReturn.asmx/SearchReturnIndent', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length)
                    bindIndentData(responseData);
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
                if (data[i].VIEW == 'true')
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="ReturnIndent(this);" style="cursor: pointer;" title="Click To Return" /></td>';
                else
                    row += '<td class="GridViewLabItemStyle" style="text-align: center;"></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="SearchIndentDetails(this);" style="cursor: pointer;" title="Click To View Details" /></td>';


                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].LedgerNumber + '</td>';
                row += '</tr>';
                $($table).append(row);
            }

        }

        var ReturnIndent = function (rowID) {
            var row = $(rowID).closest('tr');
            var IndentNo = $(row).find('#tdIndentNo').text().trim();
            serverCall('Services/AssetReturn.asmx/SearchReturnIndentDetails', { IndentNo: IndentNo }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('.indentDetail').show();
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
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BatchNumber + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ModelNo + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SerialNo + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetNo + '</td>';
                row += '<td id="tdRemarks" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].Narration + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="checkbox" onchange="ValidatetoReturn(this);"></td>';
                row += '<td id="tdAssetID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].AssetID + '</td>';
                row += '<td id="tdStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].StockID + '</td>';
                row += '<td id="tdItemID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '</tr>';
                $($table).append(row);
            }
        }
        var ValidatetoReturn = function (rowID) {
            var row = $(rowID).closest('tr');
            if (!$(rowID).is(':checked')) {
                row.removeClass('selectedRow');
            } else {
                row.addClass('selectedRow');
            }
        }

        var Save = function () {
            getReturnDetails(function (data) {
                serverCall('Services/AssetReturn.asmx/SaveReturnIndent', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status)
                        modelAlert(responseData.response, function () {
                            printAssetReturnReceipt(responseData.SalesNo, function () {
                            window.location.reload();
                            });
                        });
                    else
                        modelAlert(responseData.response);
                });
            });
        }

        var getReturnDetails = function (callback) {
            var table = $('#tblIndentItems tbody tr input[type=checkbox]:checked');
            var rtnItems = [];
            $(table).closest('tr').each(function (i, e) {
                rtnItems.push({
                    StockID: $(e).find('#tdStockID').text().trim(),
                    ItemID: $(e).find('#tdItemID').text().trim(),
                    AssetID: $(e).find('#tdAssetID').text().trim(),
                    ItemName: $(e).find('#tdItemName').text().trim(),
                    FromDepartment: $('#spnFromDeptID').text().trim(),
                    IndentNo: $('#spnIndentNo').text().trim(),
                });
            });
            if (rtnItems.length < 1) {
                modelAlert('Please Select Any Item to Save Return');
                return false;
            }
            callback({ SavereturnItems: rtnItems });
        }
        var printAssetReturnReceipt = function (SalesNo,callback) {
            serverCall('Services/AssetReturn.asmx/ReprintDepartmentReturnReciept', { salesno: SalesNo }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    modelAlert(responseData.response, function () { });
            });
            callback(true);
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Accept Asset Return Request</b>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Date </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">From Department</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlReqDepartment"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Request Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlRequestType" ToolTip="Select Requisition Type" runat="server" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
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
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <input type="button" id="btnSearch" value="Search" tabindex="4" onclick="Search()" />
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
                        <th class="GridViewHeaderStyle" style="width: 30px;">Return</th>
                        <th class="GridViewHeaderStyle" style="width: 30px;">Details</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
        <div class="POuter_Box_Inventory indentDetail" style="display: none">
            <div class="Purchaseheader">
                Indent Details
            </div>
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
            <%--</div>
        <div class="POuter_Box_Inventory indentDetail" style="display:none">--%>
            <div class="row">
                <div class="col-md-24">
                    <table class="FixedHeader" id="tblIndentItems" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">#</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">ItemName</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">BatchNo</th>
                                <th class="GridViewHeaderStyle" style="width: 30px;">ModelNo</th>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SerialNo</th>
                                <th class="GridViewHeaderStyle" style="width: 30px;">AssetNo</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Narration</th>
                                <th class="GridViewHeaderStyle" style="width: 30px;">#</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory indentDetail" style="text-align: center;display:none">
            <div class="row">
                <input type="button" id="btnSave" value="Save" tabindex="4" onclick="Save()" />
            </div>
        </div>
    </div>

</asp:Content>
