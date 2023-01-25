<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="AgeingReport.aspx.cs" Inherits="Design_CommonReports_AgeingReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCAgeingBuckets.ascx" TagName="wuc_AgeingBuckets" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">

        $(document).ready(function () {
            $bindCentre(function () { });
	    $("#ddlAgeingWho option[value='Stock']").remove();
            $('#txtFromDate').change(function () {
                checkdate(function () { });
            });
            $('#txtToDate').change(function () {
                checkdate(function () { });
            });
        });
        var checkdate = function () {
            var data = {
                DateFrom: $('#txtFromDate').val(),
                DateTo: $('#txtToDate').val()
            };

            serverCall('../Common/CommonService.asmx/CompareDate', data, function (response) {
                responseData = JSON.parse(response);
                if (responseData == false) {
                    modelAlert("To date can not be less than from date!");
                    $('#btnSearch').attr('disabled', 'disabled');
                }
                else { $('#btnSearch').removeAttr('disabled'); }
            });
        }
        var $bindCentre = function (callback) {
            serverCall('AgeingReport.aspx/BindCentre', {}, function (response) {
                $Centre = $('#ddlCentre');
                $Centre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: true, selectedValue: 'Select' });
                $BindDocPanel();
                callback($Centre.find('option:selected').text());
            });
        }

        var $BindDocPanel = function () {
            var centreID = $('#ddlCentre').val();
            $bindDoctor(centreID, function () {
                $bindPanel(centreID, function () { });
            });
        }

        var $bindDoctor = function (centreID, callback) {
            serverCall('../common/CommonService.asmx/bindDoctorCentrewise', { CentreID: centreID }, function (response) {
                $Doctor = $('#ddlDoctor');
                $Doctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true, selectedValue: 'Select' });
                callback($Doctor.find('option:selected').text());
            });
        }
        var $bindPanel = function (CentreID, callback) {
            serverCall('AgeingReport.aspx/bindPanelCentrewise', { centreID: CentreID }, function (response) {
                $Panel = $('#ddlPanel');
                $Panel.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true, selectedValue: 'Select' });
                callback($Panel.find('option:selected').text());
            });
        }
        var searchAgeing = function () {
            if ($('#ddlCentre').val() == 0)
            {
                modelAlert("Please Select The Centre", function () {
                    $('#ddlCentre').focus();
                });
                return;
            }

            data = {
                centreID: $('#ddlCentre').val(),
                doctorID: $('#ddlDoctor').val(),
                panelID: $('#ddlPanel').val(),
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                bucketFor: $('#ddlBucketType').val(),
                bucketType: $('#ddlAgeingWho').val(),
                patienttype: $('#ddlpatienttype').val(),
                ReportType: $('#ddlReportType').val(),
                isBasecurrency: $('#chkisbasecurrency').is(':checked')? '0':'1'
            }
            serverCall('AgeingReport.aspx/SearchAgingPanel', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.URL, "_blank");
                else
                    modelAlert(responseData.message);
            });
        }
        var checkbasecurrency = function (el) {

            if ($(el).val() == "INCOA")
                $('#chkisbasecurrency').removeAttr('disabled');
            else
                $('#chkisbasecurrency').attr('disabled', 'disabled');

            if ($(el).val() == "SA") {
                $('#btnSearch').removeAttr('disabled');
                $('#txtToDate').attr('disabled', 'disabled');
            }
            else {
                $('#txtToDate').removeAttr('disabled');
            }
        }
</script>

   

    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="sp" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Aging Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        Centre Name 
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" runat="server" onchange="$BindDocPanel();" ClientIDMode="Static" TabIndex="1" ToolTip="Select Centre"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Doctor
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDoctor" runat="server" ClientIDMode="Static" TabIndex="2" ToolTip="Select Doctor"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Panel
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlPanel" runat="server" ClientIDMode="Static" TabIndex="3" ToolTip="Select Panel"></asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" AutoCompleteType="Disabled" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>


                <div class="col-md-3">
                    <label class="pull-left">Patient Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlpatienttype">
                        <option value="OPD">OPD</option>
                        <option value="IPD">IPD</option>
                        <option value="EMG">EMG</option>
                        <option value="ALL">ALL</option>
                    </select>
                </div>
            </div>
            <div class="row">
                 <div class="col-md-3">
                    <label class="pull-left">Report Type</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select id="ddlReportType" onchange="checkbasecurrency(this)">
                        <optgroup label="Panel Detail">
                            <option value="P">Panel Outstanding</option>
                            <%--<option value="PA" disabled="disabled">Panel Outstanding with ageing</option>
                            <option value="INCOA">Panel Ageing with Due Days</option>
                            <option value="INDCOA">Individual COA</option>
                            <option value="INCOAF">Individual COA On Entry Date</option>
			                <option value="INCOAW">Individual COA On Entry Date(Walkin)</option>
							<option value="INCOANEW">Individual COA (NEW)</option>
                           <option value="PUAS">Panel UnAllocated (Summary)</option>
                            <option value="PUAD">Panel UnAllocated (Outstanding)</option>
                           <option value="PUAD">Panel UnAllocated (As On To Date)</option>--%>
                            <option value="POS">Panel Outstanding Summarized (By Allocation Date)</option>
                            <option value="POD">Panel Outstanding Detail (By Allocation Date)</option>
                            <%--  <option value="PSOAS">Panel SOA Summary(By Bill Date)</option>
                            <option value="PSOAD">Panel SOA Detail(By Bill Date)</option>
                          <option value="SOAS">SOA Summary</option>
                            <option value="SOAD">SOA Detail</option>--%>
                        </optgroup>
                       <%-- <optgroup label="Doctor Detail">
                            <option value="DA">Doctor Ageing Report(By Bill Date)</option>
                            <option value="DSOA">Doctor Statement of account-Allocation date</option>
                        </optgroup>--%>
                         <optgroup label="Writeoff Report">
                            <option value="WOSR">Writeoff Summary</option>
                             <%-- <option value="WODR">Writeoff Detail(Doctorwise)</option>--%>
                        </optgroup>
                    </select>
                </div>
                <div class="row">
                 <div class="col-md-3">
                     <input type="checkbox" id="chkisbasecurrency" checked="checked" disabled="disabled" />
                    <label class="pull-left">Is BaseCurrency</label>
                    <b class="pull-right">:</b>
                </div></div>
            </div>
            <uc2:wuc_AgeingBuckets ID="AgeingBuckets" runat="server" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24 textCenter">
                    <input type="button" id="btnSearch" onclick="searchAgeing()" class="save" value="Search" tabindex="8" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>

