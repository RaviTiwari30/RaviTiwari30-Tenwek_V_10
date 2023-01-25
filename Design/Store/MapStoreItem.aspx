<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MapStoreItem.aspx.cs" Inherits="Design_Store_MapStoreItem" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Handsome-Table/handsontable.full.js"></script>
    <link href="../../Scripts/Handsome-Table/handsontable.full.min.css" rel="stylesheet" />

    <style type="text/css">
        /*.htDimmed {
            background-color: antiquewhite !important;
            color: #0e0e0e !important;
        }*/


        .ht_clone_top {
            z-index: 0 !important;
        }

        .ht_clone_left {
            z-index: 0 !important;
        }

        #container.handsontable table {
            width: 100%;
        }
    </style>


    <script type="text/javascript">       

        //*****Global Variables*******
        var hTables = {};
        var matching = [];
        var items = [];
        var racksDetails = [];
        var shelfDetails = [];
        var centreID = '<%=ViewState["centerID"].ToString()%>';
        var departmentLedgerNo = '<%=ViewState["deptLedgerNo"].ToString()%>';
        var userID = '<%=ViewState["userID"].ToString()%>';
        var hospitalID = '<%=ViewState["HOSPID"].ToString()%>';
       <%-- var pharmacyWareHouseCenterID = '<%=ViewState["pharmacyWareHouseCenterID"].ToString()%>'; --%>

        //****************************



        $(function () {
            getCentre(function () { });
            getDepartMent(function () { });
            getCategorys(function () {
                getSubCategorys($('#ddlCategory').val());
            });
            getManufactures(function () { });
            getLoyalityCatogerys(function () { });
            getRacks(function () { });
            getShelf(function () { });
            getMedicineGroup(function () { });


        });


        var loyalityCategerys = {};
        var getLoyalityCatogerys = function () {
            serverCall('Services/CommonService.asmx/GetLoyalityCatogerys', {}, function (response) {
                loyalityCategerys.master = JSON.parse(response);
                loyalityCategerys.categorys = [];
                loyalityCategerys.categorys.push('');
                $.map(loyalityCategerys.master, function (i) { loyalityCategerys.categorys.push(i.Name) });
            });
        }

        var getMedicineGroup = function (callback) {
            serverCall('Services/CommonService.asmx/GetMedicineGroup', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlMedicineGroup').bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'ItemGroup', defaultValue: 'All' }));
            });
        }

        var getCentre = function (callback) {
            serverCall('Services/CommonService.asmx/GetALLCentre', {}, function (response) {
                var responseData = JSON.parse(response);
                var _ddlCentre = $('#ddlCentre');
                _ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', selectedValue: centreID });

                /* if (pharmacyWareHouseCenterID != centreID)
                     $(_ddlCentre).prop('disabled', true); */

                callback(_ddlCentre.val());
            });
        }


        var getCategorys = function (callback) {
            serverCall('Services/MapStoreItem.asmx/GetAllCategory', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlCategory').bindDropDown({ data: JSON.parse(response).reverse(), valueField: 'CategoryID', textField: 'Name' }));
            });
        }


        var getSubCategorys = function (categoryID) {
            serverCall('Services/MapStoreItem.asmx/GetSubCategoryByCategory', { categoryID: categoryID }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlSubCategory').bindDropDown({ data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'Name', defaultValue: 'All' });
            });
        }


        var getDepartMent = function (callback) {
            serverCall('Services/CommonService.asmx/GetDepartMent', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlDepartment').bindDropDown({ data: JSON.parse(response), valueField: 'DeptLedgerNo', textField: 'RoleName', defaultValue: 'All' }));
            });
        }




        var getRacks = function () {
            serverCall('Services/CommonService.asmx/GetRacks', {}, function (response) {
                var responseData = JSON.parse(response);
                racksDetails.master = responseData;
                racksDetails.racks = [];
                $.map(racksDetails.master, function (i) { racksDetails.racks.push(i.Name) });
            });
        }



        var getShelf = function () {
            serverCall('Services/CommonService.asmx/GetShelf', {}, function (response) {
                var responseData = JSON.parse(response);
                shelfDetails.master = responseData;
            });
        }



        var onValidateCellData = function (isValid, value, row, prop, source) {
            //var btnSave= $('#btnSave');
            //if (!isValid)
            //    $(btnSave).prop('disabled',false);
            //else
            //    $(btnSave).prop('disabled',true);
        }



        var getGridSetting = function (callback) {
            var s = {
                data: mappedItems,
                rowHeaders: true,
                contextMenu: false,
                filters: true,
                height: 400,
                stretchH: 'all',
                afterValidate: onValidateCellData,
                contextMenu: { callback: function (key, selection, clickEvent) { }, items: { 'row_above': {}, 'row_below': {}, 'remove_row': {} } },
                //  colHeaders: ['StoreType', 'ItemName', 'Minlevel', 'Maxlevel', 'ReOrder', 'ReOrder Qty', 'Discount', 'LoyalityCategory', 'Rack-Details', 'Shelf', 'IsActive'],
                colHeaders: ['Category', 'SubCategory', 'ItemName', 'IsActive'],
                columns: [{ data: "Category", type: 'text', readOnly: true },
                          { data: "SubCategory", type: 'text', readOnly: true },
						  { data: 'TypeName', type: 'text', readOnly: true },
						// { data: 'MinLevel', type: 'numeric', allowInvalid: false },
						// { data: 'MaxLevel', type: 'numeric', allowInvalid: false },
						// { data: 'ReorderLevel', type: 'numeric', allowInvalid: false },
						//  { data: 'ReorderQty', type: 'numeric', allowInvalid: false },
						//  { data: 'Discount', type: 'numeric', allowInvalid: false },
						  //{
						  //    data: 'LoyalityCategoryID',
						  //    type: 'dropdown',
						  //    source: loyalityCategerys.categorys,
						  //    allowInvalid: false
						  //},
						  //{
						  //    data: 'Rack',
						  //    type: 'dropdown',
						  //    source: racksDetails.racks,
						  //    allowInvalid: false
						  //},
						  //{
						  //    data: 'Shelf',
						  //    type: 'dropdown',
						  //    allowInvalid: false
						  //},
						  {
						      data: 'IsActive',
						      type: 'dropdown',
						      source: ['N', 'Y'],

						      allowInvalid: false
						  }
                ]

            }
            callback(s);
        }



        //var isActiveRenderAction = function (instance, td, row, col, prop, value, cellProperties) {
        //    if(row==0)
        //        $(td).html('<input type="checkbox" ' + (value == 'true' ? 'checked' : '') + ' onclick="selectAllItemsConfirmation();" />').css('text-align', 'center');
        //    else
        //        $(td).html('<input ' + (value == 'true' ? 'checked' : '') + ' type="checkbox" />').css('text-align', 'center');
        //}


        var hTables = {};
        var arr = new Array();
        var searchItems = function () {
            $("#divManufactureList ul li").each(function () {
                arr.push($(this).attr('id'));
            });

            if ($('#chkdate').is(":checked"))
                var date = $('#ucFromDate').val();
            else
                date = "";

            var itemtype = $('input[type=radio][name=itemtype]:checked').val();

            var data = {
                centerID: $.trim($('#ddlCentre').val()),
                departMentLedgerNo: $.trim($('#ddlDepartment').val()),
                categoryID: $.trim($('#ddlCategory').val()),
                subCategoryID: $.trim($('#ddlSubCategory').val()),
                itemName: $.trim($('#txtItemName').val()),
                manufactureID: arr,                                            // $.trim($('#ddlManufacturer').val())
                groupid: $.trim($("#ddlMedicineGroup").val()),
                date: date,
                itemtype: itemtype,
                centreName: $.trim($('#ddlCentre option:selected').text())
            };

            serverCall('Services/MapStoreItem.asmx/GetItems', data, function (response) {
                mappedItems = JSON.parse(response);
                bindMappedItems(mappedItems);

            });

            while (arr.length > 0) {
                arr.pop();
            }
            //hTables.init();
        }


        var bindMappedItems = function (data) {
            getGridSetting(function (s) {
                var $container = document.getElementById('divMappedItems');
                $container.innerHTML = '';
                s.data = data;
                hTables = new Handsontable($container, s);
                hTables.render();
                hTables.addHook('beforeChange', function (changes, source) {
                    debugger;
                    if (source === 'loadData' || source === 'internal' || changes.length > 1) {
                        return;
                    }
                    var row = changes[0][0];
                    var prop = changes[0][1];
                    var value = changes[0][3];

                    if (prop === 'Rack') {
                        var rack = racksDetails.master.filter(function (i) { if (i.Name == value) { return i } });
                        var shelfsByRackID = shelfDetails.master.filter(function (i) { if (i.RackID == rack[0].ID) { return i; } });
                        var shelfs = [];
                        $.map(shelfsByRackID, function (i) { shelfs.push(i.ShelfName) });
                        this.setCellMeta(row, this.propToCol('Shelf'), 'source', shelfs);
                    }
                    hTables.render();
                });
                if (mappedItems.length > 0)
                    $('.searchResults').show();
                else
                    $('.searchResults').hide();
            });


        }



        var getMappedItems = function (callback) {
            var data = [];
            $(hTables.getData()).each(function () {
                var loyalityCategoryID = this.LoyalityCategoryID;
                var s = loyalityCategerys.master.filter(function (i) { if (i.Name == loyalityCategoryID) { return i; } });
                var LoyalityCategoryID = s.length > 0 ? s[0].ID : 0;
                data.push({
                    Maxlevel: Number(this.MaxLevel),
                    Minlevel: Number(this.MinLevel),
                    Reorderlevel: Number(this.ReorderLevel),
                    Reorderqty: Number(this.ReorderQty),
                    Maxreorderqty: Number(this.MaxReorderQty),
                    Minreorderqty: Number(this.MinReorderQty),
                    Discount: Number(this.Discount),
                    Rack: $.trim(this.Rack),
                    Shelf: $.trim(this.Shelf),
                    LoyalityCategoryID: LoyalityCategoryID,
                    Majorunit: this.MajorUnit,
                    Minorunit: this.MinorUnit,
                    Conversionfactor: this.ConversionFactor,
                    Subcategoryid: this.SubCategoryID,
                    Itemid: this.ItemID,
                    Deptledgerno: this.departMentLedgerNo,
                    Centreid: this.centerID,
                    Isactive: this.IsActive,
                    CentreName: this.CentreName
                });
            });
            callback(data);
            // });
        }

        var checkAll = function (checkStatus) {
            $('#divMappedItems table tbody input[type=checkbox]').prop('checked', checkStatus);
        }


        var itemCheckChanged = function (elem) {
            $('#chkAll').prop('checked', ($('#divMappedItems table tbody input[type=checkbox]').not(':checked').length == 0))
        }

        //var onItemvalueChange = function (e) {
        //	var code = (e.keyCode ? e.keyCode : e.which);
        //	var cell = $(e.target).closest('td');
        //	var cellIndex = e.target.parentNode.cellIndex;
        //	var row = $(e.target).closest('tr');

        //	if (code == 13) {
        //		modelConfirmation('Confirmation', 'Copy Cell Value To The Column !!', 'Copy', 'Cancel', function (response) {
        //			if (response)
        //				$('#divMappedItems table tbody tr  td:nth-child(' + (cellIndex + 1) + ')').find('input').val(e.target.value).keyup();
        //		});
        //	}
        //}



        var getManufactures = function (callback) {
            serverCall('Services/CommonService.asmx/GetManufactures', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlManufacturer').bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ManufactureID', textField: 'NAME' }));
            });
        }






        var saveItems = function (btnSave) {
            getMappedItems(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('Services/MapStoreItem.asmx/SaveItems', { listItems: data }, function (res) {
                    $responseData = JSON.parse(res);
                    modelAlert($responseData.response, function (res) {
                        if ($responseData.status)
                            modelConfirmation('Confirmation ?', 'Do you want to apply Same Items Mapping to Another Centre.', 'Yes Copy To Another Centre', 'Cancel', function (response) {
                                if (response) {
                                    // $("#divItemMappingModel").showModel();
                                    loadCentreToModel(data[0].Centreid, data[0].CentreName);
                                    $(btnSave).removeAttr('disabled').val('Save');
                                }
                                else {
                                    window.location.reload();
                                }
                            });
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            })
        }

        var copyCentreItemMapping = function (btnCopy) {
            var centreList = [];
            $('#ulCentreTo li').each(function () {
                if ($(this).find('input').is(":checked")) {
                    centreList.push({
                        centreId: $(this).find('input').attr('id')
                    })
                }
            });

            if (centreList.length == 0) {
                modelAlert('Please Select Atleast One Centre To Copy !!!');
                return;
            }
            getMappedItems(function (data) {
                $(btnCopy).attr('disabled', true).val('Submitting...');
                serverCall('Services/MapStoreItem.asmx/CopyItemMappingItems', { listItems: data, centreList: centreList }, function (res) {
                    $responseData = JSON.parse(res);
                    modelAlert($responseData.response, function (res) {
                        if ($responseData.status)
                            window.location.reload();
                        else
                            $(btnCopy).removeAttr('disabled').val('Save');
                    });
                });
            })
        }
        var loadCentreToModel = function (centreId, CentreName) {
            $("#lblCentreFrom").text(CentreName);
            serverCall('Services/CommonService.asmx/GetALLCentre', {}, function (response) {
                var responseData = JSON.parse(response);
                var responseCentreTo = responseData.filter(function (i) { return i.CentreID != centreId });
                var ulCentreTo = $('#ulCentreTo');
                ulCentreTo.find('li').remove();
                if (responseCentreTo.length > 0) {
                    $.each(responseCentreTo, function (i) {
                        var aa = '<li  role="menuitem"><a>'
                            + '<label class="trimList"  title="' + this.CentreName + '" >'
                            + '<input   id="' + $.trim(this.CentreID) + '" value="' + this.CentreID + '" class="ui-all" type="checkbox" '
                            + ' >' + this.CentreName + '</label></a> </li>';
                        ulCentreTo.append(aa);
                    });


                    $("#divItemMappingModel").showModel();
                }
                else
                    modelAlert("Only One Centre Exist in the System !!!");

            });
        }

    </script>






    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Centre-Wise Item Mapping</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Centre </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlCentre"></select>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">
                        Item Creation From
                    </label>
                    <b class="pull-right">:</b>
                    <input type="checkbox" id="chkdate" />
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="ucFromDate" runat="server" ToolTip="Click To Select From Date" ReadOnly="true" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Item Type
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input id="rdbunmappItem" type="radio" name="itemtype" value="unmapped" class="pull-left" />
                    <span class="pull-left">UnMapped</span>
                    <input id="rdbmappItem" type="radio" name="itemtype" value="mapped" class="pull-left" />
                    <span class="pull-left">Mapped</span>
                    <input id="rdbboth" type="radio" name="itemtype"  checked="checked" value="Both" class="pull-left" />
                    <span class="pull-left">Both</span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Category </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select onchange="getSubCategorys(this.value)" id="ddlCategory"></select>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">SubCategory </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <select id="ddlSubCategory"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Item Name </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-5">
                    <input type="text" id="txtItemName" />
                </div>


            </div>

            <div class="row" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left">Manufacturer</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlManufacturer"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Group</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlMedicineGroup"></select>

                </div>
                <div class="col-md-3">
                    <label class="pull-left">Department </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-5">
                    <select id="ddlDepartment"></select>
                </div>

                <div class="col-md-3"></div>
                <div class="col-md-5"></div>
            </div>

            <div class="row" style="display: none">
                <div class="col-md-3">
                    <label class="pull-left">Manufacturer List</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21">
                    <div id="divManufactureList" class="chosen-container-multi">
                        <ul id="ulManufactureList" style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                        </ul>
                    </div>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-8"></div>
                <div class="col-md-8 textCenter">
                    <input type="button" value="Search" class=" save" onclick="searchItems();" id="btnSearch" />
                </div>
                <div class="col-md-6">
                    <input type="button" value="Export-to-Excel" class="save pull-right" onclick="exportToExcel();" style="display: none" id="Button1" />
                </div>
                <div class="col-md-2">
                    <input type="button" value="Import-From-Excel" class="pull-right" onclick="onImportExcel();" style="display: none" id="Button2" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory searchResults">
            <div class="row">
                <div class="col-md-24">
                    <div id="divMappedItems"></div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory searchResults" style="text-align: center; display: none">
            <div class="row">
                <div class="col-md-8">
                    <button type="button" style="width: 30px; display: none; height: 30px; float: left; margin-left: 5px; background-color: lightpink" class="circle"></button>
                    <b style="float: left; margin-top: 5px; display: none; margin-left: 5px">Non-Editable</b>
                </div>
                <div class="col-md-8">
                    <input type="button" value="Save" class=" save margin-top-on-btn" onclick="saveItems(this);" id="btnSave" />
                </div>
                <div class="col-md-8"></div>

            </div>

        </div>


    </div>

    <div id="divImportMapping" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 350px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divImportMapping" aria-hidden="true">×</button>
                    <h4 class="modal-title">Import .xlsx File.</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-24">
                            <input type="file" id="fileUploaderExcel" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="save" onclick="uploadFile()">Upload File</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divItemMappingModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 500px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divItemMappingModel" aria-hidden="true">&times;</button>
                    <b class="modal-title">Copy Same Item Mapping</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-12">
                                    <label class="pull-left" style="font-weight: bold">
                                        Copy Centre Name 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-12">
                                    <label id="lblCentreFrom" class="pull-left patientInfo" style="font-weight: bold"></label>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <label class="pull-left" style="font-weight: bold">
                                        Select Centre To Copy 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-12">
                                    <ul id="ulCentreTo" style="list-style-type: none; margin-left: -10px;"></ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
                <div class="modal-footer">

                    <button type="button" onclick="copyCentreItemMapping(this)" class="save">Save</button>
                    <button type="button" data-dismiss="divItemMappingModel">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">



        var exportToExcel = function () {
            var centerName = $('#ddlCentre option:selected').text();
            var departmentName = $('#ddlDepartment option:selected').text();
            var data = hTables.getData();
            serverCall('Services/MapStoreItem.asmx/ConvertToExcel', { fileName: 'ABC', data: data }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    window.open('../common/ExportToExcel.aspx');
                }
            });
        }



        var onImportExcel = function () {
            $('#divImportMapping').showModel();
        }

        var uploadFile = function () {
            var data = new FormData();
            var files = $('#fileUploaderExcel').get(0).files;
            if (files.length < 1) {
                modelAlert('Please Select .xlxs File', function () { });
                return false;
            }
            data.append("excelFile", files[0]);
            var ajaxRequest = $.ajax({
                type: 'POST',
                url: '../Common/ConvertXLSToJSON.asmx/Convert',
                contentType: false,
                processData: false,
                data: data,
                complete: function (data) {
                    var responseData = JSON.parse(data.responseText);
                    if (responseData.status) {
                        mappedItems = responseData.data;
                        mappedItems.forEach(function (obj) {
                            obj.Deptledgerno = Number($('#ddlDepartment').val());
                            obj.departMentLedgerNo = Number($('#ddlDepartment').val());
                            obj.centerID = Number($('#ddlCentre').val());
                            obj.Centreid = Number($('#ddlCentre').val());
                        });
                        bindMappedItems(mappedItems);
                        $('#divImportMapping').closeModel();
                    }
                    else {
                        modelAlert(responseData.message);
                    }
                },
            });
        }

    </script>



    <script type="text/javascript">
        $('#ddlManufacturer').change(function (elem) {
            if (this.value == '0')
                return false;

            var data = {
                value: this.value,
                text: $(this.selectedOptions).text()
            }

            BindManufactureList(data, function () { });
        });

        var BindManufactureList = function (data, callback) {
            var ManufactureList = $('#divManufactureList');

            $isAlreadyExits = ManufactureList.find('#' + data.value);
            if ($isAlreadyExits.length > 0) {
                modelAlert('Manufacture Item Already Seleted');
                return false;
            }
            ManufactureList.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a></li>');
            callback(ManufactureList);
        }
    </script>

</asp:Content>

