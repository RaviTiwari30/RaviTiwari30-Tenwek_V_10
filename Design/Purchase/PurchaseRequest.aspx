<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="PurchaseRequest.aspx.cs" Inherits="Design_Purchase_PurchaseRequest" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .ui-state-focus {
            /*background: none !important;*/
            background-color: #c6dff9 !important;
            border: none !important;
        }

        .ui-menu-item {
            width: 370px;
            max-width: 370px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .ui-widget-content {
            border-radius: 5px;
        }

        #toast-container > div {
            width: auto;
            min-width: 351px;
            opacity: 1;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtSearch').focus();
            $('[id$=txtNarration]').val('');
        });

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
        function EnterKeyExecute(sender, e) {
            if ($('[id$=txtCurrentReqQty]').val() != null && $('[id$=txtCurrentReqQty]').val() != "0" && $('[id$=txtCurrentReqQty]').val() != "") {
                if (e.keyCode === 13) {
                    $("#btnAddItem").click();
                }
            }
            else {
                $('[id$=txtCurrentReqQty]').val('');
                $('[id$=txtQuantity]').val('');
                return false;
            }
        }
        function validatedot() {
            if (($("#<%=txtQuantity.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtQuantity.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtQuantity.ClientID%>").val().charAt(0) == "0")) {
                $("#<%=txtQuantity.ClientID%>").val('');
                return false;
            }
            if ($(".GridViewStyle").find(".ItDoseTextinputNum").val() != null) {
                if (($(".GridViewStyle").find(".ItDoseTextinputNum").val().charAt(0) == ".")) {
                    $(".GridViewStyle").find(".ItDoseTextinputNum").val('');
                    return false;
                }
            }
            return true;
        }

        $(document).ready(function () {
            var MaxLength = 100;
            $("#<% =txtSpecification.ClientID %>,#<% =txtNarration.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtSpecification.ClientID%>').bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }
                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });
        $(document).ready(function () {
            var MaxLengthNar = 250;
            $('#<%=txtNarration.ClientID%>').bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }
                if ($(this).val().length >= MaxLengthNar) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });

        function validate() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }


    </script>
    <script type="text/javascript">
<!--
    function wopen(url, name, w, h) {
        // Fudge factors for window decoration space.
        // In my tests these work well on all platforms & browsers.
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

        function checkItem() {
            if ($("#<%=ddlItem.ClientID %> option:selected").text() == "") {
                DisplayMsg('MM018', '<%=lblMsg.ClientID %>');
                $("#<%=ddlItem.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtCurrentReqQty.ClientID %>").val().trim() == "" || $("#<%=txtCurrentReqQty.ClientID %>").val() == "0") {
                $("#<%=lblMsg.ClientID %>").text('Current Request Quantity Must Be Greater than Zero.');
                $("#<%=txtCurrentReqQty.ClientID %>").focus();
                $("#<%=txtCurrentReqQty.ClientID %>").val('');
                return false;
            }
            if ($("#<%=txtQuantity.ClientID %>").val().trim() == "" || $("#<%=txtQuantity.ClientID %>").val() == "0") {
                $("#<%=lblMsg.ClientID %>").text('Please Specify Quantity.');
                $("#<%=txtQuantity.ClientID %>").focus();
                return false;
            }
        }
        $(document).ready(function () {
            $onInit();
        });
        $onInit = function () {
            $('#txtSearch').autocomplete({
                source: function (request, response) {
                    $DeptLedgerNo = $('[id$=hdnDeptledgerNo]').val();
                    $StoreId = $('#<%=ddlStore.ClientID %>').val();
                    if ($('#<%=chkNormItems.ClientID %>').is(':checked') == true) {
                        $chkNormItems = "True";
                    }
                    else
                        $chkNormItems = "false";
                    $bindItems({ StoreId: $StoreId, chkNormItems: $chkNormItems, DeptLedgerNo: $DeptLedgerNo, PreFix: request.term }, function (responseItems) {
                        response(responseItems)
                    });
                },
                select: function (e, i) {
                    $validateInvestigation(i, function () { });
                },
                close: function (el) {
                    el.target.value = '';
                    $("#<%=txtCurrentReqQty.ClientID %>").focus();
                },
                minLength: 2
            });
        };
        $bindItems = function (data, callback) {
            serverCall('Services/PurchaseRequest.asmx/LoadAllItem', data, function (response) {
                if (response == "No Item Found") {
                    alert(response);
                    $('#txtSearch').val('');
                    return false;
                }
                else {
                    var responseData = $.map(JSON.parse(response), function (item) {
                        return {
                            label: item.ItemName,
                            val: item.ItemID,
                            Typename: item.Typename,
                            Index: item.selectindex
                        }
                    });
                }
                callback(responseData);
            });
        };
        $validateInvestigation = function (ctr, callback) {
            if (ctr.item.val.trim() != "") {
                var strItem = ctr.item.val;
                if ((strItem != null) && (strItem != "0.00")) {
                    var ItemId = strItem.split('#')[0];
                    if (ItemId != null && ItemId != "") {
                        BindPurchaseOrderDetail(ItemId);
                        CurrentStock(ItemId);
                        MainStock(ItemId);
                    }
                    $('[id$=lblItemName]').text(ctr.item.label);
                    $('[id$=lblItemName]').val(strItem);
                    $('#<%=HdnIndex.ClientID %>').val(ctr.item.Index);

                    $('#<%=txtCurrentReqQty.ClientID %>,#<%=txtQuantity.ClientID %>').val(Math.round(strItem.split('#')[3]));
                    $('#<%=txtActualMin.ClientID %>').val(strItem.split('#')[4]);
                    $('#<%=txtActualMax.ClientID %>').val(strItem.split('#')[5]);

                    $('#lblMinimum').text(strItem.split('#')[4]);
                    $('#lblMaximun').text(strItem.split('#')[5]);
                    $('[id$=lblMajorUnit]').text(strItem.split('#')[2]);

                    if ((parseFloat($('#txtActualMin').val()) == 0) && (parseFloat($('#txtActualMax').val()) == 0)) {
                        $("#ddlDecIncQty").prop('selectedIndex', 0).attr("disabled", true);
                        $('#txtActualMin,#txtActualMax').attr("disabled", true);
                    }
                    else {
                        $("#ddlDecIncQty").prop('selectedIndex', 0).removeAttr("disabled");
                        $('#txtActualMin,#txtActualMax').removeAttr("disabled");
                    }
                    if ((parseFloat($('#txtActualMax').val()) == 0)) {
                        $("#ddlDecIncQty option[value='1']").attr('disabled', 'disabled');
                        $('#txtActualMin,#txtActualMax').attr("disabled", true);
                    }
                    else {
                        $("#ddlDecIncQty option[value='1']").removeAttr('disabled');
                        $('#txtActualMin,#txtActualMax').removeAttr("disabled");
                    }
                    if ((parseFloat($('#txtActualMin').val()) == 0)) {
                        $("#ddlDecIncQty option[value='2']").attr('disabled', 'disabled');
                        $('#txtActualMin,#txtActualMax').attr("disabled", true);
                    }
                    else {
                        $("#ddlDecIncQty option[value='2']").removeAttr('disabled');
                        $('#txtActualMin,#txtActualMax').removeAttr("disabled");
                    }
                    if ($('#<%=txtCurrentReqQty.ClientID %>').val() == "0") {
                        $('#<%=txtCurrentReqQty.ClientID %>').removeAttr("readonly")
                        $("#<%=txtCurrentReqQty.ClientID %>").val('');
                        // $("#<%=txtCurrentReqQty.ClientID %>").focus();
                        return false;
                    }
                    else {
                        //$('#<%=txtCurrentReqQty.ClientID %>').attr('readonly', 'readonly')
                        $('#<%=txtCurrentReqQty.ClientID %>').removeAttr("readonly")
                        // $("#<%=txtCurrentReqQty.ClientID %>").focus();
                    }
                }
                else {
                    $('#lblMaximun,#lblMinimum').text(0);
                    return false;
                }
            }
        };
        function RemoveRow(ctr) {
            if (confirm('Are you sure want to delete this Item!')) {
                var RowId = $(ctr).closest('tr').find('[id$=tdIndex]').text();
                RowId = RowId - 1;
                $.ajax({
                    type: "POST",
                    timeout: 120000,
                    url: "PurchaseRequest.aspx/DeleteRow",
                    data: '{ RowId: "' + RowId + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d == "") {
                            $('#DivItemDetails').html('');
                            $('[id$=SaveAllItem]').prop('disabled', true);
                            $('[id$=DivReqDetails]').css('display', 'none');
                            $('[id$=DivReqNarration]').css('display', 'none');
                            $('#txtSearch').focus();
                        }
                        else {
                            ItemDetails = JSON.parse(data.d);
                            if (ItemDetails.length > 0) {
                                var output = $('#tb_ItemDetails').parseTemplate(ItemDetails);
                                if (output != "" && output != null) {
                                    $('#DivItemDetails').html(output).customFixedHeader();
                                    $('#txtSearch').focus();
                                    $('[id$=SaveAllItem]').prop('disabled', false);
                                    $('[id$=DivReqDetails]').css('display', '');
                                    $('[id$=DivReqNarration]').css('display', '');
                                }
                                else {
                                    $('#DivItemDetails').html('');
                                    $('#txtSearch').focus();
                                    $('[id$=DivReqDetails]').css('display', 'none');
                                    $('[id$=DivReqNarration]').css('display', 'none');
                                    $('[id$=SaveAllItem]').prop('disabled', true);
                                }
                            }
                            else {
                                $('#DivItemDetails').html('');
                                $('#txtSearch').focus();
                                $('[id$=DivReqDetails]').css('display', 'none');
                                $('[id$=DivReqNarration]').css('display', 'none');
                                $('[id$=SaveAllItem]').prop('disabled', true);
                            }
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
                return false;
            }
            else {
                $('#txtSearch').focus();
                return false;
            }
        }

        function AddItems() {
            if ($('[id$=lblItemName]').val() == ""||$('[id$=lblItemName]').val() == null) {
                alert('Please Select Item');
                return false;
            }
            if ($('[id$=txtQuantity]').val().trim() == "" || $('[id$=txtQuantity]').val().trim()=="0") {
                alert('Please Specify Quantity');
                return false;
            }
            else {
                var StoreId = $('[id$=ddlStore] option:selected').val();
                var Quantity = $('[id$=txtQuantity]').val()
                var ItemId = $('[id$=lblItemName]').val();
                var ItemName = $('[id$=lblItemName]').text();
                var Purpose = $('[id$=txtPurpose]').val();
                var Specification = $('[id$=txtSpecification]').val();
                var Index = parseInt($('[id$=HdnIndex]').val());
                var data = {
                    StoreId: StoreId,
                    ItemId: ItemId,
                    ItemName: ItemName,
                    Quantity: Quantity,
                    Purpose: Purpose,
                    Specification: Specification,
                    Index: Index
                }
                $.ajax({
                    type: "POST",
                    timeout: 120000,
                    url: "PurchaseRequest.aspx/AddItems",
                    data: JSON.stringify(data),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d == "1") {
                            alert("Items cannot be added of different ItemType at one time");
                            return false;
                            $('#<%=lblMsg.ClientID %>').text('');
                        }
                        if (data.d == "2") {
                            alert("Item Already Selected");
                            return false;
                            $('#<%=lblMsg.ClientID %>').text('');
                        }
                        else {
                            if (data.d != "") {
                                ItemDetails = JSON.parse(data.d);
                                if (ItemDetails.length > 0) {
                                    var output = $('#tb_ItemDetails').parseTemplate(ItemDetails);
                                    if (output != "" && output != null) {
                                        $('#DivItemDetails').html(output).customFixedHeader();
                                        $('[id$=DivReqDetails]').css('display', 'block');
                                        $('[id$=DivReqNarration]').css('display', 'block');
                                        $('[id$=txtQuantity]').val('')
                                        $('[id$=lblItemName]').val('');
                                        $('[id$=lblItemName]').text('');
                                        $('[id$=txtPurpose]').val('');
                                        $('[id$=txtSpecification]').val('');
                                        $('[id$=HdnIndex]').val('');
                                        $('[id$=txtCurrentReqQty]').val('');
                                        $('[id$=lblLastMonth]').text('');
                                        $('[id$=lbldeptstock]').text('');
                                        $('[id$=lblMajorUnit]').text('');
                                        $('[id$=lblPostock]').text('');
                                        $('[id$=lblMaximun]').text('');
                                        $('[id$=lblMinimum]').text('');
                                        $('#txtSearch').focus();
                                        $('[id$=SaveAllItem]').prop('disabled', false);
                                    }
                                    else {
                                        $('#DivItemDetails').html('');
                                        $('[id$=DivReqDetails]').css('display', 'none');
                                        $('[id$=DivReqNarration]').css('display', 'none');
                                    }
                                }
                                else {
                                    $('#DivItemDetails').html('');
                                    $('#<%=lblMsg.ClientID %>').text('');
                                    $('[id$=DivReqDetails]').css('display', 'none');
                                    $('[id$=DivReqNarration]').css('display', 'none');
                                    $('[id$=SaveAllItem]').prop('disabled', true);
                                }
                            }
                        }
                       
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                    }
                });
            }
        }
        function SaveAllItem() {
            $('[id$=btnSaveAllItem]').val('Submitting');
            var StoreId = $('[id$=ddlStore] option:selected').val();
            var Narration = $('[id$=txtNarration]').val()
            var DepartMent = $('[id$=ddlDept]').val();
            var RequestType = $('[id$=ddlRequestType] option:selected').text()
            var ledgerNo = $('[id$=ddlDept]').val();
            var Bydate = $('[id$=Date]').val();
            var chkprnt = "";
            if ($('#<%=chkprnt.ClientID %>').is(':checked') == true) {
                chkprnt = "True";
            }
            else
                chkprnt = "false";
            var data = {
                chkprnt: chkprnt,
                StoreId: StoreId,
                Narration: Narration,
                RequestType: RequestType,
                DepartMent: DepartMent,
                Bydate: Bydate,
                ledgerNo: ledgerNo
            }
            $.ajax({
                type: "POST",
                timeout: 120000,
                url: "PurchaseRequest.aspx/SaveAllDetails",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    if (data.d != null && data.d != "") {
                        if (chkprnt == "True" && data.d != "") {
                            var PRNo = data.d;
                            alert('Request No. : ' + PRNo + '');
                            window.open('PRReport.aspx?PRNumber=' + PRNo + '');
                            location.reload(true);
                        }
                        else if (chkprnt == "false" && data.d != "") {
                            var PRNo = data.d;
                            alert('Request No. : ' + PRNo + '');
                            $('[id$=DivReqDetails]').css('display', 'none');
                            $('[id$=DivReqNarration]').css('display', 'none');
                            $('[id$=SaveAllItem]').prop('disabled', true);
                            $('[id$=btnSaveAllItem]').val('Save');
                        }
                        else {
                            var status = data.d;
                            if (status == "1" || status == "2" || status == "3" || status == "4") {
                                alert("Record Not Found");
                                $('[id$=DivReqDetails]').css('display', 'none');
                                $('[id$=DivReqNarration]').css('display', 'none');
                                $('[id$=SaveAllItem]').prop('disabled', true);
                                $('[id$=btnSaveAllItem]').val('Save');
                                return false;
                            }
                            if (status == "5" || status == "2") {
                                alert("Add Requested Item");
                                $('[id$=DivReqDetails]').css('display', 'none');
                                $('[id$=DivReqNarration]').css('display', 'none');
                                $('[id$=SaveAllItem]').prop('disabled', true);
                                $('[id$=btnSaveAllItem]').val('Save');
                                return false;
                            }
                            else {
                                $('[id$=DivReqDetails]').css('display', 'none');
                                $('[id$=DivReqNarration]').css('display', 'none');
                                $('[id$=SaveAllItem]').prop('disabled', true);
                                $('[id$=btnSaveAllItem]').val('Save');
                            }
                        }
                        $('[id$=txtNarration]').val('');
                    }
                    else {
                        $('[id$=DivReqDetails]').css('display', 'none');
                        $('[id$=DivReqNarration]').css('display', 'none');
                        $('[id$=SaveAllItem]').prop('disabled', true);
                        $('[id$=btnSaveAllItem]').val('Save');
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
 }
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <asp:HiddenField ID="hdnDeptledgerNo" runat="server" />
        <asp:HiddenField ID="HdnIndex" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Purchase Request<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></b>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Requisition Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlRequestType" ToolTip="Select Requisition Type" AutoPostBack="false" runat="server"
                                Width="100px" OnSelectedIndexChanged="ddlRequestType_SelectedIndexChanged" />
                            <asp:TextBox ID="Date" Visible="true" runat="server" ClientIDMode="Static"
                                CssClass="ItDoseTextinputText" Width="115px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="Date">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" ToolTip="Select For Department" runat="server" Width="">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStore" runat="server" AutoPostBack="True" Width="" OnSelectedIndexChanged="ddlStore_SelectedIndexChanged" />
                        </div>
                    </div>
                    <div class="row">
                    </div>
                    <div class="row">
                    </div>
                    <div class="row" style="text-align: center">
                        <asp:Button ID="btnAddItems" runat="server" CausesValidation="False"
                            CssClass="ItDoseButton" Text="Add New" Visible="false" />
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" style="display: none;">
                Items Details<a href="javascript:void(0);" onclick="window.open('getMultipleItem.aspx','getMultipleItem','width=900,height=500,toolbar=1,resizable=0,scrollbars=1');">Add
                    Multiple Item</a>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" style="display: none;">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search&nbsp;By&nbsp;First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFirstNameSearch" runat="server" Width="" AutoCompleteType="disabled" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Any Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInBetweenSearch" runat="server" AutoCompleteType="Disabled"
                                Width="" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtSearch" tabindex="1" title="Enter Search text" />
                            <asp:DropDownList Visible="false" ID="ddlItem" TabIndex="1" runat="server"
                                onchange="LoadDetail();" ToolTip="Select Item">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkNormItems" runat="server" Text="Norms Item" AutoPostBack="true" OnCheckedChanged="chkNormItems_CheckedChanged" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Current Stock
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:Label ID="lblLastMonth" runat="server" ClientIDMode="Static" ForeColor="Blue"></asp:Label>
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
                            <label id="lblItemName" title="Enter Search Text"></label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purchase Unit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblMajorUnit" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department Stock
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lbldeptstock" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Current&nbsp;Req.&nbsp;Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCurrentReqQty" TabIndex="2" Style="text-align: left" runat="server" CssClass="ItDoseTextinputNum requiredField" Width="" ToolTip="Enter Quantity"
                                ValidationGroup="Items" AutoCompleteType="Disabled" MaxLength="7" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();claculateQty();EnterKeyExecute(this,event);"> </asp:TextBox>
                            <span style="color: red; font-size: 10px;" class="shat"></span>
                            <cc1:FilteredTextBoxExtender ID="ftbCurrentQty" runat="server" TargetControlID="txtCurrentReqQty" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Maximum
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-1">
                            <asp:Label ID="lblMaximun" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Minimum
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:Label ID="lblMinimum" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                PO Stock
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblPostock" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Quantity <b>+/- </b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDecIncQty" Width="149px" runat="server" ClientIDMode="Static" onchange="checkDecIncQty()" Enabled="false">
                                <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                <asp:ListItem Text="+" Value="1"></asp:ListItem>
                                <asp:ListItem Text="-" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtDecIncQty" ClientIDMode="Static" Width="70px" Enabled="false" MaxLength="5" onkeyup="claculateQty()" onkeypress="return checkForSecondDecimal(this,event)" AutoCompleteType="Disabled" runat="server" CssClass="ItDoseTextinputNum"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbDecIncQty" runat="server" TargetControlID="txtDecIncQty" ValidChars=".0123456789"></cc1:FilteredTextBoxExtender>
                            <asp:TextBox ID="txtActualMin" Width="20px" Style="display: none" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"></asp:TextBox>
                            <asp:TextBox ID="txtActualMax" Width="20px" Style="display: none" ClientIDMode="Static" runat="server" CssClass="ItDoseTextinputNum"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSpecification" runat="server" ToolTip="Enter Remarks"
                                Width="" TextMode="MultiLine" ValidationGroup="Items" AutoCompleteType="Disabled" MaxLength="200" />
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
                            <asp:TextBox ID="txtQuantity" runat="server" Style="text-align: left" CssClass="ItDoseTextinputNum requiredField" Width="" ToolTip="Enter Quantity"
                                ValidationGroup="Items" AutoCompleteType="Disabled" MaxLength="7" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"> </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftb2" runat="server" FilterType="Custom, Numbers"
                                FilterMode="validChars" ValidChars="." TargetControlID="txtQuantity">
                            </cc1:FilteredTextBoxExtender>
                            <span style="color: red; font-size: 10px;" class="shat"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purpose
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPurpose" runat="server" ToolTip="Enter Purpose" Width=""
                                AutoCompleteType="Disabled" MaxLength="100" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom,LowercaseLetters,UppercaseLetters"
                                FilterMode="validChars" ValidChars="., " TargetControlID="txtPurpose">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row" style="text-align: center">
                        <input type="button" id="btnAddItem" onclick="return AddItems();" value="Add" />
                        <asp:Button ID="btnSaveItems" Visible="false" ToolTip="Click To Add" ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="3" runat="server" Text="Add" OnClientClick="return checkItem()" OnClick="btnSaveItems_Click" />
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div style="margin-left: 12%; text-align: center">
            </div>
        </div>

        <div class="POuter_Box_Inventory" id="DivReqDetails" style="display: none;">
            <div class="Purchaseheader">
                Request Details
            </div>
            <div style="display: none;">
                <a style="font-weight: bold;" visible="false" href="../Store/itemMaster.aspx?Mode=1"
                    target="_blank" onclick="wopen('../Store/itemMaster.aspx?Mode=1', 'popup', 950, 450); return false;">Create New Items</a>
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;
                <asp:LinkButton ID="lnkNewItems" Visible="false" runat="server" Text="Refresh Items"
                    Font-Bold="True" OnClick="lnkNewItems_Click" />
            <br />
            <div id="DivItemDetails" style="height: 200px; width: 100%; overflow-y: scroll;">
            </div>
            <asp:GridView ID="gvRequestItems" Visible="false" runat="Server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                OnRowCommand="gvRequestItems_RowCommand" Style="width: 100%;">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Item" ItemStyle-Width="200px" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("ItemName")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Remarks" ItemStyle-Width="200px" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("Specification")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Purpose" HeaderStyle-Width="100px" ItemStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("Purpose")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Qty." HeaderStyle-Width="50px" ItemStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("RequiredQty")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Unit" HeaderStyle-Width="70px" ItemStyle-Width="70px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("Unit")%>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Department" HeaderStyle-Width="80px" ItemStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                        Visible="false"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%--<%# Eval("Dept")%>--%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Remove" HeaderStyle-Width="50px" ItemStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                        HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
         <div class="POuter_Box_Inventory" id="DivReqNarration" style="display:none;">
            <div class="Purchaseheader">
                Request Narration
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Narration
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtNarration" runat="server" Width="" TextMode="MultiLine"
                                ToolTip="Enter Narration" ValidationGroup="PR" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            Print
            <input id="chkprnt" runat="server" type="checkbox" />

              <input type="button" id="btnSaveAllItem" disabled="disabled" onclick="return SaveAllItem();" value="Save" />

            <asp:Button ID="btnSave" CssClass="ItDoseButton" Visible="false" ToolTip="Click To Save" runat="server" Text="Save" ValidationGroup="PR"
                OnClick="btnSave_Click" OnClientClick="return validate();" />&nbsp;
            <asp:Button ID="btnReset" CssClass="ItDoseButton" ToolTip="Click To Reset" runat="server" Text="Reset" CausesValidation="false"
                OnClick="btnReset_Click" />&nbsp;&nbsp;
        </div>
    </div>
    <asp:Button ID="btnAddMulti" runat="server" Text="" CausesValidation="false" OnClick="btnAddMulti_Click"
        Style="display: none;" CssClass="ItDoseButton" />

  <script id="tb_ItemDetails" type="text/html">
	<table  id="tableitemdetails" cellspacing="0" class="yui" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr class="tblTitle" id="Header">
			<th class="GridViewHeaderStyle" scope="col" >S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" >Item</th>
			<th class="GridViewHeaderStyle" scope="col" >Remarks</th>           
			<th class="GridViewHeaderStyle" scope="col" >Purpose</th>
			<th class="GridViewHeaderStyle" scope="col" >Qty.</th>          
			<th class="GridViewHeaderStyle" scope="col" >Unit</th>         
			<th class="GridViewHeaderStyle" scope="col" style="display:none;" >Department</th>
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
						<td class="GridViewLabItemStyle" id="tditemname" style=" text-align:center;" ><#=objRow.ItemName#></td>
						<td class="GridViewLabItemStyle" id="tdspec" style=" text-align:center;"  ><#=objRow.Specification#></td>                       
						<td class="GridViewLabItemStyle" id="tdpurpose" style=" text-align:center;"  ><#=objRow.Purpose#></td>                      
						<td class="GridViewLabItemStyle" id="tdreqqty" style=" text-align:center;"  ><#=objRow.RequiredQty#></td>                     
						<td class="GridViewLabItemStyle" id="tdunit" style=" text-align:center;"  ><#=objRow.Unit#></td>                    
						<td class="GridViewLabItemStyle" id="tddepart" style="display:none" ><#=objRow.Department#></td>
						<td class="GridViewLabItemStyle" id="tddelete" style="text-align:center" >
                            <input type="image" src="../../Images/Delete.gif" onclick="return RemoveRow(this);" />
						</td>                       
			           </tr>            
		<#}        
		#>
			</tbody>      
	 </table> 
   </script>

    <script type="text/javascript">
        function LoadDetail() {
            var strItem = $('#<%=ddlItem.ClientID %>').val();
            //$("#<%=ddlItem.ClientID %>").focus();
            if ((strItem != null) && (strItem != "0.00")) {
                var ItemId = strItem.split('#')[0];
                BindPurchaseOrderDetail(ItemId);
                CurrentStock(ItemId);
                MainStock(ItemId);
                $('#<%=txtCurrentReqQty.ClientID %>,#<%=txtQuantity.ClientID %>').val(Math.round(strItem.split('#')[3]));
                $('#<%=txtActualMin.ClientID %>').val(strItem.split('#')[4]);
                $('#<%=txtActualMax.ClientID %>').val(strItem.split('#')[5]);
                $('#lblMinimum').text(strItem.split('#')[4]);
                $('#lblMaximun').text(strItem.split('#')[5]);
                //$('#lblLastMonth').text(strItem.split('#')[6]);
                $('[id$=lblMajorUnit]').text(strItem.split('#')[2]);
                $("#<%=txtCurrentReqQty.ClientID %>").focus();

                //$('[id$=lbldeptstock]').text(strItem.split('#')[3]);
              if ((parseFloat($('#txtActualMin').val()) == 0) && (parseFloat($('#txtActualMax').val()) == 0)) {
                  $("#ddlDecIncQty").prop('selectedIndex', 0).attr("disabled", true);
                  $('#txtActualMin,#txtActualMax').attr("disabled", true);
              }
              else {
                  $("#ddlDecIncQty").prop('selectedIndex', 0).removeAttr("disabled");
                  $('#txtActualMin,#txtActualMax').removeAttr("disabled");
              }
              if ((parseFloat($('#txtActualMax').val()) == 0)) {
                  $("#ddlDecIncQty option[value='1']").attr('disabled', 'disabled');
                  $('#txtActualMin,#txtActualMax').attr("disabled", true);
              }
              else {
                  $("#ddlDecIncQty option[value='1']").removeAttr('disabled');
                  $('#txtActualMin,#txtActualMax').removeAttr("disabled");
              }
              if ((parseFloat($('#txtActualMin').val()) == 0)) {
                  $("#ddlDecIncQty option[value='2']").attr('disabled', 'disabled');
                  $('#txtActualMin,#txtActualMax').attr("disabled", true);
              }
              else {
                  $("#ddlDecIncQty option[value='2']").removeAttr('disabled');
                  $('#txtActualMin,#txtActualMax').removeAttr("disabled");
              }
              if ($('#<%=txtCurrentReqQty.ClientID %>').val() == "0") {
                    $('#<%=txtCurrentReqQty.ClientID %>').removeAttr("readonly")
                    $("#<%=txtCurrentReqQty.ClientID %>").val('');
                    $("#<%=txtCurrentReqQty.ClientID %>").focus();
                    return false;
                }
                else {
                    //$('#<%=txtCurrentReqQty.ClientID %>').attr('readonly', 'readonly')
                    $('#<%=txtCurrentReqQty.ClientID %>').removeAttr("readonly")
                    $("#<%=txtCurrentReqQty.ClientID %>").focus();
                }
            }
            else {
                $('#lblMaximun,#lblMinimum').text(0);
                return false;
            }
            $("#<%=txtCurrentReqQty.ClientID %>").focus();
            return false;
        }

        function BindPurchaseOrderDetail(ItemId) {
            var Id = ItemId;
            jQuery.ajax({
                url: "PurchaseRequest.aspx/BindPurchaseOrderDetail",
                data: '{ ItemId: "' + Id + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    Subcat = jQuery.parseJSON(result.d);
                    if (Subcat != null) {
                        $('[id$=lblPostock]').text(parseFloat(Subcat[0].ApprovedQty));
                    }
                    else {
                        $('[id$=lblPostock]').text(parseInt('0'));
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function CurrentStock(ItemId) {
            var Id = ItemId;
            jQuery.ajax({
                url: "PurchaseRequest.aspx/CurrentStock",
                data: '{ ItemId: "' + Id + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    Subcat = jQuery.parseJSON(result.d);
                    if (Subcat != null) {
                        $('[id$=lblLastMonth]').text(parseFloat(Subcat[0].CurrentStock));
                    }
                    else {
                        $('[id$=lblLastMonth]').text(parseInt('0'));
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function MainStock(ItemId) {
            var Id = ItemId;
            jQuery.ajax({
                url: "PurchaseRequest.aspx/MainStock",
                data: '{ ItemId: "' + Id + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    Subcat = jQuery.parseJSON(result.d);
                    if (Subcat != null) {
                        $('[id$=lbldeptstock]').text(parseFloat(Subcat[0].MainStock));
                    }
                    else {
                        $('[id$=lbldeptstock]').text(parseInt('0'));
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }

        function claculateQty() {
            if ($("#ddlDecIncQty").val() == "1") {
                var DecIncQty = parseFloat($("#txtDecIncQty").val());
                if (isNaN(DecIncQty) || DecIncQty == "")
                    DecIncQty = 0;
                if (parseFloat(DecIncQty) > parseFloat($('#<%=txtActualMax.ClientID %>').val())) {
                    $('#<%=lblMsg.ClientID %>').text('Maximum ' + $('#<%=txtActualMax.ClientID %>').val() + ' % Increase');
                    $("#txtDecIncQty").val('');
                    $('#<%=txtQuantity.ClientID %>').val($('#<%=txtCurrentReqQty.ClientID %>').val());
                    return;

                }
                var CurrentReqQty = parseFloat($('#<%=txtCurrentReqQty.ClientID %>').val());
                if (isNaN(CurrentReqQty) || CurrentReqQty == "")
                    CurrentReqQty = 0;
                var qty = 0;
                if (parseFloat($('#<%=txtDecIncQty.ClientID %>').val()) > 0)
                    qty = Math.ceil(parseFloat(parseFloat($('#<%=txtDecIncQty.ClientID %>').val()) * parseFloat(CurrentReqQty)) / 100);
                else
                    qty = 0;

                qty = parseFloat(qty) + parseFloat(CurrentReqQty);
                $('#<%=txtQuantity.ClientID %>').val(qty);
            }

            else if ($("#ddlDecIncQty").val() == "2") {
                var DecIncQty = parseFloat($("#txtDecIncQty").val());
                if (isNaN(DecIncQty) || DecIncQty == "")
                    DecIncQty = 0;
                if (parseFloat(DecIncQty) > parseFloat($('#<%=txtActualMin.ClientID %>').val())) {
                    $('#<%=lblMsg.ClientID %>').text('Minimum ' + $('#<%=txtActualMin.ClientID %>').val() + ' % Decrease');
                    $("#txtDecIncQty").val('');
                    $('#<%=txtQuantity.ClientID %>').val($('#<%=txtCurrentReqQty.ClientID %>').val());
                    return;
                }
                var CurrentReqQty = $('#<%=txtCurrentReqQty.ClientID %>').val();
                if (isNaN(CurrentReqQty) || CurrentReqQty == "")
                    CurrentReqQty = 0;
                var qty = 0;
                if (parseFloat($('#<%=txtDecIncQty.ClientID %>').val()) > 0)
                    qty = Math.ceil(parseFloat(parseFloat($('#<%=txtDecIncQty.ClientID %>').val()) * parseFloat(CurrentReqQty)) / 100);
                else
                    qty = 0;
                qty = parseFloat(CurrentReqQty) - parseFloat(qty);
                $('#<%=txtQuantity.ClientID %>').val(qty);
            }
            else {
                $('#<%=txtQuantity.ClientID %>').val($('#<%=txtCurrentReqQty.ClientID %>').val());
            }
    }
    function checkDecIncQty() {
        if (($("#ddlDecIncQty").val() != "0")) {
            $("#txtDecIncQty").removeAttr('disabled');
        }
        else {
            $("#txtDecIncQty").val('').attr('disabled', 'disabled');
            $('#<%=txtQuantity.ClientID %>').val($('#<%=txtCurrentReqQty.ClientID %>').val())

        }
        claculateQty();
    }

    </script>
</asp:Content>
