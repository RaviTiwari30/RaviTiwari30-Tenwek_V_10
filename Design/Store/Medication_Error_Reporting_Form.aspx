<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Medication_Error_Reporting_Form.aspx.cs" Inherits="Design_Store_Medication_Error_Reporting_Form" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagName="StartTime" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     
    <div>
            
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/Common.js"></script>
 
        
        <style type="text/css">
            th {
            background-color:royalblue;
            color:white;
            
            }
            input[type=text] {
                width: 100%;
            }
            table,td,th {
            padding:2px;
            margin:5px;
  border-collapse: collapse;
            }
        .holder {
                position: relative;
            }
            .dropdown {
                width:500px;
                height:120px;
                overflow-y:auto;
                margin-top:25px;
                position: absolute;
                z-index:999;
                border: 1px solid black;
                display: none;
                background-color:white;
                color:black;
            }

            input:focus + .dropdown {
                display: block;
            }
        .deleted {
            display:none;
        }
        .ajax__scroll_none {
    overflow: visible !important;
    z-index: 10000 !important;
}
           
    </style>
    
    <script type="text/javascript">


        function PrepareData() {
            var data = new Array();
            var obj = new Object();
            obj.ID = $("#txtID").val();
            obj.Date = $("#<%=txtDateOnEvent.ClientID %>").val();
            obj.Time = $("#ctl00_ContentPlaceHolder1_StartTime1_txtTime").val();
            obj.InstitutionName = $("#txtNameOfInstitution").val();
            obj.Contact = $("#txtContact").val();
            obj.FacilityCode = $("#txtFacilityCode").val();
            obj.County = $("#txtCounty").val();
            obj.UHID = $("#txtUHID").val();
            obj.PatientInitials = $("#txtPatientInitials").val();
            obj.DOBAge = $("#txtDOBAge").val();
            obj.Gender = $('#<%=rdbGender.ClientID %> input[type=radio]:checked').val();
                        obj.LocationOfEvent = $('input[name=radioLocationEvent]:checked').val();

                        obj.LocationSpecify = $("#txtOthersSpecify").val();
                        obj.ErrorDesc = $("#txtErrorDesc").val();
                        obj.ProcessErrorOccured = $('#<%=rdbProcess.ClientID %> input[type=radio]:checked').val();
            //$("#txtProcessSpecify").val(); 
                        obj.ErrorReachPatient = $('#<%=rdbErrorReachPatient.ClientID %> input[type=radio]:checked').val();
            obj.IsCorrectMedicineTaken = $('#<%=rdbAdministeredtakenByPatient.ClientID %> input[type=radio]:checked').val();
            obj.DirectResultOnPatient = $("#txtResultDescription").val();
            obj.ErrorOutcomeCategory = $('input[name=radioErrorOutComeCategory]:checked').val();
            // $("#txtResultDescription").val();
            if ($("#chkInexperiencedpersonnel").is(":checked") == true) {
                obj.Inexperiencedpersonnel = "Yes";
            }
            else {
                obj.Inexperiencedpersonnel = "No";
            }
            if ($("#chkInadequateknowledge").is(":checked") == true) {
                obj.Inadequateknowledge = "Yes";
            }
            else {
                obj.Inadequateknowledge = "No";
            }
            if ($("#chkDistraction").is(":checked") == true) {
                obj.Distraction = "Yes";
            }
            else {
                obj.Distraction = "No";
            }
            if ($("#chkHeavyworkload").is(":checked") == true) {
                obj.Heavyworkload = "Yes";
            }
            else {
                obj.Heavyworkload = "No";
            }
            if ($("#chkPeakhour").is(":checked") == true) {
                obj.Peakhour = "Yes";
            }
            else {
                obj.Peakhour = "No";
            }
            if ($("#chkStockarrangementsstorageproblem").is(":checked") == true) {
                obj.Stockarrangementsstorageproblem = "Yes";
            }
            else {
                obj.Stockarrangementsstorageproblem = "No";
            }
            if ($("#chkFailuretoadheretoworkprocedure").is(":checked") == true) {
                obj.Failuretoadheretoworkprocedure = "Yes";
            }
            else {
                obj.Failuretoadheretoworkprocedure = "No";
            }
            if ($("#chkUseofabbreviations").is(":checked") == true) {
                obj.Useofabbreviations = "Yes";
            }
            else {
                obj.Useofabbreviations = "No";
            }
            if ($("#chkIllegibleprescriptions").is(":checked") == true) {
                obj.Illegibleprescriptions = "Yes";
            }
            else {
                obj.Illegibleprescriptions = "No";
            }
            if ($("#chkPatientinformationrecordunavailableinaccurate").is(":checked") == true) {
                obj.Patientinformationrecordunavailableinaccurate = "Yes";
            }
            else {
                obj.Patientinformationrecordunavailableinaccurate = "No";
            }

            if ($("#chkWronglabellinginstructionondispensingenveloporbottlecontainer").is(":checked") == true) {
                obj.Wronglabelling = "Yes";
            }
            else {
                obj.Wronglabelling = "No";
            }
            if ($("#chkIncorrectcomputerentry").is(":checked") == true) {
                obj.Incorrectcomputerentry = "Yes";
            }
            else {
                obj.Incorrectcomputerentry = "No";
            }
            if ($("#chkOthersSpecifyTNT").is(":checked") == true) {
                obj.Others = "Yes";
            }
            else {
                obj.Others = "No";
            }

            obj.OthersSpecify = $("#txtTaskAndTechnologySpecify").val();
            obj.GenericName1 = $("#txtGenericName1").val();
            obj.GenrnicName2 = $("#txtGenericName2").val();
            obj.BrandName1 = $("#txtBrandName1").val();
            obj.BrandName2 = $("#txtBrandName2").val();
            obj.DosageFrom1 = $("#txtDosageFrom1").val();
            obj.DosageFrom2 = $("#txtDosageFrom2").val();
            obj.DoseFrequency1 = $("#txtDoseFrequency1").val();
            obj.DoseFrequency2 = $("#txtDoseFrequency2").val();
            obj.Manufacturer1 = $("#txtManufacturer1").val();
            obj.Manufacturer2 = $("#txtManufacturer2").val();
            obj.Strengthconcentration1 = $("#txtStrengthconcentration1").val();
            obj.Strengthconcentration2 = $("#txtStrengthconcentration2").val();
            obj.Typeandsizeofcontainer1 = $("#txtTypeandsizeofcontainer1").val();
            obj.Typeandsizeofcontainer2 = $("#txtTypeandsizeofcontainer2").val();
            obj.recommendations = $("#txtrecommendations").val();
            obj.NameofInitialreporter = $("#txtNameofInitialreporter").val();
            obj.Cadredesignation1 = $("#txtCadredesignation1").val();
            obj.Mobileno1 = $("#txtMobileno1").val();
            obj.Email1 = $("#txtEmail1").val();
            obj.Dateofreport = $("#txtDateOfReport").val();
            obj.Name2 = $("#txtName2").val();
            obj.Cadredesignation2 = $("#txtCadredesignation2").val();
            obj.Mobileno2 = $("#txtMobileno2").val();
            obj.Email2 = $("#txtEmail2").val();
            obj.DateofSubmission = $("#txtDateofSubmission").val();
            data.push(obj);
            return data;
        }
        function saveData() {

            var data = PrepareData();

            if (data != "") {

                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ data: data }),
                    url: "Medication_Error_Reporting_Form.aspx/SaveData",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        var IntakeOutPut = (result.d);
                        if (IntakeOutPut == '1') {
                            alert("Record Saved Successfully");

                        }
                        else {
                            alert('Error occurred, Please contact administrator');
                            //bindPatientInfo();
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                        $('#btnSave').removeProp('disabled');
                    }

                });
            }
            else
                alert('Please fill At Least One medicine');

        }
        function fillData(obj) {
            $("#txtID").val(obj.ID);
            $("#txtUHID").val(obj.ID);
            $("#<%=txtDateOnEvent.ClientID %>").val(obj.Date1);
            $("#ctl00_ContentPlaceHolder1_StartTime1_txtTime").val(obj.Time);
            $("#txtNameOfInstitution").val(obj.InstitutionName);
            $("#txtContact").val(obj.Contact);
            $("#txtFacilityCode").val(obj.FacilityCode);
            $("#txtCounty").val(obj.County);
            $("#txtUHID").val(obj.UHID);
            $("#txtPatientInitials").val(obj.PatientInitials);
            $("#txtDOBAge").val(obj.DOBAge);
            if (obj.Gender == "Male") {
                $('#<%=rdbGender.ClientID %>').find("input[value='Male']").prop("checked", true);
            }
            else {
                $('#<%=rdbGender.ClientID %>').find("input[value='Female']").prop("checked", true);
            }
            $("input[name=radioLocationEvent][value=" + obj.LocationOfEvent + "]").prop('checked', true);

            $("#txtOthersSpecify").val(obj.LocationSpecify);
            $("#txtErrorDesc").val(obj.ErrorDesc);
            switch (obj.ProcessErrorOccured) {
                case "Prescribing":
                    $('#<%=rdbProcess.ClientID %>').find("input[value='Prescribing']").prop("checked", true);
                    break;
                case "Dispensing (includes filling)":
                    $('#<%=rdbProcess.ClientID %>').find("input[value='Dispensing (includes filling)']").prop("checked", true);
                    break;
                case "Administration":
                    $('#<%=rdbProcess.ClientID %>').find("input[value='Administration']").prop("checked", true);
                    break;
                case "Others (Please specify)":
                    $('#<%=rdbProcess.ClientID %>').find("input[value='Accident & Emergency/Casualty']").prop("checked", true);
                    break;
                case "Others (Please specify)":
                    $('#<%=rdbProcess.ClientID %>').find("input[value='Others (Please specify)']").prop("checked", true);
                    break;
            }
            //$("#txtProcessSpecify").val();
            if (obj.ErrorReachPatient == "Yes") {
                $('#<%=rdbErrorReachPatient.ClientID %>').find("input[value='Yes']").prop("checked", true);

            }
            else {
                $('#<%=rdbErrorReachPatient.ClientID %>').find("input[value='No']").prop("checked", true);

            }
            if (obj.IsCorrectMedicineTaken == "Yes") {
                $('#<%=rdbAdministeredtakenByPatient.ClientID %>').find("input[value='Yes']").prop("checked", true);

            }
            else {
                $('#<%=rdbAdministeredtakenByPatient.ClientID %>').find("input[value='No']").prop("checked", true);

            }
            $('#txtResultDescription').val(obj.DirectResultOnPatient);
            $("input[name=radioErrorOutComeCategory][value=" + obj.ErrorOutcomeCategory + "]").attr('checked', 'checked');
            if (obj.Inexperiencedpersonnel == "Yes") {
                $("#chkInexperiencedpersonnel").prop('checked', true);
            }
            else {

                $("#chkInexperiencedpersonnel").prop('checked', false);
            }
            if (obj.Inadequateknowledge == "Yes") {
                $("#chkInadequateknowledge").prop('checked', true);
            }
            else {

                $("#chkInadequateknowledge").prop('checked', false);
            }
            if (obj.Distraction == "Yes") {
                $("#chkDistraction").prop('checked', true);
            }
            else {

                $("#chkDistraction").prop('checked', false);
            }
            if (obj.Heavyworkload == "Yes") {
                $("#chkHeavyworkload").prop('checked', true);
            }
            else {

                $("#chkHeavyworkload").prop('checked', false);
            }
            if (obj.Peakhour == "Yes") {
                $("#chkPeakhour").prop('checked', true);
            }
            else {

                $("#chkPeakhour").prop('checked', false);
            }
            if (obj.Stockarrangementsstorageproblem == "Yes") {
                $("#chkStockarrangementsstorageproblem").prop('checked', true);
            }
            else {

                $("#chkStockarrangementsstorageproblem").prop('checked', false);
            }
            if (obj.Failuretoadheretoworkprocedure == "Yes") {
                $("#chkFailuretoadheretoworkprocedure").prop('checked', true);
            }
            else {

                $("#chkFailuretoadheretoworkprocedure").prop('checked', false);
            }
            if (obj.Useofabbreviations == "Yes") {
                $("#chkUseofabbreviations").prop('checked', true);
            }
            else {

                $("#chkUseofabbreviations").prop('checked', false);
            }
            if (obj.Illegibleprescriptions == "Yes") {
                $("#chkIllegibleprescriptions").prop('checked', true);
            }
            else {

                $("#chkIllegibleprescriptions").prop('checked', false);
            }
            if (obj.Patientinformationrecordunavailableinaccurate == "Yes") {
                $("#chkPatientinformationrecordunavailableinaccurate").prop('checked', true);
            }
            else {

                $("#chkPatientinformationrecordunavailableinaccurate").prop('checked', false);
            }
            if (obj.Wronglabelling == "Yes") {
                $("#chkWronglabellinginstructionondispensingenveloporbottlecontainer").prop('checked', true);
            }
            else {

                $("#chkWronglabellinginstructionondispensingenveloporbottlecontainer").prop('checked', false);
            }
            if (obj.Incorrectcomputerentry == "Yes") {
                $("#chkIncorrectcomputerentry").prop('checked', true);
            }
            else {

                $("#chkIncorrectcomputerentry").prop('checked', false);
            }
            if (obj.Others == "Yes") {
                $("#chkOthersSpecifyTNT").prop('checked', true);
            }
            else {

                $("#chkOthersSpecifyTNT").prop('checked', false);
            }

            $("#txtTaskAndTechnologySpecify").val(obj.OthersSpecify);
            $("#txtGenericName1").val(obj.GenericName1);
            $("#txtGenericName2").val(obj.GenrnicName2);
            $("#txtBrandName1").val(obj.BrandName1);
            $("#txtBrandName2").val(obj.BrandName2);
            $("#txtDosageFrom1").val(obj.DosageFrom1);
            $("#txtDosageFrom2").val(obj.DosageFrom2);
            $("#txtDoseFrequency1").val(obj.DoseFrequency1);
            $("#txtDoseFrequency2").val(obj.DoseFrequency2);
            $("#txtManufacturer1").val(obj.Manufacturer1);
            $("#txtManufacturer2").val(obj.Manufacturer2);
            $("#txtStrengthconcentration1").val(obj.Strengthconcentration1);
            $("#txtStrengthconcentration2").val(obj.Strengthconcentration2);
            $("#txtTypeandsizeofcontainer1").val(obj.Typeandsizeofcontainer1);
            $("#txtTypeandsizeofcontainer2").val(obj.Typeandsizeofcontainer2);
            $("#txtrecommendations").val(obj.recommendations);
            $("#txtNameofInitialreporter").val(obj.NameofInitialreporter);
            $("#txtCadredesignation1").val(obj.Cadredesignation1);
            $("#txtMobileno1").val(obj.Mobileno1);
            $("#txtEmail1").val(obj.Email1);
            $("#txtDateOfReport").val(obj.Dateofreport1);
            $("#txtName2").val(obj.Name2);
            $("#txtCadredesignation2").val(obj.Cadredesignation2);
            $("#txtMobileno2").val(obj.Mobileno2);
            $("#txtEmail2").val(obj.Email2);
            $("#txtDateofSubmission").val(obj.DateofSubmission1);
        }
        function fillForm(id) {
            jQuery.ajax({
                type: "POST",
                url: "Medication_Error_Reporting_Form.aspx/BindGrid2",
                data: '{id:"' + id + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    if ((response.d != null) && (response.d != "")) {
                        var objRow = JSON.parse(response.d);
                        fillData(objRow[0]);

                    }
                },
                error: function (e) { }
            });
        }
        function bindGrid1(pid) {
            jQuery.ajax({
                type: "POST",
                url: "Medication_Error_Reporting_Form.aspx/BindGrid1",
                data: '{pid:"' + pid + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    if ((response.d != null) && (response.d != "")) {
                        billsDetails = JSON.parse(response.d);
                        var output = $('#templateBillsSearchDetails').parseTemplate(billsDetails);
                        $('#divBillDetailsDetails').html(output).customFixedHeader();

                    }
                },
                error: function (e) { }
            });
        }

        function bindGrid() {
            //var uhid = $('#txtUHID').val();
            //alert(key);
            jQuery.ajax({
                type: "POST",
                url: "Medication_Error_Reporting_Form.aspx/BindGrid",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    if ((response.d != null) && (response.d != "")) {
                        billsDetails = JSON.parse(response.d);
                        var output = $('#templateBillsSearchDetails').parseTemplate(billsDetails);
                        $('#divBillDetailsDetails').html(output).customFixedHeader();

                    }
                },
                error: function (e) { }
            });
        }
        function setRadio() {
            $('#radioWard').change(function () {
                if ($(this).is(':checked')) {
                    $("#txtWardSpecify").show();

                    $("#txtClinicSpecify").hide();
                    $("#txtPharmacySpecify").hide();
                    $("#txtAccidentSpecify").hide();
                    $("#txtOthersSpecify").hide();
                }

            });
            $('#radioClinic').change(function () {
                if ($(this).is(':checked')) {
                    $("#txtClinicSpecify").show();

                    $("#txtWardSpecify").hide();

                    $("#txtPharmacySpecify").hide();
                    $("#txtAccidentSpecify").hide();
                    $("#txtOthersSpecify").hide();
                }

            });
            $('#radioPharmacy').change(function () {
                if ($(this).is(':checked')) {
                    $("#txtPharmacySpecify").show();

                    $("#txtClinicSpecify").hide();
                    $("#txtWardSpecify").hide();
                    $("#txtAccidentSpecify").hide();
                    $("#txtOthersSpecify").hide();
                }

            });
            $('#radioAccident').change(function () {
                if ($(this).is(':checked')) {
                    $("#txtAccidentSpecify").show();

                    $("#txtWardSpecify").hide();
                    $("#txtPharmacySpecify").hide();
                    $("#txtClinicSpecify").hide();
                    $("#txtOthersSpecify").hide();
                }

            });
            $('#radioOthers').change(function () {
                if ($(this).is(':checked')) {
                    $("#txtOthersSpecify").show();

                    $("#txtWardSpecify").hide();
                    $("#txtPharmacySpecify").hide();
                    $("#txtAccidentSpecify").hide();
                    $("#txtClinicSpecify").hide();
                }

            });

            $('#<%=rdbProcess.ClientID %>').change(function () {
                    if ($('#<%=rdbProcess.ClientID %>  input:checked').val() == "Others") {
                        $("#txtProcessSpecify").show();
                    }
                    else {
                        $("#txtProcessSpecify").hide();
                    }

                });

                $('#chkOthersSpecifyTNT').change(function () {
                    if ($(this).is(':checked') == true) {
                        $("#txtTaskAndTechnologySpecify").show();
                    }
                    else {
                        $("#txtTaskAndTechnologySpecify").hide();
                    }

                });

            }

            $(document).ready(function () {
                bindGrid();
                setRadio();
                $("#StartTime_txtTime").prop('disabled', true);
                $('#rdbAnyKnownAllergy_1').change(function () {
                    if (this.value == 'Yes') {
                        $("#txtAllergySpecify").show();
                    }

                });
                $('#rdbAnyKnownAllergy_1').change(function () {
                    if (this.value == 'No') {
                        $("#txtAllergySpecify").hide();

                    }
                });
            });

    </script>
    
    <div id="Pbody_box_inventory">
        
        <cc1:ToolkitScriptManager ID="scrManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;"><br /><br /><br />
            <b>MEDICATION ERROR REPORTING FORM</b><br /><span id="spanPatInfoID" runat="server" style="display:none;"></span>
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
            
        <div class="POuter_Box_Inventory">
        <div class="row">
                                <div class="col-sm-2">

                                    
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left"><b>1. Date of event  </b>   </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDateOnEvent" runat="server"></asp:TextBox>
                                       
                                      <cc1:CalendarExtender ID="caldate" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDateOnEvent" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                </div>
                                <div class="col-md-4">
                                    <label class="pull-left"><b>2. Time of event</b> </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-6">
                                   
                                    
                            <uc2:StartTime ID="StartTime1" runat="server" />
                                </div>

                            </div>
            </div>
            
        <div class="POuter_Box_Inventory">
            <div class="row">
       
         
        <div class="col-md-12">
            <b>3. Institution details</b>
          </div>
                </div>
            

            <div class="row">
       
         
        <div class="col-md-3">
            Name of Institution:</div>
        <div class="col-md-3">
            <asp:TextBox ID="txtNameOfInstitution" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Name of Institution" Text="Tenwek" />
            
          </div>
        <div class="col-md-3">
            Contact/Tel No:</div>
        <div class="col-md-3">
            <asp:TextBox ID="txtContact" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Contact/Tel No" MaxLength="10" Text="0728091900" />
             <cc1:FilteredTextBoxExtender ID="ftbHT" runat="server" TargetControlID="txtContact" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                               
            
          </div>
                
        <div class="col-md-3">
            Facility Code:</div>
        <div class="col-md-3">
            <asp:TextBox ID="txtFacilityCode" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Facility Code" />
            
          </div>
                <div class="col-md-3">
            County:</div>
        <div class="col-md-3">
            <asp:TextBox ID="txtCounty" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="County" Text="Bomet" />
            
          </div>
                
        <div class="col-md-3">
            </div>
                </div>
            </div>
            
        <div class="POuter_Box_Inventory">
                <div class="row">
       
         
        <div class="col-md-12">
          <b> 4. Patient Information</b>
          </div>
                </div>
            
            <div class="row">
       
         
        <div class="col-md-3">
            UHID:</div>
        <div class="col-md-3">
            <input type="hidden" id="txtID" />
            <asp:TextBox ID="txtUHID" runat="server" TabIndex="1"  ClientIDMode="Static"  onblur="bindGrid1($(this).val());"  ToolTip="UHID" />
            
          </div>
        <div class="col-md-3">
            Patient initials:</div>
        <div class="col-md-3">
            <asp:TextBox ID="txtPatientInitials" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Patient initials" />
            
          </div>
                
        <div class="col-md-3">
            DOB/Age:</div>
        <div class="col-md-3">
            <asp:TextBox ID="txtDOBAge" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="DOB/Age" />
            
          </div>
                <div class="col-md-3">
            Gender:</div>
        <div class="col-md-3">
            
            <asp:RadioButtonList ID="rdbGender" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="Male" >Male</asp:ListItem>
                                          <asp:ListItem Value="Female">Female</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
          </div>
                
        <div class="col-md-3">
            </div>
                </div>
            </div>
            
        <div class="POuter_Box_Inventory">
            <div class="row">
       
         
        <div class="col-md-12">
          <b>5. Details on the medication error</b> 
          </div>
                </div>
            <div class="row">
       
         
        <div class="col-md-24">
            Location of event:<br />
            <div class="row">
                <div class="col-md-12">
                       <table style="width:100%;"><tr><td> <input type="radio" id="radioWard" name="radioLocationEvent" value="value1" /> Ward (Specify: medical, paeds, ortho)</td><td style="width:200px;" > <input type="text" id="txtWardSpecify" style="width:200px;display:none;" /></td></tr></table> 
                       <table style="width:100%;"><tr><td> <input type="radio" id="radioClinic" name="radioLocationEvent" value="value2" /> Clinic (Specify: outpatient, dental, specialist)</td><td style="width:200px;" >  <input type="text" id="txtClinicSpecify"  style="width:200px;display:none;" /></td></tr></table> 
                         <table style="width:100%;"><tr><td> <input type="radio" id="radioPharmacy" name="radioLocationEvent" value="value3" /> Pharmacy (paeds, main, inpatient, outpatient)</td><td style="width:200px;" >  <input type="text" id="txtPharmacySpecify"  style="width:200px;display:none;" /></td></tr></table> 
                </div>
                <div class="col-md-12">
                        <table style="width:100%;"><tr><td>  <input type="radio" id="radioAccident" name="radioLocationEvent" value="value4" /> Accident & Emergency/Casualty</td><td style="width:200px;" >  <input type="text" id="txtAccidentSpecify"  style="width:200px;display:none;" /></td></tr></table> 
                         <table style="width:100%;"><tr><td> <input type="radio" id="radioOthers" name="radioLocationEvent"  value="value5" /> Others: (Please specify)</td><td style="width:200px;" >  <input type="text" id="txtOthersSpecify"  style="width:200px;display:none;" /></td></tr></table>
                          </div>

            </div>
           
             </div>
                </div>
            </div>
         
        <div class="POuter_Box_Inventory">
            <div class="row">
            <div class="col-md-12">
          <b>6. Please describe the error. Include description/ sequence of events and work environment (e.g. change of shift, short staffing, during peak hours). If more space is needed, please
attach a separate page.</b> 
          </div>
            
            <div class="col-md-12"> <asp:TextBox ID="txtErrorDesc" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Error Desc" />
           
                </div>
                </div>
        
            <div class="row">
            <div class="col-md-24">
                
            <div class="row">
            <div class="col-md-8">
            
          <b>7. In which process did the error occur?</b> 
                 <asp:RadioButtonList ID="rdbProcess" runat="server" RepeatDirection="Vertical" 
                >
                                                <asp:ListItem Value="Prescribing" >Prescribing</asp:ListItem>
                                          <asp:ListItem Value="Dispensing (includes filling)">Dispensing (includes filling)</asp:ListItem>
                                                <asp:ListItem Value="Administration" >Administration</asp:ListItem>
                                                <asp:ListItem Value="Others" >Others (Please specify)</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
           
            <asp:TextBox ID="txtProcessSpecify" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Specify" style="display:none;" />
                </div>
                <div class="col-md-8">
                   <b> 8. Did the error reach the patient?</b><br />
                     <asp:RadioButtonList ID="rdbErrorReachPatient" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="No" >No</asp:ListItem>
                                          <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                    <br />

                   <b> 9. Was the correct medication, dose or dosage form
                    administered to or taken by the patient? </b>   <br />
                    <asp:RadioButtonList ID="rdbAdministeredtakenByPatient" runat="server" RepeatDirection="Horizontal" 
                >
                                                <asp:ListItem Value="No" >No</asp:ListItem>
                                          <asp:ListItem Value="Yes">Yes</asp:ListItem>
                                          
                                      </asp:RadioButtonList>
                           
                </div>
                <div class="col-md-8">
                    <b>10. Describe the direct result on the patient (e.g. death, type
                        of harm, additional patient monitoring e.g. BP, heart rate,
                        glucose level etc)</b>
            <asp:TextBox ID="txtResultDescription" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="Specify"  />
                </div>
                </div>
                </div>
                </div>
            </div>
        
        <div class="POuter_Box_Inventory">
             <div class="row">
        <div class="col-md-24">
          <b>11. Please tick the appropriate Error Outcome Category (Tick one appropriate box below):</b> 
          </div>
                </div>
            
             <div class="row">
        <div class="col-md-24">
            <table style="width:100%;" border="1">
                <tr><th>NO ERROR</th><th colspan="2">ERROR, HARM</th></tr>
                <tr><td><input type="radio" name="radioErrorOutComeCategory" value="value1" />Potential error, circumstances/events have
potential to cause incident</td>
                    <td><input type="radio"  name="radioErrorOutComeCategory" value="value2" />Treatment /intervention required-caused temporary harm<br />
                        <input type="radio"  name="radioErrorOutComeCategory" value="value3" />Initial/prolonged hospitalization-caused temporary harm<br />
                    </td>
                    <td><input type="radio"  name="radioErrorOutComeCategory" value="value4" />Caused permanent harm<br />
                        <input type="radio" name="radioErrorOutComeCategory" value="value5" />Near death event<br /></td></tr>
                
                <tr><th colspan="2">ERROR, NO HARM</th><th>ERROR, DEATH</th></tr>
                <tr><td><input type="radio"  name="radioErrorOutComeCategory" value="value6" />Actual error-did not reach patient
                </td>
                    <td><input type="radio"  name="radioErrorOutComeCategory" value="value7" />Actual error-caused no harm<br />
                        <input type="radio"  name="radioErrorOutComeCategory" value="value8" />Additional monitoring required-caused no harm<br />
                    </td>
                    <td><input type="radio"  name="radioErrorOutComeCategory" value="value9" />Death<br /></td></tr>
            </table>
            </div>
                 </div>
            
             <div class="row">
        <div class="col-md-24">
          <b>12. Indicate the possible error cause(s) and contributing factor(s) below (Tick the appropriate box(es):</b> 
          </div>
                </div>
            
             <div class="row">
        <div class="col-md-24">
             <table style="width:100%;" border="1">
                <tr><td>
                    <b>Staff factors</b><br />
                    <input type="checkbox" id="chkInexperiencedpersonnel" />Inexperienced personnel
<br />
                     <input type="checkbox" id="chkInadequateknowledge" />Inadequate knowledge
<br />
                     <input type="checkbox" id="chkDistraction" />Distraction
<br />
                     <b>Medication related </b><br />
                    <input type="checkbox" id="chkSoundalikemedication" />Sound alike medication
<br />
                     <input type="checkbox" id="chkLookalikemedication"/>Look alike medication
<br />
                     <input type="checkbox" id="chkLookalikepackaging" />Look alike packaging

                    </td>
                    <td style="vertical-align:top;">
                     <b>Work and environment </b><br />
                    <input type="checkbox" id="chkHeavyworkload" />Heavy workload
<br />
                     <input type="checkbox" id="chkPeakhour"/>Peak hour
<br />
                     <input type="checkbox" id="chkStockarrangementsstorageproblem" />Stock arrangements/storage problem

                    </td>
                    <td><b>Task and technology</b><br />
                    <input type="checkbox" id="chkFailuretoadheretoworkprocedure"/>Failure to adhere to work procedure
<br />
                     <input type="checkbox" id="chkUseofabbreviations"/>Use of abbreviations
<br />
                     <input type="checkbox" id="chkIllegibleprescriptions"/>Illegible prescriptions
<br />
                     
                    <input type="checkbox" id="chkPatientinformationrecordunavailableinaccurate"/>Patient information/record unavailable/ inaccurate
<br />
                     <input type="checkbox" id="chkWronglabellinginstructionondispensingenveloporbottlecontainer"/>Wrong labelling/instruction on dispensing envelope or bottle/container
<br />
                     <input type="checkbox" id="chkIncorrectcomputerentry"/>Incorrect computer entry
<br />
                     <input type="checkbox" id="chkOthersSpecifyTNT" />Others (please specify):
<input type="text" id="txtTaskAndTechnologySpecify" style="display:none;"/><br /></td></tr>
            </table>
           
            </div>
                 </div>
            
             <div class="row">
        <div class="col-md-24">
          <b>13. Product details: Please complete the following for products involved. Kindly attach a separate page for additional products</b> 
          </div>
                </div>
            
             <div class="row">
        <div class="col-md-24">
            <table style="width:100%;" border="1">
                <tr><th>Product Description</th><th>Product No. 1 (intended)</th><th>Product No. 2 (error)</th>
                    </tr>
                <tr><td>13.1 Generic name (active ingredient)</td><td><asp:TextBox ID="txtGenericName1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td><asp:TextBox ID="txtGenericName2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td></tr>
                
                <tr><td>13.2 Brand/ Product Name</td><td><asp:TextBox ID="txtBrandName1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td><asp:TextBox ID="txtBrandName2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td></tr>
                
                <tr><td>13.3 Dosage form</td><td><asp:TextBox ID="txtDosageFrom1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td><asp:TextBox ID="txtDosageFrom2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td></tr>
                
                <tr><td>13.4 Dose, frequency, duration, route</td><td><asp:TextBox ID="txtDoseFrequency1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td><asp:TextBox ID="txtDoseFrequency2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td></tr>
                    </table>
            </div>
                 </div>
            
             <div class="row">
        <div class="col-md-24">
          <b>Please fill in 13.5-13.7 if error involved look alike (similar) product packaging:</b> 
          </div>
                </div>
            <div class="row">
        <div class="col-md-24">
            <table style="width:100%;" border="1">
                <tr><th>Product Description</th><th>Product No. 1 (intended)</th><th>Product No. 2 (error)</th>
                    </tr>
                <tr><td>13.5 Manufacturer</td><td><asp:TextBox ID="txtManufacturer1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td><asp:TextBox ID="txtManufacturer2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td></tr>
                
                <tr><td>13.6 Strength/concentration</td><td><asp:TextBox ID="txtStrengthconcentration1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td><asp:TextBox ID="txtStrengthconcentration2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td></tr>
                
                <tr><td>13.7 Type and size of container</td><td><asp:TextBox ID="txtTypeandsizeofcontainer1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td><asp:TextBox ID="txtTypeandsizeofcontainer2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td></tr>
                
                
                    </table>
            </div>
                 </div>

                 <div class="row">
        <div class="col-md-24">
          <b>14. Suggest any recommendations, or describe policies or procedures you instituted or plan to institute to prevent future similar errors. If available, kindly attach an investigational
report e.g. Root Cause Analysis (RCA)</b> 
          </div>
                </div>
            <div class="row">
        <div class="col-md-24">
            <asp:TextBox ID="txtrecommendations" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
          </div>
                </div>
            <div class="row">
        <div class="col-md-24">
            <b>Reporter Details</b><br />
            <table style="width:100%;vertical-align:top;" border="1">
               
                <tr><td style="vertical-align:top;width:400px;">Name of Initial reporter:<asp:TextBox ID="txtNameofInitialreporter" runat="server" TabIndex="1" style="float:left;"  ClientIDMode="Static"   ToolTip="" Enabled="false" /></td>
                    <td style="vertical-align:top;width:400px;">Cadre/designation:<asp:TextBox ID="txtCadredesignation1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td style="vertical-align:top;width:400px;">Mobile no:<asp:TextBox ID="txtMobileno1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip=""  MaxLength="10" />
                
             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtMobileno1" ValidChars="0123456789"></cc1:FilteredTextBoxExtender><br />
                Email:<asp:TextBox ID="txtEmail1" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td>                     
                    <td style="vertical-align:top;width:400px;">Date of report:<asp:TextBox ID="txtDateOfReport" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
                          <cc1:CalendarExtender ID="CalendarExtender2" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDateOfReport" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                
</td>
                </tr>
                <tr><td style="vertical-align:top;width:400px;">Name of Person Submitting to PPB if different from
reporter<asp:TextBox ID="txtName2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" /></td>
                    <td style="vertical-align:top;width:400px;">Cadre/designation:<asp:TextBox ID="txtCadredesignation2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td><td style="vertical-align:top;width:400px;">Mobile no:<asp:TextBox ID="txtMobileno2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" MaxLength="10" />
                
             <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" TargetControlID="txtMobileno2" ValidChars="0123456789"></cc1:FilteredTextBoxExtender><br />
                Email:<asp:TextBox ID="txtEmail2" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
            </td> 
                    <td style="vertical-align:top;width:400px;">Date of Submission:<asp:TextBox ID="txtDateofSubmission" runat="server" TabIndex="1"  ClientIDMode="Static"   ToolTip="" />
                          <cc1:CalendarExtender ID="CalendarExtender1" PopupButtonID="ucFromDate" runat="server" TargetControlID="txtDateofSubmission" Format="dd-MMM-yyyy"> </cc1:CalendarExtender> 
                                

                    </td>
                </tr>
                
                
                    </table>
            </div>
                 </div>
            </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                           
                        </div>
                        <div class="col-md-5">
                            
                        </div>
                        <div class="col-md-3">
                           <%--<asp:Button ID="btnSave" runat="server"  autocomplete="off" CssClass="save" Text="Save" OnClientClick="return saveData();" ClientIDMode="Static"  /> 
                          --%>
                            <button class="save" onclick="return saveData();">Save</button>
                        </div>
                        
                        
                        <div class="col-md-3">
                           
                        </div>
                        <div class="col-md-3">
                                   </div>
                        
                    </div>
                </div>
            </div>
        </div>
                   <script id="templateBillsSearchDetails" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="grdOPDBillsSettlement" style="width:100%;border-collapse:collapse;">
		<thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" >UHID</th>
			<th class="GridViewHeaderStyle" scope="col" >Patient Initials</th>
			<th class="GridViewHeaderStyle" scope="col" >Date</th>
			<th class="GridViewHeaderStyle" scope="col" >Time</th>
			<th class="GridViewHeaderStyle" scope="col" >Edit</th>
			<th class="GridViewHeaderStyle" scope="col" >Print</th>
			  
		</tr>
			</thead>
		<#
		var dataLength=billsDetails.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;
		var status;
	
		for(var j=0;j<dataLength;j++)
		{
		objRow = billsDetails[j];
		#>
					<tr   >
					<td class="GridViewLabItemStyle" id="tdSNo"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdCentreName"  style="text-align:left" ><#=objRow.UHID#></td>
                       
					<td class="GridViewLabItemStyle" id="tdBillDate"  style="text-align:center" > <#=objRow.PatientInitials#></td>
					<td class="GridViewLabItemStyle" id="td1"  style="text-align:center" ><#=objRow.Date1#></td>
					<td class="GridViewLabItemStyle textCeneter" id="tdBillNo" ><#=objRow.Time#>
								</td>
					<td class="GridViewLabItemStyle" id="tdPatientName" ><img src="../../Images/edit.png" onclick="fillForm(<#=objRow.ID#>);" /></td>
					<td class="GridViewLabItemStyle" id="td2" ><img src="../../Images/print.gif" onclick="window.open('./MEDICATIONERRORREPORTINGFORM_PDF.aspx?TestID=O23&LabType=&LabreportType=11&PID=<#=objRow.ID #>', '_blank');" /></td>
					</tr>
		<#}
		#>     
	 </table>
	</script>
         
              <div class="POuter_Box_Inventory ">
			<div class="row">
				<div  style="overflow:auto;max-height:410px" id="divBillDetailsDetails" class="col-md-24">

				</div>
			</div>
		</div>
        
        <div id="divModal" class="modal fade">
                    <div class="modal-dialog modal-sm"" >
                        <div class="modal-content">
                            <div class="modal-header">
                                <b class="modal-title">Success Message</b> <button type="button" class="close"  onclick="$('#divModal').hide();">&times;</button>
                            </div>
                            <div class="modal-body"  style="width:200px;height:60px;">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                        <span id="spanMsg"></span><br /><br />
                                        <button type="button"  onclick="$('#divModal').hide();">OK</button>
                                    </div>
                                </div>
                                                                        </div>
                            <div class="modal-footer">
                                <div class="row">
                                    <div class="col-md-24" style="text-align: center;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
    </div>
        

</asp:Content>

