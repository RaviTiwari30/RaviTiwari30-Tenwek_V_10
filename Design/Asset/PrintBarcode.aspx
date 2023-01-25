<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PrintBarcode.aspx.cs" Inherits="Design_Asset_PrintBarcode" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <script type="text/javascript">
        $(document).ready(function () {
            loadSupplier(function () {
                loadManufacturer(function () {

                });
            });
        });

        var loadSupplier = function (callback) {
            ddlSupplier = $('#ddlSupplier');
            serverCall('Services/WebService.asmx/loadSupplier', {}, function (response) {
                ddlSupplier.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'LedgerName', isSearchAble: true });
                callback(ddlSupplier.val());
            });
        }
        var loadManufacturer = function (callback) {
            ddlManufacturer = $('#ddlManufacturer');
            serverCall('Services/WebService.asmx/LoadManufacturer', {}, function (response) {
                ddlManufacturer.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ManufactureID', textField: 'NAME', isSearchAble: true });
                callback(ddlManufacturer.val());
            });
        }
        var Search = function () {
            data = {
                fromdate: $('#txtFromDate').val(),
                todate: $('#txtToDate').val(),
                supplierID: $('#ddlSupplier').val(),
                manufacturerID: $('#ddlManufacturer').val(),
                searchnoID: $('#ddlSearchNo').val(),
                searchnoValue: $('#txtSearchNo').val(),
                searchbyID: $('#ddlSearchBy').val(),
                searchbyValue: $('#txtSearchBy').val(),
            }
            serverCall('Services/WebService.asmx/SearchItemstoBarcode', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('.searchdata').show();
                    bindItems(responseData);
                }
                else {
                    $('.searchdata').hide();
                    modelAlert('No Record Found');
                }
            });
        }
        var bindItems = function (data) {
            $table = $('#tblItems tbody');
            $($table).empty();
            for (var i = 0; i < data.length; i++) {
                var j = $($table).find('tr').length + 1;
                var row = '';
                row += '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdpurchaseDate" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PurchaseDate + '</td>';
                row += '<td id="tdgrnNo" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].GRNNo + '</td>';
                row += '<td id="tdinvoiceNo"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].InvoiceNo + '</td>';
                row += '<td id="tdsupplier"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SupplierName + '</td>';
                row += '<td id="tditemName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td id="tdmanufacturer"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ManufacturerName + '</td>';
                row += '<td id="tdbatchNo"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BatchNumber + '</td>';
                row += '<td id="tdmodelNo"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ModelNo + '</td>';
                row += '<td id="tdserialNo"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SerialNo + '</td>';
                row += '<td id="tdassetNo"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].AssetNo + '</td>';
                row += '<td id="tdassetID" class="GridViewLabItemStyle" style="text-align: center;display:none">' + data[i].AssetID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="checkbox"></td>';
                row += '</tr>';
                $($table).append(row);
            }
        }
        var Print = function () {
            var BarcodeDetails = [];
            var AssetIDs = '';
            table = $('#tblItems tbody tr input[type=checkbox]:checked');
            $(table).closest('tr').each(function () {
                //BarcodeDetails.push({
                //    AssetID: $(this).find("#tdassetID").text().trim(),
                //    //PurchaseDate: $(this).find("#tdpurchaseDate").text().trim(),
                //    //GRNNo: $(this).find("#tdgrnNo").text().trim(),
                //    //InvoiceNo: $(this).find("#tdinvoiceNo").text().trim(),
                //    //ItemName: $(this).find("#tditemName").text().trim(),
                //    //Manufacturer: $(this).find("#tdmanufacturer").text().trim(),
                //    //BatchNo: $(this).find("#tdbatchNo").text().trim(),
                //    //ModelNo: $(this).find("#tdmodelNo").text().trim(),
                //    //SerialNo: $(this).find("#tdserialNo").text().trim(),
                //    //AssetNo: $(this).find("#tdassetNo").text().trim(),
                //});
                if (String.isNullOrEmpty(AssetIDs)) {
                    AssetIDs = $(this).find("#tdassetID").text().trim();
                }
                else
                    AssetIDs = AssetIDs + ',' + $(this).find("#tdassetID").text().trim();
            });
            if (String.isNullOrEmpty(AssetIDs)) {
                modelAlert('Please Select Any Asset');
                return false;
            }
            $('#lblAssetID').val(AssetIDs);
            //serverCall('PrintBarcode.aspx/PrintBarcode', { AssetIDs:AssetIDs }, function (response) {
            //    var responseData = JSON.parse(response);
            //    if (responseData.status) {
            //        window.open(responseData.responseURL);
            //    }
            //});
            $("#btnSave").click();
        }
    </script>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <asp:ScriptManager ID="smManager" runat="server"></asp:ScriptManager>
            <div style="text-align: center">
                <b>Print Asset Barcode</b>
            <%--    <asp:Label ID="lblAssetID" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>--%>
                <asp:TextBox ID="lblAssetID" runat="server" ClientIDMode="Static" style="display:none"></asp:TextBox>
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
                        <label class="pull-left">Supplier</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlSupplier"></select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Manufacturer</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select id="ddlManufacturer"></select>
                    </div>
                    <div class="col-md-3">
                        <div class="pull-left">
                            <select id="ddlSearchNo">
                                <option value="1">GRN No.</option>
                                <option value="2">Invoice No.</option>
                            </select>
                        </div>
                        <div><b class="pull-right">:</b></div>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtSearchNo" maxlength="50" />
                    </div>
                    <div class="col-md-3">
                        <div class="pull-left">
                            <select id="ddlSearchBy">
                                <option value="1">Item Name</option>
                                <option value="2">Batch No</option>
                                <option value="3">Model No</option>
                                <option value="4">Serial No</option>
                                <option value="5">Asset No</option>
                            </select>
                        </div>
                        <div><b class="pull-right">:</b></div>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="txtSearchBy" maxlength="50" />
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
        <div class="POuter_Box_Inventory searchdata" style="display:none">
            <div class="Purchaseheader">Item Details</div>
            <div class="row">
                <table id="tblItems" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Purchase Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">GRN No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Invoice No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Supplier</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Item Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Manufacturer</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Batch No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Model No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Serial No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Asset No</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 20px;"><input type="checkbox" onchange="$('#tblItems tbody tr td input[type=checkbox]').prop('checked',this.checked)" /></th>
                        </tr>
                    </thead>
                    <tbody class="asset">
                    </tbody>
                </table>
            </div>
        </div>
         <div class="POuter_Box_Inventory searchdata" style="text-align:center;display:none">
             <div class="row">
                 <input type="button" id="btnPrint" value="Print Barcode" onclick="Print()" />
                 <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" style="display:none" ClientIDMode="Static" />
             </div>
         </div>
    </div>

</asp:Content>
