<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="DonorRegistration.aspx.cs" Inherits="Design_BloodBank_DonorRegistration"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        var $bindPatientIDProof = function (callback) {
           
            serverCall('../common/CommonService.asmx/CentreWiseCache', {}, function (response) {
                var responseData = JSON.parse(response);
                var CentreWiseCache = responseData; //assign to global variables
                var $ddlIDProof = $('#<%= ddlIDProof.ClientID %>');

                var responseData = CentreWiseCache.filter(function (i) { return i.TypeID == '13' });
                $ddlIDProof.bindDropDown({ data: responseData, valueField: 'ValueField', textField: 'TextField' });


            });

           
        }

        function validate() {
            var ddl = document.getElementById('<%=ddlBagType.ClientID%>');
            var ddltxt = ddl.options[ddl.selectedIndex].value;
            if ($("#<%=txtfirstname.ClientID %>").val() == "") {
                $("#<%=lblerrmsg.ClientID %>").text('Enter Donor First Name');
                return false;
            }
            if ($("#<%=txtlastname.ClientID %>").val() == "") {
                $("#<%=lblerrmsg.ClientID %>").text('Enter Donor Last Name');
                return false;
            }
            if ($('#<%=txtKinName.ClientID %>').val() == "") {
                $('#<%=lblerrmsg.ClientID %>').text('Enter Kin Name');
                return false;
            }
            if ($('#<%=txtAddress.ClientID %>').val() == "") {
                $('#<%=lblerrmsg.ClientID %>').text('Enter Address');
                return false;
            }

            if ($('#<%=txtPhone.ClientID %>').val() == "") {
                $('#<%=lblerrmsg.ClientID %>').text('Enter Contact Number')
                return false;
            }
            if ($('#<%=ddlReleation.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Select Relation');
                return false;
            }

            //if ($("#<%=rdbFit.ClientID %> input[type=radio]:checked").val() == 'Yes') {
               // if (ddltxt == "0") {
             //       $('#<%=lblerrmsg.ClientID %>').text('Please Select Bag Type');
             //       return false;
              //  }
             //   if (ddltxt == "1") {
              //      if ($("#<%=ddlQty1.ClientID %>").val() == "0") {
               //         $('#<%=lblerrmsg.ClientID %>').text('Please Select Volume');
                //        return false;
                //    }
              //  }
               // if (ddltxt != "1" && ddltxt != "0") {
                //    if ($("#<%=ddlQty.ClientID %>").val() == "0") {
                //        $('#<%=lblerrmsg.ClientID %>').text('Please Select Volume');
                  //      return false;
                  //  }
              //  }
            // }

            if ($('#<%=txtPhone.ClientID %>').val().length < 10) {
                $('#<%=lblerrmsg.ClientID %>').text('Contact No. Must be 10-15 Digit');
                return false;
            }

            if ($("#<%=txtTemp.ClientID %>").val() > 37.8 || $("#<%=txtTemp.ClientID %>").val() < 34.4 && $("#<%=txtTemp.ClientID %>").val() != "") {
                $('#<%=lblerrmsg.ClientID %>').text('Person may not be fit to donate blood as \nTemprature is less than 34.4 or greater than 37.8');
                return false;
            }
            if ($("#<%=txtWeight.ClientID %>").val() > 200 || $("#<%=txtWeight.ClientID %>").val() < 45 && $("#<%=txtWeight.ClientID %>").val() != "") {
                $('#<%=lblerrmsg.ClientID %>').text('Person may not be fit to donate blood as \nWeight is less than 45kg or greater than 200Kg');
                return false;
            }
            if ($("#<%=txtPulse.ClientID %>").val() > 100 || $("#<%=txtPulse.ClientID %>").val() < 60 && $("#<%=txtPulse.ClientID %>").val() != "") {
                $('#<%=lblerrmsg.ClientID %>').text('Person may not be fit to donate blood as \nPulse is less than 60 or greater than 100');
                return false;
            }
            if ($("#<%=txtBP.ClientID %>").val() != "") {
                if ($("#<%=txtBP.ClientID %>").val().split('/')[0] > 180 || $("#<%=txtBP.ClientID %>").val().split('/')[0] < 100 || $("#<%=txtBP.ClientID %>").val().split('/')[1] > 100 || $("#<%=txtBP.ClientID %>").val().split('/')[1] < 60) {
                    $('#<%=lblerrmsg.ClientID %>').text('Person may not be fit to donate blood with this BP.');
                    return false;
                }
            }
            if ($('#<%=ddlHB.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Select Hemoglobin');
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
            }

        }

    </script>
    <script type="text/javascript">

        $(document).ready(function () {
            if ($('#<%=cmbTitle.ClientID%>').val() == "Mr.") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').attr('disabled', true);
                $('#<%=ddlAge.ClientID%>').prop("selectedIndex", 0);
                $("#<%=ddlAge.ClientID%> option[value='YRS']").attr("disabled", false);
                $("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").attr("disabled", true);
                $('#<%=ddlAge.ClientID%> option:contains("DAYS(S)")').attr('disabled', true);
            }
            else {
                AutoGender();
            }
            $('#<%=txtGender.ClientID %>').val($('#<%=rblSex.ClientID%> input:checked').val());
            $('#<%=rblSex.ClientID%>').change(function () {
                $('#<%=txtGender.ClientID %>').val($('#<%=rblSex.ClientID%> input:checked').val());
            });


            document.getElementById('pop1').style.display = 'none';

            setRowsInvisible("36");
            document.getElementById('<%=ddlQty.ClientID%>').style.display = 'none';
            if ($('#<%=rbDOB.ClientID %>').attr('checked')) {
                $('#<%=txtdob.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', false);
                $('#<%=txtAge1.ClientID %>').attr('disabled', true);
            }
            if ($('#<%=rbAge.ClientID %>').attr('checked')) {
                $('#<%=txtdob.ClientID %>').attr('disabled', true);
                $('#<%=txtAge1.ClientID %>').attr('disabled', false);


            }
            $("#<%=rbDOB.ClientID%>").click(function () {
                $('#<%=txtAge1.ClientID %>').val('');
                $('#<%=txtdob.ClientID %>').attr('disabled', false);
                $('#<%=txtAge1.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', true);
                $('#<%=ddlAge.ClientID%> option:nth-child(1)').attr('selected', '0');
            });

            $("#<%=rbAge.ClientID%>").click(function () {
                $('#<%=txtdob.ClientID %>').val('');
                $('#<%=txtdob.ClientID %>').attr('disabled', true);
                $('#<%=txtAge1.ClientID %>,#<%=ddlAge.ClientID %>').attr('disabled', false);
            });

        });
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            _doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
        function clearAllField() {
            a = document.getElementsByTagName("input");
            for (i = 0; i < a.length; i++) {
                if (a[i].type == "text") {
                    a[i].value = "";
                }
            }

            a = document.getElementsByTagName("select");

            for (i = 0; i < a.length; i++) {

                a[i].options[0].selected = true;
            }

            a = document.getElementsByTagName("textarea");
            for (i = 0; i < a.length; i++) {
                a[i].value = "";
            }

        }

        function clearform() {
            $(':text, textarea').val('');
            $(".chk").find(':checkbox').attr('checked', '');
            $(".rad").find(':radio').attr('checked', 'No');

            $('select:not(#<%=ddlDetail.ClientID%>) option:nth-child(1)').attr('selected', '0');
            $('#<%=rdbFit.ClientID %>').filter('[value="No"]').attr('checked', true);
        }
        function BagType() {

            $("#<%=ddlQty.ClientID %> option").remove();
            $("#<%=ddlQty.ClientID %>").append($("<option></option>").val('1').html('350 ml'));
            if ($("#<%=ddlBagType.ClientID %>").val() != "1") {
                $("#<%=ddlQty.ClientID %>").append($("<option></option>").val('2').html('450 ml'));

            }
        }
        $(document).ready(function () {
            bagtype2();
        });
        function bagtype2() {
            if ($("#<%=ddlBagType.ClientID %>").val() == "0") {
                $("#<%=ddlQty1.ClientID %>,#<%=ddlQty.ClientID %>,#<%=lblqty.ClientID %>").hide();
            }
            else {
                if ($("#<%=ddlBagType.ClientID %>").val() == "1") {
                    $("#<%=ddlQty1.ClientID %>,#<%=lblqty.ClientID %>").show();
                    $("#<%=ddlQty.ClientID %>").hide();
                }
                else {
                    $("#<%=ddlQty1.ClientID %>").hide();
                    $("#<%=ddlQty.ClientID %>,#<%=lblqty.ClientID %>").show();
                }
            }
        }
        function Bagtype1() {
            var ddl = document.getElementById('<%=ddlBagType.ClientID%>');
            var ddltxt = ddl.options[ddl.selectedIndex].value;
            if (ddltxt != "0") {
                if (ddltxt == "1") {
                    $("#<%=lblqty.ClientID %>").show();
                    $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
                    $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
                    document.getElementById('<%=ddlQty1.ClientID%>').style.display = '';
                    document.getElementById('<%=ddlQty.ClientID%>').style.display = 'none';

                }
                else {
                    $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
                    $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
                    $("#<%=lblqty.ClientID %>").show();
                    document.getElementById('<%=ddlQty1.ClientID%>').style.display = 'none';
                    document.getElementById('<%=ddlQty.ClientID%>').style.display = '';
                }
            }
            else {
                $("#<%=lblqty.ClientID %>,#<%=ddlQty1.ClientID%>,#<%=ddlQty.ClientID%>").hide();
            }

        }
        function SetColor(chk, SNO) {
            var snovalue = document.getElementById(SNO).innerHTML;
            var elements = document.getElementById(chk);
            var radio = elements.getElementsByTagName("input");
            for (var ii = 0; ii < radio.length; ii++) {
                if (radio[ii].checked) {
                    if (radio[ii].value == "1") {
                        elements.parentNode.parentNode.style.backgroundColor = "#ede49e"; //yes case
                        setRowsvisible(snovalue);
                    }
                    else {
                        elements.parentNode.parentNode.style.backgroundColor = "#afeeee"; //normal
                        setRowsInvisible(snovalue);
                    }
                }
            }

        }

        function setRowsvisible(SNO) {
            var rtpID = document.getElementById('<%=rptQues.ClientID %>');
            var lastRowIndex = rtpID.rows.length - 1;
            if (SNO == "36") {
                rtpID.rows[37].style.display = '';

            }
        }
        function setRowsInvisible(SNO) {

            var rtpID = document.getElementById('<%=rptQues.ClientID %>');
           // var lastRowIndex = rtpID.rows.length - 1;
            //if (SNO == "36") {
            //    rtpID.rows[37].style.display = 'none';

            //}
        }
    </script>
    <script type="text/javascript">
        function showError(err) {
            document.getElementById('<%= lblerrmsg.ClientID %>').innerHTML = err;
        }
        $(document).ready(function () {
            show();
            getcity();
            $("#txtcity").val($('#<%=ddlCity.ClientID %>').val());
            $('#<%=ddlCity.ClientID %>').change(function () {
                $("#txtcity").val($(this).val());
            });
        });
        function show() {
           // if ($("#<%=rdbFit.ClientID %> input[type=radio]:checked").val() == 'Yes') {
             //   $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
             //   $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
             //   $("#<%=ddlBagType.ClientID %>")[0].selectedIndex = 0;
               // $("#<%=ddlBagType.ClientID %>,#<%=ddlQty.ClientID %>,#<%=lblqty.ClientID %>,#<%=lblBagtype.ClientID %>").show();
               // $("#<%=lblRemark.ClientID %>,#<%=txtRemark.ClientID %>").hide();
              //  bagtype2();
            //}
           // else {
              //  $("#<%=ddlQty1.ClientID%>")[0].selectedIndex = 0;
              //  $("#<%=ddlQty.ClientID%>")[0].selectedIndex = 0;
               // $("#<%=ddlBagType.ClientID %>")[0].selectedIndex = 0;
              //  bagtype2();
               // $("#<%=ddlBagType.ClientID %>,#<%=ddlQty.ClientID %>,#<%=lblqty.ClientID %>,#<%=ddlQty1.ClientID %>,#<%=lblBagtype.ClientID %>").hide();
               // $("#<%=lblRemark.ClientID %>,#<%=txtRemark.ClientID %>").show();
            //}
        }


        function Age() {
            var elements = document.getElementById('s');
            var radio = elements.getElementsByTagName("input");
            for (var ii = 0; ii < radio.length; ii++) {
                if (radio[ii].checked) {
                    if (radio[ii].value == "Age") {
                        dvage.style.display = 'none';
                        dvdob.style.display = 'block';
                    }
                    else {
                        dvdob.style.display = 'none';
                        dvage.style.display = 'block';
                    }
                }
            }
        }



        function valWeight(fld) {

        }
        function valHb(fld) {
            var wt = fld.value;
            if (wt < 12.5 || wt > 17.0) {
                showError("Person may not be fit to donate blood as \nHemoglobin is less than 12.5 or greater than 17.0");
                return false;
            }
            else {
                showError("");
                return true;
            }

        }

        function valAge(fld) {
            var wt = fld.value;
            if (wt < 15 && wt > 0) {
                showError("Person may not be fit to donate blood as \nhis Age is less than 15.");
                return false;
            }
            else {
                showError("");
                return true;
            }

        }

        function valTemp(fld) {

        }

        function valPulse(fld) {

        }
        function bp() {
            var bp = $('#<%=txtBP.ClientID %>').val();
            var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
            if ($('#<%=txtBP.ClientID %>').val() != "") {
                if (!bpexp.test(bp)) {
                    alert('Please enter valid Bp ');
                    $('#<%=txtBP.ClientID %>').focus();
                    return false;
                }
                else {
                    return true;
                }
            }
        }
        function valBP(fld) {


        }
        function AutoGender() {
            var ddltitle = document.getElementById('<%=cmbTitle.ClientID%>');
            var ddltxt = ddltitle.options[ddltitle.selectedIndex].value;

            if (ddltxt == "Mr.") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').attr('disabled', true);
            }
            else if (ddltxt == "Mrs.") {
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr('disabled', true);
            }
            else if (ddltxt == "Miss." || ddltxt == "Baby" || ddltxt == "Madam") {
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr('disabled', true);
            }
            else if (ddltxt == "Master") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').attr('disabled', true);
            }

            else if (ddltxt == "B/O") {
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr('disabled', false);
                $('#<%=rblSex.ClientID%> :radio[value="Female"]').attr('disabled', false);

            }
            else if (ddltxt == "Dr." || ddltxt == "Er." || ddltxt == "Nana" || ddltxt == "Alhaji" || ddltxt == "Hajia" || ddltxt == "Prof.") {

                $('#<%=rblSex.ClientID%> :radio[value="Female"]').attr('disabled', false);
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr('disabled', false);

            }
            else {
                $('#<%=rblSex.ClientID%>').attr('disabled', false);
                $('#<%=rblSex.ClientID%> :radio[value="Male"]').attr('checked', true);

            }
    if (ddltxt == "B/O") {


        $('#<%=ddlAge.ClientID%>').prop("selectedIndex", 2);
        $("#<%=ddlAge.ClientID%> option[value='YRS']").attr("disabled", true);
        $("#<%=ddlAge.ClientID%> option[value='MONTH(S)'],#<%=ddlAge.ClientID%> option[value='DAYS(S)']").attr("disabled", false);


    }
    else if (ddltxt == "Baby" || ddltxt == 'Master') {

        $('#<%=ddlAge.ClientID%>').prop("selectedIndex", 1);
        $("#<%=ddlAge.ClientID%> option[value='YRS']").attr("disabled", false);
        $("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").attr("disabled", false);
        $('#<%=ddlAge.ClientID%> option:contains("DAYS(S)")').attr('disabled', false);

    }
    else {

        $('#<%=ddlAge.ClientID%>').prop("selectedIndex", 0);
        $("#<%=ddlAge.ClientID%> option[value='YRS']").attr("disabled", false);
        $("#<%=ddlAge.ClientID%> option[value='MONTH(S)']").attr("disabled", true);
        $('#<%=ddlAge.ClientID%> option:contains("DAYS(S)")').attr('disabled', true);

    }
    $('#<%=txtGender.ClientID %>').val($('#<%=rblSex.ClientID%> input:checked').val());


        }


        function Age1(fld) {
            var a = fld.value;
            if (a < 15 || a > 60) {
                alert("Age should Between 15 To 60");
                return false;
            }
            else {

                return true;
            }
        }


        function openPopup(btnName) {

            buttonName = document.getElementById(btnName).value;

            window.open('ReplacementPopUp.aspx?BTN=' + buttonName, null, 'left=100, top=100, height=480, width=792, status=no, resizable= no, scrollbars= no, toolbar= no,location= no, menubar= no');
            event.keyCode = 0
            return false;
        }

        function hide() {
            var tx = document.getElementById('<%=lblText.ClientID%>');
            var ddl = document.getElementById('<%=ddlType.ClientID%>');
            var ddltxt = ddl.options[ddl.selectedIndex].value;

            if (ddltxt == "0" || ddltxt == "1" || ddltxt == "3")
                document.getElementById('pop1').style.display = 'none';
            else
                document.getElementById('pop1').style.display = '';

            if (ddltxt == "1") {
                document.getElementById('<%=ddlDetail.ClientID%>').style.display = '';
                document.getElementById('<%=lblText.ClientID%>').style.display = '';
                document.getElementById('<%=lblIpdNo.ClientID%>').style.display = 'none';
                document.getElementById('<%=txtIpdNo.ClientID%>').style.display = 'none';
                document.getElementById('<%=txtDetail.ClientID%>').style.display = 'none';
                document.getElementById('<%=lblText1.ClientID%>').style.display = 'none';

            }
            if (ddltxt == "2") {
                document.getElementById('<%=txtDetail.ClientID%>').style.display = '';
                document.getElementById('<%=lblText1.ClientID%>').style.display = '';
                document.getElementById('<%=lblIpdNo.ClientID%>').style.display = 'none';
                document.getElementById('<%=txtIpdNo.ClientID%>').style.display = 'none';
                document.getElementById('<%=ddlDetail.ClientID%>').style.display = 'none';
                document.getElementById('<%=lblText.ClientID%>').style.display = 'none';

            }
            if (ddltxt == "3") {
                document.getElementById('<%=lblIpdNo.ClientID%>').style.display = '';
                document.getElementById('<%=txtIpdNo.ClientID%>').style.display = '';
                document.getElementById('<%=txtDetail.ClientID%>').style.display = 'none';
                document.getElementById('<%=lblText.ClientID%>').style.display = 'none';
                document.getElementById('<%=ddlDetail.ClientID%>').style.display = 'none';
                document.getElementById('<%=lblText.ClientID%>').style.display = 'none';
                document.getElementById('<%=lblText1.ClientID%>').style.display = 'none';

            }
            if (ddltxt == "0") {
                document.getElementById('<%=lblIpdNo.ClientID%>').style.display = 'none';
                document.getElementById('<%=txtIpdNo.ClientID%>').style.display = 'none';
                document.getElementById('<%=txtDetail.ClientID%>').style.display = 'none';
                document.getElementById('<%=ddlDetail.ClientID%>').style.display = 'none';
                document.getElementById('<%=lblText.ClientID%>').style.display = 'none';
                document.getElementById('<%=lblText1.ClientID%>').style.display = 'none';

            }
        }
        function validatespace() {
            var PfirstName = $('#<%=txtName.ClientID %>').val();
            var Dfirstname = $('#<%=txtfirstname.ClientID %>').val();
            var Dlastname = $('#<%=txtlastname.ClientID %>').val();
            var PKinName = $('#<%=txtKinName.ClientID %>').val();
            var Paddress = $('#<%=txtAddress.ClientID %>').val();

            var PEmail = $('#<%=txtEmail.ClientID %>').val();

            var PBP = $('#<%=txtBP.ClientID %>').val();
            var PWeight = $('#<%=txtWeight.ClientID %>').val();

            if (PfirstName.charAt(0) == ' ' || PfirstName.charAt(0) == '.' || PfirstName.charAt(0) == ',' || PfirstName.charAt(0) == '0' || PfirstName.charAt(0) == "'" || PfirstName.charAt(0) == "-") {
                $('#<%=txtName.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                PfirstName.replace(PfirstName.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblerrmsg.ClientID %>').text('');
            }
            if (Dfirstname.charAt(0) == ' ' || Dfirstname.charAt(0) == '.' || Dfirstname.charAt(0) == ',' || Dfirstname.charAt(0) == '0' || Dfirstname.charAt(0) == "'" || Dfirstname.charAt(0) == "-") {
                $('#<%=txtfirstname.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Dfirstname.replace(Dfirstname.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblerrmsg.ClientID %>').text('');
            }
            if (Dlastname.charAt(0) == ' ' || Dlastname.charAt(0) == '.' || Dlastname.charAt(0) == ',' || Dlastname.charAt(0) == '0' || Dlastname.charAt(0) == "'" || Dlastname.charAt(0) == "-") {
                $('#<%=txtlastname.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Dlastname.replace(Dlastname.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblerrmsg.ClientID %>').text('');
            }
            if (PKinName.charAt(0) == ' ' || PKinName.charAt(0) == '.' || PKinName.charAt(0) == ',' || PKinName.charAt(0) == '0' || PKinName.charAt(0) == "'" || PKinName.charAt(0) == "-") {
                $('#<%=txtKinName.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                PKinName.replace(PKinName.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblerrmsg.ClientID %>').text('');
            }
            if (Paddress.charAt(0) == ' ' || Paddress.charAt(0) == '.' || Paddress.charAt(0) == ',' || Paddress.charAt(0) == '0' || Paddress.charAt(0) == "'") {
                $('#<%=txtAddress.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Paddress.replace(Paddress.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblerrmsg.ClientID %>').text('');
            }

            if (PEmail.charAt(0) == ' ' || PEmail.charAt(0) == '.' || PEmail.charAt(0) == ',' || PEmail.charAt(0) == '0' || PEmail.charAt(0) == "'") {
                $('#<%=txtEmail.ClientID %>').val('');
                $('#<%=lblerrmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                PEmail.replace(PEmail.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblerrmsg.ClientID %>').text('');
            }

            if (PBP.charAt(0) == ' ' || PBP.charAt(0) == '.' || PBP.charAt(0) == ',' || PBP.charAt(0) == '0' || PBP.charAt(0) == "'" || PBP.charAt(0) == "/") {
                $('#<%=txtBP.ClientID %>').val('');

                $('#<%=lblerrmsg.ClientID %>').text('This can not be First Character');
                PBP.replace(PBP.charAt(0), "");
                return false;
            }
            else {
                $('#<%=lblerrmsg.ClientID %>').text('');
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
        function checkForSecond(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 47)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '/');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }

        function check(e) {
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

            validatespace();

            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function check1(sender, e) {
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
                    for (var j = 0; j < strLen; j++) {
                        hasDec = (strVal.charAt(j) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }


            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }


        function email() {
            var emailaddress = $('#<%=txtEmail.ClientID %>').val();
            var emailexp = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

            if (!emailexp.test(emailaddress)) {
                alert('Please enter valid email address.');
                $('#<%=txtEmail.ClientID %>').focus();
                return false;
            }
            else {
                return true;
            }
        }
        function homo() {
            var hb = document.getElementById('<%=ddlHB.ClientID%>').value;
            if (hb == "0") {
                showError("Please Select Hemoglobin ");
                return false;
            }
            else {
                showError("");
                return true;
            }
        }

        function ht() {
            alert("hi");
        }

        function openPopup11(btnName) {

            buttonName = document.getElementById(btnName).value;
            window.open('../BloodBank/PatientPopupIPD.aspx?BTN=' + buttonName, null, 'left=100, top=100, height=520, width=840, status=no, resizable= no, scrollbars= no, toolbar= no,location= no, menubar= no');
            event.keyCode = 0
            return false;
        }
        function getcity1() {

            var ddlCity = $("#<%=ddlCity.ClientID %>");
            $("#<%=ddlCity.ClientID %> option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/getCity",
                data: '{ Country: "' + $("#<%=ddlNationality.ClientID %> option:selected").val() + '"}', // parameter map
                type: "POST", // data has to be Posted  
                async: false,
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    if (CityData.length == 0) {
                        ddlCity.append($("<option></option>").val("0").html("---No Data Found---"));
                        $('#<%=txtcity.ClientID %>').val('');
                    }
                    else {
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].City).html(CityData[i].City));
                            if ($('#<%=txtcity.ClientID %>').val() == "")
                                $('#<%=txtcity.ClientID %>').val($('#<%= ddlCity.ClientID %> option:selected').text());

                        }
                    }
                    ddlCity.attr("disabled", false);

                },
                error: function (xhr, status) {
                    alert("Error ");
                    ddlCity.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function getcity() {

            var ddlCity = $("#<%=ddlCity.ClientID %>");
            $("#<%=ddlCity.ClientID %> option").remove();
            $.ajax({
                url: "DonorRegistration.aspx/getCity", //../Common/CommonService.asmx
                data: '{ CountryID:"' + $("#<%=ddlNationality.ClientID %> option:selected").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    if (CityData == null) {
                        ddlCity.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].City).html(CityData[i].City));
                            // $('#<%= ddlCity.ClientID %> option:selected').text($("#txtcity").val());
                            $("#txtcity").val($('#<%= ddlCity.ClientID %> option:selected').text());
                        }
                    }
                    ddlCity.attr("disabled", false);

                },
                error: function (xhr, status) {
                    alert("Error ");
                    ddlCity.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function SaveCity() {
            if ($.trim($("#<%=txtNewCity.ClientID %>").val()) != "") {
                $.ajax({
                    url: "DonorRegistration.aspx/CityInsert",
                    data: '{ CityName: "' + $("#<%=txtNewCity.ClientID %>").val() + '", CountryID: "' + $("#<%=ddlNationality.ClientID %>").val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data == "1") {
                            $('#<%=lblerrmsg.ClientID %>').text('City Saved Successfully');
                            $("#<%=ddlCity.ClientID %>").append($("<option></option>").val($("#<%=txtNewCity.ClientID %>").val()).html($("#<%=txtNewCity.ClientID %>").val()));
                            $("#<%=ddlCity.ClientID %>").val($("#<%=txtNewCity.ClientID %>").val());
                            $("#txtcity").val($("#<%=txtNewCity.ClientID %>").val());
                            $("#<%=txtNewCity.ClientID %>").val('');
                            $find('<%=mpCity.ClientID%>').hide();
                        }
                        else if (Data == "2") {
                            $('#<%=lblerrmsg.ClientID %>').text('City Already Exist');
                            $("#<%=txtNewCity.ClientID %>").val('');
                            $find('<%=mpCity.ClientID%>').hide();
                        }
                        else {
                            $('#<%=lblerrmsg.ClientID %>').text('City Not Saved');
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
            $('#<%=lblerrmsg.ClientID %>').text("Please Enter City Name");
                $("#<%=txtNewCity.ClientID %>").focus();
                $find('<%=mpCity.ClientID%>').show();
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Donor Registration</b><br />

            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Donor Detail
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblDonorId" runat="server" Text="Donor Id"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDonorId" runat="server" TabIndex="1"></asp:TextBox>
                            <asp:Label ID="lbldtentry" runat="server" Style="display: none;"></asp:Label>

                        </div>
                        <div class="col-md-5">
                            <input id="pop11" class="ItDoseButton" onclick="openPopup11('pop11');" tabindex="2"
                                type="button" value="Established Donor" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblDonId" runat="server" Style="display: none;" Text="Donor ID:"></asp:Label>
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDon" runat="server" Style="display: none;"></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" OnClick="btnSearch_Click"
                                Style="display: none;" Text="Search" />
                            <input id="pop12" class="ItDoseButton" onclick="openPopup11('pop12');" style="display: none;"
                                type="button" value="Old Patients" />&nbsp;
                            <asp:TextBox ID="txtVisit" runat="server" Width="80px"
                                Style="display: none"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbTitle" runat="server" ToolTip="select Sex" Width="55px"
                                TabIndex="3" onChange="AutoGender();">
                            </asp:DropDownList>
                            <asp:TextBox ID="txtfirstname" CssClass="requiredField" runat="server" TabIndex="4" onkeypress="return check1(this,event)"
                                autocomplete="off" onkeyup="validatespace();" Width="164px" ToolTip="Enter Name"
                                MaxLength="50">
                            </asp:TextBox>
                            <asp:Label ID="lblV" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Last Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtlastname" CssClass="requiredField" runat="server" TabIndex="4" onkeypress="return check1(this,event)"
                                autocomplete="off" onkeyup="validatespace();" ToolTip="Enter Name"
                                MaxLength="50">
                            </asp:TextBox>
                            <asp:Label ID="lblV0" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sex
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" TabIndex="4" Style="display: none;" onkeypress="return check1(this,event)"
                                autocomplete="off" onkeyup="validatespace();" Width="120px" ToolTip="Enter Name"
                                MaxLength="50">
                            </asp:TextBox>
                            <asp:RadioButtonList ID="rblSex" runat="server" RepeatDirection="Horizontal" ToolTip="Select Sex"
                                TabIndex="15">
                                <asp:ListItem Value="Male" Text="Male" Selected="True">
                                </asp:ListItem>
                                <asp:ListItem Value="Female" Text="Female">
                                </asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlType" runat="server" TabIndex="5" onChange="return hide();">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:RadioButton ID="rbDOB" runat="server" Text="DOB" GroupName="rb1" Checked="true"
                                    TabIndex="6" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdob" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="caldob" TargetControlID="txtdob" Format="dd-MMM-yyyy" Animated="true"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblText" runat="server" Text="Organisation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>:</b> " Style="display: none;"></asp:Label>
                                <asp:Label ID="lblText1" runat="server" Text="IPD No.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>:</b> " Style="display: none;"></asp:Label>
                                <asp:Label ID="lblIpdNo" runat="server" Text="IPD No.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>:</b> " Style="display: none;"></asp:Label>
                            </label>
                            <b class="pull-right"></b>&nbsp;
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDetail" runat="server" Style="display: none;"
                                TabIndex="6">
                            </asp:DropDownList>
                            <asp:TextBox ID="txtDetail" Width="84%" runat="server" Style="display: none;"
                                TabIndex="7"></asp:TextBox>
                            <input id="pop1" class="ItDoseButton" onclick="openPopup('pop1');" tabindex="8" type="button"
                                value="GO" style="display: none;" />
                            <asp:TextBox ID="txtIpdNo" runat="server"
                                Style="display: none;" MaxLength="10" TabIndex="9"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:RadioButton ID="rbAge" runat="server" Text="Age" GroupName="rb1" TabIndex="6" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAge1" runat="server" MaxLength="2"
                                Width="60px" onblur="Age1(this);" TabIndex="6"></asp:TextBox>&nbsp;
                            <cc1:FilteredTextBoxExtender ID="ftbAge" runat="server" FilterType="Numbers" TargetControlID="txtAge1">
                            </cc1:FilteredTextBoxExtender>
                            <asp:DropDownList ID="ddlAge" runat="server" Width="154px">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtGender" runat="server" Width="30" Style="display: none"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Kin Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtKinName" runat="server" CssClass="requiredField" TabIndex="7"
                                onkeypress="return check1(this,event)" onkeyup="validatespace();"
                                MaxLength="50"></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Relation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlReleation" CssClass="requiredField" runat="server" TabIndex="8">
                            </asp:DropDownList>
                            <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlblood" runat="server" TabIndex="9">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAddress" runat="server" TabIndex="10"
                                CssClass="requiredField" MaxLength="100" onkeyup="validatespace();"></asp:TextBox>
                            <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Country
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlNationality" CssClass="requiredField" runat="server" TabIndex="11"
                                class="ddl" ToolTip="Select Nationality" AutoPostBack="false" onchange="getcity()">
                            </asp:DropDownList>
                            <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                City
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCity" CssClass="requiredField" TabIndex="12" runat="server" Width="181px" AutoPostBack="false"
                                ToolTip="Select City" class="ddl">
                            </asp:DropDownList>
                            <asp:TextBox ID="txtcity" runat="server" ClientIDMode="Static" Style="display: none"></asp:TextBox>
                            <asp:Button ID="btnNewCity" runat="server" CssClass="ItDoseButton" Text="New" style="padding:2px 5px;" ToolTip="Click To Add New City"></asp:Button>
                            <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPhone" runat="server" TabIndex="13"
                                MaxLength="12" CssClass="requiredField"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" FilterType="Numbers" TargetControlID="txtPhone">
                            </cc1:FilteredTextBoxExtender>
                            <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Email
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmail" runat="server" TabIndex="14"
                                onblur="email(this);" MaxLength="100" onkeyup="validatespace();"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Last Donated
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBDonate" runat="server" TabIndex="15">
                                <asp:ListItem Text="Select" Selected="True" Value="0"></asp:ListItem>
                                <asp:ListItem Text="3 Month Ago"></asp:ListItem>
                                <asp:ListItem Text="6 Month Ago"></asp:ListItem>
                                <asp:ListItem Text="Yearly"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                 <div class="col-md-3">
			           <label class="pull-left"> ID Proof No. </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
				        <div class="row" style="margin:0px;">
					        <div class="col-md-12" style="padding-left:0px;padding-right:5px;">
<%--						        <select id="ddlIDProof" class="chosen-select" runat="server" name="ddlIDProof"></select>  --%>
                                <asp:DropDownList ID="ddlIDProof" runat="server" TabIndex="15" class="chosen-select">
                                    <asp:ListItem Value="Alien ID" Text="Alien ID"></asp:ListItem>
                                    <asp:ListItem Value="Huduma No"  Text="Huduma No"></asp:ListItem>
                                    <asp:ListItem Value="ID Card"  Text="ID Card"></asp:ListItem>
                                    <asp:ListItem Value="National ID"  Text="National ID"></asp:ListItem>
                                    <asp:ListItem  Value="Passport" Text="Passport"></asp:ListItem>
                                </asp:DropDownList> 

					        </div>
					        <div class="col-md-12" style="padding-left:0px;padding-right:0px;">
						        <input type="text" id="txtIDProofNo" name="txtIDProofNo" runat="server" onkeyup="previewCountDigit(event,function(e){patientSearchOnEnter(e)});"  autocomplete="off"  data-title="Enter Id Card No." onlytextnumber="25"   maxlength="14"/>
					        </div>
			           </div> 
			        </div>   
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Questionnaire
            </div>
            <div style="max-height: 150px; overflow: auto;">
                <asp:GridView ID="rptQues" runat="server" AutoGenerateColumns="False" OnRowDataBound="rptQuest_DataBound"
                    OnRowCommand="rptQuest_RowCommand" TabIndex="24" CssClass="GridViewStyle" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblSeq" Text='<%#Container.DataItemIndex+1 %>' runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Question">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="340px" />
                            <ItemTemplate>
                                <asp:Label ID="lblQues" runat="server" Text='<%# Eval("Questions")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Response">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemTemplate>
                                <asp:Label ID="lblQuestId" runat="server" Text='<%#Eval("question_ID") %>' Visible="false"></asp:Label>
                                <asp:RadioButtonList ID="rdbAns" runat="server" RepeatDirection="Horizontal" class="rad"
                                    TabIndex="24">
                                    <asp:ListItem Value="1">YES</asp:ListItem>
                                    <asp:ListItem Value="0">NO</asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:TextBox ID="txtAns" runat="server" Width="50px" MaxLength="100" TabIndex="24"></asp:TextBox>
                                <asp:Label ID="lblType" runat="server" Text='<%#Eval("Type") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remarks">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="400px" />
                            <ItemTemplate>
                                <asp:TextBox ID="txtRemarks" runat="server"  MaxLength="100"></asp:TextBox>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sex">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblGender" runat="server" Text='<%#Eval("Gender") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Text='<%#Eval("Status") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Flag" Visible="false">
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                            <ItemTemplate>
                                <asp:Label ID="lblFlag" runat="server" Text='<%#Eval("Flag") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Health Status
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                B.P.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBP" runat="Server" MaxLength="7"
                                onblur="bp(this);" onkeypress="return checkForSecond(this,event)" onkeyup="validatespace();"
                                TabIndex="25" ValidationGroup="saveQuestion" Width="150px"></asp:TextBox>
                            mm/Hg
                            <cc1:FilteredTextBoxExtender ID="ftbBP" runat="server" TargetControlID="txtBP" ValidChars="/0987654321">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Weight
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtWeight" runat="Server" MaxLength="3" onkeypress="return checkForSecondDecimal(this,event)"
                                TabIndex="26" ValidationGroup="saveQuestion" Width="150px"></asp:TextBox>
                            <span>Kg.
                                <cc1:FilteredTextBoxExtender ID="ftbWeight" runat="server" TargetControlID="txtWeight"
                                    ValidChars="0987654321">
                                </cc1:FilteredTextBoxExtender>
                            </span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Temp
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTemp" runat="Server" TabIndex="27"
                                ValidationGroup="saveQuestion" Width="150px" MaxLength="4" onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox><sup><span>0</span></sup>C
                            <cc1:FilteredTextBoxExtender ID="ftbTemp" runat="server" TargetControlID="txtTemp"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Pulse
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPulse" runat="server" MaxLength="3"
                                TabIndex="28" ValidationGroup="saveQuestion" Width="150px"></asp:TextBox>
                            p-m
                            <cc1:FilteredTextBoxExtender ID="ftbPulse" runat="server" FilterType="Numbers" TargetControlID="txtPulse">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Height
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtHeight" runat="Server" TabIndex="29"
                                ValidationGroup="saveQuestion" Width="150px" MaxLength="6"  onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>cm&nbsp;
                            <cc1:FilteredTextBoxExtender ID="ftcHeight" runat="server" TargetControlID="txtHeight"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Hemoglobin
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="requiredField" ID="ddlHB" Width="150px" runat="server" TabIndex="30" Height="21px">
                                <asp:ListItem Selected="True" Text="Select" Value="0"></asp:ListItem>
                                <asp:ListItem Text="&lt;12.5"></asp:ListItem>
                                <asp:ListItem Text="&gt;12.5"></asp:ListItem>
                            </asp:DropDownList>
                            Hb
                            <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3" style="display:none;">
                            <label class="pull-left">
                                GPE
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"  style="display:none;">
                            <asp:TextBox ID="txtGpe" runat="server" TabIndex="31"
                                onkeypress="return checkForSecondDecimal(this,event)" ValidationGroup="saveQuestion"
                                Width="150px" MaxLength="5"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbgpe" runat="server" TargetControlID="txtGpe"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Fit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbFit" runat="server"
                                onclick="show();" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="Yes" Selected="True"></asp:ListItem>
                                <asp:ListItem  Text="No" Value="No"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblPlate" runat="server" Text="Platelet Count"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPlate" runat="server" Width="150px" MaxLength="10" TabIndex="33"
                                onkeypress="return checkForSecondDecimal(this,event)"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbPlatelet" runat="server" TargetControlID="txtPlate"
                                ValidChars=".0987654321">
                            </cc1:FilteredTextBoxExtender>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lbl" runat="server" Text="Phlebotomy Side"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPhle" runat="server" Width="150px" Height="21px" TabIndex="32">
                                <asp:ListItem Text="Select" Selected="True" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Left"></asp:ListItem>
                                <asp:ListItem Text="Right"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblRemark" Text="Remark" runat="server"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemark" runat="server" MaxLength="50"
                                TabIndex="33" ValidationGroup="saveQuestion" Width="150"></asp:TextBox>
                        </div>
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                 <asp:Label ID="lblBagtype" Text="Bag Type :" runat="server"></asp:Label>
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5" style="display:none">
                               <asp:DropDownList ID="ddlBagType" runat="server" OnChange="Bagtype1();" TabIndex="34"
                            ValidationGroup="saveQuestion" Width="150px">
                        </asp:DropDownList>
                        </div>
                        <div class="col-md-3" style="display:none">
                    <label class="pull-left">
                        <asp:Label ID="lblqty" Text="Quantity" runat="server"></asp:Label>
                    </label>
                    <b class="pull-right"></b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlQty" runat="Server" TabIndex="35" ValidationGroup="saveQuestion"
                            Width="75px">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">350 ml</asp:ListItem>
                            <asp:ListItem Value="2">450 ml</asp:ListItem>
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlQty1" runat="Server" TabIndex="35" ValidationGroup="saveQuestion"
                            Width="75px" Style="display: none">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">350 ml</asp:ListItem>
                        </asp:DropDownList>
                </div>
                    </div>
                    <div class="row">
                
            </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <%--<table style="width: 100%">
                <tr>
                    <td style="width: 7%; text-align: right;">
                        <asp:Label ID="lblqty" Text="Quantity :&nbsp;" runat="server"></asp:Label>
                    </td>
                    <td colspan="2">
                        <asp:DropDownList ID="ddlQty" runat="Server" TabIndex="35" ValidationGroup="saveQuestion"
                            Width="75px">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">350 ml</asp:ListItem>
                            <asp:ListItem Value="2">450 ml</asp:ListItem>
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlQty1" runat="Server" TabIndex="35" ValidationGroup="saveQuestion"
                            Width="75px" Style="display: none">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="1">350 ml</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>--%>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save"   CausesValidation="false" CssClass="ItDoseButton save" style="margin-top:7px"
                TabIndex="38" OnClick="btnSave_Click" OnClientClick="return validate();" UseSubmitBehavior="false" />
        </div>
        <div id="divResult" class="POuter_Box_inventory" style="display: none;">
            <asp:Label ID="lblSession" runat="server" Text=""></asp:Label>
            <asp:Label ID="lblCentreID" runat="server" Text=""></asp:Label>
        </div>
        <div style="display: none;">
            <input type="button" id="btnonload" class="ItDoseButton" />
        </div>
        <asp:Panel ID="pnlCity" runat="server" CssClass="pnlItemsFilter" Style="display: none"
            Width="300px">
            <div id="dragHandle" runat="server" class="Purchaseheader">
                Create New City&nbsp;
            </div>
            <div class="">
                <table>
                    <tr>
                        <td>City:
                        </td>
                        <td>
                            <asp:TextBox ID="txtNewCity" runat="server" Width="140px" MaxLength="20"></asp:TextBox>
                            <asp:Label ID="lblCity" runat="server" CssClass="ItDoseLblError"></asp:Label>
                            <asp:RequiredFieldValidator ID="reqCity" runat="server" ValidationGroup="SaveCity"
                                ErrorMessage="Enter City" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtNewCity"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td>
                            <input id="btnSaveCity" type="button" value="Save" onclick="SaveCity()" class="ItDoseButton" />
                           <asp:Button
                                ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
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
