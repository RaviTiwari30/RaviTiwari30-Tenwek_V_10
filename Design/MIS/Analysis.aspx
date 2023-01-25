<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Analysis.aspx.cs" Inherits="Design_MIS_Analysis" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="sc" runat="server">
    </Ajax:ScriptManager>
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
    <%--   <script type="text/javascript"  src="../../Scripts/gviz-api.js"></script>
    <script type="text/javascript" src="../../Scripts/jsapi.js"></script>--%>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript" src="../../Scripts/moment.min.js"></script>

    <script type="text/javascript">
        google.load('visualization', '1', { packages: ['corechart'] });
        google.load('visualization', '1', { packages: ['table'] });

    </script>


    <div style="border: none; margin: 35px 1px 1px 1px;" id="Pbody_box_inventory">
        <table style="border: thin solid #000000; vertical-align: top;" id="MainTable">
            <tr>
                <td id="tdLeft" style="vertical-align: top;">
                    <table style="border: thin solid #000000; vertical-align: top">
                        <tr>
                            <td style="width: 100%">
                                <strong>Patient Analysis</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;&nbsp;<span id="spnAnalysis" style="cursor: pointer;">Analysis</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">
                                <strong>OPD</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;&nbsp;<span id="Appointment" style="cursor: pointer;">Appointment</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;&nbsp;<span id="Collection" style="cursor: pointer;">Collection</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="Revenue_OPD" style="cursor: pointer;">Revenue</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="Business_Dept" style="cursor: pointer;">Business</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">
                                <strong>IPD</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="BedOccupancy" style="cursor: pointer;">Bed Occupancy</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="AdmitDischarge" style="cursor: pointer;">Admit-Discharge</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="IPDCollection" style="cursor: pointer;">IPD Collection</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Surgery" style="cursor: pointer;">Surgery (Doctor)</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Surgery_Dpt" style="cursor: pointer;">Surgery (Dpt.)</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Revenue" style="cursor: pointer;">Revenue</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="IPD_Business" style="cursor: pointer;">&nbsp;Business</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="Advance_Bill" style="cursor: pointer;">&nbsp;Advance & Bill</span></td>

                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="spnAdmissionType" style="cursor: pointer;">&nbsp;Admission Type</span></td>

                        </tr>
                         <tr>
                            <td style="width: 100%">
                                <strong>EMG</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="EMGBedOccupancy" style="cursor: pointer;">Bed Occupancy</span>
                            </td>
                        </tr>
                       
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="EMGCollection" style="cursor: pointer;">EMG Collection</span>
                            </td>
                        </tr>
                      
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="EMGRevenue" style="cursor: pointer;">Revenue</span>
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="width: 100%">
                                <strong>Pathology</strong></td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="Path_Investigation" style="cursor: pointer;">&nbsp; Booking</span></td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="Path_DepartmentWiseStatus" style="cursor: pointer;">&nbsp; Status</span></td>
                        </tr>

                        <tr>
                            <td style="width: 100%">
                                <strong>Radiology</strong></td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="Radio_Investigation" style="cursor: pointer;">&nbsp; Booking</span></td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; <span id="Radio_DepartmentWiseStatus" style="cursor: pointer;">&nbsp; Status</span></td>
                        </tr>
                        <tr>
                            <td style="width: 100%">
                                <strong>Purchase</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="po" style="cursor: pointer;">Purchase Order</span>
                            </td>
                        </tr>
                          <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="pos" style="cursor: pointer;">PO Status</span>
                            </td>
                        </tr>
            
                        <tr>
                            <td style="width: 100%">
                                <strong>Store</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="GRN" style="cursor: pointer;">GRN</span>
                            </td>
                        </tr>
                         <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="GRNStatus" style="cursor: pointer;">GRN Status</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Consumption" style="cursor: pointer;">Consumption</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">
                                <strong>Pharmacy</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Sale" style="cursor: pointer;">Sale</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;&nbsp;&nbsp;<span id="ProfitSummary" style="cursor: pointer;">Profit Summary</span>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 100%">&nbsp;&nbsp;&nbsp;<span id="inventoryAnalysis" style="cursor: pointer;">Inventory Analysis </span>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="topSaleProduct" style="cursor: pointer;">Top 10 Sale </span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="topBuyProduct" style="cursor: pointer;">Top 10 Buy </span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="ConsultantStatistics" style="cursor: pointer;">Doctor Statistics</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="TopVendors" style="cursor: pointer;">Top 5 Vendors</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="UserwiseSale" style="cursor: pointer;">UserWise Sale</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="SalesTrend" style="cursor: pointer;">Sales Trend</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">
                                <strong>HR</strong>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Employee" style="cursor: pointer;">Employee</span>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Salary" style="cursor: pointer;">Salary</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp; &nbsp;<span id="Leave" style="cursor: pointer;">Leave</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100%">&nbsp;
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="border: thin solid #000000; vertical-align: top;"  id="tdRight" >
                    <div id="Containerdiv" style="display:none;" >
                    <table style="width: 100%">
                        <tr>
                            <td style="width: 50%" colspan="2">
                                <table style="width: 100%" id="Datetable">
                                    <tr>
                                        <td style="width: 80%">From Date :
                                        <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                            Width="100px" onFocus="(this.name=this.value)" onchange="ChkDate(this.name,this.value)"></asp:TextBox>
                                            <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true" Format="dd-MMM-yyyy"
                                                TargetControlID="txtFromDate">
                                            </cc1:CalendarExtender>
                                            &nbsp;&nbsp;&nbsp;
                                        To Date :
                                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                                Width="100px" onFocus="(this.name=this.value)" onchange="ChkDate(this.name,this.value)"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Animated="true" Format="dd-MMM-yyyy"
                                                TargetControlID="txtToDate">
                                            </cc1:CalendarExtender>
                                            &nbsp;&nbsp;&nbsp;
                                            Centre Name : 
                                        <select id="ddlCentre" style="width: 200px"></select>
                                            &nbsp;&nbsp;&nbsp;
                                            Chart : 
                                            <select id="ddlChartType" onchange="checkSelectedOption();" style="width: 125px; height: 18px">
                                                <option value="0">Pie Chart</option>
                                                <option value="1">Line Chart</option>
                                                <option value="2">Bar Chart</option>
                                            </select>
                                        </td>
                                        <td id="tdSales" style="width: 20%">Select Year :                                        
                             <asp:DropDownList ID="ddlYear" runat="server" Style="width: 125px; height: 18px" ClientIDMode="Static" ToolTip="Click To Select Year">
                                 <asp:ListItem Value="2018">2018</asp:ListItem>
                                 <asp:ListItem Value="2019">2019</asp:ListItem>
                                 <asp:ListItem Value="2020" Selected="True">2020</asp:ListItem>
                             </asp:DropDownList>

                                        </td>
                                    </tr>
                                    <tr>
                            <td id="tdRevenueType">
                                 <input type="radio" class="divDepartMentWise" checked="checked" name="rdoCategory" value="DepartMentWise" onclick="getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });" />DepartMentWise
                        <input type="radio" class="divDoctorWise" name="rdoCategory" value="DoctorWise" onclick="getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });" />DoctorWise
                        <input type="radio" class="divPanelWise" name="rdoCategory" value="PanelWise"  onclick="getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });" />PanelWise
                        <input type="radio" class="divCategoryWise" name="rdoCategory" value="CategoryWise" onclick="getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });" />CategoryWise

                            </td>
                        </tr>
                                </table>
                                <table id="SalaryMonth" style="width: 100%">
                                    <tr>
                                        <td style="width: 100%">Salary Month
                            <asp:TextBox ID="txtSalaryMonth" runat="server" ClientIDMode="Static" ToolTip="Click To Select Salary Month"
                                Width="170px"></asp:TextBox>
                                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Animated="true"
                                                TargetControlID="txtSalaryMonth" BehaviorID="calendar1" Format="MMM-yyyy" OnClientShown="onCalendarShown">
                                            </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                </table>
                            
                            </td>

                        </tr>
                        
                    </table>
                        <div id="AreaDiv">
                        <table style="width: 100%">
                            <tr style="border: 1px solid #a1a1a1;">
                                <td style="width: 50%; vertical-align: top; border: 1px solid #a1a1a1;">
                                    <div id="char1Div" >
                                    </div>
                                </td>
                                <td style="width: 50%; vertical-align: top; border: 1px solid #a1a1a1;">
                                    <div id="chart2Div" >
                                    </div>
                                </td>
                            </tr>
                            <tr style="border: 1px solid #a1a1a1;">
                                <td style="width: 50%; vertical-align: top; border: 1px solid #a1a1a1;">
                                    <div id="tableDiv1" >
                                    </div>
                                </td>
                                <td style="width: 50%; vertical-align: top; border: 1px solid #a1a1a1;">
                                    <div id="tableDiv2" >
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%">
                            <tr style="border: 1px solid #a1a1a1;">
                                <td style="width: 80%; vertical-align: top; border: 1px solid #a1a1a1;">
                                  <div id="divExport" style="text-align: center;">
                                       Detail`s
                                 <img alt="Export To Excel" src="../../Images/excelexport.gif" style="float: right;height:25px; width:25px;" title="Export To Excel" id="excel"  />&nbsp;&nbsp;
                                 <img alt="Export To PDF" src="../../Images/pdfexport.jpg" style="float: right;height:25px; width:25px;" title="Export To PDF" id="pdf"  />&nbsp;&nbsp;

                                    </div>
                                    <br />
                                    <div id="Detail1Div">
                                    </div>
                                </td>
                            </tr>
                        </table>
                            
                    </div>
             <div id="DivRevenueArea">
                        <table style="width: 100%">
                            <tr style="border: 1px solid #a1a1a1;">
                                <td style="width: 50%; vertical-align: top; border: 1px solid #a1a1a1;">
                                    <div id="Revenuechart">
                                    </div>
                                </td>

                            </tr>
                            <tr style="border: 1px solid #a1a1a1;">
                                <td style="width: 50%; vertical-align: top; border: 1px solid #a1a1a1;">
                                    <div id="RevenuechartTable">
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table style="width: 100%">
                            <tr style="border: 1px solid #a1a1a1;">
                                <td style="width: 100%; vertical-align: top; border: 1px solid #a1a1a1;">
                                    <div id="RevenuedivExport" style="text-align: center;">
                                       Detail`s
                                 <img alt="Export To Excel" src="../../Images/excelexport.gif" style="float: right;height:25px; width:25px;" title="Export To Excel" id="RevExcel"  />&nbsp;&nbsp;&nbsp;&nbsp;
                                &nbsp;&nbsp;&nbsp;&nbsp;
                                 <img alt="Export To PDF" src="../../Images/pdfexport.jpg" style="float: right;height:25px; width:25px;" title="Export To PDF" id="RevPDF"  />&nbsp;&nbsp;
                                    </div>
                                    <div id="RevenuechartDetails">
                                    </div>
                                </td>
                            </tr>
                        </table>

                    </div>


                    </div>
                </td>
            </tr>
        </table>

        <input type="hidden" id="hdnchkdate" value="0" />
       
    </div>


    <script type="text/javascript">
        var formatetype = '';

        $('#excel').click(function () {
            formatetype = 0;
            expertToExcel();
        });
        $('#pdf').click(function () {
            formatetype = 1;
            expertToExcel();
        });

        $('#RevExcel').click(function () {
            formatetype = 0;
            expertToExcel();
        });
        $('#RevPDF').click(function () {
            formatetype = 1;
            expertToExcel();
        });


       


        var expertToExcel = function () {
            data = {
                Type: flag,
                FromDate: $('#txtFromDate').val(),
                ToDate: $('#txtToDate').val(),
                CentreID: $('#ddlCentre').val(),
                RevenueType: $('input:[name=rdoCategory]:checked').val(),
                selectedValue: selectedValue,
                emgScreen: emgScreen,
                CategoryID: "<%=GetGlobalResourceObject("Resource", "PathologyCategoryID") %>",
               selectedID: selectedID,
               Pathtype: Pathtype,
              Year: $("#ddlYear").val(),
              formateType: formatetype
            }        
            serverCall('Services/mis.asmx/exportToExcel', data, function (response) {
                var responseData = JSON.parse(response);

                if (responseData.status)
                    window.open(responseData.URL, "_blank");
                else
                    modelAlert(responseData.message);
            });
        }
    

        function GetCenter() {
            $("#ddlCentre option").remove();
            $.ajax({
                url: "Services/mis.asmx/BindMISCenter",
                data: '{UserID:"' + $('#lblUserID').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    Center = jQuery.parseJSON(result.d);
                    if (Center.length == 0) {
                        $("#ddlCentre").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < Center.length; i++) {
                            $("#ddlCentre").append($("<option></option>").val(Center[i].CentreID).html(Center[i].CentreName));
                        }
                        $("#ddlCentre").val('<%=GetGlobalResourceObject("Resource", "DefaultCentreID") %>');
                    }
                },
                error: function (xhr, status) {
                    alert("Error ");
                    $("#ddlCentre").attr("disabled", false);
                }
            });
        }
    </script>
    <script type="text/javascript">
        var cal1;
        function pageLoad() {
            cal1 = $find("calendar1");
            modifyCalDelegates(cal1);
        }
        function modifyCalDelegates(cal) {
            //we need to modify the original delegate of the month cell.
            cal._cell$delegates =
            {
                mouseover: Function.createDelegate(cal, cal._cell_onmouseover),
                mouseout: Function.createDelegate(cal, cal._cell_onmouseout),

                click: Function.createDelegate(cal, function (e) {

                    e.stopPropagation();
                    e.preventDefault();

                    if (!cal._enabled) return;

                    var target = e.target;
                    var visibleDate = cal._getEffectiveVisibleDate();
                    Sys.UI.DomElement.removeCssClass(target.parentNode, "ajax__calendar_hover");
                    switch (target.mode) {
                        case "prev":
                        case "next":
                            cal._switchMonth(target.date);
                            break;
                        case "title":
                            switch (cal._mode) {
                                case "days": cal._switchMode("months"); break;
                                case "months": cal._switchMode("years"); break;
                            }
                            break;
                        case "month":
                            //if the mode is month, then stop switching to day mode.
                            if (target.month == visibleDate.getMonth()) {
                                //this._switchMode("days");
                            }
                            else {
                                cal._visibleDate = target.date;
                                //this._switchMode("days");
                            }
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;

                        case "year":
                            if (target.date.getFullYear() == visibleDate.getFullYear()) {
                                cal._switchMode("months");
                            }
                            else {
                                cal._visibleDate = target.date;
                                cal._switchMode("months");
                            }
                            break;

                        case "today":
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;
                    }

                }

                )
            }
        }

        function onCalendarShown(sender, args) {
            //set the default mode to month
            sender._switchMode("months", true);
            changeCellHandlers(cal1);

        }


        function changeCellHandlers(cal) {
            if (cal._monthsBody) {
                //remove the old handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $common.removeHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
                //add the new handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $addHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
            }
        }
    </script>

    <script type="text/javascript">
        var flag = ""; var emgScreen = ""; var selectedID = ""; var Pathtype = "";
       
        $(window).load(function () {
            
            GetCenter();
            var tablewidth = $(window).width() - 20;
            var Leftwidth = 150;
            var RightWidth = tablewidth - 160;


            $('#MainTable').css('width', tablewidth);
            $('#tdLeft').css('width', Leftwidth);
            $('#tdRight').css('width', RightWidth);



            $('#txtSalaryMonth').change(function () {
                Salary_DeptWise($('#txtSalaryMonth').val());
            });
    
            //for hide all graph div
            hide_Graph();
            $('#spnAnalysis').click(function () {
                flag = 'Analysis'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show();
                    $('#AreaDiv').show();
                    bindPatientAnalysis($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });


            $('#Appointment').click(function () {
                $('#AreaDiv').hide();
                $('#Containerdiv').css('display', 'block');
                flag = 'OPDAppointment';
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {            
                    hide_Graph(); $('#AreaDiv').show();
                    $('#txtFromDate').attr('disabled', true);
                    $('#txtToDate').attr('disabled', true);
                    $('#Datetable').show();
                    OPD_Graph();
                    OPD_Graph_Month();
                    OPD_Graph_Year();
                }

            });



            $('#Employee').click(function () {
                $('#Containerdiv').css('display', 'block');
                hide_Graph();
                $('#HR_Area').show();
                Employee();
                DeptWise_Employee();

            });


            $('#Collection').click(function () {
                flag = 'OPDCollection'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    $('#AreaDiv').show();
                    hide_Graph();
                    $('#Datetable').show();
                    Collection_TypOfTnx($('#txtFromDate').val(), $('#txtToDate').val());
                    OPD_Collection($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

            $('#BedOccupancy').click(function () {
                flag = 'BedOccupancy'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    $('#AreaDiv').show();
                    hide_Graph();
                 
                    $('#Datetable').show();
                    BedAvailable_Graph(); BedOccupancy();
                }

            });

            $('#AdmitDischarge').click(function () {
                flag = 'AdmitDischarge'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                 
                    hide_Graph();              
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Admit_Graph($('#txtFromDate').val(), $('#txtToDate').val());
                    Discharge_Graph($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

            $('#IPDCollection').click(function () {
                flag = 'IPDCollection'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    IPDCollection($('#txtFromDate').val(), $('#txtToDate').val());
                }


            });

            $('#po').click(function () {
                flag = 'PurchageOrder'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    $('#AreaDiv').show();
                    hide_Graph();
                  
                    $('#Datetable').show();
                    PurchaseOrder($('#txtFromDate').val(), $('#txtToDate').val());
                    PurchaseOrderItemStoreWise($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });
            $('#pos').click(function () {
                flag = 'PurchageOrderStatus'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                  
                    hide_Graph();
                    $('#AreaDiv').show();
                    $('#Datetable').show();
                    PurchaseOrderStatus($('#txtFromDate').val(), $('#txtToDate').val());
                    PurchaseRequestStatus($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });
           

            $('#Surgery').click(function () {
                flag = 'IPDSurgeryDoc'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                  
                    hide_Graph();
                    $('#AreaDiv').show();
                    $('#Datetable').show();
                    Surgery_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });
            $('#Surgery_Dpt').click(function () {
                flag = 'IPDSurgeryDpt'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                  
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Surgery_DeptWise($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

            $('#Revenue').click(function () {
                flag = 'IPDRevenue'; $('#tdRevenueType').hide(); $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                
                    hide_Graph();
                 
                    $('#Datetable').show(); $('#tdRevenueType').show(); $('#AreaDiv').show();
                  getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });

                }

            });
            $('#Revenue_OPD').click(function () {
                flag = 'OPDRevenue'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#tdRevenueType').show(); $('#AreaDiv').show();
                    getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });

                }

            });
            $('#Path_Investigation').click(function () {
                flag = 'PathInvestigation'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                  
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Path_InvestigationDetail($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });
            $('#Path_DepartmentWiseStatus').click(function () {
                flag = 'PathDepartmentWiseStatus'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Path_DeptWiseStatus($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });     

            $('#Radio_Investigation').click(function () {
                flag = 'RadioInvestigation'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                
                    hide_Graph();                 
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Radio_Investigation($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });
            $('#Radio_DepartmentWiseStatus').click(function () {
                flag = 'RadioDepartmentWiseStatus'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Radio_DeptWiseStatus($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

            $('#Sale').click(function () {
                flag = 'Sale'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#txtFromDate').attr('disabled', true);
                    $('#txtToDate').attr('disabled', true);
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Sale_DateWise();
                    Sale_MonthWise();
                    Sale_PatientWise();
                }
            });

            $('#GRN').click(function () {
                flag = 'GRN'; $('#Containerdiv').css('display', 'block');
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show(); $('#AreaDiv').hide();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Medical_Purchase($('#txtFromDate').val(), $('#txtToDate').val());
                    General_Purchase($('#txtFromDate').val(), $('#txtToDate').val());
                }


            });

            $('#GRNStatus').click(function () {
                flag = 'GRNStatus'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                   
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                     GRN_Status($('#txtFromDate').val(), $('#txtToDate').val());
                }


            });

            $('#Consumption').click(function () {
                flag = 'Consumption'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                  
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Consumption($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });


            $('#Business_Dept').click(function () {
                flag = 'OPDBusiness'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                
                    hide_Graph();
                  
                    $('#Datetable').show(); $('#AreaDiv').show();
                    OPD_Business_CategoryWise($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

            $('#IPD_Business').click(function () {
                flag = 'IPDbusiness'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#IPD_Business_SubCategoryWise', '#IPD_Business_ItemWise').hide();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    IPD_Business_CategoryWise($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

            $('#Advance_Bill').click(function () {
                flag = 'IPDAdvanceBill'; $('#Containerdiv').css('display', 'block');
                $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                
                    hide_Graph();                 
                    $('#Datetable').show(); $('#AreaDiv').show();
                    Advance_Bill_Detail($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

            $('#Salary').click(function () {
                flag = 'Salary'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').show();
                hide_Graph();
                $('#Salary_Area').show();
                $('#SalaryMonth').show();
                Salary_DeptWise($('#txtSalaryMonth').val());


            });

            $('#Leave').click(function () {
                flag = 'LeaveDetail'; $('#Containerdiv').css('display', 'block');
                hide_Graph();
                $('#Leave_Area').show();
                $('#Datetable').show();
                LeaveDetail($('#txtFromDate').val(), $('#txtToDate').val());


            });

            $('#spnAdmissionType').click(function () {
                flag = 'IPDAdmissionType'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                  
                    hide_Graph();
                    $('#Datetable').show();
                    $('#AreaDiv').show();
                    bindIPDAdmissionType($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

           
            $('#ProfitSummary').click(function () {
                flag = 'Profit'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    bindProfitSummary($('#txtFromDate').val(), $('#txtToDate').val());
                }
            });

            $("#inventoryAnalysis").click(function () {
                $('#tdSales').hide(); $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {                  
                    flag = 'Inventory';
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    inventoryAnalysis($('#txtFromDate').val(), $('#txtToDate').val());
                }
            });
            $("#ConsultantStatistics").click(function () {
                flag = 'DoctorStatistics'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
   
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    consultantStatistics($('#txtFromDate').val(), $('#txtToDate').val());
                }
            });
            $("#topSaleProduct").click(function () {
                flag = 'TopSale'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    topSellingProducts($('#txtFromDate').val(), $('#txtToDate').val());
                }
            });

            $("#topBuyProduct").click(function () {
                flag = 'TopBuy'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                  
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    topPurchasedProducts($('#txtFromDate').val(), $('#txtToDate').val());
                }
            });

            $("#TopVendors").click(function () {
                flag = 'TopVendors'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    topSuppliers($('#txtFromDate').val(), $('#txtToDate').val());
                }
            });

            $("#UserwiseSale").click(function () {
                flag = 'UserWiseSale'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    topSalesperson($('#txtFromDate').val(), $('#txtToDate').val());
                }
            });
            $('#SalesTrend').click(function () {

                flag = 'SalesTrend'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').show();

                hide_Graph();
                $('#tdSales').show();
                $('#Datetable').show();
                $('#txtFromDate').attr('disabled', true);
                $('#txtToDate').attr('disabled', true);
                salesTrend();

            });
            $('#EMGBedOccupancy').click(function () {
                flag = 'EMGBedOccupancy'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {

                    hide_Graph();
                    $('#Datetable').show(); $('#AreaDiv').show();
                    EMGBedOccupied_Graph();
                    bindEMGAdmissionType($('#txtFromDate').val(), $('#txtToDate').val());
                    EMGAdmittedTypeWise($('#txtFromDate').val(), $('#txtToDate').val());
                    EMGBillNotGenTypeWise($('#txtFromDate').val(), $('#txtToDate').val());
                }

            });

          
            $('#EMGCollection').click(function () {
                flag = 'EMGCollection'; $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show();
                    $('#AreaDiv').show();
                    EMGCollection($('#txtFromDate').val(), $('#txtToDate').val());
                }


            });

        
            $('#EMGRevenue').click(function () {
                flag = 'EMGRevenue'; $('#tdRevenueType').hide(); $('#Containerdiv').css('display', 'block'); $('#AreaDiv').hide();
                if ($('#hdnchkdate').val() == '1') {
                    hide_Graph(); $('#Datetable').show();
                    alert('To date can not be less than from date!');
                    return false;
                }
                else {
                    hide_Graph();
                    $('#Datetable').show(); $('#tdRevenueType').show(); $('#AreaDiv').show();
                    getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });

                }

            });



            $("#txtFromDate").change(function () {
                ChkDate($('#txtFromDate').val(), $('#txtToDate').val());
            });

            $("#txtToDate").change(function () {
                ChkDate($('#txtFromDate').val(), $('#txtToDate').val());
            });

            $("#ddlYear").change(function () {
                $('#DivSalesTrade,#SalesTradeChart,#SalesTradesTable,#SalesTradesTableDetails').hide();
                salesTrend();
            });


        });




        function fillDate() {
            getDate();
            var currentDate = moment($('#txtToDate').val(), 'DD-MMMM-yyyy');
            currentDate = new Date(currentDate.format('MMMM DD,YYYY'));
            var firstDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
            $("#txtFromDate").val(moment(firstDate).format('DD-MMMM-YYYY'));
            $("#txtToDate").val(moment(currentDate).format('DD-MMMM-YYYY'));
        }

        function checkSelectedOption() {
           
            if ($('#hdnchkdate').val() == '1') {
                        alert('To date can not be less than from date!');
                        return false;
                    }
                    else {
                        if (flag == 'Profit') {
                            bindProfitSummary($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if (flag == 'SalesTrend') {
                            salesTrend();
                        }
                        else if (flag == 'Inventory') {
                            inventoryAnalysis($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'DoctorStatistics') {
                            consultantStatistics($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'TopVendors') {
                            topSuppliers($('#txtFromDate').val(), $('#txtToDate').val());
                        }

                        else if (flag == 'UserWiseSale') {
                            topSalesperson($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if (flag == 'TopBuy') {
                            topPurchasedProducts($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if (flag == 'TopSale') {
                            topSellingProducts($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if (flag == 'Sale') {
                            Sale_DateWise();
                            Sale_MonthWise();
                            Sale_PatientWise();
                        }
                        else if (flag == 'PathInvestigation') {
                            Path_InvestigationDetail($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'PathDepartmentWiseStatus') {
                            Path_DeptWiseStatus($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'RadioInvestigation') {
                            Radio_Investigation($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'RadioDepartmentWiseStatus') {
                            Radio_DeptWiseStatus($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'PurchageOrderStatus') {
                            PurchaseOrderStatus($('#txtFromDate').val(), $('#txtToDate').val());
                            PurchaseRequestStatus($('#txtFromDate').val(), $('#txtToDate').val());

                        }

                        else if (flag == 'PurchageOrder') {
                            PurchaseOrder($('#txtFromDate').val(), $('#txtToDate').val());
                            PurchaseOrderItemStoreWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'GRN') {
                            Medical_Purchase($('#txtFromDate').val(), $('#txtToDate').val());
                            General_Purchase($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'GRNStatus') {
                            GRN_Status($('#txtFromDate').val(), $('#txtToDate').val());
                          

                        }
                        else if (flag == 'Consumption') {
                            Consumption($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'BedOccupancy') {
                            BedAvailable_Graph(); BedOccupancy();
                        }
                        else if (flag == 'AdmitDischarge') {
                            Admit_Graph($('#txtFromDate').val(), $('#txtToDate').val());
                            Discharge_Graph($('#txtFromDate').val(), $('#txtToDate').val());


                        }
                        else if (flag == 'IPDCollection') {
                            IPDCollection($('#txtFromDate').val(), $('#txtToDate').val());


                        }
                        else if (flag == 'IPDSurgeryDoc') {
                            Surgery_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'IPDSurgeryDpt') {
                            Surgery_DeptWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'IPDRevenue') {
                            getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });

                        }
                        else if (flag == 'IPDbusiness') {
                            IPD_Business_CategoryWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'IPDAdvanceBill') {
                            Advance_Bill_Detail($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'IPDAdmissionType') {
                            bindIPDAdmissionType($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'OPDAppointment') {
                            OPD_Graph();
                            OPD_Graph_Month();
                            OPD_Graph_Year();
                        }
                        else if (flag == 'OPDCollection') {
                            Collection_TypOfTnx($('#txtFromDate').val(), $('#txtToDate').val());
                            OPD_Collection($('#txtFromDate').val(), $('#txtToDate').val());


                        }
                        else if (flag == 'OPDRevenue') {
                          //  Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
                            getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });

                        }
                        else if (flag == 'OPDBusiness') {
                            OPD_Business_CategoryWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'Analysis') {

                            bindPatientAnalysis($('#txtFromDate').val(), $('#txtToDate').val());


                        }
                        else if (flag == 'LeaveDetail') {

                            LeaveDetail($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'Salary') {

                            Salary_DeptWise($('#txtSalaryMonth').val());

                        }
                      
                        else if (flag == 'EMGBedOccupancy') {
                            EMGBedOccupied_Graph();
                            bindEMGAdmissionType($('#txtFromDate').val(), $('#txtToDate').val());
                            EMGAdmittedTypeWise($('#txtFromDate').val(), $('#txtToDate').val());
                            EMGBillNotGenTypeWise($('#txtFromDate').val(), $('#txtToDate').val());

                            }
                        else if (flag == 'EMGCollection') {

                        EMGCollection($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if (flag == 'EMGRevenue') {

                            // EMGRevenue();
                            getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });


                        }
            }
                }


        function getDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;

                    return;
                }
            });
        }

        function ChkDate(oldValue, newValue) {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var data = mydata.d;
                    if (data == false) {
                        $('#hdnchkdate').val('1');
                        alert('To date can not be less than from date!');
                        hide_Graph(); $('#Datetable').show();
                        getDate();
                        $('#txtFromDate').val(oldValue);
                    }
                    else {
                        $('#hdnchkdate').val('0');
                        checkDivVisibility();                   
                        if ($('#AreaDiv').is(':visible') && flag == 'OPDCollection') {
                            Collection_TypOfTnx($('#txtFromDate').val(), $('#txtToDate').val());
                            OPD_Collection($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'OPDRevenue') {
                            // Revenue_OPD_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());
                            getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'BedOccupancy') {
                            BedAvailable_Graph(); BedOccupancy();
                           // BedOccupancy_Graph($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'AdmitDischarge') {
                            Admit_Graph($('#txtFromDate').val(), $('#txtToDate').val());
                            Discharge_Graph($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'IPDCollection') {
                            IPDCollection($('#txtFromDate').val(), $('#txtToDate').val());

                        }

                        else if ($('#AreaDiv').is(':visible') && flag == 'IPDSurgeryDoc') {
                            Surgery_DoctorWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }

                        else if ($('#AreaDiv').is(':visible') && flag == 'IPDSurgeryDpt') {
                            Surgery_DeptWise($('#txtFromDate').val(), $('#txtToDate').val());


                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'PurchageOrder')  {
                            PurchaseOrder($('#txtFromDate').val(), $('#txtToDate').val());
                            PurchaseOrderItemStoreWise($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'PurchageOrderStatus') {
                           
                            PurchaseOrderStatus($('#txtFromDate').val(), $('#txtToDate').val());
                            PurchaseRequestStatus($('#txtFromDate').val(), $('#txtToDate').val());
                        }

                        else if ($('#AreaDiv').is(':visible') && flag == 'IPDRevenue') {
                            getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });
                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'PathInvestigation') {
                            Path_InvestigationDetail($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'PathDepartmentWiseStatus') {
                            Path_DeptWiseStatus($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'RadioInvestigation') {
                            Radio_Investigation($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'RadioDepartmentWiseStatus') {
                            Radio_DeptWiseStatus($('#txtFromDate').val(), $('#txtToDate').val());

                        }

                       
                        else if ($('#AreaDiv').is(':visible') && flag == 'GRN') {
                            Medical_Purchase($('#txtFromDate').val(), $('#txtToDate').val());
                            General_Purchase($('#txtFromDate').val(), $('#txtToDate').val());
                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'GRNStatus') {
                             GRN_Status($('#txtFromDate').val(), $('#txtToDate').val());
                          
                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'Consumption') {
                            Consumption($('#txtFromDate').val(), $('#txtToDate').val());
                        }

                        else if ($('#AreaDiv').is(':visible') && flag == 'OPDBusiness') {
                            OPD_Business_CategoryWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'IPDbusiness') {
                            IPD_Business_CategoryWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#Leave_Area').is(':visible')) {
                            LeaveDetail($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'IPDAdvanceBill') {
                            Advance_Bill_Detail($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'IPDAdmissionType') {
                            bindIPDAdmissionType($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'Analysis') {
                            bindPatientAnalysis($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'Profit') {
                            bindProfitSummary($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'Sale')
                         {
                            Sale_DateWise();
                            Sale_MonthWise();
                            Sale_PatientWise();

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'Inventory') {
                            inventoryAnalysis($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'DoctorStatistics') {
                            consultantStatistics($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'TopSale') {
                            topSellingProducts($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'TopBuy') {
                            topPurchasedProducts($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'TopVendors') {
                            topSuppliers($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'UserWiseSale') {
                            topSalesperson($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'Sale') {
                            salesTrend();

                        }

                        else if ($('#AreaDiv').is(':visible') && flag == 'EMGBedOccupancy') {
                            EMGBedOccupied_Graph();
                            bindEMGAdmissionType($('#txtFromDate').val(), $('#txtToDate').val());
                            EMGAdmittedTypeWise($('#txtFromDate').val(), $('#txtToDate').val());
                            EMGBillNotGenTypeWise($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'EMGCollection') {

                                EMGCollection($('#txtFromDate').val(), $('#txtToDate').val());

                        }
                        else if ($('#AreaDiv').is(':visible') && flag == 'EMGRevenue') {

                            getRevenueList({ FromDate: $('#txtFromDate').val(), ToDate: $('#txtToDate').val(), CentreID: $('#ddlCentre').val(), RevenueType: $('input:[name=rdoCategory]:checked').val() }, function () { });


                        }

                    }
                    }
                
            });

        }

        function checkDivVisibility()
        {
            
            if (flag == 'Analysis' || flag == 'OPDAppointment' || flag == 'OPDRevenue' || flag == 'OPDCollection' || flag == 'OPDBusiness' || flag == 'BedOccupancy'
                || flag == 'AdmitDischarge' || flag == 'IPDCollection' || flag == 'IPDSurgeryDoc' || flag == 'IPDSurgeryDpt' || flag == 'IPDRevenue'||
                flag == 'IPDbusiness' || flag == 'IPDAdvanceBill' || flag == 'IPDAdmissionType' || flag == 'Profit' || flag == 'SalesTrend'||
              flag == 'Inventory'||flag == 'DoctorStatistics'|| flag == 'TopVendors'||flag == 'UserWiseSale' ||flag == 'TopBuy'||flag == 'TopSale'
                || flag == 'Sale' || flag == 'PathInvestigation' || flag == 'PathDepartmentWiseStatus' || flag == 'PathDepartmentWiseStatus' || flag == 'RadioInvestigation' || flag == 'RadioDepartmentWiseStatus'
                || flag == 'PurchageOrderStatus' || flag == 'PurchageOrder' || flag == 'GRN' || flag == 'GRNStatus' || flag == 'Consumption' || flag == 'EMGBedOccupancy'
                || flag == 'EMGCollection' || flag == 'EMGRevenue')
            {
                $('#AreaDiv').show();
                    }
          
        else if (flag == 'LeaveDetail') {

            LeaveDetail($('#txtFromDate').val(), $('#txtToDate').val());

        }
        else if (flag == 'Salary') {

            Salary_DeptWise($('#txtSalaryMonth').val());

        }

        }



        function hide_Graph() {
            $('#divExport').hide();
            $('#RevenuedivExport').hide();
            $('#Salary_Area').hide();
            $('#SalaryMonth').hide();
            $('#txtFromDate').attr('disabled', false);
            $('#txtToDate').attr('disabled', false);
            $('#AreaDiv').hide(); $('#char1Div').hide(); $('#chart2Div').hide();
            $('#tableDiv1').hide(); $('#tableDiv2').hide(); $('#Detail1Div').hide();
            $('#DivRevenueArea').hide(); 
            $('#Revenuechart').hide(); $('#RevenuechartTable', '#RevenuechartDetails').hide();
            $('#tdSales').hide(); $('#tdRevenueType').hide(); $('#AreaDiv').hide();

        }

        function Employee() {

            $.ajax({
                url: "Services/mis.asmx/Employee_Gradewise",
                data: '',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Grade');
                        dataTable.addColumn('number', 'Employee');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Grade);
                            dataTable.setCell(i, 1, mis_data[i].Emp);

                        }
                     
                        // Set chart options
                        var options = {
                            'title': 'Grade Wise Employee', fontName: '"Arial"',
                            'width': 583,
                            'height': 300
                        };

                        // Instantiate and draw our chart, passing in some options.
                        var chart = new google.visualization.PieChart(document.getElementById('Employee_Graph'));

                        function selectHandler() {
                            var selectedItem = chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                Employee_Detail(topping, "Grade");

                            }
                        }

                        google.visualization.events.addListener(chart, 'select', selectHandler);
                        chart.draw(dataTable, options);


                    }
                    else {
                        modelAlert('No Record Found');
                    }
                }
            });
        }

        function DeptWise_Employee() {

            $.ajax({
                url: "Services/mis.asmx/Department_wise_Employee",
                data: '',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'Employee');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].Employee);
                        }
                        var table = new google.visualization.Table(document.getElementById('DeptWise_Graph'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        function selectHandler() {
                            var selectedItem = table.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                Employee_Detail(topping, "Department");
                               

                            }
                        }
                        google.visualization.events.addListener(table, 'select', selectHandler);
                        table.draw(dataTable);

                    }
                    else {
                        modelAlert('No Record Found');
                    }
                }
            });
        }


        function Employee_Detail(Grade, Type) {

            $.ajax({
                url: "Services/mis.asmx/Employee_Detail",
                data: '{Grade:"' + Grade + '",Type:"' + Type + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Employee ID');
                        dataTable.addColumn('string', 'Name');
                        dataTable.addColumn('string', 'Designation');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Employee_ID);
                            dataTable.setCell(i, 1, mis_data[i].NAME);
                            dataTable.setCell(i, 2, mis_data[i].Designation_Name);

                        }

                        var table = new google.visualization.Table(document.getElementById('Employee_Detail'));

                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });

                    }
                    else {
                        modelAlert('No Record Found');
                    }
                }
            });
        }
        function LeaveDetail(FromDate, ToDate) {
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/LeaveDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);

                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Months');
                        dataTable.addColumn('number', 'NoOfLeave');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Months);
                            dataTable.setCell(i, 1, mis_data[i].NoOfLeave);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Month Wise Leave",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Month Wise Leave",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Month Wise Leave",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);


                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                MonthLeaveDetail('01 ' + topping);


                            }
                        }


                    }
                    else {
                        modelAlert('No Record Found');
                    }
                }
            });
        }


        function MonthLeaveDetail(SelectedMonth) {

            $.ajax({
                url: "Services/mis.asmx/MonthLeaveDetail",
                data: '{SelectedMonth:"' + SelectedMonth + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'EmployeeID');
                        dataTable.addColumn('string', 'Name');
                        dataTable.addColumn('number', 'Leave');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Employee_ID);
                            dataTable.setCell(i, 1, mis_data[i].Name);
                            dataTable.setCell(i, 2, mis_data[i].Days);

                        }

                        var table = new google.visualization.Table(document.getElementById('tableDiv1'));

                        table.draw(dataTable, { allowHtml: true, showRowNumber: true });
                        $('#tableDiv1').show();

                    }
                }
            });
        }

    



        function Path_InvestigationDetail(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/InvestigationDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CategoryID:"<%=GetGlobalResourceObject("Resource", "PathologyCategoryID") %>",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department ');

                        dataTable.addColumn('number', 'Quantity');
                        dataTable.addColumn('number', 'GrossAmount');
                        dataTable.addColumn('number', 'Discount');
                        dataTable.addColumn('number', 'NetAmount');
                        dataTable.addColumn('number', 'SubCategoryID');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].Quantity);
                            dataTable.setCell(i, 2, mis_data[i].GrossAmount);
                            dataTable.setCell(i, 3, mis_data[i].Discount);
                            dataTable.setCell(i, 4, mis_data[i].NetAmount);
                            dataTable.setCell(i, 5, mis_data[i].SubCategoryID);


                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1, 2, 3, 4]);
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Pathalogy Investigation",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Pathalogy Investigation",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Pathalogy Investigation",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show();

                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#AreaDiv').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 5);
                                selectedValue = topping;
                                Path_InvestigationTableDetail(FromDate, ToDate, topping);
                            }
                        }

                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        };


        function Path_InvestigationTableDetail(FromDate, ToDate, topping) {

            $('#Detail1Div').hide();
            $.ajax({
                url: "Services/mis.asmx/PathalogyInvestigationDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CategoryID:"<%=GetGlobalResourceObject("Resource", "PathologyCategoryID") %>",CentreID :"' + $("#ddlCentre").val() + '",Department:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var PathInvestigationCol_data = jQuery.parseJSON(mydata.d);
                    if (PathInvestigationCol_data.length > 0) {
                        var PathInvestigationDataTable = new google.visualization.DataTable();
                        PathInvestigationDataTable.addColumn('string', 'Department');
                        PathInvestigationDataTable.addColumn('string', 'ItemName');
                        PathInvestigationDataTable.addColumn('string', 'UHID');
                        PathInvestigationDataTable.addColumn('string', 'MRNo');
                        PathInvestigationDataTable.addColumn('string', 'PName');
                        PathInvestigationDataTable.addColumn('string', 'Gender');
                        PathInvestigationDataTable.addColumn('string', 'Age');
                        PathInvestigationDataTable.addColumn('string', 'TYPE');
                        PathInvestigationDataTable.addColumn('number', 'Quantity');
                        PathInvestigationDataTable.addColumn('number', 'GrossAmount');
                        PathInvestigationDataTable.addColumn('number', 'Discount');
                        PathInvestigationDataTable.addColumn('number', 'NetAmount');

                        PathInvestigationDataTable.addRows(PathInvestigationCol_data.length);

                        for (var i = 0; i < PathInvestigationCol_data.length; i++) {
                            PathInvestigationDataTable.setCell(i, 0, PathInvestigationCol_data[i].Department);
                            PathInvestigationDataTable.setCell(i, 1, PathInvestigationCol_data[i].ItemName);
                            PathInvestigationDataTable.setCell(i, 2, PathInvestigationCol_data[i].UHID);
                            PathInvestigationDataTable.setCell(i, 3, PathInvestigationCol_data[i].MRNo);
                            PathInvestigationDataTable.setCell(i, 4, PathInvestigationCol_data[i].PName);
                            PathInvestigationDataTable.setCell(i, 5, PathInvestigationCol_data[i].Gender);
                            PathInvestigationDataTable.setCell(i, 6, PathInvestigationCol_data[i].Age);
                            PathInvestigationDataTable.setCell(i, 7, PathInvestigationCol_data[i].TYPE);
                            PathInvestigationDataTable.setCell(i, 8, PathInvestigationCol_data[i].Quantity);
                            PathInvestigationDataTable.setCell(i, 9, PathInvestigationCol_data[i].GrossAmount);
                            PathInvestigationDataTable.setCell(i, 10, PathInvestigationCol_data[i].Discount);
                            PathInvestigationDataTable.setCell(i, 11, PathInvestigationCol_data[i].NetAmount);



                        }
                        var PathInvestigationTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PathInvestigationTableDetails.draw(PathInvestigationDataTable, {
                            allowHtml: true, cssClassNames: {
                                tableCell: 'small-font'
                            }, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }


        function Path_DeptWiseStatus(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();

            $.ajax({
                url: "Services/mis.asmx/PathalogyDeptWiseStatus",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department ');
                        dataTable.addColumn('number', 'ObservationType_ID ');
                        dataTable.addColumn('number', 'Collected');
                        dataTable.addColumn('number', 'NotCollected');
                        dataTable.addColumn('number', 'Rejected');
                        dataTable.addColumn('number', 'Approved');
                        dataTable.addColumn('number', 'UnApproved');
                        dataTable.addColumn('number', 'ReDone');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].ObservationType_ID);
                            dataTable.setCell(i, 2, mis_data[i].Collected);
                            dataTable.setCell(i, 3, mis_data[i].NotCollected);
                            dataTable.setCell(i, 4, mis_data[i].Rejected);
                            dataTable.setCell(i, 5, mis_data[i].Approved);
                            dataTable.setCell(i, 6, mis_data[i].UnApproved);
                            dataTable.setCell(i, 7, mis_data[i].ReDone);


                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 2, 3, 4, 5, 6, 7]);
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Pathalogy Department Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Pathalogy Department Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Pathalogy Department Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }


                        $('#char1Div').show();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#AreaDiv').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 1);

                                PathalogyDepartmentWiseCollected(FromDate, ToDate, topping);
                                Path_DepartmentWiseType(FromDate, ToDate, topping);
                            }
                        }

                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        };

        function PathalogyDepartmentWiseCollected(FromDate, ToDate, topping) {
            $.ajax({
                url: "Services/mis.asmx/PathalogyDepartmentWiseCollected",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var PathDeptCollectedCol_data = jQuery.parseJSON(mydata.d);
                    if (PathDeptCollectedCol_data.length > 0) {
                        var PathDeptCollectedDataTable = new google.visualization.DataTable();
                        PathDeptCollectedDataTable.addColumn('string', 'TYPE');
                        PathDeptCollectedDataTable.addColumn('number', 'COUNT');
                        PathDeptCollectedDataTable.addColumn('number', 'ObservationType_Id');

                        PathDeptCollectedDataTable.addRows(PathDeptCollectedCol_data.length);

                        for (var i = 0; i < PathDeptCollectedCol_data.length; i++) {
                            PathDeptCollectedDataTable.setCell(i, 0, PathDeptCollectedCol_data[i].TYPE);
                            PathDeptCollectedDataTable.setCell(i, 1, PathDeptCollectedCol_data[i].COUNT);
                            PathDeptCollectedDataTable.setCell(i, 2, PathDeptCollectedCol_data[i].ObservationType_Id);

                        }

                        var view = new google.visualization.DataView(PathDeptCollectedDataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('tableDiv1'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('tableDiv1'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('tableDiv1'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                       // $('#Detail2Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var toppingType = PathDeptCollectedDataTable.getValue(selectedItem.row, 0);
                                var toppingID = PathDeptCollectedDataTable.getValue(selectedItem.row, 2);                          
                                emgScreen = "DeptCollection"; 
                                Path_DeptCollectedDetail(FromDate, ToDate, toppingType, toppingID);

                            }
                        }


                        $('#tableDiv1').show();
                    }
                    else
                        $('#tableDiv1').hide();
                }
            });
        }


        function Path_DepartmentWiseType(FromDate, ToDate, topping) {
          
            //  $('#POTableDetail').hide();
            $.ajax({
                url: "Services/mis.asmx/PathalogyDepartmentType",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var PathDeptTypeCol_data = jQuery.parseJSON(mydata.d);
                    if (PathDeptTypeCol_data.length > 0) {
                        var PathDeptTypeDataTable = new google.visualization.DataTable();
                        PathDeptTypeDataTable.addColumn('string', 'TYPE');
                        PathDeptTypeDataTable.addColumn('number', 'COUNT');
                        PathDeptTypeDataTable.addColumn('number', 'ObservationType_Id');

                        PathDeptTypeDataTable.addRows(PathDeptTypeCol_data.length);

                        for (var i = 0; i < PathDeptTypeCol_data.length; i++) {
                            PathDeptTypeDataTable.setCell(i, 0, PathDeptTypeCol_data[i].TYPE);
                            PathDeptTypeDataTable.setCell(i, 1, PathDeptTypeCol_data[i].COUNT);
                            PathDeptTypeDataTable.setCell(i, 2, PathDeptTypeCol_data[i].ObservationType_Id);
                        }
                        var view = new google.visualization.DataView(PathDeptTypeDataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('tableDiv2'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 353,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('tableDiv2'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 353,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('tableDiv2'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 353,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var toppingType = PathDeptTypeDataTable.getValue(selectedItem.row, 0);
                                var toppingID = PathDeptTypeDataTable.getValue(selectedItem.row, 2);
                                selectedID=toppingID;
                                emgScreen = "DeptType"; 
                                Path_DepartmentTypeDetails(FromDate, ToDate, toppingType, toppingID);

                            }
                        }

                        $('#tableDiv2').show();
                    }
                    else
                        $('#tableDiv2').hide();
                }
            });
        }

        function Path_DepartmentTypeDetails(FromDate, ToDate, toppingType, toppingID) {
          
            $('#Detail1Div').hide();
            if (toppingType == 'Approved') {
                toppingType = 1;
            }
            else if (toppingType == 'UnApproved')
                toppingType = 0;
            else if (toppingType == 'ReDone') {
                Pathtype = 'ReDone';
                toppingType = 1;
            }
            selectedValue = toppingType;         
            $.ajax({
                url: "Services/mis.asmx/PathalogyDepartmentTypeDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + toppingID + '",vSampleCollected:"' + toppingType + '",type:"' + Pathtype + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var PathDepttypeDetailCol_data = jQuery.parseJSON(mydata.d);
                    if (PathDepttypeDetailCol_data.length > 0) {
                        var PathDepttypeDetailDataTable = new google.visualization.DataTable();
                        PathDepttypeDetailDataTable.addColumn('string', 'Department');
                        PathDepttypeDetailDataTable.addColumn('string', 'BarcodeNo');
                        PathDepttypeDetailDataTable.addColumn('string', 'UHID');
                        PathDepttypeDetailDataTable.addColumn('string', 'PatientName');
                        PathDepttypeDetailDataTable.addColumn('string', 'Age');
                        PathDepttypeDetailDataTable.addColumn('string', 'Gender');
                        PathDepttypeDetailDataTable.addColumn('string', 'TestName');
                        PathDepttypeDetailDataTable.addColumn('string', 'SampleType');
                        PathDepttypeDetailDataTable.addColumn('string', 'SampleStatus');


                        PathDepttypeDetailDataTable.addRows(PathDepttypeDetailCol_data.length);

                        for (var i = 0; i < PathDepttypeDetailCol_data.length; i++) {
                            PathDepttypeDetailDataTable.setCell(i, 0, PathDepttypeDetailCol_data[i].Department);
                            PathDepttypeDetailDataTable.setCell(i, 1, PathDepttypeDetailCol_data[i].BarcodeNo);
                            PathDepttypeDetailDataTable.setCell(i, 2, PathDepttypeDetailCol_data[i].UHID);
                            PathDepttypeDetailDataTable.setCell(i, 3, PathDepttypeDetailCol_data[i].PatientName);
                            PathDepttypeDetailDataTable.setCell(i, 4, PathDepttypeDetailCol_data[i].Age);
                            PathDepttypeDetailDataTable.setCell(i, 5, PathDepttypeDetailCol_data[i].Gender);
                            PathDepttypeDetailDataTable.setCell(i, 6, PathDepttypeDetailCol_data[i].TestName);
                            PathDepttypeDetailDataTable.setCell(i, 7, PathDepttypeDetailCol_data[i].SampleType);
                            PathDepttypeDetailDataTable.setCell(i, 8, PathDepttypeDetailCol_data[i].SampleStatus);



                        }
                        //  $('#Detail1Div').hide();
                        Pathtype = "";
                        var PathtypeDetailTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PathtypeDetailTableDetails.draw(PathDepttypeDetailDataTable, {
                            allowHtml: true, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }


       

        function Path_DeptCollectedDetail(FromDate, ToDate, toppingType, toppingID) {

            if (toppingType == 'Rejected')
                toppingType = 'R';
            else if (toppingType == 'Collected')
                toppingType = 'S';
            else if (toppingType == 'NotCollected')
                toppingType = 'N';
            selectedValue = toppingType;
            selectedID = toppingID;     

            $.ajax({
                url: "Services/mis.asmx/PathDeptWisecollectedDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + toppingID + '",vSampleCollected:"' + toppingType + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var PathCollectedDetailCol_data = jQuery.parseJSON(mydata.d);
                    if (PathCollectedDetailCol_data.length > 0) {
                        var PathCollectedDetailDataTable = new google.visualization.DataTable();
                        PathCollectedDetailDataTable.addColumn('string', 'Department');
                        PathCollectedDetailDataTable.addColumn('string', 'BarcodeNo');
                        PathCollectedDetailDataTable.addColumn('string', 'UHID');
                        PathCollectedDetailDataTable.addColumn('string', 'PatientName');
                        PathCollectedDetailDataTable.addColumn('string', 'Age');
                        PathCollectedDetailDataTable.addColumn('string', 'Gender');
                        PathCollectedDetailDataTable.addColumn('string', 'TestName');
                        PathCollectedDetailDataTable.addColumn('string', 'SampleType');
                        PathCollectedDetailDataTable.addColumn('string', 'SampleStatus');


                        PathCollectedDetailDataTable.addRows(PathCollectedDetailCol_data.length);

                        for (var i = 0; i < PathCollectedDetailCol_data.length; i++) {
                            PathCollectedDetailDataTable.setCell(i, 0, PathCollectedDetailCol_data[i].Department);
                            PathCollectedDetailDataTable.setCell(i, 1, PathCollectedDetailCol_data[i].BarcodeNo);
                            PathCollectedDetailDataTable.setCell(i, 2, PathCollectedDetailCol_data[i].UHID);
                            PathCollectedDetailDataTable.setCell(i, 3, PathCollectedDetailCol_data[i].PatientName);
                            PathCollectedDetailDataTable.setCell(i, 4, PathCollectedDetailCol_data[i].Age);
                            PathCollectedDetailDataTable.setCell(i, 5, PathCollectedDetailCol_data[i].Gender);
                            PathCollectedDetailDataTable.setCell(i, 6, PathCollectedDetailCol_data[i].TestName);
                            PathCollectedDetailDataTable.setCell(i, 7, PathCollectedDetailCol_data[i].SampleType);
                            PathCollectedDetailDataTable.setCell(i, 8, PathCollectedDetailCol_data[i].SampleStatus);



                        }
                        //$('#Detail2Div').hide();
                        var PathCollectedTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PathCollectedTableDetails.draw(PathCollectedDetailDataTable, {
                            allowHtml: true, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

     


       


        function Radio_Investigation(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/Radiologyinvestigation",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department ');
                        dataTable.addColumn('number', 'Quantity');
                        dataTable.addColumn('number', 'GrossAmount');
                        dataTable.addColumn('number', 'Discount');
                        dataTable.addColumn('number', 'NetAmount');
                        dataTable.addColumn('number', 'SubCategoryID');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            //dataTable.setCell(i, 1, mis_data[i].ItemName);
                            dataTable.setCell(i, 1, mis_data[i].Quantity);
                            dataTable.setCell(i, 2, mis_data[i].GrossAmount);
                            dataTable.setCell(i, 3, mis_data[i].Discount);
                            dataTable.setCell(i, 4, mis_data[i].NetAmount);
                            dataTable.setCell(i, 5, mis_data[i].SubCategoryID);

                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1, 2, 3, 4]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Radiology Investigation",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Radiology Investigation",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Radiology Investigation",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show();

                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 5);
                                selectedValue = topping;
                                Radio_InvestigationTableDetail(FromDate, ToDate, topping);

                            }
                        }

                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }

                }
            });
        }

        function Radio_InvestigationTableDetail(FromDate, ToDate, topping) {

            $.ajax({
                url: "Services/mis.asmx/RadiologyinvestigationDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CategoryID:"<%=GetGlobalResourceObject("Resource", "PathologyCategoryID") %>",CentreID :"' + $("#ddlCentre").val() + '",Department:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var RadioInvestigationCol_data = jQuery.parseJSON(mydata.d);
                    if (RadioInvestigationCol_data.length > 0) {
                        var RadioInvestigationDataTable = new google.visualization.DataTable();
                        RadioInvestigationDataTable.addColumn('string', 'Department');
                        RadioInvestigationDataTable.addColumn('string', 'ItemName');
                        RadioInvestigationDataTable.addColumn('string', 'UHID');
                        RadioInvestigationDataTable.addColumn('string', 'MRNo');
                        RadioInvestigationDataTable.addColumn('string', 'PName');
                        RadioInvestigationDataTable.addColumn('string', 'Gender');
                        RadioInvestigationDataTable.addColumn('string', 'Age');
                        RadioInvestigationDataTable.addColumn('string', 'TYPE');
                        RadioInvestigationDataTable.addColumn('number', 'Quantity');
                        RadioInvestigationDataTable.addColumn('number', 'GrossAmount');
                        RadioInvestigationDataTable.addColumn('number', 'Discount');
                        RadioInvestigationDataTable.addColumn('number', 'NetAmount');

                        RadioInvestigationDataTable.addRows(RadioInvestigationCol_data.length);

                        for (var i = 0; i < RadioInvestigationCol_data.length; i++) {
                            RadioInvestigationDataTable.setCell(i, 0, RadioInvestigationCol_data[i].Department);
                            RadioInvestigationDataTable.setCell(i, 1, RadioInvestigationCol_data[i].ItemName);
                            RadioInvestigationDataTable.setCell(i, 2, RadioInvestigationCol_data[i].UHID);
                            RadioInvestigationDataTable.setCell(i, 3, RadioInvestigationCol_data[i].MRNo);
                            RadioInvestigationDataTable.setCell(i, 4, RadioInvestigationCol_data[i].PName);
                            RadioInvestigationDataTable.setCell(i, 5, RadioInvestigationCol_data[i].Gender);
                            RadioInvestigationDataTable.setCell(i, 6, RadioInvestigationCol_data[i].Age);
                            RadioInvestigationDataTable.setCell(i, 7, RadioInvestigationCol_data[i].TYPE);
                            RadioInvestigationDataTable.setCell(i, 8, RadioInvestigationCol_data[i].Quantity);
                            RadioInvestigationDataTable.setCell(i, 9, RadioInvestigationCol_data[i].GrossAmount);
                            RadioInvestigationDataTable.setCell(i, 10, RadioInvestigationCol_data[i].Discount);
                            RadioInvestigationDataTable.setCell(i, 11, RadioInvestigationCol_data[i].NetAmount);



                        }
                        var RadioInvestigationTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        RadioInvestigationTableDetails.draw(RadioInvestigationDataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }



        function Radio_DeptWiseStatus(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/RadiologyDeptWiseStatus",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department ');
                        dataTable.addColumn('number', 'ObservationType_ID ');
                        dataTable.addColumn('number', 'NotAccepted');
                        dataTable.addColumn('number', 'Accepted');
                        dataTable.addColumn('number', 'Rejected');
                        dataTable.addColumn('number', 'Approved');
                        dataTable.addColumn('number', 'UnApproved');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].ObservationType_ID);
                            dataTable.setCell(i, 2, mis_data[i].NotAccepted);
                            dataTable.setCell(i, 3, mis_data[i].Accepted);
                            dataTable.setCell(i, 4, mis_data[i].Rejected);
                            dataTable.setCell(i, 5, mis_data[i].Approved);
                            dataTable.setCell(i, 6, mis_data[i].UnApproved);

                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 2, 3, 4, 5, 6]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Radiology Department Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Radiology Department Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Radiology Department Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show();

                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                       
                        $('#chart2Div').show(); $('#tableDiv1').hide();$('#tableDiv2').hide();
                        $('#Detail1Div').hide();
                        //$('#Detail2Div').hide();

                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 1);

                                RadiologyDepartmentWiseCollected(FromDate, ToDate, topping);
                                Radio_DepartmentWiseType(FromDate, ToDate, topping);
                            }
                        }

                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');                    
                    }

                }
            });
        }


        function RadiologyDepartmentWiseCollected(FromDate, ToDate, topping) {
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/RadiologyDepartmentWiseCollected",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var RadioDeptCollectedCol_data = jQuery.parseJSON(mydata.d);
                    if (RadioDeptCollectedCol_data.length > 0) {
                        var RadioDeptCollectedDataTable = new google.visualization.DataTable();
                        RadioDeptCollectedDataTable.addColumn('string', 'TYPE');
                        RadioDeptCollectedDataTable.addColumn('number', 'COUNT');
                        RadioDeptCollectedDataTable.addColumn('number', 'ObservationType_Id');

                        RadioDeptCollectedDataTable.addRows(RadioDeptCollectedCol_data.length);

                        for (var i = 0; i < RadioDeptCollectedCol_data.length; i++) {
                            RadioDeptCollectedDataTable.setCell(i, 0, RadioDeptCollectedCol_data[i].TYPE);
                            RadioDeptCollectedDataTable.setCell(i, 1, RadioDeptCollectedCol_data[i].COUNT);
                            RadioDeptCollectedDataTable.setCell(i, 2, RadioDeptCollectedCol_data[i].ObservationType_Id);

                        }

                        var view = new google.visualization.DataView(RadioDeptCollectedDataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('tableDiv1'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('tableDiv1'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('tableDiv1'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#tableDiv1').show();

                        //$('#Detail2Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var toppingType = RadioDeptCollectedDataTable.getValue(selectedItem.row, 0);
                                var toppingID = RadioDeptCollectedDataTable.getValue(selectedItem.row, 2);
                                emgScreen = "DeptCollection";
                                 Radio_DeptCollectedDetail(FromDate, ToDate, toppingType, toppingID);

                            }
                        }


                        $('#tableDiv1').show();
                    }
                    else
                        $('#tableDiv1').hide();
                }
            });
        }


        function Radio_DepartmentWiseType(FromDate, ToDate, topping) {
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/RadiologyDepartmentType",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'TYPE');
                        DataTable.addColumn('number', 'COUNT');
                        DataTable.addColumn('number', 'ObservationType_Id');

                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].TYPE);
                            DataTable.setCell(i, 1, Col_data[i].COUNT);
                            DataTable.setCell(i, 2, Col_data[i].ObservationType_Id);
                        }
                        var view = new google.visualization.DataView(DataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('tableDiv2'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('tableDiv2'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('tableDiv2'));
                            Chart.draw(view,
                           {
                               title: "Type Wise Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#tableDiv2').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var toppingType = DataTable.getValue(selectedItem.row, 0);
                                var toppingID = DataTable.getValue(selectedItem.row, 2);
                                emgScreen = "DeptType";
                                 Radio_DepartmentTypeDetails(FromDate, ToDate, toppingType, toppingID);

                            }
                        }

                        $('#tableDiv2').show();
                    }
                    else
                        $('#tableDiv2').hide();
                }
                });
        
        }


        function Radio_DepartmentTypeDetails(FromDate, ToDate, toppingType, toppingID) {
           
            $('#Detail1Div').hide();
            if (toppingType == 'Approved')
                toppingType = 1;
            else if (toppingType == 'UnApproved')
                toppingType = 0;
            selectedID = toppingID;
            selectedValue = toppingType;

            $.ajax({
                url: "Services/mis.asmx/RadiologyDepartmentTypeDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + toppingID + '",vSampleCollected:"' + toppingType + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'Department');
                        DataTable.addColumn('string', 'BarcodeNo');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('string', 'PatientName');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'TestName');
                        DataTable.addColumn('string', 'SampleType');
                        DataTable.addColumn('string', 'SampleStatus');


                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].Department);
                            DataTable.setCell(i, 1, Col_data[i].BarcodeNo);
                            DataTable.setCell(i, 2, Col_data[i].UHID);
                            DataTable.setCell(i, 3, Col_data[i].PatientName);
                            DataTable.setCell(i, 4, Col_data[i].Age);
                            DataTable.setCell(i, 5, Col_data[i].Gender);
                            DataTable.setCell(i, 6, Col_data[i].TestName);
                            DataTable.setCell(i, 7, Col_data[i].SampleType);
                            DataTable.setCell(i, 8, Col_data[i].SampleStatus);



                        }
                      //  $('#Detail1Div').hide();
                        var RadiotypeDetailTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        RadiotypeDetailTableDetails.draw(DataTable, {
                            allowHtml: true, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }




        function Radio_DeptCollectedDetail(FromDate, ToDate, toppingType, toppingID) {
           
           // var type = '';
            if (toppingType == 'Rejected') {
                toppingType = 'R';
                Pathtype = 'Rejected';
            }
            else if (toppingType == 'Accepted') {
                toppingType = 1;
            }
            else if (toppingType == 'NotAccepted') {
                toppingType = 0;
            }
            selectedID = toppingID;
            selectedValue = toppingType;

            $.ajax({
                url: "Services/mis.asmx/RadioDeptWisecollectedDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ObservationType_ID :"' + toppingID + '",vSampleCollected:"' + toppingType + '",type:"' + Pathtype + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'Department');
                        DataTable.addColumn('string', 'BarcodeNo');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('string', 'PatientName');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'TestName');
                        DataTable.addColumn('string', 'SampleType');
                        DataTable.addColumn('string', 'SampleStatus');


                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].Department);
                            DataTable.setCell(i, 1, Col_data[i].BarcodeNo);
                            DataTable.setCell(i, 2, Col_data[i].UHID);
                            DataTable.setCell(i, 3, Col_data[i].PatientName);
                            DataTable.setCell(i, 4, Col_data[i].Age);
                            DataTable.setCell(i, 5, Col_data[i].Gender);
                            DataTable.setCell(i, 6, Col_data[i].TestName);
                            DataTable.setCell(i, 7, Col_data[i].SampleType);
                            DataTable.setCell(i, 8, Col_data[i].SampleStatus);



                        }
                       // $('#Detail2Div').hide();
                        var PathCollectedTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PathCollectedTableDetails.draw(DataTable, {
                            allowHtml: true, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function Revenue_DoctorWise() {
            $('#AreaDiv').hide();
            $('#DivRevenueArea').show(); $('#RevenuedivExport').hide();
            $.ajax({
                url: "Services/mis.asmx/Revenue_DoctorWise",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + $('input:[name=rdoCategory]:checked').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Doctor');
                        dataTable.addColumn('number', 'Total');
                        dataTable.addColumn('number', 'DoctorVisit');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Consultant);
                            dataTable.setCell(i, 1, mis_data[i].Total);
                            dataTable.setCell(i, 2, mis_data[i].DoctorVisit);

                        }
                        $('#RevenuechartDetails').hide();
                        $('#RevenuechartTable').hide();
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Revenue ",
                               fontName: '"Arial"',
                               width: 1165,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Revenue ",
                               fontName: '"Arial"',
                               width: 1165,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Revenue ",
                               fontName: '"Arial"',
                               width: 1165,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#Revenuechart').show();

                        $('#RevenuechartDetails').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                              //  var topping = dataTable.getValue(selectedItem.row, 0);
                                var RevenueType = $('input:[name=rdoCategory]:checked').val();
                                $.ajax({
                                    url: "Services/mis.asmx/Revenue_DoctorWise",
                                    data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + RevenueType + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            if (RevenueType == 'DepartMentWise') {
                                                dataTable.addColumn('string', 'Department');
                                                dataTable.addColumn('string', 'id');
                                            }
                                            else if (RevenueType == 'PanelWise') {
                                                dataTable.addColumn('string', 'Panel');
                                                dataTable.addColumn('number', 'id');
                                            }
                                            else if (RevenueType == 'CategoryWise') {
                                                dataTable.addColumn('string', 'Category');
                                                dataTable.addColumn('number', 'id');
                                            }
                                            else if (RevenueType == 'DoctorWise') {
                                                dataTable.addColumn('string', 'Doctor');
                                                dataTable.addColumn('number', 'id');
                                            }

                                            dataTable.addColumn('number', 'Total');
                                            dataTable.addColumn('number', 'DoctorVisit');
                                            dataTable.addColumn('number', 'CrossVisit');
                                            dataTable.addColumn('number', 'Investigation');
                                            dataTable.addColumn('number', 'MinorPro');
                                            dataTable.addColumn('number', 'Surgery');
                                            dataTable.addColumn('number', 'Package');
                                            dataTable.addColumn('number', 'BedCharges');
                                            dataTable.addColumn('number', 'Medicine');
                                            dataTable.addColumn('number', 'Other');

                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].Consultant);
                                                dataTable.setCell(i, 1, mis_data[i].id);
                                                dataTable.setCell(i, 2, mis_data[i].Total);
                                                dataTable.setCell(i, 3, mis_data[i].DoctorVisit);
                                                dataTable.setCell(i, 4, mis_data[i].CrossVisit);
                                                dataTable.setCell(i, 5, mis_data[i].Investigation);
                                                dataTable.setCell(i, 6, mis_data[i].MinorPro);
                                                dataTable.setCell(i, 7, mis_data[i].Surgery);
                                                dataTable.setCell(i, 8, mis_data[i].Package);
                                                dataTable.setCell(i, 9, mis_data[i].BedCharges);
                                                dataTable.setCell(i, 10, mis_data[i].Medicine);
                                                dataTable.setCell(i, 11, mis_data[i].Other);

                                            }
                                            var view = new google.visualization.DataView(dataTable);
                                            view.setColumns([0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);

                                            var table = new google.visualization.Table(document.getElementById('RevenuechartTable'));

                                            table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#RevenuechartDetails').hide();
                                            $('#RevenuechartTable').show();
                                            google.visualization.events.addListener(table, 'select', selectHandler);

                                            function selectHandler() {
                                                var selectedItem = table.getSelection()[0];
                                                if (selectedItem) {
                                                    var topping = dataTable.getValue(selectedItem.row, 1);
                                                    selectedValue = topping;
                                                    var RevenueType = $('input:[name=rdoCategory]:checked').val();
                                                    Revenue_IPDchartDetail(RevenueType, topping)
                                                }
                                            }

                                        }

                                    }
                                });
                            }

                        }

                        $('#DivRevenueArea').show();
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#DivRevenueArea').hide();
                    }
                }
            });
        }


        function Revenue_IPDchartDetail(RevenueType, topping) {
            $('#DivRevenueArea').show();
            $('#AreaDiv').hide();
            $.ajax({
                url: "Services/mis.asmx/Revenue_IPD_DoctorWiseDetail",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + RevenueType + '",vid:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Revenue_OPDCol_data = jQuery.parseJSON(mydata.d);
                    if (Revenue_OPDCol_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        if (RevenueType == 'DepartMentWise') {
                            dataTable.addColumn('string', 'Department');
                        }
                        else if (RevenueType == 'PanelWise') {
                            dataTable.addColumn('string', 'Panel');
                        }
                        else if (RevenueType == 'CategoryWise') {
                            dataTable.addColumn('string', 'Category');
                        }
                        else if (RevenueType == 'DoctorWise') {
                            dataTable.addColumn('string', 'Doctor');
                        }
                        dataTable.addColumn('string', 'UHID');
                        dataTable.addColumn('string', 'PName');
                        dataTable.addColumn('string', 'Age');
                        dataTable.addColumn('string', 'gender');
                        dataTable.addColumn('string', 'city');
                        dataTable.addColumn('string', 'TypeOfTnx');
                        dataTable.addColumn('number', 'Total');


                        dataTable.addRows(Revenue_OPDCol_data.length);
                        for (var i = 0; i < Revenue_OPDCol_data.length; i++) {
                            dataTable.setCell(i, 0, Revenue_OPDCol_data[i].Consultant);
                            dataTable.setCell(i, 1, Revenue_OPDCol_data[i].UHID);
                            dataTable.setCell(i, 2, Revenue_OPDCol_data[i].PName);
                            dataTable.setCell(i, 3, Revenue_OPDCol_data[i].Age);
                            dataTable.setCell(i, 4, Revenue_OPDCol_data[i].gender);
                            dataTable.setCell(i, 5, Revenue_OPDCol_data[i].city);
                            dataTable.setCell(i, 6, Revenue_OPDCol_data[i].TypeOfTnx);
                            dataTable.setCell(i, 7, Revenue_OPDCol_data[i].Total);



                        }
                        var Revenue_OPDCol_dataDetails = new google.visualization.Table(document.getElementById('RevenuechartDetails'));
                        Revenue_OPDCol_dataDetails.draw(dataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#RevenuechartDetails').show(); $('#RevenuedivExport').show();

                    }
                    else
                        $('#RevenuechartDetails').hide();
                }
            });
        }





        function getRevenueList(data, callback) {
           $('#AreaDiv').hide();

            if (flag == 'IPDRevenue') {
                $('#DivRevenueArea').hide();
                Revenue_DoctorWise();             
            }
           else if (flag == 'EMGRevenue') {
               $('#DivRevenueArea').hide();
                EMGRevenue();
            }
           else {
               $('#RevenuedivExport').hide();
                serverCall('Services/mis.asmx/Revenue_OPD_DoctorWise', data, function (response) {
                    var $responseData = JSON.parse(response);

                    if ($responseData.data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Doctor');
                        dataTable.addColumn('number', 'Total');
                        dataTable.addRows($responseData.data.length);
                        for (var i = 0; i < $responseData.data.length; i++) {
                            dataTable.setCell(i, 0, $responseData.data[i].Consultant);
                            dataTable.setCell(i, 1, $responseData.data[i].Total);
                           // dataTable.setCell(i, 2, $responseData.data[i].DoctorVisit);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD Revenue ",
                               fontName: '"Arial"',
                               width: 1165,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD Revenue ",
                               fontName: '"Arial"',
                               width: 1165,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD Revenue ",
                               fontName: '"Arial"',
                               width: 1165,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );

                        }

                        $('#Revenuechart').show(); $('#RevenuechartTable').hide(); $('#RevenuechartDetails').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                var RevenueType = $('input:[name=rdoCategory]:checked').val();

                                $.ajax({
                                    url: "Services/mis.asmx/Revenue_OPD_DoctorWise",
                                    data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + RevenueType + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();

                                            if (RevenueType == 'DepartMentWise') {
                                                dataTable.addColumn('string', 'Department');
                                                dataTable.addColumn('string', 'id');
                                            }
                                            else if (RevenueType == 'PanelWise') {
                                                dataTable.addColumn('string', 'Panel');
                                                dataTable.addColumn('number', 'id');
                                            }
                                            else if (RevenueType == 'CategoryWise') {
                                                dataTable.addColumn('string', 'Category');
                                                dataTable.addColumn('number', 'id');
                                            }
                                            else if (RevenueType == 'DoctorWise') {
                                                dataTable.addColumn('string', 'Doctor');
                                                dataTable.addColumn('number', 'id');
                                            }

                                            dataTable.addColumn('number', 'Total');
                                            dataTable.addColumn('number', 'Appointment');
                                            dataTable.addColumn('number', 'Investigation');
                                            dataTable.addColumn('number', 'Procedure');
                                            dataTable.addColumn('number', 'Package');
                                            dataTable.addColumn('number', 'Other');
                                           

                                            dataTable.addRows(mis_data.data.length);
                                            for (var i = 0; i < mis_data.data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data.data[i].Consultant);
                                                dataTable.setCell(i, 1, mis_data.data[i].id);
                                                dataTable.setCell(i, 2, mis_data.data[i].Total);
                                                dataTable.setCell(i, 3, mis_data.data[i].Appointment);
                                                dataTable.setCell(i, 4, mis_data.data[i].Investigation);
                                                dataTable.setCell(i, 5, mis_data.data[i].Procedure);
                                                dataTable.setCell(i, 6, mis_data.data[i].Package);
                                                dataTable.setCell(i, 7, mis_data.data[i].Other);

                                            }
                                            var view = new google.visualization.DataView(dataTable);
                                            view.setColumns([0, 2, 3, 4, 5, 6, 7]);

                                            var table = new google.visualization.Table(document.getElementById('RevenuechartTable'));

                                            table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#RevenuechartTable').show(); $('#RevenuechartDetails').hide();
                                            google.visualization.events.addListener(table, 'select', selectHandler);

                                            function selectHandler() {
                                                var selectedItem = table.getSelection()[0];
                                                if (selectedItem) {
                                                    var topping = dataTable.getValue(selectedItem.row, 1);
                                                   selectedValue = topping;                                                   
                                                 var RevenueType = $('input:[name=rdoCategory]:checked').val();
                                                    Revenue_OPDchartDetail(RevenueType, topping)
                                                }
                                            }
                                        }

                                    }
                                });
                            }

                        }

                        $('#DivRevenueArea').show();
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#DivRevenueArea').hide();
                    }
                })
            }
                      
        };
      
        function Revenue_OPDchartDetail(RevenueType, topping) {
            $('#DivRevenueArea').show(); $('#RevenuedivExport').show();
            $.ajax({
                url: "Services/mis.asmx/Revenue_OPD_DoctorWiseDetail",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + RevenueType + '",vid:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Revenue_OPDCol_data = jQuery.parseJSON(mydata.d);
                    if (Revenue_OPDCol_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        if (RevenueType == 'DepartMentWise') {
                            dataTable.addColumn('string', 'Department');

                        }
                        else if (RevenueType == 'PanelWise') {
                            dataTable.addColumn('string', 'Panel');

                        }
                        else if (RevenueType == 'CategoryWise') {
                            dataTable.addColumn('string', 'Category');
                        }
                        else if (RevenueType == 'DoctorWise') {
                            dataTable.addColumn('string', 'Doctor');
                        }
                        dataTable.addColumn('string', 'UHID');
                        dataTable.addColumn('string', 'PName');
                        dataTable.addColumn('string', 'Age');
                        dataTable.addColumn('string', 'gender');
                        dataTable.addColumn('string', 'city');
                        dataTable.addColumn('string', 'TypeOfTnx');
                        dataTable.addColumn('number', 'Total');


                        dataTable.addRows(Revenue_OPDCol_data.length);
                        for (var i = 0; i < Revenue_OPDCol_data.length; i++) {
                            dataTable.setCell(i, 0, Revenue_OPDCol_data[i].Consultant);
                            dataTable.setCell(i, 1, Revenue_OPDCol_data[i].UHID);
                            dataTable.setCell(i, 2, Revenue_OPDCol_data[i].PName);
                            dataTable.setCell(i, 3, Revenue_OPDCol_data[i].Age);
                            dataTable.setCell(i, 4, Revenue_OPDCol_data[i].gender);
                            dataTable.setCell(i, 5, Revenue_OPDCol_data[i].city);
                            dataTable.setCell(i, 6, Revenue_OPDCol_data[i].TypeOfTnx);
                            dataTable.setCell(i, 7, Revenue_OPDCol_data[i].Total);



                        }
                        var Revenue_OPDCol_dataDetails = new google.visualization.Table(document.getElementById('RevenuechartDetails'));
                        Revenue_OPDCol_dataDetails.draw(dataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#RevenuechartDetails').show(); $('#divExport').show();

                    }
                    else
                        $('#RevenuechartDetails').hide();
                }
            });
        }



//GRN

        function Medical_Purchase(FromDate, ToDate) {

            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/Medical_Purchase",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Item');
                        dataTable.addColumn('number', 'Quantity');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'ItemID');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].ItemName);
                            dataTable.setCell(i, 1, mis_data[i].InitialCount);
                            dataTable.setCell(i, 2, mis_data[i].Amount);
                            dataTable.setCell(i, 3, mis_data[i].ItemID);
                        }
                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1, 2]);


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Medical Store",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Medical Store",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Medical Store",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                        $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#chart2Div').show();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 3);
                                selectedValue = topping;
                                MedicalGRNDetail(FromDate, ToDate, topping);

                            }

                        }
                        $('#AreaDiv').show();
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found'); 
                    }

                }
            });
        }

        function MedicalGRNDetail(FromDate, ToDate, topping) {
            $.ajax({
                url: "Services/mis.asmx/GRNDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ItemID:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var PurchaseOrderCol_data = jQuery.parseJSON(mydata.d);
                    if (PurchaseOrderCol_data.length > 0) {
                        var PurchaseOrderDataTable = new google.visualization.DataTable();
                        PurchaseOrderDataTable.addColumn('string', 'GRNNo');
                        PurchaseOrderDataTable.addColumn('string', 'GRNDate');
                        PurchaseOrderDataTable.addColumn('string', 'Supplier');
                        PurchaseOrderDataTable.addColumn('string', 'Department');
                        PurchaseOrderDataTable.addColumn('string', 'ItemName');
                        PurchaseOrderDataTable.addColumn('string', 'SubCategory');
                        PurchaseOrderDataTable.addColumn('number', 'InitialCount');
                        PurchaseOrderDataTable.addColumn('number', 'Amount');

                        PurchaseOrderDataTable.addRows(PurchaseOrderCol_data.length);

                        for (var i = 0; i < PurchaseOrderCol_data.length; i++) {
                            PurchaseOrderDataTable.setCell(i, 0, PurchaseOrderCol_data[i].GRNNo);
                            PurchaseOrderDataTable.setCell(i, 1, PurchaseOrderCol_data[i].GRNDate);
                            PurchaseOrderDataTable.setCell(i, 2, PurchaseOrderCol_data[i].Supplier);
                            PurchaseOrderDataTable.setCell(i, 3, PurchaseOrderCol_data[i].Department);
                            PurchaseOrderDataTable.setCell(i, 4, PurchaseOrderCol_data[i].ItemName);
                            PurchaseOrderDataTable.setCell(i, 5, PurchaseOrderCol_data[i].SubCategory);
                            PurchaseOrderDataTable.setCell(i, 6, PurchaseOrderCol_data[i].InitialCount);
                            PurchaseOrderDataTable.setCell(i, 7, PurchaseOrderCol_data[i].Amount);

                        }
                        var PurchaseOrderTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PurchaseOrderTableDetails.draw(PurchaseOrderDataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function General_Purchase(FromDate, ToDate) {
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/General_Purchase",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Item');
                        dataTable.addColumn('string', 'SubCategory');
                        dataTable.addColumn('number', 'Quantity');
                        dataTable.addColumn('number', 'Amount');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].ItemName);
                            dataTable.setCell(i, 1, mis_data[i].SubCategory);
                            dataTable.setCell(i, 2, mis_data[i].InitialCount);
                            dataTable.setCell(i, 3, mis_data[i].Amount);
                        }
                  

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "General Store",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "General Store",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "General Store",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#tableDiv1').show();
                        var table = new google.visualization.Table(document.getElementById('tableDiv2'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#tableDiv2').show();

                        $('#AreaDiv').show();
                    }
                    //else{
                    //   modelAlert('No Record Found in General Store');
                    //   $('#AreaDiv').hide();
                    //}
                }
            });
        }

        //GRN Status


        function GRN_Status(FromDate, ToDate)
        {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/GRN_Status",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'STATUS');
                        dataTable.addColumn('number', 'COUNT');



                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].STATUS);
                            dataTable.setCell(i, 1, mis_data[i].COUNT);


                        }
                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1]);


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "GRN Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "GRN Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "GRN Status",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show(); $('#chart2Div').show(); $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: 578 });
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var toppingStatus = dataTable.getValue(selectedItem.row, 0);
                                
                                  GRNStatusDetails(FromDate, ToDate, toppingStatus)
                            }
                        }
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                }
            });
        }

        function GRNStatusDetails(FromDate, ToDate, toppingStatus) {
            if (toppingStatus =='Not Posted')
                toppingStatus = 0;
            else if (toppingStatus == 'Posted')
                toppingStatus = 1;
            else if (toppingStatus =='Rejected')
                toppingStatus = 3;
            selectedValue = toppingStatus;
            $.ajax({
                url: "Services/mis.asmx/GRN_StatusDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",Status:"' + toppingStatus + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'GRNNo');
                        DataTable.addColumn('string', 'GRNDate');
                        DataTable.addColumn('string', 'Supplier');
                        DataTable.addColumn('string', 'Department');
                        DataTable.addColumn('string', 'ItemName');
                        DataTable.addColumn('string', 'SubCategory');
                        DataTable.addColumn('number', 'InitialCount');
                        DataTable.addColumn('number', 'Amount');
                        DataTable.addColumn('string', 'STATUS');
                    
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].GRNNo);
                            DataTable.setCell(i, 1, Col_data[i].GRNDate);
                            DataTable.setCell(i, 2, Col_data[i].Supplier);
                            DataTable.setCell(i, 3, Col_data[i].Department);
                            DataTable.setCell(i, 4, Col_data[i].ItemName);
                            DataTable.setCell(i, 5, Col_data[i].SubCategory);
                            DataTable.setCell(i, 6, Col_data[i].InitialCount);
                            DataTable.setCell(i, 7, Col_data[i].Amount);
                            DataTable.setCell(i, 8, Col_data[i].STATUS);

                        }
                        $('#Detail1Div').hide();
                        var TableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        TableDetails.draw(DataTable, {
                            allowHtml: true, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function Surgery_DoctorWise(FromDate, ToDate) {

            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/Surgery_DoctorWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Doctor');
                        dataTable.addColumn('number', 'No of Surgery');
                        dataTable.addColumn('number', 'NetAmount');
                        dataTable.addColumn('number', 'DoctorID');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Doctor);
                            dataTable.setCell(i, 1, mis_data[i].Surgery);
                            dataTable.setCell(i, 2, mis_data[i].NetAmount);
                            dataTable.setCell(i, 3, mis_data[i].DoctorID);

                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1, 2]);

                        $('#AreaDiv').show();
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Surgery Doctorwise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Surgery Doctorwise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Surgery Doctorwise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show();

                        var table = new google.visualization.Table(document.getElementById('chart2Div'));

                        table.draw(view, { allowHtml: true, showRowNumber: true, width: 578 });
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 3);
                                selectedValue = topping;
                                Surgery_DoctorWiseDetail(FromDate, ToDate, topping);

                            }

                        }
                        $('#AreaDiv').show();
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();

                    }
                }
            });
        }


        function Surgery_DoctorWiseDetail(FromDate, ToDate, topping) {

            $.ajax({
                url: "Services/mis.asmx/Surgery_DoctorWiseDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",DoctorId:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'city');
                        DataTable.addColumn('number', 'GrossAmount');
                        DataTable.addColumn('number', 'Discount');
                        DataTable.addColumn('number', 'NetAmount');
                        DataTable.addColumn('number', 'Surgery');
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].Doctor);
                            DataTable.setCell(i, 1, Col_data[i].UHID);
                            DataTable.setCell(i, 2, Col_data[i].PName);
                            DataTable.setCell(i, 3, Col_data[i].Gender);
                            DataTable.setCell(i, 4, Col_data[i].city);
                            DataTable.setCell(i, 5, Col_data[i].GrossAmount);
                            DataTable.setCell(i, 6, Col_data[i].Discount);
                            DataTable.setCell(i, 7, Col_data[i].NetAmount);
                            DataTable.setCell(i, 8, Col_data[i].Surgery);

                        }
                        var SurgeryDoctorWiseTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        SurgeryDoctorWiseTableDetails.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }



        function Surgery_DeptWise(FromDate, ToDate) {
            $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/Surgery_DeptWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'No of Surgery');
                        dataTable.addColumn('number', 'GrossAmount');
                        dataTable.addColumn('number', 'Discount');
                        dataTable.addColumn('number', 'NetAmount');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].Surgery);
                            dataTable.setCell(i, 2, mis_data[i].GrossAmount);
                            dataTable.setCell(i, 3, mis_data[i].Discount);
                            dataTable.setCell(i, 4, mis_data[i].NetAmount);
                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Surgery Department wise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Surgery Department wise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Surgery Department wise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show();

                        var table = new google.visualization.Table(document.getElementById('chart2Div'));


                        table.draw(dataTable, { allowHtml: true, showRowNumber: true });
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                Surgery_DepartmentWiseDetail(FromDate, ToDate);

                            }

                        }
                        $('#AreaDiv').show();
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        }



        function Surgery_DepartmentWiseDetail(FromDate, ToDate) {

            $.ajax({
                url: "Services/mis.asmx/Surgery_DeptWiseDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'Department');
                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('number', 'IPDNO');

                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'city');
                        DataTable.addColumn('number', 'GrossAmount');
                        DataTable.addColumn('number', 'Discount');
                        DataTable.addColumn('number', 'NetAmount');
                        DataTable.addColumn('number', 'Surgery');
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].Department);
                            DataTable.setCell(i, 1, Col_data[i].Doctor);
                            DataTable.setCell(i, 2, Col_data[i].UHID);
                            DataTable.setCell(i, 3, Col_data[i].IPDNO);
                            DataTable.setCell(i, 4, Col_data[i].PName);
                            DataTable.setCell(i, 5, Col_data[i].Gender);
                            DataTable.setCell(i, 6, Col_data[i].city);
                            DataTable.setCell(i, 7, Col_data[i].GrossAmount);
                            DataTable.setCell(i, 8, Col_data[i].Discount);
                            DataTable.setCell(i, 9, Col_data[i].NetAmount);
                            DataTable.setCell(i, 10, Col_data[i].Surgery);

                        }
                        var SurgeryDeptWiseTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        SurgeryDeptWiseTableDetails.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function PurchaseOrder(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
           // $('#Detail2Div').hide();
            $.ajax({
                url: "Services/mis.asmx/PurchaseOrder",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Months');
                        dataTable.addColumn('number', 'Purchase Order');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].months);
                            dataTable.setCell(i, 1, mis_data[i].po);

                        }
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Purchase Order",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Purchase Order",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Purchase Order",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show(); $('#tableDiv1').hide(); $('#tableDiv2').hide();
                        $('#POTableDetail').hide();
                        $('#Detail1Div').hide();
                        //$('#Detail2Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);

                                $.ajax({
                                    url: "Services/mis.asmx/PurchaseOrder",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'Months');
                                            dataTable.addColumn('number', 'Purchase Order');


                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].months);
                                                dataTable.setCell(i, 1, mis_data[i].po);

                                            }

                                            var table = new google.visualization.Table(document.getElementById('tableDiv1'));
                                            table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#tableDiv1').show();
                                            google.visualization.events.addListener(table, 'select', selectHandler);

                                            function selectHandler() {
                                                var selectedItem = table.getSelection()[0];
                                                if (selectedItem) {
                                                    //var topping = dataTable.getValue(selectedItem.row, 0);
                                                    emgScreen = "PurchaseOrder";
                                                    PurchaseOrderDetail(FromDate, ToDate);
                                                }
                                            }
                                        }

                                    }
                                });
                            }

                        }


                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        }

        function PurchaseOrderDetail(FromDate, ToDate) {
           
            $.ajax({
                url: "Services/mis.asmx/PurchaseOrderDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'PurchaseOrderNo');
                        DataTable.addColumn('number', 'NetTotal');
                        DataTable.addColumn('number', 'GrossTotal');
                        DataTable.addColumn('string', 'Subject');
                        DataTable.addColumn('string', 'VendorName');
                        DataTable.addColumn('string', 'RaisedDate');
                        DataTable.addColumn('string', 'Type');
                        DataTable.addColumn('string', 'STATUS');

                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].PurchaseOrderNo);
                            DataTable.setCell(i, 1, Col_data[i].NetTotal);
                            DataTable.setCell(i, 2, Col_data[i].GrossTotal);
                            DataTable.setCell(i, 3, Col_data[i].Subject);
                            DataTable.setCell(i, 4, Col_data[i].VendorName);
                            DataTable.setCell(i, 5, Col_data[i].RaisedDate);
                            DataTable.setCell(i, 6, Col_data[i].Type);
                            DataTable.setCell(i, 7, Col_data[i].STATUS);

                        }
                        var PurchaseOrderTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PurchaseOrderTableDetails.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }


        function PurchaseOrderItemStoreWise(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/PurchaseOrderItemStoreWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'store');
                        dataTable.addColumn('number', 'Item');
                        dataTable.addColumn('number', 'CategoryID');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].store);
                            dataTable.setCell(i, 1, mis_data[i].Item);
                            dataTable.setCell(i, 2, mis_data[i].CategoryID);

                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1]); //here you set the columns you want to display


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Item Wise Purchase",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Item Wise Purchase",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Item Wise Purchase",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        // $('#Detail2Div').hide();
                        $('#chart2Div').show();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);

                                $.ajax({
                                    url: "Services/mis.asmx/PurchaseOrderItemStoreWise",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'store');
                                            dataTable.addColumn('number', 'Item');
                                            dataTable.addColumn('number', 'CategoryID');


                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].store);
                                                dataTable.setCell(i, 1, mis_data[i].Item);
                                                dataTable.setCell(i, 2, mis_data[i].CategoryID);

                                            }

                                            var view = new google.visualization.DataView(dataTable);
                                            view.setColumns([0, 1]);

                                            var table = new google.visualization.Table(document.getElementById('tableDiv2'));
                                            table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#tableDiv2').show();
                                            google.visualization.events.addListener(table, 'select', selectHandler);
                                            function selectHandler() {
                                                var selectedItem = table.getSelection()[0];
                                                if (selectedItem) {
                                                    var topping = dataTable.getValue(selectedItem.row, 2);
                                                    selectedValue = topping;
                                                    emgScreen = "POItemwise";
                                                    PurchaseOrderItemStoreWiseDetail(FromDate, ToDate, topping);
                                                }
                                            }

                                        }

                                    }
                                });
                            }

                        }

                    }
                    else {
                        $('#AreaDiv').hide(); modelAlert('No Record Found');
                    }
                }
            });
        }

        function PurchaseOrderItemStoreWiseDetail(FromDate, ToDate, topping) {

            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/PurchaseOrderItemStoreWiseDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",CategoryID:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var PurchaseOrderCol_data = jQuery.parseJSON(mydata.d);
                    if (PurchaseOrderCol_data.length > 0) {
                        var PurchaseOrderDataTable = new google.visualization.DataTable();
                        PurchaseOrderDataTable.addColumn('string', 'Store');
                        PurchaseOrderDataTable.addColumn('string', 'ItemName');
                        PurchaseOrderDataTable.addColumn('string', 'PurchaseOrderNo');
                        PurchaseOrderDataTable.addColumn('string', 'RaisedDate');
                        PurchaseOrderDataTable.addColumn('string', 'RaisedUserName');
                        PurchaseOrderDataTable.addColumn('string', 'VendorName');
                        PurchaseOrderDataTable.addColumn('string', 'STATUS');

                        PurchaseOrderDataTable.addRows(PurchaseOrderCol_data.length);

                        for (var i = 0; i < PurchaseOrderCol_data.length; i++) {
                            PurchaseOrderDataTable.setCell(i, 0, PurchaseOrderCol_data[i].store);
                            PurchaseOrderDataTable.setCell(i, 1, PurchaseOrderCol_data[i].ItemName);
                            PurchaseOrderDataTable.setCell(i, 2, PurchaseOrderCol_data[i].PurchaseOrderNo);
                            PurchaseOrderDataTable.setCell(i, 3, PurchaseOrderCol_data[i].RaisedDate);
                            PurchaseOrderDataTable.setCell(i, 4, PurchaseOrderCol_data[i].RaisedUserName);
                            PurchaseOrderDataTable.setCell(i, 5, PurchaseOrderCol_data[i].VendorName);
                            PurchaseOrderDataTable.setCell(i, 6, PurchaseOrderCol_data[i].STATUS);


                        }
                        var PurchaseOrderTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PurchaseOrderTableDetails.draw(PurchaseOrderDataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        //PurchaseOrder Status
        function PurchaseOrderStatus(FromDate, ToDate) {
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/PurchaseOrderStatus",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'VendorName');
                        dataTable.addColumn('number', 'TotalOrder');
                        dataTable.addColumn('string', 'VendorID');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].VendorName);
                            dataTable.setCell(i, 1, mis_data[i].TotalOrder);
                            dataTable.setCell(i, 2, mis_data[i].VendorID);

                        }
                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Purchase Order Vendor Wise ",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Purchase Order Vendor Wise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Purchase Order Vendor Wise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#chart2Div').show(); $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);


                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);
                                $.ajax({
                                    url: "Services/mis.asmx/PurchaseOrderTypeWise",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",VendorID:"' + topping + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'TYPE');
                                            dataTable.addColumn('number', 'COUNT');
                                            dataTable.addColumn('string', 'VendorID');


                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].TYPE);
                                                dataTable.setCell(i, 1, mis_data[i].COUNT);
                                                dataTable.setCell(i, 2, mis_data[i].VendorID);

                                            }
                                            var view = new google.visualization.DataView(dataTable);
                                            view.setColumns([0, 1]);


                                            var chartType = document.getElementById('ddlChartType').value;

                                            if (chartType == 0) {
                                                var Chart = new google.visualization.PieChart(document.getElementById('tableDiv2'));
                                                Chart.draw(view,
                                               {
                                                   title: "Purchase Order Type Wise",
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },

                                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                                   trendlines: { 0: {} },
                                               }
                                            );
                                            }
                                            else if (chartType == 1) {
                                                var Chart = new google.visualization.LineChart(document.getElementById('tableDiv2'));
                                                Chart.draw(view,
                                               {
                                                   title: "Purchase Order Type Wise",
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },
                                                   legend: { position: 'bottom' },
                                                   chartArea: { left: 80, top: 18, width: "95%" },
                                                   trendlines: { 0: {} },
                                               }
                                            );
                                            }
                                            if (chartType == 2) {
                                                var Chart = new google.visualization.BarChart(document.getElementById('tableDiv2'));
                                                Chart.draw(view,
                                               {
                                                   title: "Purchase Order Type Wise",
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },
                                                   legend: { position: 'bottom' },
                                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                                   trendlines: { 0: {} },
                                               }
                                            );


                                            }
                                            $('#tableDiv2').show(); $('#Detail1Div').hide();
                                            //$('#Detail2Div').hide();
                                            google.visualization.events.addListener(Chart, 'select', selectHandler);

                                            function selectHandler() {
                                                var selectedItem = Chart.getSelection()[0];
                                                if (selectedItem) {
                                                    var toppingType = dataTable.getValue(selectedItem.row, 0);
                                                    var toppingID = dataTable.getValue(selectedItem.row, 2);
                                                    PurchaseOrderTypeWiseDetails(FromDate, ToDate, toppingType, toppingID);
                                                }
                                            }
                                        }
                                    }
                                });

                            }
                        }
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        }



        function PurchaseRequestStatus(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/PurchaseRequestStatus",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'TotalRequest');
                        dataTable.addColumn('string', 'LedgerNumber');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].TotalRequest);
                            dataTable.setCell(i, 2, mis_data[i].LedgerNumber);

                        }
                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Purchase Request Department Wise ",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Purchase Request Department Wise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: "Purchase Request Department Wise",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#char1Div').show(); $('#tableDiv1').hide(); $('#tableDiv2').hide();
                        $('#Detail1Div').hide();
                        //$('#Detail2Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);


                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);

                                $.ajax({
                                    url: "Services/mis.asmx/PurchaseRequestTypeWise",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",LedgerNumber:"' + topping + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'TYPE');
                                            dataTable.addColumn('number', 'COUNT');
                                            dataTable.addColumn('string', 'LedgerNumber');


                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].TYPE);
                                                dataTable.setCell(i, 1, mis_data[i].COUNT);
                                                dataTable.setCell(i, 2, mis_data[i].LedgerNumber);

                                            }
                                            var view = new google.visualization.DataView(dataTable);
                                            view.setColumns([0, 1]);


                                            var chartType = document.getElementById('ddlChartType').value;

                                            if (chartType == 0) {
                                                var Chart = new google.visualization.PieChart(document.getElementById('tableDiv1'));
                                                Chart.draw(view,
                                               {
                                                   title: "Purchase Request Type Wise",
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },

                                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                                   trendlines: { 0: {} },
                                               }
                                            );
                                            }
                                            else if (chartType == 1) {
                                                var Chart = new google.visualization.LineChart(document.getElementById('tableDiv1'));
                                                Chart.draw(view,
                                               {
                                                   title: "Purchase Request Type Wise",
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },
                                                   legend: { position: 'bottom' },
                                                   chartArea: { left: 80, top: 18, width: "95%" },
                                                   trendlines: { 0: {} },
                                               }
                                            );
                                            }
                                            if (chartType == 2) {
                                                var Chart = new google.visualization.BarChart(document.getElementById('tableDiv1'));
                                                Chart.draw(view,
                                               {
                                                   title: "Purchase Request Type Wise",
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },
                                                   legend: { position: 'bottom' },
                                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                                   trendlines: { 0: {} },
                                               }
                                            );


                                            }
                                            $('#tableDiv1').show();
                                            google.visualization.events.addListener(Chart, 'select', selectHandler);

                                            function selectHandler() {
                                                var selectedItem = Chart.getSelection()[0];
                                                if (selectedItem) {
                                                    var toppingType = dataTable.getValue(selectedItem.row, 0);
                                                    var toppingID = dataTable.getValue(selectedItem.row, 2);
                                                    PurchaseRequestTypeWiseDetails(FromDate, ToDate, toppingType, toppingID)
                                                }
                                            }
                                        }

                                    }
                                });
                            }

                        }

                    }
                    else
                        modelAlert('No Record Found');
                }
            });
        }

        function PurchaseRequestTypeWiseDetails(FromDate, ToDate, toppingType, toppingID) {
         
            emgScreen = "PRType";
            if (toppingType == 'Pending')
                toppingType = 0;
            else if (toppingType == 'Reject')
                toppingType = 1;
            else if (toppingType == 'Open')
                toppingType = 2;
            else if (toppingType == 'Close')
                toppingType = 3;
            selectedID = toppingID;
            selectedValue = toppingType;

            $.ajax({
                url: "Services/mis.asmx/PurchaseRequestTypeWiseDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",LedgerNumber :"' + toppingID + '",Status:"' + toppingType + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'Department');
                        DataTable.addColumn('string', 'RequestNo');
                        DataTable.addColumn('string', 'Item');
                        DataTable.addColumn('number', 'ApprovedQty');
                        DataTable.addColumn('number', 'OrderedQty');
                        DataTable.addColumn('number', 'ApproxRate');
                        DataTable.addColumn('number', 'InHandQty');
                        DataTable.addColumn('string', 'STATUS');
                        DataTable.addColumn('string', 'RaisedDate');
                        DataTable.addColumn('string', 'Type');
                        DataTable.addColumn('string', 'RaisedBy');
           


                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].Department);
                            DataTable.setCell(i, 1, Col_data[i].RequestNo);
                            DataTable.setCell(i, 2, Col_data[i].Item);
                            DataTable.setCell(i, 3, Col_data[i].ApprovedQty);
                            DataTable.setCell(i, 4, Col_data[i].OrderedQty);
                            DataTable.setCell(i, 5, Col_data[i].ApproxRate);
                            DataTable.setCell(i, 6, Col_data[i].InHandQty);
                            DataTable.setCell(i, 7, Col_data[i].STATUS);
                            DataTable.setCell(i, 8, Col_data[i].RaisedDate);
                            DataTable.setCell(i, 9, Col_data[i].Type);
                            DataTable.setCell(i, 10, Col_data[i].RaisedBy);
               

                        }
                      //  $('#Detail2Div').hide();
                        var TableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        TableDetails.draw(DataTable, {
                            allowHtml: true, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }


        function PurchaseOrderTypeWiseDetails(FromDate, ToDate, toppingType, toppingID) {
            emgScreen = "POType";$('#Detail1Div').hide();
            
            if (toppingType == 'Pending')
                toppingType = 0;
            else if (toppingType == 'Reject')
                toppingType = 1;
            else if (toppingType == 'Open')
                toppingType = 2;
            else if (toppingType == 'Close')
                toppingType = 3;
            selectedID = toppingID;
            selectedValue = toppingType;

            $.ajax({
                url: "Services/mis.asmx/PurchaseOrderTypeWiseDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",VendorID :"' + toppingID + '",Status:"' + toppingType + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'VendorName');
                        DataTable.addColumn('string', 'PurchaseOrderNo');
                        DataTable.addColumn('string', 'itemSpcl');
                        DataTable.addColumn('number', 'ApprovedQty');
                        DataTable.addColumn('number', 'RecievedQty');
                        DataTable.addColumn('number', 'BuyPrice');
                        DataTable.addColumn('string', 'PRNumber');
                        DataTable.addColumn('number', 'Discount');
                        DataTable.addColumn('number', 'Rate');
                        DataTable.addColumn('number', 'Amount');
                        DataTable.addColumn('string', 'Status');
                        DataTable.addColumn('string', 'RaisedDate');
                        DataTable.addColumn('string', 'RaisedBy');


                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].VendorName);
                            DataTable.setCell(i, 1, Col_data[i].PurchaseOrderNo);
                            DataTable.setCell(i, 2, Col_data[i].itemSpcl);
                            DataTable.setCell(i, 3, Col_data[i].ApprovedQty);
                            DataTable.setCell(i, 4, Col_data[i].RecievedQty);
                            DataTable.setCell(i, 5, Col_data[i].BuyPrice);
                            DataTable.setCell(i, 6, Col_data[i].PRNumber);
                            DataTable.setCell(i, 7, Col_data[i].Discount_p);
                            DataTable.setCell(i, 8, Col_data[i].Rate);
                            DataTable.setCell(i, 9, Col_data[i].Amount);
                            DataTable.setCell(i, 10, Col_data[i].PoStatus);
                            DataTable.setCell(i, 11, Col_data[i].RaisedDate);
                            DataTable.setCell(i, 12, Col_data[i].RaisedBy);

                        }
                      //  $('#Detail1Div').hide();
                        var PathCollectedTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        PathCollectedTableDetails.draw(DataTable, {
                            allowHtml: true, showRowNumber: true, width: "100%"
                        });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }



        function Sale_PatientWise() {

            $.ajax({
                url: "Services/mis.asmx/Sale_PatientWise",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Patient');
                        dataTable.addColumn('number', 'Amount');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Patient);
                            dataTable.setCell(i, 1, mis_data[i].Amount);

                        }
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "Patient Wise Sale",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "Patient Wise Sale",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "Patient Wise Sale",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );

                        }
                        //);
                        $('#tableDiv1').show();
                    }
                    else
                        $('#tableDiv1').hide();
                }
            });
        }

        function Salary_DeptWise(SalaryMonth) {

            $.ajax({
                url: "Services/mis.asmx/Salary_DeptWise",
                data: '{SalaryMonth:"' + SalaryMonth + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'Employee Cost');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].EmployeeCost);

                        }

                        new google.visualization.ComboChart(document.getElementById('char1Div')).
                        draw(dataTable,
                        {
                            colors: ['green'],
                            title: 'Department Wise Salary', fontName: '"Arial"',
                            width: 950,
                            height: 500,
                            vAxis: { title: "EmployeeCost" },
                            hAxis: { title: "Department", gridlines: { count: 2 } },
                            seriesType: "bars",
                            series: { 1: { type: "line" } }
                        }
                      );

                    }
                    else {
                        modelAlert('No Record Found');
                    }
                }
            });
        }


        function Admit_Graph(FromDate, ToDate) {
            $('#AreaDiv').show();
            $('#Detail1Div').hide();
            //$('#Detail2Div').hide();
            $.ajax({
                url: "Services/mis.asmx/Admission_monthwise_graph",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);

                        if (mis_data.length > 0) {

                            var dataTable = new google.visualization.DataTable();
                            dataTable.addColumn('string', 'Months');
                            dataTable.addColumn('number', 'Admission');


                            dataTable.addRows(mis_data.length);
                            for (var i = 0; i < mis_data.length; i++) {
                                dataTable.setCell(i, 0, mis_data[i].Months);
                                dataTable.setCell(i, 1, mis_data[i].Admission);

                            }

                            var chartType = document.getElementById('ddlChartType').value;

                            if (chartType == 0) {
                                var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                                Chart.draw(dataTable,
                               {
                                   title: "Month Wise Admission",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 351,
                                   annotations: { alwaysOutside: true },

                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            else if (chartType == 1) {
                                var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                                Chart.draw(dataTable,
                               {
                                   title: "Month Wise Admission",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 351,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 80, top: 18, width: "95%" },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            if (chartType == 2) {
                                var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                                Chart.draw(dataTable,
                               {
                                   title: "Month Wise Admission",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 351,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );


                            }
                            $('#Detail1Div').hide(); $('#tableDiv1').hide(); $('#tableDiv2').hide();
                            $('#char1Div').show(); $('#divExport').hide();
                            $('#char2Div').show();
                            google.visualization.events.addListener(Chart, 'select', selectHandler);

                            function selectHandler() {
                                var selectedItem = Chart.getSelection()[0];
                                if (selectedItem) {
                                    var topping = dataTable.getValue(selectedItem.row, 0);
                                    $.ajax({
                                        url: "Services/mis.asmx/Admission_monthwise_graph",
                                        data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                        type: "POST",
                                        async: true,
                                        dataType: "json",
                                        contentType: "application/json; charset=utf-8",
                                        success: function (mydata) {

                                            var mis_data = jQuery.parseJSON(mydata.d);
                                           
                                            if (mis_data.length > 0) {

                                                var dataTable = new google.visualization.DataTable();
                                                dataTable.addColumn('string', 'Months');
                                                dataTable.addColumn('number', 'Admission');


                                                dataTable.addRows(mis_data.length);
                                                for (var i = 0; i < mis_data.length; i++) {
                                                    dataTable.setCell(i, 0, mis_data[i].Months);
                                                    dataTable.setCell(i, 1, mis_data[i].Admission);

                                                }

                                                var table = new google.visualization.Table(document.getElementById('tableDiv1'));

                                                table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                                $('#tableDiv1').show(); $('#Detail1Div').hide();
                                              //  $('#Detail2Div').hide();
                                                google.visualization.events.addListener(table, 'select', selectHandler);
                                                function selectHandler() {
                                                    var AdmittableselectedItem = table.getSelection()[0];
                                                    if (AdmittableselectedItem) {
                                                        $('#AreaDiv').show();
                                                        selectedValue = 'AdmittedMonthWiseDetail';
                                                        AdmittedMonthWiseDetail(FromDate, ToDate);
                                                    }
                                                }
                                            }

                                        }
                                    });
                                }

                            }
                            $('#AreaDiv').show();
                        }
               
                    else {
                            $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                }
            });
        }

        function AdmittedMonthWiseDetail(FromDate, ToDate) {
            $('#Detail1Div').show(); $('#divExport').show();
            $.ajax({
                url: "Services/mis.asmx/Admission_monthwise_graphDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('number', 'IPDNO');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('string', 'Sex');
                        DataTable.addColumn('string', 'Company_Name');
                        DataTable.addColumn('string', 'AdmittedRoom');
                        DataTable.addColumn('string', 'STATUS');
                        DataTable.addColumn('string', 'DateOfAdmit');
                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].IPDNO);
                            DataTable.setCell(i, 1, Col_data[i].PName);
                            DataTable.setCell(i, 2, Col_data[i].Age);
                            DataTable.setCell(i, 3, Col_data[i].Sex);
                            DataTable.setCell(i, 4, Col_data[i].Company_Name);
                            DataTable.setCell(i, 5, Col_data[i].AdmittedRoom);
                            DataTable.setCell(i, 6, Col_data[i].STATUS);
                            DataTable.setCell(i, 7, Col_data[i].DateOfAdmit);
                            DataTable.setCell(i, 8, Col_data[i].Doctor);



                        }
                        var AdmMonthTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        AdmMonthTableDetails.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show();
                        //$('#Detail2Div').hide(); 
                        $('#AreaDiv').show();
                    }
                    else {
                        $('#AreaDiv').hide();
                    }
                }
            });
        }
        function Discharge_Graph(FromDate, ToDate) {

            $.ajax({
                url: "Services/mis.asmx/Discharge_monthwise_graph",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Months');
                        dataTable.addColumn('number', 'Discharge');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Months);
                            dataTable.setCell(i, 1, mis_data[i].Discharge);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Month Wise Discharge",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Month Wise Discharge",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Month Wise Discharge",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        } $('#chart2Div').show();
                        $('#tableDiv2').hide();
                        $('#Detail1Div').hide();
                       // $('#Detail2Div').show();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);

                                $.ajax({
                                    url: "Services/mis.asmx/Discharge_monthwise_graph",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'Months');
                                            dataTable.addColumn('number', 'Discharge');


                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].Months);
                                                dataTable.setCell(i, 1, mis_data[i].Discharge);

                                            }

                                            var table = new google.visualization.Table(document.getElementById('tableDiv2'));

                                            table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#tableDiv2').show();
                                            google.visualization.events.addListener(table, 'select', selectHandler);
                                            function selectHandler() {
                                                var AdmittableselectedItem = table.getSelection()[0];
                                                if (AdmittableselectedItem) {
                                                    selectedValue = 'DischargeMonthWiseDetail';
                                                    DischargeMonthWiseDetail(FromDate, ToDate);
                                                }
                                            }

                                        }

                                    }
                                });
                            }

                        }
                        $('#AreaDiv').show();
                    }
                    else
                        $('#AreaDiv').hide();
                }
            });
        }
        function DischargeMonthWiseDetail(FromDate, ToDate) {
            $('#Detail1Div').hide();
            $('#divExport').show();
            $.ajax({
                url: "Services/mis.asmx/Discharge_monthwise_graphDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var DischargeDetailCol_data = jQuery.parseJSON(mydata.d);
                    if (DischargeDetailCol_data.length > 0) {
                        var DischargeDetailDataTable = new google.visualization.DataTable();
                        DischargeDetailDataTable.addColumn('number', 'IPDNO');
                        DischargeDetailDataTable.addColumn('string', 'PName');
                        DischargeDetailDataTable.addColumn('string', 'Age');
                        DischargeDetailDataTable.addColumn('string', 'Sex');
                        DischargeDetailDataTable.addColumn('string', 'Company_Name');
                        DischargeDetailDataTable.addColumn('string', 'AdmittedRoom');
                        DischargeDetailDataTable.addColumn('string', 'STATUS');

                        DischargeDetailDataTable.addColumn('string', 'DateOfAdmit');
                        DischargeDetailDataTable.addColumn('string', 'DateOfDischarge');
                        DischargeDetailDataTable.addColumn('string', 'Doctor');
                        DischargeDetailDataTable.addRows(DischargeDetailCol_data.length);

                        for (var i = 0; i < DischargeDetailCol_data.length; i++) {
                            DischargeDetailDataTable.setCell(i, 0, DischargeDetailCol_data[i].IPDNO);
                            DischargeDetailDataTable.setCell(i, 1, DischargeDetailCol_data[i].PName);
                            DischargeDetailDataTable.setCell(i, 2, DischargeDetailCol_data[i].Age);
                            DischargeDetailDataTable.setCell(i, 3, DischargeDetailCol_data[i].Sex);
                            DischargeDetailDataTable.setCell(i, 4, DischargeDetailCol_data[i].Company_Name);
                            DischargeDetailDataTable.setCell(i, 5, DischargeDetailCol_data[i].AdmittedRoom);
                            DischargeDetailDataTable.setCell(i, 6, DischargeDetailCol_data[i].STATUS);
                            DischargeDetailDataTable.setCell(i, 7, DischargeDetailCol_data[i].DateOfAdmit);
                            DischargeDetailDataTable.setCell(i, 8, DischargeDetailCol_data[i].DateOfDischarge);
                            DischargeDetailDataTable.setCell(i, 9, DischargeDetailCol_data[i].Doctor);



                        }
                        var DischargeDetailTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        DischargeDetailTableDetails.draw(DischargeDetailDataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }
        function IPDCollection(FromDate, ToDate) {
            $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/IPDCollection_graph",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Months');
                        dataTable.addColumn('number', 'Advance');
                        dataTable.addColumn('number', 'Settlement');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Months);
                            dataTable.setCell(i, 1, mis_data[i].Advance);
                            dataTable.setCell(i, 2, mis_data[i].Settlement);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Advance & Settelment",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Advance & Settelment",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Advance & Settelment",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        $('#char1Div').show();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                              
                                $.ajax({
                                    url: "Services/mis.asmx/IPDCollection_graphDetail",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'ReceiptNo');
                                            dataTable.addColumn('number', 'IPDNo');
                                            dataTable.addColumn('string', 'PatientName');
                                            dataTable.addColumn('string', 'Sex');
                                            dataTable.addColumn('string', 'Panel');
                                            dataTable.addColumn('string', 'RecieptDate');
                                            dataTable.addColumn('number', 'AmountPaid');
                                            dataTable.addColumn('string', 'UserName');
                                            dataTable.addColumn('string', 'PaymentMode');

                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].ReceiptNo);
                                                dataTable.setCell(i, 1, mis_data[i].IPDNo);
                                                dataTable.setCell(i, 2, mis_data[i].PatientName);
                                                dataTable.setCell(i, 3, mis_data[i].Sex);
                                                dataTable.setCell(i, 4, mis_data[i].Panel);
                                                dataTable.setCell(i, 5, mis_data[i].RecieptDate);
                                                dataTable.setCell(i, 6, mis_data[i].AmountPaid);
                                                dataTable.setCell(i, 7, mis_data[i].UserName);
                                                dataTable.setCell(i, 8, mis_data[i].PaymentMode);

                                            }

                                            var table = new google.visualization.Table(document.getElementById('Detail1Div'));

                                            table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#Detail1Div').show(); $('#divExport').show();

                                        }

                                    }
                                });
                            }

                        }
                        $('#AreaDiv').show();
                    }
                    else
                        $('#AreaDiv').hide();
                }
            });
        }

        function Advance_Bill_Detail(FromDate, ToDate) {
            $('#Detail1Div').hide(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/Advance_Bill_Detail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'MONTH');
                        dataTable.addColumn('number', 'Advance');
                        dataTable.addColumn('number', 'Bill');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].MONTH);
                            dataTable.setCell(i, 1, mis_data[i].Advance);
                            dataTable.setCell(i, 2, mis_data[i].Bill);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Advance & Bill Generate Amount",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Advance & Bill Generate Amount",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Advance & Bill Generate Amount",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();                      
                        $('#Advance_BillTable').show();
                        $('#Detail1Div').hide();                    
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));

                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#chart2Div').show();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);
                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                BindIPD_AdvanceBillDetail(FromDate, ToDate);
                            }
                        }
                        $('#AreaDiv').show();
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                        }
                }
            });
        }


        function BindIPD_AdvanceBillDetail(FromDate, ToDate) {

            $.ajax({
                url: "Services/mis.asmx/IPDAdvance_Bill_Detail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var IPD_AdvanceBillCol_data = jQuery.parseJSON(mydata.d);
                    if (IPD_AdvanceBillCol_data.length > 0) {
                        var IPDAdvanceBillDataTable = new google.visualization.DataTable();
                        IPDAdvanceBillDataTable.addColumn('string', 'ReceiptNo');
                        IPDAdvanceBillDataTable.addColumn('string', 'UHID');
                        IPDAdvanceBillDataTable.addColumn('string', 'PatientName');
                        IPDAdvanceBillDataTable.addColumn('string', 'Sex');
                        IPDAdvanceBillDataTable.addColumn('string', 'Panel');
                        IPDAdvanceBillDataTable.addColumn('string', 'RecieptDate');
                        IPDAdvanceBillDataTable.addColumn('number', 'Bill');
                        IPDAdvanceBillDataTable.addColumn('number', 'AmountPaid');
                        IPDAdvanceBillDataTable.addColumn('string', 'UserName');
                        IPDAdvanceBillDataTable.addRows(IPD_AdvanceBillCol_data.length);


                        for (var i = 0; i < IPD_AdvanceBillCol_data.length; i++) {
                            IPDAdvanceBillDataTable.setCell(i, 0, IPD_AdvanceBillCol_data[i].ReceiptNo);
                            IPDAdvanceBillDataTable.setCell(i, 1, IPD_AdvanceBillCol_data[i].UHID);
                            IPDAdvanceBillDataTable.setCell(i, 2, IPD_AdvanceBillCol_data[i].PatientName);
                            IPDAdvanceBillDataTable.setCell(i, 3, IPD_AdvanceBillCol_data[i].Sex);
                            IPDAdvanceBillDataTable.setCell(i, 4, IPD_AdvanceBillCol_data[i].Panel);
                            IPDAdvanceBillDataTable.setCell(i, 5, IPD_AdvanceBillCol_data[i].RecieptDate);
                            IPDAdvanceBillDataTable.setCell(i, 6, IPD_AdvanceBillCol_data[i].Bill);
                            IPDAdvanceBillDataTable.setCell(i, 7, IPD_AdvanceBillCol_data[i].AmountPaid);
                            IPDAdvanceBillDataTable.setCell(i, 8, IPD_AdvanceBillCol_data[i].UserName);

                        }
                        var IPDAdvanceBilltable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        IPDAdvanceBilltable.draw(IPDAdvanceBillDataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function BedAvailable_Graph() {
            $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/BedAvailable",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'RoomType');
                        DataTable.addColumn('number', 'AvailableBed');

                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].RoomType);
                            DataTable.setCell(i, 1, Col_data[i].AvailableBed);

                        }
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(DataTable,
                           {
                               title: "Bed Available",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(DataTable,
                           {
                               title: "Bed Available",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(DataTable,
                           {
                               title: "Bed Available",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );

                        }
                                    
                        $('#char1Div').show();
                        $('#Detail1Div').hide(); $('#Detail1Div').hide();                    
                        $('#AreaDiv').show();
                    }
                    else
                        $('#AreaDiv').hide();
                }
            });
        }

        function BedOccupancy() {
            $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/BedOccupied",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'RoomType');
                        DataTable.addColumn('number', 'OccupiedBed');
                        DataTable.addColumn('number', 'IPDCaseTypeID');
                       
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].RoomType);
                            DataTable.setCell(i, 1, Col_data[i].OccupiedBed);
                            DataTable.setCell(i, 2, Col_data[i].IPDCaseTypeID);

                        }
                        var view = new google.visualization.DataView(DataTable);
                        view.setColumns([0, 1]);
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Bed Occupied",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Bed Occupied",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(view,
                           {
                               title: "Bed Occupied",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );

                        }

                        $('#chart2Div').show();

                        google.visualization.events.addListener(Chart, 'select', selectHandler);
                        function selectHandler() {
                            var BedtableselectedItem = Chart.getSelection()[0];
                            if (BedtableselectedItem) {
                                var toppingRoomId = DataTable.getValue(BedtableselectedItem.row, 2);
                                selectedValue = toppingRoomId;
                                BedOccupancy_GraphDetail($('#txtFromDate').val(), $('#txtToDate').val(), toppingRoomId);
                            }
                        }
                    }
                    else
                        $('#chart2Div').hide();
                }
            });
        }


        function BedOccupancy_GraphDetail(FromDate, ToDate, toppingRoomId) {
            $.ajax({
                url: "Services/mis.asmx/BedOccupancy_GraphDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",Room:"' + toppingRoomId + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('number', 'IPDNO');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('string', 'Sex');
                        DataTable.addColumn('string', 'Company_Name');
                        DataTable.addColumn('string', 'Room');
                        DataTable.addColumn('string', 'DateOfAdmit');
                        DataTable.addColumn('string', 'Status');
                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].IPDNO);
                            DataTable.setCell(i, 1, Col_data[i].PName);
                            DataTable.setCell(i, 2, Col_data[i].Age);
                            DataTable.setCell(i, 3, Col_data[i].Sex);
                            DataTable.setCell(i, 4, Col_data[i].Company_Name);
                            DataTable.setCell(i, 5, Col_data[i].Room);
                            DataTable.setCell(i, 6, Col_data[i].DateOfAdmit);
                            DataTable.setCell(i, 7, Col_data[i].Status);
                            DataTable.setCell(i, 8, Col_data[i].Doctor);

                        }
                        var BedCoccupationTableDetails = new google.visualization.Table(document.getElementById('Detail1Div'));
                        BedCoccupationTableDetails.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function OPD_Collection(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/OPD_Collection",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'PaymentMode');
                        dataTable.addColumn('number', 'Amount');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].PaymentMode);
                            dataTable.setCell(i, 1, mis_data[i].Amount);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Cash Collection (Payment Mode Wise)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Cash Collection (Payment Mode Wise)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Cash Collection (Payment Mode Wise)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        $('#tableDiv1').hide(); $('#char1Div').show();
                       // $('#Detail2Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                $.ajax({
                                    url: "Services/mis.asmx/OPD_Collection",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'PaymentMode');
                                            dataTable.addColumn('number', 'Amount');

                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].PaymentMode);
                                                dataTable.setCell(i, 1, mis_data[i].Amount);

                                            }

                                            var table = new google.visualization.Table(document.getElementById('tableDiv1'));
                                            table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#tableDiv1').show();

                                            google.visualization.events.addListener(table, 'select', selectHandlerCashtable);
                                            function selectHandlerCashtable() {
                                                var CashtableselectedItem = table.getSelection()[0];
                                                if (CashtableselectedItem) {
                                                    BindOPDCollectionDetail(FromDate, ToDate);
                                                }
                                            }

                                        }

                                    }
                                });
                            }

                        }

                        $('#AreaDiv').show();

                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }

                }
            });
        }

        function Collection_TypOfTnx(FromDate, ToDate) {

            $.ajax({
                url: "Services/mis.asmx/Collection_TnxWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'TypeOfTnx');
                        dataTable.addColumn('number', 'NetAmount');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].TypeOfTnx);
                            dataTable.setCell(i, 1, mis_data[i].NetAmount);

                        }

                  

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Cash Collection (Transaction Type Wise)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Cash Collection (Transaction Type Wise)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Cash Collection (Transaction Type Wise)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                          
                        }
                        $('#chart2Div').show();
                        $('#tableDiv2').hide();
                        $('#Detail1Div').hide();
                      //  $('#Detail2Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                $.ajax({
                                    url: "Services/mis.asmx/Collection_TnxWise",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'TypeOfTnx');
                                            dataTable.addColumn('number', 'NetAmount');

                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].TypeOfTnx);
                                                dataTable.setCell(i, 1, mis_data[i].NetAmount);

                                            }

                                            var table = new google.visualization.Table(document.getElementById('tableDiv2'));
                                            table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#tableDiv2').show();

                                            google.visualization.events.addListener(table, 'select', selectHandlerCashtable);
                                            function selectHandlerCashtable() {
                                                var CashtableselectedItem = table.getSelection()[0];
                                                if (CashtableselectedItem) {
                                                    BindOPDCollectionDetail(FromDate, ToDate);
                                                }
                                            }

                                        }

                                    }
                                });
                            }

                        }

                        $('#AreaDiv').show();
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                }
            });
        }

        function BindOPDCollectionDetail(FromDate, ToDate) {

          //  $('#Detail2Div').hide();
            $.ajax({
                url: "Services/mis.asmx/OPDCollectionDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'ReceiptNo');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addColumn('string', 'UserName');
                        DataTable.addColumn('number', 'Cash');
                        DataTable.addColumn('number', 'Cheque');
                        DataTable.addColumn('number', 'OPDAdvance');
                        DataTable.addColumn('number', 'Credit_card');
                        DataTable.addColumn('number', 'Credit');
                        DataTable.addColumn('number', 'Online_Payment');
                        DataTable.addColumn('number', 'Others');
                        DataTable.addColumn('number', 'TotalAmount');



                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].ReceiptNo);
                            DataTable.setCell(i, 1, Col_data[i].UHID);
                            DataTable.setCell(i, 2, Col_data[i].PName);
                            //DataTable.setCell(i, 3, Col_data[i].Age);
                            DataTable.setCell(i, 3, Col_data[i].Doctor);
                            DataTable.setCell(i, 4, Col_data[i].UserName);
                            DataTable.setCell(i, 5, Col_data[i].Cash);
                            DataTable.setCell(i, 6, Col_data[i].Cheque);
                            DataTable.setCell(i, 7, Col_data[i].OPDAdvance);
                            DataTable.setCell(i, 8, Col_data[i].Credit_card);
                            DataTable.setCell(i, 9, Col_data[i].Credit);
                            DataTable.setCell(i, 10, Col_data[i].Online_Payment);
                            DataTable.setCell(i, 11, Col_data[i].Others);
                            DataTable.setCell(i, 12, Col_data[i].TotalAmount);



                        }
                        var table = new google.visualization.Table(document.getElementById('Detail1Div'));
                        table.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#Detail1Div').hide();
                    }
                }
            });
        }

        function OPD_Business_CategoryWise(FromDate, ToDate) {

            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/OPD_Business_CategoryWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'CategoryID');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].Amount);
                            dataTable.setCell(i, 2, mis_data[i].CategoryID);

                        }


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'OPD Business Category Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'OPD Business Category Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'OPD Business Category Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        $('#char1Div').show();
                        $('#chart2Div').hide();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);
                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);
                               
                                OPD_Business_SubCategoryWise($('#txtFromDate').val(), $('#txtToDate').val(), topping);
                                //clear detail of subcategory 
                               // $('#OPD_Business_SubCategoryWise').text('');
                            }
                        }

                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        }

        function OPD_Business_SubCategoryWise(FromDate, ToDate, CategoryID) {

            // $('#OPD_Business_SubCategoryWise').show();
            $.ajax({
                url: "Services/mis.asmx/OPD_Business_SubCategoryWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CategoryID:"' + CategoryID + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'SubCategoryID');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].Amount);
                            dataTable.setCell(i, 2, mis_data[i].SubCategoryID);
                        }



                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'OPD Business SubCategory Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'OPD Business SubCategory Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'OPD Business SubCategory Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        $('#tableDiv1').hide();
                        $('#chart2Div').show();

                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);
                                selectedValue = topping;
                                OPD_Business_ItemWise($('#txtFromDate').val(), $('#txtToDate').val(), topping);
                            }
                        }

                    }
                }
            });
        }

        function OPD_Business_ItemWise(FromDate, ToDate, SubCategoryID) {
            $('#tableDiv1').hide();
            $('#tableDiv2').hide();
            $('#Detail1Div').show(); $('#divExport').show();
            $.ajax({
                url: "Services/mis.asmx/OPD_Business_ItemWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",SubCategoryID:"' + SubCategoryID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'UHID');
                        dataTable.addColumn('string', 'Patient Name');
                        dataTable.addColumn('string', 'Item Name');
                        dataTable.addColumn('number', 'Rate');
                        dataTable.addColumn('number', 'Quantity');
                        dataTable.addColumn('number', 'Gross Amount');
                        dataTable.addColumn('number', 'Discount');
                        dataTable.addColumn('number', 'Net Amount');
                        dataTable.addColumn('string', 'Date');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {

                            dataTable.setCell(i, 0, mis_data[i].PatientID);
                            dataTable.setCell(i, 1, mis_data[i].PName);
                            dataTable.setCell(i, 2, mis_data[i].ItemName);
                            dataTable.setCell(i, 3, mis_data[i].Rate);
                            dataTable.setCell(i, 4, mis_data[i].Quantity);
                            dataTable.setCell(i, 5, mis_data[i].GrossAmt);
                            dataTable.setCell(i, 6, mis_data[i].Discount);
                            dataTable.setCell(i, 7, mis_data[i].Amount);
                            dataTable.setCell(i, 8, mis_data[i].DATE);

                        }

                        var table = new google.visualization.Table(document.getElementById('Detail1Div'));

                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });

                    }
                }
            });
        }

        function IPD_Business_CategoryWise(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $('#chart2Div', '#tableDiv1').hide();
            $.ajax({
                url: "Services/mis.asmx/IPD_Business_CategoryWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'CategoryID');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].Amount);
                            dataTable.setCell(i, 2, mis_data[i].CategoryID);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'IPD Business Category Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'IPD Business Category Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'IPD Business Category Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        $('#char1Div').show();                      
                        $('#chart2Div').hide();
                        $('#tableDiv1').hide(); $('#Detail1Div').hide(); $('#divExport').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);
                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);
                                
                                IPD_Business_SubCategoryWise($('#txtFromDate').val(), $('#txtToDate').val(), topping);

                            }
                        }


                    }
                    else{
                        modelAlert('No Record found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        }

        function IPD_Business_SubCategoryWise(FromDate, ToDate, CategoryID) {
            $.ajax({
                url: "Services/mis.asmx/IPD_Business_SubCategoryWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CategoryID:"' + CategoryID + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'SubCategoryID');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Department);
                            dataTable.setCell(i, 1, mis_data[i].Amount);
                            dataTable.setCell(i, 2, mis_data[i].SubCategoryID);
                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'IPD Business SubCategory Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'IPD Business SubCategory Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               'title': 'IPD Business SubCategory Wise',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        $('#tableDiv1').hide(); $('#tableDiv2').hide();
                        $('#chart2Div').show(); $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);
                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);
                                selectedValue = topping;
                                IPD_Business_ItemWise($('#txtFromDate').val(), $('#txtToDate').val(), topping);
                            }
                        }
                    }
                }
            });
        }

        function IPD_Business_ItemWise(FromDate, ToDate, SubCategoryID) {

            $.ajax({
                url: "Services/mis.asmx/IPD_Business_ItemWise",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",SubCategoryID:"' + SubCategoryID + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();

                        dataTable.addColumn('string', 'UHID');
                        dataTable.addColumn('string', 'Patient Name');
                        dataTable.addColumn('string', 'Item Name');
                        dataTable.addColumn('number', 'Rate');
                        dataTable.addColumn('number', 'Quantity');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('string', 'Date');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].PatientID);
                            dataTable.setCell(i, 1, mis_data[i].PName);
                            dataTable.setCell(i, 2, mis_data[i].ItemName);
                            dataTable.setCell(i, 3, mis_data[i].Rate);
                            dataTable.setCell(i, 4, mis_data[i].Quantity);
                            dataTable.setCell(i, 5, mis_data[i].Amount);
                            dataTable.setCell(i, 6, mis_data[i].Date);
                        }
                        $('#Detail1Div').show(); $('#divExport').show();
                        var table = new google.visualization.Table(document.getElementById('Detail1Div'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                    }
                }
            });
        }

        function Sale_DateWise() {
            $.ajax({
                url: "Services/mis.asmx/Sale_DateWise",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Day');
                        dataTable.addColumn('number', 'OPD Patient');
                        dataTable.addColumn('number', 'IPD Patient');

                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Dt);
                            dataTable.setCell(i, 1, mis_data[i].OPD);
                            dataTable.setCell(i, 2, mis_data[i].IPD);
                        }


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Last 30 Days Pharmacy Sale Analysis",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Last 30 Days Pharmacy Sale Analysis",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Last 30 Days Pharmacy Sale Analysis",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                    }
                    else
                        $('#char1Div').hide();
                }
            });
        }

        function Sale_MonthWise() {

            $.ajax({
                url: "Services/mis.asmx/Sale_MonthWise",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Month');
                        dataTable.addColumn('number', 'OPD Patient');
                        dataTable.addColumn('number', 'IPD Patient');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].months);
                            dataTable.setCell(i, 1, mis_data[i].OPD);
                            dataTable.setCell(i, 2, mis_data[i].IPD);
                        }


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Last 6 Month Sale Analysis",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Last 6 Month Sale Analysis",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Last 6 Month Sale Analysis",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#chart2Div').show();
                    }
                    else
                        $('#chart2Div').hide();
                }
            });
        }


        function OPD_Graph(FromDate, ToDate) {
            $('#AreaDiv').show();
            $('#char1Div').show();
            $.ajax({
                url: "Services/mis.asmx/OPD_Graph",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Day');
                        dataTable.addColumn('number', 'Appointment');
                        dataTable.addColumn('number', 'Confirm Appointment');
                        dataTable.addColumn('number', 'Registration');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Dt);
                            dataTable.setCell(i, 1, mis_data[i].Appointment);
                            dataTable.setCell(i, 2, mis_data[i].ConfirmAppointment);
                            dataTable.setCell(i, 3, mis_data[i].Registration);
                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 30 Days OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               hAxis: { title: "Date" },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 30 Days OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                               hAxis: { title: "Date" },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 30 Days OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                               hAxis: { title: "Date" },
                           }
                        );
                        }
                      //  $('#AreaDiv').show();
                        $('#char1Div').show();
                    }
                    else {
                        $('#char1Div').hide();
                      modelAlert('No Record Found');
                        
                    }
                }
            });
        }

        function OPD_Graph_Month() {
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/OPD_Graph_Month",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Month');
                        dataTable.addColumn('number', 'Appointment');
                        dataTable.addColumn('number', 'Confirm Appointment');
                        dataTable.addColumn('number', 'Registration');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].months);
                            dataTable.setCell(i, 1, mis_data[i].Appointment);
                            dataTable.setCell(i, 2, mis_data[i].ConfirmAppointment);
                            dataTable.setCell(i, 3, mis_data[i].Registration);
                        }


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 12 Month OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               hAxis: { title: "Date" },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 12 Month OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                               hAxis: { title: "Date" },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 12 Month OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                               hAxis: { title: "Date" },
                           }
                        );


                        }

                    }
                }
               
            }); $('#chart2Div').show();
        }

        function Consumption() {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/Store_Req_Issue",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Department');
                        dataTable.addColumn('number', 'Requisition');
                        dataTable.addColumn('number', 'Reject');
                        dataTable.addColumn('number', 'Issue');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].LedgerName);
                            dataTable.setCell(i, 1, mis_data[i].Requisition);
                            dataTable.setCell(i, 2, mis_data[i].Reject);
                            dataTable.setCell(i, 3, mis_data[i].Issue);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Consumption",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Consumption",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "Consumption",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                ConsumptionDept_Detail($('#txtFromDate').val(), $('#txtToDate').val());

                            }

                        }
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                       
                    }
                }
            });
        }

        function ConsumptionDept_Detail(FromDate, ToDate) {

            $('#Detail1Div').show();
            $.ajax({
                url: "Services/mis.asmx/ConsumptionByDept",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'CentreName');
                        DataTable.addColumn('string', 'ConsumeByDepartment');
                        DataTable.addColumn('string', 'GroupName');
                        DataTable.addColumn('string', 'ItemName');
                        DataTable.addColumn('number', 'ConsumeQty');
                        DataTable.addColumn('string', 'ConsumeDate');
                        DataTable.addColumn('string', 'UserName');


                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].CentreName);
                            DataTable.setCell(i, 1, Col_data[i].ConsumeByDepartment);
                            DataTable.setCell(i, 2, Col_data[i].GroupName);
                            DataTable.setCell(i, 3, Col_data[i].ItemName);
                            DataTable.setCell(i, 4, Col_data[i].ConsumeQty);
                            DataTable.setCell(i, 5, Col_data[i].ConsumeDate);
                            DataTable.setCell(i, 6, Col_data[i].UserName);
                        }
                        var ConsumptionDepttable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        ConsumptionDepttable.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }
        function OPD_Graph_Year() {         
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/OPD_Graph_Year",
                data: '{CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Year');
                        dataTable.addColumn('number', 'Appointment');
                        dataTable.addColumn('number', 'Confirm Appointment');
                        dataTable.addColumn('number', 'Registration');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].yrs);
                            dataTable.setCell(i, 1, mis_data[i].Appointment);
                            dataTable.setCell(i, 2, mis_data[i].ConfirmAppointment);
                            dataTable.setCell(i, 3, mis_data[i].Registration);
                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 5 Year OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               hAxis: { title: "Date" },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 5 Year OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                               hAxis: { title: "Date" },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('tableDiv1'));
                            Chart.draw(dataTable,
                           {
                               title: "OPD (Last 5 Year OPD Appointment,Confirmation & Registration Analysis)",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                               hAxis: { title: "Date" },
                           }
                        );


                        } $('#tableDiv1').show();

                    }
                }
            });
        }


        function bindIPDAdmissionType(FromDate, ToDate) {
            $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/IPDAdmissionType",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Name');
                        dataTable.addColumn('number', 'COUNT');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].AdmissionType);
                            dataTable.setCell(i, 1, mis_data[i].AdmissionTypeCount);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Admission Type",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Admission Type",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "IPD Admission Type",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();                    
                        $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#chart2Div').show();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                selectedValue = topping;
                                $.ajax({
                                    url: "Services/mis.asmx/IPDAdmissionTypeDetail",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",AdmissionType :"' + topping + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'Admission_type');
                                            dataTable.addColumn('number', 'IPDNO');
                                            dataTable.addColumn('string', 'PName');
                                            dataTable.addColumn('string', 'Age');
                                            dataTable.addColumn('string', 'Sex');
                                            dataTable.addColumn('string', 'Company_Name');
                                            dataTable.addColumn('string', 'DateOfAdmit');
                                            dataTable.addColumn('string', 'DateOfDischarge');
                                            dataTable.addColumn('string', 'STATUS');
                                            dataTable.addColumn('string', 'Doctor');


                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].Admission_type);
                                                dataTable.setCell(i, 1, mis_data[i].IPDNO);
                                                dataTable.setCell(i, 2, mis_data[i].PName);
                                                dataTable.setCell(i, 3, mis_data[i].Age);
                                                dataTable.setCell(i, 4, mis_data[i].Sex);
                                                dataTable.setCell(i, 5, mis_data[i].Company_Name);
                                                dataTable.setCell(i, 6, mis_data[i].DateOfAdmit);
                                                dataTable.setCell(i, 7, mis_data[i].DateOfDischarge);
                                                dataTable.setCell(i, 8, mis_data[i].STATUS);
                                                dataTable.setCell(i, 9, mis_data[i].Doctor);

                                            }

                                            var table = new google.visualization.Table(document.getElementById('Detail1Div'));

                                            table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#Detail1Div').show(); $('#divExport').show();

                                        }

                                    }
                                });
                            }

                        }
                        $('#AreaDiv').show();
                    }
                    else{ modelAlert('No Record Found');
                    $('#AreaDiv').hide();}

                }
            });
        }

        function bindPatientAnalysis(FromDate, ToDate) {           
          $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/StateAnalysis",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'State');
                        dataTable.addColumn('number', 'StateCount');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].State);
                            dataTable.setCell(i, 1, mis_data[i].StateCount);
                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: 'State Analysis',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: 'State Analysis',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 50, top: 45, width: "80%" },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: 'State Analysis',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#AreaDiv').show();
                        $('#char1Div').show();
                        $('#chart2Div,#tableDiv1,#tableDiv2,#Detail1Div').hide(); $('#divExport').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                    $('#CityWiseRefDoc,#CityWiseCollection').hide();
                                $.ajax({
                                    url: "Services/mis.asmx/DistrictAnalysis",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",State:"' + topping + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {
                                        var district_data = jQuery.parseJSON(mydata.d);
                                        if (district_data.length > 0) {
                                            var districtData = new google.visualization.DataTable();
                                            districtData.addColumn('string', 'District');
                                            districtData.addColumn('number', 'DistrictCount');
                                            districtData.addColumn('number', 'districtID');
                                            districtData.addRows(district_data.length);
                                            for (var i = 0; i < district_data.length; i++) {
                                                districtData.setCell(i, 0, district_data[i].District);
                                                districtData.setCell(i, 1, district_data[i].DistrictCount);
                                                districtData.setCell(i, 2, district_data[i].districtID);
                                            }

                                            var viewdistrictData = new google.visualization.DataView(districtData);
                                            viewdistrictData.setColumns([0, 1]);


                                            var chartType = document.getElementById('ddlChartType').value;

                                            if (chartType == 0) {
                                                var districtChart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                                                districtChart.draw(viewdistrictData,
                                               {
                                                   title: 'District Analysis',
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },
                                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                                   trendlines: { 0: {} },
                                               }
                                            );
                                            }
                                            else if (chartType == 1) {
                                                var districtChart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                                                districtChart.draw(viewdistrictData,
                                               {
                                                   title: 'District Analysis',
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },
                                                   legend: { position: 'bottom' },
                                                   chartArea: { left: 50, top: 45, width: "80%" },
                                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                                   trendlines: { 0: {} },
                                               }
                                            );
                                            }
                                            if (chartType == 2) {
                                                var districtChart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                                                districtChart.draw(viewdistrictData,
                                               {
                                                   title: 'District Analysis',
                                                   fontName: '"Arial"',
                                                   width: 578,
                                                   height: 351,
                                                   annotations: { alwaysOutside: true },
                                                   legend: { position: 'bottom' },
                                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                                   trendlines: { 0: {} },
                                               }
                                            );


                                            }

                                            $('#chart2Div').show();
                                            $('#chart2Div,#tableDiv1,#tableDiv2,#Detail1Div').hide(); $('#divExport').hide();

                                            google.visualization.events.addListener(districtChart, 'select', selectHandlerDistrict);

                                            function selectHandlerDistrict() {
                                                var districtChartselectedItem = districtChart.getSelection()[0];
                                                if (districtChartselectedItem) {
                                                    var toppingDistrict = districtData.getValue(districtChartselectedItem.row, 2);
                                                   
                                                    $.ajax({
                                                        url: "Services/mis.asmx/CityWiseRefDoc",
                                                        data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",District:"' + toppingDistrict + '"}',
                                                        type: "POST",
                                                        async: true,
                                                        dataType: "json",
                                                        contentType: "application/json; charset=utf-8",
                                                        success: function (mydata) {

                                                            var refDoc_data = jQuery.parseJSON(mydata.d);
                                                            if (refDoc_data.length > 0) {
                                                                var cityDataTable = new google.visualization.DataTable();
                                                                cityDataTable.addColumn('string', 'City');
                                                                cityDataTable.addColumn('string', 'Refer Doctor Name');
                                                                cityDataTable.addColumn('number', 'DoctorID');
                                                                cityDataTable.addColumn('number', 'districtID');
                                                                cityDataTable.addColumn('number', 'Count');
                                                                cityDataTable.addRows(refDoc_data.length);

                                                                for (var i = 0; i < refDoc_data.length; i++) {
                                                                    cityDataTable.setCell(i, 0, refDoc_data[i].City);
                                                                    cityDataTable.setCell(i, 1, refDoc_data[i].refDocName);
                                                                    cityDataTable.setCell(i, 2, refDoc_data[i].DoctorID);
                                                                    cityDataTable.setCell(i, 3, refDoc_data[i].districtID);
                                                                    cityDataTable.setCell(i, 4, refDoc_data[i].referDocCount);
                                                                }

                                                                var view = new google.visualization.DataView(cityDataTable);
                                                                view.setColumns([0, 1, 4]); //here you set the columns you want to display

                                                                var Citytable = new google.visualization.Table(document.getElementById('tableDiv1'));
                                                                var formatter = new google.visualization.TableBarFormat({ width: 340 });
                                                                formatter.format(cityDataTable, 4); // Apply formatter to second column
                                                                Citytable.draw(view, { allowHtml: true, showRowNumber: true });
                                                                $('#tableDiv1').show(); $('#divExport').hide();

                                                                google.visualization.events.addListener(Citytable, 'select', selectHandlerCitytable);


                                                                function selectHandlerCitytable() {
                                                                    var CitytableselectedItem = Citytable.getSelection()[0];
                                                                    if (CitytableselectedItem) {                                                            
                                                                        var toppingCitytabledistrictID = cityDataTable.getValue(CitytableselectedItem.row, 3);

                                                                        BindCityCollectionDetail(FromDate, ToDate, toppingCitytabledistrictID);
                                                                    }
                                                                }
                                                            }
                                                            else
                                                                $('#tableDiv1').hide();
                                                        }
                                                    });


                                                    $.ajax({
                                                        url: "Services/mis.asmx/CityWiseCollection",
                                                        data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",District:"' + toppingDistrict + '"}',
                                                        type: "POST",
                                                        async: true,
                                                        dataType: "json",
                                                        contentType: "application/json; charset=utf-8",
                                                        success: function (mydata) {

                                                            var cityWiseCol_data = jQuery.parseJSON(mydata.d);
                                                            if (cityWiseCol_data.length > 0) {
                                                                var cityColDataTable = new google.visualization.DataTable();
                                                                cityColDataTable.addColumn('string', 'City');
                                                                cityColDataTable.addColumn('number', 'Collection');
                                                                cityColDataTable.addColumn('number', 'districtID');

                                                                cityColDataTable.addRows(cityWiseCol_data.length);

                                                                for (var i = 0; i < cityWiseCol_data.length; i++) {
                                                                    cityColDataTable.setCell(i, 0, cityWiseCol_data[i].City);
                                                                    cityColDataTable.setCell(i, 1, cityWiseCol_data[i].PaidAmt);
                                                                    cityColDataTable.setCell(i, 2, cityWiseCol_data[i].districtID);

                                                                }
                                                                var view = new google.visualization.DataView(cityColDataTable);
                                                                view.setColumns([0, 1]);

                                                                var CityCollectiontable = new google.visualization.Table(document.getElementById('tableDiv2'));
                                                                var formatterCol = new google.visualization.TableBarFormat({ width: 420 });
                                                                formatterCol.format(cityColDataTable, 1); // Apply formatter to second column
                                                                CityCollectiontable.draw(view, { allowHtml: true, showRowNumber: true });
                                                                $('#tableDiv2').show();
                                                                google.visualization.events.addListener(CityCollectiontable, 'select', selectHandlercityCol);
                                                                function selectHandlercityCol() {
                                                                    var CitytableselectedItem = CityCollectiontable.getSelection()[0];
                                                                    if (CitytableselectedItem) {
                                                                        var toppingCitytabledistrictID = cityColDataTable.getValue(CitytableselectedItem.row, 2);

                                                                        BindCityCollectionDetail(FromDate, ToDate, toppingCitytabledistrictID);

                                                                    }
                                                                }
                                                            }
                                                            else
                                                                $('#tableDiv2').hide();
                                                        }
                                                    });




                                                }
                                            }

                                            //districtChart.draw(districtData, disoptions);

                                            $('#chart2Div').show();
                                        }
                                    }
                                });
                            }
                        }

                        //chart.draw(dataTable, options);

                        $('#AreaDiv').show();
                    }
                    else{
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');}
                }
            });
        }

        var selectedValue = '';

        function BindCityCollectionDetail(FromDate, ToDate, toppingCitytabledistrictID) {
            selectedValue = toppingCitytabledistrictID;
            $.ajax({
                url: "Services/mis.asmx/CityTableDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",districtID:"' + toppingCitytabledistrictID + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'RefDocName');
                        DataTable.addColumn('string', 'PatientID');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('number', 'OPD');
                        DataTable.addColumn('number', 'IPD');
                        DataTable.addColumn('number', 'EMG');
                        DataTable.addColumn('number', 'TotalCount');
                        DataTable.addColumn('number', 'OPD_AMT');
                        DataTable.addColumn('number', 'IPD_AMT');
                        DataTable.addColumn('number', 'EMG_AMT');
                        DataTable.addColumn('number', 'TotalCol');

                        DataTable.addRows(Col_data.length);
                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].refDocName);
                            DataTable.setCell(i, 1, Col_data[i].PatientID);
                            DataTable.setCell(i, 2, Col_data[i].PName);
                            DataTable.setCell(i, 3, Col_data[i].Gender);
                            DataTable.setCell(i, 4, Col_data[i].Age);

                            DataTable.setCell(i, 5, Col_data[i].OPD);
                            DataTable.setCell(i, 6, Col_data[i].IPD);
                            DataTable.setCell(i, 7, Col_data[i].EMG);
                            DataTable.setCell(i, 8, Col_data[i].TotalCount);

                            DataTable.setCell(i, 9, Col_data[i].OPD_AMT);
                            DataTable.setCell(i, 10, Col_data[i].IPD_AMT);
                            DataTable.setCell(i, 11, Col_data[i].EMG_AMT);
                            DataTable.setCell(i, 12, Col_data[i].TotalCol);

                        }

                        var CityCollectiontable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        CityCollectiontable.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }



        //profitSummary
        function bindProfitSummary(FromDate, ToDate) {

            $.ajax({
                url: "Analysis.aspx/ProfitSummary",
                data: '{fromDate:"' + FromDate + '",toDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Title');
                        dataTable.addColumn('number', 'TotalAmount');
                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Title);
                            dataTable.setCell(i, 1, mis_data[i].TotalAmount);
                        }

                        var options = {
                            title: 'Profilt Summary',
                            sliceVisibilityThreshold: 0,
                            width: 578, height: 351,
                            fontSize: 11,
                            slices: {
                                2: { offset: 0.2 },
                                4: { offset: 0.3 },
                                6: { offset: 0.4 },
                                8: { offset: 0.5 },
                                10: { offset: 0.6 },
                                14: { offset: 0.7 },
                                16: { offset: 0.8 },
                            },     
                            chartArea: { left: 10, right: 50, width: "85%" }

                        };

                        var options1 = {
                            title: 'Profilt Summary',                           
                            sliceVisibilityThreshold: 0,
                            width: 578, height: 351,
                            fontSize: 11,
                            slices: {
                                2: { offset: 0.2 },
                                4: { offset: 0.3 },
                                6: { offset: 0.4 },
                                8: { offset: 0.5 },
                                10: { offset: 0.6 },
                                14: { offset: 0.7 },
                                16: { offset: 0.8 },
                            },
                            legend: { position: 'bottom' },
                            chartArea: { left: 70, top: 18, width: "95%" },
                        };
                        var options2 = {
                            title: 'Profilt Summary',
                            sliceVisibilityThreshold: 0,
                            width: 578, height: 351,
                            fontSize: 11,
                            slices: {
                                2: { offset: 0.2 },
                                4: { offset: 0.3 },
                                6: { offset: 0.4 },
                                8: { offset: 0.5 },
                                10: { offset: 0.6 },
                                14: { offset: 0.7 },
                                16: { offset: 0.8 },
                            },
                        };

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            $detailWiseChart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            $detailWiseChart.draw(dataTable, options);
                        }
                        else if (chartType == 1) {
                            $detailWiseChart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            $detailWiseChart.draw(dataTable, options1);
                        }
                        if (chartType == 2) {
                            $detailWiseChart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            $detailWiseChart.draw(dataTable, options2);
                        }

                        $('#char1Div').show();

                        if (mis_data.length > 0) {
                            var ProfitSummaryTable = new google.visualization.Table(document.getElementById('chart2Div'));
                            var formatterCol = new google.visualization.TableBarFormat();
                            formatterCol.format(dataTable, 1); // Apply formatter to second column
                            ProfitSummaryTable.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%', height: '100%' });
                            $('#chart2Div').show();
                        }
                        $('#AreaDiv').show();

                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }

                }
            });
        }

        //salesTrades
        function salesTrend() {
            $('#AreaDiv').show(); $('#divExport').hide();

            $.ajax({
                url: "Analysis.aspx/SalesTrend",
                data: '{Year:"' + $("#ddlYear").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
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
                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: 'Sales Trend',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: 'Sales Trend',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 50, top: 45, width: "80%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: 'Sales Trend',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });

                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                SalesTradeDetail();
                            }

                        }

                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function SalesTradeDetail() {

            $.ajax({
                url: "Services/mis.asmx/SalesTrendDetail",
                data: '{Year:"' + $("#ddlYear").val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'Month');
                        DataTable.addColumn('string', 'CentreName');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addColumn('number', 'MRP');
                        DataTable.addColumn('number', 'NetSaleQty');
                        DataTable.addColumn('number', 'NetSalePrice');
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].Month);
                            DataTable.setCell(i, 1, Col_data[i].CentreName);
                            DataTable.setCell(i, 2, Col_data[i].PName);
                            DataTable.setCell(i, 3, Col_data[i].UHID);
                            DataTable.setCell(i, 4, Col_data[i].Age);
                            DataTable.setCell(i, 5, Col_data[i].Gender);
                            DataTable.setCell(i, 6, Col_data[i].Doctor);
                            DataTable.setCell(i, 7, Col_data[i].MRP);
                            DataTable.setCell(i, 8, Col_data[i].NetSaleQty);
                            DataTable.setCell(i, 9, Col_data[i].NetSalePrice);

                        }
                        var SaleTradetable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        SaleTradetable.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }





        //inventoryAnalysis
        function inventoryAnalysis(FromDate, ToDate) {
            $('#AreaDiv').show();

            $.ajax({
                url: "Analysis.aspx/InventoryAnalysis",
                data: '{fromDate:"' + FromDate + '",toDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    inventory_data = $.parseJSON(result.d)
                    if (result.d != "0") {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Title');
                        dataTable.addColumn('number', 'Amount(₹)');
                        dataTable.addRows(inventory_data.length);

                        for (var i = 0; i < inventory_data.length; i++) {
                            dataTable.setCell(i, 0, inventory_data[i].Title);
                            dataTable.setCell(i, 1, inventory_data[i].Amount);
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



                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(viewData,
                           {
                               title: 'Inventory Analysis',
                               fontName: '"Arial"',
                               width: 578, height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(viewData,
                           {
                               title: 'Inventory Analysis',
                               fontName: '"Arial"',
                               width: 578, height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 70, top: 18, width: "80%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(viewData,
                           {
                               title: 'Inventory Analysis',
                               fontName: '"Arial"',
                               width: 578, height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                        $('#chart2Div').show();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });



                    }


                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                       
                    }
                },
                error: function (xhr, status) {
                    
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        //DocStatistic
        function consultantStatistics(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();

            $.ajax({
                url: "Analysis.aspx/ConsultantStatistics",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    consultantStatistics_Data = $.parseJSON(result.d)

                    if (result.d != "0") {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Doctor');
                        dataTable.addColumn('number', 'No of Prescriptions');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'DoctorID');

                        dataTable.addRows(consultantStatistics_Data.length);

                        for (var i = 0; i < consultantStatistics_Data.length; i++) {
                            dataTable.setCell(i, 0, consultantStatistics_Data[i].Doctor);
                            dataTable.setCell(i, 1, consultantStatistics_Data[i].NoOfPrescriptions);
                            dataTable.setCell(i, 2, consultantStatistics_Data[i].Amount);
                            dataTable.setCell(i, 3, consultantStatistics_Data[i].DoctorID);
                        }

 

                        var viewData = new google.visualization.DataView(dataTable);
                        viewData.setColumns([0, 1, 2]);


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(viewData,
                           {
                               title: 'Doctor Statistics',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(viewData,
                           {
                               title: 'Doctor Statistics',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(viewData,
                           {
                               title: 'Doctor Statistics',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }


                        $('#char1Div').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(viewData, { allowHtml: true, showRowNumber: true, width: '100%' });



                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 3);

                                DocStatisticsDetail(FromDate, ToDate, topping);

                            }

                        }

                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                       
                    }
                },
                error: function (xhr, status) {
                    //  DisplayMsg("MM05", "lblErrorMsg");
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }

        function DocStatisticsDetail(FromDate, ToDate, topping) {
            selectedValue = topping;
            $.ajax({
                url: "Services/mis.asmx/DoctorStatisticsDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",Doctor:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'CentreName');
                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'City');
                        DataTable.addColumn('string', 'ItemName');
                        DataTable.addColumn('number', 'Rate');
                        DataTable.addColumn('number', 'Qty');
                        DataTable.addColumn('number', 'Amount');
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].CentreName);
                            DataTable.setCell(i, 1, Col_data[i].Doctor);
                            DataTable.setCell(i, 2, Col_data[i].UHID);
                            DataTable.setCell(i, 3, Col_data[i].PName);
                            DataTable.setCell(i, 4, Col_data[i].Age);
                            DataTable.setCell(i, 5, Col_data[i].Gender);
                            DataTable.setCell(i, 6, Col_data[i].City);
                            DataTable.setCell(i, 7, Col_data[i].ItemName);
                            DataTable.setCell(i, 8, Col_data[i].Rate);
                            DataTable.setCell(i, 9, Col_data[i].Qty);
                            DataTable.setCell(i, 10, Col_data[i].Amount);
                        }
                        var DocStatisticstable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        DocStatisticstable.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        //VENDORS
        function topSuppliers(FromDate, ToDate) {

            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Analysis.aspx/TopSuppliers",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    suppliers_Data = $.parseJSON(result.d)

                    if (result.d != "0") {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Supplier Name');
                        dataTable.addColumn('number', 'No of Purchase');
                        dataTable.addColumn('number', 'Purchased Amt(₹)');

                        dataTable.addColumn('number', '% of Total Purchase');
                        dataTable.addColumn('string', 'LedgerNumber');
                        dataTable.addRows(suppliers_Data.length);

                        for (var i = 0; i < suppliers_Data.length; i++) {
                            dataTable.setCell(i, 0, suppliers_Data[i].LedgerName);
                            dataTable.setCell(i, 1, suppliers_Data[i].No_Of_GRN);
                            dataTable.setCell(i, 2, suppliers_Data[i].NetPurchase);

                            dataTable.setCell(i, 3, suppliers_Data[i].Percent);
                            dataTable.setCell(i, 4, suppliers_Data[i].LedgerNumber);
                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1, 2, 3]);


                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 5 Vendors',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 5 Vendors',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 5 Vendors',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }

                        $('#char1Div').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();

                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });

                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 4);

                                TopVendorDetail(FromDate, ToDate, topping);

                            }

                        }
                    }
                    else { $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    $('#AreaDiv').hide();
                    modelAlert('Error occurred, Please contact administrator');
                   
                }
            });
        }

        function TopVendorDetail(FromDate, ToDate, topping) {
            selectedValue = topping;
            $.ajax({
                url: "Services/mis.asmx/TopVendorDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",Vendor:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'CentreName');
                        DataTable.addColumn('string', 'Vendor');
                        DataTable.addColumn('string', 'ItemName');
                        DataTable.addColumn('string', 'Department');
                        DataTable.addColumn('number', 'PurQty');
                        DataTable.addColumn('number', 'RatePerUnit');
                        DataTable.addColumn('number', 'DiscPer');
                        DataTable.addColumn('number', 'TaxPerUnit');
                        DataTable.addColumn('number', 'unitPrice');
                        DataTable.addColumn('number', 'TotalAmt');
                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].CentreName);
                            DataTable.setCell(i, 1, Col_data[i].Vendor);
                            DataTable.setCell(i, 2, Col_data[i].ItemName);
                            DataTable.setCell(i, 3, Col_data[i].Department);
                            DataTable.setCell(i, 4, Col_data[i].PurQty);
                            DataTable.setCell(i, 5, Col_data[i].RatePerUnit);
                            DataTable.setCell(i, 6, Col_data[i].DiscPer);
                            DataTable.setCell(i, 7, Col_data[i].TaxPerUnit);
                            DataTable.setCell(i, 8, Col_data[i].unitPrice);
                            DataTable.setCell(i, 9, Col_data[i].TotalAmt);


                        }
                        var TopVendortable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        TopVendortable.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function topSalesperson(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Analysis.aspx/TopSalesperson",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    salesPerson_Data = $.parseJSON(result.d)

                    if (result.d != "0") {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'SalesPerson');
                        dataTable.addColumn('number', 'Sales Amt(₹)');
                        dataTable.addColumn('number', 'No of Orders');
                        dataTable.addColumn('number', '% of Total Sales');
                        dataTable.addColumn('string', 'EmployeeID');

                        dataTable.addRows(salesPerson_Data.length);

                        for (var i = 0; i < salesPerson_Data.length; i++) {
                            dataTable.setCell(i, 0, salesPerson_Data[i].Employee);
                            dataTable.setCell(i, 1, salesPerson_Data[i].Amount);
                            dataTable.setCell(i, 2, salesPerson_Data[i].NoOfOrders);
                            dataTable.setCell(i, 3, salesPerson_Data[i].Percent);
                            dataTable.setCell(i, 4, salesPerson_Data[i].EmployeeID);
                        }
               
                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1, 2, 3]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'UserWise Sale',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'UserWise Sale',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 50, top: 45, width: "80%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'UserWise Sale',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 4);
                               
                                UserWiseDetail(FromDate, ToDate, topping);

                            }

                        }
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    $('#AreaDiv').hide();
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }
        function UserWiseDetail(FromDate, ToDate, topping) {
            selectedValue = topping;
            $.ajax({
                url: "Services/mis.asmx/UserWiseDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",Employee:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'Employee');
                        DataTable.addColumn('string', 'CentreName');
                        DataTable.addColumn('string', 'PName');
                        DataTable.addColumn('string', 'UHID');
                        DataTable.addColumn('string', 'Age');
                        DataTable.addColumn('string', 'Gender');
                        DataTable.addColumn('string', 'City');
                        DataTable.addColumn('string', 'TYPE');

                        DataTable.addColumn('string', 'Doctor');
                        DataTable.addColumn('number', 'MRP');
                        DataTable.addColumn('number', 'NetSaleQty');
                        DataTable.addColumn('number', 'NetSalePrice');
                        DataTable.addColumn('string', 'SellingDate');


                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].Employee);
                            DataTable.setCell(i, 1, Col_data[i].CentreName);
                            DataTable.setCell(i, 2, Col_data[i].PName);
                            DataTable.setCell(i, 3, Col_data[i].UHID);
                            DataTable.setCell(i, 4, Col_data[i].Age);
                            DataTable.setCell(i, 5, Col_data[i].Gender);
                            DataTable.setCell(i, 6, Col_data[i].City);
                            DataTable.setCell(i, 7, Col_data[i].TYPE);
                            DataTable.setCell(i, 8, Col_data[i].Doctor);
                            DataTable.setCell(i, 9, Col_data[i].MRP);
                            DataTable.setCell(i, 10, Col_data[i].NetSaleQty);
                            DataTable.setCell(i, 11, Col_data[i].NetSalePrice);
                            DataTable.setCell(i, 12, Col_data[i].SellingDate);


                        }
                        var UserWisetable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        UserWisetable.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function topSellingProducts(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Analysis.aspx/TopSellingProducts",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    toSelling_Data = $.parseJSON(result.d);
                    if (result.d != "0") {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'ItemName');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'ItemID');
                        dataTable.addRows(toSelling_Data.length);

                        for (var i = 0; i < toSelling_Data.length; i++) {
                            dataTable.setCell(i, 0, toSelling_Data[i].ItemName);
                            dataTable.setCell(i, 1, toSelling_Data[i].Amount);
                            dataTable.setCell(i, 2, toSelling_Data[i].ItemID);
                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 10 Sale',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 10 Sale',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 10 Sale',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });

                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);

                                topSaleProductsDetail(FromDate, ToDate, topping);
                            }
                        }
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    $('#AreaDiv').hide();
                    modelAlert('Error occurred, Please contact administrator');
                   
                }
            });
        }

        function topSaleProductsDetail(FromDate, ToDate, topping) {

            $('#AreaDiv').show();
            selectedValue = topping;
            $.ajax({
                url: "Services/mis.asmx/TopSaleDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ItemID:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var TopSaleCol_data = jQuery.parseJSON(mydata.d);
                    if (TopSaleCol_data.length > 0) {
                        var TopSaleDataTable = new google.visualization.DataTable();
                        TopSaleDataTable.addColumn('string', 'CentreName');
                        TopSaleDataTable.addColumn('string', 'ItemName');
                        TopSaleDataTable.addColumn('string', 'Department');
                        TopSaleDataTable.addColumn('number', 'MRP');
                        TopSaleDataTable.addColumn('number', 'NetSaleQty');
                        TopSaleDataTable.addColumn('number', 'NetSalePrice');
                        TopSaleDataTable.addColumn('string', 'SellingDate');
                        TopSaleDataTable.addColumn('string', 'UserName');


                        TopSaleDataTable.addRows(TopSaleCol_data.length);

                        for (var i = 0; i < TopSaleCol_data.length; i++) {
                            TopSaleDataTable.setCell(i, 0, TopSaleCol_data[i].CentreName);
                            TopSaleDataTable.setCell(i, 1, TopSaleCol_data[i].ItemName);
                            TopSaleDataTable.setCell(i, 2, TopSaleCol_data[i].Department);
                            TopSaleDataTable.setCell(i, 3, TopSaleCol_data[i].MRP);
                            TopSaleDataTable.setCell(i, 4, TopSaleCol_data[i].NetSaleQty);
                            TopSaleDataTable.setCell(i, 5, TopSaleCol_data[i].NetSalePrice);
                            TopSaleDataTable.setCell(i, 6, TopSaleCol_data[i].SellingDate);
                            TopSaleDataTable.setCell(i, 7, TopSaleCol_data[i].UserName);


                        }
                        var TopSaletable = new google.visualization.Table(document.getElementById('Detail1Div'));
                        TopSaletable.draw(TopSaleDataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function topPurchasedProducts(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();

            $.ajax({
                url: "Analysis.aspx/TopPurchasedProducts",
                data: '{fromDate:"' + $("#txtFromDate").val() + '",toDate:"' + $("#txtToDate").val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (result) {
                    topPurchased_Data = $.parseJSON(result.d)

                    if (result.d != "0") {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'ItemName');
                        dataTable.addColumn('number', 'Amount');
                        dataTable.addColumn('number', 'ItemID');
                        dataTable.addRows(topPurchased_Data.length);

                        for (var i = 0; i < topPurchased_Data.length; i++) {
                            dataTable.setCell(i, 0, topPurchased_Data[i].ItemName);
                            dataTable.setCell(i, 1, topPurchased_Data[i].Amount);
                            dataTable.setCell(i, 2, topPurchased_Data[i].ItemID);
                        }

                        var view = new google.visualization.DataView(dataTable);
                        view.setColumns([0, 1]);

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 10 Buy',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 10 Buy',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(view,
                           {
                               title: 'Top 10 Buy',
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#char1Div').show();
                        $('#chart2Div').show();
                        $('#Detail1Div').hide();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                        google.visualization.events.addListener(Chart, 'select', selectHandler);
                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 2);
                                topPurchasedProductsDetail(FromDate, ToDate, topping);

                            }

                        }


                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    $('#AreaDiv').hide();
                    modelAlert('Error occurred, Please contact administrator');
                }
            });
        }
        function topPurchasedProductsDetail(FromDate, ToDate, topping) {
            $('#Detail1Div').show(); selectedValue = topping;
            $.ajax({
                url: "Services/mis.asmx/TopPurchaseDetail",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",ItemID:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'CentreName');
                        DataTable.addColumn('string', 'ItemName');
                        DataTable.addColumn('string', 'Department');
                        DataTable.addColumn('number', 'PurQty');
                        DataTable.addColumn('number', 'RatePerUnit');
                        DataTable.addColumn('number', 'DiscPer');
                        DataTable.addColumn('number', 'TaxPerUnit');
                        DataTable.addColumn('number', 'unitPrice');
                        DataTable.addColumn('number', 'TotalAmt');


                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].CentreName);
                            DataTable.setCell(i, 1, Col_data[i].ItemName);
                            DataTable.setCell(i, 2, Col_data[i].Department);
                            DataTable.setCell(i, 3, Col_data[i].PurQty);
                            DataTable.setCell(i, 4, Col_data[i].RatePerUnit);
                            DataTable.setCell(i, 5, Col_data[i].DiscPer);
                            DataTable.setCell(i, 6, Col_data[i].TaxPerUnit);
                            DataTable.setCell(i, 7, Col_data[i].unitPrice);
                            DataTable.setCell(i, 8, Col_data[i].TotalAmt);

                        }
                        var table = new google.visualization.Table(document.getElementById('Detail1Div'));
                        table.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else
                        $('#Detail1Div').hide();
                }
            });
        }

        function EMGBedOccupied_Graph() {
            $('#divExport').hide(); $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/EMGBedOccupied",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'RoomType');
                        DataTable.addColumn('number', 'OccupiedBed');
                        DataTable.addColumn('number', 'IPDCaseTypeID');

                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].RoomType);
                            DataTable.setCell(i, 1, Col_data[i].OccupiedBed);
                            DataTable.setCell(i, 2, Col_data[i].IPDCaseTypeID);

                        }


                            var view = new google.visualization.DataView(DataTable);
                            view.setColumns([0, 1]);
                            var chartType = document.getElementById('ddlChartType').value;

                            if (chartType == 0) {
                                var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                                Chart.draw(view,
                               {
                                   title: "EMG Bed Occupied",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 351,
                                   annotations: { alwaysOutside: true },

                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            else if (chartType == 1) {
                                var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                                Chart.draw(view,
                               {
                                   title: "EMG Bed Occupied",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 351,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 80, top: 18, width: "95%" },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            if (chartType == 2) {
                                var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                                Chart.draw(view,
                               {
                                   title: "EMG Bed Occupied",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 351,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );

                            }
                            $('#Detail1Div').hide(); $('#char1Div').show();
                            google.visualization.events.addListener(Chart, 'select', selectHandler);

                            function selectHandler() {
                                var selectedItem = Chart.getSelection()[0];
                                if (selectedItem) {
                                    emgScreen = 'EMGBedOccupied';
                                    $.ajax({
                                        url: "Services/mis.asmx/EMGBedOccupiedDetails",
                                        data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                                        type: "POST",
                                        async: true,
                                        dataType: "json",
                                        contentType: "application/json; charset=utf-8",
                                        success: function (mydata) {

                                            var mis_data = jQuery.parseJSON(mydata.d);
                                            if (mis_data.length > 0) {

                                                var dataTable = new google.visualization.DataTable();

                                                dataTable.addColumn('string', 'EmergencyNo');
                                                dataTable.addColumn('string', 'PName');
                                                dataTable.addColumn('string', 'Age');
                                                dataTable.addColumn('string', 'Sex');
                                                dataTable.addColumn('string', 'Company_Name');
                                                dataTable.addColumn('string', 'AdmissionDate');
                                                dataTable.addColumn('string', 'Room');
                                                dataTable.addColumn('string', 'STATUS');
                                                dataTable.addColumn('string', 'Doctor');


                                                dataTable.addRows(mis_data.length);
                                                for (var i = 0; i < mis_data.length; i++) {

                                                    dataTable.setCell(i, 0, mis_data[i].EmergencyNo);
                                                    dataTable.setCell(i, 1, mis_data[i].PName);
                                                    dataTable.setCell(i, 2, mis_data[i].Age);
                                                    dataTable.setCell(i, 3, mis_data[i].Sex);
                                                    dataTable.setCell(i, 4, mis_data[i].Company_Name);
                                                    dataTable.setCell(i, 5, mis_data[i].AdmissionDate);
                                                    dataTable.setCell(i, 6, mis_data[i].Room);
                                                    dataTable.setCell(i, 7, mis_data[i].STATUS);
                                                    dataTable.setCell(i, 8, mis_data[i].Doctor);

                                                }

                                                var table = new google.visualization.Table(document.getElementById('Detail1Div'));

                                                table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                                $('#Detail1Div').show(); $('#divExport').show();
                                            }

                                        }
                                    });
                                }

                            }
                           

                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    
                    }
                }
            });
        }
        
        function bindEMGAdmissionType(FromDate, ToDate) {
            $('#divExport').hide(); $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/EMGAdmissionType",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Name');
                        dataTable.addColumn('number', 'COUNT');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].AdmissionType);
                            dataTable.setCell(i, 1, mis_data[i].AdmissionTypeCount);

                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Admission Type",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Admission Type",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('chart2Div'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Admission Type",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }

                        $('#chart2Div').show();

                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var topping = dataTable.getValue(selectedItem.row, 0);
                                selectedValue = topping; emgScreen = 'EMGAdmission';
                                $.ajax({
                                    url: "Services/mis.asmx/EMGAdmissionTypeDetail",
                                    data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '",AdmissionType :"' + topping + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {

                                        var mis_data = jQuery.parseJSON(mydata.d);
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            dataTable.addColumn('string', 'Admission_type');
                                            dataTable.addColumn('string', 'EmergencyNo');
                                            dataTable.addColumn('string', 'PName');
                                            dataTable.addColumn('string', 'Age');
                                            dataTable.addColumn('string', 'Sex');
                                            dataTable.addColumn('string', 'Company_Name');
                                            dataTable.addColumn('string', 'AdmissionDate');
                                            dataTable.addColumn('string', 'DischargeDate');
                                            dataTable.addColumn('string', 'STATUS');
                                            dataTable.addColumn('string', 'Doctor');


                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].Admission_type);
                                                dataTable.setCell(i, 1, mis_data[i].EmergencyNo);
                                                dataTable.setCell(i, 2, mis_data[i].PName);
                                                dataTable.setCell(i, 3, mis_data[i].Age);
                                                dataTable.setCell(i, 4, mis_data[i].Sex);
                                                dataTable.setCell(i, 5, mis_data[i].Company_Name);
                                                dataTable.setCell(i, 6, mis_data[i].AdmissionDate);
                                                dataTable.setCell(i, 7, mis_data[i].DischargeDate);
                                                dataTable.setCell(i, 8, mis_data[i].STATUS);
                                                dataTable.setCell(i, 9, mis_data[i].Doctor);

                                            }

                                            var table = new google.visualization.Table(document.getElementById('Detail1Div'));

                                            table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#Detail1Div').show(); $('#divExport').show();

                                        }

                                    }
                                });
                            }

                        }
                    }
                    else {
                        $('#Detail1Div').hide();
                       
                    }

                }
            });
        }

        function EMGAdmittedTypeWise(FromDate, ToDate) {
            $('#divExport').hide();
              $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/EMGAdmissionTypeWsie",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'STATUS');
                        DataTable.addColumn('number', 'COUNT');
                        //PathDeptTypeDataTable.addColumn('number', 'ObservationType_Id');

                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].STATUS);
                            DataTable.setCell(i, 1, Col_data[i].COUNT);
                            ////PathDeptTypeDataTable.setCell(i, 2, PathDeptTypeCol_data[i].ObservationType_Id);
                        }


                            var view = new google.visualization.DataView(DataTable);
                            view.setColumns([0, 1]);

                            var chartType = document.getElementById('ddlChartType').value;

                            if (chartType == 0) {
                                var Chart = new google.visualization.PieChart(document.getElementById('tableDiv1'));
                                Chart.draw(view,
                               {
                                   title: "EMG Type Wise Status",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 353,
                                   annotations: { alwaysOutside: true },

                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            else if (chartType == 1) {
                                var Chart = new google.visualization.LineChart(document.getElementById('tableDiv1'));
                                Chart.draw(view,
                               {
                                   title: "EMG Type Wise Status",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 353,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 80, top: 18, width: "95%" },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            if (chartType == 2) {
                                var Chart = new google.visualization.BarChart(document.getElementById('tableDiv1'));
                                Chart.draw(view,
                               {
                                   title: "EMG Type Wise Status",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 353,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );


                            }
                            $('#tableDiv1').show();
                            google.visualization.events.addListener(Chart, 'select', selectHandler);

                            function selectHandler() {
                                var selectedItem = Chart.getSelection()[0];
                                if (selectedItem) {
                                    emgScreen = 'EMGAdmitted';
                                    var toppingType = DataTable.getValue(selectedItem.row, 0); 
                                    EMGAdmitDischargeTypeDetails(toppingType);
                                }
                            }

                            $('#tableDiv1').show(); 
                       
                    }
                    else {
                        $('#tableDiv1').hide();
                 
                   }
                }
            });
        }

        function EMGAdmitDischargeTypeDetails( toppingType) {
            if (toppingType == 'Discharge' )
                toppingType = 1;
            else if (toppingType == 'Released For IPD')
                toppingType = 2;
            else if (toppingType == 'Shift To IPD')
                toppingType = 3;
            else if (toppingType == 'Admitted')
                toppingType = 'Admitted';         
            else if (toppingType == 'Bed Not Allotted') {             
                toppingType = 'Bed Not Allotted';
            }
            selectedValue = toppingType; 
         
        $.ajax({
            url: "Services/mis.asmx/EMGAdmitDischargeTypeDetail",
            data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",Type :"' + toppingType + '"}',
            type: "POST",
            async: true,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (mydata) {

                var mis_data = jQuery.parseJSON(mydata.d);
                if (mis_data.length > 0) {

                    var dataTable = new google.visualization.DataTable();
                   
                    dataTable.addColumn('string', 'EmergencyNo');
                    dataTable.addColumn('string', 'PName');
                    dataTable.addColumn('string', 'Age');
                    dataTable.addColumn('string', 'Sex');
                    dataTable.addColumn('string', 'Company_Name');
                    dataTable.addColumn('string', 'AdmissionDate');
                    dataTable.addColumn('string', 'STATUS');
                    dataTable.addColumn('string', 'Doctor');


                    dataTable.addRows(mis_data.length);
                    for (var i = 0; i < mis_data.length; i++) {
                      
                        dataTable.setCell(i, 0, mis_data[i].EmergencyNo);
                        dataTable.setCell(i, 1, mis_data[i].PName);
                        dataTable.setCell(i, 2, mis_data[i].Age);
                        dataTable.setCell(i, 3, mis_data[i].Sex);
                        dataTable.setCell(i, 4, mis_data[i].Company_Name);
                        dataTable.setCell(i, 5, mis_data[i].AdmissionDate);
                        dataTable.setCell(i, 6, mis_data[i].STATUS);
                        dataTable.setCell(i, 7, mis_data[i].Doctor);

                    }

                    var table = new google.visualization.Table(document.getElementById('Detail1Div'));

                    table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                    $('#divExport').show(); $('#Detail1Div').show();

                }

            }
        });
        }
        function EMGBillNotGenTypeWise(FromDate, ToDate) {
            $('#AreaDiv').show(); $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/EMGBillNotGenTypeWsie",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'STATUS');
                        DataTable.addColumn('number', 'COUNT');

                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].STATUS);
                            DataTable.setCell(i, 1, Col_data[i].COUNT);
                        }
              
                            var view = new google.visualization.DataView(DataTable);
                            view.setColumns([0, 1]);

                            var chartType = document.getElementById('ddlChartType').value;

                            if (chartType == 0) {
                                var Chart = new google.visualization.PieChart(document.getElementById('tableDiv2'));
                                Chart.draw(view,
                               {
                                   title: "EMG Type Wise Status",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 353,
                                   annotations: { alwaysOutside: true },

                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            else if (chartType == 1) {
                                var Chart = new google.visualization.LineChart(document.getElementById('tableDiv2'));
                                Chart.draw(view,
                               {
                                   title: "EMG Type Wise Status",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 353,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 80, top: 18, width: "95%" },
                                   trendlines: { 0: {} },
                               }
                            );
                            }
                            if (chartType == 2) {
                                var Chart = new google.visualization.BarChart(document.getElementById('tableDiv2'));
                                Chart.draw(view,
                               {
                                   title: "EMG Type Wise Status",
                                   fontName: '"Arial"',
                                   width: 578,
                                   height: 353,
                                   annotations: { alwaysOutside: true },
                                   legend: { position: 'bottom' },
                                   chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                                   trendlines: { 0: {} },
                               }
                            );


                            }
                            $('#tableDiv2').show();
                            google.visualization.events.addListener(Chart, 'select', selectHandler);

                            function selectHandler() {
                                var selectedItem = Chart.getSelection()[0];
                                if (selectedItem) {
                                    emgScreen = 'emgBillNotGen';
                                    EMGBillNotGenTypeWiseDetails();

                                }
                            }

                            $('#tableDiv2').show();

                    }
                    else {
                        $('#tableDiv2').hide();
               
                    }
                }
            });
        }
        function EMGBillNotGenTypeWiseDetails() {
            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/EMGBillNotGenTypeWsieDetails",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'EmergencyNo');
                        dataTable.addColumn('string', 'PName');
                        dataTable.addColumn('string', 'Age');
                        dataTable.addColumn('string', 'Sex');
                        dataTable.addColumn('string', 'Company_Name');
                        dataTable.addColumn('string', 'AdmissionDate');
                        dataTable.addColumn('string', 'STATUS');
                        dataTable.addColumn('string', 'Doctor');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {

                            dataTable.setCell(i, 0, mis_data[i].EmergencyNo);
                            dataTable.setCell(i, 1, mis_data[i].PName);
                            dataTable.setCell(i, 2, mis_data[i].Age);
                            dataTable.setCell(i, 3, mis_data[i].Sex);
                            dataTable.setCell(i, 4, mis_data[i].Company_Name);
                            dataTable.setCell(i, 5, mis_data[i].AdmissionDate);
                            dataTable.setCell(i, 6, mis_data[i].STATUS);
                            dataTable.setCell(i, 7, mis_data[i].Doctor);

                        }

                        var table = new google.visualization.Table(document.getElementById('Detail1Div'));

                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });
                        $('#Detail1Div').show(); $('#divExport').show();

                    }

                }
            });
        }


        function EMGCollection(FromDate, ToDate) {
            $('#AreaDiv').show();
            $('#DivRevenueArea').hide();
            $('#divExport').hide();
            $.ajax({
                url: "Services/mis.asmx/EMGCollection_graph",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Months');
                        dataTable.addColumn('number', 'Collection');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Months);
                            dataTable.setCell(i, 1, mis_data[i].Amount);


                        }

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Collection",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Collection",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('char1Div'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Collection",
                               fontName: '"Arial"',
                               width: 578,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        $('#char1Div').show(); $('#chart2Div').show();
                        var table = new google.visualization.Table(document.getElementById('chart2Div'));
                        table.draw(dataTable, { allowHtml: true, showRowNumber: true, width: '100%' });

                        $('#Detail1Div').hide(); 
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                EMGCollectionDetails($('#txtFromDate').val(), $('#txtToDate').val());
                            }

                        }
                        $('#AreaDiv').show();
                    }
                    else {
                        $('#AreaDiv').hide();
                        modelAlert('No Record Found');
                    }
                }
            });
        }

        function EMGCollectionDetails(FromDate, ToDate) {

            $('#AreaDiv').show();
            $.ajax({
                url: "Services/mis.asmx/EMGCollection_graphDetails",
                data: '{FromDate:"' + FromDate + '",ToDate:"' + ToDate + '",CentreID :"' + $("#ddlCentre").val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var DataTable = new google.visualization.DataTable();
                        DataTable.addColumn('string', 'ReceiptNo');
                        DataTable.addColumn('string', 'EmergencyNo');
                        DataTable.addColumn('string', 'PatientName');                    
                        DataTable.addColumn('string', 'Sex');
                        DataTable.addColumn('string', 'Panel');
                        DataTable.addColumn('string', 'RecieptDate');
                        DataTable.addColumn('number', 'AmountPaid');
                        DataTable.addColumn('string', 'AdmissionDate');
                        DataTable.addColumn('string', 'DischargeDate');
                        DataTable.addColumn('string', 'STATUS');
                        DataTable.addColumn('string', 'PaymentMode');

                        DataTable.addRows(Col_data.length);

                        for (var i = 0; i < Col_data.length; i++) {
                            DataTable.setCell(i, 0, Col_data[i].ReceiptNo);
                            DataTable.setCell(i, 1, Col_data[i].EmergencyNo);
                            DataTable.setCell(i, 2, Col_data[i].PatientName);
                            DataTable.setCell(i, 3, Col_data[i].Sex);
                            DataTable.setCell(i, 4, Col_data[i].Panel);
                            DataTable.setCell(i, 5, Col_data[i].RecieptDate);
                            DataTable.setCell(i, 6, Col_data[i].AmountPaid);
                            DataTable.setCell(i, 7, Col_data[i].AdmissionDate);
                            DataTable.setCell(i, 8, Col_data[i].DischargeDate);
                            DataTable.setCell(i, 9, Col_data[i].STATUS);
                            DataTable.setCell(i, 10, Col_data[i].PaymentMode);
                           

                        }
                        var table = new google.visualization.Table(document.getElementById('Detail1Div'));
                        table.draw(DataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#Detail1Div').show(); $('#divExport').show();
                    }
                    else {
                        modelAlert('No Record Found');
                        $('#AreaDiv').hide();
                    }
                }
            });
        }

        function EMGRevenue() {
            $('#DivRevenueArea').hide(); $('#RevenuedivExport').hide();
            $.ajax({
                url: "Services/mis.asmx/EMGRevenue",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + $('input:[name=rdoCategory]:checked').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var mis_data = jQuery.parseJSON(mydata.d);
                  
                    if (mis_data.length > 0) {

                        var dataTable = new google.visualization.DataTable();
                        dataTable.addColumn('string', 'Doctor');
                        dataTable.addColumn('number', 'Total');
                        dataTable.addColumn('number', 'DoctorVisit');


                        dataTable.addRows(mis_data.length);
                        for (var i = 0; i < mis_data.length; i++) {
                            dataTable.setCell(i, 0, mis_data[i].Consultant);
                            dataTable.setCell(i, 1, mis_data[i].Total);
                            dataTable.setCell(i, 2, mis_data[i].DoctorVisit);

                        }
                        $('#RevenuechartDetails').hide();
                        $('#RevenuechartTable').hide();

                        var chartType = document.getElementById('ddlChartType').value;

                        if (chartType == 0) {
                            var Chart = new google.visualization.PieChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Revenue ",
                               fontName: '"Arial"',
                               width: 1163,
                               height: 351,
                               annotations: { alwaysOutside: true },

                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        else if (chartType == 1) {
                            var Chart = new google.visualization.LineChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Revenue ",
                               fontName: '"Arial"',
                               width: 1163,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 80, top: 18, width: "95%" },
                               trendlines: { 0: {} },
                           }
                        );
                        }
                        if (chartType == 2) {
                            var Chart = new google.visualization.BarChart(document.getElementById('Revenuechart'));
                            Chart.draw(dataTable,
                           {
                               title: "EMG Revenue ",
                               fontName: '"Arial"',
                               width: 1163,
                               height: 351,
                               annotations: { alwaysOutside: true },
                               legend: { position: 'bottom' },
                               chartArea: { left: 100, top: 50, right: 0, bottom: 50, width: '100%' },
                               trendlines: { 0: {} },
                           }
                        );


                        }
                        $('#Revenuechart').show();
                        $('#RevenuechartTable').hide();
                        $('#RevenuechartDetails').hide();
                        google.visualization.events.addListener(Chart, 'select', selectHandler);

                        function selectHandler() {
                            var selectedItem = Chart.getSelection()[0];
                            if (selectedItem) {
                                var RevenueType = $('input:[name=rdoCategory]:checked').val();
                                $.ajax({
                                    url: "Services/mis.asmx/EMGRevenue",
                                    data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + $('input:[name=rdoCategory]:checked').val() + '"}',
                                    type: "POST",
                                    async: true,
                                    dataType: "json",
                                    contentType: "application/json; charset=utf-8",
                                    success: function (mydata) {
                                        var mis_data = jQuery.parseJSON(mydata.d);                                   
                                        if (mis_data.length > 0) {

                                            var dataTable = new google.visualization.DataTable();
                                            if (RevenueType == 'DepartMentWise') {
                                                dataTable.addColumn('string', 'Department');
                                               
                                            }
                                            else if (RevenueType == 'PanelWise') {
                                                dataTable.addColumn('string', 'Panel');
                                               
                                            }
                                            else if (RevenueType == 'CategoryWise') {
                                                dataTable.addColumn('string', 'Category');
                                                
                                            }
                                            else if (RevenueType == 'DoctorWise') {
                                                dataTable.addColumn('string', 'Doctor');
                                                
                                            }
                                            dataTable.addColumn('number', 'id');
                                            dataTable.addColumn('number', 'Total');
                                            dataTable.addColumn('number', 'DoctorVisit');
                                            dataTable.addColumn('number', 'CrossVisit');
                                            dataTable.addColumn('number', 'Investigation');
                                            dataTable.addColumn('number', 'MinorPro');
                                            dataTable.addColumn('number', 'Surgery');
                                            dataTable.addColumn('number', 'Package');
                                            dataTable.addColumn('number', 'BedCharges');
                                            dataTable.addColumn('number', 'Medicine');
                                            dataTable.addColumn('number', 'Other');

                                            dataTable.addRows(mis_data.length);
                                            for (var i = 0; i < mis_data.length; i++) {
                                                dataTable.setCell(i, 0, mis_data[i].Consultant);
                                                dataTable.setCell(i, 1, mis_data[i].id);
                                                dataTable.setCell(i, 2, mis_data[i].Total);
                                                dataTable.setCell(i, 3, mis_data[i].DoctorVisit);
                                                dataTable.setCell(i, 4, mis_data[i].CrossVisit);
                                                dataTable.setCell(i, 5, mis_data[i].Investigation);
                                                dataTable.setCell(i, 6, mis_data[i].MinorPro);
                                                dataTable.setCell(i, 7, mis_data[i].Surgery);
                                                dataTable.setCell(i, 8, mis_data[i].Package);
                                                dataTable.setCell(i, 9, mis_data[i].BedCharges);
                                                dataTable.setCell(i, 10, mis_data[i].Medicine);
                                                dataTable.setCell(i, 11, mis_data[i].Other);

                                            }
                                            var view = new google.visualization.DataView(dataTable);
                                            view.setColumns([0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);

                                            var table = new google.visualization.Table(document.getElementById('RevenuechartTable'));

                                            table.draw(view, { allowHtml: true, showRowNumber: true, width: '100%' });
                                            $('#RevenuechartDetails').hide();
                                            $('#RevenuechartTable').show();
                                            $('#divExport').show();
                                            google.visualization.events.addListener(table, 'select', selectHandler);

                                            function selectHandler() {
                                                var selectedItem = table.getSelection()[0];
                                                if (selectedItem) {
                                                    var topping = dataTable.getValue(selectedItem.row, 1);
                                                    selectedValue = topping;
                                                    var RevenueType = $('input:[name=rdoCategory]:checked').val();
                                                    EMGRevenueDetails(RevenueType, topping)
                                                }
                                            }

                                        }

                                    }
                                });
                            }

                        }

                        $('#DivRevenueArea').show();
                    }
                    else {                  
                        modelAlert('No Record Found');
                        $('#DivRevenueArea').hide();
                    }
                }
            });
        }


        function EMGRevenueDetails(RevenueType, topping) {
            $('#AreaDiv').hide();         
            $('#DivRevenueArea').show(); $('#RevenuedivExport').show();
            $.ajax({
                url: "Services/mis.asmx/EMGRevenueDetails",
                data: '{FromDate:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",CentreID :"' + $("#ddlCentre").val() + '",RevenueType:"' + RevenueType + '",vid:"' + topping + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {

                    var Col_data = jQuery.parseJSON(mydata.d);
                    if (Col_data.length > 0) {
                        var dataTable = new google.visualization.DataTable();
                        if (RevenueType == 'DepartMentWise') {
                            dataTable.addColumn('string', 'Department');

                        }
                        else if (RevenueType == 'PanelWise') {
                            dataTable.addColumn('string', 'Panel');
                        }
                        else if (RevenueType == 'CategoryWise') {
                            dataTable.addColumn('string', 'Category');
                        }
                        else if (RevenueType == 'DoctorWise') {
                            dataTable.addColumn('string', 'Doctor');
                        }
                        dataTable.addColumn('string', 'UHID');
                        dataTable.addColumn('string', 'PName');
                        dataTable.addColumn('string', 'Age');
                        dataTable.addColumn('string', 'gender');
                        dataTable.addColumn('string', 'city');
                        dataTable.addColumn('string', 'TypeOfTnx');
                        dataTable.addColumn('number', 'Total');
                        dataTable.addRows(Col_data.length);
                        for (var i = 0; i < Col_data.length; i++) {
                            dataTable.setCell(i, 0, Col_data[i].Consultant);
                            dataTable.setCell(i, 1, Col_data[i].UHID);
                            dataTable.setCell(i, 2, Col_data[i].PName);
                            dataTable.setCell(i, 3, Col_data[i].Age);
                            dataTable.setCell(i, 4, Col_data[i].gender);
                            dataTable.setCell(i, 5, Col_data[i].city);
                            dataTable.setCell(i, 6, Col_data[i].TypeOfTnx);
                            dataTable.setCell(i, 7, Col_data[i].Total);
                        }
                        var Revenue_OPDCol_dataDetails = new google.visualization.Table(document.getElementById('RevenuechartDetails'));
                        Revenue_OPDCol_dataDetails.draw(dataTable, { allowHtml: true, showRowNumber: true, width: "100%" });
                        $('#RevenuechartDetails').show();
                    }
                    else
                        $('#RevenuechartDetails').hide();
                }
            });
        }

    </script>

</asp:Content>
