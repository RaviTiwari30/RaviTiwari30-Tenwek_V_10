<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RevenueDepartmentWise.aspx.cs"
    Inherits="Design_CommonReports_RevenueDepartmentWise" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript">
        $(function () {
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
                    $('#btnGetExcel').attr('disabled', 'disabled');
                }
                else { $('#btnGetExcel').removeAttr('disabled'); }
            });
        }
        $(document).ready(function () {
            $bindCentre();
            $bindDepartment(function (selectedDepartment) {
                $bindDoctor(selectedDepartment, function () {
                });
            });
        });
        var $bindCentre = function () {
            serverCall('SICReport.aspx/BindCentre', {}, function (response) {
                Centre = $('#ddlCentre');
                var DefaultCentre = '<%=Session["CentreID"].ToString() %>';
                Centre.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false, selectedValue: DefaultCentre });
            });
        }


        var $bindDepartment = function (callback) {
            var $ddlDepartment = $('#ddlDepartment');
            serverCall('../common/CommonService.asmx/bindDepartment', {}, function (response) {
                $ddlDepartment.bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true, selectedValue: 'All' });
                callback($ddlDepartment.find('option:selected').text());
            });
        }


        var $bindDoctor = function (department, callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/bindDoctorDept', { Department: department }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }





        var _onDoctorChange = function (el, event, callback) {

            if (el.value == '0') {
                var doctorList = $('.selectedDoctors').hide();
                doctorList.find('ul').find('li').remove();

                return false;

            }
            var doctorList = $('.selectedDoctors').show();
            var data = {
                value: el.value,
                text: $(el.selectedOptions).text()
            }

            bindDoctors(data, function () { });

        }




        var bindDoctors = function (data, callback) {
            var doctorList = $('.selectedDoctors')
           

            $isAlreadyExits = doctorList.find('#' + data.value);
            if ($isAlreadyExits.length > 0) {
                modelAlert('Doctor Already Seleted.');
                return false;
            }
            doctorList.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="onSelectedItemRemove(this);" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a></li>');
            callback(doctorList);
        }





        var _onDepartmentChange = function (el, event, callback) {

            var departmentList = $('.selectedDepartments');
            if (el.value == '0') {
                departmentList.hide().find('ul').find('li').remove();
                return false;
            }

            departmentList.show();
            var data = {
                value: el.value,
                text: $(el.selectedOptions).text()
            }

            bindDepartments(data, function () { });

        }



        var bindDepartments = function (data, callback) {
            var doctorList = $('.selectedDepartments')


            $isAlreadyExits = doctorList.find('#' + data.value);
            if ($isAlreadyExits.length > 0) {
                modelAlert('Department Already Seleted.');
                return false;
            }
            doctorList.find('ul').append('<li id=' + data.value + ' class="search-choice"><span>' + data.text + '</span><a onclick="onSelectedItemRemove(this)" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + data.value + '</a></li>');
            callback(doctorList);
        }



        var onSelectedItemRemove = function (el) {
            var selectedRow = $(el).closest('.row');
            $(el).parent().remove();

            var selectedItems = selectedRow.find('li');
            if (selectedItems.length == 0)
                selectedRow.hide();
        }



        var getExcelReports = function () {
            data = {
                centreID: Number($('#ddlCentre').val()),
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
                Type: $('#ddlReportType').val(),
                patienttype: $('#ddlPatiReportType').val()
            }
            serverCall('RevenueDepartmentWise.aspx/GetExcelReports', data, function (response) {

                var responseData = JSON.parse(response);

                if (responseData.status)
                    window.open(responseData.URL, "_blank");
                else
                    modelAlert(responseData.message);

            });
        }




    </script>
    <cc1:ToolkitScriptManager ID="scManager" runat="server"></cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>DepartmentWise Revenue Report
            </b>
            <br />
            
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">Centre </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlCentre" title="Select Centre"></select>
                                </div>
                                 <div class="col-md-8">
                                     <span style="font-size:xx-small;font-style:italic;color:red;font-weight:bold">NOTE: This report is generated as per entry date.</span>
                                     </div>
                                <div class="col-md-3">
                                    <label class="pull-left">Patient Type </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <select id="ddlPatiReportType" title="Select Type">
                                        <option value="OPD">OPD</option>
                                        <option value="IPD">IPD</option>
                                        <option value="EMG">EMG</option>
                                        <option value="ALL" selected="selected">ALL</option>
                                    </select>
                                </div>
                                <div class="col-md-3 hidden">
                                    <label class="pull-left">Department's </label>
                                    <b class="pull-right">:</b>
                                </div>

                                <div class="col-md-5 hidden">
                                    <select id="ddlDepartment" onchange="$bindDoctor($(this).find('option:selected').text(),function(){   });_onDepartmentChange(this,event,function(){})"></select>
                                </div>


                                <div class="col-md-3 hidden">
                                    <label class="pull-left">Doctor's </label>
                                    <b class="pull-right">:</b>
                                </div>

                                <div class="col-md-5 hidden">
                                    <select id="ddlDoctor" onchange="_onDoctorChange(this,event,function(){})" ></select>
                                </div>






                            </div>

                            <div class="row selectedDepartments" style="display:none">
                                <div class="col-md-3">
                                    <label class="pull-left"> Department's </label>
                                    <b class="pull-right">:</b>
                                </div>

                                 <div class="col-md-21 chosen-container-multi">
                                     <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices"></ul>
                                  </div>

                             </div>

                            <div class="row selectedDoctors" style="display:none">
                                <div class="col-md-3">
                                    <label class="pull-left">Doctor's </label>
                                    <b class="pull-right">:</b>
                                </div>

                                 <div class="col-md-21 chosen-container-multi">
                                     <ul style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices"></ul>
                                  </div>

                             </div>


                            <div class="row">

                                <div class="col-md-3">
                                    <label class="pull-left">From Date </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtFromDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                                    <cc1:CalendarExtender ID="ceFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>

                                <div class="col-md-3">
                                    <label class="pull-left">To Date </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtToDate" ClientIDMode="Static" runat="server"></asp:TextBox>
                                    <cc1:CalendarExtender ID="ceToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </div>



                                <div class="col-md-3">
                                    <label class="pull-left">Report Type </label>
                                    <b class="pull-right">:</b>
                                </div>

                                <div class="col-md-5 ">
                                    <select id="ddlReportType">
                                        <option value="0">Department Wise</option>
                                        <option value="1">Doctor Wise</option>
                                    </select>
                                </div>


                               <div class="col-md-3 hidden">
                                    <label class="pull-left">Search On </label>
                                    <b class="pull-right">:</b>
                                </div>

                                <div class="col-md-5 hidden">
                                    <select id="ddlSearchOn">
                                        <option value="0">Transaction Date</option>
                                        <option value="1">Bill Date</option>

                                    </select>
                                </div>
                            </div>




                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>

            </div>




        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24" style="text-align: center">
                    <input type="button" class="ItDoseButton" id="btnGetExcel" value="Get Report" onclick="getExcelReports(this)" />

                </div>
            </div>
        </div>



    </div>



</asp:Content>
