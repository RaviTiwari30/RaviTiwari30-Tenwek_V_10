<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" MasterPageFile="~/DefaultHome.master"
    CodeFile="DirectGRN.aspx.cs" Inherits="Design_Store_DirectGRN" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   <script type="text/javascript" src="../../Scripts/Search.js"></script>   
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
     <script type="text/javascript">

         var keys = [];
         var values = [];
         $(document).ready(function () {
             $('#<%=ddlVendor.ClientID%>').chosen();
             $('#<%=ddlDeptLedgerNo.ClientID%>').chosen();
             var options = $('#<% = ListBox1.ClientID %> option');
             $.each(options, function (index, item) {
                 keys.push(item.value);
                 values.push(item.innerHTML);
             });
             $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                 searchByCPTCode('', document.getElementById('<%=txtSearch.ClientID%>'), '', document.getElementById('<%=ListBox1.ClientID%>'), '', values, keys, e);
                 LoadDetail();
                 expiryCon();
             });


         });
    </script>
    <script type="text/javascript">

        $(document).ready(function () {
            $('#<%=lblBDate.ClientID %>').hide();
            $('#<%=lblCDate.ClientID %>').hide();
        });

        function CheckBillDate() {
            if ($('#<%=txtBillNo.ClientID %>').val() != "") {
                $('#<%=lblBDate.ClientID %>').show();
                $('#<%=txtBillDate.ClientID %>').removeAttr('disabled');
            }
            else {
                $('#<%=lblBDate.ClientID %>').hide();
                $('#<%=txtBillDate.ClientID %>').attr('disabled', true);
            }
            if ($('#<%=txtChalanNo.ClientID %>').val() != "") {
                $('#<%=lblCDate.ClientID %>').show();
                $('#<%=txtChalanDate.ClientID %>').removeAttr('disabled');
            }
            else {
                $('#<%=lblCDate.ClientID %>').hide();
                $('#<%=txtChalanDate.ClientID %>').attr('disabled', true);
            }
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

        function ButtonDisable(btn) {

            var narrate = $('#<%=txtNarration.ClientID %>').val();
            narrate = jQuery.trim(narrate);
            if (narrate == "") {
                $('#<%=txtNarration.ClientID %>').val('');
                alert('Enter Narration');
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
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

        function sum(ItemAmt, InvAmt, Freight, Octori, RoundOff) {

            try {
                var _ItemAmt = document.getElementById(ItemAmt).value;
                var _InvAmt = document.getElementById(InvAmt).value;
                var _Freight = document.getElementById(Freight).value;
                var _Octori = document.getElementById(Octori).value;

                var _RoundOff = document.getElementById(RoundOff).value;
                if (trim(_ItemAmt) == '') {
                    _ItemAmt = "0";
                }
                if (trim(_InvAmt) == '') {
                    _InvAmt = "0";
                }
                if (trim(_Freight) == '') {
                    _Freight = "0";
                }
                if (trim(_Octori) == '') {
                    _Octori = "0";
                }

                if (trim(_RoundOff) == '') {
                    _RoundOff = "0";
                }
                var _total = eval(_ItemAmt) + eval(_Freight) + eval(_Octori) + eval(_RoundOff);
                var _TAmt = Math.round(_total * 100) / 100;

                _total = _total;
                var _Round = Math.round((_total - _TAmt) * 100) / 100;
                document.getElementById(InvAmt).value = _total;
            }
            catch (exception) {
            }
        }

        function ValidateDisc() {
            var DiscPer = $('#<%=txtDiscount1.ClientID %>').val();
            var PurTax = $('#<%=txtTAX1.ClientID %>').val();
            var SpclDisc = $('#<%=txtSpclDisc.ClientID %>').val();
            if (Number(DiscPer) > 100) {
                $('#<%=txtDiscount1.ClientID %>').val('');
                alert('Invalid Discount');
            }
            if (Number(PurTax) > 100) {
                $('#<%=txtTAX1.ClientID %>').val('');
                alert('Invalid Purchase Tax');
            }
            if (parseFloat($('#<%=txtDiscAmt.ClientID %>').val()) > parseFloat($('#<%=txtRate1.ClientID %>').val())) {
                $('#<%=txtDiscAmt.ClientID %>').val('');
                alert('Discount Amount Can not be Greater than Rate');
            }

            if (Number(SpclDisc) > 100) {
                $('#<%=txtSpclDisc.ClientID %>').val('');
                alert('Invalid Discount');
            }
        }

        function validateAmt(name) {
            if (name == "txtDiscAmt") {
                if ($('#<%=txtDiscAmt.ClientID %>').val() != "") {
                    $('#<%=txtDiscount1.ClientID %>').val('');
                }
            }
            if (name == "txtDiscount1") {
                if ($('#<%=txtDiscount1.ClientID %>').val() != "") {
                    $('#<%=txtDiscAmt.ClientID %>').val('');
                }
            }
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

        function ValidateDecimal() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtRate1.ClientID%>").val();
            var valIndex = val.indexOf(".");
            if (valIndex > "0") {
                if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
                    alert("Please Enter Valid Cost Price, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");

                    $("#<%=txtRate1.ClientID%>").val($("#<%=txtRate1.ClientID%>").val().substring(0, ($("#<%=txtRate1.ClientID%>").val().length - 1)))
                    return false;
                }
            }
        }
        function ValidateDecimalSellingPrice() {
            var DigitsAfterDecimal = 2;
            var val = $("#<%=txtMRP1.ClientID%>").val();
    var valIndex = val.indexOf(".");
    if (valIndex > "0") {
        if (val.length - (val.indexOf(".") + 1) > DigitsAfterDecimal) {
            alert("Please Enter Valid Selling Price, Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");

            $("#<%=txtMRP1.ClientID%>").val($("#<%=txtMRP1.ClientID%>").val().substring(0, ($("#<%=txtMRP1.ClientID%>").val().length - 1)))
            return false;
        }
    }
}

function validatedot() {
    ValidateDecimal();
    ValidateDecimalSellingPrice();

    if (($("#<%=txtRate1.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtRate1.ClientID%>").val('');
                return false;
            }
            if (($("#<%=txtMRP1.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtMRP1.ClientID%>").val('');
        return false;
    }
    if (($("#<%=txtQuantity1.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtQuantity1.ClientID%>").val('');
        return false;
    }
    if (($("#<%=txtTAX1.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtTAX1.ClientID%>").val('');
        return false;
    }
    return true;
}


$(document).ready(function () {

    var MaxLength = 100;
    $("#<% =txtNarration.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtNarration.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
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
        $(function () {
            expiryCon();
        });
        function expiryCon() {
            var obs = $("#<%=ListBox1.ClientID %>").val();

            if (obs != null) {
                var array = obs.split('#')[5];
                if (array.toUpperCase() == "YES") {
                    $("#<%=txtExpDate1.ClientID%>").show();
                    $("#<%=lblexpirydate.ClientID%>").show();
                }
                else {

                    $("#<%=txtExpDate1.ClientID%>").val('').hide();
                    $("#<%=lblexpirydate.ClientID%>").hide();
                }
            }
        }

    </script>
    <script type="text/javascript">
        function LoadDetail() {
            var strItem = $('#<%=ListBox1.ClientID %>').val();
            if (strItem != null) {
                var ItemID = strItem.split('#')[0];

                $('#<%=lblConFactor.ClientID %>').text(strItem.split('#')[7]);
                $('#<%=lblMajorUnit.ClientID %>').text(strItem.split('#')[8]);
                $('#<%=lblMinorUnit.ClientID %>').text(strItem.split('#')[6]);
            }
            LoadGST();
            //By Vishal
            $('#lblItemName').html($('#<%=ListBox1.ClientID %>' + ' option:selected').text());
        }
        function LoadGST() {
            //Add new On 29-june-2017 for gst change
            var strItem = $('#<%=ListBox1.ClientID %>').val();
            if (strItem != null) {
                $('#<%=txtIGST.ClientID %>').val(Number(strItem.split('#')[9]).toFixed(2));
                $('#<%=txtCGSt.ClientID%>').val(Number(strItem.split('#')[11]).toFixed(2));
                $('#<%=txtSGST.ClientID%>').val(Number(strItem.split('#')[10]).toFixed(2));
                $('#<%=txtHSNCodeNo.ClientID%>').val(strItem.split('#')[13]);
                $('#<%=lblGstType.ClientID%>').text(strItem.split('#')[12]);
                if (strItem.split('#')[12] == "IGST") {
                    $('#<%=ddlTAX1.ClientID%>').val('T4');
                    $('#<%=txtCGSt.ClientID%>,#txtSGST,#txtTAX1,#spCgst,#spSgst').hide();
                    $('#txtIGST,#SPigst').show();
                    TaxCal();
                }
                else if (strItem.split('#')[12] == "CGST&UTGST") {
                    $('#<%=ddlTAX1.ClientID%>').val('T7');
                    $('#<%=txtCGSt.ClientID%>,#spCgst,#spSgst,#txtSGST').show();
                    $('#<%=txtIGST.ClientID%>,#SPigst,#txtTAX1,#txtIGST').hide();
                    $('#spSgst').text('UTGST Tax Per. :');
                    TaxCal();
                }
                else if (strItem.split('#')[12] == "CGST&SGST") {

                    $('#<%=ddlTAX1.ClientID%>').val('T6');
                    $('#<%=txtCGSt.ClientID%>,#spCgst,#spSgst,#txtSGST').show();
                    $('#<%=txtIGST.ClientID%>,#SPigst,#txtTAX1,#txtIGST').hide();
                    $('#spSgst').text('SGST Tax Per. :');
                    TaxCal();
                }
                else {

                    $('#txtTAX1').show();
                    $('#SPigst,#txtCGSt,#txtSGST,#spCgst,#spSgst,#txtIGST').hide();


                }
                //Gaurav 31.08.2017
        if ('<%=Resources.Resource.TaxSelectionBasedOnSupplierState %>' == "1") {
                    var strVendor = $('#<%=ddlVendor.ClientID%>').val();
            if (strVendor != null) {
                var StateID = parseInt(strVendor.split('#')[2]);
                if ('<%=Resources.Resource.DefaultStateID %>' == StateID) {
                    $('#<%=ddlTAX1.ClientID%>').val('T6');
                    $('#<%=txtCGSt.ClientID%>,#txtSGST,#spCgst,#spSgst').show();
                    $('#<%=txtIGST.ClientID%>,#SPigst,#txtTAX1').hide();
                    $('#<%=txtIGST.ClientID%>').val(0);
                    $('#<%=txtTAX1.ClientID%>').val(0);
                    $('#<%=lblGstType.ClientID%>').text('CGST&SGST');
                    TaxCal();
                } else {
                    $('#<%=ddlTAX1.ClientID%>').val('T4');
                    $('#<%=txtCGSt.ClientID%>,#txtSGST,#txtTAX1,#spCgst,#spSgst').hide();
                    $('#<%=txtCGSt.ClientID%>').val(0);
                    $('#<%=txtSGST.ClientID%>').val(0);
                    $('#<%=txtTAX1.ClientID%>').val(0);
                    $('#<%=lblGstType.ClientID%>').text('IGST');
                    $('#txtIGST,#SPigst').show();
                    TaxCal();
                }
            }
        }

        $('#<%=lblConFactor.ClientID %>').text(strItem.split('#')[7]);
                $('#<%=lblMajorUnit.ClientID %>').text(strItem.split('#')[8]);
                $('#<%=lblMinorUnit.ClientID %>').text(strItem.split('#')[6]);
            }

        }
        function taxChange() {
            if ($('#<%=ddlTAX1.ClientID%>').val() == "T4") {
                $('#<%=txtCGSt.ClientID%>,#txtSGST,#txtTAX1,#spCgst,#spSgst').hide();
                $('#txtIGST,#SPigst').show();

            }
            else if ($('#<%=ddlTAX1.ClientID%>').val() == "T7") {
                $('#<%=txtCGSt.ClientID%>,#txtSGST,#spCgst,#spSgst').show();
                $('#<%=txtIGST.ClientID%>,#SPigst,#txtTAX1').hide();
                $('#spSgst').text('UTGST Tax Per. :');
            }
            else if ($('#<%=ddlTAX1.ClientID%>').val() == "T6") {
                $('#<%=txtCGSt.ClientID%>,#txtSGST,#spCgst,#spSgst').show();
                $('#<%=txtIGST.ClientID%>,#SPigst,#txtTAX1').hide();
                $('#spSgst').text('SGST Tax Per. :');
            }
            else {
                $('#txtTAX1').show();
                $('#SPigst,#txtCGSt,#txtSGST,#spCgst,#spSgst,#txtIGST').hide();

            }

    $('#txtSGST,#txtTAX1,#txtCGSt,#txtIGST,#txtUTGST').val(Number('0').toFixed(2));

}
    </script>
    <script type="text/javascript">
     

        function validateGenericPopUp() {

            if ($.trim($("#txtstrength").val()) == "") {
                $("#lblGenErrMsg").text('Please Enter Strength');
                $("#txtstrength").focus();
                return false;
            }
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function TaxCal() {
            $('#<%=txtTAX1.ClientID %>').val(Number($('#<%=txtCGSt.ClientID%>').val()) + Number($('#<%=txtSGST.ClientID%>').val()) + Number($('#<%=txtIGST.ClientID%>').val()));

        }
        function Validate(btn) {
            debugger;
            TaxCal();
            var dateValue = new Date();
            dateValue.setDate(dateValue.getDate() + 180);
            dateValue = dateValue.toDateString('yyyy-MM-dd')
            var ExpDate = $("#<%=txtExpDate1.ClientID%>").val();
            ExpDate = ExpDate.split('-');
            ExpDate = ExpDate[2] + '-' + ExpDate[1] + '-' + ExpDate[0];
            ExpDate = new Date(ExpDate).toDateString('yyyy-MM-dd');

            if (Date.parse(dateValue) > Date.parse(ExpDate)) {
                if (confirm("Expiry date within sex months.Are you sure you want to add this?") == true) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }


        $(function () {
            if ($('#<%=ddlTAX1.ClientID%>').val() == "T4") {
                $('#<%=txtCGSt.ClientID%>,#txtSGST,#txtTAX1,#spCgst,#spSgst').hide();
                $('#txtIGST,#SPigst').show();
            }
            else if ($('#<%=ddlTAX1.ClientID%>').val() == "T6") {
                $('#<%=txtCGSt.ClientID%>,#txtSGST,#spCgst,#spSgst').show();
                $('#<%=txtIGST.ClientID%>,#SPigst,#txtTAX1').hide();
            }
            else {
                $('#txtTAX1').show();
                $('#SPigst,#txtCGSt,#txtSGST,#spCgst,#spSgst,#txtIGST').hide();

            }
            // $('#<%=txtCGSt.ClientID%>,#txtSGST,#spCgst,#spSgst').show();
            //$('#<%=txtIGST.ClientID%>,#SPigst,#txtTAX1').hide();
            TaxCal();
            LoadDetail();

        });
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {

                if ($find('ModalPopupExtender1')) {
                    closeUnit();
                }
                if ($find('ModalPopupExtender2')) {
                    closePurchaseUnit();
                }
            }
        }
    </script>
     

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Receive Consignment</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <asp:Panel ID="pnlPurchase" runat="server" Width="100%">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Order Detail&nbsp;
                </div>
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                     <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                Supplier
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlVendor" CssClass="requiredField" runat="server" Width="" ClientIDMode="Static">
                            </asp:DropDownList>&nbsp;<asp:Label ID="LblVen" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <asp:RequiredFieldValidator ID="rqVendor" runat="server" ErrorMessage="Select Vendor"
                                ControlToValidate="ddlVendor" Display="none" InitialValue="0" SetFocusOnError="true"
                                ValidationGroup="Items"> </asp:RequiredFieldValidator>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                               Consign Dept.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlDeptLedgerNo" runat="server" CssClass="requiredField">
                                </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Invoice No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtBillNo" CssClass="requiredField" runat="server" onkeyup="CheckBillDate()" MaxLength="50"> </asp:TextBox>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Invoice Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBillDate" CssClass="requiredField" runat="server"> </asp:TextBox>
                            <asp:Label ID="lblBDate" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <cc1:CalendarExtender ID="todalcal" TargetControlID="txtBillDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                WayBill No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtChalanNo" runat="server" onkeyup="CheckBillDate()" MaxLength="50">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                WayBill Date 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtChalanDate" CssClass="requiredField" runat="server">
                            </asp:TextBox><asp:Label ID="lblCDate" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <cc1:CalendarExtender ID="callandate" TargetControlID="txtChalanDate" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Gate Entry No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtGatePassInWard" runat="server">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GRN Pay. Mode
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rdoGRNPayType" runat="server"
                                RepeatColumns="2" RepeatDirection="Horizontal" Width="">
                                <asp:ListItem Selected="True" Text="Credit" Value="4"> </asp:ListItem>
                                <asp:ListItem Text="Cash" Value="1"> </asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                   
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select Item
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtSearch" runat="server" AutoCompleteType="Disabled"
                                Width=""> </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Tax Calculate On
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                              <asp:RadioButtonList ID="rblTaxCal" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" Style="font-size: 10px;">
                                <asp:ListItem Text="MRP" Value="MRP"></asp:ListItem>
                                <asp:ListItem Text="Rate" Value="Rate"  ></asp:ListItem>
                                <asp:ListItem Text="RateAD" Value="RateAD" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Rate Rev." Value="RateRev"></asp:ListItem>
                                <asp:ListItem Text="Rate Excl." Value="RateExcl"></asp:ListItem>
                                <asp:ListItem Text="MRP Excl." Value="MRPExcl"></asp:ListItem>
                                <asp:ListItem Text="Excise Amt." Value="ExciseAmt"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 123px; text-align: right;">
                            <table style="width: 123px; text-align: right;">
                                <tr>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="height: 235px;">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                        <td style="width: 225px; text-align: left;">
                            <table style="width: 225px;">
                                <tr>
                                    <td>
                                        <label id="lblItemName" style="color:green;font-style:normal;"></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:ListBox ID="ListBox1" runat="server" CssClass="ItDoseDropdownbox" Height="200px" onchange="expiryCon();LoadDetail(); LoadGST();" Width="323px"></asp:ListBox>
                                    </td>
                                </tr>
                               
                            </table>
                        </td>

                        <td colspan="2">
                            <table style="width: 100%;border-collapse:collapse">
                                <tr>
                                    <td style="width: 126px; text-align: right">HSNCode&nbsp;&nbsp;<b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:TextBox ID="txtHSNCodeNo" runat="server" Width="100px"  ClientIDMode="Static" MaxLength="20" CssClass="ItDoseLabelSp" ></asp:TextBox>
                                    </td>
                                    <td style="width: 100px; text-align: right">
                                       GSTType :&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:Label ID="lblGstType" runat="server" ClientIDMode="Static" CssClass="ItDoseLabelSp" ></asp:Label>
                                       </td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right">Conversion&nbsp;Factor&nbsp;<b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:Label ID="lblConFactor" runat="server" Width="80px" Font-Size="Large" ForeColor="Red"></asp:Label>
                                    </td>
                                    <td style="width: 100px; text-align: right">
                                        <asp:Label ID="lbldeal11" runat="server" Text="Is Deal <b>:</b> " Width="80px" CssClass="ItDoseLabelSp"></asp:Label>
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:TextBox ID="txtDeal" ClientIDMode="Static"  runat="server" Width="34px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                                        <asp:Label ID="Label1" runat="server" Text="+ "  Width="5px" CssClass="ItDoseLabelSp"></asp:Label>
                                        <asp:TextBox ID="txtDeal1" ClientIDMode="Static"  runat="server" Width="34px" CssClass="ItDoseTextinputNum" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right">Purchase Unit <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:Label ID="lblMajorUnit" runat="server" Width="80px" CssClass="ItDoseLabelSp"></asp:Label>
                                    </td>
                                    <td style="width: 100px; text-align: right">Sale Unit <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:Label ID="lblMinorUnit" runat="server" Width="80px" CssClass="ItDoseLabelSp"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right">Rate <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:TextBox ID="txtRate1"  ClientIDMode="Static" runat="server" Width="80px" CssClass="ItDoseTextinputNum requiredField" MaxLength="9" AutoCompleteType="Disabled" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"> </asp:TextBox>
                                        <asp:Label  ID="Label4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rqrate" runat="server" ErrorMessage="Rate Required!"
                                            ControlToValidate="txtRate1" Display="none" SetFocusOnError="true" ValidationGroup="Items"> </asp:RequiredFieldValidator>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" TargetControlID="txtRate1"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td style="width: 100px; text-align: right">Selling Price <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:TextBox ID="txtMRP1" ClientIDMode="Static" runat="server" Width="80px" CssClass="ItDoseTextinputNum" AutoCompleteType="Disabled" MaxLength="9" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"> </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" TargetControlID="txtMRP1"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right">Quantity <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:TextBox ID="txtQuantity1" ClientIDMode="Static" runat="server" Width="80px" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum requiredField" MaxLength="9" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"> </asp:TextBox>
                                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rqQuantity" runat="server" ErrorMessage="Quantity Required!"
                                            ControlToValidate="txtQuantity1" Display="none" SetFocusOnError="true" ValidationGroup="Items"> </asp:RequiredFieldValidator>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server" TargetControlID="txtQuantity1"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td style="width: 100px; text-align: right">Batch No. <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:TextBox ID="txtBatchNo1" runat="server" Width="80px" AutoCompleteType="Disabled" CssClass="ItDoseTextinputNum requiredField" MaxLength="12">
                                        </asp:TextBox>
                                          <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rqBatch" runat="server" ErrorMessage="BatchNo Required!"
                                            ControlToValidate="txtBatchNo1" Display="none" SetFocusOnError="true" ValidationGroup="Items"> </asp:RequiredFieldValidator>


                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right">Purchase Tax (%) <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left;">
                                        <asp:DropDownList ID="ddlTAX1" runat="server" Width="130px" onchange="taxChange();">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 100px; text-align: right;">
                                        <asp:TextBox ID="txtTAX1" runat="server" Width="91px" MaxLength="9" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDisc();"> </asp:TextBox>
                                        <span id="SPigst">IGST Tax Per. <b>:</b>&nbsp;</span>
                                        <span id="spCgst">CGST Tax Per. <b>:</b>&nbsp;</span>
                                    </td>

                                    <td style="width: 100px; text-align: left;">
                                        <asp:TextBox ID="txtIGST" runat="server" Width="80px" CssClass="ItDoseTextinputNum" onlyNumber="5" decimalPlace="2" max-value="100" MaxLength="6" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="TaxCal();"> </asp:TextBox>
                                        <asp:TextBox ID="txtCGSt" runat="server" Width="80px" CssClass="ItDoseTextinputNum" MaxLength="6" onlyNumber="5" decimalPlace="2" max-value="100" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="TaxCal();"> </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender9" runat="server" TargetControlID="txtTAX1"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr id="trSGst">
                                    <td></td>
                                    <td></td>
                                    <td style="width: 138px; text-align: right">
									<span id="spSgst">SGST Tax Per. <b>:</b>&nbsp;</span>
									</td>
                                    <td style="width: 128px; text-align: left;">
                                        <asp:TextBox ID="txtSGST" CssClass="ItDoseTextinputNum" runat="server" Width="80px" MaxLength="6" onlyNumber="5" decimalPlace="2" max-value="100" ClientIDMode="Static" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="TaxCal();"> </asp:TextBox></td>
                                </tr>

                                <tr style="display: none">
                                    <td style="width: 126px; text-align: right">Sale Tax (%) <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left">
                                        <asp:DropDownList ID="DropDownList2" runat="server" Width="87px">
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 100px; text-align: left">&nbsp;</td>
                                    <td style="width: 100px; text-align: right"></td>

                                </tr>
                                <tr style="display: none" id="trExcisePer">
                                    <td style="width: 126px; text-align: right">Excise(%) <b>:</b></td>
                                    <td style="width: 100px; text-align: left">
                                        <asp:TextBox ID="txtExcisePer" runat="server" ClientIDMode="Static" CssClass="ItDoseTextinputNum" MaxLength="5" onkeypress="return checkForSecondDecimal(this,event)" onkeyup="ValidateDisc();validateAmt('txtExcisePer');" Width="80px"> </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="ftbExcisePer" runat="server" Enabled="True" FilterType="Custom, Numbers" TargetControlID="txtExcisePer" ValidChars=".">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td style="width: 100px; text-align: left">&nbsp;</td>
                                    <td style="width: 100px; text-align: right">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right">Discount (%) <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left">
                                        <asp:TextBox ID="txtDiscount1" runat="server" Width="80px" CssClass="ItDoseTextinputNum" ClientIDMode="Static"
                                            onkeyup="ValidateDisc();validateAmt('txtDiscount1');" MaxLength="9" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtDiscount1"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                    <td style="width: 100px; text-align: right"><span style="color: red;">OR</span>&nbsp;&nbsp;&nbsp;Disc.Amt.&nbsp;<b>:</b>&nbsp;</td>
                                    <td style="width: 100px; text-align: left">
                                        <asp:TextBox ID="txtDiscAmt" runat="server" Width="80px" CssClass="ItDoseTextinputNum" MaxLength="9" ClientIDMode="Static"
                                            Onkeyup="ValidateDisc();validateAmt('txtDiscAmt');" onkeypress="return checkForSecondDecimal(this,event)"> </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender11" runat="server" TargetControlID="txtDiscAmt"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                     <td style="width: 126px; text-align: right; vertical-align:top;">Special Disc(%) <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left; vertical-align:top;">
                                        <asp:TextBox ID="txtSpclDisc" runat="server" Width="80px" CssClass="ItDoseTextinputNum" ClientIDMode="Static"
                                            onkeyup="ValidateDisc();" MaxLength="5" onkeypress="return checkForSecondDecimal(this,event)" > </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtDiscount1"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                        <td style="width: 126px; text-align: right; vertical-align:top; display:none;">Special Disc Amt <b>:</b>&nbsp;
                                    </td>
                                    <td style="width: 100px; text-align: left; vertical-align:top; display:none;">
                                        <asp:TextBox ID="txtSpclDiscAmt" runat="server" Width="80px" CssClass="ItDoseTextinputNum" ClientIDMode="Static"
                                            onkeyup="ValidateDisc();" MaxLength="9" onkeypress="return checkForSecondDecimal(this,event)" > </asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" TargetControlID="txtDiscount1"
                                            FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                        </cc1:FilteredTextBoxExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right; height: 18px; vertical-align:top;">
                                        <asp:Label ID="lblexpirydate" runat="server" Text="Expiry Date <b>:</b>&nbsp;"></asp:Label>
                                    </td>
                                    <td style="height: 18px; text-align: left;" colspan="3">
                                        <asp:TextBox ID="txtExpDate1" Style="text-align: left;" runat="server" CssClass="ItDoseTextinputNum"
                                            Width="80px" MaxLength="10"> </asp:TextBox>
                                        <cc1:CalendarExtender ID="expdate" TargetControlID="txtExpDate1" Format="dd-MM-yyyy"
                                            runat="server">
                                        </cc1:CalendarExtender>
                                        &nbsp;<span style="color: #0066FF"><em><asp:Label ID="lbldateformat" runat="server" Text="(format-dd-MM-yyyy)"></asp:Label>
                                        </em></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 126px; text-align: right">Is Free <b>:</b>&nbsp;
                                    </td>
                                    <td style="text-align: left;" colspan="3">
                                        <asp:RadioButtonList ID="rbtnFree" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem>Yes</asp:ListItem>
                                            <asp:ListItem Selected="True">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                        <asp:HiddenField ID="HF_lblNetAmount" runat="server" ClientIDMode="Static" />
                                        <asp:HiddenField ID="HF_lblTaxAmount" runat="server" ClientIDMode="Static" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="text-align: center">
                                        <asp:Button ID="btnSaveItems" runat="server" CssClass="ItDoseButton"  OnClick="btnSaveItems_Click" OnClientClick="return Validate(this);"
                                            Text="Add" ValidationGroup="Items" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Order Items Detail
                </div>
                <div style="text-align: center;">
                    <asp:Panel ID="pnlgvItems" runat="server" ScrollBars="Vertical" Height="270px" Width="100%">
                        <asp:GridView ID="gvPODetails" DataKeyNames="ItemID" runat="server" AutoGenerateColumns="False"
                            CssClass="GridViewStyle" OnRowDeleting="gvPODetails_RowDeleting" OnRowCommand="gvPODetails_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:CommandField ShowDeleteButton="True" HeaderText="Remove" ButtonType="Image" DeleteImageUrl="~/Images/Delete.gif">
                                    <HeaderStyle Width="30px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:CommandField>


                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="false" CommandName="AEdit" ImageUrl="~/Images/edit.png" CommandArgument='<%# ((GridViewRow) Container).RowIndex %>' OnClientClick="expiryCon();" />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Is Expirable">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsExpirable" runat="server" Text='<%# Eval("IsExpirable") %>' CssClass="ItDoseTextinputNum" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="120px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IsDeal">
                                    <ItemTemplate>
                                          <asp:Label ID="lbldeal1" runat="server" Text='<%# Eval("deal1") %>' Visible="False" />
                                          <asp:Label ID="lbltotaldeal" runat="server" Text='<%# Eval("totaldeal") %>' Visible="False" />
                                          <asp:Label ID="lbldeal" runat="server" Text='<%# Eval("deal") %>' Visible="False" />
                                          <asp:Label ID="lblDealTotal" runat="server" Text='<%# Eval("DealTotal") %>' CssClass="ItDoseTextinputNum"/>
                                    </ItemTemplate>
                                      <HeaderStyle Width="120px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="ItemName">
                                    <ItemTemplate>
                                        <asp:Label ID="lblitemname" runat="server" Text='<%# Eval("ItemName") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="175px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Purchase Unit">
                                    <ItemTemplate>
                                        <asp:Label ID="lblunit" runat="server" Text='<%# Eval("Unit") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rate">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRate" runat="server" Text='<%# Eval("Rate") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Purchase Tax(%)">
                                    <ItemTemplate>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblTAXType" runat="server" Text='<%# Eval("TaxName") %>'></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lblTAX" runat="server" Text='<%# Eval("TaxPer") %>'></asp:Label></td>
                                                <asp:Label ID="lblIGSTTaxPer" runat="server" Text='<%# Eval("igstTaxPer") %>' Visible="false"></asp:Label></td>
                                                <asp:Label ID="lblCGSTTaxPer" runat="server" Text='<%# Eval("cgstTaxPer") %>' Visible="false"></asp:Label></td>
                                                <asp:Label ID="lblSGSTTaxPer" runat="server" Text='<%# Eval("sgstTaxPer") %>' Visible="false"></asp:Label></td>
                                                <asp:Label ID="lblHSNCode" runat="server" Text='<%# Eval("HSNCode") %>' Visible="false"></asp:Label></td>
                                                <asp:Label ID="lblGSTType" runat="server" Text='<%# Eval("GSTType") %>' Visible="false"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                    <HeaderStyle Width="75px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Sale Tax(%)" Visible="false">
                                    <ItemTemplate>

                                        <asp:Label ID="lblSaleTax" runat="server" Text='<%# Eval("SaleTaxPer") %>'></asp:Label></td>
                                            
                                    </ItemTemplate>
                                    <HeaderStyle Width="75px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="TypeID" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTypeID" runat="server" Text='<%# Eval("TypeID") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Disc. (%)">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDiscount" runat="server" Text='<%# Eval("Discount") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Special Disc.(%)">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSpecialDisc" runat="server" Text='<%# Eval("SpecialDiscPer") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="40px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Free">
                                    <ItemTemplate>
                                        <asp:Label ID="lblFreeStatus" runat="server" Text='<%# Eval("FreeStatus") %>' />
                                    </ItemTemplate>
                                    <HeaderStyle Width="35px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Batch No.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBatchNo" runat="server" Width="90px" Text='<%# Eval("BatchNo") %>'
                                            CssClass="ItDoseTextinputText" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Qty.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRecQty" runat="server" Text='<%# Eval("Quantity") %>' CssClass="ItDoseTextinputNum" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Amt.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAmt" runat="server" Text='<%# Eval("AMT") %>' CssClass="ItDoseTextinputNum" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Selling Price">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>' CssClass="ItDoseTextinputNum" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Net Amt.">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNetAmount" runat="server" Text='<%# Eval("NetAmount") %>' CssClass="ItDoseTextinputNum" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Tax Amt." Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblTaxAmount" runat="server" Text='<%# Eval("taxAmount") %>' CssClass="ItDoseTextinputNum" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="50px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Right" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Expiry Date">
                                    <ItemTemplate>
                                        <asp:Label ID="lblExpDate" runat="server" Text='<%# Eval("ExpDate") %>' CssClass="ItDoseTextinputNum" />

                                        <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False" />
                                        <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                            Visible="False" />
                                        <asp:Label ID="lblTaxID" runat="server" Text='<%# Eval("TaxID") %>' Visible="False" />
                                        <asp:Label ID="lblSaleUnit" runat="server" Text='<%# Eval("SaleUnit") %>' Visible="False" />
                                        <asp:Label ID="lblExciseAmt" runat="server" Text='<%# Eval("ExciseAmt") %>' Visible="False" />
                                        <asp:Label ID="lblExcisePer" runat="server" Text='<%# Eval("ExcisePer") %>' Visible="False" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="135px" CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:TemplateField>


                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <table style="width: 100%;border-collapse:collapse">
                    <tr>
                        <td style="text-align:right">
                            IGST Amt:
                        </td>
                         <td style="text-align:left">
                           <asp:TextBox ID="txtFreight" runat="server" CssClass="ItDoseTextinputNum"
                                    Width="75px" Text="0" onkeypress="return checkForSecondDecimal(this,event)" MaxLength="9" Visible="false"></asp:TextBox>
                             <cc1:FilteredTextBoxExtender ID="ftbFreight" runat="server"
                                    TargetControlID="txtFreight" FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                           <%--GST Changes--%>
                             
                               <asp:TextBox ID="txtTotalIGST" runat="server" CssClass="ItDoseTextinputNum"
                                    Width="75px" Text="0" onkeypress="return checkForSecondDecimal(this,event)" Enabled="false"></asp:TextBox>
                             <cc1:FilteredTextBoxExtender ID="ftbIGST" runat="server"
                                    TargetControlID="txtTotalIGST" FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                                </cc1:FilteredTextBoxExtender>
                        </td>
                         <td style="text-align:right">
                             CGST Amt:
                        </td>
                          <td style="text-align:left">
                         <asp:TextBox ID="txtOctori" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                                Width="75px" onkeypress="return checkForSecondDecimal(this,event)" MaxLength="9" Visible="false"> </asp:TextBox>
                             <cc1:FilteredTextBoxExtender ID="ftbOctori" runat="server" TargetControlID="txtOctori"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                                 <%--GST Changes--%>
                              <asp:TextBox ID="txtTotalCGST" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                                Width="75px" onkeypress="return checkForSecondDecimal(this,event)" MaxLength="9" Enabled="false"> </asp:TextBox>
                             <cc1:FilteredTextBoxExtender ID="ftbCGST" runat="server" TargetControlID="txtTotalCGST"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align:right">
                             SGST Amt:
                        </td>
                         <td style="text-align:left">
                            <asp:TextBox ID="txtTotalSGST" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                                Width="75px" onkeypress="return checkForSecondDecimal(this,event)" MaxLength="9" Enabled="false"> </asp:TextBox>
                             <cc1:FilteredTextBoxExtender ID="ftbSGST" runat="server" TargetControlID="txtTotalSGST"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                         <td style="text-align:right">
                             Round Off Amount :
                        </td>
                         <td style="text-align:left">
                             <asp:TextBox ID="txtRoundOff" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                                Width="75px" MaxLength="9"> </asp:TextBox>
                            
                            <cc1:FilteredTextBoxExtender ID="ftbRoundOff" runat="server" TargetControlID="txtRoundOff"
                                FilterType="Custom, Numbers" ValidChars=".-" Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="text-align:right">
                            GRN Amount :
                        </td>
                         <td style="text-align:left">
                           
                            <asp:TextBox ID="txtInvoiceAmount" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                                Width="75px"> </asp:TextBox>
                              <cc1:FilteredTextBoxExtender ID="ftbInvoiceAmount" runat="server" TargetControlID="txtInvoiceAmount"
                                FilterType="Custom, Numbers" ValidChars="." Enabled="True">
                            </cc1:FilteredTextBoxExtender>
                           
                        </td>
                    </tr>
                   
                     <tr>
                        
                    <td  style="text-align:right" colspan="2">
Narration/Comment :
                    </td>
                         <td colspan="5">
                              <asp:TextBox ID="txtNarration" runat="server" TextMode="MultiLine" Width="400px"
                        CssClass="ItDoseTextinputText requiredField" AccessKey="N"> </asp:TextBox>&nbsp;
                             <asp:Label ID="lblNaration" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                         </td>
                         <td>
                             <asp:TextBox ID="txtVendorBillAmt" runat="server" CssClass="ItDoseTextinputNum" Text="0"
                            Width="75px" Visible="false"> </asp:TextBox>
                              <asp:TextBox ID="lbl" runat="server"  style="display: none"> </asp:TextBox>
                         </td>
                          </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                    <asp:Button ID="btnSave" OnClientClick="return ButtonDisable(this)" runat="server" Text="Save"
                        OnClick="btnSave_Click" CssClass="ItDoseButton" />&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="btnCancel" CausesValidation="False" runat="server" Text="Cancel"
                            OnClick="btnCancel_Click" CssClass="ItDoseButton" />
            </div>
        </asp:Panel>
        <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="True"
            ShowSummary="False" ValidationGroup="Items" />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
            ShowSummary="False" />

        <div style="display: none;">
        <asp:Button ID="Button1" runat="server" CssClass="ItDoseButton" />
    </div>
       
       </div>
        <script type="text/javascript">
            function checkExcise() {
                if ($.trim($('#<%=rblTaxCal.ClientID %> input[type="radio"]:checked').val()) == "ExciseAmt") {
                    $("#trExcisePer").show();
                }
                else {
                    $("#trExcisePer").attr('disabled', 'disabled');
                }
            }
            $(function () {
                checkExcise();
                $("#rblTaxCal").change(function () {
                    checkExcise();
                    //    GetTaxAmount();
                });
            });
            function TaxParameters() {
                var data = new Array();
                var objmcm = new Object();
                objmcm.Rate = parseFloat($.trim($("#<%=txtRate1.ClientID %>").val()));
                objmcm.MRP = parseFloat($.trim($("#<%=txtMRP1.ClientID %>").val()));
                objmcm.Quantity = parseFloat($.trim($("#<%=txtQuantity1.ClientID %>").val()));
                objmcm.Type = $.trim($('#<%=rblTaxCal.ClientID %> input[type="radio"]:checked').val());
                if ($('#<%=txtTAX1.ClientID %>').val() == "")
                    objmcm.TaxPer = "0.0";
                else
                    objmcm.TaxPer = parseFloat($.trim($('#<%=txtTAX1.ClientID %>').val()));
                if ($('#<%=txtDiscount1.ClientID %>').val() == "")
                    objmcm.DiscPer = "0.0";
                else
                    objmcm.DiscPer = parseFloat($.trim($('#<%=txtDiscount1.ClientID %>').val()));

                if ($('#<%=txtDiscAmt.ClientID %>').val() == "")
                    objmcm.DiscAmt = "0.0";
                else
                    objmcm.DiscAmt = parseFloat($.trim($('#<%=txtDiscAmt.ClientID %>').val()));

                if ($('#<%=txtExcisePer.ClientID %>').val() == "")
                    objmcm.ExcisePer = "0.0";
                else
                    objmcm.ExcisePer = parseFloat($.trim($('#<%=txtExcisePer.ClientID %>').val()));
                data.push(objmcm);
                return data;
            }


            function GetTaxAmount() {
                if (($.trim($("#<%=txtRate1.ClientID %>").val()) != "") && ($.trim($("#<%=txtMRP1.ClientID %>").val()) != "") && ($.trim($("#<%=txtQuantity1.ClientID %>").val()) != "")) {
                    var result = TaxParameters();
                    $.ajax({
                        url: "Services/WebService.asmx/GetTaxAmount",
                        data: JSON.stringify({ Data: result }),
                        type: "POST",
                        async: false,
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function (mydata) {
                            var Data = mydata.d;
                            $('#HF_lblNetAmount').val(Data.split('#')[0]);
                            $('#HF_lblTaxAmount').val(Data.split('#')[1]);
                        }
                    });
                }

            };


            function BindLedgerNameGrd(MappedItemID) {
                $.ajax({
                    type: "POST",
                    url: 'DirectGRN.aspx/BindLedgerNameGrd',
                    data: '{ItemID:"' + MappedItemID + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    success: function (response) {
                        MappedItem = jQuery.parseJSON(response.d);
                        if (MappedItem != null) {
                            var output = $('#tb_MappedItem').parseTemplate(MappedItem);
                            $('#div_MappedItem').html(output);
                            $('#div_MappedItem').show();
                        }
                        else {
                            DisplayMsg('MM04', 'lblMsg');
                            $('#div_MappedItem').hide();
                        }
                    },
                    error: function (e) {
                        DisplayMsg('MM05', 'lblMsg');
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
      </script>


         <script id="tb_MappedItem" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:720px;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Generic Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Strength</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Unit</th>                       
		</tr>
        <#       
        var dataLength=MappedItem.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        for(var j=0;j<dataLength;j++)
        {       
        objRow = MappedItem[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>                                                  
                           <td class="GridViewLabItemStyle"  style="width:160px;"><#=objRow.saltname#></td>
                        <td class="GridViewLabItemStyle"  style="width:240px;"><#=objRow.Strength#></td>
                        <td class="GridViewLabItemStyle"  style="width:200px;"><#=objRow.strengthUnit#></td>                       
                    </tr>            
        <#}        
        #>      
     </table>    
    </script>

</asp:Content>
