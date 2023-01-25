<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="InfectionControlAnalysis.aspx.cs" Inherits="Design_OPD_Reports_InfectionControlAnalysis" %>

<%-- Add content controls here --%>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
    <div id="Pbody_box_inventory" style="width: 1304px;">
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center; background-color: black; color: white;">
            <span style="font-size: 20px;"><strong>Infection Control Analysis Report</strong><br />
            </span>

            <div class="alert fade" style="position: absolute; left: 40%; border-radius: 15px; z-index: 11111">
                <p align="center" id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
            </div>

        </div>

        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;">
            <div>
                <div class="row">

                    <div class="col-md-3" style="text-align: right; font-weight: bold; color: #9d4848;">
                        <strong>From Date :</strong>
                    </div>
                    <div class="col-md-5" style="text-align: left">
                        <asp:TextBox ID="dtFrom" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="CalendarExtender1"
                            TargetControlID="dtFrom"
                            Format="dd-MMM-yyyy" />
                    </div>
                    <div class="col-md-3" style="text-align: right; font-weight: bold; color: #9d4848;"><strong style="text-align: right">To Date :</strong></div>
                    <div class="col-md-5" style="text-align: left">
                        <asp:TextBox ID="dtToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="CalendarExtender2"
                            TargetControlID="dtToDate"
                            Format="dd-MMM-yyyy" />
                    </div>
                    <div class="col-md-3" style="text-align: right; font-weight: bold; color: #9d4848;"><strong style="text-align: right">UHID :</strong></div>
                    <div class="col-md-5" style="text-align: left">
                        <asp:TextBox ID="txtUHID" runat="server" ClientIDMode="Static"></asp:TextBox>

                    </div>


                </div>

                <div class="row">
                    <div class="col-md-3" style="text-align: right; font-weight: bold; color: #9d4848;"><strong style="text-align: right">Result Type :</strong></div>
                    <div class="col-md-5" style="text-align: left">
                        <asp:DropDownList runat="server" ID="ddlResultType" ClientIDMode="Static">
                            <asp:ListItem Text="All" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Positive" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Negative" Value="2"></asp:ListItem>

                        </asp:DropDownList>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;">
            <div class="Purchaseheader">Select Investigation </div>
            <div>
                <asp:CheckBoxList ID="chkinvestigation" runat="server" RepeatDirection="Horizontal" RepeatColumns="8" Style="text-align: left; font-weight: bold; color: #9d4848;"></asp:CheckBoxList>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center;">
            <input type="button" id="btnsearch" class="searchbutton" value="Search" onclick="InfectionControlSearch();" />&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="button" id="Button1" class="searchbutton" value="Report" onclick="report();" />&nbsp;&nbsp;&nbsp;&nbsp;
        </div>

        <div id="divsummary" class="POuter_Box_Inventory" style="width: 1300px;">
            <table style="width: 100%; border-collapse: collapse;" id="tblSummary" class="GridViewStyle">
                <tr>
                    <th class="GridViewHeaderStyle">S.No.</th>
                    <th class="GridViewHeaderStyle">UHID</th>
                    <th class="GridViewHeaderStyle">Patient Name</th>
                    <th class="GridViewHeaderStyle">Age</th>
                    <th class="GridViewHeaderStyle">Sex</th>
                    <th class="GridViewHeaderStyle">Investigation</th>
                    <th class="GridViewHeaderStyle">Result</th>
                    <th class="GridViewHeaderStyle">Prescribed DateTime</th>
                    <th class="GridViewHeaderStyle">Result Entered By</th>
                    <th class="GridViewHeaderStyle">Result Enter Date</th>
                </tr>
            </table>
        </div>
    </div>
    <script type="text/javascript">
        function getsearchdata() {
            var dataPLO = new Array();
            dataPLO[0] = $('#<%=dtFrom.ClientID%>').val();
            dataPLO[1] = $('#<%=dtToDate.ClientID%>').val();
            dataPLO[2] = checkboxlist();
            dataPLO[3] = $('#<%=txtUHID.ClientID%>').val();
            dataPLO[4] = $('#<%=ddlResultType.ClientID%>').val();
            return dataPLO;
        }
        function InfectionControlSearch() {


            $('#divsummary tr').slice(1).remove();
            var searchdata = getsearchdata();
            $.blockUI();
            $.ajax({
                url: "InfectionControlAnalysis.aspx/InfectionControlSearch",
                data: JSON.stringify({ searchdata: searchdata }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var rowColor = "";
                    var TestCode = "";
                    TestData = $.parseJSON(result.d);
                    if (TestData.length == 0) {
                        $.unblockUI();
                        showerrormsg("No Data Found..!");
                        return;
                    }
                    else {
                        for (var i = 0; i < TestData.length; i++) {
                            if (TestData[i].Result == "Positive") {
                                rowColor = "pink";
                            }
                            else if (TestData[i].Result == "ALL TEST") {
                                rowColor = "#53de98";
                            }

                            var mydata = "<tr id='" + TestData[i].Test_ID + "'  style='background-color:" + rowColor + ";'>";
                            mydata += "<td class='GridViewLabItemStyle' >" + parseInt(i + 1) + "";
                            mydata += "</td>";

                            mydata += '<td class="GridViewLabItemStyle" style="font-weight: bold;">' + TestData[i].UHID + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"><h style="font-size:12px;">' + TestData[i].PatientName + '</h></td>';

                            mydata += '<td class="GridViewLabItemStyle" style="font-weight: bold;">' + TestData[i].Age + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"><h style="font-size:12px;">' + TestData[i].Sex + '</h></td>';

                            mydata += '<td class="GridViewLabItemStyle" style="font-weight: bold;">' + TestData[i].NAME + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"><h style="font-size:12px;">' + TestData[i].VALUE + '</h></td>';

                            mydata += '<td class="GridViewLabItemStyle"><h style="font-size:12px;">' + TestData[i].PrescribedDate + '</h></td>';

                            mydata += '<td class="GridViewLabItemStyle" style="font-weight: bold;">' + TestData[i].ResultEnteredBy + '</td>';
                            mydata += '<td class="GridViewLabItemStyle"><h style="font-size:12px;">' + TestData[i].ResultEnteredDate + '</h></td>';


                            mydata += "</tr>";
                            TestCode = TestData[i].TestCode;
                            $('#tblSummary').append(mydata);
                        }

                    }

                    $.unblockUI();
                },
                error: function (xhr, status) {
                    $.unblockUI();

                    window.status = status + "\r\n" + xhr.responseText;
                }

            });

        }
        function checkboxlist() {
            var message = "";
            var chkinvestigation = $("[id*=chkinvestigation] input:checked");
            message = "";
            chkinvestigation.each(function () {
                var value = $(this).val();
                //  var text = $(this).closest("td").find("label").html();
                message += value;
                message += ",";
            });
            return message;
        }
        function newchkeckboxlist() {
            var message = "";
            var chkinvestigation = $("[id*=chkcountall] input:checked");
            message = "";
            chkinvestigation.each(function () {
                var value = $(this).val();
                //  var text = $(this).closest("td").find("label").html();
                message += value;
                message += ",";
            });
            return message;
        }
        function showerrormsg(msg) {
            $('#msgField').html('');
            $('#msgField').append(msg);
            $(".alert").css('background-color', 'red');
            $(".alert").removeClass("in").show();
            $(".alert").delay(1500).addClass("in").fadeOut(1000);
        }


        function report() {
            var searchdata = getsearchdata();
            serverCall('InfectionControlAnalysis.aspx/GetReport', { searchdata: searchdata }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    window.open('../../common/ExportToExcel.aspx');
                }
                else { modelAlert(responseData.response) };
            });
        }

    </script>
</asp:Content>
