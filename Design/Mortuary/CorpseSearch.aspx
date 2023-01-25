<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CorpseSearch.aspx.cs" Inherits="Design_Mortuary_CorpseSearch" %>

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
                $.ajax({
                    url: "Services/Mortuary.asmx/SearchCorpse",
                    data: '{CorpseNo:"' + $.trim($("#txtCorpseID").val()) + '",DepositeNo:"' + $.trim($("#txtDepositeNo").val()) + '",FirstName:"' + $.trim($("#txtFirstName").val()) + '",LastName:"' + $.trim($("#txtLastName").val()) + '",FromDate:"' + $.trim($("#txtFromDate").val()) + '",ToDate:"' + $.trim($("#txtToDate").val()) + '",Status:"' + $("#rblStatus input[type='radio']:checked").val() + '"}',
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

        function View(img) {
            rowID = $(img).closest("tr");
            $("#spnCorpseID").text(rowID.find("#tdCorpseID").text());
            $("#spnDepositeID").text(rowID.find("#tdDepositeNo").text());
            $("#spnName").text(rowID.find("#tdName").text());
            $("#spnAgeGender").text(rowID.find("#tdAgeGender").text());

            $.ajax({
                url: "Services/Mortuary.asmx/PostmortemProcess",
                data: '{DepositeNo:"' + $("#spnDepositeID").text() + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d != "0") {
                        Postmortem = $.parseJSON(result.d);
                        var HtmlOutput = $("#scrtPostmortem").parseTemplate(Postmortem);
                        $("#divPostmortem").html(HtmlOutput);
                        $("#divPostmortem").show();
                        $find("mpPostmortem").show();
                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function PostMortemProcess() {
            $("#spnError").text("");
            if ($("#divPostmortem input[type='checkbox']:checked").not(":disabled").length == 0) {
                $("#spnError").text("Please Select Checkbox");
                return;
            }

            if ($("#divPostmortem input[id='chkSendBefore']:checked").length > 0) {
                if ($.trim($("#txtReceived").val()) == "") {
                    $("#txtReceived").focus();
                    $("#spnError").text("Please Enter Name of Received By");
                    return;
                }

                $.ajax({
                    url: "Services/Mortuary.asmx/SendPostmortemProcess",
                    data: '{DepositeNo:"' + $("#spnDepositeID").text() + '",ReceivedBy:"' + $.trim($("#txtReceived").val()) + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != null && result.d == "1") {
                            DisplayMsg("MM01", "lblErrorMsg");
                            $(rowID).css("background-color", "#F48FB1");
                            ClosePopUp();
                        }
                        else {
                            DisplayMsg("MM05", "lblErrorMsg");
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                });


            }

            if ($("#divPostmortem input[id='chkReceivedBefore']:checked").length > 0) {

                $.ajax({
                    url: "Services/Mortuary.asmx/ReceivePostmortemProcess",
                    data: '{DepositeNo:"' + $("#spnDepositeID").text() + '"}',
                    type: "Post",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d != null && result.d == "1") {
                            DisplayMsg("MM01", "lblErrorMsg");
                            $(rowID).css("background-color", "#4DB6AC");
                            ClosePopUp();

                        }
                        else {
                            DisplayMsg("MM05", "lblErrorMsg");
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg("MM05", "lblErrorMsg");
                    }
                });
            }
        }

        function MortuarySticker(img) {

            var CorpseID = $(img).closest("tr").find("#tdCorpseID").text();

            $.ajax({
                url: "Services/Mortuary.asmx/mortuarySticker",
                data: '{CorpseID:"' + CorpseID + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != null && result.d == "1") {
                        window.open('../common/Commonreport.aspx');
                    }
                },
                error: function (xhr, status) {

                }
            });

        }

        function MortuaryInforMation(img) {
            var DepositeNo = $(img).closest("tr").find("#tdDepositeNo").text();
            $.ajax({
                url: "Services/Mortuary.asmx/MortuaryInforMation",
                data: '{DepositeNo:"' + DepositeNo + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d != "0") {
                        window.open('../common/Commonreport.aspx');
                    }
                    else {
                        DisplayMsg('MM05', 'spnErrorMsg');
                    }
                },
                error: function (xhr, status) {
                }
            });
        }


        function ClosePopUp() {
            $("#spnError").text("");
            $("#txtReceiver").val("");
            $find("mpPostmortem").hide();
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
                if ($find("mpPostmortem")) {
                    ClosePopUp()
                }
            }
        }
    </script>
    <script type="text/javascript">
        function ReseizeIframe(Transaction_ID) {
            var con = 0;
            if (con == "0") {
                document.getElementById("iframeCorpse").style.width = "100%";
                document.getElementById("iframeCorpse").style.height = "100%";
                document.getElementById("iframeCorpse").style.display = "";
            }
        }
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
            <b><span id="lblHeader" style="font-weight: bold;">Search Corpse</span></b><br />
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
                    <div class="col-md-4">
                            <label class="pull-left">
                                Corpse ID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtCorpseID" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter Corpse ID" Width="" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Deposite No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDepositeNo" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter IPD No." AutoCompleteType="None" Width="" />
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFirstName" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter Name" AutoCompleteType="None" Width="" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Last Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtLastName" runat="server" ClientIDMode="Static" MaxLength="20" title="Enter Name" AutoCompleteType="None" Width="" />
                        </div>
                       
                    </div>
                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                From Deposite Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static" title="Click to Select From Date" Width="" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="calFromdate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                To Deposite Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static" title="Select To Date" Width="" onchange="ChkDate();"/>
                            <cc1:CalendarExtender ID="calTodate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblStatus" runat="server" RepeatDirection="Horizontal" align="center" ClientIDMode="Static">
                                <asp:ListItem value="0" Selected="True" Text="Admitted" />
                                <asp:ListItem value="1" Text="Released" />
                            </asp:RadioButtonList>  
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" id="btnSearch" value="Search" class="ItDoseButton" />
        </div>
        <div class="POuter_Box_Inventory">
            <div style="">
                <table style="margin: 0 Auto; width: 70%;">
                    <tr>
                        <td style="width: 146px;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td  class="circle" style="width:35px;height:25px;  background-color: #FFF59D;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td  style="text-align: left">Postmortem Request</td>
                        <td class="circle" style="width:35px;height:25px;  background-color: #F48FB1;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Send For Postmortem</td>
                        <td class="circle" style="width:35px;height:25px;  background-color: #4DB6AC;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left">Postmortem Completed</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; max-height: 430px; overflow: auto;">
            <div id="divSearchedResult" style="width:100%;">
            </div>
        </div>
    </div>
    <iframe id="iframeCorpse" name="iframeCorpse" src="" style="position: fixed; top: 0px; left: 0px; background-color: #FFFFFF; display: none;"
        frameborder="0" enableviewstate="true"></iframe>

    <script type="text/html" id="SearchResult">
        <table cellspacing="0" rules="all" border="1" style="border-collapse:collapse;">
		    <tr>            
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Labels</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Info</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Select</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Postmortem</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:50px;">UHID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Deposite Date Time</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:200px;">CorpseID</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">DepositeNo</th>               	
			    <th class="GridViewHeaderStyle" scope="col" style="width:130px;">Name</th>		          	
			    <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Death Date<br />Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Rack/Shelf</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none;">Death Type</th>
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Infectious Remark</th>	
			    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Admitted By</th>                                    	
		    </tr>
		    <#       
		    var dataLength=CorpseResult.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;               
		    for(var j=0;j<dataLength;j++)
		    {       

                var strStyle="";
		        objRow = CorpseResult[j];

                if(objRow.IsPMRequest=="1"){
                    strStyle="background-color: #FFF59D;";
                    if(objRow.IsSend=="1")
                    {
                        strStyle="background-color: #F48FB1;";
                    }
                    if(objRow.IsPostmortem=="1")
                    {
                        strStyle="background-color: #4DB6AC;";
                    }
                    
                }

                
		    #>
				    <tr style="<#=strStyle#>">            
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;">
                            <img id="imgLabel" src="../../Images/view.GIF" style="cursor:pointer;" title="Click To View" onclick="MortuarySticker(this);"/>
                        </td>
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;">
                            <img id="imgInformation" src="../../Images/view.GIF" style="cursor:pointer;" title="Click To View" onclick="MortuaryInforMation(this);"/>
                        </td>
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;">
                            <a href="MortuaryBilling.aspx?CorpseID=<#=objRow.Corpse_ID#>&TransactionID=<#=objRow.TransactionID#>" target="iframeCorpse" style="border: 0px solid #FFFFFF;" onclick="ReseizeIframe(<#=objRow.Transaction_ID#>);">
                            <img alt="Select" src="../../Images/Post.gif" style="cursor:pointer;" title="Click To View"/>
                           </a>
                        </td>                        
                        <td class="GridViewLabItemStyle" style="width:50px;text-align:center;">
                            <#
                                if(objRow.IsPMRequest=="1"){
                            #>
                            <img id="imgView" src="../../Images/view.GIF" style="cursor:pointer;" title="Click To View" onclick="View(this);"/>
                            <#
                            }
                            #>
                        </td>                        
                        <td class="GridViewLabItemStyle" id="tdDateTime"  style="width:200px;text-align:center;" ><#=objRow.PatientID#></td>
                        <td class="GridViewLabItemStyle" id="td3"  style="width:200px;text-align:center;" ><#=objRow.DepositeDateTime#></td>
					    <td class="GridViewLabItemStyle" id="tdCorpseID"  style="width:200px;text-align:center;" ><#=objRow.Corpse_ID#></td>
                        <td class="GridViewLabItemStyle" id="tdDepositeNo" style="width:80px;text-align:center; "><#=objRow.Transaction_ID#></td>    
					    <td class="GridViewLabItemStyle" id="tdName" style="width:130px;text-align:left; "><#=objRow.CName#></td>
					    <td class="GridViewLabItemStyle" id="tdAgeGender" style="width:100px;text-align:center;"><#=objRow.Age#>/<#=objRow.Gender#></td>
					    <td class="GridViewLabItemStyle" id="tdDeathDate" style="width:200px;text-align:center"><#=objRow.DateofDeath#>&nbsp; <#=objRow.TimeofDeath#></td>
                        <td class="GridViewLabItemStyle" id="td1" style="width:120px;text-align:center;"><#=objRow.FreezerName#></td>
					    <td class="GridViewLabItemStyle" id="tdDeathType" style="width:120px;text-align:left;display:none;"><#=objRow.DeathType#></td>
					    <td class="GridViewLabItemStyle" id="td2" style="width:120px;text-align:left;"><#=objRow.InfectiousRemark#></td>
					    <td class="GridViewLabItemStyle" id="tdAdmittedBy" style="width:120px;text-align:left;"><#=objRow.AdmittedBy#></td>                                                                  
                    </tr>             
                
		    <#}        
		    #> 
	    </table>    
    </script>

    <asp:Panel ID="pnlPostmortem" runat="server" style="display:none;">
        <div style="margin: 0px; background-color: #eaf3fd; border: solid 1px Green; display: inline-block; padding: 1px 1px 1px 1px; margin: 0px 10px 3px 10px; width: 800px;">
            <div class="Purchaseheader">
                <table width="790">
                    <tr>
                        <td style="text-align: left;">
                            <b>Post-Mortem Process</b>
                        </td>
                        <td style="text-align: right;">
                            <em><span style="font-size: 7.5pt">Press esc or click<img src="../../Images/Delete.gif" style="cursor: pointer" onclick="ClosePopUp()" />to close</span></em>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 797px;">
                <span id="spnError" class="ItDoseLblError"></span>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 20%; text-align: right;">Corpse ID&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnCorpseID" class="ItDoseLabelSp"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Deposite No&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnDepositeID" class="ItDoseLabelSp"></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Name&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnName" class="ItDoseLabelSp"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Age/Gender&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnAgeGender" class="ItDoseLabelSp"></span>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 20%; text-align: right;">Doctor&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnDoctor" class="ItDoseLabelSp"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Location&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnLocation" class="ItDoseLabelSp"></span>
                        </td>
                    </tr>
                    <%--<tr>
                        <td style="width: 20%; text-align: right;">Approved By&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnApprovedBy" class="ItDoseLabelSp"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Approved Date&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnApprovedDate" class="ItDoseLabelSp"></span>
                        </td>
                    </tr>--%>
                    <tr>
                        <td style="width: 20%; text-align: right;">Postmortem Date&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnPostDate" class="ItDoseLabelSp"></span>
                        </td>
                        <td style="width: 20%; text-align: right;">Postmortem Time&nbsp:&nbsp</td>
                        <td style="width: 20%; text-align: left;">
                            <span id="spnPostTime" class="ItDoseLabelSp"></span>
                        </td>
                    </tr>
                </table>
                <div class="POuter_Box_Inventory" style="text-align: center; width: 797px;">
                    <div id="divPostmortem">
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center; width: 797px;">
                <input type="button" id="btnProcess" value="Process" onclick="PostMortemProcess();" class="ItDoseButton" />
            </div>
        </div>
    </asp:Panel>
    <asp:Button ID="btnHide" runat="server" style="display:none;"/>
    <cc1:modalpopupextender ID="mpPostmortem" BehaviorID="mpPostmortem" runat="server" DropShadow="true" TargetControlID="btnHide" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlPostmortem" RepositionMode="RepositionOnWindowResize">
    </cc1:modalpopupextender>

    <script type="text/html" id="scrtPostmortem">
        <table cellspacing="0" rules="all" border="1" style="border-collapse: collapse;">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">Select</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;"></th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Date Time</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">By</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Received By</th>
            </tr>
            <#       
		    var dataLength=Postmortem.length;
		    window.status="Total Records Found :"+ dataLength;
		    var objRow;
            var strStyle="";   
		    for(var j=0;j<dataLength;j++)
		    {       
		        objRow = Postmortem[j];
                $("#spnDoctor").text(objRow.DoctorName);
                $("#spnLocation").text(objRow.Location);
                $("#spnPostDate").text(objRow.PostmortemDate);
                $("#spnPostTime").text(objRow.PostmortemTime);
                $("#spnApprovedBy").text(objRow.ApprovedBy);
                $("#spnApprovedDate").text(objRow.ApprovedDate);
                
                        strStyle="background-color: #FFF59D;";                    
                        if(objRow.IsApproved=="1" && objRow.IsSend=="0")
                        {
                            #>
                                <tr style="<#=strStyle#>">
                                    <td class="GridViewLabItemStyle" style="width: 50px; text-align: center;">
                                        <input type="checkbox" id="chkSendBefore" />
                                    </td>
                                    <td class="GridViewLabItemStyle" style="width: 100px; text-align: center;">Send For Post-Mortem</td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;">&nbsp;</td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;">&nbsp;</td>
                                    <td class="GridViewLabItemStyle" style="width: 200px; text-align: center;">
                                        <input type="text" id="txtReceived" maxlength="50" onkeypress="return check(this,event)"/>
                                        <span class="ItDoseLblError">*</span>
                                    </td>
                                </tr>
                            <#
                        }
                        if(objRow.IsApproved=="1" && objRow.IsSend=="1")
                        {
                            strStyle="background-color: #F48FB1;";
                            #>                                
                                <tr style="<#=strStyle#>">
                                    <td class="GridViewLabItemStyle" style="width: 50px; text-align: center;">
                                        <input type="checkbox" id="chkSendAfter" checked="checked" disabled="disabled" />
                                    </td>
                                    <td class="GridViewLabItemStyle" style="width: 100px; text-align: center;">Send For Post-Mortem</td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;"><#=objRow.SendDate#></td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;"><#=objRow.SendBy#></td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;"><#=objRow.ReceivedBy#></td>
                                </tr>
                            <#
                        }
                        if(objRow.IsApproved=="1" && objRow.IsSend=="1" && objRow.IsPostmortem=="0")
                        {
                            strStyle="background-color: #F48FB1;";
                            #>                                
                                <tr style="<#=strStyle#>">
                                    <td class="GridViewLabItemStyle" style="width: 50px; text-align: center;">
                                        <input type="checkbox" id="chkReceivedBefore" />
                                    </td>
                                    <td class="GridViewLabItemStyle" style="width: 100px; text-align: center;">Received After Post-Mortem</td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;">&nbsp;</td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;">&nbsp;</td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;">&nbsp;</td>
                                </tr>
                            <#
                        }
                        if(objRow.IsApproved=="1" && objRow.IsSend=="1" && objRow.IsPostmortem=="1")
                        {
                            strStyle="background-color: #4DB6AC;";
                            $("#btnProcess").hide();
                            #>
                                
                                <tr style="<#=strStyle#>">
                                    <td class="GridViewLabItemStyle" style="width: 50px; text-align: center;">
                                        <input type="checkbox" id="chkAfterReceived" checked="checked" disabled="disabled" />
                                    </td>
                                    <td class="GridViewLabItemStyle" style="width: 100px; text-align: center;">Received After Post-Mortem</td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;"><#=objRow.ReceivedDateAfterPost#></td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;"><#=objRow.ReceivedByAfterPost#></td>
                                    <td class="GridViewLabItemStyle" style="width: 150px; text-align: center;">&nbsp;</td>
                                </tr>
                            <#
                                           
                }
            }             
		         
		    #> 
            <tr>
                <td colspan="11">&nbsp;</td>
            </tr>
        </table>
    </script>
</asp:Content>

