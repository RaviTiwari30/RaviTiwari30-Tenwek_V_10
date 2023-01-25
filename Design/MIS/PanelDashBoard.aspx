<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PanelDashBoard.aspx.cs" Inherits="Design_MIS_PanelDashBoard" Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="../../Styles/BedManagement.css" rel="stylesheet" />

    <style type="text/css">
        .well {
            min-height: 20px;
            padding: 19px;
            margin-bottom: 20px;
            background-color: #f5f5f5;
            border: 1px solid #eee;
            border: 1px solid rgba(0, 0, 0, 0.05);
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
            -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
        }

        .row-fluid .span3 {
            width: 23.404255317%;
        }
    </style>

    <%--  <script type="text/javascript" src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>--%>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });
    </script>

    <div id="Pbody_box_inventory">

        <cc1:ToolkitScriptManager runat="server" ID="scCustom"></cc1:ToolkitScriptManager>
        <asp:Timer ID="Timer1" runat="server" Interval="12000000"></asp:Timer>

        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Billing Dash Board</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
            </div>
        </div>
               <div class="POuter_Box_Inventory">
            <div class="row">
                 <div class="col-md-1"></div>
                                <div class="col-md-2">
                      <label class="pull-left bold">From Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"></asp:TextBox>
                    <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true" Format="dd-MMM-yyyy" TargetControlID="txtFromDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                      <label class="pull-left bold">To Date </label>
                      <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                 <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"></asp:TextBox>
                 <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Animated="true" Format="dd-MMM-yyyy" TargetControlID="txtToDate"></cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                     <input type="button" class="ItDoseButton" id="btnSearch" value="Search" onclick="return bindDashBoard()" />&nbsp;
                </div>
                 <div class="col-md-2"></div>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(1)">
                    <span class='icon32 icon-color icon-square-plus'></span>
                    <div class="bigDashBoardHeader">
                        Total IPD Admission
                    </div>
                    <div>
                        <span id="spn1" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(2)">
                    <span class='icon32 icon-color icon-square-plus'></span>
                    <div class="bigDashBoardHeader">
                        Currently IPD Admitted
                    </div>
                    <div>
                        <span id="spn2" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>

<%--                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(3)">
                    <span class='icon32 icon-color icon-square-plus'></span>
                    <div class="bigDashBoardHeader">
                        Total EMG Admission
                    </div>
                    <div>
                        <span id="spn3" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(4)">
                    <span class='icon32 icon-color icon-square-plus'></span>
                    <div class="bigDashBoardHeader">
                        Currently EMG Admitted
                    </div>
                    <div>
                        <span id="spn4" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>--%>
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(7)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Net Revenue
                    </div>
                    <div>
                        <span id="spn7" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(8)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Patient Collection
                    </div>
                    <div>
                        <span id="spn8" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(5)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Revenue
                    </div>
                    <div>
                        <span id="spn5" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(6)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Discount
                    </div>
                    <div>
                        <span id="spn6" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                  <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(11)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Panel Outstanding
                    </div>
                    <div>
                        <span id="spn11" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(12)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Outstanding
                    </div>
                    <div>
                        <span id="spn12" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                
            </div>
            <div class="row">
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(9)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Panel Collection
                    </div>
                    <div>
                        <span id="spn9" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>
                <div class="col-md-6 ShowDashBoardBox top-block" onclick="PanelDashBoardDetails(10)">
                    <span class='icon32 icon-color icon-book'></span>
                    <div class="bigDashBoardHeader">
                        Total Patient Outstanding
                    </div>
                    <div>
                        <span id="spn10" class="spnStyleBigDashBoard">0</span>
                    </div>
                </div>

              
            </div>
        </div>
    </div>
    <div id="divPanelwiseDashBoard" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1050px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divPanelwiseDashBoard" aria-hidden="true">&times;</button>
                    <b class="modal-title"><span id="spnHeader"></span>Detail`s </b>
                    <span id="spnType" style="display: none">0</span>
                </div>
                <div class="modal-body" style="height: 400px;">
                    <div class="row">
                        <div class="col-md-24">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="Purchaseheader" style="text-align: center;">
                                        Tabular Detail`s
                                            <img alt="Export To Excel" src="../../Images/excelexport.gif" style="float: right" title="Export To Excel" onclick="expertToExcel()" />&nbsp;&nbsp;
                                    </div>
                                    <br />
                                    <div class="divPanelWiseDetails" style="width: 100%; max-height: 340px; overflow: auto;"></div>
                                </div>
                                <div class="col-md-12" style="border-left: solid 1px #303e54; min-height: 365px;">
                                    <div class="Purchaseheader" style="text-align: center;">
                                        Graphical Analysis 
                                            <select id="ddlChartType" onchange="configureChart();" style="float: right; width: 125px; height: 18px">
                                                <option value="0">Bar Chart</option>
                                                <option value="1" selected="selected">Pie Chart</option>
                                                <option value="2">Line Chart</option>
                                            </select>&nbsp;&nbsp;
                                    </div>
                                    <br />
                                    <div id="divAnalysis" style="text-align: center; width: 100%"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="divPanelwiseDashBoard">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">

        $(function () {
            bindDashBoard(function () { });
        });


        var bindDashBoard = function () {
            serverCall('PanelDashBoard.aspx/bindPanelSummaryDashBoard', { DateFrom: $('#txtFromDate').val() , DateTo: $('#txtToDate').val() }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    $('#spn1').text(responseData[0].TotalIPDAdmission);
                    $('#spn2').text(responseData[0].CurrentlyIPDAdmitted);
                    $('#spn3').text(responseData[0].TotalEMGAdmission);
                    $('#spn4').text(responseData[0].CurrentlyEMGAdmitted);
                    $('#spn5').text(responseData[0].TotalGrossAmt);
                    $('#spn6').text(responseData[0].TotalDiscAmt);
                    $('#spn7').text(responseData[0].TotalNetAmt);
                    $('#spn8').text(responseData[0].PatientReceiveAmt);
                    $('#spn9').text(responseData[0].PanelReceiveAmt);
                    $('#spn10').text(responseData[0].PatientOutstanding);
                    $('#spn11').text(responseData[0].PanelOutstanding);
                    $('#spn12').text(responseData[0].TotalOutstanding);
                }
                else
                    modelAlert("No Records Found !!!");

            });
        }

        var expertToExcel = function () {
            serverCall('PanelDashBoard.aspx/exportToExcel', { Type: Number($("#spnType").text()), reportName: $('#spnHeader').text() }, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status)
                    window.open(responseData.URL, "_blank");
                else
                    modelAlert(responseData.message);
            });
        }
        var PanelDashBoardDetails = function (type) {

            $("#spnType").text(type);

            var typeName = "";

            if (Number(type) == 1)
                typeName = "Panel Wise IPD Admission";
            else if (Number(type) == 2)
                typeName = "Panel Wise Currently IPD Admitted Patient";
            else if (Number(type) == 3)
                typeName = "Panel Wise Emergency Admission";
            else if (Number(type) == 4)
                typeName = "Panel Wise Currently Emergency Admitted Patient";
            else if (Number(type) == 5)
                typeName = "Panel Wise Total Revenue";
            else if (Number(type) == 6)
                typeName = "Panel Wise Total Discount";
            else if (Number(type) == 7)
                typeName = "Panel Wise Total Net Revenue";
            else if (Number(type) == 8)
                typeName = "Panel Wise Total Patient Collection";
            else if (Number(type) == 9)
                typeName = "Panel Wise Total Collection";
            else if (Number(type) == 10)
                typeName = "Panel Wise Total Patient Outstanding";
            else if (Number(type) == 11)
                typeName = "Panel Wise Total Outstanding";
            else
                typeName = "Total Outstanding";

            serverCall('PanelDashBoard.aspx/bindPanelDashBoardDetails', { Type: type }, function (response) {
                responseData = JSON.parse(response);
                if (responseData.length > 0) {
                    var parseHTML = $('#templatePanelWiseDetails').parseTemplate(responseData);
                    $('.divPanelWiseDetails').html(parseHTML);
                    gridSummary(function () { });
                    drawPanelwiseSummaryChart(responseData);
                    $('#spnHeader').text(typeName);

                    $("#divPanelwiseDashBoard").show();
                }
                else
                    modelAlert("No Records Found !!!");

            });
        }

        var configureChart = function () {
            PanelDashBoardDetails(Number($("#spnType").text()));
        }

        var $PanelwiseSummaryChart = {};
        var $PanelwiseSummaryDataTable = {};
        function drawPanelwiseSummaryChart(data, callback) {
            $PanelwiseSummaryDataTable = new google.visualization.DataTable();
            $PanelwiseSummaryDataTable.addColumn('string', 'Label');
            $PanelwiseSummaryDataTable.addColumn('number', 'Value');

            $PanelwiseSummaryDataTable.addRows(data.length);
            for (var i = 0; i < data.length; i++) {
                $PanelwiseSummaryDataTable.setCell(i, 0, data[i].PanelName);
                $PanelwiseSummaryDataTable.setCell(i, 1, data[i].ValueField);
            }
            var $options = {
                height: 340,
                legend: { position: 'left', textStyle: { color: 'Black', fontSize: 10, bold: true } },
                tooltip: { textStyle: { color: '#FF0000' }, showColorCode: true }
            };

            if ($("#ddlChartType").val() == "0") {
                $PanelwiseSummaryChart = new google.visualization.BarChart(document.getElementById('divAnalysis'));
            }
            else if ($("#ddlChartType").val() == "1") {
                $PanelwiseSummaryChart = new google.visualization.PieChart(document.getElementById('divAnalysis'));
            }
            else {
                $PanelwiseSummaryChart = new google.visualization.LineChart(document.getElementById('divAnalysis'));
            }
            $PanelwiseSummaryChart.draw($PanelwiseSummaryDataTable, $options);
        }

        var gridSummary = function () {
            var totalValue = 0;

            $('.divPanelWiseDetails table tbody tr').each(function () {
                if ($(this).attr('id') != 'trFotter') {
                    totalValue += Number($(this).find('#tdValue').text());
                }
            });

            $('.divPanelWiseDetails table tbody tr').find('.gridTotal').text(precise_round(totalValue, 2));
        }

    </script>

    <script id="templatePanelWiseDetails" type="text/html">

       <table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblPanelWiseDetails" style="width:100%;border-collapse:collapse;">
		<#if(responseData.length>0){#>
		    <thead>
                <tr>
                    <th class='GridViewHeaderStyle'>S.No.</th>
                    <th class='GridViewHeaderStyle'>Panel Name</th>
                    <th class='GridViewHeaderStyle' style="text-align:right;">Value&nbsp;&nbsp;</th>
                </tr>
		    </thead>
		 <#}#>
		    <tbody>

		    <#
		    var dataLength=responseData.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;   
		    var status;
		    for(var j=0;j<dataLength;j++)
		    {

		    objRow = responseData[j];
		
		      #>
                <tr>
                    <td id="tdIndex" class="GridViewLabItemStyle" style="text-align:center; width:20px;"><#=j+1#></td>
                    <td id="tdPanelName" class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.PanelName#></td>
                    <td id="tdValue" class="GridViewLabItemStyle" style="text-align:right; width:150px;"><#=objRow.ValueField#>&nbsp;&nbsp;</td>
				</tr>   

			<#}#>

                <tr id='trFotter'>
                    <th class='GridViewHeaderStyle' colspan="2" style="text-align:right">Total : &nbsp;</th>
                    <th class='GridViewHeaderStyle' style="text-align:right;"><span class="gridTotal">0</span>&nbsp;&nbsp;</th>
                </tr>
        </tbody>
	 </table>    
	</script>
</asp:Content>

