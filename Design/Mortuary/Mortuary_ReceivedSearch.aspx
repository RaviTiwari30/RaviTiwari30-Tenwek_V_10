<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Mortuary_ReceivedSearch.aspx.cs" Inherits="Design_Mortuary_Mortuary_ReceivedSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="uc1" TagName="Time" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnSearch").click(function () {
                $("#lblErrorMsg").text("");
                $("#btnSearch").val("Searching...");
                $("#btnSearch").attr("disabled", true);
                $("#btnExcel").attr("disabled", true);
                $.ajax({
                    url: "Services/Mortuary.asmx/serachReceivedCorpse",
                    data: '{MRNo:"' + $.trim($("#txtPatient_ID").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",FirstName:"' + $.trim($("#txtFirstName").val()) + '",LastName:"' + $.trim($("#txtLastName").val()) + '",FromDate:"' + $.trim($("#txtFromDate").val()) + '",ToDate:"' + $.trim($("#txtToDate").val()) + '",CorpseType:"' + $('#<%=DDLCorpseType.ClientID %> option:selected').val() + '",ButtonType:"' + $.trim($("#btnSearch").val()) + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != null && result.d != "0") {
                            CorpseResult = $.parseJSON(result.d);
                            var HtmlOutput = $("#SearchResult").parseTemplate(CorpseResult);
                            $("#divSearchedResult").html(HtmlOutput);
                            $("#divSearchedResult").show();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                            $("#btnExcel").attr("disabled", false);
                        }
                        else {
                            $("#divSearchedResult").empty();
                            $("#divSearchedResult").hide();
                            $("#btnSearch").val("Search");
                            $("#btnSearch").attr("disabled", false);
                            $("#btnExcel").attr("disabled", false);
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
            $("#btnExcel").click(function () {
                $("#lblErrorMsg").text("");
                $("#btnExcel").val("Expoting....");
                $("#btnExcel").attr("disabled", true);
                $("#btnSearch").attr("disabled", true);
                $.ajax({
                    url: "Services/Mortuary.asmx/serachReceivedCorpse",
                    data: '{MRNo:"' + $.trim($("#txtPatient_ID").val()) + '",IPDNo:"' + $.trim($("#txtIPDNo").val()) + '",FirstName:"' + $.trim($("#txtFirstName").val()) + '",LastName:"' + $.trim($("#txtLastName").val()) + '",FromDate:"' + $.trim($("#txtFromDate").val()) + '",ToDate:"' + $.trim($("#txtToDate").val()) + '",CorpseType:"' + $('#<%=DDLCorpseType.ClientID %> option:selected').val() + '",ButtonType:"' + $.trim($("#btnExcel").val()) + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != null && result.d != "0") {
                            CorpseResult = $.parseJSON(result.d);
                            var HtmlOutput = $("#SearchResult").parseTemplate(CorpseResult);
                            $("#divSearchedResult").html(HtmlOutput);
                            $("#divSearchedResult").show();
                            window.open("../common/ExportToExcel.aspx");
                            $("#btnExcel").val("Export To Excel");
                            $("#btnExcel").attr("disabled", false);
                            $("#btnSearch").attr("disabled", false);
                        }
                        else {
                            $("#divSearchedResult").empty();
                            $("#divSearchedResult").hide();
                            $("#btnExcel").val("Export To Excel");
                            $("#btnExcel").attr("disabled", false);
                            $("#btnSearch").attr("disabled", false);
                            DisplayMsg('MM04', 'lblErrorMsg');
                        }
                    },
                    error: function (xhr, status) {
                        $("#divSearchedResult").empty();
                        $("#divSearchedResult").hide();
                        $("#btnExcel").val("Export To Excel");
                        DisplayMsg('MM05', 'lblErrorMsg');
                    }
                });
            });


        });

        function corpseDeposite(rowID) {
            var row = $(rowID).closest("tr");
            var MRNo = row.find("#tdMRNo").text();
            var IPDNo = row.find("#tdIPDNo").text();
            window.open("CorpseDeposite.aspx?MRNo=" + MRNo + "&IPDNo=" + IPDNo, "_self");
        }

        function corpseReleased(rowID) {
            var row = $(rowID).closest("tr");
            $("#spnRMRNO").text(row.find("#tdMRNo").text());
            $("#spnRIPDNO1").text(row.find("#tdIPDNo1").text());
            $("#spnRIPDNO").text(row.find("#tdIPDNo").text());
            $("#spnName").text(row.find("#tdName").text());
            $("#spnRDeath").text(row.find("#tdDeathDate").text());
            // $find("mpRelease").show();
            $('#ModalPopupExtender2').show();
        }

        function saveReleasedDetailDirect() {
            $("#lblErrorMsg,#spnReleaseError").text("");

            if ($.trim($("#txtRCollected").val()) == "") {
                $("#txtRCollected").focus();
                $("#spnReleaseError").text("Please Enter Collected Person Name");
                modelAlert('Please Enter Collected Person Name');
                return;
            }

            if ($.trim($("#txtRContactNo").val()) == "") {
                $("#txtRContactNo").focus();
                $("#spnReleaseError").text("Please Enter Collected Person Contact No");
                modelAlert('Please Enter Collected Person Contact No');
                return;
            }

            if (($.trim($('#txtRContactNo').val()) != "") && ($.trim($('#txtRContactNo').val()).length < "10")) {
                $('#txtRContactNo').focus();
                $("#spnReleaseError").text('Please Enter Valid Contact No.');
                modelAlert('Please Enter Valid Contact No.');
                return;
            }

            if ($.trim($("#txtRAddress").val()) == "") {
                $("#txtRAddress").focus();
                $("#spnReleaseError").text("Please Enter Collected Person Address");
                modelAlert('Please Enter Collected Person Address');
                return;
            }

            $("#btnRelease").attr("disabled", true);
            $.ajax({
                url: "Services/Mortuary.asmx/saveReleasedDetailDirect",
                data: '{IPDNo:"' + $("#spnRIPDNO").text() + '",CollectedBy:"' + $.trim($("#txtRCollected").val()) + '",ContactNo:"' + $.trim($("#txtRContactNo").val()) + '",Address:"' + $.trim($("#txtRAddress").val()) + '",Remarks:"' + $.trim($("#txtRemarks").val()) + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    if (result.d != null && result.d != "0") {
                        closeRelease();
                        $("#btnRelease").attr("disabled", false);
                        $("#divSearchedResult").empty();
                        $("#divSearchedResult").hide();
                        DisplayMsg("MM01", "lblErrorMsg");
                    }
                    else {
                        $("#btnRelease").attr("disabled", false);
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                },
                error: function (xhr, status) {
                    $("#btnRelease").val("Search");
                    DisplayMsg("MM05", "lblErrorMsg");
                }
            });

        }
    </script>
    <script type="text/javascript">
        $(document).on("keydown", function (e) {
            if ((e.which == 13) && (e.target.id != "btnSearch")) {
                e.preventDefault();
            }
        });
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }

        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("mpRelease")) {
                  //  $find("mpRelease").hide();
                    $('#ModalPopupExtender2').hide();
                    cancelRelease();
                }
            }
        }

        function closeRelease() {
          //  $find("mpRelease").hide();
            $('#ModalPopupExtender2').hide();
            $("#txtRCollected").val('');
            $("#txtRContactNo").val('');
            $("#txtRAddress").val('');
            $("#txtRemarks").val('');
        }

        function cancelRelease() {
            $("#txtRCollected").val('');
            $("#txtRContactNo").val('');
            $("#txtRAddress").val('');
            $("#txtRemarks").val('');
        }
    </script>    
    <script type="text/javascript">

        $(document).ready(function () {
            $("#txtIPDNo,#txtRContactNo").keypress(function (e) {
                var charCode = (e.which) ? e.which : e.keyCode;
                if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                    return false;
                }
            });
        });
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
            <b><span id="lblHeader" style="font-weight: bold;">Search Received Corpse</span></b><br />
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
                             <asp:TextBox ID="txtPatient_ID" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter Corpse ID" Width="" />
                        </div>
                           <div class="col-md-3">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFirstName" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter Name" AutoCompleteType="None" Width="" onkeypress="return check(this,event)"/>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Last Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtLastName" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter Name" AutoCompleteType="None" Width="" onkeypress="return check(this,event)"/>
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
                     <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Corpse Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:DropDownList ID="DDLCorpseType" runat="server">
                                <asp:ListItem Value="0">ALL</asp:ListItem>
                                <asp:ListItem Value="1">Received</asp:ListItem>
                                <asp:ListItem Value="2">Deposited</asp:ListItem>
                                <asp:ListItem Value="3">Released</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSearch" value="Search" class="ItDoseButton"  />
            <input type="button" id="btnExcel" value="Export To Excel" class="ItDoseButton" />
        </div>
        <div class="POuter_Box_Inventory">
                <table style="margin: 0 Auto; width: 70%;">
                    <tr>
                        <td style="width: 135px;height:40px">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td class="circle" style="width: 40px; height:20px; background-color: #FFF59D;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td  style="text-align: left">Received Corpse</td>
                        <td class="circle" style="width: 40px; height:20px; background-color: #e59bbb;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Deposited Corpse</td>
                        <td class="circle" style="width: 40px; height:20px;  background-color: #10e067;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Released Corpse</td>                        
                    </tr>
                </table>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; max-height: 430px; overflow: auto;">
            <div id="divSearchedResult" style="width: 100%;">
            </div>
        </div>
    </div>
    <script type="text/html" id="SearchResult">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;width:100%" id="search_tbl">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;"></th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">IPD No</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">UHID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Name</th>			                  	          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Death Date<br />Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Death</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Brought By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Received Remarks</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Received By</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Received Date</th>		
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Collected By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Released By</th>                                                	
		    </tr>
		    <#       
		    var dataLength=CorpseResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {       
                var strStyle="background-color:  #FFF59D;";
                var strDeposite="";
                var strRelease="";
		        objRow = CorpseResult[j];                
                if(objRow.IsDeposited=="1"){
                    strStyle="background-color: #e59bbb;";                     
                }
                if(objRow.IsReleased=="1"){
                    strStyle="background-color: #10e067;";                                   
                }
		    #>
				    <tr style="<#=strStyle#>">            
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;">
                          <#
                            if((objRow.IsDeposited=="0" || objRow.IsDeposited== null) && (objRow.IsReleased=="0" || objRow.IsReleased==null))
                            {
                          #>
                            <input type="button" id="btnDeposite" value="Deposite" class="ItDoseButton" style="width:70px;" onclick="corpseDeposite(this);" /><br />
                            <input type="button" id="btnReleased" value="Release" class="ItDoseButton"style="width:70px;margin-top:5px;margin-bottom:2px;" onclick="corpseReleased(this);" />
                          <#}#>  
                        </td>                                           
                        <td class="GridViewLabItemStyle" id="tdIPDNo"  style="width:50px;text-align:center;display:none;" ><#=objRow.Transaction_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdIPDNo1"  style="width:50px;text-align:center;" ><#=objRow.IPDNO#></td>
                        
					    <td class="GridViewLabItemStyle" id="tdMRNo"  style="width:80px;text-align:center;" ><#=objRow.Patient_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdName" style="width:80px;text-align:left; "><#=objRow.PName#></td>    
					    <td class="GridViewLabItemStyle" id="tdAgeGender" style="width:100px;text-align:center;"><#=objRow.Age#>/<#=objRow.Gender#></td>
					    <td class="GridViewLabItemStyle" id="tdDeathDate" style="width:100px;text-align:center"><#=objRow.DOD#><br /><#=objRow.DOT#></td>
                        <td class="GridViewLabItemStyle" id="tdDeath" style="width:100px;text-align:center;"><#=objRow.TypeOfDeath#></td>
                        <td class="GridViewLabItemStyle" id="tdBrought" style="width:100px;text-align:left;"><#=objRow.BroughtBy#></td> 
                        <td class="GridViewLabItemStyle" id="tdRemarks" style="width:120px;text-align:left;"><#=objRow.ReceivedRemarks#></td>
                        <td class="GridViewLabItemStyle" id="tdReceivedBy" style="width:100px;text-align:left;"><#=objRow.ReceivedBy#></td> 
					    <td class="GridViewLabItemStyle" id="tdReceivedDate" style="width:100px;text-align:left;"><#=objRow.ReceivedDate#></td>
                        <td class="GridViewLabItemStyle" id="tdCollectedBy" style="width:100px;text-align:left;"><#=objRow.CollectedBy#></td>                                                                  
                        <td class="GridViewLabItemStyle" id="tdReleasedBy" style="width:100px;text-align:left;"><#=objRow.ReleasedBy#></td>                                                               
                    </tr>             
		    <#}        
		    #> 
	    </table>    
    </script>

     <!--Popup for corpse release-->
    <asp:Button ID="btnHideRelease" runat="server" style="display:none;"></asp:Button>
    <cc1:ModalPopupExtender ID="mpRelease" BehaviorID="mpRelease" runat="server" DropShadow="true" TargetControlID="btnHideRelease" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlRelease" CancelControlID="btnReleaseCancel" OnCancelScript="cancelRelease();">
    </cc1:ModalPopupExtender>
    <%--<asp:Panel ID="pnlRelease" runat="server" style="display:none;">         
        <div style="margin: 0px;background-color: #eaf3fd;border: solid 1px Green;display: inline-block;padding: 1px 1px 1px 1px;margin: 0px 10px 3px 10px;width:700px;">
            <div class="Purchaseheader">
                <table width="690">
                    <tr>
                        <td style="text-align:left;">
                            <b>Release Corpse</b>
                        </td>
                        <td  style="text-align:right;">
                            <em ><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor:pointer" onclick="closeRelease()"/>to close</span></em>                            
                         </td>  
                     </tr>
                 </table>                
            </div>                 
            <div class="POuter_Box_Inventory" style="width:697px;text-align:center;">
                <b><span id="spnReleaseError" class="ItDoseLblError"></span></b>                     
                <table  style="border-collapse:collapse;" id="Table3">
                    <tr>
                        <td style="text-align:right;width:200px;">Patient No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnRMRNO"></span></td>
                        <td style="text-align:right;width:200px;">IPD No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnRIPDNO"></span></td>
                    </tr>                       
                    <tr>
                        <td style="text-align:right;width:200px;">Name&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnName"></span></td>
                        <td style="text-align:right;width:200px;">Death Date & Time&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:200px;"><span id="spnRDeath"></span></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                        <td style="text-align:right;width:200px;">&nbsp;</td>
                        <td style="text-align:left;width:200px;">&nbsp;</td>
                    </tr>                   
                </table>   
            </div>
            <div class="POuter_Box_Inventory" style="width:697px;">                 
                <table  style="border-collapse:collapse;width:100%;">
                    <tr>
                        <td style="text-align:right;width:25%;">Collected By&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:25%;">
                            <input type="text" id="txtRCollected" title="Enter Collected By" onkeypress="return check(this,event)" maxlength="50"/>
                            <span class="ItDoseLblError">*</span>
                        </td>
                        <td style="text-align:right;width:25%;">Contact No&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:25%;">
                            <input type="text" id="txtRContactNo" title="Enter Contact No" maxlength="15"/>
                            <span class="ItDoseLblError">*</span>
                        </td>
                    </tr>     
                     <tr>
                        <td style="text-align:right;width:25%;">Address&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:25%;" colspan="2">
                            <input type="text" id="txtRAddress" title="Enter Address" style="width:200px" onkeypress="return check(this,event)" maxlength="100"/>
                            <span class="ItDoseLblError">*</span>
                        </td>                        
                        <td style="text-align:left;width:25%;">&nbsp;</td>
                    </tr>                                              
                    <tr>
                        <td style="text-align:right;width:25%;">Release Remarks&nbsp;:&nbsp;</td>
                        <td style="text-align:left;width:75%;" colspan="3">
                            <textarea id="txtRemarks" style="width:300px;height:50px;resize:none;" onkeypress="return check(this,event)" maxlength="200"></textarea>         
                        </td>                        
                    </tr>                              
                    <tr>
                        <td style="text-align:right">&nbsp;</td>
                        <td style="text-align:left">&nbsp;</td>                        
                    </tr>
                </table> 
                </div>  
            <div class="POuter_Box_Inventory" style="text-align:center;width:697px;">
                <input type="button" id="btnRelease" value="Release" onclick="saveReleasedDetailDirect();" class="ItDoseButton"/>
                <asp:Button ID="btnReleaseCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" ToolTip="Click To Cancel" />
            </div>         
        </div>        
    </asp:Panel>--%>

    <div id="ModalPopupExtender2"  class="modal">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 600px;height: 306px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="ModalPopupExtender2" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Release Corpse</h4>
				</div>
				<div class="modal-body">
					 	<div class="row" ">
                                         <div class="col-md-5" >
                                             <b class="pull-left">Patient No </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-6"> 
                    <span id="spnRMRNO"></span>
                    </div> 
                                   <div class="col-md-5" >
                                             <b class="pull-left">IPD No </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                    <span id="spnRIPDNO" style="display:none;"></span>
                        <span id="spnRIPDNO1"></span>
                    </div> 
				</div>
                    					 	<div class="row" ">
                                         <div class="col-md-5" >
                                             <b class="pull-left">Name </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-6"> 
                    <span id="spnName"></span>
                    </div>  
				</div>



                    	 	<div class="row" ">
                                       
                                       <div class="col-md-8" >
                                             <b class="pull-left">Death Date & Time </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                    <span id="spnRDeath"></span>
                    </div> 
				</div>
                    	 	<div class="row" ">
                                         <div class="col-md-8" >
                                             <b class="pull-left">Collected By </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-6"> 
                    <input type="text" id="txtRCollected" title="Enter Collected By" onkeypress="return check(this,event)" maxlength="200" style="width:300px" class="required"/>
                    </div>           
				</div>
                    <div class="row">
                         <div class="col-md-8" >
                                             <b class="pull-left">Contact No </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-6"> 
                          <input type="text" id="txtRContactNo" title="Enter Contact No" maxlength="200" style="width:300px" class="required"/>
                    </div>  
                    </div>
                    	<div class="row" ">
                                         <div class="col-md-8" >
                                             <b class="pull-left">Address </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                    <input type="text" id="txtRAddress" title="Enter Address" style="width:300px" onkeypress="return check(this,event)" maxlength="200" class="required"/>
                    </div>   
                             
				</div>
                    	<div class="row" ">
                                         <div class="col-md-8" >
                                             <b class="pull-left">Release Remarks </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                      <textarea id="txtRemarks" style="width:300px;height:50px;resize:none;" onkeypress="return check(this,event)" maxlength="200"></textarea> 
                    </div>   
                             
				</div>
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                             <input type="button" id="btnRelease" value="Release" onclick="saveReleasedDetailDirect();" class="ItDoseButton"/> 
						 <%--<button type="button"  data-dismiss="ModalPopupExtender2" aria-hidden="true" >Close</button>--%>
				</div>
			</div>
		</div>
	</div>
    <!--Popup for corpse release-->

</asp:Content>

