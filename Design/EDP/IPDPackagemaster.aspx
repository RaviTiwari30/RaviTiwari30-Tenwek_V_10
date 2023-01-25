<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IPDPackageMaster.aspx.cs" Inherits="Design_EDP_IPDPackageMaster" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .hidden
        {
            display: none;
        }
        .checkbox
        {
           background-color: lightgreen
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            checkNewoldPackage(function () {
                bindPkgCategory(function (response) {
                    bindAllCategory(function (response) {
                      //  bindRoomTypeMaster(function () {
                            init();
                     //   });
                    });
                });
            });
            $('.scroll').slimScroll({
                color: '#008AFF',
                height: '150px',
            });
        });

        var checkNewoldPackage = function (callback) {
            if ($('#rbtNewEdit :checked').val() == 'New') {
                $('#ddlIPDPackage').val('0').prop('disabled', true).chosen('destroy').chosen();
                $('#txtIPDPackage').val('');
                $('#SpnPackageItemID').text('');
                $('#tblPackage tbody').empty();
                $('#btnSave').val('Save');
            }
            else {
                $('#txtIPDPackage').val('');
                $('#ddlIPDPackage').val('0').prop('disabled', false).chosen('destroy').chosen();
                $('#btnSave').val('Update');
            } 
            callback();
        }


        var bindPkgCategory = function (callback) {
            Configid = '14';
            $ddlCategory = $('#ddlPkgCategory');
            serverCall('IPDPackageMaster.aspx/BindPkgCategory', { ConfigID: Configid }, function (response) {
                $ddlCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CategoryID', textField: 'NAME', isSearchAble: true });
                bindPkgSubCategory(Configid, $ddlCategory.val(), function () {
                    callback($ddlCategory.val());
                });
            });
        }

        var bindPkgSubCategory = function (Configid, categoryID, callback) {

            $subCategory = $('#ddlPkgSubCategory');
            serverCall('IPDPackageMaster.aspx/BindPkgSubCategory', { ConfigID: Configid, CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'NAME', isSearchAble: true });
                bindPackageName(Configid, categoryID, $subCategory.val(), function () {
                    callback($subCategory.val());
                });
            });
        }

        var bindPackageName = function (Configid, categoryID, subcategoryID, callback) {
            Configid = '14';
            $ddlIPDPackage = $('#ddlIPDPackage');
            serverCall('IPDPackageMaster.aspx/BindIPDPackageMaster', { ConfigID: Configid, CategoryID: categoryID, SubCategoyrID: subcategoryID }, function (response) {
                $ddlIPDPackage.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });
                callback($ddlIPDPackage.val());
            });
        }

        var bindAllCategory = function (callback) {
            $ddlCategory = $('#ddlCategory');
            serverCall('IPDPackageMaster.aspx/BindAllCategory', {}, function (response) {
                $ddlCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CategoryID', textField: 'NAME', isSearchAble: true });

                bindAllSubCategory($ddlCategory.val(), function () {
                    callback($ddlCategory.val());
                });
            });
        }

        var bindAllSubCategory = function (categoryID, callback) {
            $subCategory = $('#ddlSubCategory');

            var responseData = {
                item: {
                    label: $('#ddlCategory option:selected').text(),
                    val: $('#ddlCategory').val().split('#')[0],
                    ItemID: '',
                    TypeName: '',
                    SubCategoryID: '',
                    CategoryID: $('#ddlCategory').val().split('#')[0],
                    SubCategoryName: '',
                    CategoryName: $('#ddlCategory option:selected').text(),
                    ConfigID: $('#ddlCategory').val().split('#')[1],
                    PackageType: 'CategoryWise'
                }
            }
            $('#spnSelectedItem').text('');
            $('#spnSelectedItemdetails').text(JSON.stringify(responseData));

            serverCall('IPDPackageMaster.aspx/BindAllSubCategory', { ConfigID: Configid, CategoryID: categoryID }, function (response) {
                $subCategory.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'SubCategoryID', textField: 'NAME', isSearchAble: true });

                callback($subCategory.val());

            });
        }

        var getSubCategoryDetails = function (callback) {
            var responseData = {
                item: {
                    label: $('#ddlSubCategory option:selected').text(),
                    val: $('#ddlSubCategory').val().split('#')[0],
                    ItemID: '',
                    TypeName: '',
                    SubCategoryID: $('#ddlSubCategory').val().split('#')[0],
                    CategoryID: $('#ddlSubCategory').val().split('#')[1],
                    SubCategoryName: $('#ddlSubCategory option:selected').text(),
                    CategoryName: $('#ddlSubCategory').val().split('#')[3],
                    ConfigID: $('#ddlCategory').val().split('#')[2],
                    PackageType: 'SubCategoryWise'
                }
            }
            $('#spnSelectedItem').text('');
            $('#spnSelectedItemdetails').text(JSON.stringify(responseData));
            callback();
        };

        var init = function () {
            $('#txtSearch').autocomplete({
                source: function (request, response) {
                    $categoryID = $('#ddlCategory').val().split('#')[0];
                    $subCategoryID = $('#ddlSubCategory').val().split('#')[0];
                    $bindItems({ searchType: 1, prefix: request.term, Type: 0, CategoryID: $categoryID, SubCategoryID: $subCategoryID, itemID: '' }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    //debugger;
                    $('#spnSelectedItem').text(i.item.label);
                    $('#spnSelectedItemdetails').text(JSON.stringify(i));
                },
                focus: function (e, i) {
                    // console.log(i);
                },
                close: function (el) {
                    el.target.value = '';
                },
                minLength: 2
            });
        };


        $bindItems = function (data, callback) {
            serverCall('IPDPackageMaster.aspx/BindAllItems', data, function (response) {
                var responseData = $.map(JSON.parse(response), function (item) {
                    return {
                        label: item.TypeName,
                        val: item.ItemID,
                        ItemID: item.ItemID,
                        TypeName: item.TypeName,
                        SubCategoryID: item.SubCategoryID,
                        CategoryID: item.CategoryID,
                        SubCategoryName: item.SubCategoryName,
                        CategoryName: item.CategoryName,
                        ConfigID: item.ConfigID,
                        PackageType: 'ItemWise'
                    }
                });
                callback(responseData);
            });

        }

        var clearAmount = function (rowID) {
            if (rowID == 0) {
                if (Number($('#txtQuantity').val()) > 0) {
                    $('#txtAmount').val('0');
                    $('#txtAmount').removeClass('requiredField');
                    $('#txtQuantity').addClass('requiredField');
                }
            }
            else {
                if (Number($(rowID).closest('tr').find('#txtQty').val()) > 0) {
                    $(rowID).closest('tr').find('#txtAmt').val('0')
                }
            }
        }
        var clearQty = function (rowID) {
            if (rowID == 0) {
                if (Number($('#txtAmount').val()) > 0) {
                    $('#txtQuantity').val('0');
                    $('#txtAmount').addClass('requiredField');
                    $('#txtQuantity').removeClass('requiredField');
                }
            }
            else {
                if (Number($(rowID).closest('tr').find('#txtAmt').val()) > 0) {
                    $(rowID).closest('tr').find('#txtQty').val('0')
                }
            }
        }

        var getDetails = function () {
            if (String.isNullOrEmpty($('#spnSelectedItemdetails').text())) {
                modelAlert('Please Select Something', function () {
                    $('#ddlCategory').focus();
                });
                return false;
            }

            var selectedData = JSON.parse($('#spnSelectedItemdetails').text());

            if (selectedData.item.val == "0") {
                modelAlert('Please Select Something', function () {
                    $('#ddlCategory').focus();
                });
                return false;
            }

            if (selectedData.item.PackageType == 'CategoryWise') {
                if ($('#tblPackage tbody tr #tdCategoryID').filter(function () { return ($(this).text().trim() == selectedData.item.CategoryID) }).length > 0) {
                    modelAlert('Selected Category Already Added!', function () { $('#ddlCategory').focus(); });
                    return;
                }
            }
            if (selectedData.item.PackageType == 'SubCategoryWise') {
                var tbpkg = $('#tblPackage tbody tr');
                var isExists = 0;
                $(tbpkg).each(function () {
                    if ($(this).find('#tdPackageType').text() == 'CategoryWise' && $(this).find('#tdCategoryID').text() == selectedData.item.CategoryID) {
                        modelAlert('Category Wise Detail Already Added !', function () { $('#ddlSubCategory').focus(); });
                        isExists = 1;
                    }
                    else if ($(this).find('#tdPackageType').text() == 'ItemWise' && $(this).find('#tdCategoryID').text() == selectedData.item.CategoryID) {
                        modelAlert('ItemWise Detail Already Added!', function () { $('#ddlSubCategory').focus(); });
                        isExists = 1;
                    }
                    else if ($(this).find('#tdSubCategoryID').text() == selectedData.item.SubCategoryID) {
                        modelAlert('Selected SubCategory Already Added!', function () { $('#ddlSubCategory').focus(); });
                        isExists = 1;
                    }
                });
                if (isExists == 1) {
                    return false;
                }
            }
            if (selectedData.item.PackageType == 'ItemWise') {
                var tbpkg = $('#tblPackage tbody tr');
                var isExist = 0;
                $(tbpkg).each(function () {
                    if ($(this).find('#tdPackageType').text() == 'CategoryWise' && $(this).find('#tdCategoryID').text() == selectedData.item.CategoryID) {
                        modelAlert('CategoryWise Detail Already Added!', function () { $('#ddlCategory').focus(); });
                        isExists = 1;
                    }
                    else if ($(this).find('#tdPackageType').text() == 'SubCategoryWise' && $(this).find('#tdCategoryID').text() == selectedData.item.CategoryID) {
                        modelAlert('SubCategoryWise Detail Already Added!', function () { $('#ddlSubCategory').focus(); });
                        isExists = 1;
                    }
                    else if ($(this).find('#tdItemID').text() == selectedData.item.ItemID) {
                        modelAlert('Selected Item Already Added!', function () { $('#txtSearch').focus(); });
                        isExists = 1;
                    }
                });
                if (isExists == 1) {
                    return false;
                }
            }
            if (Number($('#txtQuantity').val()) <= 0 && Number($('#txtAmount').val()) <= 0) {
                modelAlert('Please Enter Either Quantity or Amount', function () {
                    $('#txtQuantity').focus();
                });
                return false;
            }

            data = [];
            data.push({
                PackageType: selectedData.item.PackageType,
                CategoryID: selectedData.item.CategoryID,
                CategoryName: selectedData.item.CategoryName,
                SubCategoryID: selectedData.item.SubCategoryID,
                SubCategoryName: selectedData.item.SubCategoryName,
                ItemID: selectedData.item.ItemID,
                ItemName: selectedData.item.TypeName,
                Quantity: $('#txtQuantity').val(),
                Amount: $('#txtAmount').val(),
                ConfigID: selectedData.item.ConfigID,
            });
            AddDetails(data);

        }

        var AddDetails = function (data) {
            var j = 0;
            for (var i = 0; i < data.length; i++) {
                j = $('#tblPackage tbody tr').length + 1;
                var row = '<tr>';
                row += '<td id="tdsrno"  class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdPackageType"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].PackageType + '</td>';
                row += '<td id="tdCategoryID"  class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].CategoryID + '</td>';
                row += '<td id="tdCategoryName"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].CategoryName + '</td>';
                row += '<td id="tdSubCategoryID"  class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].SubCategoryID + '</td>';
                row += '<td id="tdSubCategoryName"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].SubCategoryName + '</td>';
                row += '<td id="tdItemID"  class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ItemID + '</td>';
                row += '<td id="tdItemName"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemName + '</td>';
                row += '<td id="tdConfigID"  class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ConfigID + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtQty" onlynumber="true" maxlength="3" onkeyup="clearAmount(this);" value=' + data[i].Quantity + ' /></td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><input type="text" id="txtAmt" onlynumber="true" maxlength="3" onkeyup="clearQty(this);" value=' + data[i].Amount + ' /></td>';
                row += '<td class="GridViewLabItemStyle textCenter"><img id="imgDelete" src="../../Images/Delete.gif" onclick="DeleteRow(this);" title="Click To Delete" /></td>'
                row += '</tr>';
                $('#tblPackage tbody').append(row);
            }
            $('#spnSelectedItemdetails').text('');
            $('#spnSelectedItem').text('');
            //   $('#ddlCategory').val('0').chosen('destroy').chosen();
            //   $('#ddlSubCategory').val('0').chosen('destroy').chosen();
        }


        var DeleteRow = function (rowID) {
            var i = rowID.parentNode.parentNode.rowIndex;
            document.getElementById("tblPackage").deleteRow(i);
            var j = 1;
            $('#tblPackage tbody tr').each(function () {
                $(this).find('#tdsrno').html(j);
                j++;
            });
        }

        var bindPackageDetails = function () {
            $('#tblPackage tbody').empty();
            serverCall('IPDPackageMaster.aspx/BindPackageMasterDetails', { PackageID: $('#ddlIPDPackage').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('#ddlPkgCategory').val(responseData[0].CategoryID).chosen('destroy').chosen();
                    $('#ddlPkgSubCategory').val(responseData[0].SubCategoryID).chosen('destroy').chosen();
                    $('#txtIPDPackage').val(responseData[0].Packagename).focus();
                    $('#txtValidityDays').val(responseData[0].DaysInvolved);
                    $('input:radio[id*="rdbActive"]').filter('[value="' + responseData[0].IsActive + '"]').attr('checked', true);
                    $('#SpnPackageItemID').text(responseData[0].ItemID);
                    var PanelIDs = responseData[0].PanelID.split(',');
                    $('input:checkbox[id*="chlPanel"]').attr('checked', false);
                    $('input:checkbox[id*="chlPanel"]').parent().removeClass('checkbox');
                    for (var i = 0; i < PanelIDs.length; i++) {
                        $('input:checkbox[id*="chlPanel"]').filter('[value="' + PanelIDs[i] + '"]').attr('checked', true);
                        $('input:checkbox[id*="chlPanel"]').filter('[value="' + PanelIDs[i] + '"]').parent().addClass('checkbox');
                    }

                }
                else {
                    $('#ddlPkgCategory').val('0').chosen('destroy').chosen();
                    $('#ddlPkgSubCategory').val('0').chosen('destroy').chosen();
                    $('#txtIPDPackage').val('');
                    $('#txtValidityDays').val('0');
                    $('input:radio[id*="rdbActive"]').filter('[value="1"]').attr('checked', true);
                    $('#SpnPackageItemID').text('');
                    $('input:checkbox[id*="chlPanel"]').attr('checked', false);
                    $('input:checkbox[id*="chlPanel"]').parent().addClass('checkbox');
                }
            });
            serverCall('IPDPackageMaster.aspx/BindPackageDetails', { PackageID: $('#ddlIPDPackage').val() }, function (response) {
                var responseData = JSON.parse(response);
                AddDetails(responseData)
            });
           
        }

        var save = function () {
            if ($('#rbtNewEdit :checked').val() == 'New') {
                SavePackage();
            }
            else {
                UpdatePackage();
            }
        }

        var SavePackage = function () {
            getPackageDetails(function (data) {
                serverCall('IPDPackageMaster.aspx/SavePackage', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status)
                        modelAlert(responseData.response, function () {
                            location.href = 'IPDPackageMaster.aspx';
                        });
                    else
                        modelAlert(responseData.response);
                });
            });
        }
        var UpdatePackage = function () {
            getPackageDetails(function (data) {
                serverCall('IPDPackageMaster.aspx/UpdatePackage', data, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.response, function () {
                          location.href = 'IPDPackageMaster.aspx';
                    });
                });
            });
        }

        var getPackageDetails = function (callback) {
            var PanelIDs = '';
            $.each($("input[id*='chlPanel']:checked"), function () {
                if (PanelIDs == '')
                    PanelIDs = $(this).val();
                else
                    PanelIDs = PanelIDs + ',' + $(this).val();
            });

            var packageMaster = {
                CategoryID: $('#ddlPkgCategory').val(),
                SubCategoryID: $('#ddlPkgSubCategory').val(),
                PackageID:$('#ddlIPDPackage').val(),
                PackageName: $.trim($('#txtIPDPackage').val()),
                VaidityDays:  $.trim($('#txtValidityDays').val()),
                IsActive: $('#rdbActive :checked').val(),
                PanelID: PanelIDs,
                PackageItemID:$('#SpnPackageItemID').text()
            }

            if (packageMaster.CategoryID == "0") {
                modelAlert('Please Select Package Category ', function () {
                    $('#ddlPkgCategory').focus();
                });
                return false;
            }
            if (packageMaster.SubCategoryID == "0") {
                modelAlert('Please Select Package SubCategory ', function () {
                    $('#ddlPkgSubCategory').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(packageMaster.PackageName)) {
                modelAlert('Please Enter Package Name ', function () {
                    $('#txtIPDPackage').focus();
                });
                return false;
            }
            if ($('#chlPanel :checked').length <= 0) {
                modelAlert('Please Select Any Panel', function () {
                   
                });
                return false;
            }

            packageDetails = [];
            $table = $('#tblPackage tbody tr').clone();
            $($table).each(function (index,row) {
                packageDetails.push({
                    CategoryID: $(row).find('#tdCategoryID').text().trim(),
                    SubCategoryID: $(row).find('#tdSubCategoryID').text().trim(),
                    ItemID: $(row).find('#tdItemID').text().trim(),
                    Quantity: $(row).find('#txtQty').val().trim(),
                    Amount: $(row).find('#txtAmt').val().trim(),
                    IsSurgery: $(row).find('#tdConfigID').text().trim() == '22' ? '1' : '0',
                    IsAmount: Number($(row).find('#txtQty').val()) > 0 ? '0' : '1',
                    PackageType: $(row).find('#tdPackageType').text(),
                });
            });
            callback({ packageMaster: packageMaster, packageDetails: packageDetails })
        }

    </script>
    <script type="text/javascript">
        $(function () {
            $("[id*=chkPanel]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=chlPanel] input").attr("checked", "checked");
                    $("[id*=chlPanel] input").parent().addClass('checkbox');
                } else {
                    $("[id*=chlPanel] input").removeAttr("checked");
                    $("[id*=chlPanel] input").parent().removeClass('checkbox');
                }
            });
        });
        $(function () {
            $("[id*=chlPanel]").change("click", function () {
                if ($(this).is(":checked")) {
                    $(this).parent().addClass('checkbox');
                } else {
                    $(this).parent().removeClass('checkbox');
                }
            });
        });
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>IPD Package Master</b>
            <br />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-11"></div>
                <div class="col-md-3">
                    <asp:RadioButtonList ID="rbtNewEdit" runat="server" ClientIDMode="Static" Font-Bold="True" Font-Names="Verdana" RepeatDirection="Horizontal" ToolTip="Select Add Or Edit To Update Package " onchange="checkNewoldPackage(function(){});">
                        <asp:ListItem Selected="True" Value="New">New</asp:ListItem>
                        <asp:ListItem Value="Edit">Edit</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
                <div class="col-md-10"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Package Master
            </div>
            <div class="row">
                <div class="col-md-1">
                </div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Category</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPkgCategory" title="Select IPD Package Category" onchange="bindPkgSubCategory( '14',$('#ddlPkgCategory').val(),function(){});"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">SubCategory  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPkgSubCategory" title="Select IPD Package SubCategory" onchange="bindPackageName('14',$('#ddlPkgCategory').val(),$('#ddlPkgSubCategory').val(),function(){}) "></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Package Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtIPDPackage" class="requiredField" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Validity Days  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtValidityDays" onlynumber="true" maxlength="3" title="Enter Validity Days of this package" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Active</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbActive" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow" ClientIDMode="Static" ToolTip="Select Active Or De-Active To Update Package">
                                <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Select Package </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <select id="ddlIPDPackage" title="Select IPD Package" class="requiredField hidden" onchange="bindPackageDetails();"></select>
                             <span id="SpnPackageItemID" class="hidden"></span>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkPanel" runat="server" Text="Show in Panel" CssClass="ItDoseCheckbox" ToolTip="Click to Select All Panel(This Package will show in selected Panels only)" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21 scroll" style="border: groove">
                            <asp:CheckBoxList ID="chlPanel" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" ClientIDMode="Static"
                                CssClass="ItDoseCheckboxlist">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-1">
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Add Package Items
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCategory" title="Select Category" onchange="bindAllSubCategory($('#ddlCategory').val().split('#')[0],function(){});"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sub Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlSubCategory" title="Select Sub Category" onchange="getSubCategoryDetails(function(){}); "></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearch" title="Enter Search Text" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Selected Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <span id="spnSelectedItem" class="patientInfo"></span>
                            <span id="spnSelectedItemdetails" class="hidden"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtQuantity" onlynumber="true" maxlength="3" onkeyup="clearAmount(0)" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Amount
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <input type="text" id="txtAmount" onlynumber="true" onkeyup="clearQty(0);" maxlength="7" />
                        </div>
                        <div class="col-md-1">
                            <input type="button" id="btnAdd" value="Add" onclick="getDetails()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Package Details
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div id="divOutPut" style="max-height: 170px; overflow-x: auto;">
                        <table id="tblPackage" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle textCenter" style="width: 80px;">Package Type</th>
                                    <th class="GridViewHeaderStyle textCenter" style="width: 100px;">Category</th>
                                    <th class="GridViewHeaderStyle textCenter" style="width: 100px;">SubCategory</th>
                                    <th class="GridViewHeaderStyle textCenter" style="width: 200px;">ItemName</th>
                                    <th class="GridViewHeaderStyle textCenter" style="width: 50px;">Quauntity</th>
                                    <th class="GridViewHeaderStyle textCenter" style="width: 50px;">Amount</th>
                                    <th class="GridViewHeaderStyle textCenter" style="width: 30px;">Delete</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <input type="button" id="btnSave" value="Save" title="Click to Save Package Details" onclick="save();" />
        </div>
    </div>
</asp:Content>
