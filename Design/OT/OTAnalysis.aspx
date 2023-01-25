<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OTAnalysis.aspx.cs" Inherits="Design_OT_OTAnalysis" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/BedManagement.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/fusioncharts.js"></script>
    <script type="text/javascript" src="../../Scripts/fusioncharts.theme.fint.js"></script>

    <script type="text/javascript" src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>

    <style type="text/css">
        .tbl {
            width: 100%;
            height: 100% !important;
        }


        .height30 {
            height: 30%;
            background-color:mediumseagreen!important;
        }
         .height40 {
            height: 40%;
             background-color:aquamarine!important;
        }

          .height50 {
            height: 50%;
             background-color:lightpink!important;
        }
         .height70 {
            height: 70%;
             background-color:deeppink!important;
        }

          .height90 {
            height: 90%;
             background-color:red!important;
        }


    </style>

    <script type="text/javascript">
        //global  Variables
        var globalAnalysisData = {};
        var isConfirmed = 1;
        //....*****.....



        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });

        $(document).ready(function () {
            getDepartments(function () {
                getDoctors('All', function () {
                    initFirstView(1);
                });
            });
        });





        var onChartTypeChange = function (chartType) {
            var chartType = Number(chartType);

            if (chartType == 0) {
                bindMeterChart(globalAnalysisData.OTWiseSummary, function () { });
            }
            else if (chartType == 1) {
                configurePieChart();
            }
            else {
                for (var i = 0; i <= 4; i++) {
                    bindBarChart('Div' + i);
                }
            }
        }



        var configurePieChart = function () {
            var data = globalAnalysisData.OTWiseSummary;

            for (var i = 0; i < data.length; i++) {
                var occupiedSlots = data[i].filter(function (s) {
                    if (s.status == isConfirmed) { return s; }
                });

                var c = {
                    occupiedSlots: occupiedSlots.length,
                    avilableSlots: (data[i].length - occupiedSlots.length),
                    renderID: 'Div' + (i + 1),
                    title: 'OT-' + (i + 1) + ' Occupency'
                }

                bindPieChart(c.occupiedSlots, c.avilableSlots, c.renderID, c.title);
            }
        }






        var bindPieChart = function (OS, AS, cid, title) {

            $summaryDataTable = new google.visualization.DataTable();
            $summaryDataTable.addColumn('string', 'Label');
            $summaryDataTable.addColumn('number', 'Value');
            $summaryDataTable.addColumn('string', 'Param');
            $summaryDataTable.addRows(2);

            $summaryDataTable.setCell(0, 0, 'Occupied Slots');
            $summaryDataTable.setCell(0, 1, OS);


            $summaryDataTable.setCell(1, 0, 'Avilable Slots');
            $summaryDataTable.setCell(1, 1, AS);



            var $options = {
                title: title,
                height: 196,
                legend: { position: 'bottom', textStyle: { color: 'Black', fontSize: 10, bold: true } },
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };
            $summaryChart = new google.visualization.PieChart(document.getElementById(cid));
            $summaryChart.draw($summaryDataTable, $options);
        }


        var bindBarChart = function (cid) {
            $summaryDataTable = new google.visualization.DataTable();
            $summaryDataTable.addColumn('string', 'Label');
            $summaryDataTable.addColumn('number', 'Value');
            $summaryDataTable.addColumn('string', 'Param');
            $summaryDataTable.addRows(2);

            $summaryDataTable.setCell(0, 0, 'Occupied Slots');
            $summaryDataTable.setCell(0, 1, 40);


            $summaryDataTable.setCell(1, 0, 'Avilable Slots');
            $summaryDataTable.setCell(1, 1, 60);



            var $options = {
                title: 'OT-1 Occupency',
                height: 196,
                legend: { position: 'bottom', textStyle: { color: 'Black', fontSize: 10, bold: true } },
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };
            $summaryChart = new google.visualization.BarChart(document.getElementById(cid));
            $summaryChart.draw($summaryDataTable, $options);

        }


        var configureChart = function (data, id) {
            FusionCharts.ready(function () {
                var angularChart = new FusionCharts({
                    "type": "angulargauge",
                    "renderAt": id,
                    "width": "198",
                    "height": "196",
                    "dataFormat": "json",
                    "dataSource": {
                        "chart": {
                            "caption": data.title,
                            "subcaption": "Analysis in %",
                            "lowerLimit": "0",
                            "upperLimit": "100",
                            "theme": "fint"
                        },
                        "colorRange": {
                            "color": [
                               {
                                   "minValue": "0",
                                   "maxValue": "25",
                                   "code": "#e44a00"
                               },
                                {
                                    "minValue": "25",
                                    "maxValue": "50",
                                    "code": "FF00FF"
                                },
                               {
                                   "minValue": "50",
                                   "maxValue": "75",
                                   "code": "#f8bd19"
                               },
                               {
                                   "minValue": "75",
                                   "maxValue": "100",
                                   "code": "#6baa01"
                               }
                            ]
                        },
                        "dials": {
                            "dial": [
                               {
                                   "value": data.value
                               }
                            ]
                        }
                    }
                });

                angularChart.render();
            });
        }




        var getDepartments = function (callback) {
            serverCall('../Common/CommonService.asmx/bindDepartment', {}, function (response) {
                var responseData = JSON.parse(response);
                callback($('#ddlDepartment').bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true }));
            })
        }


        var getDoctors = function (departmentID, callback) {
            serverCall('../Common/CommonService.asmx/bindDoctorDept', { Department: departmentID }, function (response) {
                callback($('#ddlDoctor').bindDropDown({ defaultValue: 'All', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true }));
            });
        }


        var initFirstView = function (isRangeSearch) {
            getSearchCriteria(isRangeSearch, function (searchCriteria) {
                getAnalysis(searchCriteria, function (data) {
                    getSummaryAnalysis(data, function (summary) {
                        bindRangeView(summary.OTRangeViewData, function () {
                            bindSumaryView(summary.OTRangeViewData, function () {
                                bindMeterChart(summary.OTWiseSummary, function () {
                                    $('#ddlChartType').val(0);
                                });
                            });
                        });
                    });
                });
            });
        }



        var bindMeterChart = function (data, callback) {
            for (var i = 0; i < data.length; i++) {
                var occupiedSlots = data[i].filter(function (s) {
                    if (s.status == isConfirmed) { return s; }
                });
                var p = precise_round((occupiedSlots.length * 100 / data[i].length), 2);
                configureChart({ value: p, title: 'OT-' + (i + 1) + ' Occupency-' + p + '%' }, 'Div' + (i + 1));
            }
            callback();
        }

        var bindSumaryView = function (rangeSummary, callback) {
            var totalSlots = 0;
            var occupiedSlots = 0;
            for (var i = 0; i < rangeSummary.length; i++) {
                totalSlots = totalSlots + rangeSummary[i].totalSlots;
                occupiedSlots = occupiedSlots + rangeSummary[i].occupiedSlots;
            }

            $('#spnTotalBed').text(totalSlots);
            $('#spnTotalOccupied').text(occupiedSlots);
            $('#spnTotalAvilable').text(totalSlots - occupiedSlots);
            callback();
        }


        var bindRangeView = function (data, callback) {
            OTMonthView = data;
            var s = $('#template_OtMonthView').parseTemplate(OTMonthView);
            $('#divMonthView').html(s);
            callback(OTMonthView);

        }




        var getSummaryAnalysis = function (data, callback) {
            var OTRangeViewData = [];
            var OTWiseSummary = [[], [], [], [], []];
            for (var i = 0; i < data.length; i++) {
                var dayData = data[i];
                var a = {
                    date: dayData.date,
                    displayDate: dayData.displayDate,
                    displayMonth: dayData.displayMonth,
                    occupiedSlots: 0,
                    totalSlots: 0,
                    occupiedPercent: 0,
                    cssClass: 'height30'

                };
                for (var j = 1; j < dayData.schedule.length; j++) {
                    OTWiseSummary[j - 1] = OTWiseSummary[j - 1].concat(dayData.schedule[j]);
                    a.totalSlots = a.totalSlots + dayData.schedule[j].length;
                    a.occupiedSlots = a.occupiedSlots + dayData.schedule[j].filter(function (s) { if (s.status == isConfirmed) { return s; } }).length;
                    a.occupiedPercent = ((a.occupiedSlots * 100) / a.totalSlots);
                    if (a.occupiedPercent < 30) {
                        a.cssClass = 'height30';
                    }

                    if (a.occupiedPercent > 40) {
                        a.cssClass = 'height40';
                    }

                    if (a.occupiedPercent > 50) {
                        a.cssClass = 'height50';
                    }

                    if (a.occupiedPercent > 70) {
                        a.cssClass = 'height70';
                    }

                    if (a.occupiedPercent > 70) {
                        a.cssClass = 'height90';
                    }

                }
                OTRangeViewData.push(a);
            }
            globalAnalysisData = { OTRangeViewData: OTRangeViewData, OTWiseSummary: OTWiseSummary };
            console.log(OTRangeViewData);
            callback(globalAnalysisData)
        }






        var getAnalysis = function (searchCriteria, callback) {
            serverCall('Services/OTAnalysis.asmx/GetAnalysis', searchCriteria, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }





        var getSearchCriteria = function (isRangeSearch, callback) {
            var data = {
                fromDate: $.trim($('#txtFromDate').val()),
                toDate: $.trim($('#txtToDate').val()),
                departmentID: $.trim($('#ddlDepartment').val()),
                doctorID: $.trim($('#ddlDoctor').val()),
                month: $.trim($('#ddlMonth').val()),
                year: $.trim($('#ddlYear').val()),
                isRangeSearch: isRangeSearch,
            }
            callback(data);
        }


        var analyse = function (callback) {
            var analyseType = Number($('#divDetailAnalysis select').val());
            var OTNumber=Number($('#spnOTNumber').text());
            serverCall('Services/OTAnalysis.asmx/Analyse', { slots: globalAnalysisData.OTWiseSummary[OTNumber], analyseType: analyseType }, function (response) {
                var responseData = JSON.parse(response);
                callback(responseData);
            });
        }


        var bindAnalyseDetailSummary = function (data, callback) {
            var divDetailViewRow = $('#divDetailViewRow').html('');
            var _temp = [];
            for (var i = 0; i < data.length; i++) {
                var dateDetail = data[i];
                var _t = '<div  style="margin-bottom:2px;width:240px" class="col-md-6"> <div  class="ShowOTboxed"><div id="dateDetail' + i + '" ></div> </div> </div>';
                divDetailViewRow.append(_t);
                _temp.push({
                    occupiedSlots: dateDetail.value,
                    avilableSlots: (dateDetail.total - dateDetail.value),
                    renderID: 'dateDetail' + i,
                    title: dateDetail.display + ' Occupency'
                });
                bindPieChart(_temp[i].occupiedSlots, _temp[i].avilableSlots, _temp[i].renderID, _temp[i].title);
            }
            callback();
        }


        var onAnalysisTypeChange = function () {
            analyse(function (data) {
                bindAnalyseDetailSummary(data, function () { });
            });
        }

        var onDetailsView = function (OTNumber) {
            $('#spnOTNumber').text(OTNumber);
            analyse(function (data) {
              
                $('#divDetailAnalysis').showModel();
                bindAnalyseDetailSummary(data, function () { });
            });
        }


        var ssss = function (el) {
            getDoctors($(el).find('option:selected').text(), function () { initFirstView(1); })
        }


    </script>



    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b id="pageTitle">OT Analysis</b>
            <cc1:ToolkitScriptManager runat="server"></cc1:ToolkitScriptManager>
        </div>
        <div class="POuter_Box_Inventory">

            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server" onchange="initFirstView(1)" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender runat="server" ID="calendarExteTxtFromDate" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" onchange="initFirstView(1)" ClientIDMode="Static"></asp:TextBox>
                    <cc1:CalendarExtender runat="server" ID="CalendarExtender1" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Analysis Month</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <select onchange="initFirstView(0)" id="ddlMonth">
                        <option value="Jan">Jan</option>
                        <option value="Feb">Feb</option>
                        <option value="Mar">Mar</option>
                        <option value="Jun">Jun</option>
                        <option value="Jul">Jul</option>
                        <option value="Aug">Aug</option>
                        <option value="Sep">Sep</option>
                        <option value="Oct">Oct</option>
                        <option value="Nov">Nov</option>
                        <option value="Dec">Dec</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select onchange="initFirstView(0)"  id="ddlYear">

                        <option value="2018">2018</option>
                        <option value="2017">2017</option>
                    </select>
                </div>





            </div>


            <div class="row">

                <div class="col-md-3">
                    <label class="pull-left">Department</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select onchange="ssss(this)" id="ddlDepartment"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Doctor</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select onchange="initFirstView(1)"  id="ddlDoctor"></select>
                </div>

                <div class="col-md-3">
                    <label class="pull-left">Analysis Using</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <select onchange="onChartTypeChange(this.value)" id="ddlChartType">
                        <option value="0">Meter Chart</option>
                        <option value="1">Pie Chart</option>
                        <%--<option value="2">Bar Chart</option>--%>
                    </select>
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Today Analysis
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div  class="ShowOTboxed">
                        <table cellpadding="0" cellspacing="0" class="tbl">
                            <tr>
                                <td>
                                    <div class="textCenter">
                                        <b>Total Slots  </b>
                                        <br />
                                        <span id="spnTotalBed" class="spnStyle" style="font-size: 50pt; font-weight: 700"></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="height30 label-mediumseagreen">
                                <td>
                                    <div class="textCenter">
                                        OS:<span id="spnTotalOccupied" >0</span > AS:<span  id="spnTotalAvilable"></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="col-md-4">
                    <div style="width: 200px; height: 198px;cursor:pointer" onclick="onDetailsView(0);" class="ShowOTboxed" id="Div1"></div>
                </div>

                <div class="col-md-4">
                    <div style="width: 202px; height: 198px;cursor:pointer" onclick="onDetailsView(1);" class="ShowOTboxed" id="Div2"></div>
                </div>

                <div class="col-md-4">
                    <div style="width: 202px; height: 198px;cursor:pointer" onclick="onDetailsView(2);" class="ShowOTboxed" id="Div3"></div>
                </div>


                <div class="col-md-4">
                    <div style="width: 202px; height: 198px;cursor:pointer" onclick="onDetailsView(3)"   class="ShowOTboxed" id="Div4"></div>
                </div>

                <div class="col-md-4">
                    <div style="width: 201px; height: 198px;cursor:pointer" onclick="onDetailsView(4)"  class="ShowOTboxed" id="Div5"></div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Month Analysis
            </div>
            <div id="divMonthView" class="row">
            </div>
        </div>


    </div>


    <script id="template_OtMonthView" type="text/html">
        

                <#
                     var dataLength=OTMonthView.length;        
                     var objRow;    
                     var cssClass='height30';
                for(var j=0;j<dataLength;j++)
                {
                    objRow = OTMonthView[j];


                       


                    #>  
                    
                   

                    <div style="margin-top: 3px;cursor:pointer" class="col-md-2">
                    <div  style="height:85px;width:96px;" onclick="onOTDetailView(this)" class="ShowOTboxed">
                        <table cellpadding="0" cellspacing="0" class="tbl">
                            <tr>
                                <td>
                                    <div class="textCenter">
                                        <b><#=objRow.displayMonth#></b>
                                        <br />
                                         <span id="Span1" class="spnStyle" style="font-size:10pt;"><#=objRow.displayDate#></span>
                                         <span id="spnDate" class="spnStyle" style="font-size:10pt;display:none"><#=objRow.date#></span> 

                                    </div>
                                </td>
                            </tr>
                            <tr class="label-mediumseagreen
                                <#=objRow.cssClass #>
                                
                                ">
                                <td>
                                    <div style="font-size: 14px;font-weight: bold;" class="textCenter">
                                        OS:<#=objRow.occupiedSlots#> AS:<#=objRow.totalSlots- objRow.occupiedSlots#> 
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    </div>


                       
                

                           

            <#}#>            
         
    </script>






    <script type="text/javascript">


        var onOTDetailView = function (elem) {
            var date = $(elem).find('#spnDate').text();
            $('#txtSchedulingDate').val(date);
            onOTScheduling();
        }




        var $selectSlot = function (elem) {

            var status = $(elem).hasClass("badge-pink");
            var alreadySeletedOT = 0;
            var selectedSlots = $('#divSlotAvailabilityBody').find('.badge-pink');
            if (selectedSlots.length > 0) {
                alreadySeletedOT = Number($(selectedSlots[0]).closest("div[class*='_slotParent']").attr('OT'));
                var selectedOT = Number($(elem).closest("div[class*='_slotParent']").attr('OT'));
                if (alreadySeletedOT != selectedOT) {
                    modelAlert('Signle OT Room  at a time.');
                    return false;
                }
            }

            if (status)
                $(elem).removeClass('badge-pink');
            else
                $(elem).addClass('badge-pink');



            selectedSlots = $('#divSlotAvailabilityBody .badge-pink');

            if (selectedSlots.length > 0) {
                var startTime = $(selectedSlots[0]).find('#spnSlotTime').text().split('-')[0];
                var endTime = $(selectedSlots[selectedSlots.length - 1]).find('#spnSlotTime').text().split('-')[1];


                var firstSelected = Number($(selectedSlots[0]).attr('id'));
                var lastSelected = Number($(selectedSlots[selectedSlots.length - 1]).attr('id'));

                for (var i = firstSelected + 1; i < lastSelected; i++) {
                    $(selectedSlots[0]).closest("div[class*='_slotParent']").find('#' + i).addClass('badge-pink');
                }
            }

        }


        var onOTScheduling = function () {
            var date = $('#txtSchedulingDate').val();
            getOTSchedule({ fromDate: date, day: 0 });
        }


        var onPrevOTScheduling = function () {
            var date = $('#txtSchedulingDate').val();
            getOTSchedule({ fromDate: date, day: -1 });
        }

        var onNextOTScheduling = function () {
            var date = $('#txtSchedulingDate').val();
            getOTSchedule({ fromDate: date, day: 1 });
        }


        var getOTSchedule = function (data) {
            serverCall('../../Design/OT/Services/Scheduling.asmx/GetOTSchedule', data, function (response) {
                var responseData = JSON.parse(response);

                $('#txtSchedulingDate').val(responseData.date);


                var htmlStr = '';
                for (var i = 1; i < responseData.data.length; i++) {
                    htmlStr = htmlStr + '<div OT=' + i + ' style="padding-left: 0px;" class="' + i + '_slotParent ' + (i < responseData.data.length - 1 ? 'col-md-5' : 'col-md-4') + '">' + responseData.data[i] + '</div>';
                }

                $('#divSlotAvailability').find('#divSlotAvailabilityBody').html(htmlStr);
                bindSelectedTime();
                $('#divSlotAvailability').showModel();
                MarcTooltips.add('.badge-purple', 'Already Booked!', {
                    position: 'up',
                    align: 'left'
                });
            });
        }


        var selectSchedule = function (elem) {
            var selectedSlots = $('#divSlotAvailabilityBody .badge-pink');
            if (selectedSlots.length > 0) {
                var startTime = $(selectedSlots[0]).find('#spnSlotTime').text().split('-')[0];
                var endTime = $(selectedSlots[selectedSlots.length - 1]).find('#spnSlotTime').text().split('-')[1];
                var scheduleDate = $('#txtSchedulingDate').val();
                $('#txtOTTiming').val('On ' + scheduleDate + ' From ' + startTime + ' To ' + endTime);
                $('#txtScheduleDate').val(scheduleDate);
                $('#txtScheduleFromTime').val(startTime);
                $('#txtScheduleToTime').val(endTime);
                $('#txtOTNumber').val(Number($(selectedSlots[0]).closest("div[class*='_slotParent']").attr('OT')));
                $('#divSlotAvailability').closeModel();
            }
        }





        var bindSelectedTime = function () {
            var OT = Number($('#txtOTNumber').val());
            var alreadyBookDate = $.trim($('#txtScheduleDate').val());
            var s = $.trim($('#txtSchedulingDate').val());

            if (alreadyBookDate.toLowerCase() != s.toLowerCase())
                return false;


            $('.' + OT + '_slotParent').find('.square').each(function () {

                var timing = $(this).find('#spnSlotTime').text();
                var startTime = $.trim(timing.split('-')[0]);
                var endTime = $.trim(timing.split('-')[1]);

                var fromTime = $.trim($('#txtScheduleFromTime').val());
                var toTime = $.trim($('#txtScheduleToTime').val());
                if (fromTime == startTime)
                    $(this).click();

                if (endTime == toTime)
                    $(this).click();

            });
        }



    </script>





     <div id="divSlotAvailability" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="divSlotAvailability" aria-hidden="true">×</button>

                        <b class="modal-title">OT Date :</b>
                        <asp:TextBox runat="server" ClientIDMode="Static"  onchange="onOTScheduling()" Style="width: 172px" ID="txtSchedulingDate"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calendarExteTxtSchedulingDate" Format="dd-MMM-yyyy" TargetControlID="txtSchedulingDate"></cc1:CalendarExtender>
                        <button style="box-shadow: none;" onclick="onPrevOTScheduling()" type="button">Prev</button>
                        <button style="box-shadow: none;" onclick="onNextOTScheduling()" type="button">Next</button>
                        
                    </div>
                    <div class="modal-body">
                        <div>
                            <div class="row">
                                <div style="" class="col-md-5 textCenter ">
                                    <b class="">OT-1 </b>

                                </div>
                                <div style="" class="col-md-5 textCenter">
                                    <b style="padding-right: 19px">OT-2 </b>
                                </div>
                                <div style="" class="col-md-5 textCenter">
                                    <b style="padding-right: 40px">OT-3 </b>
                                </div>
                                <div style="" class="col-md-5 textCenter ">
                                    <b style="padding-right: 65px">OT-4 </b>
                                </div>
                                <div style="" class="col-md-4 textCenter">
                                    <b style="padding-right: 42px">OT-5 </b>
                                </div>
                            </div>
                            <div id="divSlotAvailabilityBody" style="padding-left: 30px; width: 1020px; height: 370px; overflow: auto" class="row">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-avilable"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Avilable</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-yellow"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Booked</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-purple"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Approved</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-pink"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Selected</b>
                        <button type="button" style="width: 30px; height: 22px; float: left; margin-left: 5px" class="square badge-grey"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Expired</b>
                        <%--   <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px" class="circle badge-info"></button>
                        <b style="float: left; margin-top: 5px; margin-left: 5px">Rejected</b>--%>


                        
                        <button type="button" data-dismiss="divSlotAvailability">Close</button>

                    </div>
                </div>
            </div>
        </div>


     <div id="divDetailAnalysis" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <span id="spnOTNumber" style="display:none">0</span>
                          <b class="modal-title">Analysis :</b>
                          <select onchange="onAnalysisTypeChange()" style="width:200px">
                              <option value="0" >DateWise</option>
                              <option value="1" >DoctorWise</option>
                              <option value="2" >DepartmentWise</option>
                          </select>
                          
                          <button type="button" class="close" data-dismiss="divDetailAnalysis" aria-hidden="true">×</button>

                           
                    </div>
                    <div class="modal-body">
                        <div>
                            <div id="divDetailViewRow"  style="width: 1020px; height: 370px; overflow: auto" class="row">
                                            
                                       <div style="margin-bottom:2px" class="col-md-8">
                                                <div class="ShowOTboxed"></div>                                          
                                       </div>      
                                       <div style="margin-bottom:2px" class="col-md-8">
                                          <div class="ShowOTboxed"></div>
                                       </div>     
                                        <div style="margin-bottom:2px" class="col-md-8">
                                           <div class="ShowOTboxed"></div>
                                           
                                       </div>     
                                       <div style="margin-bottom:2px" class="col-md-8">
                                                <div class="ShowOTboxed"></div>                                          
                                       </div>      
                                       <div style="margin-bottom:2px" class="col-md-8">
                                          <div class="ShowOTboxed"></div>
                                       </div>      
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" data-dismiss="divDetailAnalysis">Close</button>
                    </div>
                </div>
            </div>
        </div>


</asp:Content>

