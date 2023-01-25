<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Mortuary_CorpseReceiving.aspx.cs" Inherits="Design_Mortuary_CorpseReceiving" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#tbl_div,#cmd_div").hide();

            $("#btnSearch").click(function () {

                $("#lblErrorMsg").text("");
                $("#btnSearch").val("Searching...");
                $("#btnSearch").attr("disabled", true);
                $.ajax({
                    url: "Services/Mortuary.asmx/SerachDeathPerson",
                    data: '{MRNo:"' + $.trim($("#txtPatient_ID").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",FirstName:"' + $.trim($("#txtFirstName").val()) + '",LastName:"' + $.trim($("#txtLastName").val()) + '",FromDate:"' + $.trim($("#txtFromDate").val()) + '",ToDate:"' + $.trim($("#txtToDate").val()) + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {

                        if (result.d != null && result.d != "0") {
                            CorpseResult = $.parseJSON(result.d);
                            var HtmlOutput = $("#SearchResult").parseTemplate(CorpseResult);
                            $("#divSearchedResult").html(HtmlOutput);
                            $("#tbl_div,#divSearchedResult,#cmd_div").show();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                        }
                        else {
                            $("#divSearchedResult").empty();
                            $("#tbl_div,#divSearchedResult,#cmd_div").hide();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                            DisplayMsg('MM04', 'lblErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        $("#divSearchedResult").empty();
                        $("#tbl_div,#divSearchedResult,#cmd_div").hide();
                        $("#btnSearch").val("Search");
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                });
            });

            $("#btnSave").click(function () {

                $("#lblErrorMsg").text("");


                var dataCorpse = new Array();
                var flag = true;

                if ($(".chkSelect:checked").not(":disabled").length == 0) {
                    DisplayMsg('MM239', 'lblErrorMsg');
                    return;
                }

                $("#divSearchedResult table tr").not(":first").each(function (i, tr) {
                    if ($(this).find('input[type="checkbox"]').not(":disabled") && $(this).find('input[type="checkbox"]').is(":checked")) {
                        if ($.trim($(this).find("#txtBroughtBy").val()) == "") {
                            $('#lblErrorMsg').text('Please Enter Brought By');
                            $(this).find('input[type="text"]').focus();
                            flag = false;
                            return flag;
                        }
                        else {
                            var dataObj = new Object();
                            dataObj.Patient_ID = $(this).find("#tdPatient_ID").text();
                            dataObj.Transaction_ID = $(this).find("#tdIPDNo").text();
                            dataObj.BroughtBy = $(this).find("#txtBroughtBy").val();
                            dataObj.ReceivedRemarks = $(this).find("#txtInRemarks").val();
                            dataCorpse.push(dataObj);
                        }
                    }
                });

                if (flag == false) {
                    $("#btnSave").val("Save");
                    $("#btnSave").attr("disabled", false);
                    return;
                }


                $("#btnSave").val("Submitting...");
                $("#btnSave").attr("disabled", true);

                $.ajax({
                    url: "Services/Mortuary.asmx/saveCorpseReceive",
                    data: JSON.stringify({ corpseDetail: dataCorpse }),
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != null && result.d != "0") {
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            $("#divSearchedResult").empty();
                            $("#tbl_div,#divSearchedResult,#cmd_div").hide();
                            DisplayMsg('MM01', 'lblErrorMsg');
                        }
                        else {
                            $("#btnSave").val("Save");
                            $("#btnSave").attr("disabled", false);
                            DisplayMsg('MM05', 'lblErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        $("#btnSave").val("Save");
                        $("#btnSave").attr("disabled", false);
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                });
            });
        });

        function SelectAll(chk) {

            if ($(chk).is(":checked")) {
                $(".chkSelect").attr("checked", "checked");
            }
            else
                $(".chkSelect").removeAttr("checked");

        }

    </script>
    <script type="text/javascript">
        $(document).on("keydown", function (e) {
            if ((e.which == 13) && (e.target.id != "btnSearch")) {
                e.preventDefault();
            }
        });
    </script>    
    <script type="text/javascript">
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
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
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b><span id="lblHeader" style="font-weight: bold;">Corpse Receiving</span></b><br />
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
                             <asp:TextBox ID="txtPatient_ID" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter UHID" Width="" />
                        </div>
                     
                            <div class="col-md-3">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFirstName" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter First Name" AutoCompleteType="None" Width="" onkeypress="return check(this,event)"/>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Last Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtLastName" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter Last Name" AutoCompleteType="None" Width="" onkeypress="return check(this,event)"/>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter IPD No." AutoCompleteType="None" Width="" />
                        </div>
                           <div class="col-md-3">
                            <label class="pull-left">
                                From Death Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" title="Click to Select From Date" Width="" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="calFromdate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Death Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" title="Select To Date" Width="" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="calTodate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSearch" value="Search" class="ItDoseButton" />
        </div>
        <div id="tbl_div" class="POuter_Box_Inventory" style="text-align: center; max-height: 430px; overflow: auto;">
            <div id="divSearchedResult" style="width: 100%;">
            </div>
        </div>
        <div id="cmd_div" class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSave" class="ItDoseButton" value="Save"/>
        </div>
    </div> 

    <script type="text/html" id="SearchResult">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Receive<br />
                    <input type="checkbox" id="chkAll" onchange="SelectAll(this);"/>
                 </th>                
			    <th class="GridViewHeaderStyle" scope="col" style="width:50px;">IPD No</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:130px;">UHID</th>               	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Name</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>	          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Ward</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Death Date<br />Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Brought By</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Received Remarks</th>			                                    	
		    </tr>
		    <#       
		    var dataLength=CorpseResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {                
		        objRow = CorpseResult[j];         
                                
		    #>
				    <tr>  
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;" >
                            <input type="checkbox" class="chkSelect"/>
                        </td>                                          
                        <td class="GridViewLabItemStyle" id="tdIPDNo"  style="width:50px;text-align:center;display:none;" ><#=objRow.Transaction_ID#></td>
                        <td class="GridViewLabItemStyle" id="td1"  style="width:50px;text-align:center;" ><#=objRow.IPDNo#></td>
					    <td class="GridViewLabItemStyle" id="tdPatient_ID"  style="width:130px;text-align:center;" ><#=objRow.Patient_ID#></td>
        			    <td class="GridViewLabItemStyle" id="tdName" style="width:120px;text-align:center; "><#=objRow.PName#></td>
					    <td class="GridViewLabItemStyle" id="tdAgeGender" style="width:100px;text-align:center;"><#=objRow.Age#>/<#=objRow.Gender#></td>
					    <td class="GridViewLabItemStyle" id="td2" style="width:100px;text-align:center;"><#=objRow.Ward#></td>
					    <td class="GridViewLabItemStyle" id="tdDeathDate" style="width:100px;text-align:center"><#=objRow.DOD#>&nbsp; <#=objRow.DOT#></td>
                        <td class="GridViewLabItemStyle" id="tdBroughtBy" style="width:160px;text-align:center;">
                            <input type="text" id="txtBroughtBy" title="Enter Brought By" style="width:140px;" onkeypress="return check(this,event)"/>
                            <span class="ItDoseLblError">*</span>
                        </td>
					    <td class="GridViewLabItemStyle" id="tdDeathType" style="width:120px;text-align:center;">
                            <textarea id="txtInRemarks" style="width:200px;height:50px;resize:none;" title="Enter In Remarks" onkeypress="return check(this,event)"></textarea>
					    </td>
                    </tr>             
                
		    <#}        
		    #> 
	    </table>    
    </script>
</asp:Content>