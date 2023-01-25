<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReprintAssetIssueReturn.aspx.cs" Inherits="Design_Asset_ReprintAssetIssueReturn" MasterPageFile="~/DefaultHome.master" %>

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
                ddlReqDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ledgerNumber', textField: 'ledgerName', isSearchAble: true });
                callback(ddlReqDepartment.val());
            });
        }

        var Search = function () {
            data = {
                deptLedgerNo: $('#ddlReqDepartment').val(),
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                indentNo: $('#txtIndentNo').val(),
                salesNo: $('#txtSalesNo').val(),
                typeoftnx: $('#ddlTypeOfTnx').val(),
            }
            serverCall('Services/AssetIssue.asmx/SearchDepartmentIssueReturn', data, function (response) {
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
                row += '<td id="tdTypeOfTnx" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TypeOfTnx + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IssueDate + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IssueTime + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].LedgerName + '</td>';
                row += '<td id="tdSalesNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].salesno + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IndentNo + '</td>';
                row += '<td id="tdDeptFrom" class="GridViewLabItemStyle" style="text-align: center;"><img id="imgPrint" src="../../Images/print.gif" onclick="Print(this);" style="cursor: pointer;" title="Click To Print" /></td>';
                row += '</tr>';
                $($table).append(row);
            }
        }

        var Print = function (rowID) {
            var row = $(rowID).closest('tr');
            var salesNo = $(row).find('#tdSalesNo').text().trim();
            var typeoftnx = $(row).find('#tdTypeOfTnx').text().trim();
            if (typeoftnx == "Issue") {
                serverCall('Services/AssetIssue.asmx/ReprintDepartmentIssue', { salesno: salesNo }, function (response) {
                    var responseData = JSON.parse(response);
                    window.open(responseData.responseURL);
                });
            } else {
                serverCall('Services/AssetReturn.asmx/ReprintDepartmentReturnReciept', { salesno: salesNo }, function (response) {
                    var responseData = JSON.parse(response);
                    window.open(responseData.responseURL);
                });
            }
        }


    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
            <div style="text-align: center">
                <b>Reprint Department Issue</b>
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
                    <div class="col-md-3">
                        <label class="pull-left">Indent No</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtIndentNo" />
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Indent No</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlTypeOfTnx">
                            <option value="0">All</option>
                            <option value="1">Issue</option>
                            <option value="2">Return</option>
                        </select>
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
          <div class="POuter_Box_Inventory searchData" style="text-align: center;display:none">
            <div class="row">
                <table id="tblItems" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr id="IssueItemHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Transaction Type</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Time</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Department</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Sales No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Indent No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">Print</th>
                        </tr>
                    </thead>
                    <tbody class="asset">
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</asp:Content>
