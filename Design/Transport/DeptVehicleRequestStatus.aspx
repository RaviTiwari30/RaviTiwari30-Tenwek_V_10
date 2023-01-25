<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DeptVehicleRequestStatus.aspx.cs" Inherits="Design_Transport_DeptVehicleRequestStatus" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function ChkDate() {
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
                        $('#lblErrorMsg').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');

                    }
                    else {
                        $('#lblErrorMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            //bind controls
            bindDepartment();

            $("#btnSearch").click(function () {

                $("#lblErrorMsg").text("");

                $("#btnSearch").val("Searching...");
                $("#btnSearch").attr("disabled", true);

                $.ajax({
                    url: "Services/Transport.asmx/deptRequestStatus",
                    data: '{RequestID:"' + $.trim($("#txtRequestID").val()) + '",DepartmentID:"' + $.trim($("#ddlDepartment").val()) + '",FromDate:"' + $.trim($("#txtFromDate").val()) + '",ToDate:"' + $.trim($("#txtToDate").val()) + '",Status:"' + $("#rblStatus input[type='radio']:checked").val() + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        if (result.d != null && result.d != "0") {
                            Request = $.parseJSON(result.d);
                            var HtmlOutput = $("#SearchResult").parseTemplate(Request);
                            $("#divSearchedResult").html(HtmlOutput);
                            $("#divSearchedResult").show();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                        }
                        else {
                            $("#divSearchedResult").empty();
                            $("#divSearchedResult").hide();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                            DisplayMsg('MM04', 'lblErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        $("#divSearchedResult").empty();
                        $("#divSearchedResult").hide();
                        $("#btnSearch").val("Search");
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                });

            });
        });

        function bindDepartment() {
            $("#ddlDepartment").empty();
            $.ajax({
                url: "../common/CommonService.asmx/bindRoleDepartment",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d != "") {
                        var Dept = $.parseJSON(result.d);
                        $("#ddlDepartment").append($("<option></option>").val("0").html("Select"))
                        for (var i = 0; i < Dept.length; i++) {
                            $("#ddlDepartment").append($("<option></option>").val(Dept[i].DeptLedgerNo).html(Dept[i].DeptName));
                        }
                        $("#ddlDepartment").val($("#lblLoginType").text());
                    }
                    else {
                        $("#ddlDepartment").append($("<option></option>").val("0").html("Select"));
                    }
                },
                error: function (xhr, status) {
                    $("#ddlDepartment").append($("<option></option>").val("0").html("Select"));
                }
            });
            $("#ddlDepartment").attr("disabled", true);
        }
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Department Vehicle Request Status</span></b><br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Request ID
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <input type="text" id="txtRequestID" maxlength="20" title="Enter Vehicle RequestID" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                </label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Department
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <select id="ddlDepartment" title="Select Department"></select>
                                <asp:Label ID="lblLoginType" runat="server" ClientIDMode="Static" Style="display: none;" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    From Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="static" onchange="ChkDate();" ToolTip="Click to Select From Date" />
                                <cc1:CalendarExtender ID="clFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                </label>
                                <b class="pull-right"></b>
                            </div>
                            <div class="col-md-5">
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    To Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="static" onchange="ChkDate();" ToolTip="Click to Select To Date" />
                                <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                            </div>
                            <div class="col-md-12">
                                <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal" align="center" ClientIDMode="Static">
                                    <asp:ListItem Value="0" Text="All Request" Selected="True" />
                                    <asp:ListItem Value="1" Text="Pending Request" />
                                    <asp:ListItem Value="2" Text="Out" />
                                    <asp:ListItem Value="3" Text="Complete Request" />
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-6">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-11">
                            </div>
                            <div class="col-md-2">
                                <input type="button" id="btnSearch" value="Search" class="ItDoseButton" />
                            </div>
                            <div class="col-md-11">
                            </div>
                        </div>

                    </div>
                    <div class="col-md-1"></div>
                </div>

            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="padding: 10px;">
                <table style="margin: 0 Auto; width: 100%;">
                    <tr>
                        <td style="width: 146px;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #99bbff;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Pending<br />
                            Request</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #F48FB1;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Out&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #4DB6AC;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Complete<br />
                            Request</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; max-height: 400px; overflow: auto;">
            <div id="divSearchedResult" style="width: 100%;">
            </div>
        </div>
    </div>
        <script type="text/html" id="SearchResult">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">RequestID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Department</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Request Date</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Travel Date Time</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Purpose</th>   
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Departure Date Time</th>           	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle No</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Driver Name</th>                
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Arrival Date Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Place Visited</th>	                				                                        	
		    </tr>
		    <#       
		    var dataLength=Request.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {       
                var strStyle="";
		        objRow = Request[j];

                if(objRow.Status=="0"  && objRow.IsAck=="0"){
                    strStyle="background-color: #99bbff;";          
                }
                else{
                    if(objRow.Status=="1" && objRow.IsAck=="0" ){
                        strStyle="background-color: #F48FB1;";                       
                    }
                    else{                        
                        strStyle="background-color: #4DB6AC;";
                    }
                }
		    #>
				    <tr style="<#=strStyle#>">                                          
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:center;" ><#=objRow.VehicleRequestID#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.DeptFrom#></td>    
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.VehicleType#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.RequestDate#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.TravelDate#><br/><#=objRow.TravelTime#></td>
					    <td class="GridViewLabItemStyle" style="width:150px;text-align:center"><#=objRow.Purpose#></td>
   					    <td class="GridViewLabItemStyle" style="width:120px;text-align:center;"><#=objRow.DepartureDate#><br /><#=objRow.DepartureTime#></td>                                                                  
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.VehicleNo#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:left;"><#=objRow.DriverName#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.ArrivalDate#><br /><#=objRow.ArrivalTime#></td>  
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.PlaceVisited#></td>
                    </tr>            
                
		    <#}        
		    #> 
            <tr>
                <td colspan="11">&nbsp;</td>
            </tr>        
	    </table>    
    </script>
</asp:Content>

