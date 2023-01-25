<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CSSDUsedSetDetails.aspx.cs" Inherits="Design_CSSD_CSSDUsedSetDetails" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>CSSD Used Set Details</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
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
                            <label class="pull-left">
                                Used Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSet"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Used UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" maxlength="20" id="txtUsedUHID" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFrom" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" onchange="ChkDate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="calTo" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Search" id="btnSearch" style="width: 100px; margin-top: 7px;" onclick="Search()" />
        </div>
        <script>
            $(document).ready(function () {
                bindSets(function () {


                });

            });
            var bindSets = function (callback) {

                serverCall('Services/SetMaster.asmx/LoadSetsForEdit', {}, function (response) {
                    if (String.isNullOrEmpty(response)) {
                        $('#ddlSet').append('<option value="0">No Data Bound</option>');
                    }
                    else {
                        var responseData = JSON.parse(response);
                        $('#ddlSet').bindDropDown({ defaultValue: 'Select', data: responseData, valueField: 'Set_ID', textField: 'SetName', isSearchAble: true });
                    }
                    callback(true);
                });
            }
            var Search = function () {

                var data = {
                    UsedDeptLedgerNo: $('#ddlDept').val(),
                    SetId: $('#ddlSet').val(),
                    UsedUHID: $.trim($('#UsedUHID').val()),
                    FromDate: $('#txtFromDate').val(),
                    ToDate: $('#txtToDate').val()
                }
                serverCall('CSSDUsedSetDetails.aspx/Search', data, function (response) {
                    if (response != '')
                        window.open('../../Design/common/ExportToExcel.aspx');
                    else
                        modelAlert('No Record Found');

                });


            }
        </script>
</asp:Content>

