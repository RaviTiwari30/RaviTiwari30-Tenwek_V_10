<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CSSDSetLocationDetails.aspx.cs" Inherits="Design_CSSD_CSSDSetLocationDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">


        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>CSSD Set Location Details</b><br />
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
                                Set List
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSetList"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Location
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Report" style="width: 100px; margin-top: 7px;" onclick="Report()" />
        </div>
    </div>
    <script>
        $(document).ready(function () {
            bindSets(function () {
                $('#ddlDept').chosen();
            });
        });
        var bindSets = function (callback) {
            serverCall('Services/SetMaster.asmx/LoadSetsForEdit', {}, function (response) {
                if (String.isNullOrEmpty(response)) {
                    $('#ddlSetList').append('<option value="0">No Data Bound</option>');
                }
                else {
                    var responseData = JSON.parse(response);
                    $('#ddlSetList').bindDropDown({ defaultValue: 'ALL', data: responseData, valueField: 'Set_ID', textField: 'SetName', isSearchAble: true });
                }
                callback(true);
            });


        }

        var Report = function () {
            var data = {setId:$('#ddlSetList').val(),deptLedgerNo: $('#ddlDept').val()};

            serverCall('CSSDSetLocationDetails.aspx/getReport', data, function (response) {
                if (response != '')
                    window.open('../../Design/common/ExportToExcel.aspx');
                else
                    modelAlert('No Record Found.');



            });


        }

    </script>
</asp:Content>

