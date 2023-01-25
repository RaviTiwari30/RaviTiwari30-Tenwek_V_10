<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Mis.aspx.cs" Inherits="Design_EDP_Mis" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">


        .google-visualization-table-td {
            font-family: arial, helvetica;
            font-size: 9pt;
            cursor: default;
            margin: 0;
            background: white;
            border-spacing: 0;
        }
    </style>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
    <script type="text/javascript" src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });
    </script>
    <script type="text/javascript">
        function loadData(fromDate, toDate) {
            serverCall('./Services/MISServices.asmx/LoadData', { fromDate: fromDate, toDate: toDate }, function (response) {
                var $responseData = JSON.parse(response);
                modelAlert($responseData.data);
                if ($responseData.status)
                    $searchData(fromDate, toDate);
            });
        }

        var $searchData = function (fromDate, toDate) {
            $('#divMainChart').slideUp();
            serverCall('./Services/MISServices.asmx/GetSearchResult', { fromDate: fromDate, toDate: toDate }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    if ($responseData.data.length > 0) {
                        $('#divMainChart').slideDown();
                        drawSummaryChart($responseData.data, function () {
                            $detailWiseChart = {};
                            $detailWiseDataTable = {};
                            $detailWiseoptions = {};
                            document.getElementById('divDetails').innerHTML = '';
                        });
                    }
                    else
                        modelAlert('0 Record Found');
                }
                else
                    modelAlert('Error While Load Data');

            });
        }

        var $summaryChart = {};
        var $summaryDataTable = {};
        function drawSummaryChart(data, callback) {
            $summaryDataTable = new google.visualization.DataTable();
            $summaryDataTable.addColumn('string', 'Label');
            $summaryDataTable.addColumn('number', 'Value');
            $summaryDataTable.addColumn('string', 'Param');
            $summaryDataTable.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $summaryDataTable.setCell(i, 0, data[i].Label);
                $summaryDataTable.setCell(i, 1, data[i].Value);
                $summaryDataTable.setCell(i, 2, data[i].Param);
            }
            var $options = {
                title: 'Appointment Analysis',
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
            try {
                $summarySelected = $summaryDataTable.getValue($summaryChart.getSelection()[0].row, 2);
                var data = { fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }
                getDoctorsList(data, function () { });
            } catch (e) {

            }
        }

        function getDoctorsList(data, callback) {
            serverCall('./Services/MISServices.asmx/GetDoctorsList', data, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    if ($responseData.data.length > 0) {
                        $detailResponseData = $responseData.data;
                        configureChart($responseData.data, function () { });
                    }
                    else
                        modelAlert('0 Record Found');

                }
                else
                    modelAlert('Error While Load Data');
            });
        }

        function configureChart(data, callback) {
            var $reportName = 'Appointment ' + $('input:[name=rdoCategory]:checked').val() + 'wise Analysis';
            var $labelName = $('input:[name=rdoCategory]:checked').val();
            var $valueName = $('input:[name=rdoSubCategory]:checked').val();
            var $chartType = document.getElementById('ddlChartType').value;
            var $chartContainer = document.getElementById('divDetails');
            drawDetailWiseChart(data, $reportName, $labelName, $valueName, $chartType, $chartContainer, function () {
            });
        }

        var $detailWiseChart = {};
        var $detailWiseDataTable = {};
        var $detailWiseoptions = {};
        function drawDetailWiseChart(data, chartName, labelName, valueName, chartType, chartContainer, callback) {
            $detailWiseDataTable = new google.visualization.DataTable();
            $detailWiseDataTable.addColumn('string', labelName);
            $detailWiseDataTable.addColumn('number', valueName);
            $detailWiseDataTable.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $detailWiseDataTable.setCell(i, 0, data[i].Label);
                $detailWiseDataTable.setCell(i, 1, data[i].Value);
            }
            $detailWiseoptions = {
                title: chartName,
                height: 390,
                fontName: 'Arial',
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };
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

            google.visualization.events.addListener($detailWiseChart, 'select', onDetailChartSelection);
            $detailWiseChart.draw($detailWiseDataTable, $detailWiseoptions);

        }





        function onDetailChartSelection() {
            try {
                GetPatientSummaryData(function () { });
            } catch (e) {

            }
        }

        function GetPatientSummaryData(callback) {
            var patientDetailValueField = $('input[name=rdoPatientSubCategory]:checked').val();
            var selectedValue = $detailWiseDataTable.getValue($detailWiseChart.getSelection()[0].row, 0);
            var data = { fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), detailSelection: selectedValue, patientDetailValueField: patientDetailValueField }
            serverCall('./Services/MISServices.asmx/GetPatientDetails', data, function (response) {
                var $responseData = JSON.parse(response);
                debugger;
                if ($responseData.status) {
                    drawPatientDetailChart($responseData.data, function () {
                        showHideChart(function () {
                            $('#divPatientDetailsModel').showModel();
                            var patientSummaryValueField = $('input:[name=rdoPatientSubCategory]:checked').val();
                            var chartType = $('#ddlPatientSummary').val();
                            drawPatientDetailSummaryChart($responseData.summaryData, patientSummaryValueField, chartType, function () { });
                        });
                    });
                }
                else
                    modelAlert($responseData.data);
            });
        }





        function drawPatientDetailChart(data, callback) {
            var $patientDetails = new google.visualization.DataTable();
            $patientDetails.addColumn('string', 'PatientID');
            $patientDetails.addColumn('string', 'Patient Name');
            $patientDetails.addColumn('string', 'Date');
            $patientDetails.addColumn('string', 'Doctor');
            $patientDetails.addColumn('string', 'Department');
            $patientDetails.addColumn('string', 'Gender');
            $patientDetails.addColumn('string', 'Panel');
            $patientDetails.addColumn('string', 'Sub-Group');
            $patientDetails.addColumn('string', 'City');
            $patientDetails.addColumn('number', 'Discount');
            $patientDetails.addColumn('number', 'Amount');
            $patientDetails.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientDetails.setCell(i, 0, data[i].PatientID);
                $patientDetails.setCell(i, 1, data[i].PName);
                $patientDetails.setCell(i, 2, data[i].DateofApp);
                $patientDetails.setCell(i, 3, data[i].Doctor);
                $patientDetails.setCell(i, 4, data[i].Department);
                $patientDetails.setCell(i, 5, data[i].Sex);
                $patientDetails.setCell(i, 6, data[i].Panel);
                $patientDetails.setCell(i, 7, data[i].SubGroup);
                $patientDetails.setCell(i, 8, data[i].City);
                $patientDetails.setCell(i, 9, data[i].DiscountOnTotal);
                $patientDetails.setCell(i, 10, data[i].NetAmount);
            }

            var $patientDetailsChart = new google.visualization.Table(document.getElementById('divPatientDetails'));
            $patientDetailsChart.draw($patientDetails, $detailWiseoptions);
            callback(true);
        }

        var $patientSummaryoptions = {};
        var $patientSummaryDataTables = {};
        var $patientSummaryCharts = {};
        function drawPatientDetailSummaryChart(summaryData, summaryValueField, callback) {
            var data = summaryData[0];
            $patientSummaryDataTables.$departmentWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$departmentWisePatientSummary.addColumn('string', "DepartMent's");
            $patientSummaryDataTables.$departmentWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$departmentWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$departmentWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$departmentWisePatientSummary.setCell(i, 1, data[i].Value);
            }
            $patientSummaryoptions = {
                title: 'Department Wise',
                height: 200,
                fontName: 'Arial',
                legend: { position: 'bottom', textStyle: { color: 'Black', fontSize: 10, bold: true } },
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };

            data = summaryData[1];
            $patientSummaryDataTables.$doctorWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$doctorWisePatientSummary.addColumn('string', "Doctors's");
            $patientSummaryDataTables.$doctorWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$doctorWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$doctorWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$doctorWisePatientSummary.setCell(i, 1, data[i].Value);
            }

            data = summaryData[2];
            $patientSummaryDataTables.$panelWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$panelWisePatientSummary.addColumn('string', "Panel's");
            $patientSummaryDataTables.$panelWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$panelWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$panelWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$panelWisePatientSummary.setCell(i, 1, data[i].Value);
            }


            data = summaryData[3];
            $patientSummaryDataTables.$genderWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$genderWisePatientSummary.addColumn('string', "Panel's");
            $patientSummaryDataTables.$genderWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$genderWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$genderWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$genderWisePatientSummary.setCell(i, 1, data[i].Value);
            }


            data = summaryData[4];
            $patientSummaryDataTables.$panelGroupWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$panelGroupWisePatientSummary.addColumn('string', "Panel's");
            $patientSummaryDataTables.$panelGroupWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$panelGroupWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$panelGroupWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$panelGroupWisePatientSummary.setCell(i, 1, data[i].Value);
            }


            data = summaryData[5];
            $patientSummaryDataTables.$diagnosisWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$diagnosisWisePatientSummary.addColumn('string', "Panel's");
            $patientSummaryDataTables.$diagnosisWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$diagnosisWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$diagnosisWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$diagnosisWisePatientSummary.setCell(i, 1, data[i].Value);
            }


            data = summaryData[6];
            $patientSummaryDataTables.$sourceWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$sourceWisePatientSummary.addColumn('string', "Panel's");
            $patientSummaryDataTables.$sourceWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$sourceWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$sourceWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$sourceWisePatientSummary.setCell(i, 1, data[i].Value);
            }


            data = summaryData[7];
            $patientSummaryDataTables.$localityWisePatientSummary = new google.visualization.DataTable();
            $patientSummaryDataTables.$localityWisePatientSummary.addColumn('string', "Panel's");
            $patientSummaryDataTables.$localityWisePatientSummary.addColumn('number', summaryValueField);
            $patientSummaryDataTables.$localityWisePatientSummary.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $patientSummaryDataTables.$localityWisePatientSummary.setCell(i, 0, data[i].Label);
                $patientSummaryDataTables.$localityWisePatientSummary.setCell(i, 1, data[i].Value);
            }

            configurePatientSummaryChart($patientSummaryDataTables, 0, function () { });

        }


        function configurePatientSummaryChart(data, chartType, callback) {
            debugger;
            if (chartType == 0) {
                $patientSummaryCharts.$departmentWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divDepartMentWise'));
                $patientSummaryCharts.$doctorWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divDoctorWise'));
                $patientSummaryCharts.$panelWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divPanelWise'));
                $patientSummaryCharts.$genderWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divGenderWise'));
                $patientSummaryCharts.$panelGroupWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divPanelGroupWise'));
                $patientSummaryCharts.$diognosisWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divDiagnosisWise'));
                $patientSummaryCharts.$sourceWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divSourceWise'));
                $patientSummaryCharts.$localityWiseSummaryChart = new google.visualization.BarChart(document.getElementById('divLocalityWise'));
            }

            else if (chartType == 1) {
                $patientSummaryCharts.$departmentWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divDepartMentWise'));
                $patientSummaryCharts.$doctorWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divDoctorWise'));
                $patientSummaryCharts.$panelWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divPanelWise'));
                $patientSummaryCharts.$genderWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divGenderWise'));
                $patientSummaryCharts.$panelGroupWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divPanelGroupWise'));
                $patientSummaryCharts.$diognosisWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divDiagnosisWise'));
                $patientSummaryCharts.$sourceWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divSourceWise'));
                $patientSummaryCharts.$localityWiseSummaryChart = new google.visualization.PieChart(document.getElementById('divLocalityWise'));

            }
            else if (chartType == 2) {
                $patientSummaryCharts.$departmentWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divDepartMentWise'));
                $patientSummaryCharts.$doctorWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divDoctorWise'));
                $patientSummaryCharts.$panelWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divPanelWise'));
                $patientSummaryCharts.$genderWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divGenderWise'));
                $patientSummaryCharts.$panelGroupWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divPanelGroupWise'));
                $patientSummaryCharts.$diognosisWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divDiagnosisWise'));
                $patientSummaryCharts.$sourceWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divSourceWise'));
                $patientSummaryCharts.$localityWiseSummaryChart = new google.visualization.LineChart(document.getElementById('divLocalityWise'));
            }

            $patientSummaryCharts.$departmentWiseSummaryChart.draw($patientSummaryDataTables.$departmentWisePatientSummary, $patientSummaryoptions);
            $patientSummaryoptions.title = 'DocotorWise Summary';
            $patientSummaryCharts.$doctorWiseSummaryChart.draw($patientSummaryDataTables.$doctorWisePatientSummary, $patientSummaryoptions);
            $patientSummaryoptions.title = 'PanelWise Summary';
            $patientSummaryCharts.$panelWiseSummaryChart.draw($patientSummaryDataTables.$panelWisePatientSummary, $patientSummaryoptions);
            $patientSummaryoptions.title = 'GenderWise Summary';
            $patientSummaryCharts.$genderWiseSummaryChart.draw($patientSummaryDataTables.$genderWisePatientSummary, $patientSummaryoptions);
            $patientSummaryoptions.title = 'PanelGroupWise Summary';
            $patientSummaryCharts.$panelGroupWiseSummaryChart.draw($patientSummaryDataTables.$panelGroupWisePatientSummary, $patientSummaryoptions);
            $patientSummaryoptions.title = 'DiognosisWise Summary';
            $patientSummaryCharts.$diognosisWiseSummaryChart.draw($patientSummaryDataTables.$diagnosisWisePatientSummary, $patientSummaryoptions);
            $patientSummaryoptions.title = 'SourseWise Summary';
            $patientSummaryCharts.$sourceWiseSummaryChart.draw($patientSummaryDataTables.$sourceWisePatientSummary, $patientSummaryoptions);
            $patientSummaryoptions.title = 'LocalityWise Summary';
            $patientSummaryCharts.$localityWiseSummaryChart.draw($patientSummaryDataTables.$localityWisePatientSummary, $patientSummaryoptions);

            google.visualization.events.addListener($patientSummaryCharts.$departmentWiseSummaryChart, 'select', departmentWiseSummaryChartClick);
            google.visualization.events.addListener($patientSummaryCharts.$doctorWiseSummaryChart, 'select', doctorWiseSummaryChartClick);
            google.visualization.events.addListener($patientSummaryCharts.$panelWiseSummaryChart, 'select', panelWiseSummaryChartClick);
            google.visualization.events.addListener($patientSummaryCharts.$genderWiseSummaryChart, 'select', genderWiseSummaryChartClick);
            google.visualization.events.addListener($patientSummaryCharts.$panelGroupWiseSummaryChart, 'select', panelGroupWiseSummaryChartClick);
            google.visualization.events.addListener($patientSummaryCharts.$diognosisWiseSummaryChart, 'select', diognosisWiseSummaryChartClick);
            google.visualization.events.addListener($patientSummaryCharts.$sourceWiseSummaryChart, 'select', sourceWiseSummaryChartClick);
            google.visualization.events.addListener($patientSummaryCharts.$localityWiseSummaryChart, 'select', localityWiseSummaryChartClick);


        }

        function departmentWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$departmentWisePatientSummary.getValue($patientSummaryCharts.$departmentWiseSummaryChart.getSelection()[0].row, 0);
           filterPatientDetails('Department',$selectedPatientSummaryValue,function(){});
           // FilterPatientDetails
        }

        function doctorWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$doctorWisePatientSummary.getValue($patientSummaryCharts.$doctorWiseSummaryChart.getSelection()[0].row, 0);
           filterPatientDetails('Doctor',$selectedPatientSummaryValue,function(){});
        }

        function panelWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$panelWisePatientSummary.getValue($patientSummaryCharts.$panelWiseSummaryChart.getSelection()[0].row, 0);
            filterPatientDetails('Panel',$selectedPatientSummaryValue,function(){});
        }

        function genderWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$genderWisePatientSummary.getValue($patientSummaryCharts.$genderWiseSummaryChart.getSelection()[0].row, 0);
          filterPatientDetails('Sex',$selectedPatientSummaryValue,function(){});
        }

        function panelGroupWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$panelGroupWisePatientSummary.getValue($patientSummaryCharts.$panelGroupWiseSummaryChart.getSelection()[0].row, 0);
             filterPatientDetails('PanelGroup',$selectedPatientSummaryValue,function(){});
        
        }




        function diognosisWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$diagnosisWisePatientSummary.getValue($patientSummaryCharts.$diognosisWiseSummaryChart.getSelection()[0].row, 0);
             filterPatientDetails('Diagnosis',$selectedPatientSummaryValue,function(){});
        
        }

        function sourceWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$sourceWisePatientSummary.getValue($patientSummaryCharts.$sourceWiseSummaryChart.getSelection()[0].row, 0);
             filterPatientDetails('Source',$selectedPatientSummaryValue,function(){});
            
        
        }

        function localityWiseSummaryChartClick(){
           var $selectedPatientSummaryValue = $patientSummaryDataTables.$localityWisePatientSummary.getValue($patientSummaryCharts.$localityWiseSummaryChart.getSelection()[0].row, 0);
             filterPatientDetails('Locality',$selectedPatientSummaryValue,function(){});
        
        }


        function filterPatientDetails(chartName,patientSummarySelectedValue,callback){
              var selectedValue = $detailWiseDataTable.getValue($detailWiseChart.getSelection()[0].row, 0);
        var data = { fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), detailSelection: selectedValue, chartName: chartName,patientSummarySelectedValue:patientSummarySelectedValue }
              serverCall('./Services/MISServices.asmx/FilterPatientDetails', data, function (response) {
                   var $responseData = JSON.parse(response);
                    if ($responseData.status) {
                       drawPatientDetailChart($responseData.data,function(){});
                    }
              })
        }



       // function summaryDataValueChanged() {
          //  var data = { fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), detailSelection: selectedValue }
         //   var patientSummaryValueField = $('input:[name=rdoPatientSubCategory]:checked').val();
         //   var chartType = $('#ddlPatientSummary').val();
         //   drawPatientDetailSummaryChart($responseData.summaryData, patientSummaryValueField, chartType, function () { });
       // };
        function showHideChart(callback) {
            $('#divDepartMentWise,#divDoctorWise,#divPanelWise,#divPanelGroupWise,#divGenderWise,#divDiagnosisWise,#divSourceWise,#divLocalityWise').show();
            $('input:[name=rdoCategory]').each(function (index, elem) {
                if (this.checked) {
                    var emen = $('#' + this.className);
                    $('#' + this.className).hide();
                    callback(true);
                }
            });
        }

    </script>
   <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Appointment Analysis</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Creteria
            </div>
            <div class="row">
                <div class="col-md-5"></div>
                <div class="col-md-2">
                      <label class="pull-left bold">From Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtFromDate" runat="server" TabIndex="1"  ToolTip="Select From Date" ClientIDMode="Static"  onchange="$searchData($('#txtFromDate').val(),$('#txtToDate').val())"></asp:TextBox>
                     <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                      <label class="pull-left bold">To Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                     <asp:TextBox ID="txtToDate" runat="server" TabIndex="1"  ToolTip="Select From Date" ClientIDMode="Static"  onchange="$searchData($('#txtFromDate').val(),$('#txtToDate').val())"></asp:TextBox>
                     <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                        <input type="button" value="LoadData" style="width: 90px; font-weight: bold" class="ItDoseButton" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />
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
                        <select id="ddlChartType" onchange="configureChart($detailResponseData,function () { });" style="float: right;width:125px;height:18px">
                                <option value="0">Bar Chart</option>
                                <option value="1">Pie Chart</option>
                                <option value="2">Line Chart</option>
                         </select>
                     </div>
                    <div class="row col-md-24">
                    <input type="radio" class="divDepartMentWise" checked="checked" name="rdoCategory" value="Department's Name" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />DepartMentWise
                        <input type="radio" class="divDoctorWise" name="rdoCategory" value="Doctor's Name" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />DoctorWise
                        <input type="radio" class="divPanelWise" name="rdoCategory" value="Panel's Name" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />PanelWise
                        <input type="radio" class="divGenderWise" name="rdoCategory" value="Gender" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />GenderWise
                        <input type="radio" class="divPanelGroupWise" name="rdoCategory" value="PanelGroup" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />PanelGroupWise
                        <br />
                        <input type="radio" class="divSourceWise" name="rdoCategory" value="Source" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />SourceWise                        
                        <input type="radio" class="divDiagnosisWise" name="rdoCategory" value="Diagnosis" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />DiagnosisWise
                        <input type="radio" name="rdoCategory" class="divLocalityWise" value="Locality" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />LocalityWise
                    </div>
                     <div class="row col-md-24">
                         <div style="width: 100%; height: 392px" id="divDetails"></div>
                     </div>
                      <div class="row col-md-24">
                        <span style="text-align: center; margin-left: 170px;">
                        <input type="radio" checked="checked" name="rdoSubCategory" value="Appointment's" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Quantity
                        <input type="radio" name="rdoSubCategory" value="Collection" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Collection
                        <input type="radio" name="rdoSubCategory" value="Revenue" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Revenue
                        <input type="radio" name="rdoSubCategory" value="Discount" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />Discount
                        </span>
                      </div>
                       
                </div>
            </div>
        </div>




        <%--style="padding-top: 190px;"--%>
        <div id="divPatientDetailsModel"  class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="width: 1200px;">
                    <div class="modal-header">

                        <button type="button" class="close btn ItDoseButton" data-dismiss="divPatientDetailsModel" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Patient Details</h4>
                    </div>
                    <div class="modal-body">
                        <table width="100%">
                            <tr>
                                <td>

                                    <input type="radio" checked="checked" name="rdoPatientSubCategory" value="Appointment's" onclick="GetPatientSummaryData(function () { });" />Quantity
                                    <input type="radio" name="rdoPatientSubCategory" value="Collection" onclick="GetPatientSummaryData(function () { });" />Collection
                                    <input type="radio" name="rdoPatientSubCategory" value="Revenue" onclick="GetPatientSummaryData(function () { });" />Revenue
                                    <input type="radio" name="rdoPatientSubCategory" value="Discount" onclick="GetPatientSummaryData(function () { });" />Discount
                                    
                                <select class="form-control" id="ddlPatientSummary" onchange="configurePatientSummaryChart($patientSummaryDataTables,this.value,function () { });" style="width: 131px; padding: 0px; height: 19px; float: right;">
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
                                                <div id="divDepartMentWise" style="width: 14.20%; float: left"></div>
                                                <div id="divDoctorWise" style="width: 14.20%; float: left"></div>
                                                <div id="divPanelWise" style="width: 14.20%; float: left"></div>
                                                <div id="divPanelGroupWise" style="width: 14.20%; float: left"></div>
                                                <div id="divGenderWise" style="width: 14.20%; float: left"></div>
                                                <div id="divDiagnosisWise" style="width: 14.20%; float: left"></div>
                                                <div id="divSourceWise" style="width: 14.20%; float: left"></div>
                                                <div id="divLocalityWise" style="width: 14.20%; float: left"></div>
                                            </td>

                                        </tr>
                                    </table>

                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="height: 200px" id="divPatientDetails"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer">

                        <button type="button" class="btn ItDoseButton" data-dismiss="divPatientDetailsModel">Close</button>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

