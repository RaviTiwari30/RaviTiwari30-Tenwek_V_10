<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DepartmentIndentIssue.aspx.cs" Inherits="Design_Store_DepartmentIndentIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>  
       <div id="Pbody_box_inventory">
           <div class="POuter_Box_Inventory" style="text-align: center;">
           <strong>Department Indent Issue</strong>
            <br />
                     <asp:Label  ID="lblDeptLedgerNo" runat="server" style="display:none" ClientIDMode="Static" ></asp:Label>
        </div>
           <div class="POuter_Box_Inventory"> 
               <div class="row"> 
                   <div class="col-md-1"></div>
          <div class="col-md-22">          
    <div class="row">
       
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Store Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <label style="margin-right:32px">                         
                               <input type="radio" id="rblStoreM" name="rblStoreType" checked="checked" value="STO00001" class="rblStoreType" />
                                <span>Medical Store</span>
                                <input type="radio" id="rblStoreG" name="rblStoreType" value="STO00002" class="rblStoreType" />
                                <span>General Store</span>
                        </label>                                
                            </div>
                            <div class="col-md-2">
                                <label class="pull-left">
                                    From Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="DateFrom" runat="server" ClientIDMode="Static"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="todalcal" TargetControlID="DateFrom" Format="dd-MMM-yyyy"
                                    runat="server">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    To Date 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="DateTo" runat="server" ClientIDMode="Static"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="todate" TargetControlID="DateTo" Format="dd-MMM-yyyy" runat="server">
                                </cc1:CalendarExtender>
                            </div>
            
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    From Centre 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                     <select id="ddlFromCentre" class="ddlFromCentre" title="Select Center"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    From Department 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                     <select id="ddlDepartment" class="ddlDepartment" title="Select Department"></select>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Requisition No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtIndentNoToSearch" autocomplete="off" data-title="Enter Indent No" maxlength="30" class="ItDoseTextinputText Alphanumeric" />
                            </div>
                        </div>
                        <div class="row">
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Sub-Group
                                </label>
                                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                 <select id="ddlSubGroup" class="ddlSubGroup" title="Select SubGroup"></select>
                        </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Status
                                </label>
                                <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                 <select id="ddlStatus" class="ddlStatus" title="Select Status" onchange="SearchIndent('0')">
                                     <option value="" selected="selected">ALL</option>
                                      <option value="OPEN">OPEN </option>
                                      <option value="CLOSE">CLOSE</option>
                                         <option value="REJECT">REJECT</option>
                                         <option  value="PARTIAL">PARTIAL</option>
                                 </select>
                        </div>                            
                          <div class="col-md-7">
                              <label style="color:aquamarine;font-size: 23px;">&#x25CF</label> <label>Pending</label> 
                              <label style="color:green;font-size: 23px;">&#x25CF;</label><label>Issued</label>
                                  <label style="color:#e4324c;font-size: 23px;">&#x25CF;</label> <label>Reject</label> 
                              <label style="color:Yellow;font-size: 23px;">&#x25CF;</label><label>Partial</label>
                          </div>
                    </div>
                        <div class="row" style="text-align: center;">
                            <input type="button" id="btnSearchIndent" value="Search" class="Search margin-top-on-btn" onclick="SearchIndent('0')" />
                        </div>
              </div>
                   </div> 
               <div class="row"></div><div class="row"></div>
                                     <div class="hidden row" id="DivOnIndent">
                   <div class="Purchaseheader">
                   Indent Details
                   </div>                            
                <div style="max-height:200px;overflow-y:auto;" class="DivIndentSearch hidden"></div>                                                              
             </div>
              </div>             
            <div class="POuter_Box_Inventory hidden" id="DivOnItem" >
             <%--    <div class="row" style="text-align: center;">
           <strong>Add Item Manualy</strong>
            <br />
        </div>--%>
                   <div class="row"> 
                   <div class="col-md-1"></div>    
             <div class="col-md-22">
                 <div class="col-md-1"></div>
                <div class="col-md-23">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Search By</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4 pull-left">
                            <input type="radio" id="rdoTypeItem" class="rdoSearchBy pull-left" name="rdoSearchBy" onclick="onSearchTypeChange(this)" checked="checked" value="1" /><span class="pull-left">Item</span>
                            <input type="radio" id="rdoTypeGeneric" class="rdoSearchBy pull-left" name="rdoSearchBy" onclick="onSearchTypeChange(this)" value="2" /><span class="pull-left"> Generic</span>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Search Type</label>
                            <b class="pull-right withGeneric">:</b>
                        </div>
                         <div class="col-md-4 pull-left">
                             <input type="radio" class="rdoIsManualSearch pull-left" value="false" id="rdoManualSearch" checked="checked"  name="rdoIsManualSearch" onclick="onIsManualChange(this)" /><span class="pull-left">Manual</span> 
                             <input type="radio" class="rdoIsManualSearch pull-left" value="true"  id="rdoBarcodeSearch" name="rdoIsManualSearch" onclick="onIsManualChange(this)" /> <span class="pull-left">Barcode</span> 
                         </div>
                        <div class="col-md-3">
                            <label class="pull-left withGeneric">With Generic</label>
                            <b class="pull-right withGeneric">:</b>
                        </div>
                         <div class="col-md-3 pull-left">
                             <input type="radio" class="rdoWithAlt withGeneric pull-left" value="true" onclick="onIsWithAlternateChange()" name="rdoWithAlt" /><span class="pull-left withGeneric">Yes</span> 
                             <input type="radio" class="rdoWithAlt withGeneric pull-left" value="false" onclick="onIsWithAlternateChange()" checked="checked"   name="rdoWithAlt" /> <span class="pull-left withGeneric">No</span> 
                         </div>
                       <div class="col-md-2 pull-right">
                              <label style="color:rgba(252, 114, 51, 1);font-size: 23px;">&#x25CF</label> <label>Alternet</label>
                       </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">By First Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-11 pull-left">
                            <input type="text" id="txtItemSearch" tabindex="6" class="easyui-combogrid" />
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">Quantity</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <input type="text" id="txtQuantity" autocomplete="off" onlynumber="10" " max-value="1000" decimalplace="4"  onkeyup="addItem(event)" tabindex="7" />
                        </div>
                        <div class="col-md-1">
                            <input type="button" value="Add" onclick="addItem(event)" class="pull-left" />
                        </div>

                          <div class="col-md-3 pull-right">
                         
                             <label style="color:rgba(77, 0, 253, 1);font-size: 23px;">&#x25CF;</label><label>New</label>
                                  <label style="color:rgba(228, 50, 76, 1);font-size: 23px;">&#x25CF;</label> <label>Reject</label> 
                          </div>
                    </div>
                </div>
             
             </div>
                  </div>                  
            <div class="row"></div><div class="row"></div>
                    <div class="row">
                        <div class="Purchaseheader">
                   Itemm Details
                   </div> 
                        <div id="divIndentItemsDetails" style="height:200px;overflow-y:auto;">                           
                </div>
                           
            </div>
                 
                <div class="row">
                      <div style="text-align: center">
               <%--<label>
                   <input type="checkbox" class="chkPrint" id="chkPrint" name="chkPrint" checked="checked" value="Print Requisition"/>Print Requisition</label>--%>
                 &nbsp;<input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="SaveIndent(this)" />
                   <label class="hidden" runat="server" clientidmode="Static" id="lblUserID"></label>                  
                   <label class="hidden" id="lblBarcode"></label>
                   </div>
                </div>                 
      </div>
     <div id="DivIndentDeatailSearchPOPUP" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1050px">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$closeIndentDetailSearchModel()"   aria-hidden="true">&times;</button>
                <h4 class="modal-title">Indent Details</h4>
            </div>
            <div class="modal-body">
                <div style="height:200px"  class="row">
                    <div class="col-md-24">
                          <div style="height: 250px; overflow: auto;" class="DivIndentSearchDetail hidden"></div>                        
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button"  onclick="$closeIndentDetailSearchModel()">Close</button>
            </div>
        </div>
    </div>
</div>
      <div id="DivItemPopUp" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 1050px">
            <div class="modal-header">
                <button type="button" class="close"  onclick="$closeItemPopUpModel()"   aria-hidden="true">&times;</button>
                <h4 class="modal-title">Item Details</h4>
            </div>
            <div class="modal-body">
                <div style="height:200px"  class="row">
                    <div class="col-md-24">
                          <div style="height: 250px; overflow: auto;" class="DivItemPopUpContent"></div>                        
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button"  onclick="$closeItemPopUpModel()">Close</button>
            </div>
        </div>
    </div>
</div>
           <div id="divRejectReason" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divRejectReason" aria-hidden="true">×</button>
                    <h4 class="modal-title">Reject Reason</h4>
                    <label indentNo="" style="display:none" id="lblRejectItemID"></label>
                     <label  style="display:none" id="lblRow"></label>
                </div>
                <div class="modal-body">
                    <div class="row">
                       <div class="col-md-24 patientInfo"></div>
                    </div>
                     <div class="row">
                         <div class="col-md-24">
                              <textarea cols="" rows="" style="height:82px;min-width:285px" ></textarea>
                          </div>
                      </div>
                </div>
                  <div class="modal-footer">
                         <button type="button" onclick="rejectIndentItem()">Reject</button>
                         <button type="button" data-dismiss="divRejectReason">Close</button>
                </div>
            </div>
        </div>
    </div>

          </div>
    <script type="text/javascript">
        
        $(document).ready(function () {
            
            checkStoreRight();
            $bindCentreDropDown();
            $bindDepartmentDropDown();
            $bindSubGroupDropDown();
            $(document).on('change', '.chkIssue', function () {
                if ($(this).is(':checked')) {
                    $(this).closest('tr').find('.txtIssueQuantity,.txtRejectQuantity').val('0').attr('disabled', false);
                    $(this).closest('tr').find('.txtRejReason').attr('disabled', false);
                }
                else {
                    $(this).closest('tr').find('.txtIssueQuantity,.txtRejectQuantity').val('0').attr('disabled', true);
                    $(this).closest('tr').find('.txtRejReason').attr('disabled', true);
                }
            });
            $(".rblStoreType").change(function () {
                $bindSubGroupDropDown();
                $('.DivIndentSearch').addClass('hidden');
                iniItemSearch(function () {});
            });
        });
        $(document).on('change', '.ddlAlternetItem', function () {
            var row = $(this);
            if ($(row).val() == '0') {
                $(row).closest('tr').css('background-color', '');
                $(row).closest('tr').find('#txtIssueQuantity,#btnReject,#btnalternet').removeClass('hidden');
                $(row).closest('tr').find('#tdtype').text('OLD');

                $(row).closest('tr').find('#txtIssueQuantity,#btnReject,#btnalternet').removeClass('hidden');
                $(row).closest('tr').find('#divAlternetitem').addClass('hidden');
                $(row).closest('tr').css('background-color', '');
                $('#tblSelectedMedicine tbody .Child_' + $.trim($(row).closest('tr').find('#tdStockId').text()) + '').remove()
            }
            else {              
                
                var quantity = isNaN(parseFloat($.trim($(row).closest('tr').find('#tdReqQty').text()))) ? 0 : parseFloat($.trim($(row).closest('tr').find('#tdReqQty').text()));               
                var itemID = $.trim($(row).val().split('#')[0]);
                var avilableQuantity = Number($.trim($(row).val().split('#')[2]));
                var deptLedgerNo = $('#lblDeptLedgerNo').text().trim();
                var OldItemID = $.trim($(row).closest('tr').find('#tdItemID').text());
                var stockID = $.trim($.trim($(row).val().split('#')[1]));
                var OldStockID = $.trim($(row).closest('tr').find('#tdStockId').text());
                if (quantity == 0)
                    return;

                if (quantity > parseFloat(avilableQuantity)) {
                    modelAlert('Stock Not Avilable')
                    return;
                }
           
                
                var alreadySelectBool = $('#tblSelectedMedicine > tbody').find('#Tr_' + stockID + '').length > 0 ? true : false;
                if (alreadySelectBool) {
                    modelAlert('Item Already Added', function () {
                        return;
                    });
                   
                }
                else {
                    bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, OldItemID,OldStockID, function () {
                        $(row).closest('tr').css('background-color', 'rgb(228, 50, 76,0.9);').addClass('TrRemove').removeClass('TrAdd');
                        $(row).closest('tr').find('#txtIssueQuantity,#btnReject,#btnalternet').addClass('hidden');
                        $(row).closest('tr').find('#tdtype').text('REJECT');
                    });
                      }
                    
            }
        })
        var iniItemSearch = function (callback) {
            try {
                getComboGridOption(function (response) {
                    $('#txtItemSearch').combogrid(response);
                    callback(true);
                });
            } catch (e) {

            }
        }
        var getComboGridOption = function (callback) {
            var setting = {
                panelWidth: 750,
                idField: 'ItemID',
                textField: 'ItemName',
                mode: 'remote',
                url: 'Services/CreatePurchaseRequest.asmx/ItemSearch?cmd=item',
                loadMsg: 'Searching... ',
                method: 'get',
                pagination: true,
                pageSize: 20,
                rownumbers: true,
                fit: true,
                border: false,
                cache: false,
                nowrap: true,
                emptyrecords: 'No records to display.',
                queryParams: {
                    storeID: $('.rblStoreType:checked').val(),
                    type: $('.rdoSearchBy:checked').val(),
                    deptLedgerNo: $('#lblDeptLedgerNo').text().trim(),
                    sort: 'ItemName',
                    order: 'asc',
                    isWithAlternate: $('.rdoWithAlt:checked').val(),
                    isBarCodeScan: $('.rdoIsManualSearch:checked').val(),
                },
                onHidePanel: function () { },
                columns: [[
                    { field: 'ItemName', title: 'ItemName', align: 'left', sortable: true, width: 250 },
                    { field: 'BatchNumber', title: 'Batch No.', align: 'center', sortable: true },
                    { field: 'AvlQty', title: 'Avl. Qty.', align: 'right', sortable: true },
                    { field: 'Expiry', title: 'Expiry', align: 'center', sortable: true },
                    { field: 'MRP', title: 'MRP', align: 'right', sortable: true },
                    { field: 'Rack', title: 'Rack', align: 'center' },
                    { field: 'Shelf', title: 'Shelf', align: 'center' },
                    { field: 'Generic', title: 'Generic', align: 'center', sortable: true }
                ]],
                fitColumns: true,
                rowStyler: function (index, row) {
                    if (row.alterNate > 0) {
                        return 'background-color:antiquewhite;';
                    }
                }
            }
            callback(setting);
        }
        var $bindCentreDropDown = function () {
            serverCall('DepartmentIndentIssue.aspx/BindCentre', {}, function (response) {
                $('.ddlFromCentre').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: 'Select' });
            });
        };
        var $bindDepartmentDropDown = function () {
            serverCall('DepartmentIndentIssue.aspx/BindDepartment', {}, function (response) {
                $('.ddlDepartment').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'LedgerNumber', textField: 'LedgerName', isSearchAble: true, selectedValue: 'Select' });
            });
        };
        var $bindSubGroupDropDown = function () {
            var ledgerNo = $.trim($("input[name='rblStoreType']:checked").val());
            serverCall('DepartmentIndentIssue.aspx/BindSubCategory', { StorLedgerNo: ledgerNo }, function (response) {
                $('.ddlSubGroup').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
            });
        };
        var checkStoreRight = function () {
            serverCall('DepartmentIndentIssue.aspx/checkStoreRight', {}, function (response) {
                var checkStoreRight = JSON.parse(response);
                if (checkStoreRight.length > 0) {
                    if (checkStoreRight[0].IsMedical == 'false') {
                        $("#rblStoreM").attr('disabled', checkStoreRight[0].IsMedical);
                    }
                    if (checkStoreRight[0].IsGeneral == 'false') {
                        $("#rblStoreG").attr('disabled', checkStoreRight[0].IsGeneral);
                    }
                    if (checkStoreRight[0].IsMedical == 'true') {
                        $("#rblStoreG").attr('checked', false);
                        $("#rblStoreM").attr('checked', true);
                    }
                    else if (checkStoreRight[0].IsGeneral == 'true') {
                        $("#rblStoreM").attr('checked', false);
                        $("#rblStoreG").attr('checked', true);
                        $bindSubGroupDropDown();
                    }
                }
                else {
                    $("#rblStoreM").attr('disabled', false);
                    $("#rblStoreG").attr('disabled', false);
                }
            });
        }
        var SearchIndent = function () {
            var data = {};
            data.StoreType = $.trim($("input[name='rblStoreType']:checked").val());
            data.DateFrom = $.trim($('#DateFrom').val());
            data.DateTo = $.trim($('#DateTo').val());
            data.CentreFrom = $.trim($('#ddlFromCentre').val());
            data.Department = $.trim($('#ddlDepartment').val());
            data.RequisitionNo = $.trim($('#txtIndentNoToSearch').val());
            data.SubGroup = $.trim($('#ddlSubGroup').val());
            data.status = $.trim($('#ddlStatus').val());
            serverCall('DepartmentIndentIssue.aspx/SearchIndent', data, function (response) {
                templateIndentSearchData = JSON.parse(response);
                if (templateIndentSearchData.length > 0) {
                    var parseHTML = $('#templateIndentSearchDataDetail').parseTemplate(templateIndentSearchData);
                    $('.DivIndentSearch').removeClass('hidden').html(parseHTML).customFixedHeader();;
                    $('#DivOnIndent').removeClass('hidden');
                    $('#DivOnItem').addClass('hidden');                   
                }
                else {
                    modelAlert('Record Not Found');
                }
            });
        }
        var ViewIndentDetail = function (el) {
            var data = {};
            data.IndentNo = $.trim($(el).closest('tr').find('.GrdlbDataID').text().split('#')[0]);
            data.status = $.trim($(el).closest('tr').find('.GrdlbDataID').text().split('#')[1]);
            serverCall('DepartmentIndentIssue.aspx/SearchIndentDetails', data, function (response) {
                templateIndentSearchDetailData = JSON.parse(response);
                if (templateIndentSearchDetailData.length > 0) {
                    var parseHTML = $('#templateIndentSearchDetailData').parseTemplate(templateIndentSearchDetailData);
                    $('.DivIndentSearchDetail').removeClass('hidden').html(parseHTML).customFixedHeader();;
                    $('#DivIndentDeatailSearchPOPUP').showModel();
                }
                else {
                    $('.DivIndentSearchDetail').addClass('hidden').html("");
                    modelAlert('Record Not Found');

                }
            });
        }
        var getIndentItemsDetails = function (el, searchType) {                  
            var data = {};
            $('tr').removeClass('SelectedIndent'); // removes all highlights from tr's
            $(el).closest('tr').addClass('SelectedIndent'); // adds the highlight to this row
            data.deptLedgerNo = $('#lblDeptLedgerNo').text().trim();
            data.indentNo = $.trim($(el).closest('tr').find('.GrdlbDataID').text().split('#')[0]);
            serverCall('DepartmentIndentIssue.aspx/GetIndentItemsStockDetails', data, function (response) {
                indentItemsStockDetails = JSON.parse(response);
                if (indentItemsStockDetails.length > 0) {
                    var template = $('#templateIndentItemsStockDetails').parseTemplate(indentItemsStockDetails);
                    $('#divIndentItemsDetails').removeClass('hidden').html(template).customFixedHeader();
                    $('#DivOnItem').removeClass('hidden');
                    iniItemSearch(function () { });
                }
                else {
                    $('#divIndentItemsDetails').addClass('hidden').html('').customFixedHeader();
                    $('#DivOnItem').addClass('hidden');
                    modelAlert('Record Not Found');
                }
            });
        }
        var onSearchTypeChange = function (elem) {
            try {
                iniItemSearch(function () { });
                $('.withGeneric').css({ 'display': (elem.value == '1') ? '' : 'none' });
            } catch (e) {

            }
        }
        var onIsManualChange = function (elem) {          
            iniItemSearch(function () { });
        }
        var onIsWithAlternateChange = function () {           
            iniItemSearch(function () { });
        }
        var PrintIndentDetail = function (indentnum, salesnumber) {
            var data = {};
            data.IndentNo = indentnum;
            data.SalesNo = salesnumber;
            serverCall('DepartmentIndentIssue.aspx/PrintIndentDetails', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL, "_blank");
                else
                    modelAlert("No Data Found.");
            });
        }      
        var $closeIndentDetailSearchModel = function () {
            $('#DivIndentDeatailSearchPOPUP').hideModel();
        }
        var $closeItemPopUpModel = function () {
            $('#DivItemPopUp').hideModel();
        }
        var ViewItemIndentDetail = function (el) {
            $('.DivItemPopUpContent').html('<table  cellspacing="0" rules="all" border="1"   style="width:100%;border-collapse:collapse;">' +
        '<thead><tr><th class="GridViewHeaderStyle" scope="col" style="width:30px;">Batch</th><th class="GridViewHeaderStyle" scope="col" style="width:30px;">Expirable</th><th class="GridViewHeaderStyle" scope="col" style="width:30px;">Expiry</th><th class="GridViewHeaderStyle" scope="col" style="width:65px;">Unit Cost</th><th class="GridViewHeaderStyle" scope="col" style="width:85px;">Selling Price</th><th class="GridViewHeaderStyle" scope="col" style="width:65px;">Avail. Qty.</th><th class="GridViewHeaderStyle" scope="col" style="width:80px;">Unit</th></tr></thead>' +
               '<tbody><tr>' +
               '<td class="GridViewLabItemStyle textCenter">' + $.trim($(el).closest("tr").find(".GrdlbitemDataID").text().split("#")[8]) + '</td>' +
            '<td class="GridViewLabItemStyle textCenter">' + $.trim($(el).closest("tr").find(".GrdlbitemDataID").text().split("#")[14]) + '</td>' +
            '<td class="GridViewLabItemStyle textCenter">' + $.trim($(el).closest("tr").find(".GrdlbitemDataID").text().split("#")[11]) + '</td>' +
            '<td class="GridViewLabItemStyle textCenter">' + $.trim($(el).closest("tr").find(".GrdlbitemDataID").text().split("#")[9]) + '</td>' +
            '<td class="GridViewLabItemStyle textCenter">' + $.trim($(el).closest("tr").find(".GrdlbitemDataID").text().split("#")[10]) + '</td>' +
            '<td class="GridViewLabItemStyle textCenter">' + $.trim($(el).closest("tr").find("td:eq(6)").text()) + '</td>' +
            '<td class="GridViewLabItemStyle textCenter">' + $.trim($(el).closest("tr").find(".GrdlbitemDataID").text().split("#")[13]) + '</td>' +
               '</tr></tbody>');
            $('#DivItemPopUp').showModel();
        }
        var getItemDetails = function (callback) {
            debugger;
            var items = [];
            var Rejectitems = [];
            $('#tblSelectedMedicine > tbody > .TrAdd ').each(function (){
                if ($.trim($(this).find('#tdtype').text()) != 'REJECT' && Number($.trim($(this).find('#txtIssueQuantity').val()))) {
                    items.push({

                        RejectQuantity: 0,
                        IssueQuantity: Number($(this).find('#txtIssueQuantity').val()),
                        RequestQuatity: Number($(this).find('#tdReqQty').text()),
                        StoreID: $.trim($(this).find('#tdStoreId').text()),
                        IndentNo: $.trim($(this).find('#tdIndentNum').text()),
                        ItemID: $.trim($(this).find('#tdItemID').text()),
                        StockID: $.trim($(this).find('#tdStockId').text()),
                        DeptLedgerNo: $.trim($('#lblDeptLedgerNo').text()),
                        FromcentreID: $.trim($(this).find('#tdfromCentreID').text()),
                        DeptFrom: $.trim($(this).find('#tdDeptFrom').text()),
                        UserID: $.trim($('#lblUserID').text()),
                        Types: $.trim($(this).find('#tdtype').text()),
                        OldItemID: $.trim($(this).find('#tdOldItemID').text()),

                    });
                }
                else if ($.trim($(this).find('#tdtype').text()) == 'REJECT') {
                    Rejectitems.push({

                        StoreID: $.trim($(this).find('#tdStoreId').text()),
                        IndentNo: $.trim($(this).find('#tdIndentNum').text()),
                        ItemID: $.trim($(this).find('#tdItemID').text()),
                        StockID: $.trim($(this).find('#tdStockId').text()),
                        DeptLedgerNo: $.trim($('#lblDeptLedgerNo').text()),
                        FromcentreID: $.trim($(this).find('#tdfromCentreID').text()),
                        DeptFrom: $.trim($(this).find('#tdDeptFrom').text()),
                        UserID: $.trim($('#lblUserID').text()),
                        Types: $.trim($(this).find('#tdtype').text()),                        
                    });
                }
            });
 
            if (items.length == 0 && Rejectitems.length == 0) {
                modelAlert('Either issue Qty is zero or Item list is empty.');
                //$('#DivOnItem').addClass('hidden');
                //SearchIndent('0');
                return false;
            }
                var zeroQuantityItems = items.filter(function (s) {
                    return s.IssueQuantity <= 0;
                });
             
                if (zeroQuantityItems.length > 0) {
                    modelAlert('Some Item have Invalid Quantity.');
                    return false;
                }
                callback({ items: items, Rejectitems: Rejectitems });
        }
        var SaveIndent = function (btn) {
            getItemDetails(function (data) {
                if (data.items.length > 0) {
                    // $(btn).attr('disabled', true).val('Submitting...');
                    serverCall('DepartmentIndentIssue.aspx/SaveIndentData', data, function (response) {

                        var $responseData = JSON.parse(response);                  
                        if ($responseData.status) {
                            modelAlert($responseData.message);

                            $('#DivOnItem').addClass('hidden');
                            SearchIndent('0');
                            //modelConfirmation('Confirmation !', $responseData.response, 'Yes', 'No', function (status) {
                            //    if (status) {
                            //        PrintIndentDetail('' + data.items.IndentNo + ',' + $responseData.SalesNo + '');
                            //    }
                            //});
                        }
                        else {
                            modelAlert($responseData.response);
                        }
                       
                    });
                }
            });
        }
        var addItem = function (e) {

            var txtItemSearch = $('#txtItemSearch');
            var txtQuantity = $('#txtQuantity');
            var quantity = isNaN(parseFloat(txtQuantity.val())) ? 0 : parseFloat(txtQuantity.val());
            var grid = txtItemSearch.combogrid('grid');
            var selectedRow = grid.datagrid('getSelected');
            var itemID = $.trim(selectedRow.ItemID.split('#')[0]);
            var avilableQuantity = selectedRow.AvlQty;
            var deptLedgerNo = $('#lblDeptLedgerNo').text().trim();

            if (quantity == 0)
                return;

            if (quantity > parseFloat(selectedRow.AvlQty)) {
                modelAlert('Stock Not Avilable', function () {
                    txtQuantity.val('').focus();
                });
                return;
            }

            var code = (e.keyCode ? e.keyCode : e.which);
            if (String.isNullOrEmpty(selectedRow)) {
                modelAlert('Please Select Item First', function () {
                    $('.textbox-text.validatebox-text').focus();
                    txtItemSearch.combogrid('reset');
                });
                return;
            }
            var stockID = $.trim(selectedRow.stockid);
            var alreadySelectBool = $('#tblSelectedMedicine > tbody').find('#Tr_' + stockID + '').length > 0 ? true : false;
            if (alreadySelectBool) {
                modelAlert('Item Already Added', function () {
                    txtQuantity.val('');
                    $('.textbox-text.validatebox-text').focus();
                    txtItemSearch.combogrid('reset');
                });
                return;
            }
            else {
                if (code == 13 && e.target.type == 'text') {
                    quantity = e.target.value;
                    var alreadyItemExist = $('#tblSelectedMedicine > tbody').find('.' + itemID + '').length > 0 ? true : false;
                    if (alreadyItemExist) {
                        if (Number($('#tblSelectedMedicine > tbody > .' + itemID + '').find('#tdAvlQty').text()) >= Number($('#tblSelectedMedicine > tbody > .' + itemID + '').find('#tdReqQty').text())) {
                            modelConfirmation('Warning:- Qty Already Available !', 'Do you want to add this item again ?', 'Yes', 'Cancel', function (status) {
                                if (status) {
                                    bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo,'','', function () {
                                        txtQuantity.val('');
                                        $('.textbox-text.validatebox-text').focus();
                                        txtItemSearch.combogrid('reset');
                                    });
                                }
                            });
                        }
                    }
                    else {
                        bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, '','', function () {
                            txtQuantity.val('');
                            $('.textbox-text.validatebox-text').focus();
                            txtItemSearch.combogrid('reset');
                        });
                    }
                }
                else if (e.target.type == 'button') {
                    var alreadyItemExist = $('#tblSelectedMedicine > tbody').find('.' + itemID + '').length > 0 ? true : false;
                    if (alreadyItemExist) {
                        if (Number($('#tblSelectedMedicine > tbody > .' + itemID + '').find('#tdAvlQty').text()) >= Number($('#tblSelectedMedicine > tbody > .' + itemID + '').find('#tdReqQty').text())) {
                            modelConfirmation('Warning:- Qty Already Available !', 'Do you want to add this item again ?', 'Yes', 'Cancel', function (status) {
                                if (status) {
                                    bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, '','', function () {
                                        txtQuantity.val('');
                                        $('.textbox-text.validatebox-text').focus();
                                        txtItemSearch.combogrid('reset');
                                    });
                                }
                            });
                        }
                    }
                    else {
                        bindItem(itemID, quantity, stockID, avilableQuantity, deptLedgerNo, '','', function () {
                            txtQuantity.val('');
                            $('.textbox-text.validatebox-text').focus();
                            txtItemSearch.combogrid('reset');
                        });
                    }
                }

                if (code == 9 && e.target.type == 'text') {
                    $(this).parent().find('input[type=button]').focus();
                }
            }
        }
        var bindItem = function (itemID, quantity, stockID, avilableQuantity, deptLedgerNo, OldItemID,OldStockID, callback) {
            getItemStockDetails(itemID, quantity, stockID, avilableQuantity, 0, deptLedgerNo, function (response) {
                response[0].patientMedicine = '0';
                response[0].indentNo = '';
                response[0].draftDetailID = '0';
                addNewRow(response[0], quantity, stockID, OldItemID,OldStockID, function () {
                    callback();
                });
            });
        }
        var getItemStockDetails = function (itemID, tranferQty, stockID, availableQty, isSet, deptLedgerNo, callback) {
            serverCall('Services/WebService.asmx/addItem', { ItemID: itemID, tranferQty: tranferQty, StockID: stockID, patientMedicine: '0', DeptLedgerNo: deptLedgerNo }, function (response) {
                if (!String.isNullOrEmpty(response)) {
                    var responseData = JSON.parse(response);
                    if (responseData.length > 0)
                        callback(responseData);
                    else {
                        modelAlert('Stock Not Avilable');
                    }
                }
                else {

                }
            });
        }
        var addNewRow = function (itemDetails, quantity, stockID, OldItemID, OldStockID, callback) {
          
            var table = $('#tblSelectedMedicine > tbody');
            var td = '';
            var ReqQty = Number(quantity);
            var stockIssue = ((Number(itemDetails.AvlQty) > Number(ReqQty)) ? Number(ReqQty) : Number(itemDetails.AvlQty));
          //  var classname = (($.trim(OldItemID) != $.trim('')) ? $.trim(OldItemID) : $.trim(itemDetails.ItemID));
            var BackgroundColor = (($.trim(OldItemID) != $.trim('')) ? $.trim('rgba(252, 114, 51, 0.9)') : $.trim('rgba(77, 0, 253, 0.7)'));
            var alreadyItemExist = table.find('.' + $.trim(itemDetails.ItemID) + '').length > 0 ? true : false;
                                   
                 var StoreID = $('#tblSelectedIndent tbody tr.SelectedIndent').find('.GrdlbDataID').text().split('#')[3];
                 var DepartmentFromID = $('#tblSelectedIndent tbody tr.SelectedIndent').find('.GrdlbDataID').text().split('#')[2];
                 var CenterFromID = $('#tblSelectedIndent tbody tr.SelectedIndent').find('.GrdlbDataID').text().split('#')[5];
                 var IndentNo = $('#tblSelectedIndent tbody tr.SelectedIndent').find('.GrdlbDataID').text().split('#')[0];
                 
                 if (alreadyItemExist) {
                     td += '<td class="GridViewLabItemStyle" style="border-top-color: transparent;border-right-color: transparent;"></td>' +
                         '<td colspan="4" id="tdReqQty" class="GridViewLabItemStyle" style="border-top-color: transparent;border-left-color: transparent;">'+ReqQty+'</td>';
                 }
                 else {
                     td+= '<td class="GridViewLabItemStyle SrNo" style="width:10px">0</td>' +
                                              '<td class="GridViewLabItemStyle" id="tdItemName"  style="text-align:left;font-weight: bold;color:#000000">' + itemDetails.ItemName + '</td>' +
                                              '<td class="GridViewLabItemStyle" id="tdReqQty" style="text-align:center">'+ReqQty+'</td>'+
                                              '<td class="GridViewLabItemStyle" id="tdRecQty" style="text-align:center">0</td>'+
                                              '<td class="GridViewLabItemStyle" id="tdRejQty" style="text-align:center">0</td>';
                 }
                
                      
                 td += '<td class="GridViewLabItemStyle" id="tdAvlQty" style="text-align:center">' + itemDetails.AvlQty + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdBatchNumber" style="text-align:left">' + itemDetails.BatchNumber + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdMedExpiryDate" style="text-align:center">' + itemDetails.MedExpiryDate + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdMRP" style="text-align:center;">' + itemDetails.MRP + '</td>' +

                       '<td class="GridViewLabItemStyle" id="tdIssueQty"  style="text-align:center">' +
                           '<input type="text" id="txtIssueQuantity" onlynumber="10" decimalplace="4"  max-value="' + itemDetails.AvlQty + '" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"  value="' + stockIssue + '" />' +
                       '</td>'+

                       '<td style="text-align:center" class="GridViewLabItemStyle"></td>'+

                             '<td style="text-align:center" class="GridViewLabItemStyle" id="tdReject">' +
                        '<img alt="" src="../../Images/Delete.gif" class="imgPlus"  style="cursor:pointer" onclick="onIndentReject(1,this)"  />' +
                       '</td>'+ 
                     

                       '<td class="GridViewLabItemStyle" id="tdStockId" style="display:none" >' + itemDetails.stockid + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdItemID" style="display:none" >' + itemDetails.ItemID + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdOldItemID" style="display:none" >' + OldItemID + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdIndentNum" style="display:none" >' + IndentNo + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdStoreId" style="display:none" >' + StoreID + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdfromCentreID" style="display:none" >' + CenterFromID + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdDeptFrom" style="display:none" >' + DepartmentFromID + '</td>' +
                       '<td class="GridViewLabItemStyle" id="tdtype" style="display:none" >NEW</td>';
           
                 if (alreadyItemExist) {
                     if ($.trim(OldStockID) != '') {
                         table.find('.' + itemDetails.ItemID + '').first().after('<tr class="TrAdd Child_' + OldStockID + ' ' + IndentNo + '" style="background-color:' + BackgroundColor + '" id="Tr_' + itemDetails.stockid + '">' + $.trim(td) + '</tr>');
                     }
                     else {
                         table.find('.' + itemDetails.ItemID + '').first().after('<tr class="TrAdd Child_' + stockID + ' ' + IndentNo + '" style="background-color:' + BackgroundColor + '" id="Tr_' + itemDetails.stockid + '">' + $.trim(td) + '</tr>');
                     }
                 }
                 else {
                     if ($.trim(OldStockID) != '') {
                         table.prepend('<tr style="background-color:rgba(77, 0, 253, 0.7)" class="TrAdd Child_' + $.trim(OldStockID) + ' ' + IndentNo + '" id="Tr_' + itemDetails.stockid + '">' + $.trim(td) + '</tr>');
                     }
                     else {
                         table.prepend('<tr style="background-color:rgba(77, 0, 253, 0.7)" class="TrAdd Parent_' + itemDetails.stockid + ' ' + IndentNo + '" id="Tr_' + itemDetails.stockid + '">' + $.trim(td) + '</tr>');
                     }
                 }
                 $('#tblSelectedMedicine > tbody > tr > .SrNo').each(function (idx, elem) { $(elem).text(idx + 1); });
           
            callback(true);
        }
        var onIndentReject = function (val, elem) {
            var row = $(elem).closest('tr');
            var divRejectReason = $('#divRejectReason');
            
            if (Number(val) == 1) {
                row.remove();
            }                     
            else if (Number(val) == 0) {
                divRejectReason.find('#lblRejectItemID').text('');
                divRejectReason.find('#lblRejectItemID').attr('indentNo', $.trim(row.find('#tdIndentNum').text())).attr('StockID', $.trim(''));
                divRejectReason.find('textarea').val('');
                divRejectReason.find('.patientInfo').html('<b style="color:black">Indent ID:</b> ' + $.trim(row.find('#tdIndentNum').text()));
                divRejectReason.showModel();               
            }
            else if (Number(val) == 2) {
                divRejectReason.find('#lblRejectItemID').text($.trim(row.find('#tdItemID').text()));
                divRejectReason.find('#lblRejectItemID').attr('indentNo', $.trim(row.find('#tdIndentNum').text())).attr('StockID', $.trim(row.find('#tdStockId').text()));
                divRejectReason.find('textarea').val('');
                divRejectReason.find('.patientInfo').html('<b style="color:black">Item Name:</b> ' + $.trim(row.find('#tdItemName').text()));
                divRejectReason.showModel();
            }
        }                               
        var rejectIndentItem = function () {    
            var divRejectReason = $('#divRejectReason');
            var data = {
                indentID: $.trim(divRejectReason.find('#lblRejectItemID').attr('indentNo')),
                itemID: $.trim(divRejectReason.find('#lblRejectItemID').text()),
                rejectReason: $.trim(divRejectReason.find('textarea').val()),
                StockID: $.trim(divRejectReason.find('#lblRejectItemID').attr('StockID')),
            }           
            if (String.isNullOrEmpty(data.rejectReason)) {
                modelAlert('Please Enter Reject Reason', function () {
                    divRejectReason.find('textarea').focus();
                });
                return false;
            }

            serverCall('DepartmentIndentIssue.aspx/RejectIndentItem', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    divRejectReason.hideModel();
                    if (!String.isNullOrEmpty(data.itemID)) {
                        $('#tblSelectedMedicine > tbody > #Tr_' + data.StockID + '').css('background-color', 'rgb(228, 50, 76,0.9)').addClass('TrRemove').find('#tdIssueQty,#tdAlternetitem,#tdReject').html('');
                        $('#tblSelectedMedicine tbody .Child_' + $.trim(data.StockID) + '').remove()
                    }
                    else {
                        SearchIndent('0');
                    }
                }
            });
        }
        var $BindAlterNetItemDropDown = function (row) {
            var data = {};
            data.ItemID = $.trim($(row).closest('tr').find('#tdItemID').text());
            data.StockID =Number ($.trim($(row).closest('tr').find('#tdStockId').text()));
            serverCall('DepartmentIndentIssue.aspx/bindGenericItem', data, function (response) {
                if (JSON.parse(response).length > 0) {
                    $(row).closest('tr').find('#btnalternet').addClass('hidden');
                    $(row).closest('tr').find('#ddlAlternetItem').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemID', textField: 'ItemName', isSearchAble: true, selectedValue: 'Select' });                                      
                    $(row).closest('tr').find('#divAlternetitem').removeClass('hidden');
                }
                else {
                    modelAlert('Alternet Item not available.');
                }
                });
        }
        </script>
     <script id="templateIndentSearchDataDetail" type="text/html">
    <table class="FixedTables"   cellspacing="0" rules="all" border="1"   style="width:100%;border-collapse:collapse;" id="tblSelectedIndent">
        <thead>
        <tr>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Indent Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Indent No.</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:100px;">From Centre</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width:100px;">From Department</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Indent Type</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Select</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Detail</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Reprint</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Reject</th>
        </tr>
            
         </thead>
        <tbody>
        <#       
        var dataLength=templateIndentSearchData.length;
        var objRow; 
           
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateIndentSearchData[j];
        #>
                <tr class="<#=objRow.indentno#>" 
                    <#
                    if(objRow.StatusNew=="REJECT")
                    {#> 
                    style="background-color:#e4324c" 
                    <#} 
                    else if(objRow.StatusNew=="CLOSE")
                    {#>  
                    style="background-color:Green"
                    <#}
                     else if(objRow.StatusNew=="OPEN")
                    {#>  
                    style="background-color:aquamarine"
                    <#}
                     else if(objRow.StatusNew=="PARTIAL")
                    {#>  
                    style="background-color:Yellow"
                    <#}                    
                    #> >
                    <td class="GridViewLabItemStyle textCenter SrNo"> <#=j+1#>
                        <label class="hidden GrdlbDataID" ><#= objRow.indentno #>#<#= objRow.StatusNew #>#<#= objRow.DeptfromID #>#<#= objRow.StoreId #>#<#= objRow.LedgerNumber #>#<#= objRow.CentreID #></label>
                         <label class="hidden GrdlblIsNewIndent" ><#= objRow.NewIndent #></label>
                    </td>
                    <td class="GridViewLabItemStyle textCenter"> <#= objRow.dtEntry #></td>
                       <td class="GridViewLabItemStyle textCenter" id="tdIndentNo" > <#= objRow.indentno #></td> 
                     <td class="GridViewLabItemStyle textCenter"> <#= objRow.CentreFrom #></td> 
                    <td class="GridViewLabItemStyle textCenter"> <#= objRow.DeptFrom #></td>
                    <td class="GridViewLabItemStyle textCenter"> <#= objRow.Type #></td>                                                      
                    <td class="GridViewLabItemStyle textCenter" >
                                          <# if(objRow.StatusNew!='REJECT' && objRow.StatusNew!='CLOSE'){#>
                     <img alt="" src="../../Images/Post.gif" id="btnBindIndentItem" title="Click here to show item" class="imgPlus"  style="cursor:pointer" onclick="getIndentItemsDetails(this,0)"  />
                        <#}#>
                                      
                       </td>  
                     <td class="GridViewLabItemStyle textCenter" >
                        <img alt="" src="../../Images/view.GIF" class="imgPlus" title="Click here to view details"  style="cursor:pointer" onclick="ViewIndentDetail(this)" />
                       </td> 
                    <td class="GridViewLabItemStyle textCenter" >
                        <#
                        if(objRow.StatusNew!="REJECT" && objRow.StatusNew!="OPEN"){#> 
                        <img alt="" src="../../Images/print.gif" class="imgPlus" title="Click here to print recipt"  style="cursor:pointer" onclick="PrintIndentDetail('<#= objRow.indentno #>','')" />
                       <#}   #> 
                    </td>
                      <td style="text-align:center" class="GridViewLabItemStyle">
                         <# if(objRow.StatusNew!='REJECT' && objRow.StatusNew!='CLOSE'){#>
                     <img alt="" src="../../Images/Delete.gif" class="imgreject"  style="cursor:pointer" onclick="onIndentReject(0,this)"  />
                          <#}#>
                    </td>                       
               </tr>     
        <#}#>   
       </tbody>   
     </table>
                        </script>  
      
      <script id="templateIndentSearchDetailData" type="text/html">
 <table class="FixedTables"  cellspacing="0" rules="all" border="1"   style="width:100%;border-collapse:collapse;">
        <thead>
        <tr>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Requisition No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Item Name</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:65px;">Unit Type</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width:85px;">Requested Qty.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:65px;">Issue Qty. </th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rejected Qty.</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Date</th>
        </tr>
            
         </thead>
               <tbody>
        <#       
        var dataLength=templateIndentSearchDetailData.length;
        var objRow; 
           
        for(var j=0;j<dataLength;j++)
        {       
        objRow = templateIndentSearchDetailData[j];
        #>
                <tr >
                       <td class="GridViewLabItemStyle textCenter SrNo"><#=j+1#></td>
                       <td class="GridViewLabItemStyle textCenter"> <#= objRow.IndentNo #></td> 
                     <td class="GridViewLabItemStyle textCenter"> <#= objRow.ItemName #></td> 
                    <td class="GridViewLabItemStyle textCenter"> <#= objRow.UnitType #></td>
                    <td class="GridViewLabItemStyle textCenter"> <#= objRow.ReqQty #></td> 
                       <td class="GridViewLabItemStyle textCenter"> <#= objRow.SoldUnits #></td>
                       <td class="GridViewLabItemStyle textCenter"> <#= objRow.RejectQty #></td> 
                     <td class="GridViewLabItemStyle textCenter"> <#= objRow.Date #></td>                    
                </tr>
      <#}#>   
       </tbody> 
                             </table>
     </script>    
     <script id="templateIndentItemsStockDetails" type="text/html">
    <table class="FixedTables" cellspacing="0" id="tblSelectedMedicine" rules="all" border="1"  style="width:100%;border-collapse:collapse;">
        <thead>
        <tr id="Tr3">
            <th class="GridViewHeaderStyle" scope="col" >S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >Item Name</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Requested</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Issued</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Rejected</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Available</th>
            <th class="GridViewHeaderStyle" style="width:100px" scope="col" >BatchNumber</th>		
            <th class="GridViewHeaderStyle" style="width:100px" scope="col" >Expire Date</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >MRP</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Issue</th>
               <th class="GridViewHeaderStyle" style="width:120px" scope="col" >Alternet</th>
            <th class="GridViewHeaderStyle" style="width:80px" scope="col" >Reject</th>        	 
        </tr>
         </thead><tbody>        
              <#       
        var dataLength=indentItemsStockDetails.length;
        var objRow; 
           var stockIssue=0; 
        for(var j=0;j<dataLength;j++)
        {       
        objRow = indentItemsStockDetails[j];
        #>
             <#
              var pendingQty=(Number(objRow.ReqQty)-Number(objRow.ReceiveQty)+Number(objRow.RejectQty));
                           var isTotalIssued=false;
                           if(pendingQty>0){
                                stockIssue= ((objRow.AvlQty>pendingQty)?pendingQty:objRow.AvlQty);
                                isTotalIssued=((stockIssue)==objRow.ReqQty)?true:false;
                           }
            #>
                    <tr  class="TrAdd <#=objRow.ItemID#> Parent_<#=objRow.stockid#> <#=objRow.IndentNo#>" id="Tr_<#=objRow.stockid#>">
                       
                    <td class="GridViewLabItemStyle SrNo" style="width:10px"> <#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdItemName"  style="text-align:left;font-weight: bold;color:#000000"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="tdReqQty" style="text-align:center"><#=objRow.TotalReqQty#></td>
                    <td class="GridViewLabItemStyle" id="tdRecQty" style="text-align:center"><#=objRow.ReceiveQty#></td>
                    <td class="GridViewLabItemStyle" id="tdRejQty" style="text-align:center"><#=objRow.RejectQty#></td>                                                                                       
                    <td class="GridViewLabItemStyle" id="tdAvlQty" style="text-align:center"><#=objRow.AvlQty#></td>
                    <td class="GridViewLabItemStyle" id="tdBatchNumber" style="text-align:left"><#=objRow.BatchNumber#></td>
                    <td class="GridViewLabItemStyle" id="tdMedExpiryDate" style="text-align:center"><#=objRow.MedExpiryDate#></td>
                    <td class="GridViewLabItemStyle" id="tdMRP" style="text-align:center;"><#=objRow.MRP#></td>
                    <td class="GridViewLabItemStyle" id="tdIssueQty"  style="text-align:center">
                        <input type="text" id="txtIssueQuantity" onlynumber="10" decimalplace="4"  max-value="<#=Number(objRow.AvlQty)#>" onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event,function(e){ });"  value="<#=stockIssue#>" />
                    </td>

                         <td style="text-align:center" id="tdAlternetitem" class="GridViewLabItemStyle">
                             <div class="hidden" style="width:120px" id="divAlternetitem">
                        <select id="ddlAlternetItem"    class="ddlAlternetItem" title="Select alternet Item" ></select>
 </div>
                   <img alt="" src="../../Images/plus.png" id="btnalternet" class="imgPlus"  style="cursor:pointer" onclick="  $BindAlterNetItemDropDown(this);"  />         
                   </td>

                    <td style="text-align:center" class="GridViewLabItemStyle" id="tdReject">
                       <img alt="" src="../../Images/Delete.gif" id="btnReject" class="imgPlus"  style="cursor:pointer" onclick="onIndentReject(2,this)"  />                       
                    </td>   
                   

                    <td class="GridViewLabItemStyle" id="tdStockId" style="display:none" ><#=objRow.stockid#></td> 
                    <td class="GridViewLabItemStyle" id="tdItemID" style="display:none" ><#=objRow.ItemID#></td> 
                    <td class="GridViewLabItemStyle" id="tdOldItemID" style="display:none" ><#=objRow.OLDItemID#></td>
                    <td class="GridViewLabItemStyle" id="tdIndentNum" style="display:none" ><#=objRow.IndentNo#></td>                   
                    <td class="GridViewLabItemStyle" id="tdStoreId" style="display:none" ><#=objRow.StoreId#></td>
                    <td class="GridViewLabItemStyle" id="tdfromCentreID" style="display:none" ><#=objRow.CentreID#></td>
                    <td class="GridViewLabItemStyle" id="tdDeptFrom" style="display:none" ><#=objRow.DeptFrom#></td>
                        <td class="GridViewLabItemStyle" id="tdtype" style="display:none" >OLD</td>

               </tr>     
             
            <#}#>
       </tbody>   
     </table>    
</script>
           </asp:Content>

