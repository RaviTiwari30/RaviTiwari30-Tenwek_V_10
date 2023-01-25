<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="POByReOrder.aspx.cs" Inherits="Design_Purchase_POByReOrder" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        //$(document).ajaxStart(function () {
        //    debugger;
        //    $modelUnBlockUI();
        //});

        //$(document).ajaxComplete(function () {
        //    $modelUnBlockUI();
        //});

        $(document).ready(function () {
            $("input[name='StoreType']").bind("click", function () {
                $("#lblMsg").text('');
                bindItem();
                bindVendor();
                bindGSTType();
               
            });
            $("[id*=chkselectAll]").live("click", function () {
                var chkHeader = $(this);
                var grid = $(this).closest("table");
                $("input[type=checkbox]:not(:disabled)", grid).each(function () {
                    if (chkHeader.is(":checked")) {
                        $(this).attr("checked", "checked");
                    } else {
                        $(this).removeAttr("checked");
                    }
                });
            });
            $("[id*=chkselect]").live("click", function () {
                var grid = $(this).closest("table");
                var chkHeader = $("[id*=chkselectAll]", grid);
                if (!$(this).is(":checked")) {
                    chkHeader.removeAttr("checked");
                } else {
                    if ($("[id*=chkselect]", grid).length == $("[id*=chkselect]:checked", grid).length)
                        chkHeader.attr("checked", "checked");
                }
            });
            $("#ckbCheckAll").click(function () {
                $(".checkBoxClass").attr('checked', this.checked);
            });
        });
        function CalUnitPrice(rowId) {

            var id = $(rowId).closest('tr').find('#tdSno').text();
            if ($(rowId).closest('tr').find('#ddlvendor').val() == "0") {
                $(rowId).closest('tr').find('#ddlvendor').css("border", "2px dotted Red");
                $(rowId).closest('tr').find('#ddlvendor').focus();
                $(rowId).closest('tr').find('#ddlvendor').removeAttr('disabled');
                $(rowId).val(0);
                return;
            } else {
                $(rowId).closest('tr').find('#ddlvendor').css("border", "");
                $(rowId).closest('tr').find('#ddlvendor').attr("disabled", "disabled")
            }

            if ($(rowId).closest('tr').find('#ddlTaxCalOn').val() == "0") {
                $(rowId).closest('tr').find('#ddlTaxCalOn').css("border", "2px dotted Red");
                $(rowId).closest('tr').find('#ddlTaxCalOn').focus();
                $(rowId).val(0);
                return;
            } else {
                $(rowId).closest('tr').find('#ddlTaxCalOn').css("border", "");
            }

            var GST_Type = $(rowId).closest('tr').find('#ddlgsttype option:selected').text();
            var Rate = parseFloat($(rowId).closest('tr').find('#txtRate' + id).val()).toFixed(2);
            var MRP = parseFloat($(rowId).closest('tr').find('#txtMRP' + id).val()).toFixed(2);
            var DiscPer = parseFloat($(rowId).closest('tr').find('#txtDiscPer' + id).val()).toFixed(2);
            var GSTPer = parseFloat($(rowId).closest('tr').find('#txtGSTPer' + id).val()).toFixed(2);
            var IGSTPer = parseFloat($(rowId).closest('tr').find('#tdIGSTPercent').text()).toFixed(2);
            var CGSTPer = parseFloat($(rowId).closest('tr').find('#tdCGSTPercent').text()).toFixed(2);
            var SGSTPer = parseFloat($(rowId).closest('tr').find('#tdSGSTPercent').text()).toFixed(2);
            var UnitPrice = parseFloat($(rowId).closest('tr').find('#tdUnitPrice').text()).toFixed(2);
            var TaxCalOn = $(rowId).closest('tr').find('#tdTaxCalOn option:selected').text();
            var ROL = parseFloat($(rowId).closest('tr').find('#tdReorderLevel').text()).toFixed(2);
            var ROLQty = parseFloat($(rowId).closest('tr').find('#txtReorderQty' + id).val()).toFixed(2);

            if (Rate == "0" && MRP == "0" && DiscPer == "0") {
                $(rowId).closest('tr').find('#ddlTaxCalOn,#ddlvendor').val(0);
                $(rowId).closest('tr').find('#ddlTaxCalOn,#ddlvendor').removeAttr('disabled');
                $(rowId).closest('tr').find('#ddlvendor').css("border", "2px dotted Red");
                $(rowId).closest('tr').find('#ddlvendor').focus();
            } else {
                $(rowId).closest('tr').find('#ddlTaxCalOn,#ddlvendor').attr("disabled", "disabled");
                $(rowId).closest('tr').find('#ddlvendor').css("border", "");
            }
            var TotalTaxPer = parseFloat(IGSTPer) + parseFloat(CGSTPer) + parseFloat(SGSTPer);
            if (GSTPer != TotalTaxPer) {
                alert('Kindly Check GST(%)');
                return;
            }

            var DiscAmt = 0, TaxAmt = 0;
            if ($(rowId).closest('tr').find('#ddlTaxCalOn').val() == "Rate") {
                if (DiscPer > 0 && DiscPer != null)
                    DiscAmt = (Rate * DiscPer) / 100;
                TaxAmt = (Rate * TotalTaxPer) / 100;
                UnitPrice = parseFloat(Rate) + parseFloat(TaxAmt) - parseFloat(DiscAmt);
            }
            else if ($(rowId).closest('tr').find('#ddlTaxCalOn').val() == "RateAD") {
                if (DiscPer > 0 && DiscPer != null)
                    DiscAmt = (Rate * DiscPer) / 100;
                TaxAmt = ((Rate - DiscAmt) * TotalTaxPer) / 100;
                UnitPrice = parseFloat(Rate) + parseFloat(TaxAmt) - parseFloat(DiscAmt);
            }

            var TotalAmount = (parseFloat(UnitPrice) * parseFloat(ROLQty)).toFixed(2);
            $(rowId).closest('tr').find('#tdUnitPrice').text(Number(UnitPrice).toFixed(2));
            $(rowId).closest('tr').find('#tdTotalAmount').text(Number(TotalAmount).toFixed(2));
            $(rowId).closest('tr').find('#tdDiscAmt').text(Number(DiscAmt).toFixed(2));
            $(rowId).closest('tr').find('#tdGSTAmt').text(Number(TaxAmt).toFixed(2));

            if (TotalAmount > 0)
                $(rowId).closest('tr').find('#chkselect' + id).prop("disabled", false)
            else
                $(rowId).closest('tr').find('#chkselect' + id).prop("disabled", true)

            if ($(rowId).closest('tr').find('#ddlgsttype').val() == "T4") {         // IGST
            }
            else if ($(rowId).closest('tr').find('#ddlgsttype').val() == "T6") {    // CGST&SGST
            }
            else if ($(rowId).closest('tr').find('#ddlgsttype').val() == "T7") {    // CGST&UTGST
            }
        }
        function bindVendor() {
            $("#ddlvendor option").remove();
            $.ajax({
                url: "POByReOrder.aspx/bindVendor",
                data: '{StoreID:"' + $("input[name='StoreType']:checked").val() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    Vendor = jQuery.parseJSON(result.d);
                    if (Vendor != null) {
                      
                        $('#ItemOutput').find('#ddlvendor').append($("<option></option>").val("0").html("---Select---"));
                        for (i = 0; i < Vendor.length; i++) {
                            $('#ItemOutput').find('#ddlvendor').append($("<option></option>").val(Vendor[i].ID).html(Vendor[i].LedgerName));
                        }
                    }
              
                 
                },
                error: function (xhr, status) {
                }
            });
        }
        function bindGSTType() {
            $("#ddlgsttype option").remove();
            $.ajax({
                url: "POByReOrder.aspx/bindGSTType",
                data: '{}',
                type: "Post",
                async: false,
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    Vendor = jQuery.parseJSON(result.d);
                    if (Vendor != null) {
                        $('#ItemOutput').find('#ddlgsttype').append($("<option></option>").val("0").html("---Select---"));
                        for (i = 0; i < Vendor.length; i++) {
                            $('#ItemOutput').find('#ddlgsttype').append($("<option></option>").val(Vendor[i].TaxID).html(Vendor[i].TaxName));
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function bindItem() {
            $.ajax({
                type: "post",
                data: '{StoreID:"' + $("input[name='StoreType']:checked").val() + '"}',
                url: "POByReOrder.aspx/bindItem",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    itemData = jQuery.parseJSON(result.d);
                    if (itemData != null && itemData != "") {
                        var output = $("#tb_ItemDetail").parseTemplate(itemData);
                        $("#ItemOutput").html(output);
                        $("#ItemOutput,#divitemdetail").show();
                    } else { $("#ItemOutput,#divitemdetail").hide(); }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                }
            });
        }
        function bindStock(rowID) {
            var ItemID = $(rowID).closest('tr').find("#tdItemID").text().trim();
            $.ajax({
                type: "post",
                data: '{ItemID:"' + ItemID + '",StoreID:"' + $("input[name='StoreType']:checked").val() + '"}',
                url: "POByReOrder.aspx/bindStock",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    StockData = jQuery.parseJSON(result.d);
                    if (StockData != null) {
                        var output = $("#tb_StockDetail").parseTemplate(StockData);
                        $("#StockOutput").html(output);
                        $("#StockOutput").show();
                        $find('mpStock').show();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                }
            });
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpStock')) {
                    $find('mpStock').hide();
                }
            }
        }
        function hideStock() {
            $find('mpStock').hide();
        }
        function getItemDetail() {
            var dataItem = new Array();
            var ObjItem = new Object();
            $("#ItemOutput tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "trHeader") {
                    if (($rowid).closest("tr").find("#chkselect" + id).is(':checked') == true) {
                        if ($.trim($rowid.find("#tdVendor_ID").text()) != "" && $.trim($rowid.find("#tdVendor_ID").text()) != null) {
                            ObjItem.Vendor_ID = $.trim($rowid.find("#tdVendor_ID").text());
                            ObjItem.Rate = $.trim($rowid.find("#tdRate").text());
                            ObjItem.MRP = $.trim($rowid.find("#tdMRP").text());
                            ObjItem.DiscPer = $.trim($rowid.find("#tdDiscPer").text());
                            ObjItem.GSTType = $.trim($rowid.find("#tdGSTType" + id).text());
                            ObjItem.GSTPer = $.trim($rowid.find("#tdGSTPer").text());
                            ObjItem.TaxCalOn = $.trim($rowid.find("#tdTaxCalOn").text());
                            ObjItem.TaxID = $.trim($rowid.find("#tdTaxID").text());
                        } else {
                            ObjItem.Vendor_ID = $.trim($rowid.find("#ddlvendor").val());
                            ObjItem.Rate = $.trim($rowid.find("#txtRate" + id).val());
                            ObjItem.MRP = $.trim($rowid.find("#txtMRP" + id).val());
                            ObjItem.DiscPer = $.trim($rowid.find("#txtDiscPer" + id).val());
                            ObjItem.GSTType = $.trim($rowid.find("#ddlgsttype option:selected").text());
                            ObjItem.GSTPer = $.trim($rowid.find("#txtGSTPer" + id).val());
                            ObjItem.TaxCalOn = $.trim($rowid.find("#ddlTaxCalOn option:selected").text());
                            ObjItem.TaxID = $.trim($rowid.find("#ddlgsttype").val());
                        }
                        ObjItem.ItemID = $.trim($rowid.find("#tdItemID").text());
                        ObjItem.SubCategoryID = $.trim($rowid.find("#tdSubCategoryID").text());
                        ObjItem.PurchaseUnit = $.trim($rowid.find("#tdUnitType").text());
                        ObjItem.DiscAmt = $.trim($rowid.find("#tdDiscAmt").text());
                        ObjItem.GSTAmt = $.trim($rowid.find("#tdGSTAmt").text());
                        ObjItem.IGSTPercent = $.trim($rowid.find("#tdIGSTPercent").text());
                        ObjItem.CGSTPercent = $.trim($rowid.find("#tdCGSTPercent").text());
                        ObjItem.SGSTPercent = $.trim($rowid.find("#tdSGSTPercent").text());
                        ObjItem.HSNCode = $.trim($rowid.find("#tdHSNCode").text());
                        ObjItem.UnitPrice = $.trim($rowid.find("#tdUnitPrice").text());
                        ObjItem.Quantity = $.trim($rowid.find("#txtReorderQty" + id).val());
                        ObjItem.StoreType = $("input[name='StoreType']:checked").val();
                        ObjItem.ConversionFactor = $.trim($rowid.find("#tdConversionFactor").text());
                        ObjItem.ManufactureID = $.trim($rowid.find("#tdManufactureID").text());
                        ObjItem.IsRateSet = $.trim($rowid.find("#tdIsRateSet").text());
                        ObjItem.TotalAmount = $.trim($rowid.find("#tdTotalAmount").text());
                        dataItem.push(ObjItem);
                        ObjItem = new Object();
                    }
                }
            });
            return dataItem;
        }
        function savepo() {
            var count = 0; var validate = true;
            $("#ItemOutput tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "trHeader")
                    if (($rowid).closest("tr").find("#chkselect" + id).is(':checked') == true) {
                        count = count + 1;
                        if (($rowid.find("#txtReorderQty" + id).val()) == 0) {
                            modelAlert('Please Check ROL Quantity');
                            $rowid.find("#txtReorderQty" + id).focus();
                            validate = false;
                            return;
                        }

                    }
            });
            if (count == 0) {
                modelAlert('Please select atleast one item');
                $("input[name='StoreType']:checked").focus();
                return;
            }
            var resultItem = getItemDetail();
            if (validate) {
                modelConfirmation('Alert!!!', 'Do You Want to Generate Purchase Order?', 'Continue', 'Close', function (response) {
                    if (response) {
                        $.ajax({
                            type: "post",
                            data: JSON.stringify({ itemDetail: resultItem }),
                            url: "POByReOrder.aspx/savePOByROL",
                            dataType: "json",
                            contentType: "application/json;charset=UTF-8",
                            timeout: 120000,
                            async: false,
                            success: function (result) {
                                var Data = (result.d);
                                if (Data == "1") {
                                    modelAlert('PO Generated Successfully');
                                    $("#divitemdetail,#tb_ItemDetail").hide();
                                    $("input[name='StoreType']").prop('checked', false);
                                }
                                else {
                                    modelAlert('Error Occured');
                                }
                            },
                            error: function (xhr, status) {
                                modelAlert('Error Occured..');
                            }
                        });
                    }
                });
            }


        }

        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }

            if (sender.value == "0") {
                sender.value = sender.value.substring(0, sender.value.length - 1);
            }

            strLen = sender.value.length;
            strVal = sender.value;
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
            return true;
        }
        function CalAmt(Qty) {
            var ROLQty = $(Qty).val();
            var id = $(Qty).closest('tr').find('#tdSno').text();
            if (ROLQty.charAt(0) == "0") {
                $(Qty).val(Number(ROLQty));
            }

            if (ROLQty.match(/[^0-9\.]/g)) {
                ROLQty = ROLQty.replace(/[^0-9\.]/g, '');
                $(Qty).val(Number(ROLQty));
                return;
            }

            if (ROLQty.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = ROLQty.indexOf(".");
                if (valIndex > "0") {
                    if (ROLQty.length - (ROLQty.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(Qty).val($(Qty).val().substring(0, ($(Qty).val().length - 1)));

                    }
                }
            }
            if (ROLQty == 0) {
                $(Qty).val(0);
            }
            var UnitPrice = $(Qty).closest('tr').find('#tdUnitPrice').text();
            var TotalAmount = Number(UnitPrice * ROLQty).toFixed(2);
            $(Qty).closest('tr').find("#tdTotalAmount").text(TotalAmount);

            if (TotalAmount > 0)
                $(Qty).closest('tr').find('#chkselect' + id).prop("disabled", false)
            else
                $(Qty).closest('tr').find('#chkselect' + id).prop("disabled", true)


        }
        function CalGST(GSTPer) {
            var GSTPercent = $(GSTPer).val();
            if (GSTPercent.charAt(0) == "0") {
                $(GSTPer).val(Number(GSTPercent));
            }

            if (GSTPercent.match(/[^0-9\.]/g)) {
                GSTPercent = GSTPercent.replace(/[^0-9\.]/g, '');
                $(GSTPer).val(Number(GSTPercent));
                return;
            }

            if (GSTPercent.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = GSTPercent.indexOf(".");
                if (valIndex > "0") {
                    if (GSTPercent.length - (GSTPercent.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(GSTPer).val($(GSTPer).val().substring(0, ($(GSTPer).val().length - 1)));

                    }
                }
            }
            if (GSTPercent == 0) {
                $(GSTPer).val(0);
                $(GSTPer).closest('tr').find('#ddlgsttype').val(0);
                $(GSTPer).closest('tr').find('#ddlgsttype').removeAttr('disabled');
                $(GSTPer).closest('tr').find('#tdIGSTPercent,#tdCGSTPercent,#tdSGSTPercent').text(0);
            }
            var Sno = $(GSTPer).closest('tr').find('#tdSno').text();

            if ($(GSTPer).closest('tr').find('#tdGSTType' + Sno + ' option:selected').val() == "0") {
                $(GSTPer).closest('tr').find('#ddlgsttype').focus();
                $(GSTPer).val(0);
                $(GSTPer).closest('tr').find('#ddlgsttype').css("border", "2px dotted Red");
                return;
            } else {
                $(GSTPer).closest('tr').find('#ddlgsttype').css("border", "");
            }

            if ($(GSTPer).closest('tr').find('#tdGSTType' + Sno + ' option:selected').val() == "T4") {



                $(GSTPer).closest('tr').find('#tdIGSTPercent').text($(GSTPer).val());
                $(GSTPer).closest('tr').find('#tdCGSTPercent').text(0);
                $(GSTPer).closest('tr').find('#tdSGSTPercent').text(0);
                $(GSTPer).closest('tr').find('#ddlgsttype').attr("disabled", "disabled")
                return;
            }
            else if ($(GSTPer).closest('tr').find('#tdGSTType' + Sno + ' option:selected').val() == "T6") {
                var CGSTPer = Number($(GSTPer).val() / 2);
                var SGSTPer = Number($(GSTPer).val() / 2);
                $(GSTPer).closest('tr').find('#tdIGSTPercent').text(0);
                $(GSTPer).closest('tr').find('#tdCGSTPercent').text(CGSTPer);
                $(GSTPer).closest('tr').find('#tdSGSTPercent').text(SGSTPer);
                $(GSTPer).closest('tr').find('#ddlgsttype').attr("disabled", "disabled")
                return;
            }
            else if ($(GSTPer).closest('tr').find('#tdGSTType' + Sno + ' option:selected').val() == "T7") {
                var CGSTPer = Number($(GSTPer).val() / 2);
                var SGSTPer = Number($(GSTPer).val() / 2);
                $(GSTPer).closest('tr').find('#tdIGSTPercent').text(0);
                $(GSTPer).closest('tr').find('#tdCGSTPercent').text(CGSTPer);
                $(GSTPer).closest('tr').find('#tdSGSTPercent').text(SGSTPer);
                $(GSTPer).closest('tr').find('#ddlgsttype').attr("disabled", "disabled")
                return;
            }
        }

    </script>
    
    <script id="tb_ItemDetail" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_ItemSearch" style="width:1250px;border-collapse:collapse;text-align:center;">
            <tr id="trHeader">          
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;"><input type="checkbox" id="chkselectAll" /></th>   
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Vendor</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">Vendor ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left;display:none;">ItemID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left;display:none;">SubCategoryID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left;display:none;">ConversionFactor</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left;display:none;">ManufactureID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;text-align:left;display:none;">IsRateSet</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;text-align:left;">Item Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">Unit Type</th>   
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">TaxCalOn</th>                                          
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Rate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">MRP</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Disc (%)</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">Disc Amount</th>               
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">GST Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">GST (%)</th>                   
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">TaxID</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">GST Amount</th>             
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">IGST (%)</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">CGST (%)</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">SGST (%)</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">HSN Code</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">U.P.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">Min</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">Max</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">ROL</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">ROL Qty</th> 
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Total Amount</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">Avail Stock</th>         
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Avl. Stock</th>
            </tr>
          
            <#
                var dataLength=itemData.length;
                window.status="Total Records Found :"+ dataLength;
                var objRow;
                for(var j=0;j<dataLength;j++)
                {
                    objRow = itemData[j];
            #>
            <tr id="<#=j+1#>"
                  <#                      
                                     #>  style="background-color:<#=objRow.RowColour#>" <#                        
						 #>
                >                
                 <td id="tdchkselect" class="GridViewLabItemStyle">
                    <# if(objRow.disabled=="false"){ #> 
                    <input type="checkbox" id="chkselect<#=j+1#>"  />
                       <# } else{ #>
                      <input type="checkbox" id="chkselect<#=j+1#>"  disabled="disabled" />
                       <#} #>   

                </td>

                <td  id="tdSno" class="GridViewLabItemStyle"><#=j+1#></td>
                <td id="tdVendor<#=j+1#>" class="GridViewLabItemStyle" style="text-align:left;">
                     <# if(objRow.Vendor!=""){ #> 
                        <#=objRow.Vendor#>
                     <# } else{ #>
                             <select id="ddlvendor"  style="width:150px" class="choosen"></select>                        
                     <#} #>    
                </td>
                 <td id="tdVendor_ID" class="GridViewLabItemStyle" style="text-align:left;display:none;"> <#=objRow.Vendor_ID#></td>
                <td id="tdItemID" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.ItemID#></td>
                <td id="tdSubCategoryID" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.SubCategoryID#></td>
                <td id="tdConversionFactor" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.ConversionFactor#></td>
                <td id="tdManufactureID" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.ManufactureID#></td>
                <td id="tdIsRateSet" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.IsRateSet#></td>
                <td id="tdItemName" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.ItemName#></td>
                <td id="tdUnitType" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.UnitType#></td>      
                <td id="tdTaxCalOn" class="GridViewLabItemStyle" style="text-align:left;">               
                      <# if(objRow.Vendor!=""){ #> 
                          <#=objRow.TaxCalulatedOn#>
                     <# } else{ #>
                            <select id="ddlTaxCalOn"  style="width:70px">
                            <option selected="selected" value="0">--Select--</option>
                            <option value="Rate">Rate</option>   
                            <option value="RateAD">RateAD</option>  
                            </select>                      
                     <#} #> 

                </td>
                                                  
                <td id="tdRate" class="GridViewLabItemStyle" style="text-align:right;">
                    <# if(objRow.Vendor!=""){ #> 
                        <#=objRow.GrossAmt#>
                     <# } else{ #>
                            <input type="text" maxlength="8" id="txtRate<#=j+1#>"  onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum" value="<#=objRow.GrossAmt#>" style="width:50px;"  onkeyup="CalUnitPrice(this);"  />                      
                     <#} #> 
                </td>
                <td id="tdMRP" class="GridViewLabItemStyle" style="text-align:right;">                
                       <# if(objRow.Vendor!=""){ #> 
                          <#=objRow.MRP#>
                     <# } else{ #>
                            <input type="text" maxlength="8" id="txtMRP<#=j+1#>"  onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum" value="<#=objRow.MRP#>" style="width:50px;"   onkeyup="CalUnitPrice(this);"  />                      
                     <#} #> 

                </td>                
                <td id="tdDiscPer" class="GridViewLabItemStyle" style="text-align:right;">                  
                      <# if(objRow.Vendor!=""){ #> 
                           <#=objRow.DiscPer#>
                     <# } else{ #>
                            <input type="text" id="txtDiscPer<#=j+1#>" maxlength="8"   onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum" value="<#=objRow.DiscPer#>" style="width:40px;"   onkeyup="CalUnitPrice(this);" />                      
                     <#} #> 
                </td>
                 <td id="tdDiscAmt" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.DiscAmt#></td>  
                

                <td id="tdGSTType<#=j+1#>" class="GridViewLabItemStyle" style="text-align:left;">                   
                     <# if(objRow.Vendor!=""){ #> 
                            <#=objRow.GSTType#>
                     <# } else{ #>
                             <select id="ddlgsttype"  style="width:90px"></select>                                        
                     <#} #>    
                </td>
                <td id="tdGSTPer" class="GridViewLabItemStyle" style="text-align:right;">                   
                      <# if(objRow.Vendor!=""){ #> 
                      <#=objRow.GSTPer#>
                     <# } else{ #>
                            <input type="text" maxlength="8" id="txtGSTPer<#=j+1#>"  onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum" value="<#=objRow.GSTPer#>" style="width:40px;" onkeyup="CalGST(this);CalUnitPrice(this);"   />                      
                     <#} #> 
                </td>    
                <td id="tdTaxID" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.TaxID#></td>
                <td id="tdGSTAmt" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.GSTAmt#></td>
                <td id="tdIGSTPercent" class="GridViewLabItemStyle" style="text-align:right;"><#=objRow.IGSTPercent#></td>
                <td id="tdCGSTPercent" class="GridViewLabItemStyle" style="text-align:right;"><#=objRow.CGSTPercent#></td>
                <td id="tdSGSTPercent" class="GridViewLabItemStyle" style="text-align:right;"><#=objRow.SGSTPercent#></td>
                <td id="tdHSNCode" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.HSNCode#></td>
               
                <td id="tdUnitPrice" class="GridViewLabItemStyle" style="text-align:right;"><#=objRow.NetAmt#></td>
                <td id="tdMinLevel" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.MinLevel#></td>
                <td id="tdMaxLevel" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.MaxLevel#></td>
                <td id="tdReorderLevel" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.ReorderLevel#></td>
                <td id="tdReorderQty" class="GridViewLabItemStyle" style="text-align:left;"><input type="text" maxlength="8" id="txtReorderQty<#=j+1#>"  onkeypress="return checkForSecondDecimal(this,event)" class="ItDoseTextinputNum" value="<#=objRow.ReorderQty#>" style="width:50px;" onkeyup="CalAmt(this);"  /></td>   
                <td id="tdTotalAmount" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.TotalAmount#></td>   
                <td id="tdAvailStock" class="GridViewLabItemStyle" style="text-align:left;display:none;"><#=objRow.AvailStock#></td>
               
                 <td class="GridViewLabItemStyle" style="width:90px;">      
                     <# if(itemData[j].AvailStock > "0"){#>
                      <input type="button" id="btnItem<#=j+1#>" value="Avl Stock" class="ItDoseButton" onclick="bindStock(this)" />
                     <#}else{#>   
                   <span>NA</span>
                     <#}#>         
                      
                </td>
            </tr>
            <#}#>
        </table>
    </script>


    <script id="tb_StockDetail" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_DocShareItem" style="width:auto;border-collapse:collapse;text-align:center">
            <tr id="Header">
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">ItemName</th>  
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">StockID</th>                                           
                <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Avail.Qty</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px; display:none;">DeptLedgerNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Department</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">FromDept</th>
            </tr>          
            <#
                var dataLength=StockData.length;
                window.status="Total Records Found :"+ dataLength;
                var objRow;
                for(var j=0;j<dataLength;j++)
                {
                    objRow = StockData[j];
            #>
            <tr id="Tr1">        
                <td class="GridViewLabItemStyle"><#=j+1#></td>
                <td id="tdItemNamePopUp" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.ItemName#></td>  
                <td id="tdStockID" class="GridViewLabItemStyle"><#=objRow.StockID#></td>                           
                <td id="tdAvailQty" class="GridViewLabItemStyle"><#=objRow.AvailQty#></td>
                <td id="tdDeptLedgerNo" style="display:none"><#=objRow.DeptLedgerNo#></td>
                <td id="tdDeptName" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.DeptName#></td>   
                <td id="tdFromDept" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.FromDept#></td>             
            </tr>
            <#}#>
        </table>
    </script>

       <cc1:ModalPopupExtender ID="mpStock" runat="server" BackgroundCssClass="filterPupupBackground" CancelControlID="btnRCancel" DropShadow="true" 
           PopupControlID="pnlStock" TargetControlID="btnNew" BehaviorID="mpStock" OnCancelScript="hideStock()" PopupDragHandleControlID="dragHandle"></cc1:ModalPopupExtender>
    <asp:Button ID="btnNew" runat="server" Style="display: none" />
    <asp:Panel ID="pnlStock" runat="server" CssClass="pnlRequestItemsFilter" Style="display: none; width:700px;">
        <div class="Purchaseheader" runat="server" style="text-align: right"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="hideStock()" />to close</span></em>
        </div>
        <div id="StockOutput" style="max-height: 120px; overflow-x: auto; text-align: center"></div>
            <table style="width: 100%">
                <tr>
                    <td colspan="2" style="text-align: center">                       
                        <asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>

    <div id="Pbody_box_inventory" style="width:1350px;">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div style="text-align: center;width:1345px;" class="POuter_Box_Inventory">
            <b>PO By Re-Order</b>
            <br />
             <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>

      
         <div class="POuter_Box_Inventory"  style="width:1345px;">
          <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                       <input id="rdoStoreTypeMed" type="radio" name="StoreType" value="STO00001"  />Medical Store
                       <input id="rdoStoreTypeGen" type="radio" name="StoreType" value="STO00002" />General Store

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                             
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                              
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                              <%--<asp:DropDownList ID="ddlvendor" Width="60%" runat="server" ClientIDMode="Static" style="display:none;"></asp:DropDownList>--%>
                        </div>
                    </div>
             </div>

             <div class="POuter_Box_Inventory" style="width:1345px;">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">

                    <div class="row">
                        <div class="col-md-7"></div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSN" runat="server" Width="25px" Height="25px" BackColor="AntiqueWhite"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Open Purchase Order"  Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Fixed</b>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="LightBlue"
                                CssClass="ItDoseButton11 circle" ToolTip="Click for Close Purchase Order"  Style="cursor: pointer;" />
                            <b style="margin-top: 5px; margin-left: 5px;">Not Fixed</b>
                        </div>
                        <div class="col-md-3">
                            
                        </div>
                        <div class="col-md-3">
                          
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>


          
        <div class="POuter_Box_Inventory" id="divitemdetail" style=" display:none;width:1345px;">
               
           
             <div id="ItemOutput" style="max-height: 400px; overflow-x: auto; text-align: center"></div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">

                    <div class="row" style="text-align:center;" >
                        <div class="col-md-22">
                             <input type="button" onclick="savepo();" value="Save" class="ItDoseButton" id="btnSaveItem" title="Click To Save" />&nbsp;
                        <asp:Button ID="Button1" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />

                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>


        </div>
   
     
</asp:Content>