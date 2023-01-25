<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PharmacyAnalysisReport.aspx.cs" Inherits="Design_Store_PharmacyAnalysisReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/moment.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <script type="text/javascript" src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>

    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });
    </script>

    <style type="text/css">
        .Heading
        {
            background-color: #2E4D7B;
            border: 1px solid #2F4F4F;
            color: white;
            cursor: pointer;
            font-family: Arial,Sans-Serif;
            font-size: 12px;
            font-weight: bold;
            margin-top: 5px;
            padding: 5px;
        }

            .Heading:hover
            {
                background-color: #a3c4f3;
                font-size: 14px;
            }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#trDate").show();
            $("#trYear").hide();
            $("#tdProfitSummary").click(function () {
                $("#trDate").show();
                $("#trYear").hide();
                $.blockUI();
                fillDate();
                hide();
                profitSummary();
                $.unblockUI();
            });

            $("#tdSalesTrend").click(function () {
                $("#trDate").hide();
                $("#trYear").show();
                $.blockUI();
                hide();
                salesTrend();
                $.unblockUI();
            });

            $("#tdInventoryAnalysis").click(function () {
                $("#trDate").show();
                $("#trYear").hide();
                $.blockUI();
                fillDate();
                hide();
                inventoryAnalysis();
                $.unblockUI();
            });

            $("#tdConsultantStatistics").click(function () {
                $("#trDate").show();
                $("#trYear").hide();
                $.blockUI();
                fillDate();
                hide();
                consultantStatistics();
                $.unblockUI();
            });

            $("#tdTopSellingProduct").click(function () {
                $("#trDate").show();
                $("#trYear").hide();
                $.blockUI();
                fillDate();
                hide();
                topSellingProducts();
                $.unblockUI();
            });

            $("#tdTopPurchasedProduct").click(function () {
                $("#trDate").show();
                $("#trYear").hide();
                $.blockUI();
                fillDate();
                hide();
                topPurchasedProducts();
                $.unblockUI();
            });

            $("#tdTopSuppliers").click(function () {
                $("#trDate").show();
                $("#trYear").hide();
                $.blockUI();
                fillDate();
                hide();
                topSuppliers();
                $.unblockUI();
            });

            $("#tdTopSalesPerson").click(function () {
                $("#trDate").show();
                $("#trYear").hide();
                $.blockUI();
                fillDate();
                hide();
                topSalesperson();
                $.unblockUI();
            });

            $("#txtFromDate").change(function () {
                ChkDate();
            });

            $("#txtToDate").change(function () {
                ChkDate();
            });

            $("#ddlYear").change(function () {
                updateChart();
            });

        });

        function profitSummary() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/ProfitSummary",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    $("#spnHeader").text("Profit Summary");
                    summary_data = $.parseJSON(result.d)
                    if (result.d != "0") {                        
                        var htmlOutput = $("#scrtProfitSummary").parseTemplate(summary_data);
                        $("#divChartArea").html(htmlOutput);
                        $("#divChartArea").show();
                    }
                    else {                       
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {                  
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function inventoryAnalysis() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/InventoryAnalysis",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    inventory_data = $.parseJSON(result.d)
                    $("#spnHeader").text("Inventory Analysis (for Current Month)");

                    if (result.d != "0") {                        
                        var htmlOutput = $("#scrtInventory").parseTemplate(inventory_data);
                        $("#divChartArea").html(htmlOutput);
                        $("#divChartArea").show();
                    }
                    else {
                        //DisplayMsg("MM04", "lblErrorMsg");
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function topSellingProducts() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/TopSellingProducts",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    toSelling_Data = $.parseJSON(result.d)
                    $("#spnHeader").text("Top 10 Selling Products");

                    if (result.d != "0") {
                        
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'ItemName');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addRows(toSelling_Data.length);

                        for (var i = 0; i < toSelling_Data.length; i++) {
                            dataTable.setCell(i, 0, toSelling_Data[i].ItemName);
                            dataTable.setCell(i, 1, toSelling_Data[i].Amount);
                        }

                        new google.visualization.PieChart(document.getElementById('divChart')).
                        draw(dataTable,
                           {
                               fontName: '"Arial"',
                               is3D: true,
                               chartArea: { left: 20, top: 0, width: "100%", height: "100%" }
                           }
                        );

                        var htmlOutput = $("#scrtTopSelling").parseTemplate(toSelling_Data);
                        $("#divDataTable").html(htmlOutput);
                        $("#divDataTable").show();

                    }
                    else {
                        //DisplayMsg("MM04", "lblErrorMsg");
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function topPurchasedProducts() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/TopPurchasedProducts",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    topPurchased_Data = $.parseJSON(result.d)
                    $("#spnHeader").text("Top 10 Purchased Products");

                    if (result.d != "0") {                       

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'ItemName');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addRows(topPurchased_Data.length);

                        for (var i = 0; i < topPurchased_Data.length; i++) {
                            dataTable.setCell(i, 0, topPurchased_Data[i].ItemName);
                            dataTable.setCell(i, 1, topPurchased_Data[i].Amount);
                        }

                        new google.visualization.PieChart(document.getElementById('divChart')).
                        draw(dataTable,
                           {
                               fontName: '"Arial"',
                               is3D: true,
                               chartArea: { left: 20, top: 0, width: "100%", height: "100%" }
                           }
                        );

                        var htmlOutput = $("#scrtTopPurchased").parseTemplate(toSelling_Data);
                        $("#divDataTable").html(htmlOutput);
                        $("#divDataTable").show();

                    }
                    else {
                        //DisplayMsg("MM04", "lblErrorMsg");
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function consultantStatistics() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/ConsultantStatistics",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    $("#spnHeader").text("Consultant Statistics");
                    consultantStatistics_Data = $.parseJSON(result.d)
                    
                    if (result.d != "0") {                        
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Doctor');
                        dataTable.addColumn('number', 'No of Prescriptions');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addRows(consultantStatistics_Data.length);

                        for (var i = 0; i < consultantStatistics_Data.length; i++) {
                            dataTable.setCell(i, 0, consultantStatistics_Data[i].Doctor);
                            dataTable.setCell(i, 1, consultantStatistics_Data[i].NoOfPrescriptions);
                            dataTable.setCell(i, 2, consultantStatistics_Data[i].Amount);
                        }

                        var viewData = new google.visualization.DataView(dataTable);
                        viewData.setColumns([0, 1,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 1,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            }, 2,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 2,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            }
                        ]);

                        new google.visualization.BarChart(document.getElementById('divChartArea')).
                        draw(viewData,
                           {
                               fontName: '"Arial"',
                               height: 500,
                               width: 700,
                               bar: { groupWidth: '80%' },
                               legend: { position: 'top', maxLines: 3 },
                               annotations: { alwaysOutside: true },
                               chartArea: { left:200,top: 50,right:0,bottom:50,width: '100%' },
                               hAxis: { gridlines: { count: 5 } },
                           }
                        );
                    }
                    else {
                        //DisplayMsg("MM04", "lblErrorMsg");
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function topSuppliers() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/TopSuppliers",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    $("#spnHeader").text("Top 5 Suppliers on the Basis on Purchase Value");
                    suppliers_Data = $.parseJSON(result.d)
                    
                    if (result.d != "0") {                        
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Supplier Name');
                        dataTable.addColumn('number', 'Purchased Amt(₹)');
                        dataTable.addColumn('number', 'No of Purchase');
                        dataTable.addColumn('number', '% of Total Purchase');
                        dataTable.addRows(suppliers_Data.length);

                        for (var i = 0; i < suppliers_Data.length; i++) {
                            dataTable.setCell(i, 0, suppliers_Data[i].LedgerName);
                            dataTable.setCell(i, 1, suppliers_Data[i].NetPurchase);
                            dataTable.setCell(i, 2, suppliers_Data[i].No_Of_GRN);
                            dataTable.setCell(i, 3, suppliers_Data[i].Percent);
                        }

                        var viewData = new google.visualization.DataView(dataTable);
                        viewData.setColumns([0, 1,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 1,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            }, 2,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 2,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            },3,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 3,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            }

                        ]);

                        new google.visualization.BarChart(document.getElementById('divChartArea')).
                        draw(viewData,
                           {
                               fontName: '"Arial"',
                               height: 500,
                               width: 700,
                               bar: { groupWidth: '80%' },
                               legend: { position: 'top', maxLines: 3 },
                               annotations: { alwaysOutside: true },
                               chartArea: { left:200,top: 50,right:0,bottom:50,width: '100%' },
                               hAxis: { gridlines: { count: 5 } },
                           }
                        );
                    }
                    else {
                        //DisplayMsg("MM04", "lblErrorMsg");
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function topSalesperson() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/TopSalesperson",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {                    
                    $("#spnHeader").text("Salesperson Who Recorded Maximum Sales in Pharmacy");
                    salesPerson_Data = $.parseJSON(result.d)
                    
                    if (result.d != "0") {                        
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'SalesPerson');
                        dataTable.addColumn('number', 'Sales Amt(₹)');
                        dataTable.addColumn('number', 'No of Orders');
                        dataTable.addColumn('number', '% of Total Sales');
                        dataTable.addRows(salesPerson_Data.length);

                        for (var i = 0; i < salesPerson_Data.length; i++) {
                            dataTable.setCell(i, 0, salesPerson_Data[i].Employee);
                            dataTable.setCell(i, 1, salesPerson_Data[i].Amount);
                            dataTable.setCell(i, 2, salesPerson_Data[i].NoOfOrders);
                            dataTable.setCell(i, 3, salesPerson_Data[i].Percent);
                        }

                        var viewData = new google.visualization.DataView(dataTable);
                        viewData.setColumns([0, 1,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 1,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            }, 2,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 2,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            },3,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 3,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            }
                        ]);

                        new google.visualization.BarChart(document.getElementById('divChartArea')).
                        draw(viewData,
                           {
                               fontName: '"Arial"',
                               height: 500,
                               width: 700,
                               bar: { groupWidth: '80%' },
                               legend: { position: 'top', maxLines: 3 },
                               annotations: { alwaysOutside: true },
                               chartArea: { left:200,top: 50,right:0,bottom:50,width: '100%' },
                               hAxis: { gridlines: { count: 5 } },
                           }
                        );
                    }
                    else {
                        //DisplayMsg("MM04", "lblErrorMsg");
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function salesTrend() {
            $.ajax({
                url: "PharmacyAnalysisReport.aspx/SalesTrend",
                data: '{Year:"' + $("#ddlYear").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    $("#spnHeader").text("Sales Trend");
                    salesTrend_Data = $.parseJSON(result.d)

                    if (result.d != "0") {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Month');
                        dataTable.addColumn('number', 'Sales Amt(₹)');                        
                        dataTable.addRows(salesTrend_Data.length);

                        for (var i = 0; i < salesTrend_Data.length; i++) {
                            dataTable.setCell(i, 0, salesTrend_Data[i].Month);
                            dataTable.setCell(i, 1, salesTrend_Data[i].Amount);                           
                        }

                        var viewData = new google.visualization.DataView(dataTable);
                        viewData.setColumns([0, 1,
                                            {
                                                calc: 'stringify',
                                                sourceColumn: 1,
                                                type: 'string',
                                                role: 'annotation',
                                                fontSize: 12
                                            }
                        ]);

                        new google.visualization.LineChart(document.getElementById('divChart')).
                        draw(viewData,
                           {
                               fontName: '"Arial"',
                               height: 300,
                               width:500,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );

                        var htmlOutput = $("#scrtSaleTrend").parseTemplate(salesTrend_Data);
                        $("#divDataTable").html(htmlOutput);
                        $("#divDataTable").show();
                    }
                    else {
                        //DisplayMsg("MM04", "lblErrorMsg");
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                  //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function hide() {
            $("#lblErrorMsg").text("");
            $("#divChartArea").html("");
            $("#divChart").html("");
            $("#divDataTable").html("");
        }

        function ChkDate() {   
            hide();
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#lblErrorMsg").text("To date can not be less than from date!");
                    }
                    else {
                        updateChart();
                    }
                }
            });
        }

        function updateChart() {
            var header = $("#spnHeader").text();
            if (header == "Profit Summary") {
                $.blockUI();
                profitSummary();
                $.unblockUI();
            }
            else if (header == "Inventory Analysis (for Current Month)") {
                $.blockUI();
                inventoryAnalysis();
                $.unblockUI();
            }
            else if (header == "Top 10 Selling Products") {
                $.blockUI();
                topSellingProducts();
                $.unblockUI();
            }
            else if (header == "Top 10 Purchased Products") {
                $.blockUI();
                topPurchasedProducts();
                $.unblockUI();
            }
            else if (header == "Consultant Statistics") {
                $.blockUI(); 
                consultantStatistics();
                $.unblockUI();
            }
            else if (header == "Top 5 Suppliers on the Basis on Purchase Value") {
                $.blockUI(); 
                topSuppliers();
                $.unblockUI();
            }
            else if (header == "Salesperson Who Recorded Maximum Sales in Pharmacy") {
                $.blockUI(); 
                topSalesperson();
                $.unblockUI();
            }
            else if (header == "Sales Trend") {
                $.blockUI();
                salesTrend();
                $.unblockUI();
            }
        }

        function fillDate(){
            getDate();           
            var currentDate = moment($('#txtToDate').val(), 'DD-MMMM-yyyy');
            currentDate =new Date(currentDate.format('MMMM DD,YYYY'));
            var firstDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
            $("#txtFromDate").val(moment(firstDate).format('DD-MMMM-YYYY'));
            $("#txtToDate").val(moment(currentDate).format('DD-MMMM-YYYY'));
        }

        function getDate() {
        $.ajax({
            url: "../Common/CommonService.asmx/getDate",
            data: '{}',
            type: "POST",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            async:false,
            success: function (mydata) {
                var data = mydata.d;
                $('#txtToDate').val(data);
            }
        });
    }

    </script>
     <div id="Pbody_box_inventory">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
   <%-- <cc1:ToolkitScriptManager ID="sm" runat="server"></cc1:ToolkitScriptManager>--%>
    <div class="POuter_Box_Inventory" style="text-align: center;">
        <strong>Pharmacy Report Card</strong>
        <br />
        <asp:Label ID="lblErrorMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
    </div>
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            &nbsp;
        </div>
        <div>
            <div style="width: 25%; height: 600px; float: left; border: thin solid #000000;">
                <table id="tblHeader">
                    <tr>
                        <td id="tdProfitSummary" class="Heading">Profit Summary</td>
                    </tr>
                    <tr>
                        <td id="tdSalesTrend" class="Heading">Sales Trend</td>
                    </tr>
                    <tr>
                        <td id="tdInventoryAnalysis" class="Heading">Inventory Analysis</td>
                    </tr>
                    <tr>
                        <td id="tdConsultantStatistics" class="Heading">Consultant Statistics</td>
                    </tr>
                    <tr>
                        <td id="tdTopSellingProduct" class="Heading">Top 10 Selling Products</td>
                    </tr>
                    <tr>
                        <td id="tdTopPurchasedProduct" class="Heading">Top 10 Purchased Products</td>
                    </tr>
                    <tr>
                        <td id="tdTopSuppliers" class="Heading">Top 5 Suppliers on Purchase Basis</td>
                    </tr>
                    <tr>
                        <td id="tdTopSalesPerson" class="Heading">Salesperson Recorded Maximum Sales</td>
                    </tr>
                </table>
            </div>
            <div style="width: 74.5%; height: 600px; float: left; border: thin solid #000000;z-index:10000;">
                <table width="100%">
                    <tr id="trDate">
                        <td style="width: 20%; text-align: right;">From Date :&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                        </td>
                        <td style="width: 20%; text-align: right;">To Date :&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtToDate" runat="server" Width="50%" ClientIDMode="Static" ToolTip="Click To Select Date" />
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </td>
                    </tr>
                     <tr id="trYear">
                         
                         <td style="width: 20%; text-align: right;">Select Year :&nbsp;</td>
                         <td style="width: 20%; text-align: left;">
                             <asp:DropDownList ID="ddlYear" runat="server" ClientIDMode="Static"  ToolTip="Click To Select Year">                             
                             <asp:ListItem Value="2018">2018</asp:ListItem>
                                 <asp:ListItem Value="2019">2019</asp:ListItem>
                             <asp:ListItem Value="2020" Selected="True" >2020</asp:ListItem>                             
                         </asp:DropDownList>
                         </td>
                         <td style="width: 30%;"></td>
                         <td style="width: 30%;"></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" colspan="4">
                            <br />
                            <br />
                            <strong><span id="spnHeader" style="font-size: 12pt"></span></strong>
                            <br />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div id="divChartArea">
                            </div>
                        </td>
                    </tr> 
                    <tr>
                        <td style="width:60%;" colspan="3">
                            <div id="divChart">
                            </div>
                        </td>
                        <td style="width:40%;">
                            <div id="divDataTable">
                            </div>
                        </td>
                    </tr>                    
                </table>
            </div>
        </div>
    </div>
</div>
    <script id="scrtProfitSummary" type="text/html">  
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">		    
            <#       
		    var dataLength=summary_data.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {
                var Ruppee="";  
                var Percent="";     
		        objRow = summary_data[j];
                if(objRow.Rupee=="1"){
                    Ruppee="&#8377;&nbsp;";
                    Percent="";
                }
                else{
                    Ruppee="";
                    Percent="&nbsp;%";
                }                               
		    #>
            <tr>                                    
                <td class="GridViewLabItemStyle" id="tdTitle" style="width:350px;text-align:left;font-size:12pt;"><#=objRow.Title#></td>    
				<td class="GridViewLabItemStyle" id="tdAmount" style="width:200px;text-align:right;font-size:12pt;"><strong><span><#=Ruppee#></span></strong><#=objRow.TotalAmount.toFixed(2)#><strong><span><#=Percent#></span></strong></td>                                     
            </tr>              
		    <#}        
		    #>                    
        </table>      
    </script>

    <script id="scrtInventory" type="text/html">  
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">		    
            <#       
		    var dataLength=inventory_data.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {
                var rupee="";  
                var amount="";                  
		        objRow = inventory_data[j];
                if(objRow.IsRupee=="1"){
                    rupee="&#8377;&nbsp;";
                    amount=parseFloat(objRow.Amount).toFixed(2);
                } 
                else{
                    amount=objRow.Amount;
                }                                            
		    #>
            <tr>                                    
                <td class="GridViewLabItemStyle" id="td1" style="width:500px;text-align:left;font-size:11pt;"><#=objRow.Title#></td>    
				<td class="GridViewLabItemStyle" id="td2" style="width:150px;text-align:right;font-size:11pt;"><strong><span><#=rupee#></span></strong><#=amount#></td>                                     
            </tr>              
		    <#}        
		    #>                    
        </table>      
    </script>

    <script id="scrtTopSelling" type="text/html">  
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">	
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Product Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Sales Amt(&#8377;)</th>
            </tr>	    
            <#       
		    var dataLength=toSelling_Data.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {                               
		        objRow = toSelling_Data[j];                                                         
		    #>
            <tr>                                    
                <td class="GridViewLabItemStyle" style="width:200px;text-align:left;"><#=objRow.ItemName#></td>    
				<td class="GridViewLabItemStyle" style="width:100px;text-align:right;"><#=objRow.Amount.toFixed(2)#></td>                                     
            </tr>              
		    <#}        
		    #>                    
        </table>      
    </script>

    <script id="scrtTopPurchased" type="text/html">  
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">	
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Product Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Paid Amt(&#8377;)</th>
            </tr>	    
            <#       
		    var dataLength=topPurchased_Data.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {                               
		        objRow = topPurchased_Data[j];                                                         
		    #>
            <tr>                                    
                <td class="GridViewLabItemStyle" style="width:200px;text-align:left;"><#=objRow.ItemName#></td>    
				<td class="GridViewLabItemStyle" style="width:100px;text-align:right;"><#=objRow.Amount.toFixed(2)#></td>                                     
            </tr>              
		    <#}        
		    #>                    
        </table>      
    </script>

    <script id="scrtSaleTrend" type="text/html">  
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;margin:0 auto;">	
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Month</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Sales Amt(&#8377;)</th>
            </tr>	    
            <#       
		    var dataLength=salesTrend_Data.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;            
		    for(var j=0;j<dataLength;j++)
		    {                               
		        objRow = salesTrend_Data[j];                                                         
		    #>
            <tr>                                    
                <td class="GridViewLabItemStyle" style="width:200px;text-align:left;"><#=objRow.Month#></td>    
				<td class="GridViewLabItemStyle" style="width:100px;text-align:right;"><#=objRow.Amount.toFixed(2)#></td>                                     
            </tr>              
		    <#}        
		    #>                    
        </table>      
    </script>
</asp:Content>

