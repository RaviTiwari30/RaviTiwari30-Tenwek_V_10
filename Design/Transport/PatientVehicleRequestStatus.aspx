<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientVehicleRequestStatus.aspx.cs" Inherits="Design_Transport_PatientVehicleRequestStatus" %>

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
        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125"))
                return false;
            else
                return true;
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnSearch").click(function () {

                $("#lblErrorMsg").text("");

                $("#btnSearch").val("Searching...");
                $("#btnSearch").attr("disabled", true);

                $.ajax({
                    url: "Services/Transport.asmx/patientRequestStatus",
                    data: '{MRNo:"' + $.trim($("#txtMRNo").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",FirstName:"' + $.trim($("#txtFirst").val()) + '",LastName:"' + $.trim($("#txtLast").val()) + '",FromDate:"' + $.trim($("#txtFromDate").val()) + '",ToDate:"' + $.trim($("#txtToDate").val()) + '",Status:"' + $("#rblStatus input[type='radio']:checked").val() + '"}',
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
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Patient Vehicle Request Status</span></b><br />
            <span id="lblErrorMsg" class="ItDoseLblError"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtMRNo" maxlength="20" title="Enter Patient No" />
                        </div>
                       
                        <div class="col-md-3">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtFirst" maxlength="20" title="Enter Patient First Name" onkeypress="return check(this,event)" />
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Last Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtLast" maxlength="20" title="Enter Patient Last Name" onkeypress="return check(this,event)" />
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
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="static" onchange="ChkDate();" ToolTip="Click to Select To Date" />
                            <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                         <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                IPD No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <input type="text" id="txtIPDNo" maxlength="20" title="Enter IPD No" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            </div>
                        <div class="col-md-18">
                            <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal" align="center" ClientIDMode="Static">
                                <asp:ListItem Value="0" Text="All Request" Selected="True" />
                                <asp:ListItem Value="1" Text="Pending Request" />
                                <asp:ListItem Value="2" Text="Patient Out" />
                                <asp:ListItem Value="3" Text="Complete Request" />
                                <asp:ListItem Value="4" Text="Cancel Request"  style="display:none" />
                            </asp:RadioButtonList>
                            </div>
                        <div class="col-md-3">
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
        <div class="POuter_Box_Inventory">
            <div style="padding: 10px;">
                <table style="margin: 0 Auto; width: 100%;">
                    <tr>
                        <td style="width: 100px;"></td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #99bbff;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Pending<br />
                            Request</td>
                        <%-- <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #ffffff;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                       <td style="text-align: left">Cancel<br />
                            Request</td>--%>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #F48FB1;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Patient<br />
                            Out</td>
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
           <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Request No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">UHIDNo</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Request Date</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Travel Date Time</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle Type</th>   
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Purpose</th>
     <%--           <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Cancel By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Cancel Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Reason</th>    --%>           	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Vehicle No</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Driver Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Departure Date Time</th>
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
                if(objRow.IsCancel=="1"){
                    strStyle="background-color: #ffffff;"; 
                }
                else
                {
                    if(objRow.IsAck=="0" && objRow.Status=="0" ){
                        strStyle="background-color: #99bbff;";          
                    }
                    else{
                        if(objRow.Status=="1" && objRow.IsAck=="0"){
                            strStyle="background-color: #F48FB1;";                       
                        }
                        else if (objRow.Status=="1" && objRow.IsAck=="1"){                        
                            strStyle="background-color: #4DB6AC;";
                        }
                    }
                }
		    #>
				    <tr style="<#=strStyle#>">                                          
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" ><#=(j+1)#></td>
					    <td class="GridViewLabItemStyle" style="width:50px;text-align:center; " ><#=objRow.TokenNo#></td>
                        <td class="GridViewLabItemStyle" style="width:150px;text-align:center; "><#=objRow.PatientID#></td>    
					    <td class="GridViewLabItemStyle" style="width:150px;text-align:left; "><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center; "><#=objRow.RequestDate#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.TravelDate#><br/><#=objRow.TravelTime#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:center"><#=objRow.VehicleType#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center"><#=objRow.Purpose#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;display:none"><#=objRow.CancelBy#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;display:none"><#=objRow.CancelDate#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;display:none"><#=objRow.CancelReason#></td>
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.VehicleNo#></td>
					    <td class="GridViewLabItemStyle" style="width:100px;text-align:left;"><#=objRow.DriverName#></td>
					    <td class="GridViewLabItemStyle" style="width:120px;text-align:center;"><#=objRow.DepartureDate#><br /><#=objRow.DepartureTime#></td>                                                                  
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.ArrivalDate#><br /><#=objRow.ArrivalTime#></td>  
                        <td class="GridViewLabItemStyle" style="width:100px;text-align:center;"><#=objRow.PlaceVisited#></td>  
                    </tr>            
		    <#}        
		    #> 
                
	    </table>    
    </script>
</asp:Content>

