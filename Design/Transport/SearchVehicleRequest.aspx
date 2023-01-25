<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SearchVehicleRequest.aspx.cs" Inherits="Design_Transport_SearchVehicleRequest" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //Bind controls 
            bindDepartment();
            $("#txtReason").keypress(function (e) {
                var keynum
                var keychar
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                //List of special characters you want to restrict

                if (keychar == "~" || keychar == "!" || keychar == "^" || keychar == "*" || keychar == "+" || keychar == "=" || keychar == "{" || keychar == "}" || keychar == "|" || keychar == ";" || keychar == "'" || keychar == "/" || keychar == "`") {
                    return false;
                }
                else {
                    return true;
                }
            });           
            $("#btnSearch").click(function () {
                $('#lblErrorMsg').text("");
                $("#divSearchResult").hide();
                $("#btnSearch").val("Searching...");
                $("#btnSearch").attr("disabled", true);
                $.ajax({
                    url: "SearchVehicleRequest.aspx/SearchDeptRequest",
                    data: '{FromDept:"' + $("#ddlDepFrom").val() + '",Status:"' + $("#ddlStatus").val() + '",FromDate:"' + $("#txtFromDate").val() + '",ToDate:"' + $("#txtToDate").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        VehicleRequest = $.parseJSON(result.d);
                        if (VehicleRequest != null && VehicleRequest != "0") {
                            var HtmlOutput = $("#VehicleRqst").parseTemplate(VehicleRequest);
                            $("#divSearchResult").html(HtmlOutput);
                            $("#divSearchResult").show();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                        }
                        else {
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                            DisplayMsg("MM04", "lblErrorMsg");
                        }
                    },
                    error: function (xhr, status) {                       
                        DisplayMsg("MM05", "lblErrorMsg");
                    }

                });
            });
        });

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

        function bindDepartment() {
            $("#ddlDepFrom").empty();
            $.ajax({
                url: "../common/CommonService.asmx/bindRoleDepartment",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d != null && result.d != "") {
                        var Dept = $.parseJSON(result.d);
                        $("#ddlDepFrom").append($("<option></option>").val("All").html("All"));
                        for (var i = 0; i < Dept.length; i++) {
                            $("#ddlDepFrom").append($("<option></option>").val(Dept[i].DeptLedgerNo).html(Dept[i].DeptName));
                        }
                    }
                    else {
                        $("#ddlDepFrom").append($("<option></option>").val("All").html("--No Data--"));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function openPop(rowID) {
            var ID = $(rowID).closest("tr").find("#tdID").text();
            $.ajax({
                url: "SearchVehicleRequest.aspx/AddRequest",
                data: '{ID:"' + ID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    DeptRequest = $.parseJSON(result.d);
                    if (DeptRequest != null && DeptRequest != "0") {
                        var HtmlOutput = $("#DeptRequest").parseTemplate(DeptRequest);
                        $("#divDeptRequest").html(HtmlOutput);
                        $("#divDeptRequest").show();

                        if ($("#lblAuthority").text() == "1") {
                            if (DeptRequest[0].IsApproved == "1" || DeptRequest[0].IsCancel == "1") {
                                //$("#btnApprove,#btnCancel").attr("disabled", true);
                                $("#btnApprove,#btnCancel").hide();
                            }
                            else {
                                //$("#btnApprove,#btnCancel").attr("disabled", false);
                                $("#btnApprove,#btnCancel").show();
                            }
                        }
                        else {
                            $("#spnErrorMsg").text("You are not authorized to Approve/Reject Request");
                            $("#btnApprove,#btnCancel").hide();
                        }

                        $find('mpeApprove').show();
                    }

                },
                error: function (xhr, status) {
                    DisplayMsg("MM05", "lblErrorMsg");
                }

            });
        }

        function closeDeptRequest() {
            $find('mpeApprove').hide();
            $("#divDeptRequest").empty();
        }

        function ApproveRqst() {
            $("#spnErrorMsg").text("");
            var ID = $("#divDeptRequest table tr:last").find("#tdID1").text();

            $.ajax({
                url: "SearchVehicleRequest.aspx/ApproveRqst",
                data: '{ID:"' + ID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d == "1") {
                        closeDeptRequest();
                        DisplayMsg("MM01", "lblErrorMsg");
                    }
                    else {
                        closeDeptRequest();
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                },
                error: function (xhr, status) {
                    closeDeptRequest();
                    DisplayMsg("MM05", "lblErrorMsg");
                }

            });

            $("#divSearchResult").hide();
        }

        function CancelRqst() {
            $("#spnErrorMsg").text("");
            var ID = $("#divDeptRequest table tr:last").find("#tdID1").text();
            var Reason = $.trim($("#divDeptRequest table tr:last").find("#txtReason").val());

            if (Reason == "") {
                $("#divDeptRequest table tr:last").find("#txtReason").focus();
                $("#spnErrorMsg").text("Enter Reason of Cancel");
                return;
            }

            $.ajax({
                url: "SearchVehicleRequest.aspx/CancelRqst",
                data: '{ID:"' + ID + '",Reason:"' + Reason + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d == "1") {
                        closeDeptRequest();
                        DisplayMsg("MM01", "lblErrorMsg");
                    }
                    else {
                        closeDeptRequest();
                        DisplayMsg("MM05", "lblErrorMsg");
                    }

                },
                error: function (xhr, status) {
                    closeDeptRequest();
                    DisplayMsg("MM05", "lblErrorMsg");
                }

            });

            $("#divSearchResult").hide();
        }
    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Request for Vehicle</span></b><br />
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
                                From Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlDepFrom" title="Select From Department"></select>
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
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlStatus" title="Select Status">
                                <option selected="selected" value="0">All</option>
                                <option value="1">Pending Request</option>
                                <option value="2">Out</option>
                                <option value="3">Complete Request</option>
                            </select>
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
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="static" onchange="ChkDate();"/>
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
                            <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="static" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="clToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" id="btnSearch" class="ItDoseButton" value="Search" />
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
                        <td style="width: 150px;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: LightBlue;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Pending</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #F48FB1;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">OUT</td>
                        <td style="width: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: #4DB6AC;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Complete Request</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divSearchResult">
        </div>
    </div>
    <asp:Panel ID="pnlApprove" runat="server" style="display:none;">
        <div style="margin: 0px; background-color: #eaf3fd; border: solid 1px Green; display: inline-block; padding: 1px 1px 1px 1px; margin: 0px 10px 3px 10px; width:100%;">
            <div class="Purchaseheader" >
                <table width="100%">
                    <tr>
                        <td style="text-align: left;">
                            <b>Department Request</b>
                        </td>
                        <td style="text-align: right;">
                            <em><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeDeptRequest();" />to close</span></em>
                        </td>
                    </tr>                    
                </table>                
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;width:99.9%;">
                <b><span id="spnErrorMsg" class="ItDoseLblError"></span></b>
            </div>
            <div class="POuter_Box_Inventory" style="overflow:auto;width:99.9%;text-align: center;height:200px;" id="divDeptRequest">
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;width:99.9%;">
                <input type="button" id="btnApprove" value="Approve Request" class="ItDoseButton" onclick="ApproveRqst();"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" id="btnCancel" value="Cancel Request" class="ItDoseButton" onclick="CancelRqst();"/>
            </div>
        </div>
    </asp:Panel>
    <asp:Button ID="btnHide" runat="server" style="display:none;" />
    <cc1:ModalPopupExtender ID="mpeApprove" BehaviorID="mpeApprove" runat="server" TargetControlID="btnHide" DropShadow="true"
        BackgroundCssClass="filterPupupBackground" PopupControlID="pnlApprove">
    </cc1:ModalPopupExtender>
    <script type="text/html" id="VehicleRqst">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width:100%">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">RequestID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">From Department</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Type Of Vehicle</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Requested By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Requested Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Travel Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Travel Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Purpose</th>
             <th class="GridViewHeaderStyle" scope="col" style="width: 60px; display:none">Select</th>
            </tr>
            <#
                var dataLength=VehicleRequest.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    objRow=VehicleRequest[j];
            #>
                    <tr
                        <#if(objRow.STATUS=="0" && objRow.IsAck=="0"){#>
                            style="background-color:LightBlue;"
                        <#}
                        else 
                        {
                            if(objRow.Status=="1" && objRow.IsAck=="0"){#>                                
                                style="background-color:#F48FB1;"
                            <#
                            }  
                           else if(objRow.Status=="1" && objRow.IsAck=="1"){#>                                
                                style="background-color:#4DB6AC;"
                            <#
                            }                                                      
                        }
                        #>                                                                                           
                        >                       
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:center;"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdID"  style="width:100px;text-align:center;display:none;" ><#=objRow.ID#></td>
                        <td class="GridViewLabItemStyle" id="td1"  style="width:100px;text-align:center;" ><#=objRow.VehicleRequestID#></td>
					    <td class="GridViewLabItemStyle" id="tdFromDept"  style="width:100px;text-align:left;" ><#=objRow.DeptFrom#></td>
                        <td class="GridViewLabItemStyle" id="tdType" style="width:50px;text-align:center; "><#=objRow.VehicleType#></td>    
					    <td class="GridViewLabItemStyle" id="tdRqstBy" style="width:100px;text-align:center; "><#=objRow.RaisedBy#></td>
					    <td class="GridViewLabItemStyle" id="tdRqstDate" style="width:100px;text-align:center;"><#=objRow.RaisedDate#></td>
					    <td class="GridViewLabItemStyle" id="tdTravelDate" style="width:80px;text-align:center"><#=objRow.TravelDate#></td>
					    <td class="GridViewLabItemStyle" id="tdTravelTime" style="width:80px;text-align:center"><#=objRow.TravelTime#></td>
					    <td class="GridViewLabItemStyle" id="tdPurpose" style="width:150px;text-align:center;"><#=objRow.Purpose#></td>
                        <td class="GridViewLabItemStyle" style="width:60px;text-align:center;display:none">
                            <img id="imgView" src="../../Images/view.GIF" style="cursor:pointer;" title="Click To View" onclick="openPop(this);"/>
                        </td>                                               
                    </tr>                           
            <#    
                }                
            #>
        </table>
    </script>

    <script type="text/html" id="DeptRequest">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" style="border-collapse: collapse;" border="1">
            <tr>                
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;display:none;">ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">From Department</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Type Of Vehicle</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Requested By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Requested Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Travel Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Travel Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Approved By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Approved Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Canceled By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 80px;">Canceled Date</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Reason</th>                
            </tr>
            <#
                var dataLength=DeptRequest.length;
		        window.status="Total Records Found :"+ dataLength;
		        var objRow;   
		        for(var j=0;j<dataLength;j++)
		        {
                    objRow=DeptRequest[j];
            #>
                    <tr
                        <#if(objRow.IsApproved=="0" && objRow.IsCancel=="0"){#>
                            style="background-color:LightBlue;"
                        <#}
                        else 
                        {
                            if(objRow.IsCancel=="1"){#>                                
                                style="background-color:LightPink;"
                            <#
                            }  
                            if(objRow.IsApproved=="1"){#>                                
                                style="background-color:Green;"
                            <#
                            }                                                      
                        }
                        #>  
                        >                       
                        <td class="GridViewLabItemStyle" style="width:20px;text-align:center;"> <#=j+1#>&nbsp;&nbsp;</td> 
                        <td class="GridViewLabItemStyle" id="tdID1"  style="width:100px;text-align:center;display:none;" ><#=objRow.ID#></td>
					    <td class="GridViewLabItemStyle" id="tdFromDept1"  style="width:100px;text-align:left;" ><#=objRow.DeptFrom#></td>
                        <td class="GridViewLabItemStyle" id="tdType1" style="width:50px;text-align:center; "><#=objRow.VehicleType#></td>    
					    <td class="GridViewLabItemStyle" id="tdRqstBy1" style="width:100px;text-align:center; "><#=objRow.RaisedBy#></td>
					    <td class="GridViewLabItemStyle" id="tdRqstDate1" style="width:100px;text-align:center;"><#=objRow.RaisedDate#></td>
					    <td class="GridViewLabItemStyle" id="tdTravelDate1" style="width:80px;text-align:center"><#=objRow.TravelDate#></td>
					    <td class="GridViewLabItemStyle" id="tdTravelTime1" style="width:80px;text-align:center"><#=objRow.TravelTime#></td>
                        <td class="GridViewLabItemStyle" id="tdAppBy1" style="width:80px;text-align:center"><#=objRow.ApprovedBy#></td>
					    <td class="GridViewLabItemStyle" id="tdAppDate1" style="width:80px;text-align:center"><#=objRow.ApprovedDate#></td>
					    <td class="GridViewLabItemStyle" id="tdCancelBy1" style="width:80px;text-align:center"><#=objRow.CancelBy#></td>
                	    <td class="GridViewLabItemStyle" id="tdCancelDate1" style="width:80px;text-align:center"><#=objRow.CancelDate#></td>
					    <td class="GridViewLabItemStyle" id="tdReason1" style="width:150px;text-align:center">                              
                            <input type="text" id="txtReason" style="width:150px;display:inline;" value='<#=objRow.CancelReason#>'/>                                 
                        </td>
                    </tr>                           
            <#    
                }                
            #>
        </table>
    </script>
    <asp:Label ID="lblAuthority" runat="server" style="display:none;" ClientIDMode="Static"/>
</asp:Content>
