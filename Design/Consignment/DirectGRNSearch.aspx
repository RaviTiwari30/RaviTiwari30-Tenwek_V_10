<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="DirectGRNSearch.aspx.cs" Inherits="Design_Store_DirectGRNSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-1.8.0.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
    <link href="../../Styles/themes/redmond/jquery-ui.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript">

        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#btnSearch').attr('disabled', 'disabled');
                        $('#<%=gvGRN.ClientID %>,#<%=gvItems.ClientID %>').hide();
                        $("#tbAppointment table").remove();
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                        $('#<%=gvGRN.ClientID %>').val(null);
                        $('#<%=gvItems.ClientID %>').val(null);
                    }
                }
            });
        }

        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
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

        function validatedot() {
            if (($("#<%=txtOctori.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtOctori.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtFright.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtFright.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtQty.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtMRP.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtMRP.ClientID%>").val('');
                return false;
            }
            return true;
        }

        function Validateinfo() {
            var narration = $("#<%=txtnarration.ClientID %>").val();
            narration = jQuery.trim(narration);
            if (narration == "") {
                $("#<%=lblNarUpdate.ClientID%>").text('Enter Narration');
                return false;
            }
            else {
                $("#<%=lblNarUpdate.ClientID %>").text('');
                return true;
            }
        }

    </script>

    <script type="text/javascript">

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#00ff00';
        }
        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(GRNNo, Type) {
            window.open('ConsignmentReceiveReport.aspx?' + Type + '=' + GRNNo);
        }
    </script>
    <script type="text/javascript">
        $(function () {
            expiryCon();
        });

        function expiryCon() {
            var obs = $("#<%=ddlItemname.ClientID %>").val();

            if (obs != null) {
                var array = obs.split('#')[5];
                if (array.toUpperCase() == "YES") {
                    $("#<%=txtExpDate.ClientID%>").show();
                }
                else {

                    $("#<%=txtExpDate.ClientID%>").val('').hide();
                }
            }
        }

        function LoadDetail() {
            var strItem = $('#<%=ddlItemname.ClientID %>').val();
            if (strItem != null) {
                var ItemID = strItem.split('#')[0];

                $('#<%=lblNewConversionFactor.ClientID %>').text(strItem.split('#')[7]);
                $('#<%=lblMajorUnit.ClientID %>').text(strItem.split('#')[8]);
                $('#<%=lblMinorUnit.ClientID %>').text(strItem.split('#')[6]);

            }
        }

        $(function () {
            LoadDetail();
        });

        function taxChange() {
            if ($('#<%=ddlTax.ClientID%>').val() == "T4") {
                $('#<%=txtCGST.ClientID%>,#<%=txtSGST.ClientID%>').attr('disabled', 'disabled');
                $('#<%=txtIGST.ClientID%>').removeAttr('disabled');
                $('#<%=spSgst.ClientID%>').text("SGST(%) :");
            }
            else if ($('#<%=ddlTax.ClientID%>').val() == "T7") {
                $('#<%=txtCGST.ClientID%>,#<%=txtSGST.ClientID%>').removeAttr('disabled');
                $('#<%=txtIGST.ClientID%>').attr('disabled', 'disabled');
                $('#<%=spSgst.ClientID%>').text("UTGST(%) :");
            }
            else {
                $('#<%=txtCGST.ClientID%>,#<%=txtSGST.ClientID%>').removeAttr('disabled');
                $('#<%=txtIGST.ClientID%>').attr('disabled', 'disabled');
                $('#<%=spSgst.ClientID%>').text("SGST(%) :");
            }
            $('#<%=txtCGST.ClientID%>,#<%=txtSGST.ClientID%>,#<%=txtIGST.ClientID%>').val(Number('0').toFixed(2));
        }

    </script>

    <script type="text/javascript">
        $(function () {
            $("#txtIItemName").autocomplete({
                source: function (request, response) {
                    var param = { ItemName: $('#txtIItemName').val(), GRNNo: $('#lblIGRNNo').text() };
                    $.ajax({
                        url: "DirectGRNSearch.aspx/GetItemList",
                        data: JSON.stringify(param),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function (data) { return data; },
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    value: item.itemID,
                                    label: item.itemName
                                }
                            }))
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            var err = eval("(" + XMLHttpRequest.responseText + ")");
                            alert(err.Message)
                        },
                    });
                },
                select: function (event, ui) {
                    var label = ui.item.label;
                    var value = ui.item.value;
                    this.value = '';
                    $("#lblIItemName").text(label);
                    $("#lblIItemID").text(value);
                    $("#txtIItemName").val('');
                    ui.item.value = ''
                    var str = $('#lblIItemID').text();
                    debugger;
                    var strarray = str.split('#');
                    if ($.trim(strarray[5]) == "YES") {
                        $("txtIExpiryDate").prop("disabled", false)
                    } else if ($.trim(strarray[5]) == "NO") {
                        $("txtIExpiryDate").prop("disabled", true)
                    }

                    $("#lblIPurUnit").text(strarray[6]);
                    $("#lblICoFactor").text(strarray[7]);
                    $("#lblISaleUnit").text(strarray[8]);
                    if ($.trim(strarray[9]) == "IGST") {
                        $('#<%=ddlIGSTType.ClientID%>').val('T4');
                        $("#txtICGSTPer,#txtISGSTPer").prop("disabled", true); $("#txtIIGSTPer").prop("disabled", false);
                    }
                    else if ($.trim(strarray[9]) == "CGST&SGST") {
                        $('#<%=ddlIGSTType.ClientID%>').val('T6');
                        $("#txtICGSTPer,#txtISGSTPer").prop("disabled", false); $("#txtIIGSTPer").prop("disabled", true);
                    }
                    else if ($.trim(strarray[9]) == "UTGST&SGST") {
                        $('#<%=ddlIGSTType.ClientID%>').val('T7');
                        $("#txtICGSTPer,#txtISGSTPer").prop("disabled", false); $("#txtIIGSTPer").prop("disabled", true);
                    }
                    else {
                        $('#<%=ddlIGSTType.ClientID%>').val('T4');
                        $("#txtICGSTPer,#txtISGSTPer").prop("disabled", true); $("#txtIIGSTPer").prop("disabled", false);
                        $("#txtICGSTPer,#txtISGSTPer,#txtIIGSTPer").val(Number('0').toFixed(2));
                    }
                    $("#txtIIGSTPer").val(strarray[10]);
                    $("#txtICGSTPer").val(strarray[11]);
                    $("#txtISGSTPer").val(strarray[12]);
                    $("#txtIHSNCode").val(strarray[13]);
                },
                minLength: 1

            });

            $("#btnAddItem").bind("click", Add);
            $("#btnCancelPopUp").bind("click", PopUpCancel);
        });

function GSTTypeChange() {
    if ($('#<%=ddlIGSTType.ClientID%>').val() == "T4") {
        $("#txtICGSTPer,#txtISGSTPer").prop("disabled", false); $("#txtIIGSTPer").prop("disabled", false);
    }
    else if ($('#<%=ddlIGSTType.ClientID%>').val() == "T6") {
        $("#txtICGSTPer,#txtISGSTPer").prop("disabled", false); $("#txtIIGSTPer").prop("disabled", true);
    }
    else if ($('#<%=ddlIGSTType.ClientID%>').val() == "T7") {
           $("#txtICGSTPer,#txtISGSTPer").prop("disabled", false); $("#txtIIGSTPer").prop("disabled", true);
       }
    $("#txtICGSTPer,#txtISGSTPer,#txtIIGSTPer").val(Number('0').toFixed(2));
}

function Add() {

    if ($('#lblIItemID').text() == "") {
        $("#spnErrorMsg").text('Please Search Any Item');
        return;
    }

    var ItemID = $('#lblIItemID').text().split('#')[0].trim();

    var conDup = 0;
    if (CheckDuplicateItem(ItemID)) {
        $("#spnErrorMsg").text('Selected Item Already Added');
        conDup = 1;
        $('#spnErrorMsg').focus();
        return;
    }
    if (conDup == "1") {
        $("#spnErrorMsg").text('Selected Item Already Added');
        return;
    }

    var ItemName = $('#lblIItemName').text();
    var MRP = Number($('#txtIMRP').val()).toFixed(2);
    var Rate = Number($('#txtIRate').val()).toFixed(2);

    var Qty = Number($('#txtIQuantity').val()).toFixed(2);
    var DiscPer = Number($('#txtIDiscPer').val()).toFixed(2);
    var BatchNo = $('#txtIBatchNo').val();
    var GSTType = $('#ddlIGSTType option:selected').text();
    var HSNCode = $('#txtIHSNCode').val();
    var IGSTPer = $('#txtIIGSTPer').val();
    var CGSTPer = $('#txtICGSTPer').val();
    var SGSTPer = $('#txtISGSTPer').val();
    var Deal1 = Number($('#txtIDeal1').val()).toFixed(2);
    var Deal2 = Number($('#txtIDeal2').val()).toFixed(2);
    var IsExp = $('#lblIItemID').text().split('#')[5];
    if (IsExp == "YES" && ($('#txtIExpiryDate').val() == "")) {
        $("#spnErrorMsg").text('Please Select Expiry Date');
        $('#spnErrorMsg').focus();
        return;
    }
    var d = $('#txtIExpiryDate').val().split('-');
    var ExpiryDate = d[2] + '-' + d[1] + '-' + d[0];
    var CoFactor = $('#lblIItemID').text().split('#')[7];
    var TaxCalOn = $('#rblTaxCal').find('input[type=radio]:checked').val();
    var PurUnit = $('#lblIPurUnit').text();
    var SaleUnit = $('#lblISaleUnit').text();
    var SubCategoryID = $('#lblIItemID').text().split('#')[1];
    var Type_ID = $('#lblIItemID').text().split('#')[3];

    var IsUsable = 0;
    if ($('#lblIItemID').text().split('#')[14] == "R")
        IsUsable = 1;
    else
        IsUsable = 0;

    var IsFree = "No";
    if ($("#IsFreeItem").is(':checked'))
        IsFree = "Yes";
    else
        IsFree = "No";



    if (Rate == 0.00 || isNaN(Rate)) {
        $("#spnErrorMsg").text('Please Enter Rate');
        return;
    }
    if (MRP == 0.00 || isNaN(MRP)) {
        $("#spnErrorMsg").text('Please Enter MRP');
        return;
    }
    if (Qty == 0.00 || isNaN(Qty)) {
        $("#spnErrorMsg").text('Please Enter Quantity');
        return;
    }

    if (parseFloat(Rate) > parseFloat(MRP)) {
        $("#spnErrorMsg").text('Rate cannot be greater than Selling Price');
        return;
    }





    $('#tbSelected').css('display', 'block');
    $('#tbSelected').append('<tr><td class="GridViewLabItemStyle"><span id="ItemID" style="display:none">' + ItemID + '</span><span id="SubCategoryID" style="display:none">' + SubCategoryID + '</span><span id="Type_ID" style="display:none">' + Type_ID + '</span><span id="IsUsable" style="display:none">' + IsUsable + '</span><span id="ItemName">' + ItemName + '</span><td class="GridViewLabItemStyle"><span id="MRP">' + MRP + '</span></td><td class="GridViewLabItemStyle"><span id="Rate">' + Rate + '</span></td><td class="GridViewLabItemStyle"><span id="Qty">' + Qty + '</span></td><td class="GridViewLabItemStyle"><span id="DiscPer">' + DiscPer + '</span></td><td class="GridViewLabItemStyle"><span id="BatchNo">' + BatchNo + '</span></td><td class="GridViewLabItemStyle"><span id="IsFree">' + IsFree + '</span></td><td class="GridViewLabItemStyle"  style="display:none"><span id="CoFactor">' + CoFactor + '</span></td><td class="GridViewLabItemStyle"  style="display:none"><span id="PurUnit">' + PurUnit + '</span></td><td class="GridViewLabItemStyle"  style="display:none"><span id="SaleUnit">' + SaleUnit + '</span></td><td class="GridViewLabItemStyle"  style="display:none"><span id="IsExpirable">' + IsExp + '</span></td><td class="GridViewLabItemStyle"  style="display:none"><span id="ExpiryDate">' + ExpiryDate + '</span></td><td class="GridViewLabItemStyle" style="display:none"><span id="Deal1">' + Deal1 + '</span></td><td class="GridViewLabItemStyle" style="display:none"><span id="Deal2">' + Deal2 + '</span></td><td class="GridViewLabItemStyle"><span id="TaxCalOn">' + TaxCalOn + '</span></td><td class="GridViewLabItemStyle"><span id="GSTType">' + GSTType + '</span></td><td class="GridViewLabItemStyle" style="display:none"><span id="HSNCode">' + HSNCode + '</span></td><td class="GridViewLabItemStyle"><span id="IGSTPer">' + IGSTPer + '</span></td><td class="GridViewLabItemStyle"><span id="CGSTPer">' + CGSTPer + '</span></td><td class="GridViewLabItemStyle"><span id="SGSTPer">' + SGSTPer + '</span></td><td class="GridViewLabItemStyle"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');
    $("#spnErrorMsg").text('');
    Clear();

    if ($('#tbSelected tr:not(#GRNHeader)').length > 0) {
        $('#btnUpdateGRN').show();
    }
}

function RemoveRows(rowid) {
    $(rowid).closest('tr').remove();
    if ($('#tbSelected tr:not(#GRNHeader)').length == 0) {
        $('#tbSelected').hide();
    }
    $("#spnErrorMsg").text('');
}
function CheckDuplicateItem(ItemID) {
    var count = 0;
    $('#tbSelected tr:not(#GRNHeader)').each(function () {
        if ($(this).find('#ItemID').text().trim() == ItemID) {
            count = count + 1;
        }
    });
    if (count == 0)
        return false;
    else
        return true;
}

function Clear() {
    $('#lblIItemID').text('');
    $('#lblIItemName,#lblICoFactor,#lblIPurUnit,#lblISaleUnit').text('');
    $('#txtIItemName').val('');
    $('#txtIMRP,#txtIRate,#txtIQuantity,#txtIDiscPer,#txtIBatchNo,#txtIDeal1,#txtIDeal2,#txtIExpiryDate,#txtIHSNCode').val('');
    $('#txtIIGSTPer,#txtICGSTPer,#txtISGSTPer').val(Number("0").toFixed(2));
    $('#IsFreeItem').attr('checked', false);
}

function PopUpCancel() {
    Clear();
    $('#tbSelected').remove();
    if ($('#tbSelected tr:not(#GRNHeader)').length == 0) {
        $('#tbSelected').hide();
    }
    $find('mpAddItem').hide();
}

function UpdateGRN() {
      $('#btnUpdateGRN').attr('disabled', true).val("Submitting...");
    var resultGRN = ItemDetail();
    $.ajax({
        url: "Services/WebService.asmx/AddGRNItem",
        data: JSON.stringify({ ItemDetail: resultGRN }),
        type: "Post",
        contentType: "application/json; charset=utf-8",
        timeout: "120000",
        dataType: "json",
        success: function (result) {
            OutPut = result.d;
            if (result.d != "") {
                $('#lblMsg').text('Record Updated Successfully');
                alert('Record Updated Successfully ');
                window.open('../Store/DirectGRNReport.aspx?Proj_GRN=' + OutPut.split('#')[0]);
                Clear();
                $('#tbSelected').hide();
                $find('mpAddItem').hide();
            }
            else {
                $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                $('#btnUpdateGRN').attr('disabled', true).val("Save");
            }
        },
        error: function (xhr, status) {
            $("#spnErrorMsg").text('Error occurred, Please contact administrator');
            $('#btnUpdateGRN').attr('disabled', true).val("Save");
        }
    });
}

function ItemDetail() {
    var dataGRN = new Array();
    var objGRN = new Object();
    $("#tbSelected tr").each(function () {
        var id = $(this).attr("id");
        var $rowid = $(this).closest("tr");
        if (id != "GRNHeader") {
            objGRN.LedgerTnxNo = $("#lblIGRNNo").text();
            objGRN.VenLedgerNo = $("#lblIVenLedgerNo").text();
            objGRN.InvoiceNo = $("#lblIInvoiceNo").text();
            var InvDate = $('#lblIInvoiceDate').text().split('-');
            objGRN.InvoiceDate = InvDate[2] + '-' + InvDate[1] + '-' + InvDate[0];
            objGRN.StoreLedgerNo = $("#lblIStoreLedgerNo").text();
            objGRN.ItemID = $.trim($rowid.find("#ItemID").text());
            objGRN.SubCategoryID = $.trim($rowid.find("#SubCategoryID").text());
            objGRN.ItemName = $.trim($rowid.find("#ItemName").text());
            objGRN.Rate = $.trim($rowid.find("#Rate").text());
            objGRN.MRP = $.trim($rowid.find("#MRP").text());
            objGRN.Quantity = $.trim($rowid.find("#Qty").text());
            objGRN.DiscPer = $.trim($rowid.find("#DiscPer").text());
            objGRN.DiscAmt = Number("0").toFixed(2);
            objGRN.BatchNumber = $.trim($rowid.find("#BatchNo").text());
            objGRN.ConversionFactor = $.trim($rowid.find("#CoFactor").text());
            objGRN.IsUsable = $.trim($rowid.find("#IsUsable").text());
            objGRN.IsFree = $.trim($rowid.find("#IsFree").text());
            objGRN.IsExpirable = $.trim($rowid.find("#IsExpirable").text());
            objGRN.ExpiryDate = $.trim($rowid.find("#ExpiryDate").text());
            objGRN.Deal1 = $.trim($rowid.find("#Deal1").text());
            objGRN.Deal2 = $.trim($rowid.find("#Deal2").text());
            objGRN.PurchaseUnit = $.trim($rowid.find("#PurUnit").text());
            objGRN.SaleUnit = $.trim($rowid.find("#SaleUnit").text());
            objGRN.TaxCalOn = $.trim($rowid.find("#TaxCalOn").text());
            objGRN.Type_ID = $.trim($rowid.find("#Type_ID").text());
            objGRN.GST_Type = $.trim($rowid.find("#GSTType").text());
            objGRN.HSNCode = $.trim($rowid.find("#HSNCode").text());
            objGRN.IGSTPer = $.trim($rowid.find("#IGSTPer").text());
            objGRN.CGSTPer = $.trim($rowid.find("#CGSTPer").text());
            objGRN.SGSTPer = $.trim($rowid.find("#SGSTPer").text());
            dataGRN.push(objGRN);
            objGRN = new Object();
        }
    });
    return dataGRN;
}




    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Consignment Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Invoice No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInvoiceNo" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GRN No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtGRNNo" runat="server" Width="" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Supplier Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlVendor" runat="server" Width="" />
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
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" Width=""> </asp:TextBox>
                            <cc1:CalendarExtender ID="fromdate" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
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
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" Width=""> </asp:TextBox>
                            <cc1:CalendarExtender ID="todate" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GRN Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGRNType" runat="server" Width="">
                                <asp:ListItem Selected="True" Text="All" Value="2" />
                                <asp:ListItem Text="Non-Posted" Value="0" />
                                <asp:ListItem Text="Posted" Value="1" />
                                <asp:ListItem Text="Rejected" Value="3" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                    OnClick="btnSearch_Click" ClientIDMode="Static" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div class="" style="text-align: center;">
                <asp:GridView ID="gvGRN" runat="server" ToolTip="Double Click for Items Detail" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" AllowPaging="true" PageSize="8" OnPageIndexChanging="gvGRN_PageIndexChanging"
                    OnRowDataBound="gvGRN_RowDataBound" OnRowCommand="gvGRN_RowCommand" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Consign. No.">
                            <ItemTemplate>
                                <b><%# Eval("consignmentNo").ToString()%></b>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                       <asp:TemplateField HeaderText="Return">
                           <ItemTemplate>
                                <b><%# Eval("IsReturn").ToString()%></b>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                       </asp:TemplateField>
                        <asp:TemplateField HeaderText="Invoice No.">
                            <ItemTemplate>
                                <%# Eval("BillNo")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Challan No.">
                            <ItemTemplate>
                                <%# Eval("ChallanNo")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Supplier Name">
                            <ItemTemplate>
                                <%# Eval("LedgerName")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="225px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <%# Eval("StockDate")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="85px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post Status">
                            <ItemTemplate>
                              <%# Eval("NewPost")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemTemplate>
                                <%--<asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView" ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("GRNNo")%>' Visible='<%# Util.GetBoolean(Eval("Reject1"))%>' />--%>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView" ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("consignmentNo")%>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" Visible="false" CommandName="AEdit" ImageUrl="~/Images/edit.png" CommandArgument='<%# Eval("consignmentNo")%>' />
                              
                                <asp:Label runat="server" ID="lblConsignmentNo" Text='<%# Eval("consignmentNo")%>' ClientIDMode="Static" style="display:none"></asp:Label>
                                <img alt="Edit" id="imgEdit" src="~/Images/edit.png" onclick="onEditConsignment(this)" runat="server"  Visible='<%# !Util.GetBoolean(Eval("IsPosted")) %>'  />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Post">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbPost" runat="server" CausesValidation="false" CommandName="APost" ImageUrl="~/Images/Post.gif" CommandArgument='<%# Eval("consignmentNo") %>' Visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="20px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="20px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbCancel" runat="server" CausesValidation="false" CommandName="ACancel" ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("consignmentNo") %>' Visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="20px" />
                            <ItemStyle CssClass="GridViewItemStyle"  Width="20px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                GRN Details
            </div>
            <div class="" style="text-align: left;">
                <asp:Panel ID="pnlItems" runat="server" Height="200px" Width="100%" ScrollBars="Vertical">
                    <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="gvItems_RowCommand" OnRowDataBound="gvItems_RowDataBound" Width="100%">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Consign No." HeaderStyle-Width="85px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <b><%# Eval("ConsignmentNo")%></b>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="300px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("ItemName")%>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField Visible="false" HeaderText="Cost Price" HeaderStyle-Width="75px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("UnitPrice")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Batch No." HeaderStyle-Width="100px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("BatchNumber")%>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Disc(%)" HeaderStyle-Width="30px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("DiscountPer")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Special Disc(%)" HeaderStyle-Width="30px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("SpecialDiscPer")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="HSNCode" HeaderStyle-Width="60px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" Visible="false">
                                <ItemTemplate>
                                    <%# Eval("HSNCode")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IGST(%)" HeaderStyle-Width="60px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" Visible="false">
                                <ItemTemplate>
                                    <%# Eval("IGSTPercent")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CGST(%)" HeaderStyle-Width="60px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" Visible="false">
                                <ItemTemplate>
                                    <%# Eval("CGSTPercent")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="SGST(%)" HeaderStyle-Width="60px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" Visible="false">
                                <ItemTemplate>
                                    <%# Eval("SGSTPercent")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Qty." HeaderStyle-Width="75px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("InititalCount")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="75px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("Rate")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Selling Price" HeaderStyle-Width="75px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Eval("MRP")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Free" HeaderStyle-Width="40px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <%# Util.GetBoolean(Eval("Free")) ? "Yes" : "No"%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/Images/edit.png" CommandArgument='<%# Eval("ID") %>' Visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblReject" runat="server" Text='<%#Eval("IsReject") %>' Visible="false"></asp:Label>
                                    <asp:ImageButton ID="imbCancel1" runat="server" CausesValidation="false" CommandName="ACancel1" ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Eval("ID") %>' Visible='<%# !Util.GetBoolean(Eval("Post")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                </asp:Panel>
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row" style="text-align: center;">
                        <asp:Button ID="btnAddGRNItem" runat="server" CssClass="ItDoseButton" Text="Add Item" ClientIDMode="Static" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton" />
    </div>
    <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none">
        <div class="Purchaseheader" id="Div1" runat="server">
            Cancel Consignment
        </div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 476px">
                <tr>
                    <td style="width: 100px">Consignment No. :
                    </td>
                    <td style="width: 395px">
                        <asp:Label ID="lblConsignNo" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 66px">Reason :
                    </td>
                    <td style="width: 395px">
                        <asp:TextBox ID="txtCancelReason" runat="server" Width="250px"
                            ValidationGroup="GRNCacnel" />&nbsp;<span style="color: Red; font-size: 9px;">*</span>
                        <cc1:FilteredTextBoxExtender ID="cfsreason" TargetControlID="txtCancelReason" FilterType="LowercaseLetters,UppercaseLetters" runat="server"></cc1:FilteredTextBoxExtender>
                        <asp:RequiredFieldValidator ID="rq1" runat="server" ControlToValidate="txtCancelReason"
                            ErrorMessage="Specify Cancel Reason" ValidationGroup="GRNCacnel" Text="*" Display="None" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnGRNCancel" runat="server" CssClass="ItDoseButton" Text="Reject"
                ValidationGroup="GRNCacnel" OnClick="btnGRNCancel_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnItemCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpCancel" runat="server" CancelControlID="btnItemCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel1" PopupDragHandleControlID="Div1">
    </cc1:ModalPopupExtender>
    <%--Item Cancelation--%>
    <asp:Panel ID="Panel3" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="Div4" runat="server">
            Cancel Item
        </div>
        <div class="content" style="margin-left: 10px">
            <table width="530px">
                <tr>
                    <td style="width: 105px">Consignment No. :
                    </td>
                    <td style="width: 395px">
                        <asp:Label ID="lblGRNno1" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr style="display: none;">
                    <td style="width: 105px">StockID :
                    </td>
                    <td style="width: 395px">
                        <asp:Label ID="lblStockID1" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 105px">Item Name :
                    </td>
                    <td style="width: 395px">
                        <asp:Label ID="lblItemName1" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 105px">Reason :
                    </td>
                    <td style="width: 395px">
                        <asp:TextBox ID="txtItemReason" runat="server" Width="250px"
                            ValidationGroup="GRNCacnel" />&nbsp;<span style="color: Red; font-size: 9px;">*</span>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtItemReason"
                            ErrorMessage="Specify Cancel Reason" ValidationGroup="ItemCacnel" Text="*" Display="None" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnRejectItem" runat="server" CssClass="ItDoseButton" Text="Reject Item"
                ValidationGroup="ItemCacnel" OnClick="btnRejectItem_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelItem" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mapItemCancel" runat="server" CancelControlID="btnCancelItem"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel3" PopupDragHandleControlID="Div4">
    </cc1:ModalPopupExtender>
    <%--Item Cancelation--%>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlFilter" Width="620px" Style="display: none">
        <div class="Purchaseheader" id="Div2" runat="server">
            Update GRN Item
        </div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 600px; border-collapse: collapse">
                <tr>
                    <td colspan="4" style="width: 600px">
                        <asp:Label ID="lblStockID" runat="server" Visible="false" />
                        <asp:Label ID="lblLedgerTnxNo" runat="server" Visible="false" />
                        <asp:Label ID="lblFree" runat="server" Visible="false" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Item Name :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:Label ID="lblItemName" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Rate :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:Label ID="lblRate" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="width: 100px; text-align: right">MRP :&nbsp;</td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblMRP" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    </td>



                </tr>
                <tr>
                    <td style="text-align: right; width: 100px;">&nbsp;Quantity :&nbsp;
                    </td>
                    <td style="text-align: left; width: 200px;">
                        <asp:Label ID="lblQty" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="width: 100px; text-align: right">Batch No :&nbsp;
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblBatchNumber" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>


                <tr>
                    <td style="width: 100px; text-align: right">Discount(%) :&nbsp;
                    </td>
                    <td style="width: 200px">

                        <asp:Label ID="lblDiscountPer" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="text-align: right; width: 100px;">&nbsp;IGST(%) :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblIGSTPer" runat="server" CssClass="ItDoseLabelSp" />
                    </td>


                </tr>

                <tr>
                    <td style="width: 100px; text-align: right">Expiry Date :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:Label ID="lblExpiryDate" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    </td>
                    <td style="width: 100px; text-align: right">&nbsp;CGST(%) :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:Label ID="lblCGSTPer" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    </td>

                </tr>
                <tr>
                    <%-- <td style="text-align: right; width: 100px;">Excise(%) :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblExcisePer" runat="server" CssClass="ItDoseLabelSp" />
                    </td>--%>
                    <td style="width: 100px; text-align: right">IsDeal :&nbsp;
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblIsDeal" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="text-align: right; width: 100px;">&nbsp;SGST(%) :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblSGSTPer" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">TaxCalculateOn:&nbsp;
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblTaxCalculateOn" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="width: 100px; text-align: right">GST Type :&nbsp;
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblGSTType" runat="server" CssClass="ItDoseLabelSp" />
                    </td>

                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Conversion&nbsp;Factor&nbsp;:&nbsp;
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblConversionFactor" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="width: 100px; text-align: right">HSNCode :&nbsp;
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblHSNCode" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Special Disc(%) :&nbsp;
                    </td>
                    <td style="width: 200px">

                        <asp:Label ID="lblSpecialDiscPer" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Item Name :&nbsp;</td>
                    <td style="text-align: left; width: 200px">
                        <asp:DropDownList ID="ddlItemname" runat="server" Width="190px" CssClass="ItDoseDropdownbox" onchange="expiryCon();LoadDetail();"></asp:DropDownList>
                    </td>
                    <td style="width: 100px; text-align: right">IsDeal :&nbsp;</td>
                    <td style="width: 200px; text-align: left">
                        <asp:TextBox ID="txtDeal" ClientIDMode="Static" runat="server" Width="30px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                        <asp:Label ID="Label1" runat="server" Text="+ " Width="5px" CssClass="ItDoseLabelSp"></asp:Label>
                        <asp:TextBox ID="txtDeal1" ClientIDMode="Static" runat="server" Width="30px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Rate :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:TextBox ID="txtRate" runat="server" Width="100px" MaxLength="12" CssClass="ItDoseTextinputNum" />
                    </td>
                    <td style="width: 100px; text-align: right">Sell. Price :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:TextBox ID="txtMRP" runat="server" CssClass="ItDoseTextinputNum" Width="100px"
                            onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                            MaxLength="9" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtMRP"
                            FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Quantity :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:TextBox ID="txtQty" runat="server" CssClass="ItDoseTextinputNum" Width="100px"
                            onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                            MaxLength="9" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtQty"
                            FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 100px; text-align: right">Batch :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:TextBox ID="txtBatch" runat="server" Width="100px" MaxLength="12" CssClass="ItDoseTextinputText" />
                    </td>

                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Disc(%) :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:TextBox ID="txtDiscPer" runat="server" Width="100px" MaxLength="12" CssClass="ItDoseTextinputNum" />
                    </td>
                    <%-- <td style="width: 100px; text-align: right">Vat(%) :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:TextBox ID="txtVatper" runat="server" Width="100px" MaxLength="12" CssClass="ItDoseTextinputNum" />
                    </td>--%>
                    <td style="width: 100px; text-align: right">Expiry Date:
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:TextBox ID="txtExpDate" Style="text-align: left;" runat="server" CssClass="ItDoseTextinputNum" Width="100px" MaxLength="10"> </asp:TextBox>
                        <cc1:CalendarExtender ID="expdate" TargetControlID="txtExpDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                        <%-- &nbsp;<span style="color: #0066FF"><em><asp:Label ID="lbldateformat" runat="server" Text="(format-dd-MM-yyyy)"></asp:Label>
                        </em></span>--%>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Special Disc(%) :&nbsp;
                    </td>
                    <td style="width: 200px">
                        <asp:TextBox ID="txtSpecialDiscPer" runat="server" Width="100px" MaxLength="12" CssClass="ItDoseTextinputNum" />
                    </td>
                </tr>
                <tr>


                    <td style="width: 100px; text-align: right">Conv.Fact. :
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:Label ID="lblNewConversionFactor" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        <asp:Label ID="lblMajorUnit" runat="server" CssClass="ItDoseLabelSp" Visible="true"></asp:Label>
                        <asp:Label ID="lblMinorUnit" runat="server" CssClass="ItDoseLabelSp" Visible="true"></asp:Label>

                    </td>
                    <td style="width: 100px; text-align: right">Pur.Tax : &nbsp;
                    </td>
                    <td style="width: 200px; text-align: left">
                        <asp:DropDownList ID="ddlTax" runat="server" Width="110px" CssClass="ItDoseDropdownbox" onchange="taxChange();"></asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right;">CGST(%) :&nbsp;
                    </td>

                    <td style="width: 200px; text-align: left;">
                        <asp:TextBox ID="txtCGST" runat="server" Width="100px" CssClass="ItDoseTextinputNum" MaxLength="6" onlyNumber="5" decimalPlace="2" max-value="100" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                    </td>


                    <td style="width: 138px; text-align: right">
                        <span id="spngstSU"></span>
                        <span id="spSgst" runat="server">SGST(%) :&nbsp;</span>
                        <%--<span id="spUtgst" runat="server">UTGST(%) :&nbsp;</span>--%>
                    </td>
                    <td style="width: 128px; text-align: left;">
                        <asp:TextBox ID="txtSGST" CssClass="ItDoseTextinputNum" runat="server" Width="100px" MaxLength="6" onlyNumber="5" decimalPlace="2" max-value="100" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right;">IGST(%) :&nbsp;
                    </td>

                    <td style="width: 200px; text-align: left;">
                        <asp:TextBox ID="txtIGST" runat="server" Width="100px" CssClass="ItDoseTextinputNum" onlyNumber="5" decimalPlace="2" max-value="100" MaxLength="6" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="width: 400px">
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtQty"
                            ErrorMessage="Specify Quantity" ValidationGroup="GRNUpdate" Text="*" Display="None" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtMRP"
                            ErrorMessage="Specify MRP" ValidationGroup="GRNUpdate" Text="*" Display="None" />
                    </td>
                </tr>
            </table>

        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" Text="Update" ValidationGroup="GRNUpdate"
                OnClick="btnUpdate_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnUpdateCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpUpdate" runat="server" CancelControlID="btnUpdateCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate" PopupDragHandleControlID="Div2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlOrderItemsFilter" Style="display: none"
        Width="570px">
        <div class="Purchaseheader" id="Div3" runat="server">
            Update GRN Information
        </div>
        <div class="content" style="margin-left: 10px">
            <table style="width: 550px; border-collapse: collapse">
                <tr>
                    <td style="width: 100px; text-align: right">GRN No. :&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:Label ID="lblGRN" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                    <td style="width: 100px">&nbsp;
                    </td>
                    <td style="width: 175px">&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Supplier Name :&nbsp;
                    </td>
                    <td style="width: 175px" colspan="3">
                        <asp:DropDownList ID="ddlVendorGRN" Width="384px" runat="server"></asp:DropDownList>
                    </td>

                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Invoice No. :&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:TextBox ID="txtInfoInvoiceNo" runat="server"
                            Width="100px" MaxLength="50" />
                    </td>
                    <td style="width: 100px; text-align: right">Invoice&nbsp;Date :&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:TextBox ID="txtucInvoiceDate" runat="server" ClientIDMode="Static" Width="100px">
                        </asp:TextBox>
                        <cc1:CalendarExtender ID="CaltxtucInvoiceDate" TargetControlID="txtucInvoiceDate"
                            Format="dd-MMM-yyyy" runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Challan No. :&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:TextBox ID="txtInfoChalanNo" runat="server" Width="100px" MaxLength="50" />
                    </td>
                    <td style="width: 100px; text-align: right">Challan&nbsp;Date :&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:TextBox ID="txtucChalanDate" runat="server" ClientIDMode="Static" Width="100px">
                        </asp:TextBox>
                        <cc1:CalendarExtender ID="CaltxtucChalanDate" TargetControlID="txtucChalanDate" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right; display: none;">
                        <asp:Label ID="lblFright" Style="width: 100px;" runat="server" class="labelForTag"
                            Text="Freight :&nbsp;"></asp:Label>
                    </td>
                    <td style="width: 175px; display: none;">
                        <asp:TextBox ID="txtFright" runat="server" Width="100px"
                            onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                            MaxLength="9" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtFright"
                            FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 100px; text-align: right">
                        <asp:Label ID="lblRoundOff" Style="width: 100px;" runat="server" class="labelForTag"
                            Text="Round Off :&nbsp;"></asp:Label>
                    </td>
                    <td style="width: 175px">
                        <asp:TextBox ID="txtRoundOff" runat="server" Width="100px"
                            MaxLength="9" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" TargetControlID="txtRoundOff"
                            FilterType="Custom, Numbers" ValidChars=".-">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 100px; text-align: right">GRN Amount :&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:Label ID="lblGRNAmt" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right; display: none;">
                        <asp:Label ID="lblOctori" Style="width: 100px;" runat="server" class="labelForTag"
                            Text="Octroi/Other :&nbsp;"></asp:Label>
                    </td>
                    <td style="width: 175px; display: none;">
                        <asp:TextBox ID="txtOctori" runat="server" Width="100px"
                            onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                            MaxLength="8" />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtOctori"
                            FilterType="Custom, Numbers" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>

                </tr>
                <tr>
                    <td style="width: 100px; text-align: right">Gate&nbsp;Entry&nbsp;No.&nbsp;:&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:TextBox ID="txtGNEntryNo" runat="server" Width="100px" />
                    </td>
                    <td style="width: 100px; text-align: right">Invoice&nbsp;Amount :&nbsp;
                    </td>
                    <td style="width: 175px">
                        <asp:Label ID="lblBillAmt" runat="server" CssClass="ItDoseLabelSp" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px; text-align: right; vertical-align: top">Narration :&nbsp;
                    </td>
                    <td colspan="3" style="width: 450px">
                        <asp:TextBox ID="txtnarration" runat="server" TextMode="multiLine" Width="400" Height="60">
                        </asp:TextBox>&nbsp;<span style="color: Red; font-size: 10px">*</span>
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Label ID="lblNarUpdate" runat="server" CssClass="ItDoseLblError"></asp:Label>&nbsp;
            <asp:Button ID="btnInfoUpdate" runat="server" CssClass="ItDoseButton" Text="Update"
                OnClick="btnInfoUpdate_Click" OnClientClick="return Validateinfo();" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnInfoCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" />&nbsp;
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpGRNInfo" runat="server" CancelControlID="btnInfoCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="Panel2" PopupDragHandleControlID="Div3">
    </cc1:ModalPopupExtender>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true"
        ShowSummary="false" ValidationGroup="GRNUpdate" />
    <asp:ValidationSummary ID="vs1" runat="server" ShowMessageBox="true" ShowSummary="false"
        ValidationGroup="GRNCacnel" />
    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="true"
        ShowSummary="false" ValidationGroup="ItemCacnel" />

    <%-- Add Item--%>
    <div id="divAddItem">
        <asp:Panel ID="pnlAddItem" runat="server" CssClass="pnlFilter" Width="1020px" Style="display: none;">
            <div class="Purchaseheader" id="Div5" runat="server">
                Add GRN Item
            </div>
            <div class="content" style="margin-left: 10px; width: 1010px;">
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <table style="width: 1000px; border-collapse: collapse">

                    <tr>
                        <td style="width: 100px; text-align: right">GRN No :&nbsp;
                        </td>
                        <td>
                            <asp:Label ID="lblIGRNNo" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                            <asp:Label ID="lblIInvoiceNo" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" Style="display: none"></asp:Label>
                            <asp:Label ID="lblIInvoiceDate" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" Style="display: none"></asp:Label>
                            <asp:Label ID="lblIVenLedgerNo" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" Style="display: none"></asp:Label>
                            <asp:Label ID="lblIStoreLedgerNo" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static" Style="display: none"></asp:Label>
                        </td>

                        <td style="width: 100px; text-align: right">TaxCalOn :&nbsp; </td>
                        <td colspan="3">
                            <asp:RadioButtonList ID="rblTaxCal" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" Style="font-size: 10px;">
                                <asp:ListItem Text="MRP" Value="MRP"></asp:ListItem>
                                <asp:ListItem Text="Rate" Value="Rate" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="RateAD" Value="RateAD"></asp:ListItem>
                                <asp:ListItem Text="Rate Rev." Value="RateRev"></asp:ListItem>
                            </asp:RadioButtonList></td>
                    </tr>

                    <tr>
                        <td style="width: 100px; text-align: right; height: 18px;">Item Name :&nbsp;
                        </td>
                        <td style="width: 160px; height: 18px;">
                            <asp:TextBox ID="txtIItemName" runat="server" CssClass="ItDoseTextinputNum" Width="160px" ClientIDMode="Static" />
                        </td>
                        <td colspan="4" style="height: 18px">
                            <asp:Label ID="lblIItemName" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" style="text-align: right; height: 18px; display: none">
                            <asp:Label ID="lblIItemID" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 100px; text-align: right">Rate :&nbsp;
                        </td>
                        <td style="width: 160px">
                            <asp:TextBox ID="txtIRate" runat="server" CssClass="ItDoseTextinputNum" MaxLength="12" Width="100px" ClientIDMode="Static" />
                            <asp:RequiredFieldValidator ID="rqrate" runat="server" ErrorMessage="Rate Required!"
                                ControlToValidate="txtIRate" Display="none" SetFocusOnError="true" ValidationGroup="Items"> </asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtIRate"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 100px; text-align: right">Seling Price :&nbsp;</td>
                        <td style="width: 160px; text-align: left">
                            <asp:TextBox ID="txtIMRP" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" decimalPlace="2" max-value="100" MaxLength="6" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" Width="100px"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rqmrp" runat="server" ErrorMessage="MRP Required!"
                                ControlToValidate="txtIMRP" Display="none" SetFocusOnError="true" ValidationGroup="Items"> </asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtIMRP"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>



                        <td style="width: 160px; text-align: left">GST Type :</td>
                        <td style="width: 160px; text-align: left" valign="top">
                            <asp:DropDownList ID="ddlIGSTType" runat="server" CssClass="ItDoseDropdownbox" onchange="GSTTypeChange();" Width="110px" Height="20px" ClientIDMode="Static">
                            </asp:DropDownList>
                        </td>



                    </tr>
                    <tr>
                        <td style="text-align: right; width: 100px;">&nbsp;Quantity :&nbsp;
                        </td>
                        <td style="text-align: left; width: 160px;">
                            <asp:TextBox ID="txtIQuantity" runat="server" CssClass="ItDoseTextinputNum" MaxLength="12" Width="100px" ClientIDMode="Static" />
                            <asp:RequiredFieldValidator ID="rqqty" runat="server" ErrorMessage="MRP Required!"
                                ControlToValidate="txtIQuantity" Display="none" SetFocusOnError="true" ValidationGroup="Items"> </asp:RequiredFieldValidator>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtIQuantity"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 110px; text-align: right">Batch No :&nbsp;
                        </td>
                        <td style="width: 160px; text-align: left">
                            <asp:TextBox ID="txtIBatchNo" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" decimalPlace="2" max-value="100" MaxLength="12" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" Width="100px"> </asp:TextBox>
                        </td>
                        <td style="width: 160px; text-align: left">IGST(%) :</td>
                        <td style="width: 160px; text-align: left">
                            <asp:TextBox ID="txtIIGSTPer" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" decimalPlace="2" max-value="100" MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" Width="100px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtIIGSTPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 100px; text-align: right">Disc(%) :&nbsp;
                        </td>
                        <td style="width: 160px">

                            <asp:TextBox ID="txtIDiscPer" runat="server" CssClass="ItDoseTextinputNum" MaxLength="12" Width="100px" ClientIDMode="Static" />

                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtIDiscPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align: right; width: 100px;">&nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtIDiscAmt" runat="server" CssClass="ItDoseTextinputNum" MaxLength="12" Width="100px" Style="display: none" ClientIDMode="Static" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender10" runat="server" TargetControlID="txtIDiscAmt"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>


                        <td style="text-align: left">CGST(%) :&nbsp;&nbsp;</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtICGSTPer" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" decimalPlace="2" max-value="100" MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" Width="100px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender12" runat="server" TargetControlID="txtICGSTPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>


                    </tr>


                    <tr>
                        <td style="width: 100px; text-align: right">Expiry Date:&nbsp;
                        </td>
                        <td style="width: 160px">

                            <asp:TextBox ID="txtIExpiryDate" runat="server" CssClass="ItDoseTextinputNum" Width="100px" ClientIDMode="Static" />
                            <cc1:CalendarExtender ID="Iexpdate" TargetControlID="txtIExpiryDate" Format="dd-MM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="text-align: right; width: 100px;">
                            <asp:Label ID="lbldeal11" runat="server" CssClass="ItDoseLabelSp" Text="Is Deal :" Width="80px"></asp:Label>
                            &nbsp;
                        </td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtIDeal1" ClientIDMode="Static" runat="server" Width="30px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                            <asp:Label ID="Label2" runat="server" Text="+ " Width="5px" CssClass="ItDoseLabelSp"></asp:Label>
                            <asp:TextBox ID="txtIDeal2" ClientIDMode="Static" runat="server" Width="30px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender13" runat="server" TargetControlID="txtIDeal1"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender14" runat="server" TargetControlID="txtIDeal2"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>

                        </td>


                        <td style="text-align: left">SGST(%) :</td>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtISGSTPer" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" decimalPlace="2" max-value="100" MaxLength="8" onkeypress="return checkForSecondDecimal(this,event)" onlyNumber="5" Width="100px"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender15" runat="server" TargetControlID="txtISGSTPer"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>


                    </tr>

                    <tr>
                        <td style="width: 100px; text-align: right; height: 10px;">Co.&nbsp;Factor&nbsp;:&nbsp;</td>
                        <td style="width: 160px; height: 10px;">
                            <asp:Label ID="lblICoFactor" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                        </td>
                        <td style="width: 100px; text-align: right; height: 10px;">&nbsp;Is Free :&nbsp;
                        </td>
                        <td style="width: 160px; height: 10px;">
                            <input type="checkbox" id="IsFreeItem" />Yes
                        </td>

                        <td style="width: 160px; height: 10px;">HSNCode :</td>
                        <td style="width: 160px; height: 10px;">
                            <asp:TextBox ID="txtIHSNCode" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" MaxLength="10" onlyNumber="10" Width="100px"></asp:TextBox>
                        </td>

                    </tr>
                    <tr>
                        <%-- <td style="text-align: right; width: 100px;">Excise(%) :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblExcisePer" runat="server" CssClass="ItDoseLabelSp" />
                    </td>--%>
                        <td style="width: 100px; text-align: right; height: 17px;">Pur.Unit&nbsp;:&nbsp;
                        </td>
                        <td style="width: 160px; text-align: left; height: 17px;">
                            <asp:Label ID="lblIPurUnit" runat="server" CssClass="ItDoseLabelSp" ClientIDMode="Static"></asp:Label>
                        </td>
                        <td style="text-align: right; width: 100px; height: 17px;">&nbsp;Sale.Unit&nbsp;:&nbsp;
                        </td>
                        <td style="text-align: left; height: 17px;">
                            <asp:Label ID="lblISaleUnit" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                        </td>
                        <td style="text-align: left; height: 17px;"></td>
                        <td style="text-align: left; height: 17px;"></td>
                    </tr>

                </table>
                <div class="filterOpDiv" style="text-align: left">

                    <input type="button" id="btnAddItem" value="ADD" tabindex="38" class="ItDoseButton" />
                    &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelPopUp" runat="server" CssClass="ItDoseButton" Text="Cancel"
                CausesValidation="false" ClientIDMode="Static" />&nbsp;
                </div>
                <div id="divGRN" style="max-height: 200px; overflow-y: auto; overflow-x: hidden;">
                    <table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                        <tr id="GRNHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width: 70px; text-align: left; display: none;">Item ID</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 220px; text-align: left">Item Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">MRP</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">Rate</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">Qty.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">DiscPer</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">BatchNo</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left;">Free</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">Co.Factor</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">Pur. Unit</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">Sale Unit</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">Is Expirable</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">Expiry Date</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">Deal1</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">Deal2</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left;">TaxCalOn</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">GST Type</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left; display: none;">HSN Code</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">IGST(%)</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">CGST(%)</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: left">SGST(%)</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align: left"></th>
                        </tr>

                    </table>
                </div>
                <hr />
                <div class="filterOpDiv" style="text-align: center">
                    <input type="button" id="btnUpdateGRN" class="ItDoseButton" style="display: none" value="Save" onclick="UpdateGRN()" />
                </div>
            </div>

        </asp:Panel>
    </div>
    <%-- <cc1:ModalPopupExtender ID="mpAddItem" runat="server" CancelControlID="btnCancelPopUp"
        DropShadow="true" TargetControlID="btnAddGRNItem" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddItem" PopupDragHandleControlID="divAddItem">
    </cc1:ModalPopupExtender>--%>
    <cc1:ModalPopupExtender ID="mpAddItem" BehaviorID="mpAddItem" runat="server" DropShadow="true" X="150" Y="50" TargetControlID="btnAddGRNItem" CancelControlID="btnCancelPopUp" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddItem" Drag="true" PopupDragHandleControlID="divAddItem">
    </cc1:ModalPopupExtender>


    <%--Add Item End--%>

    <script type="text/javascript">
        var onEditConsignment = function (el) {

            var ConsignmentNo = Number($(el).closest('tr').find('#lblConsignmentNo').text());
            //var billNo = ($(el).closest('tr').find('#_lblBillNo').text());
            window.location.href = 'ConsignmentReceive.aspx?consignmentNo=' + ConsignmentNo;

        }
    </script>
</asp:Content>
