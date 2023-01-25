<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Employee_Registration.aspx.cs" Inherits="Design_Payroll_Employee_Registration" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:content id="Content1" contentplaceholderid="ContentPlaceHolder1" runat="Server">
    <style>
    </style>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript">


        function chkAll(chk)
        {
            if (chk == true)
            {
                $('#txtOhouseNo').val($('#txtHouseNo').val());
                $('#txtOStreet').val($('#txtStreet').val());
                $('#txtOlocality').val($('#txtLocality').val());
                $('#txtOPinCode').val($('#txtPinCode').val());

            }

            else
            {
                $('#txtOhouseNo').val('');
                $('#txtOStreet').val('');
                $('#txtOlocality').val('');
                $('#txtOPinCode').val('');

            }

        }
        function alertDelete() {
            var answer = confirm("Are you sure to remove Qulification?")
            if (answer) {
                return true;
            }
            else
                return false;
        }

        function hideSelfFrame() {
            window.top.document.getElementById("iframePatient").style.width = "0px";
            window.top.document.getElementById("iframePatient").style.height = "0px";
            window.top.document.getElementById("iframePatient").src = "";
            window.top.document.getElementById("iframePatient").style.display = "none";
            window.top.document.getElementById("Pbody_box_inventory").style.display = "";

        }

        function email() {
            var emailaddress = $('#<%=txtEmail.ClientID %>').val();
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                $('#<%=lblmsg.ClientID %>').text('Please Enter Valid Email Address');
                $('#<%=txtEmail.ClientID %>').val('');
                $('#<%=txtEmail.ClientID %>').focus();
                return false;
            }
        }
        $(document).ready(function () {
            AutoGender();
            getCity();
            bindDesignation(function () {
                var isAutoEmpRegistration = '<%= Resources.Resource.Employee_RegistrationNo_Generate%>';
                var EmpID = '<%=Util.GetString(Request.QueryString["EmpID"])%>';
                if (String.isNullOrEmpty(EmpID) || String.isNullOrEmpty($('#ctl00_ContentPlaceHolder1_lblEmpRegNo').text())) {
                    // 1 for Mannual and 0 for Auto
                    if (isAutoEmpRegistration == '0') {
                        getEmployeeRegistrationNo(function () {

                        });
                    }
                    else {
                     //   $('#txtRegNo').attr('disabled', 'disabled');
                    }
                }
                else {
                    $('#txtRegNo').attr('disabled', 'disabled');
                    $('#btnSelectedCandidate').hide();
                }
            });
         //   LoadCentre()
        //    LoadBloodBankBloodGroup();
        //    LoadDrivingLiscenceType();
            $('#<%=txtGender.ClientID %>').val($('#<%=rbtnGender.ClientID%> input:checked').val());
            $('#<%=rbtnGender.ClientID%>').change(function () {
                $('#<%=txtGender.ClientID %>').val($('#<%=rbtnGender.ClientID%> input:checked').val());
                var rbvalue = $("#<%=rbtnGender.ClientID%> input:radio:checked").val();

            });
            var EmpID1 = '<%=Util.GetString(Request.QueryString["EmpID"])%>';
            if (EmpID1 == "") {
                var chk = $("#<%=rbtnGender.ClientID%>").find("input[name='<%=rbtnGender.UniqueID%>']:radio:checked").val();

            }
            $("#txtBranch").val($('#<%=ddlBranch.ClientID %>').val());
            $('#<%=ddlBranch.ClientID %>').change(function () {
                $("#txtBranch").val($(this).val());
            });
            var MaxLength = 100;
            //            $("#<% =txtHouseNo.ClientID %>,#<%=txtOhouseNo.ClientID%>").bind("cut copy paste", function (event) {
            //                event.preventDefault();
            //            });
            $('#<%=txtHouseNo.ClientID%>,#<%=txtOhouseNo.ClientID%>').bind("keypress", function (e) {
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

        var getEmployeeRegistrationNo = function () {
            serverCall('Employee_Registration.aspx/getEmployeeRegistrationNo', {}, function (response) {
                var responseData = JSON.parse(response);
                $('#txtRegNo').val(responseData.response);
            });
        }
        function AutoGender() {

            var ddltitle = document.getElementById('<%=cmdTitle.ClientID%>');
            var ddltxt = ddltitle.options[ddltitle.selectedIndex].text;
            if (ddltxt == "Mr.") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', true);
                //                $("#<%=txtHusbandName.ClientID%>").attr("disabled", "disabled")
            }
            else if (ddltxt == "Mrs.") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('disabled', true);
                //                $('#<%=txtHusbandName.ClientID%>').removeAttr("disabled");
            }
            else if (ddltxt == "Miss." || ddltxt == "Baby" || ddltxt == "Madam") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr({ checked: true, disabled: true });
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('disabled', true);
                //                $('#<%=txtHusbandName.ClientID%>').removeAttr("disabled");
            }
            else if (ddltxt == "Master") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: true });
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', true);
                //                $('#<%=txtHusbandName.ClientID%>').attr("disabled", "disabled")
            }

            else if (ddltxt == "B/O") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr({ checked: true, disabled: false });
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', false);
                //                $('#<%=txtHusbandName.ClientID%>').attr("disabled", "disabled")
            }
            else if (ddltxt == "Dr." || ddltxt == "Er." || ddltxt == "Nana" || ddltxt == "Alhaji" || ddltxt == "Hajia" || ddltxt == "Prof.") {
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('disabled', false);
                $('#<%=rbtnGender.ClientID%> :radio[value="Female"]').attr('disabled', false);
                $('#<%=rbtnGender.ClientID%> :radio[value="TGender"]').attr('disabled', false);
                //                $('#<%=txtHusbandName.ClientID%>').attr('disabled', false);
            }
            else {
                $('#<%=rbtnGender.ClientID%>').attr('disabled', false);
                $('#<%=rbtnGender.ClientID%> :radio[value="Male"]').attr('checked', true);
                //                $('#<%=txtHusbandName.ClientID%>').removeAttr("disabled");

            }
            $('#<%=txtGender.ClientID %>').val($('#<%=rbtnGender.ClientID%> input:checked').val());
        }
       
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var EmpID1;
            EmpID1 = '<%=Util.GetString(Request.QueryString["EmpID"])%>';
            if (EmpID1 != "") {
                $("#<%=chkLogin.ClientID%>").hide();

                $("#<%=pnlHide.ClientID %>").show();
                $(".dol").show();
                $("#<%=txtDOL.ClientID %>").attr("readonly", true);
                $("#<%=txtDOL.ClientID %>").bind('keypress keydown', function (e) {
                    var keycode = e.keyCode ? e.keyCode : e.which;
                    if ((keycode == 8) || (keycode == 46)) {
                        if ($("#<%=txtDOL.ClientID %>").val().length > 0) {
                            $("#<%=txtDOL.ClientID %>").removeAttr("readonly");
                            $("#<%=txtDOL.ClientID %>").val('');
                        }
                        else {
                            $("#<%=txtDOL.ClientID %>").attr("readonly", "readonly");
                        }
                    }

                });

            }
            else {
                $("#<%=pnlHide.ClientID %>").hide();
                $(".dol").hide();
                $("#<%=txtDOL.ClientID %>").bind('keypress keydown', function (e) {
                    var keycode = e.keyCode ? e.keyCode : e.which;
                    if ((keycode == 8) || (keycode == 46)) {
                        if ($("#<%=txtDOL.ClientID %>").val().length > 0) {
                            $("#<%=txtDOL.ClientID %>").removeAttr("readonly");
                            $("#<%=txtDOL.ClientID %>").val('');
                        }
                        else {
                            $("#<%=txtDOL.ClientID %>").attr("readonly", "readonly");
                        }
                    }
                });
                ShowEmp();
                showNewEmp();
            }

        });
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)

            validatespace();
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";"  || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function validatespace() {
            var Name = $('#<%=txName.ClientID %>').val();
            var FatherName = $('#<%=txtFather.ClientID %>').val();
            var MotherName = $('#<%=txtMother.ClientID %>').val();
            var HusbandName = $('#<%=txtHusbandName.ClientID %>').val();
            var PFNominee1 = $('#<%=txtPF_Nominee1.ClientID %>').val();
            var PFNominee2 = $('#<%=txtPF_Nominee2.ClientID %>').val();
            var kinname = $('#<%=txtKinName.ClientID %>').val();
            if (Name.charAt(0) == ' ' || Name.charAt(0) == '.' || Name.charAt(0) == ',' || Name.charAt(0) == '0' || Name.charAt(0) == "'" || Name.charAt(0) == '-') {
                $('#<%=txName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Name.replace(Name.charAt(0), "");
                return false;
            }
            if (FatherName.charAt(0) == ' ' || FatherName.charAt(0) == '.' || FatherName.charAt(0) == ',' || FatherName.charAt(0) == '0' || FatherName.charAt(0) == "'" || FatherName.charAt(0) == '-') {
                $('#<%=txtFather.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                FatherName.replace(FatherName.charAt(0), "");
                return false;
            }
            if (MotherName.charAt(0) == ' ' || MotherName.charAt(0) == '.' || MotherName.charAt(0) == ',' || MotherName.charAt(0) == '0' || MotherName.charAt(0) == "'" || MotherName.charAt(0) == '-') {
                $('#<%=txtMother.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                MotherName.replace(MotherName.charAt(0), "");
                return false;
            }
            if (HusbandName.charAt(0) == ' ' || HusbandName.charAt(0) == '.' || HusbandName.charAt(0) == ',' || HusbandName.charAt(0) == '0' || HusbandName.charAt(0) == "'" || HusbandName.charAt(0) == '-') {
                $('#<%=txtKinName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                HusbandName.replace(HusbandName.charAt(0), "");
                return false;
            }
            if (kinname.charAt(0) == ' ' || kinname.charAt(0) == '.' || kinname.charAt(0) == ',' || kinname.charAt(0) == '0' || kinname.charAt(0) == "'" || kinname.charAt(0) == '-') {
                $('#<%=txtHusbandName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                kinname.replace(kinname.charAt(0), "");
                return false;
            }
            if (PFNominee1.charAt(0) == ' ' || PFNominee1.charAt(0) == '.' || PFNominee1.charAt(0) == ',' || PFNominee1.charAt(0) == '0' || PFNominee1.charAt(0) == "'") {
                $('#<%=txtPF_Nominee1.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                PFNominee1.replace(PFNominee1.charAt(0), "");
                return false;
            }
            if (PFNominee2.charAt(0) == ' ' || PFNominee2.charAt(0) == '.' || PFNominee2.charAt(0) == ',' || PFNominee2.charAt(0) == '0' || PFNominee2.charAt(0) == "'") {
                $('#<%=txtPF_Nominee2.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                PFNominee2.replace(PFNominee2.charAt(0), "");
                return false;
            }

            else {
                $('#<%=lblmsg.ClientID %>').text('');
                return true;
            }
            // validateName();
        }
        function validateDOL() {
            var start1 = $("#<%=txtDOJ.ClientID %>").val();
            var end1 = $("#<%=txtDOL.ClientID %>").val();
            var splitdate1 = start1.split("-");
            var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
            var splitdate11 = end1.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);
            if ($("#<%=txtDOL.ClientID %>").val() != "") {
                if (newStartDate1 > newEndDate1) {
                    alert("Date Of Leaving should be Greater than Date of Joining");
                    return false;
                }
            }

            validate();

        }
    
    </script>
    <script type="text/javascript">
        //function DisableButtons() {
        //    var inputs = document.getElementsByTagName("INPUT");
        //    for (var i in inputs) {
        //        if (inputs[i].type == "button" || inputs[i].type == "submit") {
        //            inputs[i].disabled = true;
        //            inputs[i].value = "Submitting...";
        //        }
        //    }
        //}
       // window.onbeforeunload = DisableButtons;
    </script>
    <script type="text/javascript">
        function getBranch() {
            var ddlBranch = $("#<%=ddlBranch.ClientID %>");
            $("#<%=ddlBranch.ClientID %> option").remove();
            $.ajax({
                url: "Services/CommonServices.asmx/getBranch",
                data: '{ BankID: "' + $("#<%=ddlBankName.ClientID %> ").val() + '"}', // parameter map
                type: "POST", // data has to be Posted
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    BranchData = jQuery.parseJSON(result.d);
                    if (BranchData.length == 0) {
                        ddlBranch.append($("<option></option>").val("0").html("---No Branch Found---"));
                    }
                    else {
                        ddlBranch.append($("<option></option>").val("Select").html("Select"));
                        for (i = 0; i < BranchData.length; i++) {
                            ddlBranch.append($("<option></option>").val(BranchData[i].Branch_ID).html(BranchData[i].BranchName));
                            $("#txtBranch").val($('#<%= ddlBranch.ClientID %>').val());
                        }
                    }
                    ddlBranch.attr("disabled", false);
                },
                error: function (xhr, status) {
                    alert("Error ");
                    ddlBranch.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
            if ($("#<%=ddlBankName.ClientID %> option:selected").text() != "Select") {
            }
            else {

            }
        }

        function getIFSCCode()
        {
            $.ajax({
                url: "Services/CommonServices.asmx/GetIFSCCode",
                data:'{BranchID:"'+ $("#<%=ddlBranch.ClientID %>").val()+'"}',
                type:"POST",
                contentType:"application/json; charset=utf-8",
                timeout:120000,
                dataType:"json",
                success:function(result){
                    IFSCData=jQuery.parseJSON(result.d);
                   
                    if(IFSCData.length!=0)
                        {
                        $('#txtIFSCCode').val(IFSCData[0].IFSC_Code);
                    }    
                },

            });
        }

        function validate() {
            if (typeof (Page_Validators) == "undefined") return;
            var Name = document.getElementById("<%=reqName.ClientID%>");
            var Dept = document.getElementById("<%=reqDept.ClientID%>");
            var Des = document.getElementById("<%=reqDes.ClientID%>");
            var LHouse = document.getElementById("<%=reqLHouse.ClientID%>");
            var LCity = document.getElementById("<%=reqCity.ClientID%>");
            var LLocality = document.getElementById("<%=reqLocality.ClientID%>");
            var OHouse = document.getElementById("<%=reqOHouse.ClientID%>");
            var OCity = document.getElementById("<%=reqOCity.ClientID%>");
            var OLocality = document.getElementById("<%=reqolocality.ClientID%>");
            var Email = document.getElementById("<%=revEmail.ClientID%>");
            var Reg = document.getElementById("<%=ReguExpress.ClientID%>");
            var RegKinPhone = document.getElementById("<%=regKinPhone.ClientID%>");
            var RegPhoneNo = document.getElementById("<%= regPhoneNo.ClientID%>");
            var LblName = document.getElementById("<%=lblmsg.ClientID%>");
            var EmpID = $('#txtRegNo').val().trim();
            ValidatorValidate(Name);
            if (String.isNullOrEmpty(EmpID) && '<%= Resources.Resource.Employee_RegistrationNo_Generate%>'=='1') {
                modelAlert('Please Enter Employee ID', function () {
                    $('#txtRegNo').focus();
                });
                return false;
            }
            if (!Name.isvalid) {
                LblName.innerText = Name.errormessage;
                return false;
            }
            ValidatorValidate(Dept);
            if (!Dept.isvalid) {
                LblName.innerText = Dept.errormessage;
                return false;
            }
            ValidatorValidate(Des);
            if (!Des.isvalid) {
                LblName.innerText = Des.errormessage;
                return false;
            }
            ValidatorValidate(LHouse);
            if (!LHouse.isvalid) {
                LblName.innerText = LHouse.errormessage;
                return false;
            }
            ValidatorValidate(LCity);
            if (!LCity.isvalid) {
                LblName.innerText = LCity.errormessage;
                return false;
            }
            ValidatorValidate(LLocality);
            if (!LLocality.isvalid) {
                LblName.innerText = LLocality.errormessage;
                return false;
            }
            ValidatorValidate(OHouse);
            if (!OHouse.isvalid) {
                LblName.innerText = OHouse.errormessage;
                return false;
            }
            ValidatorValidate(OCity);
            if (!OCity.isvalid) {
                LblName.innerText = OCity.errormessage;
                return false;
            }
            ValidatorValidate(OLocality);
            if (!OLocality.isvalid) {
                LblName.innerText = OLocality.errormessage;
                return false;
            }
            ValidatorValidate(RegPhoneNo);
            if (!RegPhoneNo.isvalid) {
                LblName.innerText = RegPhoneNo.errormessage;
                return false;
            }
            ValidatorValidate(Reg);
            if (!Reg.isvalid) {
                LblName.innerText = Reg.errormessage;
                return false;
            }
            ValidatorValidate(Email);
            if (!Email.isvalid) {
                LblName.innerText = Email.errormessage;
                return false;
            }

            ValidatorValidate(RegKinPhone);
            if (!RegKinPhone.isvalid) {
                LblName.innerText = RegKinPhone.errormessage;
                return false;
            }

            if ($("#<%=ddlBankName.ClientID %> option:selected").text() != "Select" && $("#<%=txtBankAccNo.ClientID %>").val() == "") {
                $("#<%=lblmsg.ClientID %>").text("Please Enter Bank Account No.");
                $("#<%=txtBankAccNo.ClientID %>").focus();
                return false;
            }
            if ($("#<%=ddlBankName.ClientID %> option:selected").text() != "Select" && $("#<%=ddlBranch.ClientID %> option:selected").text() == "---No Branch Found---") {
                $("#<%=lblmsg.ClientID %>").text("Please Select Branch Name");
                $("#<%=ddlBranch.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtDOL.ClientID %>").is(':visible') == true) {
                var start1 = $("#<%=txtDOJ.ClientID %>").val();
                var end1 = $("#<%=txtDOL.ClientID %>").val();
                var splitdate1 = start1.split("-");
                var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
                var splitdate11 = end1.split("-");
                var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

                var newStartDate1 = Date.parse(dt11);
                var newEndDate1 = Date.parse(dt21);

                if ($("#<%=txtDOL.ClientID %>").val() != "") {
                    if (newStartDate1 > newEndDate1) {
                        alert("Date Of Leaving should be Greater than Date of Joining");
                        return false;
                    }
                }
            }
            if ($("#<%=chkLogin.ClientID%>").is(':checked') == true) {
               // if ($("#<%=chkNewEmp.ClientID%>").is(':checked') == false && $("#<%=ddlExistEmp.ClientID%> option:selected").val() == "0") {
             //       LblName.innerText = "Please Select Any of HIS Employee";
             //       $("#<%=ddlExistEmp.ClientID%> option:selected").focus();
            //        return false;
            //    }

            }
            if ($("#<%=txtMobile.ClientID%>").text == "") {
                LblName.innerText = "Enter Mobile No.";
                $("#<%=txtMobile.ClientID%>").focus();
                return false;
            }
            if ($('#cmbUserType').val() == '0') {
                modelAlert('Please Select User Type', function () {
                    $('#cmbUserType').focus();
                });
                return false;
            }
            if ($('#ddlUserGroup').val() == '0') {
                modelAlert('Please Select User Group', function () {
                    $('#ddlUserGroup').focus();
                });
                return false;
            }

        }
        function ShowEmp() {

            var chk = document.getElementById('<%=chkLogin.ClientID %>');
            if (chk.checked == true) {
                $("#bindEmp").show();
                $('#<%=ddlExistEmp.ClientID%>').removeAttr("disabled");
                document.getElementById('<%=chkNewEmp.ClientID %>').checked = false;
            }
            else {
                $("#bindEmp").hide();
                $("#newEmp").hide();
            }

        }
        function showNewEmp() {
            var chk = document.getElementById('<%=chkLogin.ClientID %>');
         //   var chkNew = document.getElementById('<%=chkNewEmp.ClientID %>');
            //    if (chk.checked == true && chkNew.checked == true) {
            if (chk.checked == true){
                $("#newEmp").show();
             //   $('#<%=ddlExistEmp.ClientID%>').attr("disabled", true);
            }
            else {
                $("#newEmp").hide();
             //   $('#<%=ddlExistEmp.ClientID%>').removeAttr("disabled");
            }
        }
    </script>

    <script type="text/javascript">
        $addNewCityModel = function () {
            $('#divAddCity').showModel();
        }
        
        $saveNewCity = function (cityDetails) {
            if (cityDetails.City.trim() != '') {
                serverCall('Employee_Registration.aspx/hrCityMaster', { City: cityDetails.City }, function (response) {
                    $cityId = parseInt(response);
                    if ($cityId == 0)
                        modelAlert('City Already Exist');
                    else if ($cityId > 0) {
                        $('#divAddCity').closeModel();
                        modelAlert('City Saved Successfully');
                        $("#txtCity").append($("<option></option>").val($cityId).html(cityDetails.City)).val($cityId).chosen("destroy").chosen();
                        $("#txtOCity").append($("<option></option>").val($cityId).html(cityDetails.City)).val($cityId).chosen("destroy").chosen();
                    }
                });
            }
            else
                modelAlert('Enter City Name');
        }

        function getCity() {
            jQuery("#txtCity option").remove();
            jQuery.ajax({
                url: "Employee_Registration.aspx/bindhrcityMaster",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    BindCityData = jQuery.parseJSON(result.d);
                    for (i = 0; i < BindCityData.length; i++) {
                        $("#txtCity").append($("<option></option>").val(BindCityData[i].ID).html(BindCityData[i].City)).chosen('destroy').chosen();
                        $("#txtOCity").append($("<option></option>").val(BindCityData[i].ID).html(BindCityData[i].City)).chosen('destroy').chosen();
                        
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        //var LoadCentre = function () {
        //    ddlHospital = $('#ddlHospital');
        //    serverCall('Services/PayrollServices.asmx/LoadCentre', {}, function (response) {
        //        ddlHospital.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
        //    });
        //}
        
        $onDateOfBirthChange = function (birthDate) {
            if (!String.isNullOrEmpty(birthDate)) {
                var txtAge = $('#txtDage').prop('disabled', true);
                var ddlAge = $('#ddlDAge').prop('disabled', true);

                getAge(birthDate, function (response) {
                    if ($.isNumeric(response.years) && response.years > 0) {
                        txtAge.val(response.years + '.' + response.months);
                        ddlAge.val('YRS');
                    }
                    else if ($.isNumeric(response.months) && response.months > 0) {
                        txtAge.val(response.months);
                        ddlAge.val('MONTH(S)');
                    }
                    else if ($.isNumeric(response.days) && response.days > 0) {
                        txtAge.val(response.days);
                        ddlAge.val('DAYS(S)');
                    }
                    else {
                        txtAge.val('');
                        ddlAge.val('YRS');
                    }

                });
            }
            else {
                $('#txtDage').prop('disabled', false);
                $('#ddlDAge').prop('disabled', false);
            }
        }

        var clearDateOfBirth = function (e) {
            var inputValue = (e.which) ? e.which : e.keyCode;
            if (inputValue == 46 || inputValue == 8) {
                $(e.target).val('');
                $('#txtDage').val('').prop('disabled', false);
                $('#ddlDAge').val('').prop('disabled', false);
            }
        }

        function validateDOB(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;

            if (e) {
                if (strVal.charAt(0) == '-')
                    $(sender).val('01-');
                else if (strVal.charAt(1) == '-')
                    $(sender).val('0' + strVal.charAt(0) + '-');
                else if (parseInt(strLen) == 2) {
                    $(sender).val(strVal + '-');
                    if (parseInt($(sender).val().split('-')[0]) > 31 || parseInt($(sender).val().split('-')[0]) < 1) {
                        $(sender).val('');
                        modelAlert('Invalid Day.', function () {
                            $(sender).focus();
                        });

                    }
                }
                else if (strVal.charAt(3) == '-') {
                    $(sender).val($(sender).val().split('-')[0] + '-01-');
                }
                else if (strVal.charAt(4) == '-') {
                    $(sender).val($(sender).val().split('-')[0] + '-0' + strVal.charAt(3) + '-');
                }
                else if (parseInt(strLen) == 5) {
                    $(sender).val(strVal + '-');
                    if (parseInt($(sender).val().split('-')[1]) > 12 || parseInt($(sender).val().split('-')[1]) < 1) {
                        $(sender).val('');
                        modelAlert('Invalid Month.', function () {
                            $(sender).focus();
                        });

                    }
                }
                else if (parseInt(strLen) == 10) {

                    if (parseFloat(strVal.split('-')[2]) > parseFloat($.datepicker.formatDate('yy', new Date()))) {
                        $(sender).val('');
                        modelAlert('DOB cannot be Greater than Current Date.', function () {
                            $(sender).focus();
                        });

                    }
                    else if ((parseFloat(strVal.split('-')[2]) == parseFloat($.datepicker.formatDate('yy', new Date()))) && (parseFloat(strVal.split('-')[1]) > parseFloat($.datepicker.formatDate('mm', new Date(new Date().getTime()))))) {
                        $(sender).val('');
                        modelAlert('DOB cannot be Greater than Current Date.', function () {
                            $(sender).focus();
                        });
                    }
                    else if ((parseFloat(strVal.split('-')[2]) == parseFloat($.datepicker.formatDate('yy', new Date()))) && (parseFloat(strVal.split('-')[1]) == parseFloat($.datepicker.formatDate('mm', new Date(new Date().getTime())))) && (parseFloat(strVal.split('-')[0]) > parseFloat($.datepicker.formatDate('dd', new Date(new Date().getTime()))))) {
                        $(sender).val('');
                        modelAlert('DOB cannot be Greater than Current Date.', function () {
                            $(sender).focus();
                        });;

                    }
                    else if (parseInt(strVal.split('-')[1]) == 2 && parseInt(parseInt(strVal.split('-')[2]) % 4) > 0 && parseInt(strVal.split('-')[0]) > 28) {
                        $(sender).val('');
                        modelAlert('Invalid DOB.', function () {
                            $(sender).focus();
                        });

                    }
                    else if (parseInt(strVal.split('-')[1]) == 2 && parseInt(parseInt(strVal.split('-')[2]) % 4) == 0 && parseInt(strVal.split('-')[0]) > 29) {
                        $(sender).val('');
                        modelAlert('Invalid DOB.', function () {
                            $(sender).focus();
                        });

                    }
                    else if ((parseInt(strVal.split('-')[1]) == 4 || parseInt(strVal.split('-')[1]) == 6 || parseInt(strVal.split('-')[1]) == 9 || parseInt(strVal.split('-')[1]) == 11) && parseInt(strVal.split('-')[0]) > 30) {
                        $(sender).val('');
                        modelAlert('Invalid DOB.', function () {
                            $(sender).focus();
                        });
                    }
                    else if (parseFloat(strVal.split('-')[2]) < parseFloat($.datepicker.formatDate('yy', new Date())) - 99) {
                        $(sender).val('');
                        modelAlert('Invalid DOB.', function () {
                            $(sender).focus();
                        });
                    }

                }

            }
        }

        //var LoadBloodBankBloodGroup = function () {
        //    ddlBloodGroup = $('#ddlBloodGroup');
        //    serverCall('Services/PayrollServices.asmx/LoadBloodBankBloodGroup', {}, function (response) {
        //        ddlBloodGroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: false });
        //    });
        //}
        //var LoadDrivingLiscenceType = function () {
        //    ddlDrivingLiscenceType = $('#ddlDrivingLiscenceType');
        //    serverCall('Services/PayrollServices.asmx/LoadDrivingLiscenceType', {}, function (response) {
        //        ddlDrivingLiscenceType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: false });
        //    });
        //}
        
        var bindDesignation = function (callback) {
            ddlIDesig = $('#ddlIDesig');
            serverCall('Services/CommonServices.asmx/BindDesignation', {}, function (response) {
                ddlIDesig.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Des_ID', textField: 'Designation_Name', isSearchAble: true });
                callback(ddlIDesig.val());
            });
        }

        var openCandidateModal = function () {
            $('#divCandidate').showModel();
            SearchCandidate();
        }

        var SearchCandidate = function () {

            var data = {
                fromdate: $('#txtInterviewFromDate').val(),
                todate: $('#txtInterviewToDate').val(),
                desig: $('#ddlIDesig').val(),
                SearchType:'1',
            }
            serverCall('Services/CommonServices.asmx/SearchSelectedCandidates', data, function (response) {
                ResultData = jQuery.parseJSON(response);
                if (ResultData.length > 0) {
                    var output = $('#tb_SearchC').parseTemplate(ResultData);
                    $('#divOutput').html(output);
                    $('#divOutput').show();
                }
                else {
                    modelAlert('No Record Found', function () {
                        $('#divOutput').html('');
                    });
                }
            });
        }

        var SearchCandidateDetails = function (rowID) {
            var row = $(rowID).closest('tr');
            var CandidateID = $(row).find('#tdCandidateID').text();
            var EmployeeID = $(row).find('#tdEmployeeID').text();
            if (EmployeeID != "") {
                modelAlert('This Candidate is already Registered<br/> EmployeeID : ' + EmployeeID);
                return false;
            }
            serverCall('Services/CommonServices.asmx/SearchCandidateDetails', { CandidateID: CandidateID, isPrint: '0' }, function (response) {
                ResultData = JSON.parse(response);
                if (ResultData.length > 0) {
                    bindCandidateDetail(ResultData[0], function () { });
                }
            });
        }
        var bindCandidateDetail = function (data, callback) {
            $('#lblConductCandidateID').val(data.ID);
            $($('#cmdTitle option').filter(function () { return this.text == data.Title })[0]).prop('selected', true);
            $('#txName').val(data.FirstName + data.LastName);
            $('input[type=radio][value=' + data.Gender + ']').prop('checked', true);
            $('#ddlDepartment').val(data.DeptID);
            $('#ddlDesignation').val(data.DesigID);
            $('#txtHouseNo').val(data.Address);
            $('#txtMobile').val(data.Mobile);
            $('#txtDOB').val(data.DOB);
            $('#txtEmail').val(data.Email);
            $('#ddlHospital').val(data.JoiningCentreID);
            $('#divCandidate').closeModel();
        }
        var ValidateDuplicateRegNo = function (regno) {
            serverCall('Employee_Registration.aspx/ValidateDuplicateRegNo', { regNo: regno.value }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    $('#ctl00_ContentPlaceHolder1_btnSave').removeAttr('disabled', 'disabled');
                }
                else {
                    modelAlert(responseData.response, function () {
                        $(regno).val('');
                        $('#ctl00_ContentPlaceHolder1_btnSave').attr('disabled', 'disabled');
                    });
                }
            });
        }
     
    </script>
    <asp:Panel ID="pnlHide" runat="server" Visible="false">
        <a href="javascript:void(0);" onclick="hideSelfFrame();">Back To Search</a>
    </asp:Panel>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Employee Registration </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                <asp:TextBox ID="lblConductCandidateID" runat="server" style="display:none" ClientIDMode="Static"></asp:TextBox>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Personal Detail
            </div>
            <div id="d1" visible="false" runat="server">
                <strong><a href="Employee_ProfessionalDetail_New.aspx?EmpID=<%=EmpID %>">Professional</a>&nbsp;&nbsp;
                    <a href="FinanceSalary.aspx?EmpID=<%=EmpID %>" style="display:none">Financial</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Employee
                    ID :&nbsp;<asp:Label ID="lblEmpID" runat="server" CssClass="ItDoseLabelSp" style="display:none"></asp:Label>
                    <asp:Label ID="lblEmpRegNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                    &nbsp;&nbsp;&nbsp;&nbsp;Name :&nbsp;
                    <asp:Label ID="lblName" runat="server" CssClass="ItDoseLabelSp"></asp:Label></strong>
            </div>
            <div class="row">
                <div class="col-md-22">
                    <div class="row">
                         <div class="col-md-3">
                                <label class="pull-left">
                                    Employee ID
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtRegNo" runat="server" MaxLength="20" TabIndex="1" onkeypress="return check(event)" ClientIDMode="Static" onchange="ValidateDuplicateRegNo(this);"
                            ToolTip="Enter Registration No." AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                             <asp:DropDownList  ID="cmdTitle" runat="server" ToolTip="Select Title" ClientIDMode="Static"
                            onchange="AutoGender();" class="ddl" Width="30%">
                        </asp:DropDownList>
                        <asp:TextBox ID="txName" EnableTheming="false" runat="server" TabIndex="2"
                            MaxLength="100" ToolTip="Enter Employee Name" onkeypress="return check(event)" ClientIDMode="Static"
                            onkeyup="validatespace();" AutoCompleteType="Disabled" CssClass="requiredField" width="67%"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="txName"
                            ErrorMessage="Please Enter Employee Name" Display="none" SetFocusOnError="True"
                            ValidationGroup="save1"></asp:RequiredFieldValidator>
                            </div>
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Sex
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtnGender" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                
                            <asp:ListItem Selected="True" Text="Male" Value="Male"></asp:ListItem>
                            <asp:ListItem Value="Female" Text="Female"></asp:ListItem>
                            <asp:ListItem Value="TGender" Text="TGender"></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:TextBox ID="txtGender" runat="server" Width="40" Style="display: none"></asp:TextBox>
                        </div>
                       
                        </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Marital Status </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMaitalStatus" runat="server" TabIndex="3">
                                  <asp:ListItem Selected="True" Text="Married" Value="Married"></asp:ListItem>
                                   <asp:ListItem Value="Unmarried" Text="Unmarried"></asp:ListItem>
                                <asp:ListItem Value="Widow" Text="Widow"></asp:ListItem>
                                <asp:ListItem Value="Single" Text="Single"></asp:ListItem>
                                
                            </asp:DropDownList>
                            
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="4" ToolTip="Select Department" CssClass="requiredField" ClientIDMode="Static">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="reqDept" runat="server" SetFocusOnError="True" ControlToValidate="ddlDepartment"
                                    InitialValue="0" ErrorMessage="Please Select Department" Display="none" ValidationGroup="save1"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Designation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDesignation" runat="server" CssClass="requiredField" TabIndex="5" ToolTip="Select Designation"  ClientIDMode="Static">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="reqDes" runat="server" SetFocusOnError="True" ControlToValidate="ddlDesignation"
                                    ValidationGroup="save1" InitialValue="0" ErrorMessage="Please Select Designation"
                                    Display="none"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Emp.Category </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server" TabIndex="6">
                                <asp:ListItem Selected="True" Text="General" Value="General"></asp:ListItem>
                                <asp:ListItem Value="ST" Text="ST"></asp:ListItem>
                                <asp:ListItem Value="SC" Text="SC"></asp:ListItem>
                                <asp:ListItem Value="OBC" Text="OBC"></asp:ListItem>

                            </asp:DropDownList>

                        </div>
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Blood Group
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodGroup" runat="server" TabIndex="7" ToolTip="Select Blood Group" ClientIDMode="Static">
                        </asp:DropDownList>
                        </div>
                    </div>
                        <div class="row">
                            <strong><span style="text-decoration: underline">Local Address </span></strong>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    House No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtHouseNo" runat="server" EnableTheming="false"
                                    TabIndex="8" ToolTip="Enter House No." TextMode="MultiLine" onkeypress="return check(event)" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqLHouse" runat="server" ControlToValidate="txtHouseNo"
                                    ErrorMessage="Please Enter Local House No." ValidationGroup="save1" SetFocusOnError="True"
                                    Display="None"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Street No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtStreet" runat="server" TabIndex="9" MaxLength="35" onkeypress="return check(event)"
                                    ToolTip="Enter Street No." ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    City
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="txtCity" CssClass="requiredField" runat="server" TabIndex="10" MaxLength="35"
                                    ToolTip="Enter City" onkeypress="return check(event)" ClientIDMode="Static">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="reqCity" runat="server" ControlToValidate="txtCity"
                                    Display="None" ValidationGroup="save1" ErrorMessage="Please Enter Local City"
                                    SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-1">
                                <input type="button" class="ItDoseButton" value="New" id="btnNewCity" data-title="Click to Create New City" onclick="$addNewCityModel()" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Locality
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtLocality" CssClass="requiredField" runat="server" TabIndex="11" MaxLength="35"
                                    ToolTip="Enter Locality" onkeypress="return check(event)" ClientIDMode="Static"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqLocality" runat="server" ControlToValidate="txtLocality"
                                    ErrorMessage="Please Enter Local Locality" ValidationGroup="save1" SetFocusOnError="True"
                                    Display="None"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pin No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPinCode" runat="server" TabIndex="12" MaxLength="10" ToolTip="Enter Pin Code" ClientIDMode="Static"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fc1" runat="server" TargetControlID="txtPinCode"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-1">
                                <asp:CheckBox ID="chkPermaPersonaldetail" runat="server" ClientIDMode="Static" onclick="chkAll(this.checked)" />
                            </div>
                            <div class="col-md-9">
                                <b>If Local & Permanent Address is same...</b>
                            </div>
                        </div>
                        <div class="row">
                            <strong><span style="text-decoration: underline">Permanent Address</span> </strong>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    House No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtOhouseNo" runat="server" EnableTheming="false" CssClass="requiredField" TabIndex="13" MaxLength="35" ToolTip="Enter House No." TextMode="MultiLine"
                                    onkeypress="return check(event)" ClientIDMode="Static"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqOHouse" runat="server" ControlToValidate="txtOhouseNo"
                                    Display="None" ValidationGroup="save1" ErrorMessage="Please Enter Permanent House No."
                                    SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Street No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtOStreet" runat="server" TabIndex="14" MaxLength="35" onkeypress="return check(event)"
                                    ToolTip="Enter Street No. " ClientIDMode="Static"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    City
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="txtOCity" CssClass="requiredField" runat="server" TabIndex="15" MaxLength="35"
                                    ToolTip="Enter City" onkeypress="return check(event)" ClientIDMode="Static">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="reqOCity" runat="server" ControlToValidate="txtOCity"
                                    Display="None" ErrorMessage="Please Enter Permanent City" SetFocusOnError="True"
                                    ValidationGroup="save1"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Locality
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtOlocality" CssClass="requiredField" runat="server" TabIndex="16" MaxLength="35"
                                    ToolTip="Enter Locality" onkeypress="return check(event)" ClientIDMode="Static"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="reqolocality" runat="server" ControlToValidate="txtOlocality"
                                    ErrorMessage="Please Enter Permanent Locality" ValidationGroup="save1" SetFocusOnError="True"
                                    Display="None"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pin No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtOPinCode" runat="server" TabIndex="17" MaxLength="10"
                                    ToolTip="Enter Pin Code" ClientIDMode="Static"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtOPinCode"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                        </div>
                        <div class="row">
                            <strong><span style="text-decoration: underline">Personal Details</span></strong>&nbsp;
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Phone No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPhone" runat="server" TabIndex="18" MaxLength="15" ToolTip="Enter Phone No."></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" TargetControlID="txtPhone"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RegularExpressionValidator ID="regPhoneNo" runat="server" ControlToValidate="txtPhone"
                                    Display="None" ErrorMessage="Phone No. Must be 10-15 Digit" SetFocusOnError="true"
                                    ValidationExpression="^[0-9]{10,15}$" ValidationGroup="save1"></asp:RegularExpressionValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Mobile No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtMobile" runat="server" MaxLength="10" TabIndex="19" ToolTip="Enter Mobile No."  ClientIDMode="Static" CssClass="requiredField"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="ReguExpress" runat="server" ControlToValidate="txtMobile"
                                    Display="None" ErrorMessage="Mobile No. Must be 10-15 Digit" SetFocusOnError="true"
                                    ValidationExpression="^[0-9]{10,15}$" ValidationGroup="save1"></asp:RegularExpressionValidator>
                                <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Father's Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtFather" runat="server" TabIndex="20" MaxLength="50"
                                    ToolTip="Enter Father Name" AutoCompleteType="Disabled" onkeypress="return check(event)"
                                    onkeyup="validatespace();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Mother's Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtMother" runat="server" TabIndex="21" MaxLength="50"
                                    ToolTip="Enter Mother Name" AutoCompleteType="Disabled" onkeypress="return check(event)"
                                    onkeyup="validatespace();"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    DOB
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDOB" runat="server" ToolTip="Select Date Of Birth" ClientIDMode="Static"
                                    TabIndex="22"></asp:TextBox>
                                <cc1:CalendarExtender ID="calDOB" runat="server" TargetControlID="txtDOB" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Spouse Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtHusbandName" runat="server" MaxLength="100" ToolTip="Enter Spouse Name"
                                    TabIndex="23" AutoCompleteType="Disabled" onkeypress="return check(event)"
                                    onkeyup="validatespace();"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Email
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtEmail" runat="server" TabIndex="24" ToolTip="Enter E-Mail Address" ClientIDMode="Static"
                                    MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="revEmail" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                    runat="server" Display="None" ControlToValidate="txtEmail" ErrorMessage="Please Enter Valid Email Address"
                                    ValidationGroup="save1" SetFocusOnError="True"></asp:RegularExpressionValidator>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Kin Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtKinName" runat="server" TabIndex="25" ToolTip="Enter Kin Name"
                                    MaxLength="50" AutoCompleteType="Disabled" onkeypress="return check(event)"
                                    onkeyup="validatespace();"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Kin Address
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtKinAddress" runat="server" TabIndex="26" ToolTip="Enter Kin Address" onkeypress="return check(event)"
                                    MaxLength="50" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Kin Phone
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtKinPhoneNo" runat="server" TabIndex="27" ToolTip="Enter Kin Phone No."
                                    MaxLength="15" AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" TargetControlID="txtKinPhoneNo"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RegularExpressionValidator ID="regKinPhone" runat="server" ControlToValidate="txtKinPhoneNo"
                                    Display="None" ErrorMessage="Kin Phone No. Must be 10-15 Digit" SetFocusOnError="true"
                                    ValidationExpression="^[0-9]{10,15}$" ValidationGroup="save1"></asp:RegularExpressionValidator>
                            </div>

                        </div>
                        <div class="row">
                            <strong><span style="text-decoration: underline">Nominee Details</span></strong>&nbsp;
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtNomineeName" runat="server" TabIndex="28" ToolTip="Enter Kin Name"
                                    AutoCompleteType="Disabled" onkeypress="return check(event)"
                                    onkeyup="validatespace();"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Relation</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlNomineeRelation" runat="server" TabIndex="29" ClientIDMode="Static">
                                    <asp:ListItem Value="NFather" Selected="True">Father</asp:ListItem>
                                    <asp:ListItem Value="NMother">Mother</asp:ListItem>
				    <asp:ListItem Value="NSon">Son</asp:ListItem>
				  <asp:ListItem Value="NDaughter">Daughter</asp:ListItem>
                                    <asp:ListItem Value="NBorther">Borther</asp:ListItem>
                                    <asp:ListItem Value="NSister">Sister</asp:ListItem>
                                    <asp:ListItem Value="NWife">Wife</asp:ListItem>
                                    <asp:ListItem Value="NHusband">Husband</asp:ListItem>
                                    <asp:ListItem Value="NFriend">Friend</asp:ListItem>
                                </asp:DropDownList>
                                
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Address.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtNomineeAdres" runat="server" ToolTip="Enter House No." TextMode="MultiLine" TabIndex="30" ClientIDMode="Static"></asp:TextBox>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">ContactNo</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtNomineeContactNo" runat="server" TabIndex="31"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="flNominee" runat="server" TargetControlID="txtNomineeContactNo"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    AADHAR Card.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtNomineeAdharCard" runat="server" ToolTip="Enter Nominee Adhar Card" TextMode="MultiLine" TabIndex="32" ClientIDMode="Static"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <strong><span style="text-decoration: underline">Emergency Details</span></strong>&nbsp;
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">Relation</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlEmrRelation" runat="server" ClientIDMode="Static" TabIndex="33">
                                    <asp:ListItem Value="DFather" Selected="True">Father</asp:ListItem>
                                    <asp:ListItem Value="DMother">Mother</asp:ListItem>
                                    <asp:ListItem Value="DBorther">Borther</asp:ListItem>
                                    <asp:ListItem Value="DSister">Sister</asp:ListItem>
                                    <asp:ListItem Value="DWife">Wife</asp:ListItem>
                                    <asp:ListItem Value="DHusband">Husband</asp:ListItem>
                                    <asp:ListItem Value="DFriend">Friend</asp:ListItem>

                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Rel.Name</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtEmrRelName" runat="server" TabIndex="34"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">Rel.ContactNo</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtEmrRelContact" runat="server" MaxLength="12" TabIndex="35"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="fleRelContact" runat="server" TargetControlID="txtEmrRelContact"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                            </div>

                        </div>

                        <div class="row">
                            <strong><span style="text-decoration: underline">Bank Details </span></strong>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Bank Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlBankName" runat="server" ToolTip="Select Bank Name" onchange="getBranch()" TabIndex="36">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Branch Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlBranch" runat="server" TabIndex="37" ToolTip="Select Branch Name" onchange="getIFSCCode()">
                                </asp:DropDownList>
                                <asp:TextBox ID="txtBranch" runat="server" ClientIDMode="Static" Style="display: none"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    Bank Account No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBankAccNo" ToolTip="Enter Bank Account No." runat="server" TabIndex="38" onkeypress="return check(event)"
                                    MaxLength="20" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    IFSC Code
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtIFSCCode" runat="server" ClientIDMode="Static" TabIndex="39"></asp:TextBox>

                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Acc.HolderName</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtAccHolderName" runat="server" ToolTip=" Enter Acc Holder Name " TextMode="MultiLine" TabIndex="40"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <strong><span style="text-decoration: underline">PF/ESI Details. </span></strong>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">UAN</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtUAN" ClientIDMode="Static" runat="server" TabIndex="41" ToolTip="Enter UAN No"> </asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">PF No.</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPFNo" runat="server" TabIndex="42" MaxLength="30" onkeypress="return check(event)"
                                    ToolTip="Enter SSNIT No." AutoCompleteType="Disabled" ClientIDMode="Static"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    ESI No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtESI" runat="server" TabIndex="43" ToolTip="Enter ESI No. " onkeypress="return check(event)"
                                    MaxLength="35" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    No of Dependent
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDependent" runat="server" TabIndex="44" ToolTip="Enter Dependent No."
                                    MaxLength="35"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    PF Nominee Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                  <asp:TextBox ID="txtPF_Nominee1" runat="server" MaxLength="100" TabIndex="45" ToolTip="Enter PF Nominee" ></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <strong><span style="text-decoration: underline">Other Details </span></strong>
                        </div>
                        <div class="row">
                             
                            <div class="col-md-3" style="display: none;">
                                <label class="pull-left">
                                    Letter No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="display: none;">
                                <asp:TextBox ID="txtLetterNO" runat="server" MaxLength="11" ToolTip="Enter Letter No." Visible="false"
                                    TabIndex="46" AutoCompleteType="Disabled"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtLetterNO"
                                    FilterType="Numbers">
                                </cc1:FilteredTextBoxExtender>
                            </div>

                            <div class="col-md-3" style="display: none;">
                                <label class="pull-left">
                                    Dispensary No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" style="display: none;">
                                <asp:TextBox ID="txtDisNo" runat="server" TabIndex="47" ToolTip="Enter Dispensary No." Visible="false"
                                    MaxLength="35" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    AADHAR Card No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtEmpAadharCard" runat="server" TabIndex="48" ToolTip="Enter National ID No." onkeypress="return check(event)"
                                    MaxLength="35" AutoCompleteType="Disabled"></asp:TextBox>
                                
                            </div>

                            <div class="col-md-3">
                                <label class="pull-left">
                                    PAN Card No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPAN" runat="server" TabIndex="49" ToolTip="Enter Pan Card No." onkeypress="return check(event)"
                                    MaxLength="35" AutoCompleteType="Disabled"></asp:TextBox>
                                </div>
                            <div class="col-md-3">
                         <label class="pull-left">
                                    Voter Card No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtVoterCardNo" AutoCompleteType="Disabled" runat="server" MaxLength="35" TabIndex="50"
                                    ToolTip="Enter Voter Card No." ></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3" >
                                <label class="pull-left">
                                    Passport No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPassport" runat="server" ToolTip="Enter Passport No." MaxLength="35" onkeypress="return check(event)"
                                    TabIndex="51" AutoCompleteType="Disabled"></asp:TextBox>
                            </div>
                            <div class="col-md-3" >
                                <label class="pull-left">
                                    Passport Expiry
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" >
                                <asp:TextBox ID="txtGRID_No" runat="server" MaxLength="35" ToolTip="Enter GR ID No." Visible="false"></asp:TextBox>
                                 <asp:TextBox ID="txtPassportExpiryDate" runat="server" TabIndex="52" ToolTip="Select Passport Expiry Date"></asp:TextBox>
                                 <cc1:calendarextender id="ccPassportExpiry" runat="server" targetcontrolid="txtPassportExpiryDate" format="dd-MMM-yyyy">
                                 </cc1:calendarextender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Insurance No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtLIC" AutoCompleteType="Disabled" runat="server" MaxLength="35" TabIndex="53"
                                    ToolTip="Enter Insurance No." Visible="false"></asp:TextBox>
                                  <asp:TextBox ID="txtEmpInsurance" AutoCompleteType="Disabled" runat="server" MaxLength="35"
                                    ToolTip="Enter Insurance No." ></asp:TextBox>
                            </div>
                        </div>

                    <div class="row">
                        
                         <div class="col-md-3">
                         <label class="pull-left">
                                    DL Card No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDLNo" AutoCompleteType="Disabled" runat="server" MaxLength="35" TabIndex="54"
                                    ToolTip="Enter Driving Liscence No." ></asp:TextBox>
                            </div>
                         <div class="col-md-3">
                         <label class="pull-left">
                                    DL Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:DropDownList ID="ddlDrivingLiscenceType" runat="server" TabIndex="55" ToolTip="Select Driving Liscence Type" ClientIDMode="Static">
                                 </asp:DropDownList>
                            </div>
                         <div class="col-md-3" >
                                <label class="pull-left">
                                    DL Expiry
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5" >
                                 <asp:TextBox ID="txtDLExpiry" runat="server" TabIndex="56" ToolTip="Select Driving Liscence Expiry Date"></asp:TextBox>
                                 <cc1:calendarextender id="ccDLExpiry" runat="server" targetcontrolid="txtDLExpiry" format="dd-MMM-yyyy">
                                 </cc1:calendarextender>
                            </div>
                    </div>
                    <div class="row">
                        
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Date Of Joining
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDOJ" runat="server" TabIndex="57" ToolTip="Select Date Of Joining"></asp:TextBox>
                            <cc1:calendarextender id="calucDate" runat="server" targetcontrolid="txtDOJ" format="dd-MMM-yyyy">
                        </cc1:calendarextender>
                      </div>
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Employment Type
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlEmployeeType" runat="server" TabIndex="58" ToolTip="Select Employee Type">
                            <asp:ListItem Selected="True">Full Time</asp:ListItem>
                            <asp:ListItem>Part Time</asp:ListItem>
                        </asp:DropDownList>
                            </div>
                         <div class="col-md-3">
                                <label class="pull-left">
                                    Pre Emp Medi Fit.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMedicalFit" runat="server" TabIndex="59"
                            ToolTip="Select Medical Fitness">
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                            <asp:ListItem Value="No" Selected="True">No</asp:ListItem>
                        </asp:DropDownList>
                            </div>
                    </div>
                    <div class="row" style="display:none">


                        <div class="col-md-3">
                            <label class="pull-left">
                                SSNIT Nominee1
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                SSNIT Nominee2
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPF_Nominee2" runat="server" MaxLength="100" TabIndex="60" ToolTip="SSNIT Nominee2" AutoCompleteType="Disabled" onkeypress="return check(event)"
                                onkeyup="validatespace();"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                    
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Centre
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlHospital" runat="server" TabIndex="61" ToolTip="Select Branch" ClientIDMode="Static">
                         </asp:DropDownList>
                            </div>
                         <div class="col-md-3">
                                <label class="pull-left">
                                    Accommodation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlAccomodation" runat="server" TabIndex="62"
                            ToolTip="Select Accomodation">
                            <asp:ListItem Value="1">Yes</asp:ListItem>
                            <asp:ListItem Value="0" Selected="True">No</asp:ListItem>
                        </asp:DropDownList>
                            </div>
                        <div class="col-md-8">
                            <asp:CheckBox ID="chkIsInvolveinInterViewProcess" runat="server" Text="Can Involve in Interview Process" />
                        </div>
                       
                        </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                User Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbUserType" runat="server" TabIndex="26" ClientIDMode="Static" CssClass="requiredField">
                            </asp:DropDownList>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                User Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUserGroup" runat="server" TabIndex="26" ClientIDMode="Static" CssClass="requiredField">
                            </asp:DropDownList>
                        </div>

                     </div>
                    <div class="row">
                        <div class="col-md-3" style="display: none">
                                <label class="pull-left">
                                    Date Of Leaving
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5" style="display: none">
                            <asp:TextBox ID="txtDOL" AutoCompleteType="Disabled" class="dol" runat="server" ToolTip="Select Date Of Leaving"
                            TabIndex="63" Style="display: none"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDOL"
                            Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                            </div>
                       

                         <div class="col-md-3" style="display:none">
                                <label class="pull-left">
                                    EDLI No.
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5" style="display:none">
                            <asp:TextBox ID="txtEDLI_No" runat="server" MaxLength="35" ToolTip="Enter EDLI No."
                            TabIndex="64"></asp:TextBox>
                            </div>
                   </div>
                    <div class="row">
                        <strong><span style="text-decoration: underline">Emp Dependent Details </span></strong>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDName" runat="server" TabIndex="65" ToolTip="Enter Dependent Name."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                DOB
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDdob" runat="server" ReadOnly="false" autocomplete="off" data-title="Enter DOB" placeholder="DD-MM-YYYY" TabIndex="66" ClientIDMode="Static" onblur="$onDateOfBirthChange(this.value)"  onkeyup="clearDateOfBirth(event);validateDOB(this,event);" ToolTip="Select DOB" maxlength="10"></asp:TextBox>
						<cc1:CalendarExtender ID="cclddob" TargetControlID="txtDdob" Format="dd-MM-yyyy" runat="server" ></cc1:CalendarExtender>
                        <cc1:FilteredTextBoxExtender  ID="filterDob" runat="server" FilterType="Numbers,Custom" ValidChars="-" TargetControlID="txtDdob"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Age  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtDage" runat="server" ClientIDMode="Static" TabIndex="67"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender  ID="FilteredTextBoxExtender4" runat="server" FilterType="Numbers,Custom" ValidChars="." TargetControlID="txtDage"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlDAge" runat="server" ClientIDMode="Static">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDAddress" runat="server" TabIndex="68" ToolTip="Enter Dependent Address."></asp:TextBox>
                        </div>

                        <div class="col-md-3">
                                <label class="pull-left">Relation</label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlDRelation" runat="server" TabIndex="69" ClientIDMode="Static">
                                    <asp:ListItem Value="Father" Selected="True">Father</asp:ListItem>
                                    <asp:ListItem Value="EMother">Mother</asp:ListItem>
                                    <asp:ListItem Value="EBorther">Borther</asp:ListItem>
                                    <asp:ListItem Value="ESister">Sister</asp:ListItem>
                                    <asp:ListItem Value="EWife">Wife</asp:ListItem>
                                    <asp:ListItem Value="eHusband">Husband</asp:ListItem>
                                    <asp:ListItem Value="EFriend">Friend</asp:ListItem>
                                </asp:DropDownList>
                                
                            </div>
                        <div class="col-md-3">
                                <label class="pull-left">
                                    Medical Fit
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDMedicalFit" runat="server" TabIndex="70"
                            ToolTip="Select Medical Fitness">
                            <asp:ListItem Value="Yes">Yes</asp:ListItem>
                            <asp:ListItem Value="No" Selected="True">No</asp:ListItem>
                        </asp:DropDownList>
                            </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Occupation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDOccupation" runat="server" TabIndex="71" ToolTip="Enter Dependent Occupation."></asp:TextBox>
                        </div>

                        <div class="col-md-3">
                               <asp:Button ID="btnDepDetails" runat="server" Text="Add Dep.Details" OnClick="btnDepDetails_Click"  />
                        </div>
                    </div>
                    <div class="row">
                        <asp:GridView ID="grdEmployeDepndet" runat="server" AutoGenerateColumns="false" OnRowDeleting="grdEmployeDepndet_RowDeleting" Width="863px" >
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" BackColor="White"  />
                            <Columns>
                                    <asp:TemplateField>
                            <HeaderTemplate>
                                S.No.
                            </HeaderTemplate>
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Name" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle"/>
                                <asp:BoundField DataField="DOB" HeaderText="Dob" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle"/>
                                <asp:BoundField DataField="AGE" HeaderText="Age" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle"/>
                                <asp:BoundField DataField="Address" HeaderText="Address" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                                <asp:BoundField DataField="Relation" HeaderText="Relation" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle"/>
                                <asp:BoundField DataField="MedicalFitness" HeaderText="MedicalFit..." HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle" />
                                <asp:BoundField DataField="Occupation" HeaderText="Occupation" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle"/>
                                <asp:TemplateField>
                            <HeaderTemplate>
                                Delete
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:ImageButton ID="ibDelete" runat="server" ImageUrl="~/Images/Delete.gif"
                                    CommandName="delete" OnClientClick="return alertDelete();" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
            </div>
                <div class="col-md-2">
                    <input type="button" id="btnSelectedCandidate" onclick="openCandidateModal()" value="Selected Candidate" style="height: 36px; width: 100px; white-space: normal; " />
                </div>
            </div>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <asp:CheckBox ID="chkLogin" runat="server" onClick="showNewEmp();" ToolTip="Check Login Required " TabIndex="72" Text="HIS Login Required:" />
            </div>
           <div class="row" id="bindEmp" style="display: none;">
                <div class="col-md-24" style="display:none">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">
                                Bind A Existing HIS Employee
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlExistEmp" runat="server" ToolTip="Select a HIS Employee" TabIndex="73">
                             </asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                            <strong><asp:CheckBox ID="chkNewEmp" runat="server" ToolTip="Check to Create New Employee" TabIndex="74" Text="Create A New Employee" onclick="showNewEmp();" CssClass="pull-left" Checked="true"/></strong>
                            </div>
                        </div>
                    </div>
               </div>
            </div>
            <div class="POuter_Box_Inventory" id="newEmp" style="display:none;">
                <div class="Purchaseheader">
                    Login Details
                </div>
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-5">
                            </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search By Name
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-4">
                            <input type="text" id="txtSearch" style="width: 225px" onkeyup="SearchCheckbox(this,'#chk_prev')" />
                         </div>
                     </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                              LoginType  
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-21">
                            <asp:GridView ID="grlLoginRoles" runat="server" AutoGenerateColumns="False"
                                    CssClass="GridViewStyle"
                                    TabIndex="75" width="100%">
                                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No.">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="CentreName" HeaderText="Centre Name">
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Roles">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCentreId" runat="server" Text='<%#Eval("CentreID") %>' Visible="false"></asp:Label>
                                                <asp:CheckBoxList ID="chk_prev" runat="server" RepeatLayout="Table" RepeatDirection="Horizontal" ClientIDMode="Static"
                                                    RepeatColumns="6" TabIndex="76">
                                                </asp:CheckBoxList>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                       
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                              UserName  
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtuid" runat="server" Font-Bold="true" AutoCompleteType="Disabled" MaxLength="10" TabIndex="77"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                              Password  
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtpwd" runat="server" Font-Bold="true" TextMode="Password" AutoCompleteType="Disabled" 
                                    TabIndex="78" MaxLength="12"></asp:TextBox>
                                <asp:Label ID="TextBox1_HelpLabel" runat="server" />
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                             Confirm Password  
                            </label>
                            <b class="pull-right">:</b>
                            </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtcpwd" runat="server" Font-Bold="true" TextMode="Password" AutoCompleteType="Disabled"
                                    TabIndex="79" MaxLength="12"></asp:TextBox>
                            </div>
                        </div>
             </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" TabIndex="80" Text="Save"
                ValidationGroup="save1" CssClass="ItDoseButton" ToolTip="Click to Save" OnClientClick="return validate();" Style ="margin-top:7px; width:100px;"  />&nbsp;&nbsp;
            <asp:Button Visible="false" ID="btnEdit" runat="server" Text="Update" OnClick="btnEdit_Click"
                TabIndex="81" ValidationGroup="save1" CssClass="ItDoseButton" OnClientClick="return validate();"
                ToolTip="Click to Update" />
            &nbsp; &nbsp;
            <asp:Button ID="btnPrevious" runat="server" Visible="false" OnClick="btnPrevious_Click"
                Text="Previous" CssClass="ItDoseButton" Style ="display: none; margin-top:7px; width:100px;"  />&nbsp;&nbsp;
            <asp:Button ID="btnNext" runat="server" Visible="false" Text="Next" OnClick="btnNext_Click"
                 CssClass="ItDoseButton" Style ="display: none; margin-top:7px; width:100px;" />
            <br />
        </div>
    
    </div>
    <div id="divAddCity"   class="modal fade ">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:320px;height:153px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divAddCity" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Add City</h4>
				</div>
				<div class="modal-body">
					 <div class="row">
						 <div class="col-md-10">
							   <label class="pull-left">    City Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						 <div class="col-md-14">
							 <input type="text" autocomplete="off"  onlytext="30" id="txtCityName" class="form-control ItDoseTextinputText" />
						 </div>
					  </div>
				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$saveNewCity({City:$('#txtCityName').val()})">Save</button>
						 <button type="button"  data-dismiss="divAddCity" >Close</button>
				</div>
			</div>
		</div>
	</div>
    <div id="divCandidate" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 920px; height: 480px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divCandidate" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Search Selected Candidates(On Joining Date)</h4>
                </div>
                <div class="modal-body" style="height:380px">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pul-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInterviewFromDate" runat="server" ClientIDMode="Static" onchange="SearchCandidate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="ccIFD" runat="server" TargetControlID="txtInterviewFromDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInterviewToDate" runat="server" ClientIDMode="Static" onchange="SearchCandidate()"></asp:TextBox>
                            <cc1:CalendarExtender ID="ccIFT" runat="server" TargetControlID="txtInterviewToDate"
                                Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Designation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlIDesig" onchange="SearchCandidate();"></select>
                        </div>
                    </div>
                    <div class="row">
                         <div id="divOutput" style="max-height: 340px; overflow-x:auto"></div>
                    </div>
                </div>
                <div class="modal-footer">
                     <button type="button" style="width:25px;height:25px;margin-left:5px;float:left;background-color: #90EE90;" class="circle"></button>
                        <b style="margin-top:5px;margin-left:5px;float:left">Registered</b> 
                    <button type="button" data-dismiss="divCandidate">Close</button>
                </div>
            </div>
        </div>
    </div>

    
   <script type="text/html" id="tb_SearchC">
        <table class="FixedTables" rules="all" cellspacing="0" border="1" id="tb_SearchCData" style="width:100%; border-collapse:collapse; overflow-x:auto">
            <tr id="tr2">
                <th class="GridViewHeaderStyle" scope="col" style="width: 10px">SrNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px">Joining Date</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width: 150px">Department</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width: 150px">Designation</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px">Candidate Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">Mobile</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px">Email</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px">Select</th>
            </tr>
            <#
            var dataLength=ResultData.length;
            window.status="Total Records Found :"+ dataLength;
            var objRow;
            var status;
            for(var j=0;j<dataLength;j++)
                {
                objRow = ResultData[j];
            #>
                <tr<#if(objRow.EmployeeID!=''){#>
                    style="background-color:#90EE90" 
                    <#}#>
                    >
                    <td class="GridViewLabItemStyle"  style="width: 30px; text-align: center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdCandidateID" style="width: 30px; text-align: center; display:none"><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" id="tdEmployeeID" style="width: 30px; text-align: center; display:none"><#=objRow.EmployeeID#></td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;"><#=objRow.JoiningDate#></td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;"><#=objRow.Dept_Name#></td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;"><#=objRow.Designation_Name#></td>
                    <td class="GridViewLabItemStyle" id="tdCandidateName" style="width: 30px; text-align: center;"><#=objRow.CName#></td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;"><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;"><#=objRow.Email#></td>
                    <td class="GridViewLabItemStyle" style="width: 30px; text-align: center;">
                         <img id="imgRound" data-title="Click To Select Candidate" src="../../Images/Post.gif" style="cursor:pointer"   onclick="SearchCandidateDetails(this);"  />
                    </td>
                </tr>
           <#}#>
        </table>
    </script>

    </asp:content>
