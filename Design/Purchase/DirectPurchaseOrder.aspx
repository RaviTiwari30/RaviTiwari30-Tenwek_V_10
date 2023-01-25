<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectPurchaseOrder.aspx.cs" Inherits="Design_Purchase_DirectPurchaseOrder" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<%@ Register Src="~/Design/Controls/checkPassword.ascx" TagName="checkPassword" TagPrefix="cp" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    
    <script type="text/javascript">
        $(document).ready(function () {
           // AutoCompleteItemList();
            // $('#txtItemsList').val('');
            $('[id$=txtTAX1]').attr("disabled", "true");
            var rb = $('[id$=rblStoreType] input:checked').val();

            if (rb == "STO00002") {
                $('[id$=chkIsAsset]').css("display", "");
                $('[id$=lblasset]').css("display", "");
            }
            else {
                $('[id$=chkIsAsset]').css("display", "none");
                $('[id$=lblasset]').css("display", "none");
            }
            

            $('#ddlTAX0').change(function () {
                $('#<%=txtIGSTPercent.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0);
                if ($('#ddlTAX0').val() == "T4") {  // IGST
                    $('#lblGstTypee').text("IGST"); 
                    $('#<%=txtIGSTPercent.ClientID%>').attr("disabled", false);
                     $('#<%=txtCGSTPercent.ClientID%>').prop("disabled", true);
                    $('#<%=txtSGSTPercent.ClientID%>').prop("disabled", true);
                    $('#<%=txtCGSTPercent.ClientID%>').val(0);
                    $('#<%=txtSGSTPercent.ClientID%>').val(0);
                } else if ($('#ddlTAX0').val() == "T6") { // CGST&SGST
                    $('#lblGstTypee').text("CGST&SGST");
                     $('#<%=txtIGSTPercent.ClientID%>').attr("disabled", true);
                     $('#<%=txtCGSTPercent.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPercent.ClientID%>').prop("disabled", false);
                    $('#<%=txtCGSTPercent.ClientID%>').val(0);
                    $('#<%=txtSGSTPercent.ClientID%>').val(0);
                 }
                else if ($('#ddlTAX0').val() == "T7") {  // CGST&UTGST
                    $('#lblGstTypee').text("CGST&UTGST");
                     $('#<%=txtIGSTPercent.ClientID%>').attr("disabled", true);
                     $('#<%=txtCGSTPercent.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPercent.ClientID%>').prop("disabled", false);
                    $('#<%=txtCGSTPercent.ClientID%>').val(0);
                    $('#<%=txtSGSTPercent.ClientID%>').val(0)

                 }
                TaxCal();
            });

        });

        function TaxCal() {
            $('#<%=txtTAX1.ClientID %>').val(Number($('#<%=txtIGSTPercent.ClientID%>').val()) + Number($('#<%=txtCGSTPercent.ClientID%>').val()) + Number($('#<%=txtSGSTPercent.ClientID%>').val()));
         }

        function BindPurchaseUnit() { // developed by Ankit
            if ($('[id$=hfItemID]').val() == "") {
                return false;
            }
            else {
                var ItemId = $('[id$=hfItemID]').val();
                if (ItemId != "0" && ItemId != "") {
                    $.ajax({
                        type: "POST",
                        timeout: 120000,
                        async: false,
                        url: "DirectPurchaseOrder.aspx/BindPurchaseUnit",
                        data: '{ ItemId: "' + ItemId + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            var Result = JSON.parse(data.d);
                            if (Result.length > 0) {
                                $('#<%=lblPerchaseUnit.ClientID %>').text(Result[0].majorUnit);
                            }
                            else {
                                $('#<%=lblPerchaseUnit.ClientID %>').text('');
                            }
                        },
                        error: function (xhr, status) {
                            modelAlert("Error");
                        }
                    });
                }
                return false;
            }
        }

        function GetItemID() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetItemIDByItemName",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    $('[id$=hfItemID]').val(res);
                });
            }
        }

        function GetSubCatgoryID() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetSubCategory",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    $('[id$=hfSubCategoryID]').val(res);
                });
            }
        }

        function GetManufacturer() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetManufactureID",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    $('[id$=hfManufactureID]').val(res);
                });
            }
        }

        function GetHSNCode() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetHSNCode",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    $('[id$=txttHSNCode]').val(res);
                });
            }
        }

        function GetGst() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetGSTType",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                   
                    $('[id$=lblGstTypee]').text(res);
                   // $("select#elem").prop('selectedIndex', 0);

                    if (res == "IGST") {
                        $('#<%=ddlTAX0.ClientID%>').prop("selectedIndex", 2);
                    }
                    else if (res == "CGST&SGST") {
                        $('#<%=ddlTAX0.ClientID%>').prop("selectedIndex", 0);
                    }
                    else if (res == "CGST&UTGST") {
                        $('#<%=ddlTAX0.ClientID%>').prop("selectedIndex", 1);
                    }
                                              
                    if (res == "IGST") {
                        $('#<%=txtIGSTPercent.ClientID%>').attr("disabled", false);
                        $('#<%=txtCGSTPercent.ClientID%>').prop("disabled", true);
                        $('#<%=txtSGSTPercent.ClientID%>').prop("disabled", true);
                    }
                    else if (res == "CGST&SGST") {
                        $('#<%=txtIGSTPercent.ClientID%>').attr("disabled", true);
                        $('#<%=txtCGSTPercent.ClientID%>').attr("disabled", false);
                        $('#<%=txtSGSTPercent.ClientID%>').prop("disabled", false);
                    }
                    else if (res == "CGST&UTGST") {
                        $('#<%=txtIGSTPercent.ClientID%>').attr("disabled", true);
                        $('#<%=txtCGSTPercent.ClientID%>').attr("disabled", false);
                        $('#<%=txtSGSTPercent.ClientID%>').prop("disabled", false);
                    }
                });
            }
        }

        var sumof = 0;
        function GetCGST() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetCGST",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    var n = parseFloat(res);
                    
                    $('[id$=txtCGSTPercent]').val(n.toFixed(2));
                    
                    var s = parseInt($('[id$=txtTAX1]').val());
                    var totl = s + parseInt(n.toFixed(2));
                    $('[id$=txtTAX1]').val(totl);
                });
            }
        }

        function GetIGST() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetIGST",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    var n = parseFloat(res);
                    $('[id$=txtIGSTPercent]').val(n.toFixed(2));
                    
                    var s = parseInt($('[id$=txtTAX1]').val());
                  
                    var totl = s + parseInt(n.toFixed(2));
                    
                    $('[id$=txtTAX1]').val(totl);
                    
                });
            }
        }

        function GetSGST() { // developed by Ankit
            var itemName = $('[id$=lblItemName]').text();
            if (itemName != "" && itemName != null) {
                $.ajax({
                    type: "POST",
                    url: "DirectPurchaseOrder.aspx/GetSGST",
                    data: '{ itemname: "' + itemName + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    var n = parseFloat(res);
                    $('[id$=txtSGSTPercent]').val(n.toFixed(2));
                    //var s = $('[id$=txtTAX1]').val();
                    //var totl = s + n.toFixed(2);
                    //$('[id$=txtTAX1]').val(totl);
                    $('[id$=txtTAX1]').val('');
                    $('[id$=txtTAX1]').val(n.toFixed(2));
                });
            }
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $onInit();
            $('#txtSearchItem').focus();
           // BindAllManufacturer();
        });
        $onInit = function () {
            $('#txtSearchItem').autocomplete({
                source: function (request, response) {
                    if ($('[id$=rblStoreType] input:checked').val() == undefined) {
                        modelAlert('Please Select Store type', function () {
                            $('[id$=rblStoreType]').focus();
                            $('#txtSearchItem').val('');
                            return false;
                        });
                        return false;
                    }
                    else {
                        $StoreType = $('[id$=rblStoreType] input:checked').val();
                    }
                    if ($('[id$=ddlVendor] option:selected').val() == "0") {
                        modelAlert('Please Select Supplier', function () {
                            $('[id$=ddlVendor]').focus();
                            $('#txtSearchItem').val('');
                            return false;
                        });
                        return false;
                    }
                    else {
                        $VendorType = $('[id$=ddlVendor] option:selected').val().split('#')[0].toString();
                    }
                    var chkasset;   // developed by Ankit
                    //if ($("#ctl00_ContentPlaceHolder1_chkIsAsset").is(':checked'))
                    if ($("#<%=chkIsAsset.ClientID%>").is(':checked'))
                    {
                        chkasset = 1;
                    }
                    else { chkasset = 0;}
                    $bindItems({ VendorType: $VendorType, StoreType: $StoreType, PreFix: request.term, chkAsset: chkasset }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    $validateInvestigation(i, function () { });
                },
                close: function (el) {
                    el.target.value = '';
                    $('[id$=txtQuantity1]').focus();
                },
                minLength: 2
            });

        };
        $bindItems = function (data, callback) {
            serverCall('DirectPurchaseOrder.aspx/BindSearchItem', data, function (response) {        // BindItem
                var parsed_data = JSON.parse(response);
              
                if (response == "1") {
                    modelAlert('No Item Found', function () {
                        $('#txtSearchItem').val('');
                        ////ShowModalPopUp();
                        return false;
                    });
                    //ShowModalPopUp();
                    
                    return false;

                }
                else if (parsed_data == "") {
                    //ShowModalPopUp();
                }
                else {
                    var responseData = $.map(JSON.parse(response), function (item) {
                        return {
                            label: item.Typename,
                            val: item.ItemID
                        }
                    });
                }
               
                callback(responseData);
            });
        };
        $validateInvestigation = function (ctr, callback) {
            if (ctr.item.val.trim() != "") {
                $('#lblItemName').text(ctr.item.label);
                $('#lblItemName').val(ctr.item.val);
                LoadDetail();
            }
        };
        function Clear() {
            $('#lblItemName').text('');
            $('#lblItemName').val('');
            $("#<%=lblTaxCalculatedOn.ClientID%>").text('');
            $("#<%=lblMajorUnit.ClientID%>").text('');
            $("#<%=txtRate1.ClientID%>").text('');
            $("#<%=lblConFactor.ClientID%>").text('');
            $("#<%=txtDiscount1.ClientID%>").val('');
            $("#<%=txtVATPer.ClientID%>").val('');
            $("#<%=txtExcisePer.ClientID%>").val('');
            $("#<%=lblMsg.ClientID%>").val('');
            $("#<%=txtHSNCode.ClientID%>").text('');
            $("#<%=txtIGSTPer.ClientID%>").val('');
            //$('[id$=ddlVendor] option:selected').attr("selected", null);

            //   BindSubcategory();
            var va = $('[id$=rblStoreType] input:checked').val();
         
            if (va == "STO00002") {
                $('[id$=chkIsAsset]').css("display", "");
                $('[id$=lblasset]').css("display", "");
            }
            else {
                $('[id$=chkIsAsset]').css("display", "none");
                $('[id$=lblasset]').css("display", "none");
            }

            return false;
        }
      
        function UpdateItem() {
            var Id = $('[id$=lblRowIndex]').val();
            DeleteRecord(Id)
            SaveItemDetail();
            return false;
        }
        function SaveItems() {
            var Validate = validateQty();
            if (Validate == true) {
                $('[id$=lblMsg]').text('');
                if ($('[id$=btnSaveItem]').val() == 'Update') {
                    UpdateItem();
                    $('[id$=btnSaveItem]').val('Add');
                    return false;
                }
                else {
                    SaveItemDetail();
                    return false;
                }
            }
        }
        function SaveItemDetail() {
            $("#ctl00_ContentPlaceHolder1_chkIsAsset").attr("disabled", "true");
            var ItemId = $('[id$=lblItemName]').val().split('#')[0];
            var SubCategoryID = $('[id$=lblItemName]').val().split('#')[1];
            var ItemName = $('[id$=lblItemName]').text();
            var VendorId = $('[id$=ddlVendor]').val();
            var VendorName = $('[id$=ddlVendor] option:selected').text();
            var GstType = $('[id$=ddlGST] option:selected').text();
            var TaxCalOn = $('[id$=lblTaxCalculatedOn]').text();
            var Free = $('[id$=rbtnFree] input:checked').val();
            var Quantity = $('[id$=txtQuantity1]').val();
            var Discount = $('[id$=txtDiscount1]').val();
            var Rate1 = $('[id$=txtRate1]').text();
            var Igst = $('[id$=txtIGSTPer]').val();
            var Cgst = $('[id$=txtCGSTPer]').val();
            var Sgst = $('[id$=txtSGSTPer]').val();
            var HsnCode = $('[id$=txtHSNCode]').text();
            var Tax = $('[id$=ddlTax1] option:selected').text();
            var Confactor = $('[id$=lblConFactor]').text();
            var Deal1 = $('[id$=txtDeal1]').val();
            var Deal2 = $('[id$=txtDeal2]').val();
            var data = {
                ItemId: ItemId,
                SubCategoryID: SubCategoryID,
                ItemName: ItemName,
                VendorId: VendorId,
                VendorName: VendorName,
                GstType: GstType,
                TaxCalOn: TaxCalOn,
                Free: Free,
                Quantity: Quantity,
                Discount: Discount,
                Rate1: Rate1,
                Igst: Igst,
                Cgst: Cgst,
                Sgst: Sgst,
                HsnCode: HsnCode,
                Tax: Tax,
                Confactor: Confactor,
                Deal1:Deal1,
                Deal2:Deal2
            }
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "DirectPurchaseOrder.aspx/SaveItems",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d != "") {
                        ItemDetails = JSON.parse(data.d);
                        if (ItemDetails.length > 0) {
                            var output = $('#tb_ItemDetails').parseTemplate(ItemDetails);
                            if (output != "" && output != null) {
                                $('#DivItemDetails').html(output).customFixedHeader();
                                $('[id$=DivItemDetails]').css('display', 'block');
                                Clear();
                                $('[id$=ddlVendor]').prop('disabled', true);
                                $('[id$=rbtnFree] option:selected').val('0');
                                $('[id$=txtQuantity1]').val('');
                                $('[id$=BtnSave]').prop('disabled', false);
                                $("*[name$='rblStoreType']").attr("disabled", "disabled");
                                $('#txtSearchItem').focus();
                            }
                            else {
                                $('#DivItemDetails').html('');
                                $('[id$=DivItemDetails]').css('display', 'none');
                            }
                        }
                        else {
                            $('#DivItemDetails').html('');
                            $('#<%=lblMsg.ClientID %>').text('');
                            $('[id$=BtnSave]').prop('disabled', true);
                            $('[id$=DivItemDetails]').css('display', 'none');
                        }
                    }
                    else {

                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function EnterKeyExecute(sender, e) {
            if ($('[id$=txtQuantity1]').val() != null && $('[id$=txtQuantity1]').val() != "0" && $('[id$=txtQuantity1]').val() != "") {
                if (e.keyCode === 13) {
                    $("#btnSaveItem").click();
                }
            }
            else {
                $('[id$=txtQuantity1]').val('');
                return false;
            }
        }
        function DeleteRecord(Id) {
           
            var RowId = Id - 1;
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "DirectPurchaseOrder.aspx/DeleteRow",
                data: '{ RowId: "' + RowId + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d == "") {
                        $('#DivItemDetails').html('');
                        $('[id$=BtnSave]').prop('disabled', true);
                        $('[id$=ddlVendor]').prop('disabled', false);
                        $("*[name$='rblStoreType']").attr("disabled", false);
                        $('[id$=DivItemDetails]').css('display', 'none');
                        $('[id$=lblMsg]').text('');
                        var len = $("#tableitemdetails tr").length;
                        if (len == 0) {
                            $("#<%=chkIsAsset.ClientID%>").removeAttr("disabled");
                        }
                       // alert("len = " + len);
                    }
                    else {
                        ItemDetails = JSON.parse(data.d);
                        if (ItemDetails.length > 0) {
                            var output = $('#tb_ItemDetails').parseTemplate(ItemDetails);
                            if (output != "" && output != null) {
                                $('#DivItemDetails').html(output).customFixedHeader();
                                $('[id$=btnSavePO]').prop('disabled', false);
                                $('[id$=ddlVendor]').prop('disabled', false);
                                $('[id$=DivItemDetails]').css('display', '');
                                $('[id$=BtnSave]').prop('disabled', false);
                            }
                            else {
                                $('#DivItemDetails').html('');
                                $('[id$=DivItemDetails]').css('display', 'none');
                                $('[id$=BtnSave]').prop('disabled', true);
                            }
                        }
                        else {
                            $('#DivItemDetails').html('');
                            $('[id$=BtnSave]').prop('disabled', true);
                            $('[id$=DivItemDetails]').css('display', 'none');
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function RemoveRow(ctr) {
            $('[id$=lblMsg]').text('');
            modelConfirmation('Item Delete Confirmation ?', 'Are you sure want to delete this Item!', 'Yes', 'Cancel', function (response) {
                if (response == true) {
                    var RowId = $(ctr).closest('tr').find('[id$=tdIndex]').text();
                    
                    DeleteRecord(RowId);
                    return false;
                }
                else
                    return false;
            });
            return false;
        };
        function EditRow(ctr) {
          //  $("#<%=chkIsAsset.ClientID%>").removeAttr("disabled");
            var RowId = $(ctr).closest('tr').find('[id$=tdIndex]').text().trim();
            $('[id$=lblRowIndex]').val(RowId);
            var ItemID = $(ctr).closest('tr').find('[id$=tdItemID]').text();
            var VendorId = $(ctr).closest('tr').find('[id$=tdVendorID]').text();
            var ItemName = $(ctr).closest('tr').find('[id$=tdItemname]').text();
            var OrderQty = $(ctr).closest('tr').find('[id$=tdorderqty]').text();
            var SubCat = $(ctr).closest('tr').find('[id$=tdSubCat]').text();
            var IsFree = $(ctr).closest('tr').find('[id$=tdIsfree]').text().trim();
            if (IsFree == "Yes") {
                $("input[name='ctl00$ContentPlaceHolder1$rbtnFree'][value='1']").prop('checked', true);
            }
            else {
                $("input[name='ctl00$ContentPlaceHolder1$rbtnFree'][value='0']").prop('checked', true);
            }
            $('[id$=lblItemName]').val('' + ItemID + '#' + SubCat + '');
            $('[id$=lblItemName]').text(ItemName);
            $('[id$=ddlVendor]').prop('disabled', false);
            $('[id$=ddlVendor] option:selected').val(VendorId);
            //$('[id$=lblConFactor]').text($(ctr).closest('tr').find('[id$=lblConfact]').text());
            $('#txtQuantity1').val(OrderQty);
            $('[id$=btnSaveItem]').val('Update');
            EditDetail(ItemID, VendorId);
            return false;
        }

        function EditDetail(ItemID, VendorId) {
            var ItemID = ItemID;
            var VendorID = VendorId;
            var DeptLedgerNo = '<%=ViewState["DeptLedgerNo"].ToString()%>'
            $.ajax({
                url: "../Store/WebServices/StockStatusRpt.asmx/BindListAmtInfo",
                data: '{ ItemID:"' + ItemID + '",VendorID:"' + VendorID + '",DeptLedgerNo:"' + DeptLedgerNo + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var InvData = (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d;
                    if (InvData.length != 0) {
                        $('#<%=txtRate1.ClientID %>').text(InvData[0].Rate);
                        $('#<%=txtDiscount1.ClientID %>').val(InvData[0].DiscPer).attr('readonly', 'readonly');
                        $('#<%=txtVATPer.ClientID %>').val(InvData[0].VATPer).attr('readonly', 'readonly');
                        $('#<%=lblTaxID.ClientID %>').val(InvData[0].TaxID);
                        $('#<%=lblConFactor.ClientID %>').text(InvData[0].ConFactor);
                        //$('#<%=lblMajorUnit.ClientID %>').val(InvData[0].MajorUnit).attr('readonly', 'readonly');
                        $('#<%=lblMajorUnit.ClientID %>').text(InvData[0].MajorUnit);
                        $('#<%=lblMinorUnit.ClientID %>').val(InvData[0].MinorUnit).attr('readonly', 'readonly');
                        $('#<%=txtExcisePer.ClientID %>').val(InvData[0].ExcisePer).attr('readonly', 'readonly');
                        $('#<%=lblTaxCalculatedOn.ClientID %>').text(InvData[0].TaxCalulatedOn);

                        $('#<%=txtIGSTPer.ClientID %>').val(InvData[0].IGSTPercent).attr('readonly', 'readonly');
                        $('#<%=txtCGSTPer.ClientID %>').val(InvData[0].CGSTPercent).attr('readonly', 'readonly');
                        $('#<%=txtSGSTPer.ClientID %>').val(InvData[0].SGSTPercent).attr('readonly', 'readonly');
                        $("#ddlGST option:contains(" + InvData[0].GSTType + ")").attr('selected', 'selected');
                        $('#<%=txtHSNCode.ClientID %>').text(InvData[0].HSNCode);
                        $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType).attr('readonly', 'readonly');
                        if (InvData[0].GSTType == "IGST") {
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                        } else if (InvData[0].GSTType == "CGST&SGST") {
                            $('#<%=txtIGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                        } else if (InvData[0].GSTType == "CGST&UTGST") {
                            $('#<%=txtIGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                        } else {
                            $("#ddlGST option:contains('IGST')").attr('selected', 'selected');
                            $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text('IGST');
                            $('#<%=txtHSNCode.ClientID %>').text('');
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                        }
            }
            else {
                $('#<%=txtRate1.ClientID %>,#<%=txtDiscount1.ClientID %>,#<%=txtVATPer.ClientID %>,#<%=txtExcisePer.ClientID %>,#<%=lblTaxID.ClientID %>,#<%=lblConFactor.ClientID %>,#<%=lblMajorUnit.ClientID %>,#<%=lblMinorUnit.ClientID %>,#<%=lblTaxCalculatedOn.ClientID %>').val('');
                        $("#ddlGST option:contains('IGST')").attr('selected', 'selected');
                        $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text('IGST');
                        $('#<%=txtHSNCode.ClientID %>').text('');
                        $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                        $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function SavePO() {
            $('[id$=lblMsg]').val('');
            if ($('[id$=txtExciseOnBill]').val() != undefined)
                var txtExciseOnBill = $('[id$=txtExciseOnBill]').val();
            else
                var txtExciseOnBill = "";
            if ($('[id$=txtFreight]').val() != undefined)
                var txtFreight = $('[id$=txtFreight]').val();
            else
                var txtFreight = "";
            if ($('[id$=txtRoundOff]').val() != undefined)
                var txtRoundOff = $('[id$=txtRoundOff]').val();
            else
                var txtRoundOff = "";
            if ($('[id$=txtScheme]').val() != undefined)
                var txtScheme = $('[id$=txtScheme]').val();
            else
                var txtScheme = "";
            var chkasset;   // developed by Ankit
            if ($("#<%=chkIsAsset.ClientID%>").is(':checked')) {
                chkasset = 1;
            }
            else { chkasset = 0; }
            var data = {
                txtNarration: $('[id$=txtNarration]').val(),
                txtRemarks: $('[id$=txtRemarks]').val(),
                txtPODate: $('[id$=txtPODate]').val(),
                txtValidDate: $('[id$=txtValidDate]').val(),
                txtDeliveryDate: $('[id$=txtDeliveryDate]').val(),
                txtFreight: txtFreight,
                txtRoundOff: txtRoundOff,
                txtScheme: txtScheme,
                txtExciseOnBill: txtExciseOnBill,
                ddlPOType: $('[id$=ddlPOType] option:selected').text(),
                rblStoreType: $('[id$=rblStoreType] input:checked').val(),
                ChkAsset: chkasset
            }
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "DirectPurchaseOrder.aspx/SaveAllItems",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d != null && data.d != "") {
                        if (data.d == "1" || data.d == "2") {
                            $('[id$=lblMsg]').text('Please Add Item');
                            $('[id$=ddlVendor]').focus();
                            $('[id$=DivItemDetails]').css('display', 'none');
                            $('[id$=BtnSave]').prop('disabled', true);
                            $('[id$=ddlVendor]').prop('disabled', false);
                            $("*[name$='rblStoreType']").attr("disabled", false);
                            return false;
                        }
                        if (data.d == "3") {
                            $('[id$=lblMsg]').text('Error occurred, Please contact administrator');
                            $('[id$=DivItemDetails]').css('display', 'none');
                            $('[id$=BtnSave]').prop('disabled', true);
                            $('[id$=ddlVendor]').prop('disabled', false);
                            $("*[name$='rblStoreType']").attr("disabled", false);
                            return false;
                        }
                        else if (data.d != null && data.d != "") {
                            var HSPoNumber = data.d;
                            modelAlert('PurchaseOrder No. : ' + HSPoNumber + '', function () {
                                if ($('#<%=chkPrintImg.ClientID %>').is(':checked') == true) {
                                    var ImagesToprint = 1;
                                    window.open('POReport.aspx?PONumber=' + HSPoNumber + "&ImageToPrint=" + ImagesToprint + '')
                                    location.reload(true);
                                    Clear();
                                }
                                else {
                                }
                                $('[id$=BtnSave]').prop('disabled', true);
                                $('[id$=ddlVendor]').prop('disabled', false);
                                $("*[name$='rblStoreType']").attr("disabled", false);
                                $('[id$=DivItemDetails]').css('display', 'none');
                                return false;
                            });
                        }
                        else {
                            $('[id$=BtnSave]').prop('disabled', true);
                            $('[id$=ddlVendor]').prop('disabled', false);
                            $("*[name$='rblStoreType']").attr("disabled", false);
                            $('[id$=DivItemDetails]').css('display', 'none');
                            return false;
                        }
                }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function BindAllManufacturer() {   // developed by Ankit
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "DirectPurchaseOrder.aspx/BindManufacturer",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d == "") {
                        $('[id$=ddlManufacturer]').html('');
                        $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val('0').html(" "));
                        $('[id$=ddlManufacturer]').trigger('chosen:updated');
                    }
                    else {
                        $('[id$=ddlManufacturer]').html('');
                        $('[id$=ddlManufacturer]').trigger('chosen:updated');
                        $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val("0").html("Select"));
                        Subcat = jQuery.parseJSON(data.d);
                        if (Subcat.length == 0) {
                            $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            for (i = 0; i < Subcat.length; i++) {
                                $('[id$=ddlManufacturer]').append(jQuery("<option></option>").val(Subcat[i].ManufactureID).html(Subcat[i].Name));
                            }
                            //$('[id$=ddlManufacturer]').chosen();
                            //$('[id$=ddlManufacturer]').trigger('chosen:updated');
                        }
                    }
                },
                error: function (xhr, status) {
                    modelAlert("Error ");
                    $('[id$=ddlManufacturer]').attr("disabled", false);
                }
            });

            return false;

        }

        function BindSubcategory() {   // developed by Ankit
            var c = $('[id$=rblStoreType] input:checked').parent().text();
            var id;
            if (c == "Medical") {
                id = "LSHHI5";
            }
            else if (c == "General") {
                id = "LSHHI8";
            }
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "DirectPurchaseOrder.aspx/BindAllSubcategory",
                data: '{ Category: "' + id + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    Subcat = jQuery.parseJSON(data.d);
                    if (Subcat != null) {
                        if (Subcat.length == 0) {
                            $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            $('[id$=ddlSubCategory]').html('');
                            $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val("All").html("ALL"));
                            for (i = 0; i < Subcat.length; i++) {
                                $('[id$=ddlSubCategory]').append(jQuery("<option></option>").val(Subcat[i].SubCategoryID).html(Subcat[i].Name));
                            }
                            //$('[id$=ddlSubCategory]').chosen();
                            //$('[id$=ddlSubCategory]').trigger('chosen:updated');
                        }
                    }
                },
                error: function (xhr, status) {
                    modelAlert("Error ");
                    $('[id$=ddlSubCategory]').attr("disabled", false);
                }
            });
        }

        function BindItemOnSubcategory() {
            //BindItem();
        }

        function SaveProduct() {   // developed by Ankit

            var strItem = $('[id$=lblItemsList]').text();
           // var ItemID = strItem.split('#')[0];
            var ItemID = $('[id$=hfItemID]').val();
          //  var ItemID = ItmID.split('#')[0];
            
            //var DeptLedgerNo = '<%=ViewState["DeptLedgerNo"].ToString()%>'

            var UcFromDate = $('[id$=ucFromDate]').val();
            var UcToDate = $('[id$=ucToDate]').val();
            var Category = $('[id$=rblStoreType] input:checked').val();
            var VendorId = $('[id$=ddlVendor]').val();
            var VID = VendorId.split('#')[0];
            var VendorName = $('[id$=ddlVendor] option:selected ').text();
            var Subcategory = $('[id$=hfSubCategoryID]').val();                                  //$('[id$=ddlSubCategory] option:selected').val();

            var rate = $('#<%=txtRate.ClientID %>').val();
            var Tax = $('#<%=ddlTAX0.ClientID %> option:selected').text();
            var taxval = $('#<%=ddlTAX0.ClientID %>').val();
            var IGST = $('#<%=txtIGSTPercent.ClientID %>').val();
            var CGST = $('#<%=txtCGSTPercent.ClientID %>').val();
            var SGCT = $('#<%=txtSGSTPercent.ClientID %>').val();
            var DiscountPercent = $('#<%=txtDiscPer.ClientID %>').val();
            if (DiscountPercent == "") {
                DiscountPercent = "0";
            }
            var DiscAmt = $('#<%=txtDiscAmt.ClientID %>').val();
            if (DiscAmt == "") {
                DiscAmt = "0";
            }
            var Deal1 = $('#<%=txtDeel1.ClientID %>').val();
            var Deal2 = $('#<%=txtDeel2.ClientID %>').val();
            var rblTaxCal = $('[id$=rblTaxCal] input:checked').val();
            var chkIsActive = "";
            if ($('#<%=chkIsActive.ClientID %>').is(':checked') == true) {
                chkIsActive = "true";
            }
            else
                chkIsActive = "false";

            var MRP = $('#<%=txtMRP.ClientID %>').val();
            var txtHSNCode = $('#<%=txttHSNCode.ClientID %>').val();
            var txtRemarks = $('#<%=txtRemrks.ClientID %>').val();
            var Manufacturer_ID = $('[id$=hfManufactureID]').val();                       //$('[id$=ddlManufacturer] option:selected').val();
            //var Manufacturer = $('[id$=ddlManufacturer] option:selected').text();
            //if (Manufacturer == "Select") {
            //    Manufacturer = "";
            //}

            var data = {
                ItemId: ItemID,
                UcFromDate: UcFromDate,
                UcTodate: UcToDate,
                Subcategory: Subcategory,
                VendorId: VID,
                VendorName: VendorName,
                ItemName: strItem,
                rate: rate,
                Tax: Tax,
                IGST: IGST,
                CGST: CGST,
                SGST: SGCT,
                DiscountPercent: DiscountPercent,
                DiscAmt: DiscAmt,
                Deal1: Deal1,
                Deal2: Deal2,
                rblTaxCal: rblTaxCal,
                chkIsActive: chkIsActive,
                MRP: MRP,
                txtHSNCode: txtHSNCode,
                txtRemarks: txtRemarks,
                Manufacturer_ID: Manufacturer_ID,
                CategoryId: Category
            }

            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "DirectPurchaseOrder.aspx/SaveProduct",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
            }).done(function (r) {
                var unit = $('#<%=lblPerchaseUnit.ClientID %>').text();
                $('[id$=lblMajorUnit]').text(unit);
                $('[id$=lblTaxCalculatedOn]').text(rblTaxCal);
                
                $('[id$=lblItemName]').text(strItem);
                $('[id$=txtSearchItem]').val('');
               // LoadDetail();

                CloseModal();
                //alert("Saved");
                
                $.ajax({
                    url: "DirectPurchaseOrder.aspx/GetLastNetAmt",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                }).done(function (data) {
                    var res = JSON.parse(data.d);
                    $('[id$=txtRate1]').text(res);
                });

                $.ajax({
                    url: "DirectPurchaseOrder.aspx/GetConverFactor",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json"
                }).done(function (result) {
                    var r = JSON.parse(result.d);
                    $('[id$=lblConFactor]').text(r);
                });

               // $('[id$=lblHsnCode]').text(txtHSNCode);
                $('[id$=txtHSNCode]').text(txtHSNCode);

                if (Tax == "IGST") {
                    $('#<%=ddlGST.ClientID%>').prop("selectedIndex", 2);
                }
                else if (Tax == "CGST&SGST") {
                $('#<%=ddlGST.ClientID%>').prop("selectedIndex", 0);
                }
                else if (Tax == "CGST&UTGST") {
                    $('#<%=ddlGST.ClientID%>').prop("selectedIndex", 1);
                }

                $('[id$=lblGSTType]').text(Tax);
                $('[id$=txtIGSTPer]').val(IGST);
                $('[id$=txtCGSTPer]').val(CGST);
                $('[id$=txtSGSTPer]').val(SGCT);
                $('[id$=txtDeal1]').val(Deal1);
                $('[id$=txtDeal2]').val(Deal2);

                if (taxval == "T4") {  // IGST
                   
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtCGSTPer.ClientID%>').prop("disabled", true);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                } else if (taxval == "T6") { // CGST&SGST
                   
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }
                else if (taxval == "T7") {  // CGST&UTGST
                    
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }

            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    
    <div id="Pbody_box_inventory">
        <asp:Label ID="lblRowIndex" runat="server" style="display:none;"></asp:Label>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Generate Purchase Order (By Supplier)</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" meta:resourcekey="lblMsgResource1" />
        </div>
        <div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Item & Supplier Detail&nbsp;
                </div>
                <%--<cp:checkPassword ID="check" runat="server" />--%>
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
                            <div class="col-md-3">
                                <asp:RadioButtonList runat="server" ID="rblStoreType" TabIndex="1" onchange="return Clear();"
                                      RepeatDirection="Horizontal" CssClass="rbButtonList">
                                    <asp:ListItem Value="STO00001" Text="Medical">Med.</asp:ListItem>
                                    <asp:ListItem Value="STO00002" Text="General">Gen.</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-2" style="font-weight:bold;color:red;" runat="server">
                                <asp:CheckBox ID="chkIsAsset" runat="server" OnCheckedChanged="chkIsAsset_CheckedChanged" AutoPostBack="true" />
                                <label class="" id="lblasset" runat="server">
                                    IsAsset
                                </label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Supplier
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlVendor" runat="server" TabIndex="2"  meta:resourcekey="ddlVendorResource1">
                                </asp:DropDownList>
                            </div>
                                                      <div class="col-md-3">
                                <label class="pull-left">
                                    HSN Code
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3" style="text-align:left">
                                <asp:label ID="txtHSNCode" runat="server" Width="" CssClass="ItDoseTextinputNum" Text="" ClientIDMode="Static"></asp:label>
                                <asp:label ID="lblHsnCode" runat="server"></asp:label>
                            </div>
                             
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Search Item
                                  <%-- <span id="" onclick="ShowModalPopUp()">Open Modal</span>--%>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtSearchItem" title="Enter Search text" />
                                <asp:TextBox ID="txtSearch" Visible="false" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                                    onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                    onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                    Width="" meta:resourcekey="txtSearchResource1"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Item Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left">
                                <label id="lblItemName"></label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Purchase Unit
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3" style="text-align:left">
                                <asp:Label ID="lblMajorUnit" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Quantity
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtQuantity1" CssClass="requiredField" ClientIDMode="Static" onkeyup="EnterKeyExecute(this,event);" runat="server" Width="" meta:resourcekey="txtQuantity1Resource1"></asp:TextBox>
                                <span style="color: red; font-size: 10px;"></span>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtQuantity1"
                                    FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-5" style="display: none">
                                <asp:ListBox ID="ListBox1" Visible="false" runat="server" CssClass="ItDoseDropdownbox" Height="90px"
                                    Width="" Style="margin-top: 0px;" meta:resourcekey="ListBox1Resource1" onChange="LoadDetail();"></asp:ListBox>
                            </div>
                              <div class="col-md-3">
                                <label class="pull-left">
                                    Discount(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDiscount1" runat="server" Width="" onKeyDown="preventBackspace();"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtDiscount1"
                                    FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Unit Price
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left">
                                <asp:label ID="txtRate1" ClientIDMode="Static" runat="server" Width="" onKeyDown="preventBackspace();"></asp:label>
                              <%--  <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtRate1"
                                    FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>--%>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    GST Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left">
                                <asp:DropDownList ID="ddlGST" Style="margin-top: 0px;" CssClass="ItDoseDropdownbox" Width="116px" runat="server" ClientIDMode="Static"></asp:DropDownList>
                                  <asp:Label ID="lblGSTType" runat="server" Style="color: red; font-weight: bold;" Text="" ClientIDMode="Static"></asp:Label>
                            </div>
                             <div class="col-md-3">
                                <label class="pull-left">
                                    IGST(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIGSTPer" runat="server" style="text-align:left" CssClass="ItDoseTextinputNum" Width="" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Conversion Factor
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <asp:label ID="lblConFactor" runat="server" TabIndex="3" Text=""></asp:label>
                            </div>
                        </div>
                        <div class="row">
                              <div class="col-md-3">
                                <label class="pull-left">
                                    CGST(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtCGSTPer" runat="server" style="text-align:left" CssClass="ItDoseTextinputNum" Width="" ClientIDMode="Static"></asp:TextBox>
                            </div>
                               <div class="col-md-3">
                                <label class="pull-left">
                                    SGST(%)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtSGSTPer" runat="server" style="text-align:left" CssClass="ItDoseTextinputNum" Width="" ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Tax Calculated On 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="text-align:left;">
                                <asp:label ID="lblTaxCalculatedOn" runat="server" Width="" onKeyDown="preventBackspace();"></asp:label>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="lblTaxID" runat="server" Style="display: none;"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Deal
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtDeal1" ClientIDMode="Static" runat="server" Width="105px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                                <asp:Label ID="Label1" runat="server" Text="+ " Width="5px" CssClass="ItDoseLabelSp"></asp:Label>
                                <asp:TextBox ID="txtDeal2" ClientIDMode="Static" runat="server" Width="105px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>

                                </div>
                             <div class="col-md-3">
                                <label class="pull-left">
                                    Free
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:RadioButtonList ID="rbtnFree" runat="server"  RepeatDirection="Horizontal">
                                    <asp:ListItem Text="Yes"  Value="1"></asp:ListItem>
                                    <asp:ListItem Text="No" Selected="True" Value="0"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                         
                        </div>
                        <div class="row" style="text-align: center;">
                            <input type="button" id="btnSaveItem" value="Add" onclick="return SaveItems();" />
                            <asp:Button ID="btnSaveItems" runat="server" Visible="false" CssClass="ItDoseButton" OnClientClick="return validateQty()"
                                Text="Add" meta:resourcekey="btnSaveItemsResource1" OnClick="btnSaveItems_Click" />
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table style="width: 100%">
                    <tr style="display: none;">
                        <td style="width: 100px; text-align: right">Sale Tax(%)&nbsp:&nbsp;
                        </td>
                        <td style="width: 100px; text-align: left">
                            <asp:DropDownList ID="ddlTax1" runat="server" Width="91px" meta:resourcekey="ddlTAX1Resource1">
                                <asp:ListItem>0</asp:ListItem>
                                <asp:ListItem>5.25</asp:ListItem>
                                <asp:ListItem>13.125</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right">Sale Unit :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="lblMinorUnit" runat="server" Text="" Width="80px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr style="display: none">
                        <td style="text-align: right">VAT(%) :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtVATPer" onkeypress="return checkForSecondDecimal(this,event)" runat="server" Width="80px" onKeyDown="preventBackspace();"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtVATPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: right">Excise(%) :&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtExcisePer" onkeypress="return checkForSecondDecimal(this,event)" runat="server" Width="80px" onKeyDown="preventBackspace();"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtExcisePer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Selected Item Detail
                </div>
                 <div id="DivItemDetails" style="height: 200px; width: 100%; overflow-y: scroll;display:none;">
                 </div>
                <table style="width: 100%; border-collapse: collapse;display:none;" >
                    <tr>
                        <td>
                            <asp:GridView ID="gvPODetails" Visible="false" DataKeyNames="ItemID" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowDeleting="gvPODetails_RowDeleting1" meta:resourcekey="gvPODetailsResource1" Width="100%">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField HeaderText="S.No." meta:resourcekey="TemplateFieldResource1">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Supplier Name" meta:resourcekey="TemplateFieldResource1">
                                        <ItemTemplate>
                                            <%# Eval("VendorName") %>
                                        </ItemTemplate>
                                        <HeaderStyle Width="175px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Name" meta:resourcekey="TemplateFieldResource1">
                                        <ItemTemplate>
                                            <%# Eval("ItemName") %>
                                        </ItemTemplate>
                                        <HeaderStyle Width="200px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Avl Qty." meta:resourcekey="TemplateFieldResource8">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInhandQty" runat="server" Text='<%# Eval("InHand Qty") %>' CssClass="ItDoseTextinputNum"
                                                meta:resourcekey="lblInhandQtyResource1" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Order Qty." meta:resourcekey="TemplateFieldResource8">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRecQty" runat="server" Text='<%# Eval("Order Qty") %>' CssClass="ItDoseTextinputNum"
                                                meta:resourcekey="lblRecQtyResource1" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Unit" meta:resourcekey="TemplateFieldResource2">
                                        <ItemTemplate>
                                            <asp:Label ID="lblunit" runat="server" Text='<%# Eval("Unit") %>' meta:resourcekey="lblunitResource1" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Free">
                                        <ItemTemplate>

                                            <asp:Label ID="lblFree" Visible="false" runat="server" Text='<%# Eval("Free") %>' />
                                            <asp:Label ID="lblFreeDisplay" runat="server" Text='<%# Util.GetInt(Eval("Free"))==1 ? "Yes":"No" %>' />

                                        </ItemTemplate>
                                        <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Unit Price" meta:resourcekey="TemplateFieldResource3">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate") %>' meta:resourcekey="lblRateResource1" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Disc." meta:resourcekey="TemplateFieldResource5">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("DiscPer") %>' meta:resourcekey="lblDiscountResource1" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="GST Type" meta:resourcekey="TemplateFieldResource5">
                                        <ItemTemplate>
                                            <asp:Label ID="lblGST_Type" runat="server" Text='<%# Eval("GSTType") %>' />
                                            <asp:Label ID="lblHSN_Code" runat="server" Text='<%# Eval("HSNCode") %>' Visible="false" />
                                            <asp:Label ID="lblIGSTPer" runat="server" Text='<%# Eval("GSTType") %>' Visible="false" />
                                            <asp:Label ID="lblCGSTPer" runat="server" Text='<%# Eval("CGSTPercent") %>' Visible="false" />
                                            <asp:Label ID="lblSGSTPer" runat="server" Text='<%# Eval("SGSTPercent") %>' Visible="false" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="GST(%)" meta:resourcekey="TemplateFieldResource5">
                                        <ItemTemplate>
                                            <asp:Label ID="lblGSTPer" runat="server" Text='<%# Eval("GSTPer") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Unit Cost" meta:resourcekey="TemplateFieldResource8">
                                        <ItemTemplate>
                                            <asp:Label ID="lblBuyPrice" runat="server" Text='<%# Eval("BuyPrice") %>' CssClass="ItDoseTextinputNum"
                                                meta:resourcekey="lblNetAmtResource1" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="70px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Cost" meta:resourcekey="TemplateFieldResource8">
                                        <ItemTemplate>
                                            <asp:Label ID="lblNetAmt" runat="server" Text='<%# Eval("NetAmt") %>' CssClass="ItDoseTextinputNum"
                                                meta:resourcekey="lblNetAmtResource1" HorizontalAlign="Center" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="70px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Manufacturer" meta:resourcekey="TemplateFieldResource8" Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblManufacturer" runat="server" Text='<%# Eval("Manufacturer") %>' CssClass="ItDoseTextinputNum"
                                                meta:resourcekey="lblManufacturerResource1" />
                                        </ItemTemplate>
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:CommandField ShowDeleteButton="True" DeleteImageUrl="~/Images/Delete.gif" HeaderText="Delete"
                                        meta:resourcekey="CommandFieldResource1" ButtonType="Image">
                                        <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                    </asp:CommandField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Purchase Order Information
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PO Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPODate" runat="server" ClientIDMode="Static"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtPODate">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Valid Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtValidDate" runat="server" ClientIDMode="Static"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtValidDate">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlPOType" runat="server" OnSelectedIndexChanged="ddlPOType_SelectedIndexChanged" Width="" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Delivery Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDeliveryDate" runat="server" ClientIDMode="Static"
                                    Width=""></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtDeliveryDate">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Remarks
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtRemarks" runat="server" Width="" CssClass="ItDoseTextinputText" MaxLength="200" TextMode="MultiLine" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr style="display: none;">
                        <td style="width: 12%; text-align: right;">Bill Amount :&nbsp;   </td>
                        <td style="width: 4%; text-align: left;">
                            <asp:TextBox ID="txtInvoiceAmount" runat="server" Width="80px" CssClass="ItDoseTextinputNum"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtInvoiceAmount" FilterType="Custom, Numbers" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 12%; text-align: right; display: none">Currency :&nbsp;</td>
                        <td style="text-align: left; display: none" colspan="3">
                            <asp:DropDownList ID="ddlCurrency" runat="server" Width="86px" />

                            <asp:Label ID="lblCurreny_Amount" runat="server" ClientIDMode="Static"
                                Style="color: #0000CC; font-weight: 700; background-color: #CCFF33; display: none"></asp:Label>
                            <asp:TextBox ID="lblCurrencyNotation" runat="server" Style="display: none;"></asp:TextBox>
                            <asp:TextBox ID="txtCurreny_Amount" Style="display: none" ClientIDMode="Static" runat="server"></asp:TextBox>
                        </td>
                        <td style="width: 15%; text-align: right;">
                            <div style="display: none">
                                <asp:TextBox ID="lbl" runat="server" meta:resourcekey="lblResource1"></asp:TextBox>
                            </div>
                            :  
                        </td>
                        <td style="text-align: left;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 15%; text-align: right;"></td>
                        <td style="text-align: left; vertical-align: top; display: none;" colspan="2" rowspan="2">
                            <asp:TextBox ID="txtNarration" runat="server" Width="258px" TextMode="MultiLine" MaxLength="200"
                                CssClass="ItDoseTextinputText" ValidationGroup="Save" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 12%; text-align: right;">&nbsp;</td>
                        <td colspan="7">
                            <asp:TextBox ID="txtFreight" runat="server" Width="80px" CssClass="ItDoseTextinputNum" Visible="False" />
                            &nbsp;<asp:TextBox ID="txtRoundOff" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                                Width="80px" Visible="False"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                TargetControlID="txtRoundOff" FilterType="Custom, Numbers" ValidChars=".-">
                            </cc1:FilteredTextBoxExtender>
                            &nbsp;<asp:TextBox ID="txtScheme" runat="server" CssClass="ItDoseTextinputNum" Text="0" Width="80px" Visible="False"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                                TargetControlID="txtScheme" FilterType="Custom, Numbers" ValidChars=".">
                            </cc1:FilteredTextBoxExtender>
                            &nbsp;<asp:TextBox ID="txtExciseOnBill" Width="80px" Text="0" CssClass="ItDoseTextinputNum" runat="server" Visible="False"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server"
                                TargetControlID="txtExciseOnBill" FilterType="Custom, Numbers" ValidChars=".-">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Label ID="lblchktxt" runat="server" Text="Print:"></asp:Label>
                <asp:CheckBox ID="chkPrintImg" Checked="true" runat="server" />
                <input type="button" id="BtnSave" value="Save" disabled="disabled" onclick="return SavePO();" />
                <asp:Button ID="btnSavePO" runat="server" Text="Save" Visible="false" CssClass="ItDoseButton" ValidationGroup="Save" meta:resourcekey="btnSavePOResource1" OnClick="btnSavePO_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" id="btnReset" onclick="Clear()" value="Reset" />
                <asp:RequiredFieldValidator ID="rq2" runat="server" ErrorMessage="Specify Narration" Display="None" ControlToValidate="txtNarration" SetFocusOnError="True" meta:resourcekey="rq1Resource1">*</asp:RequiredFieldValidator>
            </div>
        </div>
    </div>
    <div>

        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
            ShowSummary="False" meta:resourcekey="ValidationSummary1Resource1" />
    </div>

<!----------------------------Modal Popup start-------------------------------------------------->
 <div id="myModal" class="modal fade">
     <div class="modal-dialog">
  <div class="modal-content" style="height:350px;width:1050px;padding:4px;">
      <div class="modal-header">
          <%--<span class="close">&times;</span>--%>
          <button type="button" class="close" aria-hidden="true" onclick="CloseModal()">&times;</button>
          <h4 class="modal-title">Items Pricing Detail</h4>
      </div>
    
    <div class="POuter_Box_Inventory" id="DivItemPricingDetails" style="width:100%;border:none;">
            <div class="Purchaseheader">
                Items Pricing Detail&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <%--<div class="col-md-3">
                            <label class="pull-left">
                                Manufacturer
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlManufacturer">
                            </select>
                        </div>--%>
                        <%--<div class="col-md-3">
                                    <label class="pull-left">
                                        Sub&nbsp;Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlSubCategory" onchange="return BindItemOnSubcategory();">

                                    </select>
                                </div>--%>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Items Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-9" style="font-weight:bold;font-size:13px;">
                            <asp:Label runat="server" ID="lblItemsList"></asp:Label>
                            <asp:TextBox ID="txtItemsList" runat="server" Visible="false">
                            </asp:TextBox>
                            <asp:HiddenField ID="hfItemID" runat="server" />
                            <asp:HiddenField runat="server" ID="hfSubCategoryID" />
                            <asp:HiddenField runat="server" ID="hfManufactureID" />
                            
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
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" autocomplete="off">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucFromDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" autocomplete="off">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate2" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucToDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rate
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRate" onkeypress="return checkForSecondDecimal(this,event)" runat="server"></asp:TextBox>
                            <span style="color: red; font-size: 10px; display: none">*</span>
                            <asp:RequiredFieldValidator ID="rqrate" runat="server" ErrorMessage="Rate Required!"
                                ControlToValidate="txtRate" Display="none" SetFocusOnError="true" ValidationGroup="Items"></asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtRate"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                MRP
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRP" onkeypress="return checkForSecondDecimal(this,event)" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtMRP"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purchase&nbsp;Unit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblPerchaseUnit" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                HSN Code 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txttHSNCode" ClientIDMode="Static" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txttHSNCode"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                GST (%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTAX0" runat="server" Width="123px" ClientIDMode="Static">
                                <asp:ListItem Value="T6" Text="CGST&SGST">CGST&SGST</asp:ListItem>
                                 <asp:ListItem Value="T7" Text="CGST&UTGST">CGST&UTGST</asp:ListItem>
                                 <asp:ListItem Value="T4" Selected="True" Text="IGST">IGST</asp:ListItem>
                            </asp:DropDownList>&nbsp;
                        <asp:TextBox ID="txtTAX1" runat="server" Width="40px" MaxLength="9" ClientIDMode="Static"
                            onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDisc();" Text="0"> </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GST Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender12" runat="server" TargetControlID="txtTAX1"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            &nbsp
                        <asp:Label ID="lblGstTypee" runat="server" Text="" Style="font-weight: bold;" ClientIDMode="Static"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Is Deal
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDeel1" ClientIDMode="Static" runat="server" Width="78px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                            <asp:Label ID="Label3" runat="server" Text="+ " Width="5px" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:TextBox ID="txtDeel2" ClientIDMode="Static" runat="server" Width="80px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IGST(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIGSTPercent" runat="server" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" decimalPlace="2" ClientIDMode="Static" Onkeyup="TaxCal();"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender13" runat="server" TargetControlID="txtIGSTPercent"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                CGST(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCGSTPercent" runat="server" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" decimalPlace="2" Onkeyup="TaxCal();" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender14" runat="server" TargetControlID="txtCGSTPercent"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                           <div class="col-md-3">
                            <label class="pull-left">
                                SGST(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSGSTPercent" runat="server" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" decimalPlace="2" Onkeyup="TaxCal();" ClientIDMode="Static"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender15" runat="server" TargetControlID="txtSGSTPercent"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                     
                        <div class="col-md-3">
                            <label class="pull-left">
                                Disc. Amt.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDiscAmt" onchange="validateDis('txtDiscAmt');" onkeypress="return checkForSecondDecimal(this,event)" Onkeyup="validateAmt('txtDiscAmt');" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender16" runat="server" TargetControlID="txtDiscAmt"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <span style="font-weight: bold; color: Red;">OR</span>&nbsp;Disc.(%)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDiscPer" ClientIDMode="Static" onchange="validateDis('txtDiscPer');" onkeypress="return checkForSecondDecimal(this,event)" Onkeyup="validateAmt('txtDiscPer');" runat="server"></asp:TextBox>

                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender17" runat="server" TargetControlID="txtDiscPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemrks" runat="server"
                                Height="" TextMode="MultiLine"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                       <div class="col-md-3">
                       </div>
                        <div class="col-md-5">
                            <label class="pull-left">
                                 <asp:CheckBox ID="chkIsActive" runat="server" Checked="true"  Text="Active This Quotation" />
                                </label>
                            </div>
                         <div class="col-md-3" style="display:none;">
                            <label class="pull-left">
                               Document Upload
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5" style="display:none;">
                             <input type="file" id="FuFileUpload" />
                        </div>
                         <div class="col-md-3" style="display:none;">
                             <input type="button" id="btnUpload" value="Upload" style="display:none;" />
                       </div>
                        <div class="col-md-5">
                            <label class="pull-left">
                                Tax Calculated On
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8" >
                            <asp:RadioButtonList ID="rblTaxCal" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Rate" Value="Rate"></asp:ListItem>
                                <asp:ListItem Text="Rate Inclusive" Value="RateInclusive"></asp:ListItem>
                                <asp:ListItem Text="RateAD" Value="RateAD" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row"></div>
            <table style="width: 100%; border-collapse: collapse">
                <tr style="width: 123px; text-align: center;">
                    <td colspan="6">
                           <input type="button" id="btnAddItems" onclick="return SaveProduct();" value="Add" />
                    </td>
                </tr>
                
            </table>
        </div>
  </div>
    </div>
</div>
<!------------------------------End------------------------------------------------>

    <script id="tb_ItemDetails" type="text/html">
	<table  id="tableitemdetails" cellspacing="0" class="yui" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr class="tblTitle" id="Header">
			<th class="GridViewHeaderStyle" scope="col" >S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Supplier Name</th>
			<th class="GridViewHeaderStyle" scope="col" >Item Name</th>           
			<th class="GridViewHeaderStyle" scope="col" >Avl Qty.</th>          
			<th class="GridViewHeaderStyle" scope="col" >Order Qty.</th>         
			<th class="GridViewHeaderStyle" scope="col" >Unit</th>
			<th class="GridViewHeaderStyle" scope="col" >Free</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">FreeDisplay</th>
            <th class="GridViewHeaderStyle" scope="col" >Unit Price</th>
			<th class="GridViewHeaderStyle" scope="col" >Disc.</th> 
            <th class="GridViewHeaderStyle" scope="col" >Deal</th>          
			<th class="GridViewHeaderStyle" scope="col" >GST Type</th>         
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >hsncode</th>      
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >GSTtypenew</th>      
            <th class="GridViewHeaderStyle" scope="col"  style="display:none;">cgst</th>      
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">hgst</th>      
			<th class="GridViewHeaderStyle" scope="col" >GST(%)</th>
			<th class="GridViewHeaderStyle" scope="col" >Unit Cost</th>
            <th class="GridViewHeaderStyle" scope="col" >Total Cost</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >Manugacturer</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >ItemId</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >VendorID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >TaxCalOn</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >subcategory</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;" >ConFactor</th>
            <th class="GridViewHeaderStyle" scope="col" >Edit</th>
			<th class="GridViewHeaderStyle" scope="col" >Remove</th>
		</tr>
			</thead>
		<tbody>
		<#     
			  var dataLength=ItemDetails.length;
				var objRow;
	   for(var j=0;j<dataLength;j++)
		{
		objRow = ItemDetails[j];
		#>
						<tr data='<#= JSON.stringify(ItemDetails[j])#>' id="<#=j+1#>" >
						<td class="GridViewLabItemStyle" id="tdIndex"  style="width:30px; text-align:center"> <#=j+1#></td>  
						<td class="GridViewLabItemStyle" id="tdvendorname" style=" text-align:center;"><#=objRow.VendorName#></td>
						<td class="GridViewLabItemStyle" id="tdItemname" style=" text-align:center;"><#=objRow.ItemName#></td>                       
						<td class="GridViewLabItemStyle" id="tdinhandqty" style=" text-align:center;"><#=objRow.InHandQty#></td>                      
						<td class="GridViewLabItemStyle" id="tdorderqty" style=" text-align:center;"><#=objRow.OrderQty#></td>                     
						<td class="GridViewLabItemStyle" id="tdunit" style=" text-align:center;"><#=objRow.Unit#></td>                    
                        <td class="GridViewLabItemStyle" id="tdIsfree" style=" text-align:center;">
                        <#if(ItemDetails[j].Free =="0"){#>No<#} else {if(ItemDetails[j].Free =="1") {#>Yes<#}} #>  
                        </td>
                        <td class="GridViewLabItemStyle" id="tdFreeDisplay" style=" text-align:center;display:none;"><#=objRow.Free#></td>
						<td class="GridViewLabItemStyle" id="tdrate" style=" text-align:center;"><#=objRow.Rate#></td>                       
						<td class="GridViewLabItemStyle" id="tddiscpercent" style=" text-align:center;"><#=objRow.DiscPer#></td> 
                        <td class="GridViewLabItemStyle" id="tdIsDeal" style=" text-align:center;"><#=objRow.IsDeal#></td>                      
						<td class="GridViewLabItemStyle" id="tdGstType" style=" text-align:center;"><#=objRow.GSTType#></td>   
                        <td class="GridViewLabItemStyle" id="tdhsncode" style=" text-align:center;display:none;"><#=objRow.HSNCode#></td> 
                        <td class="GridViewLabItemStyle" id="tdgsttypenew" style=" text-align:center;display:none;"><#=objRow.GSTType#></td> 
                        <td class="GridViewLabItemStyle" id="tdcgstpercent" style=" text-align:center;display:none;"><#=objRow.CGSTPercent#></td> 
                        <td class="GridViewLabItemStyle" id="tdsgstpercent" style=" text-align:center;display:none;"><#=objRow.SGSTPercent#></td>                      
						<td class="GridViewLabItemStyle" id="TdGstPer" style=" text-align:center;"><#=objRow.GSTPer#></td>                    
                        <td class="GridViewLabItemStyle" id="TdBuyPrice" style=" text-align:center;"><#=objRow.BuyPrice#></td>
						<td class="GridViewLabItemStyle" id="tdNetAmt" style=" text-align:center;"><#=objRow.NetAmt#></td>  
                        <td class="GridViewLabItemStyle" id="tdManufacturer" style=" text-align:center; display:none"><#=objRow.Manufacturer#></td>  
                        <td class="GridViewLabItemStyle" id="tdItemID" style=" text-align:center; display:none"><#=objRow.ItemID#></td>  
                        <td class="GridViewLabItemStyle" id="tdVendorID" style=" text-align:center; display:none"><#=objRow.VendorID#></td>  
                        <td class="GridViewLabItemStyle" id="tdTaxCalOn" style=" text-align:center; display:none"><#=objRow.TaxCalulatedOn#></td>  
                        <td class="GridViewLabItemStyle" id="tdSubCat" style=" text-align:center; display:none"><#=objRow.SubCategoryID#></td>
                             <td class="GridViewLabItemStyle" id="lblConfact" style=" text-align:center; display:none"><#=objRow.ConFact#></td>
                        <td class="GridViewLabItemStyle" id="tdEdit" style=" text-align:center;">
                             <input type="image"  src="../../Images/edit.png" onclick="return EditRow(this);" />
                        </td>                        
						<td class="GridViewLabItemStyle" id="tddelete" style="text-align:center">
                        <input type="image" src="../../Images/Delete.gif" onclick="return RemoveRow(this);" />
						</td>                       
			           </tr>            
		<#}        
		#>
			</tbody>      
	 </table> 
   </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtPODate').change(function () {
                ChkDate1();
            });
            $('#txtValidDate').change(function () {
                ChkDate1();
            });
            $('#txtDeliveryDate').change(function () {
                ChkDate2();
            });
            // Page Load
            $('#ddlGST').val("T4");
            $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0);
            $('#<%=txtHSNCode.ClientID %>').text('');
            $('#<%=lblGSTType.ClientID %>').text('IGST');
            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);

            $('#ddlGST').change(function () {
                $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0);
                if ($('#ddlGST').val() == "T4") {  // IGST
                    $('#lblGSTType').text("IGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtCGSTPer.ClientID%>').prop("disabled", true);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                } else if ($('#ddlGST').val() == "T6") { // CGST&SGST
                    $('#lblGSTType').text("CGST&SGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }
                else if ($('#ddlGST').val() == "T7") {  // CGST&UTGST
                    $('#lblGSTType').text("CGST&UTGST");
                    $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                    $('#<%=txtCGSTPer.ClientID%>').attr("disabled", false);
                    $('#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                }
            });
        });
function ChkDate1() {
    $.ajax({
        url: "../Common/CommonService.asmx/CompareDate",
        data: '{DateFrom:"' + $('#txtPODate').val() + '",DateTo:"' + $('#txtValidDate').val() + '"}',
        type: "POST",
        async: true,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = mydata.d;
            if (data == false) {
                $("#<%=lblMsg.ClientID%>").text('PO date can not be Greater than Valid date!');
                $("#<%=lblMsg.ClientID%>").focus();
                $("#<%=btnSavePO.ClientID%>").attr('disabled', 'disabled');
            }
            else {
                $("#<%=lblMsg.ClientID%>").text('');
                $("#<%=btnSavePO.ClientID%>").removeAttr('disabled');
                ChkDate2();
            }
        }
    });

}
function ChkDate2() {
    $.ajax({
        url: "../Common/CommonService.asmx/CompareDate",
        data: '{DateFrom:"' + $('#txtPODate').val() + '",DateTo:"' + $('#txtDeliveryDate').val() + '"}',
        type: "POST",
        async: true,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = mydata.d;
            if (data == false) {
                $("#<%=lblMsg.ClientID%>").text('PO date can not be Greater than Delivery date!');
                $("#<%=lblMsg.ClientID%>").focus();
                $("#<%=btnSavePO.ClientID%>").attr('disabled', 'disabled');
            }
            else {
                $("#<%=lblMsg.ClientID%>").text('');
                $("#<%=btnSavePO.ClientID%>").removeAttr('disabled');
            }
        }
    });
}
$(function () {
    $('#<%=ddlCurrency.ClientID %>').change(function () {
        getCurrencyBase($('#<%=ddlCurrency.ClientID %>').val(), document.getElementById('<%=txtInvoiceAmount.ClientID %>').value);

    });
});
function getCurrencyBase(CountryID, Amount) {
    $.ajax({
        url: "../Common/CommonService.asmx/getConvertCurrecncy",
        data: '{countryID:"' + CountryID + '",Amount:"' + Amount + '"}',
        type: "POST",
        async: true,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        success: function (mydata) {
            var data = mydata.d;
            $('#lblCurreny_Amount').text(data);
            $('#txtCurreny_Amount').val(data);
        }
    });
}
function MoveUpAndDownText(textbox2, listbox2) {
    var f = document.theSource;
    var listbox = listbox2;
    var textbox = textbox2;
    if (event.keyCode == 13) {
        textbox.value = "";
    }
    if (event.keyCode == '38' || event.keyCode == '40') {
        if (event.keyCode == '40') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m + 1 == listbox.length) {
                        return;
                    }
                    listbox.options[m + 1].selected = true;
                    textbox.value = listbox.options[m + 1].text;
                    return;
                }
            }
            listbox.options[0].selected = true;
        }
        if (event.keyCode == '38') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m == 0) {
                        return;
                    }
                    listbox.options[m - 1].selected = true;
                    textbox.value = listbox.options[m - 1].text;
                    return;
                }
            }
        }
    }
}

function MoveUpAndDownValue(textbox2, listbox2) {
    var f = document.theSource;
    var listbox = listbox2;
    var textbox = textbox2;
    if (event.keyCode == '38' || event.keyCode == '40') {
        if (event.keyCode == '40') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m + 1 == listbox.length) {
                        return;
                    }
                    listbox.options[m + 1].selected = true;
                    textbox.value = listbox.options[m + 1].text;
                    return;
                }
            }

            listbox.options[0].selected = true;
        }
        if (event.keyCode == '38') {
            for (var m = 0; m < listbox.length; m++) {
                if (listbox.options[m].selected == true) {
                    if (m == 0) {
                        return;
                    }
                    listbox.options[m - 1].selected = true;
                    textbox.value = listbox.options[m - 1].text;
                    return;
                }
            }
        }
    }
}

function suggestName(textbox2, listbox2, level) {
    if (isNaN(level)) { level = 1 }
    if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {

        var listbox = listbox2;
        var textbox = textbox2;

        var soFar = textbox.value.toString();
        var soFarLeft = soFar.substring(0, level).toLowerCase();
        var matched = false;
        var suggestion = '';
        var m
        for (m = 0; m < listbox.length; m++) {
            suggestion = listbox.options[m].text.toString();
            suggestion = suggestion.substring(0, level).toLowerCase();
            if (soFarLeft == suggestion) {
                listbox.options[m].selected = true;
                matched = true;
                break;
            }
        }
        if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
    }
}
function suggestValue(textbox2, listbox2, level) {
    if (isNaN(level)) { level = 1 }
    if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
        var f = document.theSource;
        var listbox = listbox2;
        var textbox = textbox2;

        var soFar = textbox.value.toString();
        var soFarLeft = soFar.substring(0, level).toLowerCase();
        var matched = false;
        var suggestion = '';
        for (var m = 0; m < listbox.length; m++) {
            suggestion = listbox.options[m].value.toString();
            suggestion = suggestion.substring(0, level).toLowerCase();
            if (soFarLeft == suggestion) {
                listbox.options[m].selected = true;
                matched = true;
                break;
            }
        }
        if (matched && level < soFar.length) { level++; suggestName(level) }
    }
}
//Password validation
//function ValidatePass() {
//  if ("<%=Resources.Resource.EnablePassword_OPD_IPDAdvance_IPDBilling_Invoice_PharmacyIssue_PO_GRN.Split('#')[0].ToString()%>" == "1") {
        //$("#checkPasswordPanel").show();
        // $("#txtPassword").focus();
        //  $('#btnCheck').attr('onclick', "if(validatePassword()){ __doPostBack(\'ctl00$ContentPlaceHolder1$btnSavePO\',\'\'); }else{return false;}");
        //  return false;
        // }
        // else {
        //     __doPostBack('ctl00$ContentPlaceHolder1$btnSavePO', '');
        // }
        //}
    </script>
    <script type="text/javascript">
<!--
    function wopen(url, name, w, h) {
        w += 32;
        h += 96;
        var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
        win.resizeTo(w, h);
        win.moveTo(10, 100);
        win.focus();
    }
    // -->
    </script>
    <script type="text/javascript">

        function ButtonDisable(btn) {
            var narration = document.getElementById("ctl00$ContentPlaceHolder1$txtNarration").value;
            if (narration != '') {
                btn.disabled = true;
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave');
            }
        }
        function LTrim(value) {
            var re = /\s*((\S+\s*)*)/;
            return value.replace(re, "$1");
        }
        function RTrim(value) {
            var re = /((\s*\S+)*)\s*/;
            return value.replace(re, "$1");
        }
        // Removes leading and ending whitespaces
        function trim(value) {
            return LTrim(RTrim(value));
        }
        function sum() {
            $('#<%=ddlCurrency.ClientID %>').val( <%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>);
            CheckDot();
            var Nettotal = document.getElementById('<%=lbl.ClientID %>').value;
            if (Nettotal == '') Nettotal = 0;
            var fright = document.getElementById('<%=txtFreight.ClientID %>').value;
            if (fright == '') fright = 0;
            var RoundOff = document.getElementById('<%=txtRoundOff.ClientID %>').value;
            if (RoundOff == '') RoundOff = 0;
            var Scheme = document.getElementById('<%=txtScheme.ClientID %>').value;
            if (Scheme == '') Scheme = 0;
            var Excise = document.getElementById('<%=txtExciseOnBill.ClientID %>').value;
            if (Excise == '') Excise = 0;
            Nettotal = eval(Nettotal) + eval(fright) + eval(Excise) - eval(Scheme);
            var _TAmt = Math.round(Nettotal * 100) / 100;
            Nettotal = Math.round(Nettotal);
            var _Round = Math.round((Nettotal - _TAmt) * 100) / 100;
            $('#lblCurreny_Amount').text(Nettotal);
            $('#txtCurreny_Amount').val(Nettotal);
            document.getElementById('<%=txtInvoiceAmount.ClientID %>').value = Nettotal;
            document.getElementById('<%=txtRoundOff.ClientID %>').value = _Round;
        }
        function CheckDot() {
            if (($("#<%=txtFreight.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtFreight.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtScheme.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtScheme.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtExciseOnBill.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtExciseOnBill.ClientID%>").val('');
                return false;
            }
            return true;
        }
        function MoveUpAndDownText(textbox2, listbox2) {
            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;
                            LoadDetail();
                            return;
                        }
                    }
                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            LoadDetail();
                            return;
                        }
                    }
                }
            }
        }
        function MoveUpAndDownValue(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;
                            LoadDetail();
                            return;
                        }
                    }
                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            LoadDetail();
                            return;
                        }
                    }
                }
            }
        }
        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        LoadDetail();
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }
        }
        function suggestValue(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
                var f = document.theSource;
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                for (var m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        LoadDetail();
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(level) }
            }
        }
    </script>
    <%-----------------Get Amount Info after selection the ListBoxItem---------------------%>
    <script type="text/javascript">
        function LoadDetail() {
            //var strItem = $('#<%=ListBox1.ClientID %>').val();
            var strItem = $('[id$=lblItemName]').val();
            var strVendor = $('#<%=ddlVendor.ClientID %>').val();
            var ItemID = strItem.split('#')[0];
            if (ItemID == "" || ItemID == null) {
                var ItmID = $('[id$=hfItemID]').val();
                ItemID = ItmID.split('#')[0];
            }
            var VendorID = strVendor.split('#')[0];
            var DeptLedgerNo = '<%=ViewState["DeptLedgerNo"].ToString()%>'
            $.ajax({
                url: "../Store/WebServices/StockStatusRpt.asmx/BindListAmtInfo",
                data: '{ ItemID:"' + ItemID + '",VendorID:"' + VendorID + '",DeptLedgerNo:"' + DeptLedgerNo + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var InvData = (typeof result.d) == 'string' ? eval('(' + result.d + ')') : result.d;
                    if (InvData.length != 0) {
                        $('#<%=txtRate1.ClientID %>').text(InvData[0].NetAmt);    // Rate
                        $('#<%=lblMajorUnit.ClientID %>').text(InvData[0].MajorUnit);
                        $('#<%=lblTaxCalculatedOn.ClientID %>').text(InvData[0].TaxCalulatedOn);
                        $('#<%=lblConFactor.ClientID %>').text(InvData[0].ConFactor);
                        var d = parseFloat(InvData[0].DiscPer);
                        
                        $('#<%=txtDiscount1.ClientID %>').val(d.toFixed(2)).attr('readonly', 'readonly');
                        $('#<%=txtVATPer.ClientID %>').val(InvData[0].VATPer).attr('readonly', 'readonly');
                        $('#<%=lblTaxID.ClientID %>').val(InvData[0].TaxID);

                        //$('#<%=lblMajorUnit.ClientID %>').val(InvData[0].MajorUnit).attr('readonly', 'readonly');
                        $('#<%=lblMinorUnit.ClientID %>').val(InvData[0].MinorUnit).attr('readonly', 'readonly');
                        $('#<%=txtExcisePer.ClientID %>').val(InvData[0].ExcisePer).attr('readonly', 'readonly');


                        $('#<%=txtIGSTPer.ClientID %>').val(InvData[0].IGSTPercent).attr('readonly', 'readonly');
                        $('#<%=txtCGSTPer.ClientID %>').val(InvData[0].CGSTPercent).attr('readonly', 'readonly');
                        $('#<%=txtSGSTPer.ClientID %>').val(InvData[0].SGSTPercent).attr('readonly', 'readonly');
                        $("#ddlGST option:contains(" + InvData[0].GSTType + ")").attr('selected', 'selected');
                        $('#<%=txtHSNCode.ClientID %>').text(InvData[0].HSNCode);
                        $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType).attr('readonly', 'readonly');
                        if (InvData[0].GSTType == "IGST") {
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                        } else if (InvData[0].GSTType == "CGST&SGST") {
                            $('#<%=txtIGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                        } else if (InvData[0].GSTType == "CGST&UTGST") {
                            $('#<%=txtIGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text(InvData[0].GSTType);
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", true);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", false);
                        } else {
                            $("#ddlGST option:contains('IGST')").attr('selected', 'selected');
                            $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text('IGST');
                            $('#<%=txtHSNCode.ClientID %>').text('');
                            $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                            $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                        }
                        $('#<%=txtDeal1.ClientID%>,#<%=txtDeal2.ClientID%>').prop("readonly", true);
                        if (InvData[0].Deal != '') {
                            $('#txtDeal1').val(InvData[0].Deal.split('+')[0]);
                            $('#txtDeal2').val(InvData[0].Deal.split('+')[1]);

                        }
            }
            else {
                $('#<%=txtRate1.ClientID %>,#<%=txtDiscount1.ClientID %>,#<%=txtVATPer.ClientID %>,#<%=txtExcisePer.ClientID %>,#<%=lblTaxID.ClientID %>,#<%=lblConFactor.ClientID %>,#<%=lblMajorUnit.ClientID %>,#<%=lblMinorUnit.ClientID %>,#<%=lblTaxCalculatedOn.ClientID %>').val('');
                        $("#ddlGST option:contains('IGST')").attr('selected', 'selected');
                        $('#<%=txtIGSTPer.ClientID%>,#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').val(0); $('#<%=lblGSTType.ClientID %>').text('IGST');
                        $('#<%=txtHSNCode.ClientID %>').text('');
                        $('#<%=txtIGSTPer.ClientID%>').attr("disabled", false);
                        $('#<%=txtCGSTPer.ClientID%>,#<%=txtSGSTPer.ClientID%>').prop("disabled", true);
                        $('#<%=txtDeal1.ClientID%>,#<%=txtDeal2.ClientID%>').prop("readonly", false);
                         ShowModalPopUp();
                        $("#myModal").showModel();
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        $(function () {
            $("#txtQuantity1").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;

                strLen = $(this).val().length;
                strVal = $(this).val();
                hasDec = false;
                e = (e) ? e : (window.event) ? event : null;
                if (e) {
                    var charCode = (e.charCode) ? e.charCode :
                                    ((e.keyCode) ? e.keyCode :
                                    ((e.which) ? e.which : 0));
                    if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                        for (var i = 0; i < strLen; i++) {
                            hasDec = (strVal.charAt(i) == '.');
                            if (hasDec)
                                return false;
                        }
                    }
                }
            });
        });
    </script>
    <script type="text/javascript">
        function preventBackspace(e) {
            var evt = e || window.event;
            if (evt) {
                var keyCode = evt.charCode || evt.keyCode;
                if (keyCode === 8) {
                    if (evt.preventDefault) {
                        evt.preventDefault();
                    } else {
                        evt.returnValue = false;
                    }
                }
            }
        }
        function validateQty() {
            if ($('[id$=rblStoreType] input:checked').val() == undefined) {
                $('#<%=lblMsg.ClientID %>').text('Please Select Store Type');
                     $('#<%=rblStoreType.ClientID %>').focus();
                     return false;
                 }
            if ($("#<%=ddlVendor.ClientID%>").val() == "0") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Vendor');
                $('#<%=ddlVendor.ClientID %>').focus();
                return false;
            }
            if ($('[id$=lblItemName]').text() == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Item');
                $('#txtSearchItem').focus();
                return false;
            }
            if ($.trim($('#<%=txtRate1.ClientID %>').text()) == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Rate');
                $('#<%=txtRate1.ClientID %>').focus();
                return false;
            }
            if ($.trim($('#<%=txtQuantity1.ClientID %>').val()) < "0") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Quantity');
                $('#<%=txtQuantity1.ClientID %>').focus();
                return false;
            }
            else {
                return true;
            }
        }


        function ShowModalPopUp() {
          
            var itm = $('[id$=lblItemName]').text();
            $('[id$=lblItemsList]').text(itm);

            GetItemID();
            BindPurchaseUnit();
            GetManufacturer();
            GetSubCatgoryID();
            GetHSNCode();
            GetSGST();
            GetIGST();
            GetCGST();
            GetGst();

            //$("#myModal").showModel();
            //var modal = document.getElementById('myModal');

            
            
        }

        function CloseModal() {
            var modal = document.getElementById('myModal');
            modal.style.display = "none";
        }

        
        
    </script>
</asp:Content>
