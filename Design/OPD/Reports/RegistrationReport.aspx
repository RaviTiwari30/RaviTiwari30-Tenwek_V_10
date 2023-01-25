<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="RegistrationReport.aspx.cs" Inherits="Design_OPD_RegistrationReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <%--  <link href="../../Styles/grid24.css" rel="stylesheet" />--%>
    <script type="text/javascript">

        $(document).ready(function () {
            $bindCountry(function (selectedCountryID) {
                $bindState(selectedCountryID, function (selectedStateID) {
                    $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
                        $bindCity(selectedStateID, selectedDistrictID, function () { });
                    });
                });
            });
           
        });

        var $bindCountry = function (callback) {
            debugger;
            $('#ddlState,#ddlDistrict,#ddlCity').empty();
            var $ddlCountry = $('#ddlCountry');
            serverCall('../../Common/CommonService.asmx/getCountry', {}, function (response) {
                $ddlCountry.bindDropDown({ data: JSON.parse(response), valueField: 'CountryID', textField: 'Name', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "BaseCurrencyID") %>' });
                callback($ddlCountry.val());
            });
        }

        var $bindState = function (countryID, callback) {
            var $ddlState = $('#ddlState');
            serverCall('../../Common/CommonService.asmx/getState', { countryID: countryID }, function (response) {
                $ddlState.bindDropDown({ data: JSON.parse(response), valueField: 'StateID', textField: 'StateName', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultStateID") %>' });
                callback($ddlState.val());
            });
        }

        var $bindDistrict = function (countryID, stateID, callback) {
            $('#ddlCity').empty();
            var $ddlDistrict = $('#ddlDistrict');
            serverCall('../../Common/CommonService.asmx/getDistrict', { countryID: countryID, stateID: stateID }, function (response) {
                $ddlDistrict.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DistrictID', textField: 'District', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultDistrictID") %>' });
		           callback($ddlDistrict.val());
		        });
        }

        var $bindCity = function (StateID, districtID, callback) {
            var $ddlCity = $('#ddlCity');
            serverCall('../../Common/CommonService.asmx/getCity', { StateID: StateID, districtID: districtID }, function (response) {
                $ddlCity.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'City', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultCityID") %>' });
			            callback($ddlCity.val());
			        });
        }

        var $bindVillage = function (callback) {
            var $ddlVillage = $("#ddlVillage");
            serverCall('../../Common/CommonService.asmx/GetVillage', {}, function (response) {
                $ddlVillage.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Locality', textField: 'Locality', isSearchAble: true, });
                callback($ddlVillage.val());
            });
        }

        var $onCountryChange = function (selectedCountryID) {
           // $bindState(selectedCountryID, function (selectedStateID) {
                $bindDistrict(selectedCountryID, 0, function (selectedDistrictID) {
                    $bindCity(0, selectedDistrictID, function () { });
                    // $bindTuluka(selectedDistrictID, function () { });
                    $("#<%=lblCountryID.ClientID%>").val(selectedCountryID);
                });
          //  });
        }

        var $onStateChange = function (selectedCountryID, selectedStateID) {
            $bindDistrict(selectedCountryID, selectedStateID, function (selectedDistrictID) {
                $bindCity(selectedStateID, selectedDistrictID, function () { });
                // $bindTuluka(selectedDistrictID, function () { });

                $("[id$=lblStateID]").val(selectedStateID);
            });
        }

        var $onDistrictChange = function (selectedStateID, selectedDistrictID) {
            $bindCity(selectedStateID, selectedDistrictID, function () { });
            $("[id$=lblDistrictID]").val(selectedDistrictID);
        }

        function getCityID() {
            var value = $("#ddlCity option:selected").val();
            $("#<%=lblCityID.ClientID%>").val(value);
        }

        function getVillage() {
            var value = $("#ddlVillage option:selected").text();
            $("#<%=hfVillage.ClientID%>").val(value);
        }

        $(function () {
            $('#txtfromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnReport').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnReport').removeAttr('disabled');
                    }
                }
            });
        }
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');
            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function checkMain() {
            if (($('#<%= chkCentre.ClientID %> input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %> input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %> input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %> input[type=checkbox]').attr("checked", false);
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Patient Registration Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtfromDate" runat="server" ToolTip="Select From Date"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtfromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date"
                                TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtCurrentDate0_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Report Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">Excel</asp:ListItem>
                                <asp:ListItem  Value="0">PDF</asp:ListItem>
                                
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Country
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCountry" onchange="$onCountryChange(this.value)">
                              
                            </select>
                            <asp:HiddenField ID="lblCountryID" runat="server" ClientIDMode="Static"></asp:HiddenField>
                           
                        </div>
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                State
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <select id="ddlState" onchange="$onStateChange($('#ddlCountry').val(),this.value)">
                                
                            </select>
                            <asp:HiddenField ID="lblStateID" runat="server" ClientIDMode="Static"></asp:HiddenField>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                District
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDistrict" onchange="$onDistrictChange($('#ddlState').val(),this.value)">
                                <option value="0">Select</option>
                            </select>
                            <asp:HiddenField ID="lblDistrictID" runat="server" ClientIDMode="Static"></asp:HiddenField>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                City
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCity" onchange="getCityID();">
                                <option value="0">Select</option>
                            </select>
                            <asp:HiddenField ID="lblCityID" runat="server" ClientIDMode="Static"></asp:HiddenField>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                       
                        <div class="col-md-3">
                            <label class="pull-left">
                                Village
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlVillage" onchange="getVillage();">
                            </select>
                            <asp:HiddenField ID="hfVillage" runat="server" ClientIDMode="Static"></asp:HiddenField>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server" ToolTip="UHID"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" Text="Centre" onclick="checkAllCentre();" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-12">
                            <asp:CheckBoxList ID="chkCentre" ClientIDMode="Static" onclick="checkMain()" RepeatLayout="Table" CssClass="chkAllCentreCheck" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                        </div>
                    </div>
                    </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" runat="server" OnClick="btnReport_Click" Text="Report"
                ClientIDMode="Static" CssClass="ItDoseButton" TabIndex="3" ToolTip="Click to Open Report" />
        </div>
    </div>
</asp:Content>
