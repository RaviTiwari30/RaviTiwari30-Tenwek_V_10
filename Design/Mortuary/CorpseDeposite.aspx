<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CorpseDeposite.aspx.cs" Inherits="Design_Mortuary_CorpseDeposite" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .hover {
            background-color: LimeGreen;
            color: white;
            cursor: default;
        }

        .Counthover {
            background-color: LimeGreen;
            color: white;
            cursor: pointer;
            font-size: 14px;
        }

        #imgPatient {
            width: 103px;
            height: 107px;
        }
    </style>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //DisableControls();
            //EnableControls();
            bindCountry();
            bindReligion();
            bindLocality();
            bindRelation();
            bindStatus();
            bindMedicalOfficer();
            bindAuthorized();
            bindEmployee();
            bindMedicName();
            bindFreezer("0", "0,1");
            $("#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime").attr("tabindex", "8");
            $("#txtCFirstName").focus();
            bindCorpseDetail();
            $("#btnSearch").click(function () {

                $("#lblErrorMsg").text("");
                $("#btnSearch").val("Searching...");
                $("#btnSearch").attr("disabled", true);
                $.ajax({
                    url: "CorpseDeposite.aspx/SearchCorpse",
                    data: '{CorpseNo:"",DepositeNo:"",FirstName:"",LastName:"",FromDate:"' + $.trim($("#txtFromDate1").val()) + '",ToDate:"' + $.trim($("#txtToDate1").val()) + '",Status:"' + $("#rblStatus1 input[type='radio']:checked").val() + '",CorpseID:"' + $.trim($("#txtCorpseID").val()) + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        if (result.d != null && result.d != "0") {
                            CorpseResult = $.parseJSON(result.d);
                            //debugger;
                            var HtmlOutput = $("#SearchResult1").parseTemplate(CorpseResult);
                            $("#divSearchedResult1").html(HtmlOutput);
                            $("#divSearchedResult1").show();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                        }
                        else {
                            $("#divSearchedResult1").empty();
                            $("#divSearchedResult1").hide();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                           // DisplayMsg('MM04', 'lblErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        $("#divSearchedResult").empty();
                        $("#divSearchedResult").hide();
                        $("#btnSearch").val("Search");
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                });
            });

        });

        function bindCountry() {
            var ddlCountry = $("#ddlCountry");
            $.ajax({
                url: "../Common/CommonService.asmx/getCountry",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    CountryData = jQuery.parseJSON(result.d);
                    if (CountryData.length == 0) {
                        ddlCountry.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < CountryData.length; i++) {
                            ddlCountry.append($("<option></option>").val(CountryData[i].CountryID).html(CountryData[i].Name));
                        }
                        $("#ddlCountry").val('<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>');
                        //bindCity();
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    ddlCountry.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindCity() {
            var ddlCity = $("#ddlCity");
            var ddlCountry = $("#ddlCountry");
            $("#ddlCity option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/getCity",
                data: '{ districtID: "' + ddlCountry.val() + '"}',
                type: "POST",
                timeout: 120000,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    CityData = jQuery.parseJSON(result.d);
                    if (CityData.length == 0) {
                        ddlCity.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        ddlCity.append($("<option></option>").val('0').html('Select'));
                        for (i = 0; i < CityData.length; i++) {
                            ddlCity.append($("<option></option>").val(CityData[i].City).html(CityData[i].City));
                        }
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    ddlCity.attr("disabled", false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function bindReligion() {
            $("#ddlReligion option").remove();
            $.ajax({
                url: "CorpseDeposite.aspx/getReligion",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    rel = jQuery.parseJSON(result.d);
                    $("#ddlReligion").append($("<option></option>").val("0").html("Select"));
                    if (rel != null) {
                        for (i = 0; i < rel.length; i++) {
                            $("#ddlReligion").append($("<option></option>").val(rel[i].religionId).html(rel[i].ReligionName));
                        }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindLocality() {
            $("#ddlLocality option").remove();
            $.ajax({
                url: "CorpseDeposite.aspx/getLocality",
                data: '{ }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    LocalityData = jQuery.parseJSON(result.d);
                    $("#ddlLocality").append($("<option></option>").val('0').html('Select'));
                    if (LocalityData != null) {
                        for (i = 0; i < LocalityData.length; i++) {
                            $("#ddlLocality").append($("<option></option>").val(LocalityData[i].TalukaID).html(LocalityData[i].Taluka));
                        }
                    }
                   // $('#ddlLocality').chosen();
                },
                error: function (xhr, status) {
                    alert("Error ");
                }
            });
        }
        function bindRelation() {
            $("#ddlRelation option").remove();
            $("#ddlKinRelationShip option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/bindRelation",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    con = jQuery.parseJSON(result.d);
                    $("#ddlRelation,#ddlKinRelationShip").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < con.length; i++) {
                        $("#ddlRelation,#ddlKinRelationShip").append($("<option></option>").val(con[i]).html(con[i]));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindStatus() {
            $("#ddlStatus option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/bindPatientType",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientType = jQuery.parseJSON(result.d);
                    $("#ddlStatus").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < PatientType.length; i++) {
                        $("#ddlStatus").append($("<option></option>").val(PatientType[i].id).html(PatientType[i].PatientType));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindMedicalOfficer() {
            $("#ddlMedicalOfficer option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/bindDoctor",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    doctor = jQuery.parseJSON(result.d);
                    $("#ddlMedicalOfficer").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < doctor.length; i++) {
                        $("#ddlMedicalOfficer").append($("<option></option>").val(doctor[i].DoctorID).html(doctor[i].Name));
                    }
                    $('#ddlMedicalOfficer').chosen();
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindAuthorized() {
            $("#dllAuthorised option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/bindDoctor",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    doctor = jQuery.parseJSON(result.d);
                    $("#dllAuthorised").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < doctor.length; i++) {
                        if (doctor[i].DoctorID == '<%= Session["ID"].ToString() %>') {
                            $("#dllAuthorised").append($("<option value='" + doctor[i].DoctorID + "' Selected></option>"));
                        }
                        else {
                            $("#dllAuthorised").append($("<option value='" + doctor[i].DoctorID + "'></option>").html(doctor[i].Name));
                        }
                    }
                    
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindEmployee() {
            $("#dllAuthorised1 option").remove();
            $.ajax({
                url: "CorpseDeposite.aspx/bindEmployee",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    employee = jQuery.parseJSON(result.d);
                    $("#dllAuthorised1").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < employee.length; i++) {
                        if (employee[i].EmployeeID == '<%= Session["ID"].ToString() %>') {
                            $("#dllAuthorised1").append($("<option value='" + employee[i].EmployeeID + "' Selected>"+employee[i].NAME+"</option>"));
                        }
                        else {
                            $("#dllAuthorised1").append($("<option value='" + employee[i].EmployeeID + "' >" + employee[i].NAME + "</option>"));
                        }
                    }
                    
                },
                error: function (xhr, status) {
                }
            });
        }

        function bindMedicName() {
            $("#dllAuthorised1 option").remove();
            $.ajax({
                url: "CorpseDeposite.aspx/bindEmployee",
                data: '{}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    employee = jQuery.parseJSON(result.d);
                    $("#dllAuthorised").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < employee.length; i++) {
                        if (employee[i].EmployeeID == '<%= Session["ID"].ToString() %>') {
                            $("#dllAuthorised").append($("<option value='" + employee[i].EmployeeID + "' >" + employee[i].NAME + "</option>"));
                        }
                        else {
                            $("#dllAuthorised").append($("<option value='" + employee[i].EmployeeID + "' >" + employee[i].NAME + "</option>"));
                        }
                    }

                },
                error: function (xhr, status) {
                }
            });
        }


        function bindFreezer(Status, Muslim) {
            $("#ddlFreezer option").remove();
            $.ajax({
                url: "Services/Mortuary.asmx/bindFreezerList",
                data: '{Status:"' + Status + '",Muslim:"' + Muslim + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    freezer = jQuery.parseJSON(result.d);
                    $("#ddlFreezer").append($("<option></option>").val("0").html("Select"));
                    for (i = 0; i < freezer.length; i++) {
                        $("#ddlFreezer").append($("<option></option>").val(freezer[i].RackID).html(freezer[i].RackName));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

    </script>
    <script type="text/html" id="Script1">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Deposite Date Time</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">CorpseID</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">DepositeNo</th>               	
			    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Name</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Death Date<br />Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Rack/Shelf</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none;">Death Type</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Infectious Remark</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Admitted By</th>                                    	
		    </tr>
		    <#       
		    var dataLength=CorpseResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {       

                var strStyle="";
		        objRow = CorpseResult[j];

                if(objRow.IsPMRequest=="1"){
                    strStyle="background-color: #FFF59D;";
                    if(objRow.IsSend=="1")
                    {
                        strStyle="background-color: #F48FB1;";
                    }
                    if(objRow.IsPostmortem=="1")
                    {
                        strStyle="background-color: #4DB6AC;";
                    }
                    
                }

                
		    #>
				    <tr style="<#=strStyle#>">            
                        <td class="GridViewLabItemStyle" id="tdDateTime"  style="width:200px;text-align:center;" ><#=objRow.DepositeDateTime#></td>
					    <td class="GridViewLabItemStyle" id="tdCorpseID"  style="width:200px;text-align:center;" ><#=objRow.Corpse_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdDepositeNo" style="width:80px;text-align:center; "><#=objRow.Transaction_ID#></td>    
					    <td class="GridViewLabItemStyle" id="td1" style="width:130px;text-align:left; "><#=objRow.CName#></td>
					    <td class="GridViewLabItemStyle" id="tdAgeGender" style="width:100px;text-align:center;"><#=objRow.Age#>/<#=objRow.Gender#></td>
					    <td class="GridViewLabItemStyle" id="tdDeathDate" style="width:200px;text-align:center"><#=objRow.DateofDeath#>&nbsp; <#=objRow.TimeofDeath#></td>
                        <td class="GridViewLabItemStyle" id="td2" style="width:120px;text-align:center;"><#=objRow.FreezerName#></td>
					    <td class="GridViewLabItemStyle" id="tdDeathType" style="width:120px;text-align:left;display:none;"><#=objRow.DeathType#></td>
					    <td class="GridViewLabItemStyle" id="td3" style="width:120px;text-align:left;"><#=objRow.InfectiousRemark#></td>
					    <td class="GridViewLabItemStyle" id="tdAdmittedBy" style="width:120px;text-align:left;"><#=objRow.AdmittedBy#></td>                                                                  
                    </tr>             
                
		    <#}        
		    #> 
	    </table>    
    </script>

    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }

        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {

                if ($('#CorpseSearchPopUp').length > 0) {
                    $('#CorpseSearchPopUp').animate({ top: -500 }, 500);
                    clearPatientDetail();
                }

                if ($find('mpCity')) {
                    $find('mpCity').hide();
                    $("#txtNewCity").val('');
                }
                if ($find('mpReligion')) {
                    $("#txtReligion").val('');
                    $find('mpReligion').hide();
                }
                if ($find('mpLocality')) {
                    $("#txtLocality").val('');
                    $find('mpLocality').hide();
                }
                if ($find('mpDeposite')) {
                    $find('mpDeposite').hide();
                    cancelDeposite();
                }
                if ($find('mpRelease')) {
                    $find('mpRelease').hide();
                    cancelRelease();
                }
            }
        }

        function saveNewCity() {
            if ($.trim($("#txtNewCity").val()) != "") {
                $.ajax({
                    url: "../Common/CommonService.asmx/CityInsert",
                    data: '{ City: "' + $("#txtNewCity").val() + '", Country: "' + $("#ddlCountry").val() + '",DistrictID:""}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data == "2") {
                            $('#spnErrorMsg').text('City Saved Successfully');
                            $("#ddlCity").append($("<option></option>").val($("#txtNewCity").val()).html($("#txtNewCity").val()));
                            $("#ddlCity").val($("#txtNewCity").val());
                            $("#txtNewCity").val('');
                            $find('mpCity').hide();
                        }
                        else if (Data == "1") {
                            $('#spnErrorMsg').text('City Already Exist');
                            $("#txtNewCity").val('');
                            $find('mpCity').hide();
                        }
                        else {
                            $('#spnErrorMsg').text('City Not Saved');
                            $find('mpCity').hide();
                        }
                    },
                    error: function (xhr, status) {
                        $('#spnErrorMsg').text('Error ');
                        return false;
                    }
                });
            }
            else {
                $('#spnErrorMsg').text("Please Enter City Name");
                $("#txtNewCity").focus();
                $find('mpCity').hide();
            }
        }

        function saveNewLocality() {
            if ($.trim($("#txtLocality").val()) != "") {
                $.ajax({
                    url: "../Common/CommonService.asmx/LocalityInsert",
                    data: '{ Locality: "' + $("#txtLocality").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data == "2") {
                            $('#spnErrorMsg').text('Locality Saved Successfully');
                            $("#ddlLocality").append($("<option></option>").val($("#txtLocality").val()).html($("#txtLocality").val()));
                            $("#ddlLocality").val($("#txtNewCity").val());
                            $("#txtLocality").val('');
                            $find('mpLocality').hide();
                        }
                        else if (Data == "1") {
                            $('#spnErrorMsg').text('Locality Already Exist');
                            $("#txtLocality").val('');
                            $find('mpLocality').hide();
                        }
                        else {
                            $('#spnErrorMsg').text('Locality Not Saved');
                            $find('mpLocality').hide();
                        }
                    },
                    error: function (xhr, status) {
                        return false;
                    }
                });
            }
            else {
                $('#spnLocality').text("Please Enter Locality Name");
                $("#txtLocality").focus();

            }
        }

        function saveNewReligion() {
            if ($.trim($("#txtReligion").val()) != "") {
                $.ajax({
                    url: "../Common/CommonService.asmx/ReligionInsert",
                    data: '{ Religion: "' + $("#txtReligion").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        Data = (result.d);
                        if (Data == "2") {
                            $('#spnErrorMsg').text('Religion Saved Successfully');
                            $("#ddlReligion").append($("<option></option>").val($("#txtReligion").val()).html($("#txtReligion").val()));
                            $("#ddlReligion").val($("#txtReligion").val());
                            $("#txtReligion").val('');
                            $find('mpReligion').hide();
                        }
                        else if (Data == "1") {
                            $('#spnErrorMsg').text('Religion Already Exist');
                            $("#txtReligion").val('');
                            $find('mpReligion').hide();
                        }
                        else {
                            $('#spnErrorMsg').text('Religion Not Saved');
                            $find('mpReligion').hide();
                        }
                    },
                    error: function (xhr, status) {
                        return false;
                    }
                });
            }
            else {
                $('#spnReligion').text("Please Enter Religion Name");
                $("#txtReligion").focus();
            }
        }

        function clearPatientDetail() {
            $('#txtMRNo,#txtIPDNo,#txtFName,#txtLName').val('');
            $('#divSearchedResult').hide();
            $('#divSearchedResult').html('');
            $('#spnErrorMsg,#spnMsg').text("");
            $("#CorpseDetails").css("background-color", "");
        }

        function cancelCity() {
            $("#txtNewCity").val('');
        }

        function cancelReligion() {
            $("#txtReligion").val('');
            $("#spnReligion").text('');
        }

        function cancelLocality() {
            $("#txtLocality").val('');
            $("#spnLocality").text('');
        }

        function closePatientDetail() {
            $('#CorpseSearchPopUp').animate({ top: -500 }, 500);
            clearPatientDetail();
        }

        function closeReligion() {
            $find('mpReligion').hide();
            $("#txtReligion").val('');
            $("#spnReligion").text('');
        }

        function closeCity() {
            $find('mpCity').hide();
            $("#txtNewCity").val('');
        }

        function closeLocality() {
            $find('mpLocality').hide();
            $("#txtLocality").val('');
            $("#spnLocality").text('');
        }

        function closeDeposite() {
            $find('mpDeposite').hide();
            $("#txtBroughtBy").val('');
            $("#txtInRemarks").val('');
        }

        function cancelDeposite() {
            $("#txtBroughtBy").val('');
            $("#txtInRemarks").val('');
        }

        function closeRelease() {
            $find('mpRelease').hide();
            $("#txtRCollected").val('');
            $("#txtRContactNo").val('');
            $("#txtRAddress").val('');
            $("#txtOutRemarks").val('');
        }

        function cancelRelease() {
            $("#txtRCollected").val('');
            $("#txtRContactNo").val('');
            $("#txtRAddress").val('');
            $("#txtOutRemarks").val('');
        }



    </script>

    <script type="text/javascript">

        $(document).ready(function () {
            var MaxLength = 200;
            $('#txtAddress,#txtKinAddress').keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    if (e.keyCode != 8) {
                        e.preventDefault();
                    }
                }
            });

            $("#txtKinContactNo").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            });

            $("#txtAge").keypress(function (e) {

                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
                strLen = $(this).val().length;
                strVal = $(this).val();
                if ((strVal == "0") && (charCode == 48)) {
                    strVal = Number(strVal);
                    $(this).val($(this).val().substring(0, ($(this).val().length - 1)));

                }
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

        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#spnMsg').text('To date can not be less than from date!');
                        $('#btnView').attr('disabled', 'disabled');
                    }
                    else {
                        $('#spnMsg').text('');
                        $('#btnView').removeAttr('disabled');
                    }
                }
            });
        }

        function validateageyrs() {
            var MaxValue = 161;
            $('#txtAge').keyup(function (e) {
                if ($(this).val() >= MaxValue && $('#ddlAge').val() == "YRS") {
                    $("#spnErrorMsg").text('Please Enter Valid Age In YRS');
                    $('#txtAge').val('');
                    $('#txtAge').focus();
                }
                else {
                    $("span[id*=lblMsg]").text('');
                }
            });
        }
        function validatemonth() {
            var MaxValue = 13;
            $('#txtAge').keyup(function (e) {
                if ($(this).val() >= MaxValue && $('#ddlAge').val() == "MONTH(S)") {
                    $("#spnErrorMsg").text('Please Enter Valid Age In Month');
                    $('#txtAge').val('');
                    $('#txtAge').focus();
                }
                else {
                    $("span[id*=lblMsg]").text('');
                }
            });
        }
        function validatedays() {
            var MaxValue = 32;
            $('#txtAge').keyup(function (e) {
                if ($(this).val() >= MaxValue && $('#ddlAge').val() == "DAYS(S)") {
                    $("#spnErrorMsg").text('Please Enter Valid Age In days');
                    $('#txtAge').val('');
                    $('#txtAge').focus();
                }
                else {
                    $("#spnErrorMsg").text('');
                }
            });
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
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                return false;
            else
                return true;
        }

        function validatespacePFirstName() {
            var PFirstname = $('#txtCFirstName').val();
            if (PFirstname.charAt(0) == ' ' || PFirstname.charAt(0) == '.' || PFirstname.charAt(0) == ',' || PFirstname.charAt(0) == '0' || PFirstname.charAt(0) == '-') {
                $('#txtCFirstName').val('');
                $("#spnErrorMsg").text('First Character Cannot Be Space/Dot');
                PFirstname.replace(PFirstname.charAt(0), "");
                return false;
            }
            else {
                $("#spnErrorMsg").text('');
            }
        }
        function validatespacePLastName() {
            var PLastName = $('#txtCLastName').val();
            if (PLastName.charAt(0) == ' ' || PLastName.charAt(0) == '.' || PLastName.charAt(0) == ',' || PLastName.charAt(0) == '0' || PLastName.charAt(0) == '-') {
                $('#txtCLastName').val('');
                $("#spnErrorMsg").text('First Character Cannot Be Space/Dot');
                PLastName.replace(PLastName.charAt(0), "");
                return false;
            }
            else {
                $("#spnErrorMsg").text('');
            }
        }
        function validatespaceKinName() {
            var KinName = $('#txtKinName').val();
            if (KinName.charAt(0) == ' ' || KinName.charAt(0) == '.' || KinName.charAt(0) == ',' || KinName.charAt(0) == '0' || KinName.charAt(0) == '-') {
                $('#txtKinName').val('');
                $("#spnErrorMsg").text('First Character Cannot Be Space/Dot');
                KinName.replace(KinName.charAt(0), "");
                return false;
            }
            else {
                $("#spnErrorMsg").text('');
            }
        }

        function validatespaceBroughtBy() {
            var KinName = $('#txtBroughtby').val();
            if (KinName.charAt(0) == ' ' || KinName.charAt(0) == '.' || KinName.charAt(0) == ',' || KinName.charAt(0) == '0' || KinName.charAt(0) == '-') {
                $('#txtBroughtby').val('');
                $("#spnErrorMsg").text('First Character Cannot Be Space/Dot');
                KinName.replace(KinName.charAt(0), "");
                return false;
            }
            else {
                $("#spnErrorMsg").text('');
            }
        }

    </script>

    <script type="text/javascript">

        $(document).on("keydown", function (e) {
            if ((e.which == 13) && (e.target.id != "txtBarcode")) {
                if ($('#CorpseSearchPopUp').is(':visible'))
                    $("#btnView").click();
                e.preventDefault();
            }
        });

        $(document).ready(function () {
            $('#CorpseSearchPopUp').animate({ top: -500 }, 500);
            $('#btnSearchCorpse').click(function (e) {
                $('#spnErrorMsg,#spnMsg').text("");
                $('#CorpseSearchPopUp').css('left', e.pageX - 830);
                $('#CorpseSearchPopUp').css('left', e.pageY - 30);
                $('#CorpseSearchPopUp').animate({ top: 70 }, 1000);
                $('#CorpseDetails').css({ "background-color": "#ccc" });
                $('#txtMRNo').focus();
                $('#txtBarcode').val("");
                getDate();
            });

            $("#ddlReligion").change(function () {
                var str = $("#ddlReligion option:selected").text().trim();
                if (str.toUpperCase() == "ISLAM" || str.toUpperCase() == "MOSLIM" || str.toUpperCase() == "MOSLEM") {
                    bindFreezer("0", "1");
                }
                else if (str.toUpperCase() == "SELECT" || str.toUpperCase() == "OTHER" || str.toUpperCase() == "NONE") {
                    bindFreezer("0", "0,1");
                }
                else {
                    bindFreezer("0", "0");
                }
            });

            $("#txtBarcode").keypress(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    if ($("#txtBarcode").val() != "") {
                        bindCorpseDetail();
                    }
                }
            });
        });

        function getDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#txtFromDate,#txtToDate').val(data);
                }
            });
        }

        function CorpseSearch() {
            $("#divSearchedResult").empty().hide();
            $("#spnMsg").text("");
            $("#btnView").val("Searching...");
            $("#btnView").attr("disabled", true);
            $.ajax({
                url: "Services/Mortuary.asmx/SerachDeathPerson",
                data: '{MRNo:"' + $.trim($("#txtMRNo").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",FirstName:"' + $.trim($("#txtFName").val()) + '",LastName:"' + $.trim($("#txtLName").val()) + '",FromDate:"' + $.trim($("#txtFromDate").val()) + '",ToDate:"' + $.trim($("#txtToDate").val()) + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    CorpseResult = $.parseJSON(result.d);
                    if (CorpseResult != null && CorpseResult != "") {
                        var HtmlOutput = $("#SearchResult").parseTemplate(CorpseResult);
                        $("#divSearchedResult").html(HtmlOutput);
                        $("#divSearchedResult").show();
                        $("#btnView").val("View");
                        $("#btnView").attr("disabled", false);

                        $('#tablePatient tr').find("#tdSelect").bind('mouseenter mouseleave', function () {
                            $(this).closest('tr').toggleClass('hover');

                        });
                        $('#tablePatientCount td').find("#tdSelect").bind('mouseenter mouseleave', function () {
                            $(this).closest('tr').toggleClass('Counthover');
                        });
                    }
                    else {
                        $("#divSearchedResult").empty().hide();
                        $("#btnView").val("View");
                        $("#btnView").attr("disabled", false);
                        DisplayMsg('MM04', 'spnMsg');
                    }
                },
                error: function (xhr, status) {
                    $("#divSearchedResult").empty().hide();
                    $("#btnView").val("View");
                    DisplayMsg('MM05', 'spnMsg');
                }
            });
        }

        function bindCorpseMasterAndDeposite(ID) {
            $("#txtMasterID").val(ID);
            $.ajax({
                url: "Services/Mortuary.asmx/BindCorpseMasterAndDeposite",
                data: '{ID:"' + ID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    debugger;
                    if (mydata.d != "") {
                        var data = jQuery.parseJSON(mydata.d);
                        $('#txtPatientID').val(data[0]["PatientID"]);
                        $('#txtIPNo').val(data[0]["TransactionID"]);
                        $('#txtPanelID').val(data[0]["PanelID"]);

                        $("#dllAuthorised").val(data[0]["DischargeIntimateBy"]).attr('disabled', true);
                        $('#txtCFirstName').val(data[0]["FirstName"]).prop('readOnly', true);
                        $('#txtCLastName').val(data[0]["LastName"]).prop('readOnly', true);

                        if (data[0]["Gender"] == "Male") {
                            $('#rblGender input[value="Male"]').prop("checked", true);
                            $('#rblGender input[type="radio"]').prop("disabled", true)
                        }
                        else {
                            $('#rblGender input[value="Female"]').prop("checked", true).prop("disabled", true);
                            $('#rblGender input[type="radio"]').prop("disabled", true)
                        }

                        $('#txtAge').val(data[0]["Age"].split(' ')[0]);
                        $('#ddlAge').val(data[0]["Age"].split(' ')[1].trim());
                        if (data[0]["DeathDate"] != null && data[0]["DeathDate"] != "") {
                            $('#txtDateofDeath').val(data[0]["DeathDate1"]).prop('disabled', true);
                        }
                        else {
                            $('#txtDateofDeath').attr('disabled', false);
                        }

                        if (data[0]["DeathTime"] != null && data[0]["DeathTime"] != "") {
                            $('#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime').val(data[0]["DeathTime1"]).prop('disabled', true);
                        }
                        else {
                            $('#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime').prop('readOnly', false);
                        }

                        if (data[0]["Nationality"] != "")
                            $("#ddlNationality").val(data[0]["Nationality"]);
                        else
                            $("#ddlNationality").attr('disabled', false);

                        
                        if (data[0]["Religion"] != "" && data[0]["Religion"] != "0") {
                            $("#ddlReligion").val(data[0]["Religion"]);
                        }
                        else {
                            $("#ddlReligion").attr('disabled', false);
                        }

                        if (data[0]["Locality"] != "")
                            $("#ddlLocality").val(data[0]["Locality"]);
                        else
                            $("#ddlLocality").attr('disabled', false);

                        if (data[0]["Address"] != "") {
                            $('#txtAddress').val(data[0]["Address"]).prop('readOnly', true);
                        }
                        else {
                            $('#txtAddress').prop('readOnly', false);
                        }


                        if (data[0]["OtherAddress"] != "") {
                            $('#txtOtherAddress').val(data[0]["OtherAddress"]);
                        }
                        else {
                            $('#txtOtherAddress').prop('readOnly', false);
                        }

                        if (data[0]["Country"] != "") {
                            $("#ddlCountry").val(data[0]["Country"]).attr('disabled', true);
                        }
                        else {
                            $("#ddlCountry").attr('disabled', false);
                        }

                        if (data[0]["Mobile"] != "") {
                            $("#txtMobile").val(data[0]["Mobile"]).attr('disabled', true);
                        }
                        else {
                            $("#txtMobile").attr('disabled', false);
                        }
                        if (data[0]["City"] != "") {
                            $("#ddlCity").val(data[0]["City"]).attr('disabled', true);
                        }
                        else {
                            $("#ddlCity").attr('disabled', false);
                        }

                        if (data[0]["RelativeName"] != "") {
                            $("#txtKinName").val(data[0]["RelativeName"]);
                        }
                        else {
                            $("#txtKinName").prop('readOnly', false);
                        }

                        if (data[0]["TypeOfRelation"] != "") {
                            $("#ddlKinRelationShip").val(data[0]["TypeOfRelation"]);
                        }
                        else {
                            $("#ddlKinRelationShip").attr('disabled', false);
                        }

                        if (data[0]["RelativeAddress"] != "") {
                            $("#txtKinAddress").val(data[0]["RelativeAddress"]).prop('readOnly', true);
                        }
                        else {
                            $("#txtKinAddress").prop('readOnly', false);
                        }

                        if (data[0]["RelativeContact"] != "") {
                            $("#txtKinContactNo").val(data[0]["RelativeContact"]).prop('readOnly', true);
                        }
                        else {
                            $("#txtKinContactNo").val("").prop('readOnly', false);
                        }

                        if (data[0]["RelativeEmail"] != "")
                            $("#txtKinEmailID").val(data[0]["RelativeEmail"]).prop('readOnly', true);
                        else
                            $("#txtKinEmailID").val("").prop('readOnly', false);

                        if (data[0]["PermitNo"] != "")
                            $("#txtPermitNo").val(data[0]["PermitNo"]).prop('readOnly', false);
                        else
                            $("#txtPermitNo").val("");

                        if (data[0]["NationalID"] != "")
                            $("#txtNationalID").val(data[0]["NationalID"]).prop('readOnly', false);
                        else
                            $("#txtPermitNo").val("");

                        if (data[0]["Remarks"] != "")
                            $("#txtRemarks").val(data[0]["Remarks"]);
                        else
                            $("#txtRemarks").val("");


                        if (data[0]["InfectiousRemark"] != "")
                            $("#txtInfectiousRemark").val(data[0]["InfectiousRemark"]).prop('readOnly', false);
                        else
                            $("#txtInfectiousRemark").val("");

                        if (data[0]["BroughtBy"] != "")
                            $("#txtBroughtby").val(data[0]["BroughtBy"]);
                        else
                            $("#txtBroughtby").val("");


                        if (data[0]["BroughtFrom"] != "")
                            $("#txtBroughtFrom").val(data[0]["BroughtFrom"]);
                        else
                            $("#txtBroughtFrom").val("");

                        //alert(data[0]["FreezerID"]);

                        
                            if (data[0]["PlaceOfDeath"]) {
                                $('#<%=rblPlace.ClientID %>').find("input[value='" + data[0]["PlaceOfDeath"] + "']").prop("checked", true);
                            }


                        $("#txtDoctor").val(data[0]["DoctorID"]).prop('readOnly', true);
                        $("#txtTypeOfDeath").val(data[0]["DeathType"]).prop('readOnly', true);

                        //$("#ddlStatus option:contains(" + data[0].TypeOfPatient + ")").attr("selected", true);
                        var PatientType = data[0].TYPE;
                        $("#ddlStatus option").filter(function () { return this.value == PatientType; }).attr('selected', true);

                        $("#ddlMedicalOfficer").val(data[0].Doctor_ID);
                        //  $("#ddlReligion").trigger("change");
                        //debugger;
                        //alert(data[0]["FreezerID"]);
                         if (data[0]["FreezerID"] != "") {
                            // $("#ddlFreezer").val(data[0]["FreezerID"]);
                            $("#ddlFreezer").find('option').remove();
                            $("#ddlFreezer").append("<option value='" + data[0]["FreezerID"] + "' selected>" + data[0]["Freezer"] + "</option>");

                            $("#ddlFreezer").attr('disabled', true);
                        }
                        else
                            $("#ddlFreezer").attr('disabled', false);

                        $("#btnAdSave").hide();
                        $("#btnupdate").show();

                    }
                }
            });


            $('#CorpseSearchPopUp').animate({ top: -500 }, 500);
            //clearPatientDetail();
        }


        function bindCorpseDetail(rowID) {

            var Already = 0;
            var MRNo = "";
            if ($.trim($("#txtBarcode").val()) == "" && typeof rowID !== "undefined") {
                MRNo = $(rowID).closest('tr').find('#tdMRno').text();
            }
            else if ($.trim($("#txtBarcode").val()) != "") {
                MRNo = $.trim($("#txtBarcode").val());
            }
            else {
                return;
            }

            $.ajax({
                url: "Services/Mortuary.asmx/IsCorpseDeposited",
                data: '{MRNo:"' + MRNo + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        Already = 1;
                    }
                    else {
                        Already = 0;
                    }

                },
                error: function (xhr, status) {
                    Already = 0;
                }
            });

            if (Already == 1) {
                $('#spnErrorMsg,#spnMsg').text('Corpse is Already Deposited');
                return;
            }

            $.ajax({
                url: "Services/Mortuary.asmx/BindCorpseDetails",
                data: '{PatientID:"' + MRNo + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    if (mydata.d != "") {
                        var data = jQuery.parseJSON(mydata.d);
                        $('#txtPatientID').val(data[0]["Patient_ID"]);
                        $('#txtIPNo').val(data[0]["Transaction_ID"]);
                        $('#txtPanelID').val(data[0]["Panel_ID"]);

                        $("#dllAuthorised").val(data[0]["DischargeIntimateBy"]);
                        $('#txtCFirstName').val(data[0]["PFirstName"]).prop('readOnly', true);
                        $('#txtCLastName').val(data[0]["PLastName"]).prop('readOnly', true);

                        if (data[0]["Gender"] == "Male") {
                            $('#rblGender input[value="Male"]').prop("checked", true);
                            $('#rblGender input[type="radio"]').prop("disabled", true)
                        }
                        else {
                            $('#rblGender input[value="Female"]').prop("checked", true).prop("disabled", true);
                            $('#rblGender input[type="radio"]').prop("disabled", true)
                        }

                        $('#txtAge').val(data[0]["Age"].split(' ')[0]);
                        $('#ddlAge').val(data[0]["Age"].split(' ')[1].trim());
                        if (data[0]["DOD"] != null && data[0]["DOD"] != "") {
                            $('#txtDateofDeath').val(data[0]["DOD"]).prop('readOnly', true);
                        }
                        else {
                            $('#txtDateofDeath').attr('disabled', false);
                        }

                        if (data[0]["DOT"] != null && data[0]["DOT"] != "") {
                            $('#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime').val(data[0]["DOT"]).prop('readOnly', true);
                        }
                        else {
                            $('#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime').prop('readOnly', false);
                        }

                        if (data[0]["Ethnicity"] != "")
                            $("#ddlNationality").val(data[0]["Ethnicity"]).attr('disabled', true);
                        else
                            $("#ddlNationality").attr('disabled', false);

                        if (data[0]["ReligiousAffiliation"] != "" && data[0]["ReligiousAffiliation"] != "0") {
                            $("#ddlReligion").val(data[0]["ReligiousAffiliation"]).attr('disabled', true);
                        }
                        else {
                            $("#ddlReligion").attr('disabled', false);
                        }

                        if (data[0]["Locality"] != "")
                            $("#ddlLocality").val(data[0]["Locality"]).attr('disabled', true);
                        else
                            $("#ddlLocality").attr('disabled', false);

                        if (data[0]["House_No"] != "") {
                            $('#txtAddress').val(data[0]["House_No"]).prop('readOnly', true);
                        }
                        else {
                            $('#txtAddress').prop('readOnly', false);
                        }

                        if (data[0]["countryID"] != "") {
                            $("#ddlCountry").val(data[0]["countryID"]).attr('disabled', true);
                        }
                        else {
                            $("#ddlCountry").attr('disabled', false);
                        }

                        if (data[0]["Mobile"] != "") {
                            $("#txtMobile").val(data[0]["Mobile"]).attr('disabled', true);
                        }
                        else {
                            $("#txtMobile").attr('disabled', false);
                        }
                        if (data[0]["City"] != "") {
                            $("#ddlCity").val(data[0]["City"]).attr('disabled', true);
                        }
                        else {
                            $("#ddlCity").attr('disabled', false);
                        }

                        if (data[0]["EmergencyNotify"] != "") {
                            $("#txtKinName").val(data[0]["EmergencyNotify"]).prop('readOnly', true);
                        }
                        else {
                            $("#txtKinName").prop('readOnly', false);
                        }

                        if (data[0]["EmergencyRelationShip"] != "") {
                            $("#ddlKinRelationShip").val(data[0]["EmergencyRelationShip"]).attr('disabled', true);
                        }
                        else {
                            $("#ddlKinRelationShip").attr('disabled', false);
                        }

                        if (data[0]["EmergencyAddress"] != "") {
                            $("#txtKinAddress").val(data[0]["EmergencyAddress"]).prop('readOnly', true);
                        }
                        else {
                            $("#txtKinAddress").prop('readOnly', false);
                        }

                        if (data[0]["EmergencyPhoneNo"] != "") {
                            $("#txtKinContactNo").val(data[0]["EmergencyPhoneNo"]).prop('readOnly', true);
                        }
                        else {
                            $("#txtKinContactNo").val("").prop('readOnly', false);
                        }

                        if (data[0]["EmergencyEmailID"] != "")
                            $("#txtKinEmailID").val(data[0]["EmergencyEmailID"]).prop('readOnly', true);
                        else
                            $("#txtKinEmailID").val("").prop('readOnly', false);

                        $("#txtDoctor").val(data[0]["Doctor_ID"]).prop('readOnly', true);
                        $("#txtTypeOfDeath").val(data[0]["TypeOfDeath"]).prop('readOnly', true);

                        //$("#ddlStatus option:contains(" + data[0].TypeOfPatient + ")").attr("selected", true);
                        var PatientType = data[0].TypeOfPatient;
                        $("#ddlStatus option").filter(function () { return this.text == PatientType; }).attr('selected', true);

                        $("#ddlMedicalOfficer").val(data[0].Doctor_ID);
                        //$("#ddlReligion").trigger("change");

                        //var url = "../../PatientPhoto/" + data[0]["DateEnrolled"].split('-')[2] + "/" + data[0]["DateEnrolled"].split('-')[1] + "/" + data[0]["Patient_ID"].replace("/", "_").replace("/", "_").replace("/", "_") + ".jpg";

                        //$.ajax({
                        //    url: url,
                        //    type: 'HEAD',
                        //    error: function () {
                        //        //if Patient file is not exit
                        //        $("#imgPatient").show().attr("src", "../../Images/no-avatar.gif");
                        //    },
                        //    success: function () {
                        //        //if patient file is exit
                        //        $("#imgPatient").show().attr("src", "../../PatientPhoto/" + data[0]["DateEnrolled"].split('-')[2] + "/" + data[0]["DateEnrolled"].split('-')[1] + "/" + data[0]["Patient_ID"].replace("/", "_").replace("/", "_").replace("/", "_") + ".jpg");
                        //    }
                        //});
                    }
                    else {
                        alert("Wrong UHID");
                    }
                }
            });


            $('#CorpseSearchPopUp').animate({ top: -500 }, 500);
            clearPatientDetail();
        }


        function chkValidationCon() {
            var conVal = 0;
            if ($.trim($('#txtCFirstName').val()).length == 0) {
                $('#spnErrorMsg').text('Please Enter First Name');
                modelAlert('Please Enter First Name', function () { });
                $('#txtCFirstName').focus();
                conVal = 1;
                return false;
            }
            if ($.trim($('#txtCLastName').val()).length == 0) {
                $('#spnErrorMsg').text('Please Enter Last Name');
                modelAlert('Please Enter Last Name', function () { });
                $('#txtCLastName').focus();
                conVal = 1;
                return false;
            }

            if ($('#txtAge').val().length == 0) {
                $('#spnErrorMsg').text('Please Enter Age');
                modelAlert('Please Enter Age', function () { });
                $('#txtAge').focus();
                conVal = 1;
                return false;
            }
            if (parseFloat($.trim($('#txtAge').val())) == 0) {
                $('#spnErrorMsg').text('Please Enter Valid Age');
                modelAlert('Please Enter Valid Age', function () { });
                $('#txtAge').focus();
                conVal = 1;
                return false;
            }

            if ($.trim($('#txtDateofDeath').val()) == "") {
                $('#spnErrorMsg').text('Please Enter Date of Death');
                modelAlert('Please Enter Date of Death', function () { });
                $('#txtDateofDeath').focus();
                conVal = 1;
                return false;
            }

            if ($.trim($("#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime").val()) == "") {
                $('#spnErrorMsg').text('Please Enter Time of Death');
                modelAlert('Please Enter Time of Death', function () { });
                $("#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime").focus();
                conVal = 1;
                return false;
            }

            //if ($('#ddlRelation option:selected').text() != "Select") {
            //    if ($.trim($('#txtRelationName').val()).length == 0) {
            //        $('#spnErrorMsg').text('Please Enter Relation Name');
            //        $('#txtRelationName').focus();
            //        conVal = 1;
            //         return false;
            //     }
            //  }
            //if ($.trim($('#txtHouseTelephoneNo').val()).length == 0) {
            //    $('#spnErrorMsg').text('Please Enter House Telephone No.');
            //    $('#txtHouseTelephoneNo').focus();
            //    return false;
            //}
            //if ($.trim($('#txtHouseTelephoneNo').val()).length < "10") {
            //    $('#spnErrorMsg').text('Please Enter Valid House Telephone No.');
            //    $('#txtHouseTelephoneNo').focus();
            //    conVal = 1;
            //    return false;
            //}
            //if ($.trim($('#txtOfficeTelephoneNo').val()).length == 0) {
            //    $('#spnErrorMsg').text('Please Enter Office Telephone No.');
            //    $('#txtOfficeTelephoneNo').focus();
            //    return false;
            // }
            //if ($.trim($('#txtOfficeTelephoneNo').val()).length < "10") {
            //    $('#spnErrorMsg').text('Please Enter Valid Office Telephone No.');
            //    $('#txtOfficeTelephoneNo').focus();
            //    conVal = 1;
            //    return false;
            //}
            if ($.trim($('#txtAddress').val()).length == 0) {
                $('#spnErrorMsg').text('Please Enter Address');
                modelAlert('Please Enter Address', function () { });
                $('#txtAddress').focus();
                conVal = 1;
                return false;
            }
            //if ($.trim($('#txtPlaceOfWork').val()).length == 0) {
            //    $('#spnErrorMsg').text('Please Enter Place Of Work');
            //    $('#txtPlaceOfWork').focus();
            //    return false;
            //}       
            if ($('#ddlCountry option:selected').text() == "") {
                $('#spnErrorMsg').text('Please Select  Country');
                modelAlert('Please Select  Country', function () { });
                $('#ddlCountry').focus();
                conVal = 1;
                return false;
            }
            //if ($('#ddlCity option:selected').text() == "---No Data Found---") {
            //    $('#spnErrorMsg').text('Please Select  City');
            //    $('#ddlCity').focus();
            //    conVal = 1;
            //    return false;
            //}
            //if ($('#ddlCity option:selected').text() == "Select") {
            //    $('#spnErrorMsg').text('Please Select City');
            //    $('#ddlCity').focus();
            //    conVal = 1;
            //    return false;
            //}
            //if ($('#ddlCity option:selected').text() == "") {
            //    $('#spnErrorMsg').text('Please Select  City');
            //    $('#ddlCity').focus();
            //    conVal = 1;
            //    return false;
            //}
            /*if ($.trim($('#txtKinName').val()).length == 0) {
                $('#spnErrorMsg').text('Please Enter Kin Name');
                modelAlert('Please Enter Kin Name', function () { });
                $('#txtKinName').focus();
                conVal = 1;
                return false;
            }
            if ($('#ddlKinRelationShip option:selected').text() == "Select") {
                $('#spnErrorMsg').text('Please Select Kin RelationShip');
                modelAlert('Please Select Kin RelationShip', function () { });
                $('#ddlKinRelationShip').focus();
                conVal = 1;
                return false;
            }

            if ($.trim($('#txtKinAddress').val()).length == 0) {
                $('#spnErrorMsg').text('Please Enter Kin Address');
                modelAlert('Please Enter Kin Address', function () { });
                $('#txtKinAddress').focus();
                conVal = 1;
                return false;
            }
            if ($.trim($('#txtKinContactNo').val()).length == 0) {
                $('#spnErrorMsg').text('Please Enter Kin Contact No.');
                modelAlert('Please Enter Kin Contact No.', function () { });
                $('#txtKinContactNo').focus();
                conVal = 1;
                return false;
            }
            if (($.trim($('#txtKinContactNo').val()) != "") && ($.trim($('#txtKinContactNo').val()).length < "10")) {
                $('#spnErrorMsg').text('Please Enter Valid Kin Contact No.');
                modelAlert('Please Enter Valid Kin Contact No.', function () { });
                $('#txtKinContactNo').focus();
                conVal = 1;
                return false;
            }*/
            var KinEmailaddress = $.trim($('#txtKinEmailID').val());
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(KinEmailaddress) == false) && (KinEmailaddress != "")) {
                $('#spnErrorMsg').text('Please Enter Valid Kin Email Address');
                modelAlert('Please Enter Valid Kin Email Address', function () { });
                $('#txtKinEmailID').focus();
                conVal = 1;
                return false;
            }

            if ($("#ddlStatus").val() == "0") {
                $('#spnErrorMsg').text('Please Select Status');
                modelAlert('Please Select Status', function () { });
                $('#ddlStatus').focus();
                conVal = 1;
                return false;
            }

            if ($("#ddlFreezer").val() == "0") {
                $('#spnErrorMsg').text('Please Select Freezer');
                modelAlert('Please Select Freezer', function () { });
                $('#ddlFreezer').focus();
                conVal = 1;
                return false;
            }

            if ($.trim($("#txtBroughtby").val()) == "") {
                $('#spnErrorMsg').text('Please Enter Brought By');
                modelAlert('Please Select Brought By', function () { });
                $('#txtBroughtby').focus();
                conVal = 1;
                return false;
            }

            if ($("#ddlMedicalOfficer").val() == "0") {
                $('#spnErrorMsg').text('Please Select Medical Officer');
                modelAlert('Please Select Medical Officer', function () { });
                $('#ddlMedicalOfficer').focus();
                conVal = 1;
                return false;
            }

            if ($("#dllAuthorised").val() == "0") {
                $('#spnErrorMsg').text('Please Select Authorised Doctor');
                modelAlert('Please Select Authorised Doctor', function () { });
                $('#dllAuthorised').focus();
                conVal = 1;
                return false;
            }

            return true;
        }

        function UpdateCorpseDeposite() {

            $("#btnupdate").val("Submitting...");
            $("#btnupdate").attr("disabled", true);
            $('#spnErrorMsg').text("");

            if (chkValidationCon() == true) {

                var resultCorpseMaster = getCorpseMaster();
                var resultCorpseDeposite = getCorpseDeposite();
                $("#btnupdate").val("Submitting...");
                $("#btnupdate").attr("disabled", true);
                $.ajax({
                    url: "Services/Mortuary.asmx/UpdateCorpseDetails",
                    data: JSON.stringify({ CorpseMaster: resultCorpseMaster, CorpseDeposite: resultCorpseDeposite }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            ClearControl();
                            //bindFreezer("0", "0,1");
                            DisplayMsg('MM01', 'spnErrorMsg');
                            //window.open('../common/Commonreport.aspx');\\
                            $("#btnAdSave").show();
                            $("#btnupdate").hide();
                        }
                        else {
                            DisplayMsg('MM05', 'spnErrorMsg');
                            $("#btnAdSave").val("Save");
                            $("#btnAdSave").attr("disabled", false);
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'spnErrorMsg');
                        $("#btnAdSave").show();
                        $("#btnupdate").hide();
                    }

                });
            }
            else {

                $("#btnAdSave").val("Save");
                $("#btnAdSave").attr("disabled", false);
            }
        }


        function SaveCorpseDeposite() {

            $("#btnAdSave").val("Submitting...");
            $("#btnAdSave").attr("disabled", true);
            $('#spnErrorMsg').text("");

            if (chkValidationCon() == true) {

                var resultCorpseMaster = getCorpseMaster();
                var resultCorpseDeposite = getCorpseDeposite();
                $("#btnAdSave").val("Submitting...");
                $("#btnAdSave").attr("disabled", true);
                $.ajax({
                    url: "Services/Mortuary.asmx/SaveCorpseDetails",
                    data: JSON.stringify({ CorpseMaster: resultCorpseMaster, CorpseDeposite: resultCorpseDeposite }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: "120000",
                    dataType: "json",
                    success: function (result) {
                        if (result.d != "0") {
                            ClearControl();
                            bindFreezer("0", "0,1");
                            DisplayMsg('MM01', 'spnErrorMsg');
                            window.open('../common/Commonreport.aspx');
                            $("#btnAdSave").val("Save");
                            $("#btnAdSave").attr("disabled", false);
                        }
                        else {
                            DisplayMsg('MM05', 'spnErrorMsg');
                            $("#btnAdSave").val("Save");
                            $("#btnAdSave").attr("disabled", false);
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'spnErrorMsg');
                        $("#btnAdSave").val("Save");
                        $("#btnAdSave").attr("disabled", false);
                    }

                });
            }
            else {

                $("#btnAdSave").val("Save");
                $("#btnAdSave").attr("disabled", false);
            }
        }

        function getCorpseMaster() {
            var dataArray = new Array();
            var dataObj = new Object();

            dataObj.ID = '0';
            if ($("#txtMasterID").val() != "") {
                dataObj.ID = $("#txtMasterID").val();
            }
            dataObj.Patient_ID = $("#txtPatientID").val();
            dataObj.Transaction_ID = $("#txtIPNo").val();
            dataObj.FirstName = $("#txtCFirstName").val();
            dataObj.LastName = $("#txtCLastName").val();
            dataObj.CName = $("#txtCFirstName").val() + " " + $("#txtCLastName").val();
            dataObj.Age = $("#txtAge").val() + " " + $("#ddlAge").val();
            dataObj.Gender = $("#rblGender input[type='radio']:checked").val();
            dataObj.DeathDate = $("#txtDateofDeath").val();
            dataObj.DeathTime = $("#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime").val();
            dataObj.DeathType = $("#txtTypeOfDeath").val();
            if ($("#ddlNationality").val() != "0")
                dataObj.Nationality = $("#ddlNationality").val();

            if ($("#ddlReligion").val() != "0")
                dataObj.Religion = $("#ddlReligion").val();

            if ($("#ddlLocality").val() != "0")
                dataObj.Locality = $("#ddlLocality").val();

            dataObj.Address = $("#txtAddress").val();

            if ($("#ddlCity").val() != "0")
                dataObj.City = $("#ddlCity").val();

            if ($("#ddlCountry").val() != "0")
                dataObj.Country = $("#ddlCountry").val();

            dataObj.OtherAddress = $("#txtOtherAddress").val();
            dataObj.PermitNo = $("#txtPermitNo").val();
            dataObj.Mobile = $("#txtMobile").val();
            dataObj.NationalID = $("#txtNationalID").val();
            dataObj.InfectiousRemark = $("#txtInfectiousRemark").val();

            if ($("#ddlStatus").val() != "0")
                dataObj.Type = $("#ddlStatus").val();

            dataObj.PlaceOfDeath = $("#rblPlace input[type='radio']:checked").val();
            dataObj.HospitalName = "";

            if ($("#ddlKinRelationShip").val() != "0")
                dataObj.TypeOfRelation = $("#ddlKinRelationShip").val();

            dataObj.RelativeName = $("#txtKinName").val();
            dataObj.RelativeAddress = $("#txtKinAddress").val();
            dataObj.RelativeContact = $("#txtKinContactNo").val();
            dataObj.RelativeEmail = $("#txtKinEmailID").val();

            dataArray.push(dataObj);

            return dataArray;
        }

        function getCorpseDeposite() {
            var dataArray = new Array();
            var dataObj = new Object();

            if ($("#ddlMedicalOfficer").val() != "0") {
                //dataObj.DoctorID = $("#ddlMedicalOfficer").val();
                dataObj.DoctorID = $("#dllAuthorised").val();
            }

            dataObj.Remarks = $("#txtRemarks").val();
            if ($("#dllAuthorised").val() != "0")
                dataObj.AuthDoctor = $("#dllAuthorised").val();

            if ($("#ddlFreezer").val() != "0")
                dataObj.FreezerID = $("#ddlFreezer").val();

            if ($("#txtPanelID").val().trim() != "")
                dataObj.Panel_ID = $("#txtPanelID").val();
            else
                dataObj.Panel_ID = "1";

            dataObj.BroughtBy = $("#txtBroughtby").val();
            dataObj.BroughtFrom = $("#txtBroughtFrom").val();
            dataArray.push(dataObj);

            return dataArray;
        }


        function saveCorpseDeposite() {
            if ($.trim($("#txtBroughtBy").val()) == "") {
                $("#spnDepositeError").text("Please Enter Brought By");
                $("#txtBroughtBy").focus();
                return;
            }

            $.ajax({
                url: "Services/Mortuary.asmx/saveCorpseDeposite",
                data: '{MRNo:"' + $("#spnDMRNO").text() + '",IPDNo:"' + $("#spnDIPDNO").text() + '",BroughtBy:"' + $.trim($("#txtBroughtBy").val()) + '",Remarks:"' + $.trim($("#txtInRemarks").val()) + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    if (result.d != "0") {
                        DisplayMsg('MM01', 'spnErrorMsg');
                        closeDeposite();

                    }
                    else {
                        DisplayMsg('MM05', 'spnErrorMsg');
                        closeDeposite();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'spnErrorMsg');
                }

            });



        }


        function ClearControl() {
            $("#txtBarcode,#txtPatientID,#txtIPNo,#txtPanelID,#txtDoctor,#txtTypeOfDeath,#txtCFirstName,#txtCLastName,#txtAge,#txtAddress,#txtOtherAddress,#txtKinName,#txtKinAddress,#txtKinContactNo,#txtKinEmailID,#txtBroughtby,#txtRemarks,#txtPermitNo,#txtNationalID,#txtInfectiousRemark").val("");
            $("#ddlNationality,#ddlReligion,#ddlLocality,#ddlKinRelationShip,#ddlStatus,#ddlFreezer,#ddlMedicalOfficer,#dllAuthorised,#ddlCity").val("0");
            $("#ddlCountry").val('1');
            $("#rblGender input[value='Male']").attr("checked", true);
            $("#ddlAge").val("YRS");
            $("#rblPlace input[value='Hospital']").attr("checked", true);
            $("#ddlFreezer option").not("option:first").remove();
            $("#btnAdSave").val("Save");
            $("#btnAdSave").attr("disabled", false);
        }

        function DisableControls() {
            $("#txtPatientID,#txtIPNo,#txtDoctor,#txtTypeOfDeath,#txtCFirstName,#txtCLastName,#txtAge,#txtAddress,#txtOtherAddress,#txtKinName,#txtKinAddress,#txtKinContactNo,#txtKinEmailID,#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime").attr("readonly", true);
            $("#ddlNationality,#ddlReligion,#ddlLocality,#ddlKinRelationShip,#ddlCity,#ddlAge").attr("disabled", true);
            $("#rblGender input[type='radio']").attr("disabled", true);
            $("#btnNewLocality,#btnNewReligion,#btnNewCity").attr("disabled", true);
        }

        function EnableControls() {
            $("#txtBarcode,#txtPatientID,#txtIPNo,#txtDoctor,#txtTypeOfDeath,#txtCFirstName,#txtCLastName,#txtAge,#txtAddress,#txtOtherAddress,#txtKinName,#txtKinAddress,#txtKinContactNo,#txtKinEmailID,#txtBroughtby,#txtRemarks,#ctl00_ContentPlaceHolder1_ucTimeofDeath_txtTime").attr("readonly", false);
            $("#ddlNationality,#ddlReligion,#ddlLocality,#ddlKinRelationShip,#ddlStatus,#ddlFreezer,#ddlMedicalOfficer,#dllAuthorised,#ddlCity,#ddlAge").attr("disabled", false);
            $("#rblGender input[type='radio']").attr("disabled", false);
            $("#rblPlace input[type='radio']").attr("disabled", false);
            $("#btnNewLocality,#btnNewReligion,#btnNewCity").attr("disabled", false);
        }
    </script>
    <div id="CorpseDetails">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="sc1" runat="server"></asp:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <b><span id="lblHeader" style="font-weight: bold;">Corpse Deposite</span></b><br />
                <span id="spnErrorMsg" class="ItDoseLblError" style="display:none;"></span>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="Purchaseheader">
                    Corpse Details
                </div>
                 <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 <strong>Barcode Search </strong>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtBarcode" maxlength="20" tabindex="0" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtCFirstName" class="requiredField" style="" maxlength="50" tabindex="2" title="Enter First Name" onkeypress="return check(this,event)" onkeyup="validatespacePFirstName();" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Last Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <input type="text" id="txtCLastName" class="requiredField" maxlength="50" tabindex="3" title="Enter Last Name" onkeypress="return check(this,event)" onkeyup="validatespacePLastName();" />
                        </div>
                    </div>
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtPatientID" readonly="readonly" tabindex="1" />
                                        <input type="text" id="txtIPNo" style="display: none;" />
                                        <input type="text" id="txtDoctor" style="display: none;" />
                                        <input type="text" id="txtTypeOfDeath" style="display: none;" />
                                        <input type="text" id="txtPanelID"  style="display: none;" />
                            <div style="text-align: left;display:none;" id="td_staffType" >
                                        <input id="btnSearchCorpse" class="ItDoseButton" type="button"
                                            value="Search Corpse" style="display: <%=GetGlobalResourceObject("Resource", "OldPatientLink") %>" />
                                    </div>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sex
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rblGender" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" TabIndex="4">
                                <asp:ListItem Selected="True">Male</asp:ListItem>
                                <asp:ListItem>Female</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Age
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtAge" maxlength="4" title="Enter Age" tabindex="5" style="width: 60px" />
                            <span style="color: red; font-size: 10px; display: none" id="spnAge">*</span>
                            <select id="ddlAge" tabindex="6" style="width: 159px" name="D5">
                                <option value="YRS">YRS</option>
                                <option value="MONTH(S)">MONTH(S)</option>
                                <option value="DAYS(S)">DAYS(S)</option>
                            </select>
                        </div>
                    </div>
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date Of Death
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtDateofDeath" runat="server" class="requiredField" ClientIDMode="Static" ToolTip="Clieck to Select Date of Death" TabIndex="7" />
                            <span style="color: red; font-size: 10px;"></span>
                            <cc1:CalendarExtender ID="calDateofDeath" runat="server" TargetControlID="txtDateofDeath" Format="dd-MMM-yyyy" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Time Of Death
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="text-align:left;">                            
                             <uc1:Time runat="server" ID="ucTimeofDeath" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Nationality
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <select id="ddlNationality" title="Select Nationality" style="" tabindex="8">
                                <option value="0" selected="selected">Select</option>
                                <option>Kenyan</option>
                                <option>Non-Kenyan</option>
                            </select>
                        </div>
                    </div>
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Religion
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlReligion" title="Select Religion" tabindex="9" ></select>
                            &nbsp;&nbsp;<asp:Button ID="btnNewReligion" CssClass="ItDoseButton" runat="server" ClientIDMode="Static" Text="New" Visible="false" ToolTip="Click to Create New Religion" />
                            <cc1:ModalPopupExtender ID="mpReligion" runat="server" BackgroundCssClass="filterPupupBackground"
                                CancelControlID="btnReligionCancel" DropShadow="true" PopupControlID="pnlReligion"
                                TargetControlID="btnNewReligion" OnCancelScript="cancelReligion()" BehaviorID="mpReligion">
                            </cc1:ModalPopupExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Locality
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlLocality" title="Select Locality"  tabindex="10"></select>&nbsp;
                            <asp:Button ID="btnNewLocality" Visible="false" CssClass="ItDoseButton" runat="server" ClientIDMode="Static" Text="New" ToolTip="Click to Create New Locality" />
                            <cc1:ModalPopupExtender ID="btnNewLocality_ModalPopupExtender" runat="server" BackgroundCssClass="filterPupupBackground"
                                CancelControlID="btnLocalityCancel" DropShadow="true" PopupControlID="pnlLocality"
                                TargetControlID="btnNewLocality" OnCancelScript="cancelLocality()" BehaviorID="mpLocality">
                            </cc1:ModalPopupExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Residential Add.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <textarea id="txtAddress" cols="" rows="" class="requiredField"  tabindex="11" title="Enter Address"></textarea>
                        </div>
                    </div>
                       <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Other Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <input type="text" tabindex="12" id="txtOtherAddress"  maxlength="200" title="Enter Business/Employer/school Address" /><input type="text" id="txtPlaceOfWork" style="display: none;" maxlength="50" tabindex="11" title="Enter Place Of Work" />
                            <span style="color: red; font-size: 10px; display: none;">*</span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Country
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlCountry" tabindex="13" style="" class="requiredField" title="Select Country" onchange="bindCity()" name="D2"></select>
                            <span style="color: red; font-size: 10px;"></span>
                        </div>
                            <div class="col-md-3">
			           <label class="pull-left">  Mobile No. </label>
			           <b class="pull-right">:</b>
		           </div>
		           <div class="col-md-5">
			           <input id="txtMobile" type="text"   allowcharscode="45"  allowFirstZero   data-title="Enter Contact No. (Press Enter To Search)" onlynumber="10"    autocomplete="off"  />              
                      
		           </div>
                  
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Permit Number
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <input type="text" tabindex="12" id="txtPermitNo"  maxlength="200" title="Enter Permit No" />
                            <span style="color: red; font-size: 10px; display: none;">*</span>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                National ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <input type="text" tabindex="12" id="txtNationalID"  maxlength="200" title="Enter National ID" />
                            <span style="color: red; font-size: 10px; display: none;">*</span>
                        </div>
                        
                        </div>
                </div>
                <div class="col-md-1"></div>
            </div>
                <table border="0" style="width: 100%; border-collapse: collapse;">
                    <tr>
                        <td style="width: 35%; text-align: left; vertical-align: top;" rowspan="6">
                            <input type="image" id="imgPatient" src="" style="border-style: double;display:none "/>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td style="text-align: right; vertical-align: top; width: 16%">City :&nbsp;</td>
                        <td style="text-align: left; width: 34%; vertical-align: top" colspan="2">
                            <select id="ddlCity" tabindex="14" style="width: 220px" title="Select City" name="D1"></select>&nbsp;<span style="color: red; font-size: 10px;">*</span><asp:Button ID="btnNewCity" CssClass="ItDoseButton" runat="server" ClientIDMode="Static" Text="New" ToolTip="Click to Create New City" />
                            <cc1:ModalPopupExtender ID="mpCity" runat="server" BackgroundCssClass="filterPupupBackground"
                                CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlCity"
                                TargetControlID="btnNewCity" OnCancelScript="cancelCity()" BehaviorID="mpCity">
                            </cc1:ModalPopupExtender>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Kin Details
                </div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtKinName" tabindex="19"  onpaste="return false" autocomplete="off" maxlength="100" title="Enter Kin Name" onkeyup="validatespaceKinName();" onkeypress="return check(this,event)" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Relationship
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlKinRelationShip" tabindex="20"   title="Select Relationship"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <textarea  id="txtKinAddress"  tabindex="21" title="Enter Address"></textarea>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Contact No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <input type="text" id="txtKinContactNo" tabindex="22"  maxlength="15" title="Enter Kin Contact No." />
                            <span style="color: red; font-size: 10px;"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Email Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtKinEmailID" maxlength="50" tabindex="23" title="Enter Kin Email Address" />
                        </div>
                    </div>
                <div class="col-md-1"></div>
            </div>
            </div>
                </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Other Details
                </div>
                   <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Place of Death
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="rblPlace" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" TabIndex="24">
                                <asp:ListItem Selected="True">Hospital</asp:ListItem>
                                <asp:ListItem>Ex-Hospital</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlStatus" tabindex="25" class="requiredField" title="Select Status"></select>
                            <span style="color: red; font-size: 10px;"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Freezer
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlFreezer" tabindex="26" class="requiredField" style="" title="Select Freezer"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Brought By
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <input type="text" id="txtBroughtby" class="requiredField" title="Enter Brought By" tabindex="27" onkeypress="return check(this,event)" onkeyup="validatespaceBroughtBy();" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Brought From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <input type="text" id="txtBroughtFrom" class="" title="Enter Brought From" tabindex="27" onkeypress="return check(this,event)" onkeyup="validatespaceBroughtBy();" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Medic Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <select id="dllAuthorised" tabindex="29" class="requiredField" style="" title="Select Status"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Received By
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <select id="dllAuthorised1" tabindex="29" class="requiredField" style="" title="Select Status"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Deposite Remarks
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtRemarks" style="" tabindex="30" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Infectious Remark
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <input type="text" tabindex="12" id="txtInfectiousRemark"  maxlength="200" title="Enter Infectious Remark" />
                            <span style="color: red; font-size: 10px; display: none;">*</span>
                        </div>
                    
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <input type="hidden" id="txtMasterID" />
                <input type="button" id="btnAdSave" class="ItDoseButton" value="Save" onclick="SaveCorpseDeposite();" tabindex="31" />
                <input type="button" id="btnupdate" class="ItDoseButton" value="Update" onclick="UpdateCorpseDeposite();" style="display: none" />
            </div>
            
            <div class="POuter_Box_Inventory" style="text-align: center">
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                From Deposite Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtFromDate1" runat="server" ClientIDMode="Static" title="Click to Select From Date" Width="" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="calFromdate" runat="server" TargetControlID="txtFromDate1" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                To Deposite Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtToDate1" runat="server" ClientIDMode="Static" title="Select To Date" Width="" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="calTodate" runat="server" TargetControlID="txtToDate1" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                         
                         </div>
                    
                     <div class="row">
                         <div class="col-md-4">
                            <label class="pull-left">
                                Corpse ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                          <div class="col-md-5">
                              <asp:TextBox ID="txtCorpseID" runat="server" ClientIDMode="Static" title="Enter CorpseID " Width="" />
                              
                        </div>
                   
                         <div class="col-md-4"></div>
                        <div class="col-md-1" style="text-align:center;">
         <input type="button" id="btnSearch" value="Search" class="ItDoseButton" />
                            </div>
        </div>
                    </div>
                  </div>
                </div>
            
        <div class="POuter_Box_Inventory" style="text-align: center; max-height: 430px; overflow: auto;">
            <div id="divSearchedResult1" style="width:100%;">
            </div>
        </div>
    </div>
    <asp:Panel ID="pnlCity" runat="server" CssClass="pnlItemsFilter" Style="display: none" Width="344px">
        <div id="Div2" class="Purchaseheader" runat="server">
            Create New City&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <em><span style="font-size: 7.5pt">Press esc or click
            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeCity()" />
                to close</span></em>
        </div>
        <table style="width: 100%">
            <tr>
                <td style="text-align: right">&nbsp;City :&nbsp;
                </td>
                <td>
                    <input type="text" id="txtNewCity" maxlength="20" title="Enter City" />
                    <span style="color: red; font-size: 10px;">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveNewCity();" value="Save" class="ItDoseButton" id="btnSaveCity" title="Click To Save" />&nbsp;
                    <asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>

    <asp:Panel ID="pnlReligion" runat="server" CssClass="pnlItemsFilter" Style="display: none" Width="376px">
        <div id="Div3" class="Purchaseheader" runat="server">
            Create New Religion&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <em><span style="font-size: 7.5pt">Press esc or click
            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeReligion()" />
                to close</span></em>
        </div>
        <table style="width: 100%">
            <tr>
                <td style="text-align: center" colspan="2">
                    <span id="spnReligion" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">&nbsp;Religion :&nbsp;
                </td>
                <td>
                    <input type="text" id="txtReligion" class="requiredField" maxlength="20"  title="Enter Religion" />
                    <span style="color: red; font-size: 10px;"></span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveNewReligion();" value="Save" class="ItDoseButton" id="btnReligion" title="Click To Save" />&nbsp;
                    <asp:Button ID="btnReligionCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <asp:Panel ID="pnlLocality" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="396px">
        <div id="Div5" class="Purchaseheader" runat="server">
            Create New Locality&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
              <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeLocality()" />
                  to close</span></em>
        </div>
        <table style="width: 100%">
            <tr>
                <td style="text-align: center" colspan="2">
                    <span id="Span1" class="ItDoseLblError"></span>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">&nbsp;Locality :&nbsp;
                </td>
                <td>
                    <input type="text" id="txtLocality" class="requiredField" maxlength="20" title="Enter Locality" />
                    <span style="color: red; font-size: 10px;"></span>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveNewLocality();" value="Save" class="ItDoseButton" id="btnLocality" title="Click To Save" />&nbsp;
                    <asp:Button ID="btnLocalityCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>

    <!--Popup for corpse searching-->
    <div id="CorpseSearchPopUp" style="position: absolute; top: -500px; border-collapse: collapse; overflow-x: hidden; overflow-y: hidden">
        <div id="Div1" style="width: 890px; height: 410px" class="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="width: 886px; text-align: center;">
                <div class="Purchaseheader" style="text-align: right">
                    &nbsp;
                    <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePatientDetail()" />
                        to close</span></em>
                </div>
                <table style="width: 100%; text-align: center">
                    <tr>
                        <td style="text-align: center">
                            <b>Search Corpse Details</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <span id="spnMsg" class="ItDoseLblError"></span>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <table style="width: 100%; border-collapse: collapse">
                    <tr style="font-size: 10pt">
                        <td style="width: 20%; text-align: right">UHID :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtMRNo" title="Enter UHID" maxlength="20" />
                        </td>
                        <td style="width: 20%; text-align: right">IPD No :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtIPDNo" title="Enter Staff ID/No." maxlength="20" />
                        </td>
                    </tr>
                    <tr style="font-size: 10pt">
                        <td style="width: 20%; text-align: right;">First Name :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtFName" title="Enter First Name" maxlength="20" />
                        </td>
                        <td style="width: 20%; text-align: right">Last Name :&nbsp;</td>
                        <td style="width: 30%; text-align: left;">
                            <input type="text" id="txtLName" title="Enter Last Name" maxlength="20" />
                        </td>
                    </tr>
                    <tr style="font-size: 10pt">
                        <td style="width: 20%; text-align: right">From Death Date :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date" Width="149px" ClientIDMode="Static" onChange="ChkDate();"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 20%; text-align: right">To Death Date :&nbsp;
                        </td>
                        <td style="width: 30%; text-align: left;">
                            <asp:TextBox ID="txtToDate" runat="server" Width="149px" ClientIDMode="Static" ToolTip="Click To Select To Date"  onChange="ChkDate();"></asp:TextBox>
                            <cc1:CalendarExtender ID="fc2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr  style="font-size: 10pt">
                        <td style="text-align:center;" colspan="4">
                            <asp:RadioButtonList ID="rblStatus" runat="server" ClientIDMode="Static" RepeatDirection="Horizontal" style="margin:0 auto;">
                                <asp:ListItem value="0" Text="Allocate Freezer" />
                                <asp:ListItem value="1" Text="Not Allocate Freezer" />
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 100%;">
                <input type="button" id="btnView" value="View" class="ItDoseButton" title="Click to View" onclick="CorpseSearch();" />
            </div>
            <div class="POuter_Box_Inventory" style="width: 886px;">
                <div class="Purchaseheader">
                    Corpse Detail
                </div>
                <div id="divSearchedResult" style="max-height: 236px; overflow-x: auto;">
                </div>
            </div>
        </div>
    </div>
    <!--Popup for corpse searching-->

    <!--Popup for corpse deposite-->
    <asp:Button ID="btnHideDeposite" runat="server" style="display:none;"></asp:Button>
    <cc1:ModalPopupExtender ID="mpDeposite" BehaviorID="mpDeposite" runat="server" DropShadow="true" TargetControlID="btnHideDeposite" 
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlDeposite" CancelControlID="btnDepositeCancel" OnCancelScript="cancelDeposite();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlDeposite" runat="server" style="display:none;">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:700px;">
            <div class="Purchaseheader">
                <table width="690">
                    <tr>
                        <td style="text-align:left;">
                            <b>Deposite Corpse</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor:pointer" onclick="closeDeposite()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:697px;text-align:center;">
                <b><span id="spnDepositeError" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;" id="Table1">
                    <tr>
                        <td style="text-align:right;width:200px;">Patient No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnDMRNO"></span></td>
                        <td style="text-align:right;width:200px;">IPD No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnDIPDNO"></span></td>
                    </tr>                       
                    <tr>
                        <td style="text-align:right;width:200px;">Name&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnDName"></span></td>
                        <td style="text-align:right;width:200px;">Death Date & Time&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnDDeathDate"></span></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                    </tr>                   
                </table>   
            </div>
            <div class="POuter_Box_Inventory" style="width:697px;">                 
                <table  style="border-collapse:collapse;width:100%;">
                    <tr>
                        <td style="text-align:right;width:25%;">Brought By&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:75%;">
                            <input type="text" class="requiredField" id="txtBroughtBy" title="Enter Brought By" style="width:200px"/>
                        </td>
                    </tr>                                              
                    <tr>
                        <td style="text-align:right;width:25%;">In Remarks&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:75%;">
                            <textarea id="txtInRemarks" style="width:300px;height:50px;resize:none;" title="Enter In Remarks"></textarea>         
                        </td>                        
                    </tr>                              
                    <tr>
                        <td style="text-align:right">&nbsp;</td>
                        <td style="text-align:left">&nbsp;</td>                        
                    </tr>
                </table> 
                </div>  
            <div class="POuter_Box_Inventory" style="text-align:center;width:697px;">
                <input type="button" id="btnDeposite" value="Deposite" onclick="UpdateMedicine();" class="ItDoseButton"/>
                <asp:Button ID="btnDepositeCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
            </div>         
        </div>        
    </asp:Panel> 
    <!--Popup for corpse deposite-->   
    

    <!--Popup for corpse release-->
    <asp:Button ID="btnHideRelease" runat="server" style="display:none;"></asp:Button>
    <cc1:ModalPopupExtender ID="mpRelease" BehaviorID="mpRelease" runat="server" DropShadow="true" TargetControlID="btnHideRelease" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlRelease" CancelControlID="btnReleaseCancel" OnCancelScript="cancelRelease();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlRelease" runat="server" style="display:none;">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:700px;">
            <div class="Purchaseheader">
                <table width="690">
                    <tr>
                        <td style="text-align:left;">
                            <b>Released Corpse</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor:pointer" onclick="closeTypeOfApp()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:697px;text-align:center;">
                <b><span id="spnReleaseError" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;" id="Table3">
                    <tr>
                        <td style="text-align:right;width:200px;">Patient No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnRMRNO"></span></td>
                        <td style="text-align:right;width:200px;">IPD No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnRIPDNO"></span></td>
                    </tr>                       
                    <tr>
                        <td style="text-align:right;width:200px;">Name&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnName"></span></td>
                        <td style="text-align:right;width:200px;">Death Date & Time&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnRDeath"></span></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                    </tr>                   
                </table>   
            </div>
            <div class="POuter_Box_Inventory" style="width:697px;">                 
                <table  style="border-collapse:collapse;width:100%;">
                    <tr>
                        <td style="text-align:right;width:25%;">Collected By&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:25%;">
                            <input type="text" id="txtRCollected" title="Enter Collected By"/>
                            <span class="ItDoseLblError">*</span>
                        </td>
                        <td style="text-align:right;width:25%;">Contact No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:25%;">
                            <input type="text" id="txtRContactNo" title="Enter Contact No"/>
                            <span class="ItDoseLblError">*</span>
                        </td>
                    </tr>     
                     <tr>
                        <td style="text-align:right;width:25%;">Address&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:25%;" colspan="2">
                            <input type="text" id="txtRAddress" title="Enter Address" style="width:200px"/>
                            <span class="ItDoseLblError">*</span>
                        </td>                        
                        <td style="text-align:left;width:25%;">&nbsp;</td>
                    </tr>                                              
                    <tr>
                        <td style="text-align:right;width:25%;">Out Remarks&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:75%;" colspan="3">
                            <textarea id="txtOutRemarks" style="width:300px;height:50px;resize:none;"></textarea>         
                        </td>                        
                    </tr>                              
                    <tr>
                        <td style="text-align:right">&nbsp;</td>
                        <td style="text-align:left">&nbsp;</td>                        
                    </tr>
                </table> 
                </div>  
            <div class="POuter_Box_Inventory" style="text-align:center;width:697px;">
                <input type="button" id="btnRelease" value="Release" onclick="UpdateMedicine();" class="ItDoseButton"/>
                <asp:Button ID="btnReleaseCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
            </div>         
        </div>        
    </asp:Panel>
    <!--Popup for corpse release-->

        <script type="text/html" id="SearchResult1">
        <table  class="FixedTables"  cellspacing="0" rules="all" border="1" style="border-collapse:collapse;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">IN Date Time</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">CorpseID</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none;">DepositeNo</th>               	
			    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Name</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Death Date<br />Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Rack/Shelf</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none;">Death Type</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Infectious Remark</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Admitted By</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Edit</th>  
                                                  	
		    </tr>
		    <#       
		    var dataLength=CorpseResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {       

                var strStyle="";
		        objRow = CorpseResult[j];


                
		    #>
				    <tr >            
                                          
                        <td class="GridViewLabItemStyle" id="td4"  style="width:200px;text-align:center;" ><#=objRow.InDate1#></td>
					    <td class="GridViewLabItemStyle" id="td5"  style="width:200px;text-align:center;" ><#=objRow.Corpse_ID#></td>
                        <td class="GridViewLabItemStyle" id="td6" style="width:80px;text-align:center;display:none; "><#=objRow.Transaction_ID#></td>    
					    <td class="GridViewLabItemStyle" id="td7" style="width:130px;text-align:left; "><#=objRow.CName#></td>
					    <td class="GridViewLabItemStyle" id="td8" style="width:100px;text-align:center;"><#=objRow.Age#>/<#=objRow.Gender#></td>
					    <td class="GridViewLabItemStyle" id="td9" style="width:200px;text-align:center"><#=objRow.DeathDate1#>&nbsp; <#=objRow.DeathTime1#></td>
                        <td class="GridViewLabItemStyle" id="td10" style="width:120px;text-align:center;"><#=objRow.Freezer#></td>
					    <td class="GridViewLabItemStyle" id="td11" style="width:120px;text-align:left;display:none;"></td>
					    <td class="GridViewLabItemStyle" id="td12" style="width:120px;text-align:left;"><#=objRow.InfectiousRemark#></td>
					    <td class="GridViewLabItemStyle" id="td13" style="width:120px;text-align:left;"><#=objRow.AdmittedBy#></td>    
                         <td class="GridViewLabItemStyle" style="width:50px;text-align:center;">
                             
                            
                            <img id="imgLabel" src="../../Images/edit.png" style="cursor:pointer;" title="Click To View" onclick="bindCorpseMasterAndDeposite('<#=objRow.ID#>');"/>
                            
                        </td>
                                                                                     
                    </tr>             
                
		    <#}        
		    #> 
	    </table>    
    </script>
    <!--Corpse search result table-->
    <script type="text/html" id="SearchResult">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse:collapse;" id="tablePatient">
		    <tr> 
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Select</th>           
			    <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">IPDNo</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:150px;">UHID</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Name</th>               	
			    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Gender</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Age</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Contact</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">DateofDeath</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:80px;">TimeofDeath</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Doctor</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">TypeOfDeath</th>    
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none;">CauseOfDeath</th>		                         	
		    </tr>
		    <#       
		    var dataLength=CorpseResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;   
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = CorpseResult[j];
		    #>
				    <tr>     
                        <td class="GridViewLabItemStyle" style="width:60px;text-align:center;" id="tdSelect">
                            <a  onclick="bindCorpseDetail(this);" style="cursor:pointer; " class="ItDoseButton">
                                Select
                            </a>
                        </td>                   
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:center;"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdIPDNo"  style="width:50px;text-align:center;" ><#=objRow.Transaction_ID#></td>
					    <td class="GridViewLabItemStyle" id="tdMRno"  style="width:100px;text-align:left;" ><#=objRow.Patient_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdName" style="width:150px;text-align:center; "><#=objRow.PName#></td>    
					    <td class="GridViewLabItemStyle" id="tdGender" style="width:50px;text-align:center; "><#=objRow.Gender#></td>
					    <td class="GridViewLabItemStyle" id="tdAge" style="width:70px;text-align:center;"><#=objRow.Age#></td>
					    <td class="GridViewLabItemStyle" id="tdContact" style="width:50px;text-align:center"><#=objRow.Mobile#></td>
					    <td class="GridViewLabItemStyle" id="tdDOD" style="width:80px;text-align:center"><#=objRow.DOD#></td>
					    <td class="GridViewLabItemStyle" id="tdTOD" style="width:80px;text-align:center;"><#=objRow.DOT#></td>
                        <td class="GridViewLabItemStyle" id="tdDocName" style="width:120px;text-align:center"><#=objRow.DocName#></td>
                        <td class="GridViewLabItemStyle" id="tdTypeOfDeath" style="width:120px;text-align:center;display:none;"><#=objRow.TypeOfDeath#></td>
                        <td class="GridViewLabItemStyle" id="tdCauseOfDeath" style="width:120px;text-align:center;display:none;"><#=objRow.CauseOfDeath#></td>                                                                      
                    </tr>              
		    <#}        
		    #> 
            <tr>
                <td colspan="11">&nbsp;</td>
            </tr>        
	    </table>    
    </script>
    <!--Corpse search result table-->   
</asp:Content>

