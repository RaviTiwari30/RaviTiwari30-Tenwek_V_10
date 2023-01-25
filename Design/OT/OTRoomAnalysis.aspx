<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OTRoomAnalysis.aspx.cs" Inherits="Design_OT_OTRoomAnalysis" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', { 'packages': ['corechart'] });

        function drawChart() {
            var data = {
                fromDate: $('#txtFromDate').val(),
                toDate: $('#txtToDate').val(),
            }
            serverCall('OTRoomAnalysis.aspx/GetAnalysis', data, function (response) {
                var res = JSON.parse(response);
                var r = [['OT Name', 'Consume', 'Avilable']];
                res.map(function (s) {
                    r.push([s.Name, s.AvgCon, s.AvilableCon]);
                })

                var title = 'OT-Consumption For ' + data.fromDate + ' to ' + data.toDate;
                configureChart(r, title);
            });

        }



        function configureChart(d, t) {
            var data = google.visualization.arrayToDataTable(d);


            //var dataTable = new google.visualization.DataTable();
            //dataTable.addColumn('string', 'Year');
            //dataTable.addColumn('number', 'Sales');
            //// A column for custom tooltip content
            //dataTable.addColumn({ type: 'string', role: 'tooltip' });
            //dataTable.addRows([
            //  ['2010', 600, '$600K in our first year!'],
            //  ['2011', 1500, 'Sunspot activity made this our best year ever!'],
            //  ['2012', 800, '$800K in 2012.'],
            //  ['2013', 1000, '$1M in sales last year.']
            //]);


            var options = {
                chart: {
                    title: t,
                    //subtitle: 'Sales, Expenses, and Profit: 2014-2017',
                },
                axes: {
                    y: {
                        all: {
                            range: {
                                max: 24,
                                min: 0
                            }
                        }
                    }
                },
                //isStacked: true,
                isStacked:'percent',
                colors: ['red','green'],
                is3D:true,
                bar: { groupWidth: "20%" },
                legend: { },
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('columnchart_material'));

            chart.draw(data, options);
        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b id="pageTitle">OT Room Analysis</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Creteria
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">From Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ClientIDMode="Static" runat="server" ID="txtFromDate"></asp:TextBox>
                    <cc1:CalendarExtender ID="calendarExteFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ClientIDMode="Static" runat="server" ID="txtToDate"></asp:TextBox>
                    <cc1:CalendarExtender ID="calendarExteToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-5"></div>
            </div>
        </div>
        <div style="text-align: center" class="POuter_Box_Inventory">
            <input type="button" value="Search" onclick="drawChart()" class="save margin-top-on-btn" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Analysis
            </div>
            <div class="row">
                <div  class="col-md-4">
                    
                </div>
                <div class="col-md-16">
                    <div id="columnchart_material" style="width: 100%; height: 400px;"></div>
                </div>
                <div class="col-md-4">
                        

                </div>
            </div>
        </div>
    </div>
</asp:Content>

