<%--<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BioMedicalAnalysis.aspx.cs" Inherits="Design_Biomedicalwaste_BioMedicalAnalysis" >--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="BioMedicalAnalysis.aspx.cs" Inherits="Design_Biomedicalwaste_BioMedicalAnalysis" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
    <script type="text/javascript" src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>
    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });
    </script>
    <script type="text/javascript">
        function loadData(fromDate, toDate) {
          
            var SelectedValue = $('input[type=radio][name=rdoactive]:checked').val();
            if (SelectedValue == "BagQuantity" || SelectedValue == "BagWeight") {
                $('.divBagQtyWise').hide();
                $('.divBagWtyWise').hide();
                $('.divDepartMentWise').hide();
                //$('.divDepartMentWise').show();
                $(".divDepartMentWise").find($('input[type=radio][name=rdoCategory][value=Dept]').prop('checked', true));
                $('.divHospitalWise').hide();
                //$('.divHospitalWise').show();

            }
            else if (SelectedValue == "DeptQuantity" || SelectedValue == "DeptWeight") {
                $('.divBagQtyWise').hide();
                $(".divBagQtyWise").find($('input[type=radio][name=rdoCategory][value=BagQty]').prop('checked', false));
                $('.divBagWtyWise').hide();
                $('.divDepartMentWise').hide();
                $('.divHospitalWise').hide();

            }
            else if (SelectedValue == "HosptQuantity" || SelectedValue == "HosptWeight") {
                $('.divBagQtyWise').show();
                $(".divBagQtyWise").find($('input[type=radio][name=rdoCategory][value=BagQty]').prop('checked', true));
                $('.divBagWtyWise').show();
                $('.divDepartMentWise').hide();
                $('.divHospitalWise').hide();

            }
            serverCall('Services/BioMedicalwaste.asmx/LoadData', { fromDate: fromDate, toDate: toDate, SelectedValue: SelectedValue }, function (response) {
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
                    {
                    modelAlert('0 Record Found');
                    document.getElementById('reportSummary').innerHTML = '';
                    document.getElementById('divDetails').innerHTML = '';
                    $('.divBagQtyWise').hide();
                    //$(".divBagQtyWise").find($('input[type=radio][name=rdoCategory][value=BagQty]').prop('checked', true));
                    $('.divBagWtyWise').hide();
                    $('.divDepartMentWise').hide();
                    $('.divHospitalWise').hide();
                }

            });
        }
        var $summaryChart = {};
        var $summaryDataTable = {};
        function drawSummaryChart(data, callback) {
            debugger;
            $summaryDataTable = new google.visualization.DataTable();
            $summaryDataTable.addColumn('string', 'Label');
            $summaryDataTable.addColumn('number', 'Sum');
            $summaryDataTable.addColumn('number', 'BagId');
            $summaryDataTable.addColumn('string', 'BagName');
            $summaryDataTable.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                debugger;
                $summaryDataTable.setCell(i, 0, data[i].Label);
                $summaryDataTable.setCell(i, 1, data[i].Sum);
                $summaryDataTable.setCell(i, 2, data[i].ID);
                $summaryDataTable.setCell(i, 3, data[i].Name);
            }
            var $options = {
                title: 'Bio Medical Analysis',
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
        var BagName = '';
        function onSummaryChartSelection() {
          
            try {
              
                $summarySelected = $summaryDataTable.getValue($summaryChart.getSelection()[0].row, 2);
                BagName = $summaryDataTable.getValue($summaryChart.getSelection()[0].row, 3);
                var SelectedValue = $('input[type=radio][name=rdoactive]:checked').val();
                var data = { fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, SelectedValue: $('input[type=radio][name=rdoactive]:checked').val(), category: $('input:[name=rdoCategory]:checked').val(), BagName: BagName }
                //var data = { selection: $summarySelected, SelectedValue: SelectedValue }
                getDepartmentListByBag(data, function () { });
            } catch (e) {

            }
        }
        function getDepartmentListByBag(data, callback) {
            debugger;
            if (data.SelectedValue == "BagQuantity" || data.SelectedValue == "BagWeight") {
                $('.divBagQtyWise').hide();
                $('.divBagWtyWise').hide();
       
                $('.divDepartMentWise').show();
                //$(".divDepartMentWise").find($('input[type=radio][name=rdoCategory][value=Dept]').prop('checked', true));
                $('.divHospitalWise').show();
            }
            else if (data.SelectedValue == "DeptQuantity") {
                $('.divBagQtyWise').hide();
                //$(".divBagQtyWise").find($('input[type=radio][name=rdoCategory][value=BagQty]').prop('checked', false));
                $('.divBagWtyWise').hide();
                $('.divDepartMentWise').hide();
                $('.divHospitalWise').hide();
                data.category = "BagQty"
            }
            else if (data.SelectedValue == "DeptWeight") {
                $('.divBagQtyWise').hide();
                //$(".divBagQtyWise").find($('input[type=radio][name=rdoCategory][value=BagQty]').prop('checked', false));
                $('.divBagWtyWise').hide();
                $('.divDepartMentWise').hide();
                $('.divHospitalWise').hide();
                data.category = "BagWty"
            }
            else if (data.SelectedValue == "HosptQuantity" || data.SelectedValue == "HosptWeight") {
                $('.divBagQtyWise').show();
                //$(".divBagQtyWise").find($('input[type=radio][name=rdoCategory][value=BagQty]').prop('checked', true));
                $('.divBagWtyWise').show();
                $('.divDepartMentWise').hide();
                $('.divHospitalWise').hide();
            }
            serverCall('Services/BioMedicalwaste.asmx/getDepartmentListByBag', data, function (response) {
                debugger;
                var $responseData = JSON.parse(response);
                //if ($responseData.status) {
                if ($responseData.length > 0) {
                    $detailResponseData = $responseData;
                    configureChart($responseData, function () { });
                }
                else {
                    $detailWiseChart = {};
                    $detailWiseDataTable = {};
                    $detailWiseoptions = {};
                    document.getElementById('divDetails').innerHTML = '';
                    modelAlert('0 Record Found');
                }

                //}
                //else
                //    modelAlert('Error While Load Data');
            });
        }
        function configureChart(data, callback) {
          
            var $reportName = '';
            var category = $('input:[name=rdoCategory]:checked').val()

            if (category == "Dept") {

                $reportName = 'Department wise Analysis for  ' + BagName + '';
            }
            else if (category == "Hospt") {
                $reportName = 'Hospital wise Analysis for  ' + BagName + '';
            }
            else if (category == "BagQty") {
                $reportName = 'Bag Quantity wise Analysis for  ' + BagName + '';
            }
            else if (category == "BagWty") {
                $reportName = 'Bag Weight wise Analysis for  ' + BagName + '';
            }

            var $labelName = 'Department Name'
            var $valueName = 'Sum';
            //var $roomId = 'RoomId';
            var $chartType = document.getElementById('ddlChartType').value;
            var $chartContainer = document.getElementById('divDetails');
            drawDetailWiseChart(data, $reportName, $labelName, $valueName, $chartType, $chartContainer, function () {
            });
        }
        function drawDetailWiseChart(data, chartName, labelName, valueName, chartType, chartContainer, callback) {
          
            $detailWiseDataTable = new google.visualization.DataTable();
            $detailWiseDataTable.addColumn('string', labelName);
            $detailWiseDataTable.addColumn('number', valueName);
            $detailWiseDataTable.addColumn('number', 'Department');
            $detailWiseDataTable.addColumn('number', 'BagId');
            $detailWiseDataTable.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
              
                $detailWiseDataTable.setCell(i, 0, data[i].Label);
                $detailWiseDataTable.setCell(i, 1, data[i].SUM);
                $detailWiseDataTable.setCell(i, 2, data[i].Id);
                $detailWiseDataTable.setCell(i, 3, data[i].BId);


            }
            $detailWiseoptions = {
                title: chartName,
                height: 390,
                fontName: 'Arial',
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };


            var view = new google.visualization.DataView($detailWiseDataTable); //datatable contains col and rows
            view.setColumns([0, 1, 2, 3]); //only show these column
            view.hideColumns([2, 3]);


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
                GetBagandDeptSummaryData(function () { });
            } catch (e) {

            }
        }
        function GetBagandDeptSummaryData(callback) {
          
            var BId = $detailWiseDataTable.getValue($detailWiseChart.getSelection()[0].row, 3);
            var selection = $detailWiseDataTable.getValue($detailWiseChart.getSelection()[0].row, 2);
            var SelectedValue = $('input[type=radio][name=rdoactive]:checked').val();
            if (SelectedValue == "DeptQuantity") {
                var category = "BagQty";
            }
            else if (SelectedValue == "DeptWeight") {
                var category = "BagWty";
            }
            else {
                var category = $('input:[name=rdoCategory]:checked').val();
            }
            //var category = $('input:[name=rdoCategory]:checked').val()
            var data = { selection: selection, SelectedValue: SelectedValue, BagId: BId, category: category }


            serverCall('Services/BioMedicalwaste.asmx/GetBagandDeptSummaryDetails', data, function (response) {
              
                var $responseData = JSON.parse(response);
                drawCubicalDetailChart($responseData, function () {
                    $('#divGetSumrizeDetailsModel').showModel();


                });

            });
        }

        function drawCubicalDetailChart(data, callback) {
          
            var $cubicalDetails = new google.visualization.DataTable();
            $cubicalDetails.addColumn('string', 'Date');
            $cubicalDetails.addColumn('string', 'Time');
            $cubicalDetails.addColumn('string', 'BagName');
            $cubicalDetails.addColumn('string', 'DispatchedBy');
            $cubicalDetails.addColumn('number', 'Quantity');
            $cubicalDetails.addColumn('number', 'Weight');
            $cubicalDetails.addColumn('string', 'Remark');
            $cubicalDetails.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $cubicalDetails.setCell(i, 0, data[i].DATE);
                $cubicalDetails.setCell(i, 1, data[i].TIME);
                $cubicalDetails.setCell(i, 2, data[i].BagName);
                $cubicalDetails.setCell(i, 3, data[i].DispatchedBy);
                $cubicalDetails.setCell(i, 4, data[i].Quantity);
                $cubicalDetails.setCell(i, 5, data[i].Weight);
                $cubicalDetails.setCell(i, 6, data[i].Remark);

            }
            $detailWise1options = {
                title: 'Cubical Details',
                height: 100,
                fontName: 'Arial',
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };
            var $cubicalDetailsChart = new google.visualization.Table(document.getElementById('divBagDetails'));
            $cubicalDetailsChart.draw($cubicalDetails, $detailWise1options);
            callback(true);
        }

    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Bio Medical  Analysis</b>
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
                    <asp:TextBox ID="txtFromDate" runat="server" AutoComplete="off" TabIndex="1" ToolTip="Select From Date" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left bold">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtToDate" AutoComplete="off" runat="server" TabIndex="1" ToolTip="Select From Date" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <input type="button" value="LoadData" style="width: 90px; font-weight: bold" class="ItDoseButton" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />
                </div>
                <div class="col-md-5"></div>


            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="row col-md-24">
                    <input type="radio" class="divBagQuantityWise" name="rdoactive" value="BagQuantity" checked="checked" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />Bag Type Quantity Wise
                       <input type="radio" class="divBagWeightWise" name="rdoactive" value="BagWeight" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />Bag Type Weight Wise</br>
                        <input type="radio" class="divDeptQuantityWise" name="rdoactive" value="DeptQuantity" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />Department Dispatch Quantity Wise
                        <input type="radio" class="divDeptWeightWise" name="rdoactive" value="DeptWeight" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />Department Dispatch Weight Wise</br>
                        <input type="radio" class="divHospitalQuantityWise" name="rdoactive" value="HosptQuantity" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />Hospital Dispatch Quantity Wise
                        <input type="radio" class="divHospitalWeightWise" name="rdoactive" value="HosptWeight" onclick="loadData($('#txtFromDate').val(), $('#txtToDate').val())" />Hospital Dispatch Weight Wise                        

                </div>
            </div>
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
                <div class="row col-md-24">
                    <div class="divDepartMentWise">
                        <input type="radio" checked="checked" name="rdoCategory" value="Dept" onclick="getDepartmentListByBag({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, SelectedValue: $('input[type=radio][name=rdoactive]:checked').val(), category: $('input:[name=rdoCategory]:checked').val(), BagName: BagName }, function () { });" />DepartMent Wise Pending
                    </div>
                    <div class="divDepartMentWise">
                        <input type="radio" checked="checked" name="rdoCategory" value="DeptRecieve" onclick="getDepartmentListByBag({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, SelectedValue: $('input[type=radio][name=rdoactive]:checked').val(), category: $('input:[name=rdoCategory]:checked').val(), BagName: BagName }, function () { });" />DepartMent Wise Recieve
                    </div>
                    <div class="divHospitalWise">
                        <input type="radio" name="rdoCategory" value="Hospt" onclick="getDepartmentListByBag({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, SelectedValue: $('input[type=radio][name=rdoactive]:checked').val(), category: $('input:[name=rdoCategory]:checked').val(), BagName: BagName }, function () { });" />Hospital Wise Dispatch
                    </div>
                    <div class="divBagQtyWise">
                        <input type="radio" name="rdoCategory" value="BagQty" onclick="getDepartmentListByBag({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, SelectedValue: $('input[type=radio][name=rdoactive]:checked').val(), category: $('input:[name=rdoCategory]:checked').val(), BagName: BagName }, function () { });" />Bag Quantity Wise Dispatch
                    </div>
                    <div class="divBagWtyWise">
                        <input type="radio" name="rdoCategory" value="BagWty" onclick="getDepartmentListByBag({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, SelectedValue: $('input[type=radio][name=rdoactive]:checked').val(), category: $('input:[name=rdoCategory]:checked').val(), BagName: BagName }, function () { });" />Bag Weight Wise Dispatch
                    </div>
                    <%-- <input type="radio" class="divPanelGroupWise" name="rdoCategory" value="PanelGroup" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />PanelGroupWise
                        <br />
                        <input type="radio" class="divSourceWise" name="rdoCategory" value="Source" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />SourceWise                        
                        <input type="radio" class="divDiagnosisWise" name="rdoCategory" value="Diagnosis" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />DiagnosisWise
                        <input type="radio" name="rdoCategory" class="divLocalityWise" value="Locality" onclick="getDoctorsList({ fromDate: document.getElementById('txtFromDate').value, toDate: document.getElementById('txtToDate').value, selection: $summarySelected, category: $('input:[name=rdoCategory]:checked').val(), subCategory: $('input:[name=rdoSubCategory]:checked').val() }, function () { });" />LocalityWise--%>
                </div>
                <div class="row col-md-24">
                    <div style="width: 100%; height: 392px" id="divDetails"></div>
                </div>

            </div>
        </div>




        <%--style="padding-top: 190px;"--%>
        <div id="divGetSumrizeDetailsModel" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content" style="width: 613px;">
                    <div class="modal-header">

                        <button type="button" class="close btn ItDoseButton" data-dismiss="divGetSumrizeDetailsModel" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">Details</h4>
                    </div>
                    <div class="modal-body">
                        <table width="100%">
                            <tr>
                                <td>
                                    <div style="height: 200px" id="divBagDetails"></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="modal-footer">

                        <button type="button" class="btn ItDoseButton" data-dismiss="divGetSumrizeDetailsModel">Close</button>

                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

