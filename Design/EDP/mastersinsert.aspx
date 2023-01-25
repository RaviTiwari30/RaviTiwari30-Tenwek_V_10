<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MastersInsert.aspx.cs" Inherits="Design_EDP_MastersInsert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">

        $(document).ready(function () {
            $bindCountry(function (selectedCountryID) {
                //$bindState(selectedCountryID, function (selectedStateID) {
                //    $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) { });
                //});
            });
            
        });

        var $bindCountry = function (callback) {
            $('#ddlState,#ddlDistrict,#ddlCity,#ddlTaluka').empty();
            var $ddlCountry = $('#ddlCountry');
            serverCall('../Common/CommonService.asmx/getCountry', {}, function (response) {
                $ddlCountry.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CountryID', textField: 'Name', isSearchAble: true });//selectedValue: '<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>'
                callback($ddlCountry.val());
            });
        }

        function ShowMasters() {
            var value = $("#ddlAllMasters option:selected").val();
            if (value == "1") {
                $("#lblDistrict").css("display", "none");
                $("#lblddlState").css("display", "none");
                $("#lblState").css("display", "none");
             //   $("#ddlDistrict").css("display", "none");
                $("#lblddlDistrict").css("display", "none");

                $("#divState").css("display", "");
                $("#divCity").css("display", "none");
                $("#divSave").css("display", "");
                $("#divDistrict").css("display", "none");
                $('#DivDistrictList').css("display", "none");
                $("#MainDivDistrictList").css("display", "none");
                $("#DivMainCityList").css("display", "none");
                $('#divShowVillage').hide();
                $('#divVillagetable').hide();
               // bindState(function () { });
            }
            else if (value == "2") {
                $("#divSave").css("display", "");
                $("#divState").css("display", "none");
                $("#divDistrict").css("display", "");
                $('#DivStateList').css("display", "none");
                $("#MainStateList").css("display", "none");
                $("#DivMainCityList").css("display", "none");
                $("#divCity").css("display", "none");
                $("#lblState").css("display", "");
                $("#lblddlState").css("display", "");
                $("#lblddlDistrict").css("display", "none");
                $("#lblDistrict").css("display", "none");
                $('#divShowVillage').hide();
                $('#divVillagetable').hide();
                var selectedCountryID = $("#ddlCountry option:selected").val();
                $bindState(selectedCountryID, function (selectedStateID) {
                   // bindDistrict(function () { });
                });
                
            }
            else if (value == "3") {
                $("#lblDistrict").css("display", "");
                $("#lblddlState").css("display", "");
                $("#lblState").css("display", "");
                $("#lblddlDistrict").css("display", "");
                $("#divSave").css("display", "");
                $("#divCity").css("display", "");
                $("#divState").css("display", "none");
                $('#DivStateList').css("display", "none");
                $("#MainDivDistrictList").css("display", "none");
                $("#divDistrict").css("display", "none");
                $("#MainStateList").css("display", "none");
                $('#divShowVillage').hide();
                $('#divVillagetable').hide();

                var selectedCountryID = $("#ddlCountry option:selected").val();
               // var selectedStateID = $("#ddlState option:selected").val();
                $bindState(selectedCountryID, function (selectedStateID) {
                   // $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
                       // bindCity(function () { });
                   // });
                });
                
                
            }
            else if (value == "4") {
                $("#lblDistrict").css("display", "none");
                $("#lblddlState").css("display", "none");
                $("#lblState").css("display", "none");
                //   $("#ddlDistrict").css("display", "none");
                $("#lblddlDistrict").css("display", "none");

                $("#divState").css("display", "");
                $("#divCity").css("display", "none");
                $("#divSave").css("display", "");
                $("#divDistrict").css("display", "none");
                $('#DivDistrictList').css("display", "none");
                $("#MainDivDistrictList").css("display", "none");
                $("#DivMainCityList").css("display", "none");
                $("#divState").css("display", "none");
                bindVillage();
                $('.showvillage').show();
                $("#btnUpdate").css("display", "none");
                $("#btnSave").css("display", "");
                $('#divSave').show();
            }
        }

        var bindVillage = function () {
            serverCall('MastersInsert.aspx/getVillagelist', {}, function (response) {
                if (response.length > 0) {
                    bindVillageList(JSON.parse(response));
                }
                });
           }

        var bindVillageList = function (data)
        {
            
            $('#tblVillageList tbody').empty();

            for(var i=0;i<data.length;i++)
            {
              

                var j = $('#tblVillageList tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle">' + j + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdVillageName">' + data[i].VillageName + '</td>';
                row += '<td class="GridViewLabItemStyle" id="tdVillageActive">' + data[i].IsActive + '</td>';
                row += '<td class="GridViewLabItemStyle"><img id="imgEditVillage" onclick="editVillage(this)"  src="../../Images/edit.png" style="cursor:pointer"/></td>';
                row += '<td class="GridViewLabItemStyle" style="display:none;" id="tdVillageID">' + data[i].VillageID + '</td>';
                row += '</tr>';
                $('#tblVillageList tbody').append(row);
            }
            
        }
        function ShowData() {
            var value = $("#ddlAllMasters option:selected").val();
            if (value == "1") {//state
                bindState(function () { });
            }
            else if (value == "2") {
                var selectedCountryID = $("#ddlCountry option:selected").val();
                $bindState(selectedCountryID, function (selectedStateID) { });
            }
            else if (value == "3") {
                var selectedCountryID = $("#ddlCountry option:selected").val();
                $bindState(selectedCountryID, function (selectedStateID) {
                   // $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
                        //bindCity(function () { });
                  //  });
                });
            }
        }

        function CloseAllDiv() {
            $("#divState").css("display", "none");
            $("#divSave").css("display", "none");
        }

        function Savemasters() {
            var masters = $("#ddlAllMasters option:selected").val();
            var countryID = $('#ddlCountry option:selected').val();
            if (masters == "0") {
                modelAlert("Select Masters");
                return false;
            }
            else {
                if (masters == "1") {  // state
                    var state = $("#txtStateName").val();
                    if (state == "") {
                        modelAlert("Enter State");
                        return false;
                    }
                    else {
                        serverCall('../Common/CommonService.asmx/StateInsert', { CountryID: countryID, StateName: state }, function (response) {
                            var $stateId = parseInt(response);
                            if ($stateId == 0)
                                modelAlert('State Already Exist');
                            else {
                                modelAlert('State Saved Successfully', function () {
                                    $("#txtStateName").val('');
                                    bindState(function () { });
                                });
                            }
                        });
                    }
                }
                else if (masters == "2") {//District
                    var district = $("#txDistrictname").val();
                    if (district == "") {
                        modelAlert("Enter District");
                        return false;
                    }
                    else {
                        var stateid = $("#ddlState option:selected").val();
                        serverCall('../Common/CommonService.asmx/DistrictInsert', { District: district, countryID: countryID, stateID: stateid }, function (response) {
                            var $districtId = parseInt(response);
                            if ($districtId == 0)
                                modelAlert('District Already Exist');
                            else {
                                modelAlert('District Saved Successfully', function () {
                                    $("#txDistrictname").val('');
                                    bindDistrict(function () { });
                                });
                            }
                        });
                    }
                }
                else if (masters == "3") {//City
                    var city = $("#txtCityName").val();
                    var districtID = $("#ddlDistrict option:selected").val();

                    if (districtID == "0") {
                        modelAlert("Please select District");
                        $("#ddlDistrict").focus();
                        return false;
                    }
                    else if (city == "") {
                        modelAlert("Please Enter city");
                        $("#txtCityName").focus();
                        return false;
                    }
                    else {
                        var stateid = $("#ddlState option:selected").val();

                        serverCall('../Common/CommonService.asmx/CityInsert', { City: city, Country: countryID, DistrictID: districtID, StateID: stateid }, function (response) {
                            $cityId = parseInt(response);
                            if ($cityId == 0)
                                modelAlert('City Already Exist');
                            else {
                                modelAlert('City Saved Successfully', function () {
                                    $("#txtCityName").val('');
                                    bindCity(function () { });
                                });
                            }
                        });
                    }
                }

                else if (masters == 4) {
                    if ($('#txtVillage').val() == "") {
                        modelAlert('Enter Village Name', function () {
                            $('#txtVillage').focus();
                        });
                        return false;
                    }

                    serverCall('../Common/CommonService.asmx/TalukaInsert', { Taluka: $('#txtVillage').val(), districtID: 0, cityID: 0 }, function (response) {
                        var $VillageName = parseInt(response)
                        if ($VillageName == 0)
                            modelAlert('Village Already Exist');
                        else {
                            modelAlert('Village Saved Successfully', function () {
                                $('#txtVillage').val('');
                                bindVillage();
                            });
                        }
                    });
                }
            }
        }

        function UpdateMasters() {
            var masters = $("#ddlAllMasters option:selected").val();
            if (masters == "1") {  // state
                var stateID = $("#spnStateID").text();
                var countryID = $('#ddlCountry option:selected').val();
                var statename = $("#txtStateName").val();
                var active = $("input[name='rbStateActive']:checked").val();
                UpdateState(stateID, countryID, statename, active);
            }
            else if (masters == "2") {  // district
                var DistrictID = $("#spnDistrictID").text();
                var countryID = $('#ddlCountry option:selected').val();
                var StateID = $('#ddlState option:selected').val();
                var active = $("input[name='rbDistrictActive']:checked").val();
                var DistrictName = $("#txDistrictname").val();
                UpdateDistrict(StateID, countryID, DistrictName, active, DistrictID);
            }
            else if (masters == "3") {  // city
                var districtID = $("#ddlDistrict option:selected").val();
                var countryID = $('#ddlCountry option:selected').val();
                var StateID = $('#ddlState option:selected').val();
                var active = $("input[name='rbCityActive']:checked").val();
                var cityname = $("#txtCityName").val();
                var cityID = $("#spnCityID").text();
                UpdateCity(StateID, countryID, districtID, active, cityname, cityID);
            }

            else if (masters == "4")//Village
            {
                var data = {
                    villageID: $('#spnVillage').text(),
                    villageName:$('#txtVillage').val(),
                    Active:$("input[name='rbVillageActive']:checked").val()
                }

                updateVillage(data);
            }
        }

        function updateVillage(data)
        {
            serverCall('MastersInsert.aspx/UpdateVillageMaster', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    modelAlert(responseData.response, function (response) {
                        $('#txtVillage').val('');
                        bindVillage();
                    });
                }
                else { mdoelAlert(responseData.response);}

            });
        }
        function UpdateCity(stateID, CountryID, districtID, active, cityName, cityID) {
            $.ajax({
                url: 'MastersInsert.aspx/UpdateCity',
                data: '{StateID:"' + stateID + '",CountryID:"' + CountryID + '",DistrictID:"' + districtID + '",active:"' + active + '",CityName:"' + cityName + '",CityID:"' + cityID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (result) {
                var r = result.d;
                var q = r.replace(/\"/g, "");
                if (q == "OK") {
                    modelAlert("City Updated successfully", function () {
                        bindCity(function () { });
                        $("#txtCityName").val('');
                        $("#btnUpdate").css("display", "none");
                        $("#btnSave").css("display", "");
                    });
                }
                else { modelAlert("Something went wrong. try later."); }
            });
        }

        function UpdateDistrict(StateiD, CountryID, DistrictName, active,districtID)
        {
            $.ajax({
                url: 'MastersInsert.aspx/UpdateDistrict',
                data: '{StateID:"' + StateiD + '",CountryID:"' + CountryID + '",DistrictName:"' + DistrictName + '",active:"' + active + '",DistrictID:"' + districtID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (result) {
                var r = result.d;
                var q = r.replace(/\"/g, "");
                if (q == "OK") {
                    modelAlert("District Updated successfully", function () {
                        bindDistrict(function () { });
                        $("#txDistrictname").val('');
                        $("#btnUpdate").css("display", "none");
                        $("#btnSave").css("display", "");

                    });
                }
                else { modelAlert("Something went wrong. try later."); }
            });
        }

        function UpdateState(StateiD, CountryID, Statename, active) {
            $.ajax({
                url: 'MastersInsert.aspx/UpdateState',
                data: '{StateID:"' + StateiD + '",CountryID:"' + CountryID + '",StateName:"' + Statename + '",active:"' + active + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (result) {
                var r = result.d;
                var q = r.replace(/\"/g, "");
                if (q == "OK") {
                    modelAlert("State Updated successfully", function () {
                        bindState(function () { });
                        $("#txtStateName").val('');
                        $("#btnUpdate").css("display", "none");
                        $("#btnSave").css("display", "");
                    });
                }
                else { modelAlert("Something went wrong. try later."); }
            });
        }

        var bindState = function (callback) {
            var CountryID = $("#ddlCountry option:selected").val();
            serverCall('../Common/CommonService.asmx/GetStateByCountryID', { countryID: CountryID }, function (response) {
                StateData = jQuery.parseJSON(response);
                if (StateData != null) {
                    var output = $('#tb_StateListBind').parseTemplate(StateData);
                    $('#DivStateList').html(output);
                    $('#DivStateList').show();
                    $("#MainStateList").css("display", "");
                }
                else {
                    modelAlert("Record not found");
                }
            });
        }

        var bindDistrict = function (callback) {
            var CountryID = $("#ddlCountry option:selected").val();
            var stateID = $("#ddlState option:selected").val();
            serverCall('../Common/CommonService.asmx/GetDistrictByCountryAndStateID', { countryID: CountryID, StateID: stateID }, function (response) {
                DistrictData = jQuery.parseJSON(response);
                if (DistrictData != null) {
                    var output = $('#tb_DistrictListBind').parseTemplate(DistrictData);
                    $('#DivDistrictList').html(output);
                    $('#DivDistrictList').show();
                    $("#MainDivDistrictList").css("display", "");
                }
                else {
                    modelAlert("Record not found");
                }
            });
        }

        var bindCity = function (callback) {
            var CountryID = $("#ddlCountry option:selected").val();
            var stateID = $("#ddlState option:selected").val();
            var districtID = $("#ddlDistrict option:selected").val();
            serverCall('../Common/CommonService.asmx/GetCityByCountryStateDistrictID', { countryID: CountryID, StateID: stateID, districtID: districtID }, function (response) {
                CityData = jQuery.parseJSON(response);
                if (CityData != null) {
                    var output = $('#tb_CityListBind').parseTemplate(CityData);
                    $('#DivCityList').html(output);
                    $('#DivCityList').show();
                    $("#DivMainCityList").css("display", "");
                }
                else {
                    modelAlert("Record not found");
                }
            });
        }

        function BindDistrict() {
            var master = $("#ddlAllMasters option:selected").val();
            if (master == "1") {
                
            }
            else if (master == "2") {
                bindDistrict(function () { });
            }
            else if (master == "3") {
                var selectedCountryID = $("#ddlCountry option:selected").val();
                var selectedStateID = $("#ddlState option:selected").val();
                $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) { });
            }
        }

        function BindCityDrop() {
            var master = $("#ddlAllMasters option:selected").val();
            if (master == "1") {
               
            }
            else if (master == "2") { }
            else if (master == "3") {
                bindCity(function () { });
            }
        }

        var EditCity = function (rowID) {
            row = $(rowID).closest('tr');
            $("#txtCityName").val(row.find('#tdCityName').text().trim());
            $("#ddlCountry").val(row.find('#tdCityCountryID').text().trim());
            $("#ddlState").val(row.find('#tdCityStateID').text().trim());
            $("#ddlDistrict").val(row.find('#tdCityDistrictID').text().trim()); 
            $("#spnCityID").text(row.find('#tdCityID').text().trim());
            var active = row.find('#tdCityActive').text().trim(); 
            if (active == "Yes") {
                $("input[name=rbCityActive][value=1]").prop("checked", true);
            }
            else {
                $("input[name=rbCityActive][value=0]").prop("checked", true);
            }

            $("#btnUpdate").css("display", "");
            $("#btnSave").css("display", "none");
        }

        var EditDistrict = function (rowID) {
            row = $(rowID).closest('tr');
            $("#txDistrictname").val(row.find('#tdDistrict').text().trim());
            $("#ddlCountry").val(row.find('#tdDisCountryID').text().trim());
            $("#spnDistrictID").text(row.find('#tdDistrictID').text().trim());
            $("#ddlState").val(row.find('#tdDisStateID').text().trim());
            var active = row.find('#tdDistrictActive').text().trim();
            if (active == "Yes") {
                $("input[name=rbDistrictActive][value=1]").prop("checked", true);
            }
            else {
                $("input[name=rbDistrictActive][value=0]").prop("checked", true);
            }
            $("#btnUpdate").css("display", "");
            $("#btnSave").css("display", "none");
        }

        var EditState = function (rowID) {
            row = $(rowID).closest('tr');
            $("#txtStateName").val(row.find('#tdStateName').text().trim());
            $("#ddlCountry").val(row.find('#tdCountryID').text().trim());
            $("#spnStateID").text(row.find('#tdStateID').text().trim());
            var active = row.find('#tdActive').text().trim();
            if (active == "Yes") {
                $("input[name=rbStateActive][value=1]").prop("checked", true);
            }
            else {
                $("input[name=rbStateActive][value=0]").prop("checked", true);
            }
            $("#btnUpdate").css("display", "");
            $("#btnSave").css("display", "none");
        }

        var editVillage = function (rowid) {
            row = $(rowid).closest('tr');
            $('#txtVillage').val(row.find('#tdVillageName').text().trim());
            
            var active = row.find('#tdVillageActive').text().trim();
            if (active == "Yes") {
                $("input[name=rbVillageActive][value=1]").prop("checked", true);
            }
            else {
                $("input[name=rbVillageActive][value=0]").prop("checked", true);
            }
            $('#spnVillage').text(row.find('#tdVillageID').text());
            $("#btnUpdate").css("display", "");
            $("#btnSave").css("display", "none");

            
        }

        var DeleteCity = function (rowID) {
            row = $(rowID).closest('tr');
            var CityID = row.find('#tdCityID').text().trim();
            $.ajax({
                url: 'MastersInsert.aspx/DeleteCity',
                data: '{CityID:"' + CityID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (result) {
                var r = result.d;
                var q = r.replace(/\"/g, "");
                if (q == "OK") {
                    modelAlert("Deleted successfully", function () {
                        bindCity(function () { });
                    });
                }
                else { modelAlert("Something went wrong. try later."); }
            });
        }

        var DeleteDistrict = function (rowID) {
            row = $(rowID).closest('tr'); 
            var districtID = row.find('#tdDistrictID').text().trim();
            $.ajax({
                url: 'MastersInsert.aspx/DeleteDistrict',
                data: '{DistrictID:"' + districtID + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (result) {
                var r = result.d;
                var q = r.replace(/\"/g, "");
                if (q == "OK") {
                    modelAlert("Deleted successfully", function () {
                        bindDistrict(function () { });
                    });
                }
                else { modelAlert("Something went wrong. try later."); }
            });
        }

        var DeleteState = function (rowID) {
            row = $(rowID).closest('tr');
            var StateiD = row.find('#tdStateID').text().trim();
            $.ajax({
                url: 'MastersInsert.aspx/DeleteState',
                data: '{StateID:"' + StateiD + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                type: "POST",
            }).done(function (result) {
                var r = result.d;
                var q = r.replace(/\"/g, "");
                if (q == "OK") {
                    modelAlert("Deleted successfully", function () {
                        bindState(function () { });
                    });
                }
                else { modelAlert("Something went wrong. try later."); }
            });
        }

        function ClearAll() {
            $("#txtStateName").val('');
            $("#txDistrictname").val('');
            $("#txtCityName").val('');
            $("#spnStateID").text('');
            $("#btnUpdate").css("display", "none");
            $("#btnSave").css("display", "");
            $("#ddlAllMasters").val(0);
            $("#DivStateList").empty();
            $("#MainStateList").css("display", "none");
            $("#divSave").css("display", "none");
            $("#MainDivDistrictList").css("display", "none");
            $("#DivMainCityList").css("display", "none");

            $("#lblDistrict").css("display", "none");
            $("#lblddlState").css("display", "none");
            $("#lblState").css("display", "none");
            //   $("#ddlDistrict").css("display", "none");
            $("#lblddlDistrict").css("display", "none");

            $("#divCity").css("display", "none");
            $("#divDistrict").css("display", "none");
            $("#divState").css("display", "none");

            $('#ddlCountry').chosen('destroy').val(0).chosen();
        }

        var $bindState = function (countryID, callback) {
            $('#ddlDistrict').empty();
            var $ddlState = $('#ddlState');
            serverCall('../Common/CommonService.asmx/getState', { countryID: countryID }, function (response) {
                $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'StateID', textField: 'StateName', isSearchAble: true });//selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultStateID") %>'
                callback($ddlState.val());
            });
        }

        var $bindDistrict = function (countryID, stateID, callback) {
          //  $('#ddlCity,#ddlTaluka').empty();
            var $ddlDistrict = $('#ddlDistrict');
            serverCall('../Common/CommonService.asmx/getDistrict', { countryID: countryID, stateID: stateID }, function (response) {
                $ddlDistrict.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DistrictID', textField: 'District', isSearchAble: true });//selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultDistrictID") %>'
                    callback($ddlDistrict.val());
                });
         }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Add Masters</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                 <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Select Masters
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlAllMasters" onchange="ShowMasters()">
                                <option value="0">Select</option>
                                <option value="1">State</option>
                                <option value="2">District</option>
                                <option value="3">City</option>
                                <option value="4">Village</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                             <label class="pull-left">
                                Country
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCountry"  data-title="Select Country" onchange="ShowData()"></select>
                        </div>
                        <div class="col-md-3" style="display:none;" id="lblState">
                            <label class="pull-left">
                                State
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none;" id="lblddlState">
                            <select id="ddlState"   data-title="Select State" onchange="BindDistrict()" style="display:none;"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3" style="display:none;" id="lblDistrict">
                            <label class="pull-left">
                                District
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none;" id="lblddlDistrict">
                            <select id="ddlDistrict"  data-title="Select District" onchange="BindCityDrop()"></select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row" id="divState" style="display:none;">
                         <div class="col-md-3">
                            <label class="pull-left">
                                State Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtStateName" class="form-control ItDoseTextinputText requiredField" autocomplete="off" />
                            <span id="spnStateID" style="display:none;"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rbStateActive" value="1" checked="checked" />Yes
                            <input type="radio" name="rbStateActive" value="0" />No
                        </div>
                    </div>
                    <div id="divDistrict" style="display:none;">
                         <div class="col-md-3">
                            <label class="pull-left">
                                District Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txDistrictname" class="form-control ItDoseTextinputText requiredField" autocomplete="off" />
                            <span id="spnDistrictID" style="display:none;"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rbDistrictActive" value="1" checked="checked" />Yes
                            <input type="radio" name="rbDistrictActive" value="0" />No
                        </div>
                    </div>
                    <div id="divCity" style="display:none;">
                        <div class="col-md-3">
                            <label class="pull-left">
                                City Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtCityName" class="form-control ItDoseTextinputText requiredField" autocomplete="off" />
                            <span id="spnCityID" style="display:none;"></span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rbCityActive" value="1" checked="checked" />Yes
                            <input type="radio" name="rbCityActive" value="0" />No
                        </div>
                    </div>
                </div>
            </div>

            <div class="row showvillage" id="divShowVillage" style="display:none">
                 <div class="col-md-1"></div>
                <div class="col-md-22">
                <div class="col-md-3">
                    <label class="pull-left">Village</label>
                    <b class="pull:right">:</b>
                </div>
                <div class="col-md-5">
                    <input  type="text" id="txtVillage"/>
                    <span id="spnVillage" style="display:none"></span>

                </div>
                      <div class="col-md-3">
                            <label class="pull-left">
                                Active
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rbVillageActive" value="1" checked="checked" />Yes
                            <input type="radio" name="rbVillageActive" value="0" />No
                        </div>
                    </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divSave" style="text-align: center;display:none;">
            &nbsp;&nbsp;
            <input type="button" id="btnSave" value="Save" onclick="Savemasters()" />
            <input type="button" id="btnUpdate" value="Update" onclick="UpdateMasters()" style="display:none;" />
            <input type="button" id="btnCancel" value="Cancel" onclick="ClearAll()" />
        </div>

        <!------------------------------------------------------------------------------------------>
        <div class="POuter_Box_Inventory" id="MainStateList" style="display:none;">
            <div class="Purchaseheader">
                State List
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div id="DivStateList"></div>
                </div>
            </div>
        </div>
        <!--------------------------------------------------------------------------------------------->
        <div class="POuter_Box_Inventory" id="MainDivDistrictList" style="display:none;">
            <div class="Purchaseheader">
                District List
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div id="DivDistrictList"></div>
                </div>
            </div>
        </div>
        <!--------------------------------------------------------------------------------------------->
         <div class="POuter_Box_Inventory" id="DivMainCityList" style="display:none;">
            <div class="Purchaseheader">
                City List
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div id="DivCityList"></div>
                </div>
            </div>
        </div>
           <div class="POuter_Box_Inventory showvillage" id="divVillagetable" style="display:none;">
            <div class="Purchaseheader">
                Village List
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                <div id="divVillagelist">
                    <table id="tblVillageList" rules="all" border="1" style="border-collapse:collapse;width:100%" >
                        <thead>
                        <tr id="trVillageHeader">
                            <th class="GridViewHeaderStyle" scope="col" style="width:3%;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width:5%">Village Name</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width:3%">Active</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width:3%;">Edit</th>
                        </tr>
                        </thead>
                            <tbody></tbody>
                    </table>

                </div>
                </div>
            </div>
        </div>
    </div>

    <!-------------------------------State List--------------------------------------------------------->
    <script id="tb_StateListBind" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%; border-collapse:collapse;">
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col" style="width:5%;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:5%">State Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:5%">Active</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Edit</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Delete</th>
            </tr>
            <#
                var dataLength=StateData.length;
                var objRow;   
                var status;
                for(var j=0;j<dataLength;j++)
                {

                objRow = StateData[j];
            #>
                    <tr id="<#=j+1#>">
                         <td class="GridViewLabItemStyle" id="tdSno" style="width:10px;"><#=j+1#></td>
                        <td id="tdStateName" class="GridViewLabItemStyle" style="width:30%"><#=objRow.StateName#></td>
                        <td id="tdActive" class="GridViewLabItemStyle" style="width:20%"><#=objRow.Active#></td>
                        <td id="tdStateID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.StateID#></td>
                        <td id="tdCountryID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.CountryID#></td>
                        <td id="tdEdit" class="GridViewLabItemStyle" style="width:10%;">
                             <img id="imgEdit" src="../../Images/edit.png" onclick="EditState(this);" title="Click To Edit" style="cursor: pointer" />
                        </td>
                        <td id="tdDelete" class="GridViewLabItemStyle" style="width:10%;">
                            <img src="../../Images/Delete.gif" onclick="DeleteState(this)" title="Click To Delete" style="cursor: pointer" />
                        </td>
                    </tr>
            <#}#>
        </table>
    </script>
     <!------------------------------------------------END------------------------------------------------->
    <!---------------------------------District List---------------------------------------------------------------->
    <script  id="tb_DistrictListBind" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table2" style="width:100%; border-collapse:collapse;">
            <tr id="Tr2">
                <th class="GridViewHeaderStyle" scope="col" style="width:5%;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:5%">District Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:5%">Active</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Edit</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Delete</th>
            </tr>
            <#
                var dataLength=DistrictData.length;
                var objRow;   
                var status;
                for(var j=0;j<dataLength;j++)
                {
                    objRow = DistrictData[j];
            #>
                    <tr id="Tr3">
                         <td class="GridViewLabItemStyle" id="td1" style="width:10px;"><#=j+1#></td>
                        <td id="tdDistrict" class="GridViewLabItemStyle" style="width:30%"><#=objRow.District#></td>
                        <td id="tdDistrictActive" class="GridViewLabItemStyle" style="width:20%"><#=objRow.Active#></td>
                        <td id="tdDistrictID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.DistrictID#></td>
                        <td id="tdDisStateID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.StateID#></td>
                        <td id="tdDisCountryID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.CountryID#></td>
                        <td id="td6" class="GridViewLabItemStyle" style="width:10%;">
                             <img id="img1" src="../../Images/edit.png" onclick="EditDistrict(this);" title="Click To Edit" style="cursor: pointer" />
                        </td>
                        <td id="td7" class="GridViewLabItemStyle" style="width:10%;">
                            <img src="../../Images/Delete.gif" onclick="DeleteDistrict(this)" title="Click To Delete" style="cursor: pointer" />
                        </td>
                    </tr>
            <#}#>
        </table>
    </script>
      <!------------------------------------------------END------------------------------------------------->

    <!---------------------------------City List---------------------------------------------------------------->
    <script id="tb_CityListBind" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table2" style="width:100%; border-collapse:collapse;">
            <tr id="Tr4">
                <th class="GridViewHeaderStyle" scope="col" style="width:5%;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:5%">City Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:5%">Active</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Edit</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Delete</th>
            </tr>
             <#
                var dataLength=CityData.length;
                var objRow;   
                var status;
                for(var j=0;j<dataLength;j++)
                {
                    objRow = CityData[j];
            #>
                    <tr id="Tr5">
                         <td class="GridViewLabItemStyle" id="td2" style="width:10px;"><#=j+1#></td>
                        <td id="tdCityName" class="GridViewLabItemStyle" style="width:30%"><#=objRow.City#></td>
                        <td id="tdCityActive" class="GridViewLabItemStyle" style="width:20%"><#=objRow.Active#></td>
                        <td id="tdCityDistrictID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.districtID#></td>
                        <td id="tdCityStateID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.stateID#></td>
                        <td id="tdCityCountryID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.Country#></td>
                        <td id="tdCityID" class="GridViewLabItemStyle" style="width:20%;display:none;"><#=objRow.ID#></td>
                        <td id="td10" class="GridViewLabItemStyle" style="width:10%;">
                             <img id="img2" src="../../Images/edit.png" onclick="EditCity(this);" title="Click To Edit" style="cursor: pointer" />
                        </td>
                        <td id="td11" class="GridViewLabItemStyle" style="width:10%;">
                            <img src="../../Images/Delete.gif" onclick="DeleteCity(this)" title="Click To Delete" style="cursor: pointer" />
                        </td>
                    </tr>
            <#}#>
        </table>
    </script>

     <!------------------------------------------------END------------------------------------------------->

</asp:Content>

