<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DeptWiseAssetAnalysis.aspx.cs" Inherits="Design_Asset_DeptWiseAssetAnalysis" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/gviz-api.js"></script>
    <script src="../../Scripts/jsapi.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            BindDepartment(function () { });
        });

        var BindDepartment = function (callback) {
            debugger;
            $ddlDepartment = $('#ddlDepartment');
            serverCall('Services/AssetDashBoard.asmx/BindRoleMaster', {}, function (response) {
                debugger;
                $ddlDepartment.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'RoleName', isSearchAble: true, selectedValue: 'Select' });
                callback($ddlDepartment.val());
            });
        }

        function GetFloorandAssetCount(ctrl) {
            debugger;
            $('#divMainChart').slideUp();
            var DepartmentId = ctrl;
            serverCall('Services/AssetDashBoard.asmx/GetFloorandAssetCount', { DepartmentId: DepartmentId }, function (response) {
                debugger;
                var $responseData = JSON.parse(response);
                if ($responseData.length > 0) {
                    $('#divMainChart').slideDown();
                    drawSummaryChart($responseData, function () {
                        debugger;
                        $detailWiseChart = {};
                        $detailWiseDataTable = {};
                        $detailWiseoptions = {};
                        document.getElementById('divDetails').innerHTML = '';
                    });
                }
                else
                    modelAlert('0 Record Found');


            });
        }

        var $summaryChart = {};
        var $summaryDataTable = {};
        function drawSummaryChart(data, callback) {
            debugger;
            $summaryDataTable = new google.visualization.DataTable();
            $summaryDataTable.addColumn('string', 'Label');
            $summaryDataTable.addColumn('number', 'TotalAsset');
            $summaryDataTable.addColumn('number', 'FloorID');
            $summaryDataTable.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $summaryDataTable.setCell(i, 0, data[i].Label);
                $summaryDataTable.setCell(i, 1, data[i].TotalAsset);
                $summaryDataTable.setCell(i, 2, data[i].FloorID);
                //$summaryDataTable.setCell(i, 2, data[i].Param);
            }
            var $options = {
                title: 'Asset Analysis',
                height: 450,
                legend: { position: 'left', textStyle: { color: 'Black', fontSize: 10, bold: true } },
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };
            $summaryChart = new google.visualization.PieChart(document.getElementById('reportSummary'));
            google.visualization.events.addListener($summaryChart, 'select', onSummaryChartSelection);
            $summaryChart.draw($summaryDataTable, $options);
            callback(true);
        }

        var $detailResponseData = {};
        var $summarySelected = {};
        function onSummaryChartSelection() {
            debugger;
            try {
                debugger;
                $summarySelected = $summaryDataTable.getValue($summaryChart.getSelection()[0].row, 2);
                var data = { selection: $summarySelected }
                getRoomList(data, function () { });
            } catch (e) {

            }
        }

        function getRoomList(data, callback) {
            debugger;

            serverCall('Services/AssetDashBoard.asmx/GetRoomList', data, function (response) {
                debugger;
                var $responseData = JSON.parse(response);
                //if ($responseData.status) {
                if ($responseData.length > 0) {
                    $detailResponseData = $responseData;
                    configureChart($responseData, function () { });
                }
                else
                    modelAlert('0 Record Found');

                //}
                //else
                //    modelAlert('Error While Load Data');
            });
        }
        function configureChart(data, callback) {
            debugger;
            var $reportName = 'Room wise Analysis';
            var $labelName = 'Room Name'
            var $valueName = 'Total Asset';
            //var $roomId = 'RoomId';
            var $chartType = document.getElementById('ddlChartType').value;
            var $chartContainer = document.getElementById('divDetails');
            drawDetailWiseChart(data, $reportName, $labelName, $valueName, $chartType, $chartContainer, function () {
            });
        }
        function drawDetailWiseChart(data, chartName, labelName, valueName, chartType, chartContainer, callback) {
            debugger;
            $detailWiseDataTable = new google.visualization.DataTable();
            $detailWiseDataTable.addColumn('string', labelName);
            $detailWiseDataTable.addColumn('number', valueName);
            $detailWiseDataTable.addColumn('number', 'RoomId');
            //$detailWiseDataTable.addColumn('number', roomId);
            $detailWiseDataTable.addRows(data.length);
            for (var i = 0; i < data.length; i++) {


                $detailWiseDataTable.setCell(i, 0, data[i].Label);
                $detailWiseDataTable.setCell(i, 1, data[i].TotalAsset);
                $detailWiseDataTable.setCell(i, 2, data[i].Id);
                //$('[id$=hdnId_' + i + ']').val(data[i].Id);

                //$detailWiseDataTable.setCell(i, 2, data[i].Id);


            }
            $detailWiseoptions = {
                title: chartName,
                height: 390,
                fontName: 'Arial',
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };


            var view = new google.visualization.DataView($detailWiseDataTable); //datatable contains col and rows
            view.setColumns([0, 1, 2]); //only show these column
            view.hideColumns([2]);


            if (chartType == 0)
                $detailWiseChart = new google.visualization.BarChart(chartContainer);
            else if (chartType == 1)
                $detailWiseChart = new google.visualization.PieChart(chartContainer);
            else if (chartType == 2)
                $detailWiseChart = new google.visualization.LineChart(chartContainer);
            else if (chartType == 3)
                $detailWiseChart = new google.visualization.Table(chartContainer);
            else if (chartType == 4)
                $detailWiseChart = new google.visualization.orgchart(chartContainer);

            //$detailWiseChart = new google.visualization.BarChart(chartContainer);


            google.visualization.events.addListener($detailWiseChart, 'select', onDetailChartSelection);
            $detailWiseChart.draw(view, $detailWiseoptions);



        }
        function onDetailChartSelection() {
            try {
                GetCubicalSummaryData(function () { });
            } catch (e) {

            }
        }

        function GetCubicalSummaryData(callback) {
            debugger;

            var RoomId = $detailWiseDataTable.getValue($detailWiseChart.getSelection()[0].row, 2);
            var CubicalId = "0";
            var data = { RoomId: RoomId, CubicalId: CubicalId }
            serverCall('Services/AssetDashBoard.asmx/GetCubicalDetails', data, function (response) {
                debugger;
                var $responseData = JSON.parse(response);
                var dtRoomList = $responseData.dtRoomList;
                var dtCubic = $responseData.dtCubic;
                drawCubicalDetailChart(dtRoomList, function () {

                    //showHideChart(function () {
                    $('#divCubicalDetailsModel').showModel();
                    //var patientSummaryValueField = $('input:[name=rdoPatientSubCategory]:checked').val();
                    //if (dtCubic[0].TotalAsset != "0") {
                    var chartType = $('#divCubicalDetails').val();
                    drawCubicalDetailSummaryChart(dtCubic, chartType, function () { });
                    //}
                });
                //});

            });
        }
        var $cubicalSummaryoptions = {};
        var $cubicSummaryDataTables = {};
        var $cubicalSummaryCharts = {};
        var view1 = {};
        function drawCubicalDetailSummaryChart(summaryData, summaryValueField, callback) {
            debugger;
            var data = summaryData;
            //var data = summaryData[0];
            $cubicSummaryDataTables.$cubicalWiseSummary = new google.visualization.DataTable();
            $cubicSummaryDataTables.$cubicalWiseSummary.addColumn('string', "Cubic Name");
            $cubicSummaryDataTables.$cubicalWiseSummary.addColumn('number', "TotalAsset");
            $cubicSummaryDataTables.$cubicalWiseSummary.addColumn('number', "CubicalId");
            $cubicSummaryDataTables.$cubicalWiseSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                debugger;
                $cubicSummaryDataTables.$cubicalWiseSummary.setCell(i, 0, data[i].Label);
                $cubicSummaryDataTables.$cubicalWiseSummary.setCell(i, 1, data[i].TotalAsset);
                $cubicSummaryDataTables.$cubicalWiseSummary.setCell(i, 2, data[i].Id);
            }
            $cubicalSummaryoptions = {
                title: 'Cubical Analysis',
                height: 200,
                fontName: 'Arial',
                legend: { position: 'bottom', textStyle: { color: 'Black', fontSize: 10, bold: true } },
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };

            view1 = new google.visualization.DataView($cubicSummaryDataTables.$cubicalWiseSummary); //datatable contains col and rows
            view1.setColumns([0, 1, 2]); //only show these column
            view1.hideColumns([2]);

            //data = summaryData[1];
            //$cubicSummaryDataTables.$cubicalSummary = new google.visualization.DataTable();
            //$cubicSummaryDataTables.$cubicalSummary.addColumn('string', "Doctors's");
            //$cubicSummaryDataTables.$cubicalSummary.addColumn('number', summaryValueField);
            //$cubicSummaryDataTables.$cubicalSummary.addRows(data.length);
            //for (var i = 0; i < data.length; i++) {
            //    $cubicSummaryDataTables.$cubicalSummary.setCell(i, 0, data[i].Label);
            //    $cubicSummaryDataTables.$cubicalSummary.setCell(i, 1, data[i].Value);
            //}

            configureCubicSummaryChart(view1, 0, function () { });

        }


        function configureCubicSummaryChart(data, chartType, callback) {
            debugger;
            if (chartType == 0) {
                $cubicalSummaryCharts.$cubicalWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divCubicalDetail'));

            }
            else if (chartType == 1) {
                $cubicalSummaryCharts.$cubicalWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divCubicalDetail'));

            }
            else if (chartType == 2) {
                $cubicalSummaryCharts.$cubicalWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divCubicalDetail'));

            }

            $cubicalSummaryCharts.$cubicalWiseSummaryChart.draw(data, $cubicalSummaryoptions);
            $cubicalSummaryoptions.title = 'Cubical Wise Summary';

            //$cubicalSummaryCharts.$cubicalWiseSummaryChart.draw(data, $cubicalSummaryoptions);
            google.visualization.events.addListener($cubicalSummaryCharts.$cubicalWiseSummaryChart, 'select', cubicalWiseSummaryChartClick);

            //google.visualization.events.addListener($cubicalSummaryCharts.$cubicalWiseSummaryChart, 'select', departmentWiseSummaryChartClick);



        }
        function cubicalWiseSummaryChartClick() {
            debugger;
            var CubicalId = $cubicSummaryDataTables.$cubicalWiseSummary.getValue($cubicalSummaryCharts.$cubicalWiseSummaryChart.getSelection()[0].row, 2);
            var RoomId = "0";
            var data = { RoomId: RoomId, CubicalId: CubicalId }

            //var CubicalId = $patientSummaryDataTables.$departmentWisePatientSummary.getValue($patientSummaryCharts.$departmentWiseSummaryChart.getSelection()[0].row, 0);
            filterPatientDetails('Cubical', data, function () { });
            // FilterPatientDetails
        }
        function filterPatientDetails(chartName, data, callback) {
            debugger;
            serverCall('Services/AssetDashBoard.asmx/GetCubicalDetails', data, function (response) {
                var $responseData = JSON.parse(response);
                var dtRoomList = $responseData.dtRoomList;
                var dtCubic = $responseData.dtCubic;
                //var $responseData = JSON.parse(response);
                //if ($responseData.status) {
                drawCubicalDetailChart(dtRoomList, function () { });
                //    }
            })
        }
        function drawCubicalDetailChart(data, callback) {
            debugger;
            var $cubicalDetails = new google.visualization.DataTable();
            $cubicalDetails.addColumn('string', 'AssetName');
            $cubicalDetails.addColumn('string', 'AssetNo');
            $cubicalDetails.addColumn('string', 'LocationName');
            $cubicalDetails.addColumn('string', 'RoomName');
            $cubicalDetails.addColumn('string', 'CubicalName');
            $cubicalDetails.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $cubicalDetails.setCell(i, 0, data[i].AssetName);
                $cubicalDetails.setCell(i, 1, data[i].AssetNo);
                $cubicalDetails.setCell(i, 2, data[i].LocationName);
                $cubicalDetails.setCell(i, 3, data[i].RoomName);
                $cubicalDetails.setCell(i, 4, data[i].CubicalName);

            }
            $detailWise1options = {
                title: 'Cubical Details',
                height: 100,
                fontName: 'Arial',
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };
            var $cubicalDetailsChart = new google.visualization.Table(document.getElementById('divCubicalDetails'));
            $cubicalDetailsChart.draw($cubicalDetails, $detailWise1options);
            callback(true);
        }
    </script>
    <div id="Pbody_box_inventory">
        <asp:HiddenField ID="hdnId" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Dept Wise Asset Analysis</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Creteria
            </div>
            <div class="row">
                <div class="col-md-5"></div>
                <div class="col-md-3">
                    <label class="pull-left bold">Department </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" runat="server" onchange="GetFloorandAssetCount(this.value,function(){});" ClientIDMode="Static" CssClass="required" TabIndex="2" ToolTip="Select Header"></asp:DropDownList>
                </div>
                <div class="col-md-5"></div>
            </div>
        </div>


        <div id="divMainChart" style="cursor: pointer; background-color: white; display: none" class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-12">
                    <div class="Purchaseheader">Analysis</div>
                    <div style="width: 100%; height: 450px" id="reportSummary"></div>
                </div>
                <div class="col-md-12">
                    <div class="Purchaseheader">
                        Detail Section
                        <select id="ddlChartType" onchange="configureChart($detailResponseData,function () { });" style="float: right; width: 125px; height: 18px">
                            <option value="0">Bar Chart</option>
                            <option value="1">Pie Chart</option>
                            <option value="2">Line Chart</option>
                        </select>
                    </div>
                    <%-- <div class="row col-md-24">
                        <input type="radio" class="divDepartMentWise" checked="checked" name="rdoCategory" value="Department's Name" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />DepartMentWise
                        <input type="radio" class="divDoctorWise" name="rdoCategory" value="Doctor's Name" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />DoctorWise
                        <input type="radio" class="divPanelWise" name="rdoCategory" value="Panel's Name" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />PanelWise
                        <input type="radio" class="divGenderWise" name="rdoCategory" value="Gender" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />GenderWise
                        <input type="radio" class="divPanelGroupWise" name="rdoCategory" value="PanelGroup" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />PanelGroupWise
                        <br />
                        <input type="radio" class="divSourceWise" name="rdoCategory" value="Source" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />SourceWise                        
                        <input type="radio" class="divDiagnosisWise" name="rdoCategory" value="Diagnosis" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />DiagnosisWise
                        <input type="radio" name="rdoCategory" class="divLocalityWise" value="Locality" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />LocalityWise
                    </div>--%>
                    <div class="row col-md-24">
                        <div style="width: 100%; height: 392px" id="divDetails"></div>
                    </div>
                    <%-- <div class="row col-md-24">
                        <span style="text-align: center; margin-left: 170px;">
                            <input type="radio" checked="checked" name="rdoSubCategory" value="Appointment's" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Quantity
                        <input type="radio" name="rdoSubCategory" value="Collection" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Collection
                        <input type="radio" name="rdoSubCategory" value="Revenue" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Revenue
                        <input type="radio" name="rdoSubCategory" value="Discount" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Discount
                        </span>
                    </div>--%>
                </div>
            </div>
        </div>




        <%--style="padding-top: 190px;"--%>
        <div id="divCubicalDetailsModel" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="width: 600px;">
                    <div class="modal-header">

                        <button type="button" class="close btn ItDoseButton" data-dismiss="divCubicalDetailsModel" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Cubical Details</h4>
                    </div>
                    <div class="modal-body">
                        <table width="100%">
                            <tr>
                                <td>

                                    <%--                                    <input type="radio" checked="checked" name="rdoPatientSubCategory" value="Appointment's" onclick="GetPatientSummaryData(function () { });" />Quantity
                                    <input type="radio" name="rdoPatientSubCategory" value="Collection" onclick="GetPatientSummaryData(function () { });" />Collection
                                    <input type="radio" name="rdoPatientSubCategory" value="Revenue" onclick="GetPatientSummaryData(function () { });" />Revenue
                                    <input type="radio" name="rdoPatientSubCategory" value="Discount" onclick="GetPatientSummaryData(function () { });" />Discount--%>

                                    <select class="form-control" id="ddlPatientSummary" onchange="configureCubicSummaryChart(view1,this.value,function () { });" style="width: 131px; padding: 0px; height: 19px; float: right;">
                                        <option value="0">Bar Chart</option>
                                        <option value="1">Pie Chart</option>
                                        <option value="2">Line Chart</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td>

                                    <table width="100%">
                                        <tr>
                                            <td style="width: 99%">
                                                <div id="divCubicalDetail" style="width: 30%; float: left"></div>
                                                <%-- <div id="divDoctorWise" style="width: 14.20%; float: left"></div>
                                                <div id="divPanelWise" style="width: 14.20%; float: left"></div>
                                                <div id="divPanelGroupWise" style="width: 14.20%; float: left"></div>
                                                <div id="divGenderWise" style="width: 14.20%; float: left"></div>
                                                <div id="divDiagnosisWise" style="width: 14.20%; float: left"></div>
                                                <div id="divSourceWise" style="width: 14.20%; float: left"></div>
                                                <div id="divLocalityWise" style="width: 14.20%; float: left"></div>--%>
                                            </td>

                                        </tr>
                                    </table>

                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="height: 200px" id="divCubicalDetails"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer">

                        <button type="button" class="btn ItDoseButton" data-dismiss="divCubicalDetailsModel">Close</button>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

