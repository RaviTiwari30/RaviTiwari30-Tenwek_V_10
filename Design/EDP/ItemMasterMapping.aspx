<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ItemMasterMapping.aspx.cs" Inherits="Design_EDP_ItemMasterMapping" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />
    <style type="text/css">
        .listbox {
            text-align: left;
        }

        .htAutocomplete {
            text-align: left;
        }


        .htDimmed {
            background-color: #a1f6ec;
            color: #0e0e0e !important;
        }

        .listbox:only-child .htDimmed {
            background-color: white !important;
        }

        .ht_clone_top {
            z-index: 0 !important;
        }

        .ht_clone_left {
            z-index: 0 !important;
        }

        .handsomeTableCustomize {
            font-size: 12px !important;
        }

        #Pbody_box_inventory {
            width: 1345px !important;
        }

        .POuter_Box_Inventory {
            width: 1340px !important;
        }

        .htCommentTextArea {
            pointer-events: none;
        }
    </style>
    <script type="text/javascript">

        var searchedItems = "";
        $(document).ready(function () {
            $bindCentre(function () {
                $bindCategory(function () {
                    LoadCOA(function () {
                        $('#dvItemList,#dvSave,#dvItem').hide();
                    });
                });
            });

        });
        var vendors = [];
        var matching = [];
        var centres = [];
        var $bindCentre = function (callback) {
            serverCall('Services/ItemMasterMapping.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                centres = JSON.parse(response);
                $Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: 'Select' });
                callback($Centre.find('option:selected').text());
            });
        }
        var $bindCategory = function (callback) {
            serverCall('../common/CommonService.asmx/BindCategory', { Type: '8' }, function (response) {
                $Category = $('#ddlCategory');
                $Category.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                $bindSubCategory($Category.val(), function () {
                    callback($Category.find('option:selected').text());
                });

            });
        }
        $bindSubCategory = function (categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            serverCall('../common/CommonService.asmx/BindSubCategory', { Type: '8', CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                callback($subCategory.find('option:selected').text());
            });
        }

        function searchItems() {
            $('#lblMsg').text('');
            $('#dvItemList').html('');
            $('#dvItemList,#dvSave,#dvItem').hide();
            if ($('#ddlCentre').val() == "0") {
                modelAlert('Please Select Centre');
                return false;
            }
            if ($('#ddlCategory').val() == "0") {
                modelAlert('Please Select Category');
                return false;
            }
            if ($('#ddlSubCategory').val() == "0") {
                modelAlert('Please Select Sub Category');
                return false;
            }

            var data = {
                centreID: $.trim($('#ddlCentre').val()),
                CategoryID: $.trim($('#ddlCategory').val()),
                SubCategoryID: $.trim($('#ddlSubCategory').val()),
                ItemName: $.trim($('#txtItemName').val()),
                type: Number($.trim($('#ddlType').val())),
            };
            serverCall('Services/ItemMasterMapping.asmx/BindGridItems', data, function (response) {
                searchedItems = JSON.parse(response);
                if (searchedItems.length > 0) {
                    $('#dvItemList,#dvSave,#dvItem').show();
                    $('#lblMsg').text('Total Records : ' + searchedItems.length);
                    container2 = document.getElementById('dvItemList'),
                    hot2 = new Handsontable(container2, {
                        data: searchedItems,
                        //minSpareRows: 1,
                        //allowInsertRow: true,
                        colHeaders: getColumns(searchedItems),
                        colWidths: [400, 110, 250, 250, 250, 250, 250, 250, 250, 130, 250, 250, 250, 250, 250, 250],
                        columns: getColumnsData(getColumns(searchedItems)),
                        contextMenu: false,
                        filters: true,
                        height: 380,
                        beforeChange: function (changes, source) {
                            if (source === 'loadData' || source === 'internal' || changes.length > 1)
                                return;

                            
                            var h = this;
                            var row = changes[0][0];
                            var prop = changes[0][1];
                            var value = $.trim(changes[0][3]);

                            //if (true) {


                            //    matching = vendors.filter(function (i) { if (i.COA_NM == value) { return i; } }); //global Variable

                            //    if (matching.length < 1)
                            //        return false;

                            //    var selectedData = matching[0];

                            //    debugger;
                            //    h.setDataAtRowProp(row, h.propToCol('_ID'), selectedData.COA_ID);
                            //}
                        }
                    });
                }
                else {
                    $('#lblMsg').text('No Record found as per searching criteria');
                    return false;
                }
            });
        }


        function saveFinanceMapping(btnSave) {


            var unMappedItems = searchedItems.filter(function (s) { return s.RevenueID < 1 });
            if (unMappedItems.length > 0) {
                modelAlert('Please Map with finance first.</br><p class="patientInfo">' + unMappedItems[0].ItemName + '</p>');
                return false;
            }



            $('#lblMsg').text('');
            if ($('#ddlCentre').val() == "0") {
                modelAlert('Please Select Centre');
                return false;
            }
            if ($('#ddlCategory').val() == "0") {
                modelAlert('Please Select Category');
                return false;
            }
            $(btnSave).attr('disabled', true).val('Submitting...');
            var selectedCentre = [];
            selectedCentre.push($.trim($('#ddlCentre').val()));

            $('#divSelectCentres').find('input[type=checkbox]:checked').each(function () {
                var centreID = $.trim($(this).closest('.col-md-16').attr('centreid'));
                selectedCentre.push(centreID);
            });


            var data = {
                centreIDs: selectedCentre,
                ItemList: searchedItems,
            };

            serverCall('Services/ItemMasterMapping.asmx/SaveFinancematrix', data, function (response) {
                $responseData = JSON.parse(response);
                modelAlert($responseData.response, function (response) {
                    if ($responseData.status)
                        window.location.reload();
                    else
                        $(btnSave).removeAttr('disabled').val('Save');
                });
            });
        }



        function getColumns(data) {
            var columns = [];
            var valueField = ['ItemID'];
            $(Object.keys(data[0])).each(function (index, elem) {
                if (valueField.indexOf(elem) < 0)
                    columns.push(elem)
            });
            return columns;
        }

        function getColumnsData(data) {
            var colData = [];
            var valueField = ['ItemID'];
            var booleanField = ['CAPITAL_ITEM', 'BUDGET_ITM_FLG'];

            $(data).each(function (index, elem) {
                if (valueField.indexOf(elem) < 0) {
                    var filterArray = ['Yes', 'No'];
                    if (booleanField.indexOf(elem) < 0)
                        filterArray = filterVender;

                    colData.push({
                        data: elem,
                        type: 'autocomplete',
                        source: filterArray,
                        strict: true,
                        readOnly: index == 0 ? true : false,
                    });
                };
            });
            return colData;
        }

        var LoadCOA = function (callback, A) {
            serverCall('Services/ItemMasterMapping.asmx/LoadCOA', {}, function (response) {
                vendors = JSON.parse(response);
                callback(vendors);
            });
        }




        var filterVender = function (query, process) {
            i = vendors;
            if (query.length > 1) {
                var matcher = new RegExp(query.replace(/([.?*+^$[\]\\(){}|-])/g, '\\$1'), 'i');
                matching = $.grep(i, function (obj) {
                    return matcher.test(obj.COA_NM);
                });
                process(matching.map(function (i) { return i.COA_NM }));
            }
            else {
                matching = [];
                process([]);
            }
        }



        var showCopyModel = function () {
            var selectedCenterID = $('#ddlCentre').val();
            var selectedCenterName = $('#ddlCentre option:selected').text();
            $('#lblCentreFrom').text(selectedCenterName).attr('centreID', selectedCenterID);
            $('#divCopyToCentreModel').showModel();
            var d = $.grep(centres, function (e) {
                return e.CentreID != selectedCenterID;
            });

            var str = '';
            for (var i = 0; i < d.length; i++) {
                str += '<div class="col-md-16" style="padding-left: 0px;margin-left: -4px;" centreID="' + d[i].CentreID + '" ><label><input type="checkbox"> ' + d[i].CentreName + '</div>';
            }
            $('#divSelectCentres').html(str);
        }



    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Finance Item Master Mapping</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Center Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Select Centre" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Category
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCategory" runat="server" ClientIDMode="Static" onchange="$bindSubCategory($('#ddlCategory').val(),function(){});" TabIndex="2" ToolTip="Select Category" CssClass="requiredField"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Sub Category
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlSubCategory" runat="server" ClientIDMode="Static" TabIndex="3" ToolTip="Select SubCategory"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Item Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtItemName" tabindex="4" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                       Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlType" runat="server" ClientIDMode="Static" TabIndex="4" ToolTip="Select Type">
                        <asp:ListItem Value="0" >Un-Mapped</asp:ListItem>
                          <asp:ListItem Value="1" >Mapped</asp:ListItem>
                          <asp:ListItem Value="2" >Both</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24 textCenter">
                    <input type="button" id="btnSearch" onclick="searchItems()" class="save" value="Search" tabindex="6" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvItem" style="display: none;">
            <div class="Purchaseheader">
                Item List
            </div>
            <div class="row">
                <div class="col-md-24 textCenter">
                    <div id="dvItemList" style="font-size:11px"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvSave" style="display: none;">
            <div class="row">
                <div class="col-md-24 textCenter">
                    <input type="button" id="btnSave" onclick="showCopyModel()" class="save" value="Save" tabindex="7" />
                </div>
            </div>
        </div>
    </div>



    <div id="divCopyToCentreModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 650px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divCopyToCentreModel" aria-hidden="true">×</button>
                    <b class="modal-title">Copy To Centre</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-8">
                                    <label class="pull-left">
                                        Copy Centre Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-16">
                                    <label id="lblCentreFrom" class="pull-left patientInfo" centreid="0"></label>

                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-8">
                                    <label class="pull-left">
                                        Select  Centre To Copy
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-16" id="divSelectCentres">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer">

                    <button type="button" class="save" onclick="saveFinanceMapping(this)">Save</button>
                    <button type="button" data-dismiss="divCopyToCentreModel">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

