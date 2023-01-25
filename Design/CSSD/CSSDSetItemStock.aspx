<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CSSDSetItemStock.aspx.cs" Inherits="Design_CSSD_CSSDSetItemStock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">


        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>CSSD Set Item Stock</b><br />
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
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" ClientIDMode="Static" CssClass="requiredField"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-5">
                            <input type="checkbox" id="cbOnlySetItems" />Only Set Items
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

        var Report = function () {
            var data = { deptLedgerNo: $('#ddlDept').val(), isOnlySet: $('#cbOnlySetItems').prop('checked') };

            serverCall('CSSDSetItemStock.aspx/getReport', data, function (response) {
                if (response != '')
                    window.open('../../Design/common/ExportToExcel.aspx');
                else
                    modelAlert('No Record Found.');



            });


        }

    </script>

</asp:Content>

