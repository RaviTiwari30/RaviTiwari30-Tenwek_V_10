<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Graph.aspx.cs" Inherits="Design_DashBoard_Graph" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="js/core.js"></script>
    <script type="text/javascript" src="js/charts.js"></script>
    <script type="text/javascript" src="js/animated.js"></script>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" />
    <style>
        .datestyle {
                width: 100%;
    height: 22px;
    padding-left: 12px;
    font-size: 14px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
    -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
    -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        }
    </style>

    <div id="Pbody_box_inventory" style="width: 1306px;">
        <div class="POuter_Box_Inventory" style="text-align: center; width: 1300px;">
            <div class="row">
                <b>Laboratory Dashboard</b>
            </div>
        </div> 
        <div class="POuter_Box_Inventory" style="width: 1300px;">
            <div class="Purchaseheader">
                Search Option
            </div>
            <div class="row">
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="date" id="txtFormDate" class="datestyle" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="date" id="txtToDate"  class="datestyle"/>
                        </div>
                        <div class="col-md-5" style="text-align: right">
                            <input id="btnSearch" class="savebutton" type="button" value="Search" class="ItDoseButton" onclick="SearchData();" />
                        </div>
                    </div>


                </div>
            </div>
        </div> 
        <div class="POuter_Box_Inventory" style="width: 1300px;">

            <table width="100%">
                <tr>
                    <td style="text-align: center; width: 100%">
                        <div id="divChartDepartmentwiseMain" class="POuter_Box_Inventory" style="display: none; width: 1291px;">
                            <div><strong>Department Wise Test</strong> </div>
                            <div id="divChartDepartmentwise" style="width: 100%; height: 600px;">
                            </div>
                        </div>
                    </td>

                </tr>
                <tr>
                    <td style="text-align: center; width: 100%">
                        <div id="divChartStatusMain" class="POuter_Box_Inventory" style="display: none; width: 1291px; ">
                            <div><strong>Status Wise Test</strong> </div>
                            <div id="divChartStatus" style="width: 100%; height: 600px;"></div>
                        </div>
                    </td>

                </tr>
                <tr>
                    <td style="text-align: center; width: 100%">
                        <div id="divChartLocationMain" class="POuter_Box_Inventory" style="display: none; width: 1291px;">
                            <div><strong>Location Wise Test</strong> </div>
                            <div id="divChartLocation" style="width: 100%; height: 1000px;">
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; width: 100%">
                        <div id="divChartTestMain" class="POuter_Box_Inventory" style="display: none; width: 1291px;">
                            <div><strong>Test Wise Patient</strong> </div>
                            <div id="divChartTest" style="width: 100%; height: 600px;">
                            </div>
                        </div>
                    </td>

                </tr>
            </table>

        </div>
    </div>
    <script type="text/javascript">

        $(document).ready(function () {
            SearchData();
        });

        function SearchData() {
            //     $.blockUI();
            var FromDate = $('#txtFormDate').val();
            var ToDate = $('#txtToDate').val();
            $.ajax({
                url: "Graph.aspx/GetChartData",
                data: JSON.stringify({ FromDate: FromDate, ToDate: ToDate }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                //async: false,
                success: function (result) {
                    TestData1 = $.parseJSON(result.d);

                    var Departmentwise = TestData1.Departmentwise;
                    var Status = TestData1.Status;
                    var Location = TestData1.Location;
                    var Test = TestData1.Test;

                    if (Departmentwise != "") {
                        $('#divChartDepartmentwiseMain').css('display', 'block');// divChartDepartmentwise
                    }
                    if (Status != "") {
                        $('#divChartStatusMain').css('display', 'block');// divChartStatus
                    }
                    if (Location != "") {
                        $('#divChartLocationMain').css('display', 'block');// divChartLocation
                    }
                    if (Test != "") {
                        $('#divChartTestMain').css('display', 'block');//  divChartTest
                    }
                    DrawChartDepartmentWise(Departmentwise);
                    DrawChartStatus(Status);
                    DrawChartLocation(Location);
                    DrawChartTest(Test);

                    //   //   $.unblockUI();

                },
                error: function (xhr, status) {
                    alert(status + "\r\n" + xhr.responseText);
                    window.status = status + "\r\n" + xhr.responseText;
                    //   $.unblockUI();
                }
            });

        }

        function DrawChartDepartmentWise(Departmentwise) {
            var data = Departmentwise;
            am4core.useTheme(am4themes_animated);
            // Themes end
            var chart = am4core.create("divChartDepartmentwise", am4charts.PieChart3D);
            chart.hiddenState.properties.opacity = 0; // this creates initial fade-in
            chart.legend = new am4charts.Legend();
            chart.data = data;

            var series = chart.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "y";
            series.dataFields.category = "label";

        }
        function DrawChartStatus(Status) {
            var data = Status;
            // Themes begin
            am4core.useTheme(am4themes_animated);
            // Themes end 
            // Create chart instance
            var chart = am4core.create("divChartStatus", am4charts.XYChart3D);

            // Add data
            chart.data = data;

            // Create axes
            var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "label";
            categoryAxis.renderer.labels.template.rotation = 270;
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 20;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.rotation = 270;
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";

            var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
            valueAxis.title.text = "Status Wise Patient";
            valueAxis.title.fontWeight = "bold";

            // Create series
            var series = chart.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueY = "y";
            series.dataFields.categoryX = "label";
            series.name = "label";
            series.tooltipText = "{categoryX}: [bold]{valueY}[/]";
            series.columns.template.fillOpacity = .8;

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return chart.colors.getIndex(target.dataItem.index);
            })

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return chart.colors.getIndex(target.dataItem.index);
            })

            chart.cursor = new am4charts.XYCursor();
            chart.cursor.lineX.strokeOpacity = 0;
            chart.cursor.lineY.strokeOpacity = 0;


        }
        function DrawChartLocation(Location) {
            var data = Location;
            am4core.useTheme(am4themes_animated);
            // Themes end
            var chart = am4core.create("divChartLocation", am4charts.PieChart3D);
            chart.hiddenState.properties.opacity = 0; // this creates initial fade-in
            chart.legend = new am4charts.Legend();
            chart.data = data;

            var series = chart.series.push(new am4charts.PieSeries3D());
            series.dataFields.value = "y";
            series.dataFields.category = "label";

        }
        function DrawChartTest(Test) {

            var data = Test;
            // Themes begin
            am4core.useTheme(am4themes_animated);
            // Themes end

            // Create chart instance
            var chart = am4core.create("divChartTest", am4charts.XYChart3D);

            // Add data
            chart.data = data;

            // Create axes
            var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
            categoryAxis.dataFields.category = "label";
            categoryAxis.renderer.labels.template.rotation = 270;
            categoryAxis.renderer.labels.template.hideOversized = false;
            categoryAxis.renderer.minGridDistance = 20;
            categoryAxis.renderer.labels.template.horizontalCenter = "right";
            categoryAxis.renderer.labels.template.verticalCenter = "middle";
            categoryAxis.tooltip.label.rotation = 270;
            categoryAxis.tooltip.label.horizontalCenter = "right";
            categoryAxis.tooltip.label.verticalCenter = "middle";

            var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
            valueAxis.title.text = "Test Wise Patient";
            valueAxis.title.fontWeight = "bold";

            // Create series
            var series = chart.series.push(new am4charts.ColumnSeries3D());
            series.dataFields.valueY = "y";
            series.dataFields.categoryX = "label";
            series.name = "label";
            series.tooltipText = "{categoryX}: [bold]{valueY}[/]";
            series.columns.template.fillOpacity = .8;

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            var columnTemplate = series.columns.template;
            columnTemplate.strokeWidth = 2;
            columnTemplate.strokeOpacity = 1;
            columnTemplate.stroke = am4core.color("#FFFFFF");

            columnTemplate.adapter.add("fill", function (fill, target) {
                return chart.colors.getIndex(target.dataItem.index);
            })

            columnTemplate.adapter.add("stroke", function (stroke, target) {
                return chart.colors.getIndex(target.dataItem.index);
            })

            chart.cursor = new am4charts.XYCursor();
            chart.cursor.lineX.strokeOpacity = 0;
            chart.cursor.lineY.strokeOpacity = 0;
        }
    </script>

    <style type="text/css">
        .amcharts-chart-div > a {
            display: none !important;
        }
    </style>

    <script>
        $(document).ready(function () {
            var currDate = new Date().toISOString('YYYY-MM-dd').substr(0, 10);
            $('#txtFormDate').val(currDate);
            $('#txtToDate').val(currDate);
        });
    </script>
</asp:Content>

