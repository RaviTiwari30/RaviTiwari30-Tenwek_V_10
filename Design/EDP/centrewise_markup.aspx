<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="centrewise_markup.aspx.cs" Inherits="Design_EDP_centrewise_markup" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />
    <script type="text/javascript">

        //  var searchedItems = "";

        $(document).ready(function () {
            $bindCentre(function () {
                $bindCategory(function () {
                    $('#dvItemList,#dvSave,#dvItem').hide();
                });
            });

        });


        var $bindCentre = function (callback) {

            serverCall('Services/centrewise_markup.asmx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                $Centre.bindDropDown({ defaultValue: 'Universal', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: 'Universal' });
                callback($Centre.find('option:selected').text());
            });
        }
        var $bindCategory = function (callback) {
            serverCall('../common/CommonService.asmx/BindCategory', { Type: '7' }, function (response) {
                $Category = $('#ddlCategory');
                $Category.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                $bindSubCategory($Category.val(), function () {
                    callback($Category.find('option:selected').text());
                });

            });
        }
        $bindSubCategory = function (categoryID, callback) {
            $subCategory = $('#ddlSubCategory');
            serverCall('../common/CommonService.asmx/BindSubCategory', { Type: '0', CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($subCategory.find('option:selected').text());
            });
        }

        function searchItems() {

            $('#lblMsg').text('');
            $('#dvItemList').html('');
            $('#dvItemList,#dvSave,#dvItem').hide();
            if ($('#ddlCategory').val() == "0") {
                $('#lblMsg').text('Please Select Category');
                return false;
            }
            if ($('#ddlSubCategory').val() == "0") {
                $('#lblMsg').text('Please Select Sub Category');
                return false;
            }

            var data = {

                CategoryID: $.trim($('#ddlCategory').val()),
                SubCategoryID: $.trim($('#ddlSubCategory').val()),
                ItemName: $.trim($('#txtItemName').val()),
                IsSet: $('#rdbIsSet input:checked').val(),
                CentreID: $.trim($('#ddlCentre').val())
            };
            serverCall('Services/centrewise_markup.asmx/BindGridItems', data, function (response) {
                searchedItems = JSON.parse(response);
                if (searchedItems.length > 0) {
                    $('#dvItemList,#dvSave,#dvItem').show();
                    $('#lblMsg').text('Total Records : ' + searchedItems.length);
                    container2 = document.getElementById('dvItemList'),
                    hot2 = new Handsontable(container2, {
                        data: searchedItems,
                        colHeaders: ["Category", "Sub Category", "Item Name", "MarkUpPercentage"],
                        readOnly: true,
                        columns: [
                         { data: 'CategoryName', readOnly: true, width: '200' },
                         { data: 'SubCategoryName', readOnly: true, width: '200' },
                         { data: 'TypeName', renderer: safeHtmlRenderer, readOnly: true, width: '500' },
                         { data: 'MarkUpPercentage', type: 'numeric', format: '0.0000', readOnly: false, allowInvalid: false, width: '100' },

                        ],

                        stretchH: "all",
                        autoWrapRow: false,
                        fillHandle: false,
                        rowHeaders: true,
                        contextMenu: false,
                        filters: true,
                        height: 380
                    });
                }
                else {
                    $('#lblMsg').text('No Record found as per searching criteria');
                    return false;
                }
            });
        }

        function safeHtmlRenderer(instance, td, row, col, prop, value, cellProperties) {
            td.innerText = value;
            $(td).css({ 'text-align': 'left' });
        }

        function saveCentreWiseMarkup() {

            $('#lblMsg').text('');
            $('#btnSave').attr('disabled', true).val('Submitting...');

            var data = {
                ItemList: searchedItems,
                CenterID: Number($.trim($('#ddlCentre').val())),
                SubCategoryID: $.trim($('#ddlSubCategory').val()),
                IsSet: Number($('#rdbIsSet input:checked').val())

            };
            serverCall('Services/centrewise_markup.asmx/saveMarkup', data, function (response) {
                $responseData = JSON.parse(response);
                modelAlert($responseData.response, function (response) {
                    if ($responseData.status) {
                        searchItems();
                        $('#btnSave').removeAttr('disabled').val('Save');
                    }
                    else {
                        $('#btnSave').removeAttr('disabled').val('Save');
                    }
                });
            });
        }

    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Centre Wise Markup </b>
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
                        Centre Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" runat="server" ClientIDMode="Static" TabIndex="1" ToolTip="Select Centre"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Category
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCategory" runat="server" ClientIDMode="Static" onchange="$bindSubCategory($('#ddlCategory').val(),function(){});" TabIndex="2" ToolTip="Select Category"></asp:DropDownList>
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
                        Is Set
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:RadioButtonList ID="rdbIsSet" runat="server" ClientIDMode="Static" TabIndex="5" RepeatDirection="Horizontal">
                        <asp:ListItem Value="0" Selected="True">No</asp:ListItem>
                        <asp:ListItem Value="1">Yes</asp:ListItem>
                        <asp:ListItem Value="2">Both</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5 textCenter">
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
                    <div id="dvItemList"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="dvSave" style="display: none;">
            <div class="row">
                <div class="col-md-24 textCenter">
                    <input type="button" id="btnSave" onclick="saveCentreWiseMarkup()" class="save" value="Save" tabindex="7" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

