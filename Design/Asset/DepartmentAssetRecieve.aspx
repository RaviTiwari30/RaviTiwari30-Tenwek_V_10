<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DepartmentAssetRecieve.aspx.cs" MasterPageFile="~/DefaultHome.master" Inherits="Design_Asset_DepartmentAssetRecieve" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            bindDepartment(function () {
            });
        });

        var bindDepartment = function (callback) {
            ddlReqDepartment = $('#ddlReqDepartment');
            var dept = '<%=Session["DeptLedgerNo"]%>';
            serverCall('Services/AssetIssue.asmx/BindAllDepartment', {}, function (response) {
                ddlReqDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true, selectedValue: dept });
                callback(ddlReqDepartment.val());
            });
        }

        var Search = function () {
            data = {
                deptLedgerNo: $('#ddlReqDepartment').val(),
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                isRecieve: $('input[name=rdoStatus]:checked').val(),
                salesNo: $('#txtSalesNo').val(),
            }
            serverCall('Services/AssetIssue.asmx/SearchDepartmentRecieve', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('.searchData').show();
                    bindAssetinTables(responseData);
                }
                else {
                    $('.searchData').hide();
                    modelAlert('No Record Found');
                    $('#tblItems tbody').empty();
                }
            })
        }
        var bindAssetinTables = function (data) {
            $table = $('#tblItems tbody');
            $($table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $($table).find('tr').length + 1;
                var row = '';
                row += '<tr>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LedgerName + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IssueDate + '</td>';
                row += '<td id="tdSalesNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].salesno + '</td>';
                row += '<td id="tdIndentNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IndentNo + '</td>';
                row += '<td id="tdItemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BatchNumber + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ModelNo + '</td>';
                row += '<td id="tdSerialNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SerialNo + '</td>';
                row += '<td id="tdAssetNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetNo + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].InitialCount + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/view.gif" onclick="ShowAccessories(this);" style="cursor: pointer;" title="Click To Show Accessories" /></td>';
                if (data[i].isRecieve == '4')
                    row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;"><input type="checkbox"></td>';
                else
                    row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;"></td>';
                //   row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPrint" src="../../Images/print.gif" onclick="Print(this);" style="cursor: pointer;" title="Click To Print" /></td>';
                row += '<td id="tdFromStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].FromStockID + '</td>';
                row += '<td id="tdStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].StockID + '</td>';
                row += '<td id="tdFromStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].AssetID + '</td>';
                row += '<td id="tdFromStockID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '</tr>';
                $($table).append(row);
            }
        }
        var Save = function () {
            var table = $('#tblItems tbody tr input[type=checkbox]:checked');
            var rcvItems = [];
            $(table).closest('tr').each(function (i, e) {
                rcvItems.push({
                    StockID: $(e).find('#tdStockID').text().trim(),
                });
            });
            if (rcvItems.length < 1) {
                modelAlert('Please Select Any Item to recieve');
                return false;
            }
            modelConfirmation('Confirmation', 'Have you checked Accessories !', 'Yes', 'No', function (response) {
                if (response) {
                    serverCall('Services/AssetIssue.asmx/ReciveAssetinDepartment', { rcvItems: rcvItems }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            Search();
                        });
                    });
                }
            });
        }
        var ShowAccessories = function (rowID) {
            var row = $(rowID).closest('tr');
            var stockID = $(row).find('#tdStockID').text().trim();
            var Itemname = $(row).find('#tdItemName').text();
            var serial = $(row).find('#tdSerialNo').text();
            var assset = $(row).find('#tdAssetNo').text();
            serverCall('Services/AssetIssue.asmx/SearchAccessorieswithStock', { stockID: stockID }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('#divAccessories #spnItemName').text(Itemname);
                    $('#divAccessories #spnSerialNo').text(serial);
                    $('#divAccessories #spnAssetNo').text(assset);
                    $('#divAccessories').showModel();
                    $table = $('#tblAccessories tbody');
                    $($table).empty();
                    for (var i = 0; i < responseData.length; i++) {
                        var j = $($table).find('tr').length + 1;
                        var row = '';
                        row += '<tr>';
                        row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                        row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + responseData[i].AccessoriesName + '</td>';
                        row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + responseData[i].BatchNo + '</td>';
                        row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + responseData[i].LicenceNo + '</td>';
                        row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + responseData[i].ModelNo + '</td>';
                        row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + responseData[i].serialNo + '</td>';
                        row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + responseData[i].Quantity + '</td>';
                        row += '</tr>';
                        $($table).append(row);
                    }
                }
                else
                    modelAlert('No Accessories Found');
            });
        }

    </script>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
            <div style="text-align: center">
                <b>Asset Department Recieve</b>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="col-md-1"></div>
            <div class="col-md-22">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">From Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="cc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">To Date</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" CssClass="requiredField" ReadOnly="true"></asp:TextBox>
                        <cc1:CalendarExtender ID="cc2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Req From Dept</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlReqDepartment" class="requiredField"></select>
                    </div>
                </div>
                <div class="row">

                    <div class="col-md-3">
                        <label class="pull-left">Sales no</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtSalesNo" />
                    </div>
                    <div class="col-md-3" style="display: none">
                        <label class="pull-left">Indent No</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" style="display: none">
                        <input type="text" id="txtIndentNo" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Status</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="radio" name="rdoStatus" value="0" checked="checked" />Not Recieved
                        <input type="radio" name="rdoStatus" value="1" />Recieved
                    </div>
                </div>
            </div>
            <div class="col-md-1"></div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <input type="button" id="btnSearch" value="Search" onclick="Search()" />
            </div>
        </div>
        <div class="POuter_Box_Inventory searchData" style="text-align: center; display: none">
            <div class="row">
                <table id="tblItems" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr id="IssueItemHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Department</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Issue Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Sales No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Indent No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Item Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 120px;">Batch Number</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Model No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Serial No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Asset No</th>

                            <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">Qty</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">Acces.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">Recieve</th>
                        </tr>
                    </thead>
                    <tbody class="asset">
                    </tbody>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory searchData" style="text-align: center; display: none">
            <div class="row">
                <input type="button" id="btnRecieve" value="Recieve" onclick="Save()" />
            </div>
        </div>
    </div>
    <div id="divAccessories" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 1050px; height: 480px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divAccessories" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Accessories Details </h4>
                </div>
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Item Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <span id="spnItemName" class="patientInfo"></span>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">Serial No/Asset No</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-11">
                            <span id="spnSerialNo" class="patientInfo"></span>
                            <span class="patientInfo">&nbsp;/&nbsp; </span>
                            <span id="spnAssetNo" class="patientInfo"></span>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div style="height: 270px; max-height: 270px; overflow-x: auto">
                            <table class="FixedHeader" id="tblAccessories" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                                <thead>
                                    <tr>
                                        <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 200px;">AccessoriesName</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">BatchNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 100px;">LicenceNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">ModelNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">SerialNo</th>
                                        <th class="GridViewHeaderStyle" style="width: 80px;">Qty</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="divAccessories">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
