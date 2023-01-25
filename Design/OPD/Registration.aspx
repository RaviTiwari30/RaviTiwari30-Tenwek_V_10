<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Registration.aspx.cs" Inherits="Design_OPD_Registration" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Src="~/Design/Controls/wuc_PaymentDetailsJSON.ascx" TagName="PaymentControl"
    TagPrefix="uc" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <script type="text/javascript">
        $(function () {
            document.onkeydown = checkKeycode
            function checkKeycode(e) {
                var keycode;
                if (window.event)
                    keycode = window.event.keyCode;
                else if (e)
                    keycode = e.which;
                if ($.browser.mozilla) {
                    if (keycode == 116 || (e.ctrlKey && keycode == 82)) {
                        if (e.preventDefault) {
                            e.preventDefault();
                            e.stopPropagation();
                        }
                    }
                }
                else if ($.browser.msie) {
                    if (keycode == 116 || (window.event.ctrlKey && keycode == 82)) {
                        window.event.returnValue = false;
                        window.event.keyCode = 0;
                        window.status = "Refresh is disabled";
                    }
                }
            }
        });
    </script>
    <script type="text/javascript" >
        $(function () {
            if ($('#<%=PaymentControl.FindControl("txtBillAmount").ClientID %>').val() == "0") {
                $('#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>,#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>,#<%=PaymentControl.FindControl("txtPaidAmount").ClientID %>,#btnAdd').attr("disabled", true);
                $("select[id*=ddlPaymentMode] option[value='1']").attr("disabled", false);
                $("select[id*=ddlPaymentMode] option[value='2'],select[id*=ddlPaymentMode] option[value='3'],select[id*=ddlPaymentMode] option[value='4']").attr("disabled", true);
            }
        });
    </script>
    <script type="text/javascript">
        $(function () {
            if ($('#<%= PaymentControl.FindControl("txtBillAmount").ClientID %>').val() > 0) {             
                $('#btnSaveReg').prop('disabled', false);
            }
            else {
                $('#btnSaveReg').prop('disabled', 'disabled');
            }
        });
        function GetRate() {
            var itemid = $('#ddlCardTypeReg').val().split('#')[0];
            var panelid = $('#ddlCardTypeReg').val().split('#')[1];
            $.ajax({
                url: "Registration.aspx/GetRate",
                data: '{ItemId:"' + itemid + '",PanelID:"' + panelid + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var obsData = jQuery.parseJSON(mydata.d);
                    if (obsData != "") {
                        $('#lblAmount').text(obsData[0]["Rate"]);
                        $('#txtAmt').val(obsData[0]["Rate"]);
                        $('#txtItemId').val(itemid);
                        $('#<%= PaymentControl.FindControl("txtBillAmount").ClientID %>').val(obsData[0]["Rate"]);
                        $('#<%= PaymentControl.FindControl("txtNetAmount").ClientID %>').val(obsData[0]["Rate"]);
                        $('#<%= PaymentControl.FindControl("lblCurrencyBase").ClientID %>').text(obsData[0]["Rate"] + " USD");
                        $('#<%= PaymentControl.FindControl("lblBalanceAmount").ClientID %>').text(obsData[0]["Rate"]);
                        $('#btnAdd').prop('disabled', false);
                        $('#<%= PaymentControl.FindControl("txtCurrencyBase").ClientID %>').val(obsData[0]["Rate"]);
                        $('#<%= PaymentControl.FindControl("txtTotalPaidAmount").ClientID %>').val(obsData[0]["Rate"]);
                        $('#<%= PaymentControl.FindControl("txtGovTaxAmt").ClientID %>').val(0);
                        var GovTaxPer = $("#<%=lblGovTaxPer.ClientID%>").text();                     
                        $('#btnSaveReg').prop('disabled', true);
                        if ($('#<%=PaymentControl.FindControl("txtBillAmount").ClientID %>').val() == "0") {
                            $('#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>,#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>').attr("disabled", true);
                            $("select[id*=ddlPaymentMode] option[value='1'],#btnSaveReg").attr("disabled", false);
                            $("select[id*=ddlPaymentMode] option[value='2'],select[id*=ddlPaymentMode] option[value='3'],select[id*=ddlPaymentMode] option[value='4']").attr("disabled", true);
                            $('#<%=PaymentControl.FindControl("txtPaidAmount").ClientID %>,#btnAdd,select[id*=ddlPaymentMode],#<%=PaymentControl.FindControl("ddlCountry").ClientID %>').attr("disabled", true);
                            
                        }
                        else {
                            $('#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>,#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>').attr("disabled", false);
                            $("select[id*=ddlPaymentMode] option[value='1'],select[id*=ddlPaymentMode] option[value='2'],select[id*=ddlPaymentMode] option[value='3']").attr("disabled", false);
                            //if ($("select[id*=ddlPanel]").val() == "1") {
                            //    $("select[id*=ddlPaymentMode] option[value='4']").attr("disabled", true);
                            //}
                            //else {
                            //    $("select[id*=ddlPaymentMode] option[value='4']").attr("disabled", false);
                            //}
                            $('#<%=PaymentControl.FindControl("txtPaidAmount").ClientID %>,select[id*=ddlPaymentMode],#btnAdd,#<%=PaymentControl.FindControl("ddlCountry").ClientID %>').attr("disabled", false);
                            $('#btnSaveReg').attr('disabled', true);
                        }
                    }
                    else {
                        $('#lblAmount').text('0');
                        $('#txtItemId').val('');
                        $('#txtAmt,#<%= PaymentControl.FindControl("txtBillAmount").ClientID %>,#<%= PaymentControl.FindControl("txtNetAmount").ClientID %>,#<%= PaymentControl.FindControl("txtCurrencyBase").ClientID %>').val('0');
                        $('#<%= PaymentControl.FindControl("lblCurrencyBase").ClientID %>,#<%= PaymentControl.FindControl("lblBalanceAmount").ClientID %>').text('0');
                        $('#btnAdd').prop('disabled', 'disabled');
                        $('#btnSaveReg').prop('disabled', true);
                        $('#<%= PaymentControl.FindControl("txtGovTaxAmt").ClientID %>,#<%= PaymentControl.FindControl("txtTotalPaidAmount").ClientID %>').val(0);
                    }
                }
            });
        }
        function getDocName() {
            $.ajax({
                url: "NewAppointment.aspx/getDocName",
                data: '{DoctorID:"' + $('#ddlDoctorList').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    $('#lblDoctorName').text(mydata.d);
                }
            });
        }
    </script>
    <script type="text/javascript" >
        function AutoGender() {
            var ddltitle = document.getElementById('<%=cmbTitle.ClientID%>');
            var ddltxt = ddltitle.options[ddltitle.selectedIndex].text;
            if (ddltxt == "Baby" || ddltxt == "B/O") {
                $('#<%=ddlAge.ClientID%>').prop("selectedIndex", 2);
                $("#<%=ddlAge.ClientID%> option[value='YRS']").prop("disabled", true);
                $("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").prop("disabled", false);
                $("#<%=ddlAge.ClientID%> option[value='DAYS(S)']").prop("disabled", false);
            }
            else if (ddltxt == "Baby" || ddltxt == 'Master') {
                $('#<%=ddlAge.ClientID%>').prop("selectedIndex", 1);
                $("#<%=ddlAge.ClientID%> option[value='YRS']").prop("disabled", false);
                $("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").prop("disabled", false);
                $('#<%=ddlAge.ClientID%> option:contains("DAYS(S)")').prop('disabled', false);
            }
            else {
                $('#<%=ddlAge.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlAge.ClientID%> option[value='YRS']").prop("disabled", false);
                $("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").prop("disabled", true);
                $('#<%=ddlAge.ClientID%> option:contains("DAYS(S)")').prop('disabled', true);
            }
            var age = $('#<%=ddlAge.ClientID%>').val();
            if (age == "YRS") {
                validateageyrs();
            }
            else if (age == "MONTH(S)") {
                validatemonth();
            }
            else
                validatedays();
            if (ddltxt == "Mr.") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop('disabled', true);
            }
            else if (ddltxt == "Mrs." || ddltxt == "Miss." || ddltxt == "Madam") {
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop('disabled', true);
            }           
            else if (ddltxt == "Master") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop('disabled', true);
            }
            else if (ddltxt == "Baby") {
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop({ checked: true, disabled: false });
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop('disabled', false);
            }           
        else if (ddltxt == "B/O" || ddltxt == "Dr." || ddltxt == "Er." || ddltxt == "Nana" || ddltxt == "Alhaji" || ddltxt == "Hajia" || ddltxt == "Prof.") {
            $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop('disabled', false);
            $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop('disabled', false);
            }
            else {
            $('#<%=rblSex.ClientID%>').prop('disabled', false);
            $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop('checked', true);
            }
        }
        function validateageyrs() {
            var MaxValue = 161;
            $('#<%=txtAge.ClientID %>').keyup(function (e) {
                if ($(this).val() >= MaxValue && $('#<%=ddlAge.ClientID%>').val() == "YRS") {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Age In YRS');
                    $('#<%=txtAge.ClientID %>').val('');
                    $('#<%=txtAge.ClientID %>').focus();
                }
            });
        }
        function validatemonth() {
            var MaxValue = 13;
            $('#<%=txtAge.ClientID %>').keyup(function (e) {
                if ($(this).val() >= MaxValue && $('#<%=ddlAge.ClientID%>').val() == "MONTH(S)") {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Age In Month');
                    $('#<%=txtAge.ClientID %>').val('');
                    $('#<%=txtAge.ClientID %>').focus();
                }
            });
        }
        function validatedays() {
            var MaxValue = 32;
            $('#<%=txtAge.ClientID %>').keyup(function (e) {
                if ($(this).val() >= MaxValue && $('#<%=ddlAge.ClientID%>').val() == "DAYS(S)") {
                    $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Age In days');
                    $('#<%=txtAge.ClientID %>').val('');
                    $('#<%=txtAge.ClientID %>').focus();
                }
            });
        }       
        $(document).ready(function () {
            try {                        
                LoadRate();
                $('#<%=cmbTitle.ClientID %>').focus();
                AutoGender();
                var ddltitle = document.getElementById('<%=cmbTitle.ClientID%>');
                var ddltxt = ddltitle.options[ddltitle.selectedIndex].text;
                if (ddltxt == "Mr.") {
                    $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: true });
                    $('#<%=rblSex.ClientID%> :radio[value="Female"]').prop('disabled', true);
                }
            }
            catch (e) {
            }
        });
        $(document).ready(function () {
            if ($('#<%=rdDOB.ClientID %>').prop('checked')) {
                $('#<%=txtDOB.ClientID %>').prop('disabled', false);
                $('#<%=txtAge.ClientID %>').prop('disabled', true);
                $('#<%=ddlAge.ClientID %>').prop('disabled', false);
            }
            if ($('#<%=rdAge.ClientID %>').prop('checked')) {
                AutoGender();
                $('#<%=txtDOB.ClientID %>').prop('disabled', true);
                $('#<%=txtAge.ClientID %>').prop('disabled', false);
            }
            $("#<%=rdDOB.ClientID%>").click(function () {
                $('#<%=txtAge.ClientID %>').val('');
                $('#<%=txtDOB.ClientID %>').prop('disabled', false);
                $('#<%=txtAge.ClientID %>').prop('disabled', true);
                $('#<%=ddlAge.ClientID%> option:nth-child(1)').prop('selected', '0');
                $('#<%=ddlAge.ClientID %>').prop('disabled', true);
            });
            $("#<%=rdAge.ClientID%>").click(function () {
                AutoGender();
                $('#<%=txtDOB.ClientID %>').val('');
                $('#<%=txtDOB.ClientID %>').prop('disabled', true);
                $('#<%=txtAge.ClientID %>,#<%=ddlAge.ClientID %>').prop('disabled', false);
            });
            $('#<%=txtAge.ClientID %>').keyup(function (e) {
                validateAge();
            });
        });     
        function validateAge() {
            var MaxValueMonth = 13;
            var MaxValueYrs = 161;
            var MaxValueDay = 32
            if ($('#<%=txtAge.ClientID %>').val().charAt(0) == "0") {
                $('#<%=lblMsg.ClientID %>').text('0 is not allowed as first character');
                $(this).val('');
                $('#<%=txtAge.ClientID %>').val('');
                return false;
            }
            if ($('#<%=txtAge.ClientID %>').val() >= MaxValueMonth && $('#<%=ddlAge.ClientID%>').val() == "MONTH(S)") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Age In Month');
                $('#<%=txtAge.ClientID %>').val('');
                $('#<%=txtAge.ClientID %>').focus();
            }
            else if ($('#<%=txtAge.ClientID %>').val() >= MaxValueYrs && $('#<%=ddlAge.ClientID%>').val() == "YRS") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Age In YRS');
                $('#<%=txtAge.ClientID %>').val('');
                $('#<%=txtAge.ClientID %>').focus();
            }

            else if ($('#<%=txtAge.ClientID %>').val() >= MaxValueDay && $('#<%=ddlAge.ClientID%>').val() == "DAYS(S)") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Age In Days');
                $('#<%=txtAge.ClientID %>').val('');
                $('#<%=txtAge.ClientID %>').focus();
            }
            else {
                $('#<%=lblMsg.ClientID %>').text('');
            }
        }
        function openPopup(btnName) {
            buttonName = document.getElementById(btnName).value;
            window.open('../common/PatientSearchPopup.aspx?BTN=' + buttonName, null, 'left=100, top=100, height=420, width=840, status=yes, resizable= no, scrollbars= no, toolbar= no,location= no, menubar= no');
            event.keyCode = 0
            return false;
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("ModalPopupExtender1")) {
                    ClearSlot();
                    $('#btnProcess').hide();
                    $find('ModalPopupExtender1').hide();
                }
            }
        }
        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }

        function validatespace() {
            var PfirstName = $('#<%=txtPatientFirstName.ClientID %>').val();
            var PlastName = $("#txtPatientLastName").val();
            if (PfirstName.charAt(0) == ' ' || PfirstName.charAt(0) == '.' || PfirstName.charAt(0) == ',' || PfirstName.charAt(0) == '0' || PfirstName.charAt(0) == "'" || PfirstName.charAt(0) == "-") {
                $('#<%=txtPatientFirstName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                PfirstName.replace(PfirstName.charAt(0), "");
                return false;
            }
            if (PlastName.charAt(0) == ' ' || PlastName.charAt(0) == '.' || PlastName.charAt(0) == ',' || PlastName.charAt(0) == '0' || PlastName.charAt(0) == "'" || PlastName.charAt(0) == "-") {
                $("#txtPatientLastName").val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                PlastName.replace(PlastName.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblMsg.ClientID %>').text('');
                return true;
            }
        }
        function getcity() {
            var ddlCity = $("#<%=ddlCity.ClientID %>");
            $("#<%=ddlCity.ClientID %> option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/getCity",
                data: '{ Country: "' + $("#<%=ddlNationality.ClientID %>").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    if (CityData.length == 0) {
                        ddlCity.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].City).html(CityData[i].City));
                        }
                    }
                    ddlCity.prop("disabled", false);
                },
                error: function (xhr, status) {
                    alert("Error ");
                    ddlCity.prop("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>
    <script type="text/javascript">
        function SaveCity() {
            if ($.trim($("#<%=txtNewCity.ClientID %>").val()) != "") {
                $.ajax({
                    url: "../Common/CommonService.asmx/CityInsert",
                    data: '{ City: "' + $("#<%=txtNewCity.ClientID %>").val() + '", Country: "' + $("#<%=ddlNationality.ClientID %>").val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data == "2") {
                            $('#<%=lblMsg.ClientID %>').text('City Saved Successfully');
                            $("#<%=ddlCity.ClientID %>").append($("<option></option>").val($("#<%=txtNewCity.ClientID %>").val()).html($("#<%=txtNewCity.ClientID %>").val()));
                            $("#<%=ddlCity.ClientID %>").val($("#<%=txtNewCity.ClientID %>").val());

                            $("#<%=txtNewCity.ClientID %>").val('');
                            $find('<%=mpCity.ClientID%>').hide();
                        }
                        else if (Data == "1") {
                            $('#<%=lblMsg.ClientID %>').text('City Already Exist');
                            $("#<%=txtNewCity.ClientID %>").val('');
                            $find('<%=mpCity.ClientID%>').hide();
                        }
                        else {
                            $('#<%=lblMsg.ClientID %>').text('City Not Saved');
                            $find('<%=mpCity.ClientID%>').hide();
                        }
                        return false;
                    },
                    error: function (xhr, status) {
                        alert("Error ");

                        window.status = status + "\r\n" + xhr.responseText;
                        return false;
                    }
                });
            }
            else {
                $('#<%=lblMsg.ClientID %>').text("Please Enter City Name");
                $("#<%=txtNewCity.ClientID %>").focus();
                $find('<%=mpCity.ClientID%>').show();
            }
        }
        function LoadRate() {
            if ($("#ddlCardTypeReg").val() != "") {
                var itemid = $('#ddlCardTypeReg').val().split('#')[0];
                var panelid = $('#ddlCardTypeReg').val().split('#')[1];
                $.ajax({
                    url: "../Common/CommonService.asmx/LoadrateRegistration",
                    data: '{ItemId:"' + itemid + '",PanelID:"' + panelid + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        RateData = jQuery.parseJSON(result.d);
                        if (RateData.length > 0) {
                            $('#lblAmount').text(RateData[0]["Rate"]);
                            $('#lblItemID').text(RateData[0]["ItemID"]);
                        }
                        else {
                            $('#lblAmount,#lblItemID').text('0');
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }      
        $(function () {
            $('#ddlCardTypeReg').change(function () {
                $('#<%=PaymentControl.FindControl("txtrefNo").ClientID %>,#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>,#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>').val('');
                $('#<%=PaymentControl.FindControl("txtDiscReason").ClientID %>').val('').hide();
                $('select[id*=ddlApproveBy]').prop('selectedIndex', 0).hide();
                $('#<%=PaymentControl.FindControl("trDiscReason").ClientID %>').hide();
                $('#<%=PaymentControl.FindControl("lblBank").ClientID %>, #<%=PaymentControl.FindControl("ddlBank").ClientID %>,span[id*=v1],span[id*=v2]').hide();
                $('#<%=PaymentControl.FindControl("lblCardNo").ClientID %>, #<%=PaymentControl.FindControl("txtrefNo").ClientID %>').hide();
                $('select[id*=ddlPaymentMode]').prop("selectedIndex", 0);
                $('#<%=PaymentControl.FindControl("ddlCountry").ClientID %> option:selected').text('USD');
                GetRate();
            });
            var MaxLength = 100;
            $("#<%=txtResidentialAddress.ClientID%>").bind("cut copy paste", function (e) {
                e.preventDefault();
            });
            $('#<%=txtResidentialAddress.ClientID%>').keypress(function (e) {
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
        function SaveRegistration() {
            var con = 0;
            if ($('#<%=txtPatientFirstName.ClientID %>').val() == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Patient First Name');
                $('#<%=txtPatientFirstName.ClientID %>').focus();
                con = 1;
                 return false;
             }
             if ($('#<%=txtPatientLastName.ClientID %>').val() == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Patient Last Name');
                 $('#<%=txtPatientLastName.ClientID %>').focus();
                 con = 1;
                return false;
            }
            if ($('#<%=rdDOB.ClientID %>').prop('checked')) {
                if ($('#<%=txtDOB.ClientID %>').val() == "") {
                    $('#<%=lblMsg.ClientID %>').text('Select DOB or Age ');
                    $('#<%=txtDOB.ClientID %>').prop('disabled', false);
                    $('#<%=txtDOB.ClientID %>').focus();
                    con = 1;
                    return false;
                }
            }
            if ($('#<%=rdAge.ClientID %>').prop('checked')) {
                if ($('#<%=txtAge.ClientID %>').val() == "") {
                    $('#<%=lblMsg.ClientID %>').text('Select DOB or Age ');
                    $('#<%=txtAge.ClientID %>').prop('disabled', false);
                    $('#<%=txtAge.ClientID %>').focus();
                    con = 1;
                    return false;
                }
            }
            if ($('#<%=txtAge.ClientID %>').val().charAt(0) == "0") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Proper Age ');
                $('#<%=txtAge.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').focus();
                con = 1;
                return false;
            }
            if ($('#<%=txtContactNo.ClientID %>').val() == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Contact No.');
                $('#<%=txtContactNo.ClientID %>').focus();
                con = 1;
                return false;
            }
            if ($('#<%=txtContactNo.ClientID %>').val().length < "10") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Contact No.');
                $('#<%=txtContactNo.ClientID %>').focus();
                con = 1;
                return false;
            }
            
            var emailaddress = $('#<%=txtEmailAddress.ClientID %>').val();
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%=txtEmailAddress.ClientID %>').focus();
                con = 1;
                return false;
            }
            if ($.trim($('#<%=txtResidentialAddress.ClientID%>').val()) == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Enter Address');
                $('#<%=txtResidentialAddress.ClientID %>').focus();
                con = 1;
                return false;
            }
            if ($('#<%=ddlNationality.ClientID%> option:selected').text() == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Proper Country');
                $('#<%=ddlNationality.ClientID%>').focus();
                con = 1;
                return false;
            }
            if ($('#<%=ddlCity.ClientID%> option:selected').text() == "---No Data Found---") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Proper City');
                $('#<%=ddlCity.ClientID%>').focus();
                con = 1;
                return false;
            }
            if ($('#<%=ddlCity.ClientID%> option:selected').text() == "") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Proper City');
                $('#<%=ddlCity.ClientID%>').focus();
                con = 1;
                return false;
            }
            if ($('#ddlCardTypeReg').val() == "0") {
                $('#<%=lblMsg.ClientID %>').text('Please Select Card Type');
                $('ddlCardTypeReg').focus();
                con = 1;
                return false;
            }
            if ($('#txtDisAmount').val() > 0 || $('#txtDisPercent').val() > 0) {
                if ($("input[id*=txtDiscReason]").val() == "") {
                    $("#<%=lblMsg.ClientID %>").text('Please Enter Discount Reason');
                    $("input[id*=txtDiscReason]").focus();
                    con = 1;
                    return false;
                }
                if ($('select[id*=ddlApproveBy]').val() == "0") {
                    $("#<%=lblMsg.ClientID %>").text('Please Select Approve By');
                    $('select[id*=ddlApproveBy]').focus();
                    con = 1;
                    return false;
                }
            }
            if (($('select[id*=ddlPaymentMode]').val() == "2") || ($('select[id*=ddlPaymentMode]').val() == "3")) {
                if ($('#<%=PaymentControl.FindControl("ddlBank").ClientID %>').val() == "") {
                    $("#<%=lblMsg.ClientID %>").text('Please Select Bank Name');
                    $('#<%=PaymentControl.FindControl("ddlBank").ClientID %>').focus();
                    con = 1;
                    return false;
                }
                if ($.trim($('#<%=PaymentControl.FindControl("txtrefNo").ClientID %>').val()) == "") {
                    $("#<%=lblMsg.ClientID %>").text('Please Enter Card/Ref. No.');
                    $('#<%=PaymentControl.FindControl("txtrefNo").ClientID %>').focus();
                    con = 1;
                    return false;
                }
            }
            if (($('#txtNetAmount').val() > 0) && ($('select[id*=ddlPaymentMode]').val() != "4")) {
                if ($('#grdPaymentMode tr').length == "1") {
                    $("#<%=lblMsg.ClientID %>").text('Please Add Amount');
                    con = 1;
                    $('#btnAdd').focus();
                    return false;
                }
            }
            $.ajax({
                type: "POST",
                url: "Services/CardRegistration.asmx/Registered",
                data: '{ PFirstName: "' + $.trim($("#<%=txtPatientFirstName.ClientID %>").val()) + '",PlastName:"' + $.trim($("#<%=txtPatientLastName.ClientID %>").val()) + '",Mobile:"' + $.trim($("#<%=txtContactNo.ClientID %>").val()) + '"}',
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    Data = result.d;
                    if (Data > 0) {
                        var Ok = confirm("Patient already Registered are you sure to registered again");
                        if (Ok) {
                            con = 0;
                        }
                        else {
                            con = 1;
                            return false;
                        }
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;

                }
            });
            if (con == 0) {
                var SubcategoryID = "";
                $('#btnSaveReg').prop('disabled', true).val("Submitting...");
                $.ajax({
                    url: "Services/CardRegistration.asmx/CardSubCategoryID",
                    data: '{ ItemID: "' + $("#<%=ddlCardTypeReg.ClientID %> ").val().split('#')[0] + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        subcategoryid = jQuery.parseJSON(result.d);
                        if (subcategoryid != null) {
                            SubcategoryID = subcategoryid;
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $('#btnSaveReg').prop('disabled', false).val("Save");
                        return false;
                    }
                });
                var data = new Array();
                var obj = new Object();
                if (SubcategoryID != "") {
                    obj.Title = $("#<%=cmbTitle.ClientID%> option:selected").text();
                    obj.PFName = $.trim($("#txtPatientFirstName").val());
                    obj.PLName = $.trim($("#txtPatientLastName").val());
                    obj.PName = $.trim($("#txtPatientFirstName").val()) + ' ' + $.trim($("#txtPatientLastName").val());
                    if ($.trim($("#<%=txtDOB.ClientID%>").val()) == "") {
                        obj.Age = $.trim($("#<%=txtAge.ClientID%>").val()) + ' ' + $("#<%=ddlAge.ClientID%>").val();
                    }
                    else {
                        obj.Age = "";
                        obj.DOB = $.trim($("#<%=txtDOB.ClientID%>").val());
                    }
                    obj.Gender = $("#<%=rblSex.ClientID%> input[type=radio]:checked").next().text();
                    obj.MaritalStatus = $("#<%=ddlmarital.ClientID%>").val();
                    obj.Mobile = $.trim($("#<%=txtContactNo.ClientID%>").val());
                    obj.Email = $("#<%=txtEmailAddress.ClientID%>").val();
                    obj.Address = $.trim($("#<%=txtResidentialAddress.ClientID%>").val());
                    obj.Country = $("#<%=ddlNationality.ClientID%> option:selected").text();
                    obj.City = $("#<%=ddlCity.ClientID%> option:selected").text();
                    obj.Card_ID = $("#<%=ddlCardTypeReg.ClientID%>").val().split('#')[2];
                    obj.PanelID = $("#<%=ddlCardTypeReg.ClientID%>").val().split('#')[1];
                    obj.ItemID = $("#<%=ddlCardTypeReg.ClientID%>").val().split('#')[0];
                    obj.ItemName = $("#<%=ddlCardTypeReg.ClientID%> :selected").text();
                    obj.HashCode = $("#<%=txtHash.ClientID%>").val();
                    obj.DoctorID = $("#<%=ddlDoctorList.ClientID%>").val();
                    obj.TotalGrossAmt = $.trim($('#<%=PaymentControl.FindControl("txtBillAmount").ClientID %>').val());
                    obj.NetAmount = $.trim($('#<%=PaymentControl.FindControl("txtNetAmount").ClientID %>').val());
                    obj.AmountPaid = $('#<%=PaymentControl.FindControl("lblTotalPaidAmount").ClientID %>').text();

                    if (($.trim($('#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>').val()) == "") && ($.trim($('#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>').val()) != "")) {

                        obj.DisAmount = (parseFloat($.trim($('#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>').val())) * ($.trim($('#<%=PaymentControl.FindControl("txtBillAmount").ClientID %>').val()))) / 100;
                        obj.DisPercent = parseFloat($.trim($('#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>').val()));
                    }
                    else if (($.trim($('#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>').val()) != "") && ($.trim($('#<%=PaymentControl.FindControl("txtDisPercent").ClientID %>').val()) == "")) {
                        obj.DisAmount = parseFloat($.trim($('#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>').val()));
                        obj.DisPercent = ((parseFloat($.trim($('#<%=PaymentControl.FindControl("txtDisAmount").ClientID %>').val()))) * 100) / ($.trim($('#<%=PaymentControl.FindControl("txtBillAmount").ClientID %>').val()));
                    }
                    else {
                        obj.DisAmount = "0";
                        obj.DisPercent = "0";
                    }

                    obj.RoundOff = $('#<%=PaymentControl.FindControl("lblRoundVal").ClientID %>').text();
                    obj.DiscountReason = $.trim($('#<%=PaymentControl.FindControl("txtDiscReason").ClientID %>').val());
                    if ($('select[id*=ddlApproveBy] :selected').text() != "Select")
                        obj.DiscountApproveBy = $('select[id*=ddlApproveBy] :selected').text();
                    else
                        obj.DiscountApproveBy = "";
                    obj.Narration = $.trim($('#<%=PaymentControl.FindControl("txtRemarks").ClientID %>').val());
                    obj.subcategoryid = SubcategoryID;
                    if ($('#<%=PaymentControl.FindControl("txtGovTaxAmt").ClientID %>').is(':visible'))
                        obj.GovTaxAmt = $.trim($('#<%=PaymentControl.FindControl("txtGovTaxAmt").ClientID %>').val());
                    else
                        obj.GovTaxAmt = "0";
                    if($('#<%=PaymentControl.FindControl("lblGovTaxPercentage").ClientID %>').is(':visible'))
                    obj.GovTaxPer = $.trim($('#<%=PaymentControl.FindControl("lblGovTaxPercentage").ClientID %>').text());
                    else
                        obj.GovTaxPer = "0";
                    if (($("#grdPaymentMode tr").length == "1") && ($('select[id*=ddlPaymentMode]').val() == "1")) {
                        $.ajax({
                            url: "Services/CardRegistration.asmx/Cash",
                            data: '{ }',
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            async: false,
                            dataType: "json",
                            cache: false,
                            success: function (result) {
                                CashData = jQuery.parseJSON(result.d);
                                if (CashData != null) {

                                    obj.PaymentMode = "Cash";
                                    obj.PaymentModeID = "1";
                                    obj.PaidAmount = "0";
                                    obj.Currency = CashData[0]["S_Currency"];
                                    obj.CountryID = CashData[0]["S_CountryID"];
                                    obj.BankName = "";
                                    obj.RefNo = "";
                                    obj.BaceCurrency = CashData[0]["B_Currency"];
                                    obj.CFactor = CashData[0]["Selling_Specific"];
                                    obj.BaseCurrency = "0";
                                    obj.Notation = CashData[0]["S_Notation"];
                                    data.push(obj);
                                }
                            },
                            error: function (xhr, status) {
                                window.status = status + "\r\n" + xhr.responseText;
                                $('#btnSaveReg').prop('disabled', false).val("Save");
                                data.push('');
                                return false;
                            }
                        });
                    }
                    else if (($("#grdPaymentMode tr").length == "1") && ($('select[id*=ddlPaymentMode]').val() == "4")) {
                        $.ajax({
                            url: "Services/CardRegistration.asmx/Credit",
                            data: '{ }',
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            async: false,
                            dataType: "json",
                            cache: false,
                            success: function (result) {
                                CreditData = jQuery.parseJSON(result.d);
                                if (CreditData != null) {

                                    obj.PaymentMode = "Credit";
                                    obj.PaymentModeID = "4";
                                    obj.PaidAmount = "0";
                                    obj.Currency = CreditData[0]["S_Currency"];
                                    obj.CountryID = CreditData[0]["S_CountryID"];
                                    obj.BankName = "";
                                    obj.RefNo = "";
                                    obj.BaceCurrency = CreditData[0]["B_Currency"];
                                    obj.CFactor = CreditData[0]["Selling_Specific"];
                                    obj.BaseCurrency = "0";
                                    obj.Notation = CreditData[0]["S_Notation"];
                                    data.push(obj);
                                }
                            },
                            error: function (xhr, status) {
                                window.status = status + "\r\n" + xhr.responseText;
                                $('#btnSaveReg').prop('disabled', false).val("Save");
                                data.push('');
                                return false;
                            }
                        });
                    }
                    else {
                        $("#grdPaymentMode tr").each(function () {
                            var id = $(this).closest("tr").prop("id");
                            if (id != "Header") {
                                obj.PaymentMode = $(this).find("#tdPaymentMode").html();
                                obj.PaymentModeID = $(this).find("#tdPaymentModeID").html();
                                obj.PaidAmount = $(this).find("#tdPaidAmount").html();
                                obj.Currency = $(this).find("#tdCurrency").html();
                                obj.CountryID = $(this).find("#tdCountryID").html();
                                obj.BankName = $(this).find("#tdBank").html();
                                obj.RefNo = $(this).find("#tdRefNo").html();
                                obj.BaceCurrency = $(this).find("#tdBaseCurrency").html();
                                obj.CFactor = $(this).find("#tdCFactor").html();
                                obj.BaseCurrency = $(this).find("#tdBaseCurrencyAmount").html();
                                obj.Notation = $(this).find("#tdNotation").html();
                                data.push(obj);
                                obj = new Object();
                            }
                        });
                    }
                    if (data.length > 0) {
                        $.ajax({
                            url: "Services/CardRegistration.asmx/OPDCardRegistration",
                            data: JSON.stringify({ Data: data }),
                            type: "POST",
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            async: false,
                            dataType: "json",
                            cache: false,
                            success: function (result) {
                                OutPut = result.d;
                                if (OutPut != "") {
                                    $("#<%=lblMsg.ClientID%>").text('Record Saved Successfully');
                                    alert('UHID :' + OutPut.split('#')[1] + ' ');
                                    window.open('../common/CommonReceipt.aspx?LedgerTransactionNo=' + OutPut.split('#')[0] + '');
                                    // CardPrint(OutPut.split('#')[0], OutPut.split('#')[1]);
                                    // clearForm();
                                    window.location.href = 'Registration.aspx';
                                    $('#btnSaveReg').prop('disabled', true).val("Save");

                                }
                                else {
                                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                                    $('#btnSaveReg').prop('disabled', false).val("Save");

                                }
                            },
                            error: function (xhr, status) {
                                $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                                window.status = status + "\r\n" + xhr.responseText;
                                $('#btnSaveReg').prop('disabled', false).val("Save");
                            }
                        });
                    }
                    else {
                        $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                        $('#btnSaveReg').prop('disabled', false).val("Save");
                    }
                }
                else {
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    $('#btnSaveReg').prop('disabled', false).val("Save");

                }
            }
        }
        function CardPrint(LedgerTransactionNo, PID) {
            $.ajax({
                url: "Services/CardRegistration.asmx/CardPrintOut",
                data: '{LedgerTransactionNo:"' + LedgerTransactionNo + '" }', // parameter map
                type: "POST",   	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                    PrintOut = jQuery.parseJSON(result.d);
                    if (PrintOut != null) {
                        window.open('../common/CommonReceipt.aspx?PID=' + PID + '');
                        clearForm();
                    }
                },
                error: function (xhr, status) {
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function clearForm() {
            $(':text, textarea').val('');
            $('select:not(#<%=ddlNationality.ClientID%>) option:nth-child(1)').prop('selected', '0');
            $("#grdPaymentMode tr:not(:first)").remove();
            $("#grdPaymentMode").hide();
            $("#ddlCardTypeReg").prop('disabled', false);
            $("#lblAmount").text('0');
            $("#txtAmt").val('0'); 
            $('#<%=PaymentControl.FindControl("txtBillAmount").ClientID %>,#<%=PaymentControl.FindControl("txtCurrencyBase").ClientID %>').val('0');
            $('#<%=rdAge.ClientID %>').prop('checked', true);
            $('#<%=rblSex.ClientID%> :radio[value="Male"]').prop({ checked: true, disabled: true });
            $('select[id*=ddlPaymentMode]').prop('disabled', true);
            $('select[id*=ddlApproveBy]').hide().prop('disabled', false);
            $('#<%=PaymentControl.FindControl("txtDiscReason").ClientID %>').hide().prop('disabled', false);
            $('#<%=PaymentControl.FindControl("lblTotalPaidAmount").ClientID %>,#<%=PaymentControl.FindControl("lblBalanceAmount").ClientID %>,#<%=PaymentControl.FindControl("lblRoundVal").ClientID %>').text('0');
         
           
            $('#<%=PaymentControl.FindControl("lblCurrencyBase").ClientID %>').text('');
            $('#<%=PaymentControl.FindControl("trDiscReason").ClientID %>').hide();
            var DefaultCity = '<%=GetGlobalResourceObject("Resource", "DefaultCity") %>';
            $("#<%=ddlCity.ClientID %> option:selected").text(DefaultCity);
            SetDefaultCountry();
            $('#<%=ddlmarital.ClientID %> option:selected').text('Single');
            $('#<%=PaymentControl.FindControl("lblBank").ClientID %>, #<%=PaymentControl.FindControl("ddlBank").ClientID %>,span[id*=v1],span[id*=v2]').hide();
            $('#<%=PaymentControl.FindControl("lblCardNo").ClientID %>, #<%=PaymentControl.FindControl("txtrefNo").ClientID %>').hide();
            $('#<%=btnNewCity.ClientID %>').prop('disabled', false);
            $('#btnAdd').prop('disabled', true);
            $('#<%=PaymentControl.FindControl("ddlCountry").ClientID %>').prop('disabled', false);
            GetBaseCurrency();
        }
        function SetDefaultCountry() {
            $.ajax({
                url: "../Common/CommonService.asmx/DefaultCountry",
                data: '{ }', 
                type: "POST",     	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                    DefaultCountry = jQuery.parseJSON(result.d);
                    if (DefaultCountry != null) {
                        $("#<%=ddlNationality.ClientID %>").val(DefaultCountry);                      
                    }
                },
                error: function (xhr, status) {
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }
        function GetBaseCurrency() {
            $.ajax({
                url: "../Common/CommonService.asmx/BaseCurrency",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                    BaseData = jQuery.parseJSON(result.d);
                    if (BaseData != null) {
                        $("#<%=PaymentControl.FindControl("txtCurrencyNotation").ClientID%>").val(BaseData[0]["Notation"]);
                        $("#<%=PaymentControl.FindControl("lblBaseCurrencyID").ClientID%>").text(BaseData[0]["B_CountryID"]);
                        $("#<%=PaymentControl.FindControl("lblBaseCurrency").ClientID%>").text(BaseData[0]["B_Currency"]);
                        $('#<%=PaymentControl.FindControl("ddlCountry").ClientID %>').val(BaseData[0]["CountryID"]);
                    }

                },
                error: function (xhr, status) {
                    $("#<%=lblMsg.ClientID%>").text('Error occurred, Please contact administrator');
                    window.status = status + "\r\n" + xhr.responseText;
                }

            });
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory" style="text-align: left;">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Label ID="lblHeader" runat="server" Style="font-weight: bold;" Text="Card Registration"></asp:Label><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
            <asp:TextBox ID="txtHash" CssClass="txtHash" Style="display: none;" runat="server"></asp:TextBox>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Patient Personal Details
                <asp:Label ID="lblAppID" runat="server" Visible="false"></asp:Label>
            </div>
            <table style="width: 100%; border-collapse:collapse">
                <tr>
                    <td style="width: 12%; text-align: right">First Name :&nbsp;</td>
                    <td style="width: 37%">
                        <asp:DropDownList ID="cmbTitle" runat="server" ToolTip="Select  Title" Width="55px"
                            TabIndex="1" onchange="AutoGender();" class="ddl">
                        </asp:DropDownList>
                        <asp:TextBox ID="txtPatientFirstName" runat="server" AutoCompleteType="Disabled"
                            ClientIDMode="Static" MaxLength="50" onkeypress="return check(this,event)" onkeyup="validatespace();"
                            TabIndex="2" ToolTip="Enter Patient First Name" Width="142px"></asp:TextBox>
                        <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                    <td style="width: 12%; text-align: right">Last Name :&nbsp;</td>
                    <td style="width: 35%">
                        <asp:TextBox ID="txtPatientLastName" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static" MaxLength="50" onkeypress="return check(this,event)" onkeyup="validatespace();" TabIndex="3" ToolTip="Enter Patient Last Name" Width="144px"></asp:TextBox>

                        <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 12%; text-align: right">
                        <asp:RadioButton ID="rdDOB" runat="server"  class="rad" CssClass="ItDoseLabel" GroupName="A" Text="DOB :&nbsp;" Width="65px" />
                    </td>
                    <td style="width: 37%">
                        <asp:TextBox ID="txtDOB" runat="server" ToolTip="Click To Select DOB" Width="144px"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDOB" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtDOB">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 12%; text-align: right">
                        <asp:RadioButton ID="rdAge" runat="server" Checked="True" GroupName="A" Text="Age :&nbsp;" CssClass="ItDoseLabel"
                            class="rad" />&nbsp;</td>
                    <td style="width: 35%">
                        <asp:TextBox ID="txtAge" runat="server" AutoCompleteType="Disabled" MaxLength="5" TabIndex="4" ToolTip="Enter Age" Width="65px"></asp:TextBox>
                        <asp:DropDownList ID="ddlAge" runat="server" class="ddl" onchange="validateAge();" Width="74px">
                            <asp:ListItem Value="YRS">YRS</asp:ListItem>
                            <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                            <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                        </asp:DropDownList>
                        <cc1:FilteredTextBoxExtender ID="Fage" runat="Server" FilterType="Numbers,Custom" TargetControlID="txtAge" ValidChars=".">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
                <tr>
                    <td style="width: 12%; text-align: right">Sex :&nbsp;</td>
                    <td style="width: 37%">
                        <asp:RadioButtonList ID="rblSex" runat="server" class="rad" RepeatDirection="Horizontal" TabIndex="4" ToolTip="Select Gender">
                            <asp:ListItem Selected="True" Text="Male" Value="Male">
                            </asp:ListItem>
                            <asp:ListItem Text="Female" Value="Female">
                            </asp:ListItem>
                        </asp:RadioButtonList>
                       
                    </td>
                    <td style="width: 12%; text-align: right">Marital Status :&nbsp;</td>
                    <td style="width: 35%">
                        <asp:DropDownList ID="ddlmarital" runat="server" class="ddl" ClientIDMode="Static" TabIndex="5" ToolTip="Select Martial Status" Width="150px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="width: 12%; text-align: right">Contact No. :&nbsp;</td>
                    <td style="width: 37%">
                        <asp:TextBox ID="txtContactNo" MaxLength="15" runat="server" TabIndex="5" AutoCompleteType="Disabled"
                            Width="144px" ToolTip="Enter Contact No."></asp:TextBox>
                        <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        <cc1:FilteredTextBoxExtender ID="ftbtxtContactNoNo" FilterType="Numbers" runat="server"
                            TargetControlID="txtContactNo">
                        </cc1:FilteredTextBoxExtender>

                       </td>
                    <td style="width: 12%; text-align: right">Email Address :&nbsp;</td>
                    <td style="width: 35%">
                        <asp:TextBox ID="txtEmailAddress" runat="server" TabIndex="6" AutoCompleteType="Disabled"
                            MaxLength="30" Width="144px" ToolTip="Enter Email Address"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="revEmail" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                            runat="server" Display="None" ControlToValidate="txtEmailAddress" ErrorMessage="Enter Valid Email Address"
                            ValidationGroup="save" SetFocusOnError="True"></asp:RegularExpressionValidator>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 12%; text-align: right" rowspan="2" valign="top">Address :&nbsp;</td>
                    <td style="width: 37%" rowspan="3">
                        <asp:TextBox ID="txtResidentialAddress" runat="server" AutoCompleteType="Disabled" Height="59px" MaxLength="100" TabIndex="11" TextMode="MultiLine" ToolTip="Enter Residential Address" Width="296px"></asp:TextBox>
                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px; font-family: Verdana;">*</asp:Label>
                    </td>
                    <td style="width: 12%; text-align: right">Country :&nbsp;</td>
                    <td style="width: 35%">
                        <asp:DropDownList ID="ddlNationality" runat="server" TabIndex="7" Width="150px" class="ddl"
                            ToolTip="Select Nationality"
                            onchange="getcity()">
                        </asp:DropDownList>&nbsp;</td>
                </tr>
                <tr>
                    <td style="width: 12%; text-align: right">City :&nbsp;</td>
                    <td style="width: 35%">
                        <asp:DropDownList ID="ddlCity" TabIndex="8" runat="server" Width="150px" AutoPostBack="false"
                            ToolTip="Select City" class="ddl">
                        </asp:DropDownList>
                       
                        <asp:Button ID="btnNewCity" TabIndex="9" runat="server" CssClass="ItDoseButton" Text="New"
                            ToolTip="Click To Add New City"></asp:Button>&nbsp;</td>
                </tr>

            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Card Details
            </div>
            <asp:Label ID="lblCardReg" ClientIDMode="Static" runat="server" Style="display: none"></asp:Label>
            <table style="border-collapse:collapse; width:100%" >
                <tr>
                    <td  style="width: 120px; text-align:right">Card Type :&nbsp;
                    </td>
                    <td style="text-align:left" >
                        <asp:DropDownList ID="ddlCardTypeReg" runat="server" TabIndex="18" Width="150px"
                            class="ddl" ClientIDMode="Static" ToolTip="Select Visit Type"  onchange="bindPaymentMode()">
                        </asp:DropDownList>
                        <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>

                    </td>
                    <td style="text-align: right">
                        <asp:Label ID="lblGovTaxPer" Style="display: none" runat="server"></asp:Label>
                        <asp:Label ID="lblCardRegistration" runat="server" Style="display: none"></asp:Label>
                    </td>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right; vertical-align:top">Card Rate :&nbsp;
                    </td>
                    <td style="text-align:left; vertical-align:top">

                        <asp:Label ID="lblAmount" runat="server" Style="font-weight: 700" ClientIDMode="Static">0</asp:Label>
                        <asp:TextBox ID="txtAmt" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                        <asp:TextBox ID="txtItemId" runat="server" ClientIDMode="Static" Style="display: none;"></asp:TextBox>
                        <asp:Label ID="lblItemID" runat="server" Visible="False" ClientIDMode="Static" Style="display: none;"></asp:Label>

                    </td>
                    <td style="text-align:right; vertical-align:top">
                        <asp:DropDownList ID="ddlDoctorList" runat="server" style="display:none" ClientIDMode="Static" TabIndex="19" ToolTip="Select Doctor" Width="180px">
                        </asp:DropDownList>

                    </td>
                    <td>&nbsp;
                       
                    </td>
                </tr>

            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Payment Collection Details
            </div>
            <uc:PaymentControl ID="PaymentControl" runat="server" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
            <input type="button" id="btnSaveReg" value="Save" class="ItDoseButton"  onclick="SaveRegistration()" />
        </div>
        
     

        <asp:Panel ID="pnlCity" runat="server" CssClass="pnlItemsFilter" Style="display: none"
            Width="300px">
            <div id="dragHandle" runat="server" class="Purchaseheader">
                Create New City&nbsp;
            </div>
            <div class="content">
                <table>
                    <tr>
                        <td>City:
                        </td>
                        <td>
                            <asp:TextBox ID="txtNewCity" runat="server" Width="140px" MaxLength="20"></asp:TextBox>
                            <asp:Label ID="lblCity" runat="server" CssClass="ItDoseLblError"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <input id="btnSaveCity" class="ItDoseButton" type="button" value="Save" onclick="SaveCity()" />
                            &nbsp;<asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpCity" runat="server" BackgroundCssClass="filterPupupBackground"
            CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlCity" PopupDragHandleControlID="dragHandle"
            TargetControlID="btnNewCity">
        </cc1:ModalPopupExtender>
    </div>
</asp:Content>

